# gitcode_services — 自包含执行与部署包

GitCode Actions 基础能力自动化测试的**统一执行入口**：用例集、执行引擎、依赖清单、
容器定义、CI 流水线都在这里。**不依赖上级目录名，也不依赖上游仓存在**。

```
gitcode_services/
├── cases/yaml/          249 条用例（本包自有，非上游派生）
├── phase02/scripts/     执行引擎 = 上游 11 个 .py 的派生副本 + 本包独有 9 个:
│                          schema_check_ext.py  按 test_type 分流出 4 条队列
│                          api_runner.py        api 类执行器
│                          api_assertions.py    api 类断言判定
│                          run_api_batch.py     api 类批量编排
│                          ui_runner.py         ui 类执行器 + 判定（Playwright）
│                          run_ui_batch.py      ui 类批量编排
│                          git_runner.py        git 类执行器 + 判定
│                          run_git_batch.py     git 类批量编排
│                          junit_export.py      results → JUnit XML
├── requirements.txt     Python 依赖
├── Dockerfile           多阶段构建（含 Playwright Chromium），context = 本目录
├── docker-compose.yml   一条命令跑全量
├── run_daily.sh         每日调度入口（回归对比 + 门禁退出码）
├── sync-cases.sh        从上游同步用例 + 引擎 / 检查漂移
├── config.yaml.example  配置模板（凭证 + 调参，分节 YAML）
├── Jenkinsfile          Jenkins 流水线
└── JENKINS-SETUP.md     Jenkins 配置手册
```

## 路径模型

本脚本所在目录即「包根」，也是引擎的 `ROOT`：

- `run_daily.sh` 用 `BASH_SOURCE` 推导包根，与目录叫什么无关
- `phase02/scripts/*.py` 用 `__file__` 推导 `ROOT`/`PHASE02`，与 CWD 无关
- 两者天然一致 → 整个包可以改名、移动、单独打包分发

产物固定落在包根下：`phase02/runs/<run-id>/`、`phase02/reports/<run-id>/`（已 gitignore）。

## 三种执行方式

### 1. Docker Compose（推荐，环境零配置）

```bash
cd gitcode_services
cp config.yaml.example config.yaml   # 首次：填 gitcode.access_token / gitcode.cookie
docker compose build
docker compose run --rm harness                    # 全量 249 条
docker compose run --rm harness cases/yaml nightly # 指定用例集与 run 前缀
```

### 2. Docker（不用 compose）

```bash
cd gitcode_services
docker build -t gitcode-test-harness:latest .
docker run --rm --shm-size=1gb \
  -v "$(pwd)/config.yaml:/app/config.yaml:ro" \
  -v "$(pwd)/phase02/runs:/app/phase02/runs" \
  -v "$(pwd)/phase02/reports:/app/phase02/reports" \
  gitcode-test-harness:latest
```

`--shm-size=1gb` 不能省：UI 用例跑 Chromium，共享内存不足会导致浏览器崩溃。

### 3. 本地 Python

```bash
cd gitcode_services
pip install -r requirements.txt
playwright install --with-deps chromium
cp config.yaml.example config.yaml && vi config.yaml
./run_daily.sh                        # 默认 cases/yaml 全量
./run_daily.sh cases/yaml nightly
```

### 4. Jenkins

Job → Pipeline script from SCM → **Script Path = `gitcode_services/Jenkinsfile`**。
凭证与 agent 前置条件见 [JENKINS-SETUP.md](JENKINS-SETUP.md)。

## 配置：config.yaml

全部凭证与调参集中在包根的 `config.yaml`（从 `config.yaml.example` 复制）。
分节 YAML，由 `phase02/scripts/config_loader.py` 解析后注入 `os.environ`。

**优先级：真实环境变量 > config.yaml**。因此 CI 里 `API_ALLOW_WRITE=0 ./run_daily.sh`
或 `docker run -e UI_HEADLESS=0` 始终能覆盖文件里的值。

节名 + 键名 → 环境变量名的映射：

| config.yaml | 环境变量 |
|---|---|
| `gitcode.access_token` / `gitcode.cookie` / `gitcode.owner` … | `GITCODE_ACCESS_TOKEN` / `GITCODE_COOKIE` / `GITCODE_OWNER` … |
| `phase02.case_timeout` / `phase02.poll_interval` | `PHASE02_CASE_TIMEOUT` / `PHASE02_POLL_INTERVAL` |
| `api.case_timeout` / `api.allow_write` / `api.allow_unsafe_write` … | `API_CASE_TIMEOUT` / `API_ALLOW_WRITE` / `API_ALLOW_UNSAFE_WRITE` … |
| `ui.headless` / `ui.nav_timeout` … | `UI_HEADLESS` / `UI_NAV_TIMEOUT` … |
| `git.allow_push` / `git.case_timeout` | `GIT_ALLOW_PUSH` / `GIT_CASE_TIMEOUT` |
| `auth.pat_token` | `PAT_TOKEN` |
| `gate.min_execution_coverage` | `MIN_EXECUTION_COVERAGE` |
| `runtime.tz` / `runtime.login_timeout` | `TZ` / `LOGIN_TIMEOUT` |
| `email.*` | **不注入环境变量** |

布尔值 `true`/`false` 注入为 `"1"`/`"0"`，与既有 `!= "0"` 判断兼容。
`email` 节刻意不进环境变量：`git_runner.py` 会把整份 `os.environ` 传给 git 子进程，
SMTP 授权码不应随之外泄，由 `email_sender.py` 结构化读取。

用 `CONFIG_FILE=/path/to/other.yaml` 可指定非默认位置的配置文件。

## 退出码 = 门禁结论

| 码 | 结论 | Jenkins |
|----|------|---------|
| 0 | GO（可上线） | SUCCESS |
| 1 | BLOCKED（有 P0 失败或维度未达阈值） | FAILURE |
| 2 | INCONCLUSIVE（执行覆盖率 < `MIN_EXECUTION_COVERAGE`，默认 60%） | FAILURE |

> 上游 `report_builder.py` 其实**没有实现门禁退出码**：它只在「用法错误」(2) 与
> 「无结果」(1) 时非零退出，GO/BLOCKED/INCONCLUSIVE 一律返回 0——Jenkins 会永远是绿的。
> 本包不改上游文件（会被 sync 覆盖），改为在 `run_daily.sh` 里解析它确定性打印的
> `门禁: <GO|BLOCKED|INCONCLUSIVE>` 一行来映射退出码。解析失败按 INCONCLUSIVE(2) 处理。

## 产物位置

- `phase02/reports/<run-id>/report.md` — 人读报告
- `phase02/runs/<run-id>/summary.json` — 机读汇总
- `phase02/runs/<run-id>/junit.xml` — Jenkins 测试趋势图
- `phase02/runs/<run-id>/results/` — 单条用例明细
- `phase02/reports/latest.txt` — 上次 run-id，下次自动 `--compare` 回归对比

## 与上游仓的关系

只有**引擎**是上游 `gitcode-action-foundational-tests/phase02/scripts` 的派生副本。
用例是本包自有——实测与上游 `phase01/runs/*` 各 run 的文件名交集仅 15/249、内容一致 0 条。
所以同步默认只覆盖引擎：

```bash
./sync-cases.sh --from /path/to/gitcode-action-foundational-tests   # 只同步引擎
./sync-cases.sh --check                                            # 只检查引擎漂移（CI 用）
```

上游路径解析顺序：`--from` > `$GITCODE_UPSTREAM` > `../../gitcode-action-foundational-tests`。
`junit_export.py` 是本包独有（上游没有），同步时保留、不参与漂移比对。
覆盖用例需显式 `--with-cases --run-id <id> --yes`，会销毁本包自有用例，一般不要用。

## 执行覆盖：249 / 249 入队

`schema_check_ext.py` 按 `test_type` 分流成 4 条队列，各由对应执行器消费：

| 用例类型 | 条数 | 队列 | 执行器 |
|---|---|---|---|
| workflow（有 `trigger`） | 83 | `queue.json` | 上游 `run_batch.py` |
| api（`api:` 块） | 86 | `queue_api.json` | 本包 `run_api_batch.py` |
| ui（`ui:` 块） | 75 | `queue_ui.json` | 本包 `run_ui_batch.py` |
| git（`git:` 块） | 5 | `queue_git.json` | 本包 `run_git_batch.py` |

schema 不合规的用例仍写入 `phase02/runs/<run-id>/rejected.json`（当前 0 条）。

「入队」不等于「能判出 PASS/FAIL」：安全门禁、缺凭证、夹具未预置都会让用例落到
INCONCLUSIVE / ENV_ERROR，如实压低门禁的有效覆盖率。各类的实际情况见下。

### api 执行器的安全门禁

86 条 api 用例里 77 条是写操作，且契约**没有 `body` 字段**——它们本质是端点可用性
探测（`expected_status` 普遍含 4xx）。两道防线：

1. **占位符探测值**：`endpoint` 中除 `{owner}`/`{repo}` 外的占位符（`{number}`、
   `{id}`、`{sha}` 等）一律替换为刻意不存在的值，使这 44 条写请求命中 404。
2. **真实资源写请求默认跳过**：另有 32 条写请求路径完全由真实夹具构成，含不可逆
   操作——`POST /pulls/1/merge`、`POST /pulls/2/merge`（合并真实 PR）、
   `POST /transfer`（转移仓库归属）、`POST /forks`、`PUT /repo_settings`、
   `PUT /branches/main/setting`。无 body 时多数会被 400/422 挡回，但 merge 这类
   仅凭路径即可生效的会**真的执行**。故默认记 INCONCLUSIVE 不发送。

```bash
# 默认：86 条中 54 条真实发出，32 条跳过
./run_daily.sh
# 确认目标是专用测试仓后，跑满 86 条
API_ALLOW_UNSAFE_WRITE=1 ./run_daily.sh
# 先看清将要发出的请求，不发网络请求
py phase02/scripts/run_api_batch.py <run-id> --dry-run
```

另有 `API_ALLOW_WRITE=0` 整体跳过所有写方法，`API_REQUEST_DELAY`（默认 0.3s）控制间隔。

执行器会先用 `GET /api/v5/user` 预检 token：若 token 失效，所有请求得 401，而探测类
用例的 `expected_status` 恰好含 401 —— 会「全绿」掩盖配置错误。预检失败时 86 条如实
记 ENV_ERROR。

### api 判定口径

- `PASS`：全部断言通过
- `FAIL`：有断言不通过（含 5xx、`must_not_contain` 命中）
- `INCONCLUSIVE`：被安全门禁跳过 / 谓词未实现 / 需限流态才成立的用例
  （`API-RATE-01-001` 期望 429，单发请求无法触发，判不可测试而非缺陷）
- `ENV_ERROR`：token 不可用、夹具未定义（如 `repo_fixture: empty-repo` 无 owner/repo）
- `TIMEOUT`：请求超时

### ui 执行器（75 条）

Playwright Chromium。判定与驱动分离：`ui_runner.execute()` 把每条断言所需的页面
事实抽成 probes（纯 dict），`evaluate()` 只吃 probes，因此判定逻辑可无浏览器单测。

实现了用例集用到的全部 6 个动词（`wait_for_selector` / `wait` / `click` / `type` /
`navigate` / `screenshot`）与 4 个断言 target（`ui_element_visible` /
`ui_text_contains` / `ui_page_title` / `ui_url_match`）。selector 直接透传给
Playwright，所以 `:visible`、`:has-text()`、逗号回退都按其 CSS 方言生效。

一个浏览器实例复用给 75 条，每条一个 context（cookie/viewport 隔离）。
`screenshot` 动作落到 `phase02/runs/<run-id>/screenshots/`。

**action 失败会把 PASS 降级为 INCONCLUSIVE**：用例集里有 90 处 selector 就是 `body`，
交互没走完时断言仍可能通过——那是空转，不足以采信。

```bash
UI_HEADLESS=0 ./run_daily.sh        # 有头模式调试
UI_NAV_TIMEOUT=30000                 # 导航超时（默认 30s）
UI_ACTION_TIMEOUT=15000              # 单个 action 超时（默认 15s）
UI_SETTLE_TIMEOUT=10000              # SPA 渲染静默等待（默认 10s）
```

GitCode 是 SPA：`domcontentloaded` 时 `body` 已存在但内容未渲染，而用例集里大量
`wait_for_selector: body` 是无效的就绪信号。执行器在导航后额外等 `networkidle`
（超时不致命，仅打 `settle_timeout` flag），否则同一条用例会在 PASS / FAIL 之间漂移。

75 条的 `repo_fixture` 全为 null，owner/repo 取 `GITCODE_OWNER`/`GITCODE_REPO`。
无 `GITCODE_COOKIE` 时公开页仍可跑（结果带 `no_login` flag），私有页会如实判失败。

**获取 Cookie（供 `GITCODE_COOKIE`）**：

```bash
# 方式 1：自动登录（推荐，从 config.yaml 读账密）
# 1. 编辑 config.yaml，填写 gitcode.username 和 gitcode.password
# 2. 运行脚本，成功后自动回写 config.yaml 的 gitcode.cookie
python phase02/scripts/login_helper.py

# 方式 2：命令行传参
python phase02/scripts/login_helper.py <username> <password>
# 输出 Cookie 串，手动复制到 config.yaml 的 gitcode.cookie

# 方式 3：手动（浏览器已登录）
# 开发者工具 → Application/Storage → Cookies → gitcode.com → 复制关键 cookie
```

**注意**：login_helper 触发验证码或登录保护时会失败，此时改用方式 3 手动提取。

### git 执行器（5 条）

支持 `clone` / `push`，断言 `git_exit_code`（极性由 `type: negative` 决定）、
`git_output`（contains / must_not_contain）、`latency`（le 秒）。

四点稳态设计：

1. **push 默认跳过**——写真实仓，`GIT_ALLOW_PUSH=1` 开启（2 条用例）。
2. **`local_path` 未预置时判 ENV_ERROR**——否则 git 报 `not a git repository`，
   会让「期望 push 被拒」的用例假失败。
3. **`GIT_TERMINAL_PROMPT=0` + ssh `BatchMode=yes`**——凭证缺失时快速失败不挂起。
4. **`${SECRET}` 展开值落盘前替换为 `***`**——不把 token 写进 `results/`。

**前置条件缺失判 ENV_ERROR 而非 FAIL**：SSH 无密钥、夹具仓不存在、git-lfs 未装、
网络不可达都有特征识别，避免进报告的「问题发现」变成假缺陷。但「本就在验操作应当
失败」的用例例外（如 `API-USER-01-005` 期望 push 被拒），其非零退出是被测行为本身。

当前 5 条的实跑结果：2 条 push 被门禁挡下（INCONCLUSIVE）、`GIT-CLONE-01-002`
缺 `PAT_TOKEN`（ENV_ERROR）、`GIT-CLONE-01-003` 需 SSH 密钥（ENV_ERROR）、
`REL-GIT-01-001` 的夹具仓 `large-org/large-repo` 不存在（ENV_ERROR）。
即这 5 条要真正判出结果，需先备好 PAT、SSH 密钥、可推送的本地仓与大仓夹具。

## 依赖与已知限制

`requirements.txt`：`requests`、`PyYAML`、`playwright`。Playwright 装完还需
`playwright install chromium`（Docker 镜像已内置）。

- 75 条 ui 用例需要 Chromium（`playwright install chromium`）；未安装时这些用例
  记 ENV_ERROR，会把有效覆盖率压低。
- `run_daily.sh` 不调用 `compile_asserts.py`。缺少 `runs/<id>/compiled/` 时
  断言绑定优雅退化（`run_case.load_execution_inputs`），不影响执行。
- api 断言的 `json_path` 是极简实现，支持 `$`、`$.a.b`、`$[0].a`（覆盖用例集全部
  13 处用法），不支持过滤表达式等完整 JSONPath 语法；遇到不支持的谓词记
  INCONCLUSIVE 而非静默通过。

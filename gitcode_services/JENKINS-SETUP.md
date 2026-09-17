# Jenkins 每日调度配置指南

> 配合 `Jenkinsfile` 实现 GitCode Actions 测试用例每日自动执行、门禁判定、报告归档与回归对比。

---

## 一、前置条件（在 Jenkins Linux Agent 上）

### 1.1 软件依赖

```bash
# Python 3.7+
python3 --version

# Git 2.x
git --version

# Playwright（75 条 UI 用例需要）
pip3 install playwright
playwright install chromium  # 安装 headless 浏览器
```

依赖也可直接按清单装：

```bash
pip3 install -r requirements.txt
playwright install chromium
```

**重要**：249 条已全部入队（83 workflow + 86 api + 75 ui + 5 git）。ui 用例需要
Chromium，未装时这 75 条记 ENV_ERROR 并压低有效覆盖率。

**写操作门禁**（默认全部跳过并记 INCONCLUSIVE，要跑满需在 Job 里显式开启，
且确认目标仓是专用测试仓）：

| 变量 | 作用 |
|---|---|
| `API_ALLOW_UNSAFE_WRITE=1` | 32 条直打真实资源的 api 写请求（含合并 PR、转移仓库归属） |
| `GIT_ALLOW_PUSH=1` | 2 条 push 用例 |

git 用例另需 `PAT_TOKEN` 凭证与 agent 上的 SSH 密钥，否则相关用例记 ENV_ERROR。

### 1.2 Jenkins 凭证配置

在 Jenkins 管理界面 **Manage Jenkins → Credentials** 添加：

| ID | 类型 | 用途 | 填写内容 |
|---|---|---|---|
| `gitcode-access-token` | Secret Text | GitCode API 调用、git push | 从 https://gitcode.com/-/user_settings/personal_access_tokens 生成，勾选 `api, read_user, write_repository` |
| `gitcode-cookie` | Secret Text | Web 登录态（UI 用例预留） | 浏览器登录后复制的 Cookie 串。引擎只读 `GITCODE_COOKIE`，不支持账号密码自动续期 |

**安全提示**：
- Token 权限按最小化原则，只勾选必需 scope
- 使用测试专用账号，避免用个人账号

---

## 二、Jenkins Job 创建

### 2.1 新建 Pipeline Job

1. Jenkins 首页 → **New Item**
2. 名称：`GitCode-Actions-Daily-Regression`
3. 类型：**Pipeline**
4. 点击 **OK**

### 2.2 配置 Pipeline

**General 区域**：
- ✅ **Discard old builds**: Keep builds for 30 days
- 描述：`GitCode Actions 每日回归测试（249 条用例，含 API/Workflow/Git/UI）`

**Pipeline 区域**：
- **Definition**: Pipeline script from SCM
- **SCM**: Git
  - **Repository URL**: `https://gitcode.com/<your-org>/gitcode-action-foundational-tests.git`
  - **Credentials**: 选择 `gitcode-access-token`（或单独配置 Git 凭证）
  - **Branch**: `*/main`
- **Script Path**: `gitcode_services/Jenkinsfile`

保存即可，Jenkinsfile 里已配置 `cron('0 2 * * *')`（每日 UTC 02:00 = 北京时间 10:00）。

### 2.3 首次手动触发

点击 **Build Now**，验证：
- ✅ 凭证注入成功（日志无 `401 Unauthorized`）
- ✅ Playwright 可用（UI 用例不全是 `ENV_ERROR`）
- ✅ JUnit XML 已解析（**Test Result** 标签页出现用例趋势图）
- ✅ 报告已归档（**Build Artifacts** 可下载 `report.md`）

---

## 三、产物与报告查看

每次构建完成后：

### 3.1 Jenkins 用例趋势图

**Test Result** 标签页：
- 总览：通过率、失败分布、耗时趋势（天级/周级）
- 按维度筛选：点击 `completeness` / `security` 等 testsuite
- 失败详情：点击红色用例查看断言结果、日志快照

### 3.2 Markdown 报告（归档产物）

**Build Artifacts** → `phase02/reports/daily-<timestamp>/report.md`：
- 门禁判定（✅ GO / ⛔ BLOCKED / ⚪ INCONCLUSIVE）
- 分维度通过率（对照 `phase01/baseline/quality-gate.md` 阈值）
- 问题发现清单（FAIL 用例 + 归因待办）
- 回归 diff（与上次 run 对比的新增失败/修复）

### 3.3 JSON 汇总（自动化消费）

**Build Artifacts** → `phase02/runs/daily-<timestamp>/summary.json`：
- 结构化判定结果（每条用例的 `verdict`, `assertion_results`, `duration`）
- 可被下游 BI/监控系统自动拉取

---

## 四、门禁判定逻辑

`report_builder.py` 按以下规则返回退出码，Jenkins 据此判构建红绿：

| 退出码 | 门禁结论 | Jenkins 状态 | 含义 |
|---|---|---|---|
| **0** | **GO** | ✅ SUCCESS | 全部维度通过阈值，无 P0 失败，可上线 |
| **1** | **BLOCKED** | ❌ FAILURE | 某维度低于阈值 **或** 存在 P0 失败，**不可上线** |
| **2** | **INCONCLUSIVE** | ❌ FAILURE | 执行覆盖率不足（< 60% 有效判定），样本不足以给结论 |

**执行覆盖率**定义：`(通过 + 问题发现) / 总数 >= 0.6`
- 剔除 `NOT_CONFIGURED`（缺前置条件）、`ENV_ERROR`（环境问题）、`INCONCLUSIVE`（未发现问题）
- 低于阈值说明大量用例跑不起来，报告不可信

**分维度阈值**（默认，可在 `phase01/baseline/quality-gate.md` 自定义）：
- completeness: 95%
- compatibility: 90%
- reliability: 85%
- security: 90%
- usability: 80%

---

## 五、常见问题

### 5.1 UI 用例全是 `ENV_ERROR: No such file or directory: 'chromium'`

**原因**：Playwright 浏览器未安装。

**修复**：
```bash
# 在 Jenkins agent 上（用运行 Jenkins 的用户身份）
pip3 install playwright
playwright install chromium
```

### 5.2 Cookie 过期，UI 用例判 `ENV_ERROR: 401 Unauthorized`

**原因**：`gitcode-cookie` 凭证过期。**没有自动续期机制**——引擎只按
`GITCODE_COOKIE` 环境变量 → `.env` 文件 → `~/.gitcode-cookie` 的顺序读取
（`phase02/scripts/workflow_runner.py` 的 `_load_cookie`），过期只能手动换。

**修复**：
1. 浏览器重新登录 GitCode，复制 Cookie 串
2. Jenkins → Credentials → 更新 `gitcode-cookie`
3. 重跑构建

### 5.3 构建红了，但报告显示 GO

**检查**：
```bash
# 在构建日志搜索
grep "门禁:" <build-log>
```
- 如果显示 `门禁: GO` 但构建红，可能是后续步骤（归档、清理）失败
- 如果显示 `门禁: BLOCKED`，这是预期行为（说明用例真失败了）

### 5.4 回归对比显示"无"，但明明有上次 run

**原因**：`phase02/reports/latest.txt` 未归档，导致下次构建读不到。

**检查**：Jenkinsfile `archiveArtifacts` 是否包含 `phase02/reports/latest.txt`（当前版本已包含 `phase02/reports/daily-*/**/*`，会覆盖）。

### 5.5 想跑 smoke 9 条快速验证，不想每次跑全量 249 条

**方案 A**：新建 Jenkins Job `GitCode-Actions-Smoke`，把用例子集放到单独目录后：
```groovy
dir('gitcode_services') { sh './run_daily.sh cases/smoke smoke' }
```

**方案 B**：参数化构建（Jenkinsfile 加 `parameters` 块），让用户选用例集。

---

## 六、调度策略建议

| 场景 | cron 表达式 | 说明 |
|---|---|---|
| 每日早上 10:00（北京） | `0 2 * * *` | UTC 02:00，Jenkinsfile 默认 |
| 每周一/三/五 10:00 | `0 2 * * 1,3,5` | 减少 UI 用例 flaky 干扰 |
| 每小时（压力测试） | `0 * * * *` | 不推荐（249 条耗时长，可能排队） |
| GitCode 发版后手动触发 | 无 cron | 用 **Build with Parameters** |

---

## 七、报告订阅（可选）

Jenkins Email Extension Plugin 配置示例：

```groovy
post {
    failure {
        emailext(
            to: 'qa-team@example.com',
            subject: "⛔ GitCode 每日回归 BLOCKED - ${env.BUILD_NUMBER}",
            body: """
构建: ${env.BUILD_URL}
报告: ${env.BUILD_URL}artifact/phase02/reports/daily-*/report.md

门禁判定: BLOCKED 或 INCONCLUSIVE
详见附件 Markdown 报告。
            """,
            attachmentsPattern: 'phase02/reports/daily-*/report.md'
        )
    }
}
```

---

## 八、文件清单

| 文件 | 作用 |
|---|---|
路径均相对于仓库根，`gitcode_services/` 即自包含包根。

| 文件 | 作用 |
|---|---|
| `gitcode_services/Jenkinsfile` | Pipeline 定义（cron 触发、凭证注入、门禁判红） |
| `gitcode_services/run_daily.sh` | 执行入口（schema → run_batch → junit → report） |
| `gitcode_services/sync-cases.sh` | 从上游同步引擎 / `--check` 检查漂移 |
| `gitcode_services/cases/yaml/` | 249 条用例（本包自有，非上游派生） |
| `gitcode_services/requirements.txt` | Python 依赖清单 |
| `gitcode_services/Dockerfile` | 容器化执行环境（构建上下文=本包目录） |
| `gitcode_services/docker-compose.yml` | 本地一键跑全量 |
| `gitcode_services/.env.example` | 凭证模板 |
| `phase02/scripts/junit_export.py` | results/*.json → JUnit XML（本包独有） |
| `phase02/scripts/report_builder.py` | 分维度报告 + 门禁退出码 |
| `phase02/scripts/schema_check.py` | 用例合规校验 + queue.json 生成 |
| `phase02/scripts/run_batch.py` | 批量执行（仅 workflow 类，不按 test_type 分派） |

---

**快速上手**：
1. Jenkins agent 装好 Python 3 + git
2. 配置两个凭证（`gitcode-access-token` + `gitcode-cookie`）
3. 新建 Pipeline Job，Script Path 填 `gitcode_services/Jenkinsfile`
4. 手动触发一次，验证通过后每日自动跑

有问题看构建日志 `Console Output`，搜索 `ERROR` / `门禁:` 关键词定位。

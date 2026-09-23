# openEuler 私人令牌 — 自动化测试

针对 `https://openeuler.test.osinfra.cn/zh/my/tokens` 的 Playwright 自动化测试套件，
覆盖私人令牌的创建、重新生成、修改、删除全链路，含滑块验证与邮箱验证码的自动处理。

---

## 快速开始

```bash
# 安装依赖
pip install -r requirements.txt
playwright install chromium

# 跑全套（约 8 分钟）
pytest tests/

# 只跑快速用例（前端校验，无需邮箱验证码，约 1 分钟）
pytest tests/ -m "not slow"

# 跑完后核对数据是否恢复初始状态（只读，不改任何数据）
python verify_cleanup.py
```

账号与邮箱授权码配置在 `config.yaml`，由 `common/config.py` 读取并注入环境变量。

> Windows + 本项目 venv 的调用方式：
> `PYTHONUTF8=1 ../.venv2/Scripts/python.exe -m pytest tests/`

---

## 测试套件

13 条用例，全套约 8 分钟。

| 用例 | 覆盖场景 | 验证码 |
|------|---------|-------|
| `test_b08_unauthenticated_access` | 未登录直访被重定向到登录页 | 0 |
| `test_w01_illegal_chars_in_name` | 名称含非法字符 `@#$` | 0 |
| `test_w02_name_too_long` | 名称超 20 字符 | 0 |
| `test_w04_custom_days_boundary` | 自定义天数填 0 | 0 |
| `test_w05_custom_days_non_integer` | 自定义天数填小数 | 0 |
| `test_n01_login_and_navigate` | 登录并落地令牌页 | 0 |
| `test_n02_list_rendering` | 列表表头 5 列 | 0 |
| `test_e01_empty_form_submit` | 全空表单提交 | 0 |
| `test_e01a_empty_name` | 名称留空 | 0 |
| `test_e01b_empty_expiry` | 有效期不选 | 0 |
| `test_e01c_empty_permissions` | 权限不勾选 | 0 |
| **`test_lifecycle_basic`** | 创建(7天/单权限) → 重新生成 → 改名改权限 → 重设有效期 → 删除 | 5 |
| **`test_lifecycle_custom`** | 创建(90天自定义/双权限) → 删除 | 2 |

### 为什么写成生命周期用例

每个写操作都需要一次**独立**的邮箱验证码（后端在每次操作成功后即作废 emailToken），
而同一邮箱 65s 内只能发一次。早期版本把 N-03~N-08 拆成 6 条独立用例，各自
「建新令牌 → 测 → 清理删掉」，15 次验证码里 12 次耗在重复的 create/delete 上，
全套要 17 分钟。改为一个令牌串起整条生命周期后降到 7 次码、8 分钟。

两条用例都以 delete 收尾，使清理 fixture 退化为空操作，又省一次码。

保留 `test_lifecycle_custom` 独立，是因为它覆盖「创建时**直接**填自定义天数、
直接勾多个权限」这条路径——`test_lifecycle_basic` 里的自定义天数是「改成」而非「建成」。

---

## 数据清理

**跑完一遍后页面数据必须恢复初始状态**，由两层机制保证：

1. **`auto_cleanup_token` fixture**（`tests/conftest.py`）
   测试结束后删除该用例创建的令牌，含可能的 `_renamed` 变体。
   用 fixture teardown 而非用例内 `finally`，好处是**断言失败也会执行清理**。

2. **`page` fixture 的兜底清理**
   对比测试前后的令牌列表，删除所有新增的 `auto_*` 令牌。

安全护栏：`PROTECTED_TOKENS = {"software_token"}` 中的令牌绝不触碰，
`delete_token()` / `update_token()` 命中即抛 `ProtectedTokenError`。

每轮跑完建议执行 `python verify_cleanup.py` 独立核对（只读，不依赖测试日志自证）。

---

## 失败重试

只对**环境类**异常重试，配置在 `pytest.ini`：

```ini
--reruns 1
--reruns-delay 70
--only-rerun MailCodeError    # 邮箱 180s 未收到验证码
--only-rerun TimeoutError     # Playwright 等元素/弹窗超时
```

`AssertionError` **故意不在名单内**。真实功能缺陷必须一次暴露——
本项目的 F-19/F-20 两个 bug 都表现为断言失败，若无差别重试会被掩盖成
「偶发不稳定」，且每次重试要多花约 2 分钟验证码时间。

`reruns-delay` 取 70s（略大于 65s 冷却窗口），让重试时能直接拿到新码。

---

## 项目结构

```
common/                    公共层，7 条铁律内置于此
├── constants.py           URL / 超时 / 保护名单 / 令牌前缀
├── config.py              config.yaml 加载 + 环境变量注入（单例）
├── browser_helper.py      浏览器启动、settle_landing、wait_hydrated
├── auth_helper.py         账号密码登录
├── identity_verify.py     身份验证弹窗：限流等待 → 滑块 → 取码 → 确认
├── element_actions.py     下拉选择（Teleport）、禁用态断言、Toast 捕获
├── token_operations.py    表单填写、明文抓取、数据行定位
├── debug_utils.py         日志、快照（截图 + HTML + 结构化 JSON）
└── exceptions.py          业务异常

token_manager.py           高级 API：create/update/delete/regenerate/list
email_verify.py            IMAP 取邮箱验证码
slider_solver.py           滑块破解（图像分析）
slider_token.py            令牌页滑块适配器（内置等图逻辑）

tests/
├── conftest.py            fixtures：会话、页面、验证码冷却、自动清理
├── helpers.py             通用断言
├── test_normal_operations.py
├── test_error_cases.py
├── test_validation.py
└── test_boundary.py

verify_cleanup.py          只读核对：列出令牌、检查有无 auto_* 残留
cleanup_leftovers.py       清理残留令牌（测试被中断后手工收尾用）
run_stability.sh           连跑两轮 + 每轮后自动核对数据，检验稳定性
diag_update.py             诊断：抓「保存」后的 DOM 与网络层证据
diag_rowof.py              诊断：验证 row_of() 精确匹配是否生效
phase1-page-analysis.md    页面结构实测分析 + 踩坑清单（F-1~F-22）
```

`diag_*.py` 是排查 F-19~F-21 时写的取证脚本，保留下来是因为
这类「静默失败」日后仍可能出现，届时直接跑比重新推断快得多。

---

## 关键约束

这些是**实测确认**的系统行为，不是推测，违反任一条脚本必挂。
完整清单见 `phase1-page-analysis.md` §3 / §3.1。

| 编号 | 约束 |
|------|------|
| F-1 | 禁用 `networkidle`——该页持续轮询，永不达成 |
| F-2 | 禁用 `id` 定位——所有 input 的 id 每次加载随机生成 |
| F-11 | 点「创建私人令牌」前必须等 hydration 收敛，否则点击穿透到 SSR 链接误跳 settings 页 |
| F-12 | 滑块必须等图加载完再破解 |
| F-15/16 | 下拉选项被 Vue Teleport 移到 body，等待/点击**不能**带容器前缀 |
| F-18 | 禁用态只有 CSS class `o-btn-disabled`，`is_disabled()` 恒返回 False |
| **F-19** | 令牌名上限 20 字符，超长被前端**静默**拦住（不发请求、不弹验证框、无 Toast） |
| **F-20** | `filter(has_text=)` 是**子串**匹配，`row_of()` 必须用锚定正则精确匹配单元格 |
| **F-21** | 写操作后列表刷新有延迟，必须用 `wait_for_token_state()` 轮询，不能读一次就断言 |
| **F-22** | 用例中途失败留下的遮罩会级联毁掉后续用例，状态复位必须用整页 reload |

F-19~F-22 是阶段4 实测新增，共同特点是**失败表现与真因严重不符**：
F-19/F-20 叠加曾让「修改令牌」用例连续多轮失败，表现酷似「后端响应慢」或「按钮未点击」；
F-22 会让一条用例的失败伪装成一批用例的失败。完整的误判排除过程记录在
`phase1-page-analysis.md` §3.1，遇到静默失败或成批失败时建议先读那一节。

§3.1 另附一条反面教训：**不要用 Toast 出现、表单关闭这类代理信号判定写操作成功**
——曾因此把失败误报成成功，比直接失败更难排查。

---

## 已知限制

- **邮箱验证码延迟**：实测 2~120s 波动，偶尔超 180s 超时上限。已由重试机制覆盖。
- **滑块偶发失败**：自动破解内置 3 次换图重试，仍失败则**明确提醒人工介入**并等待最多 3 分钟。
- **B-01（令牌数达 20 上限）未覆盖**：造 19 个令牌需 20+ 分钟，成本过高（阿蓁 2026-09-21 决策）。
- **N-10（「个人API」外链）未覆盖**：不纠结是否开新标签页（阿蓁 2026-09-21 决策）。
- **滑块连续失败场景无法自动化**：无法可靠模拟，需人工测试。

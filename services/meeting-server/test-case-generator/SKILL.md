---
name: test-case-generator
description: Meeting Server（openUBMC 会议中心 / 类似会议预约调度系统）专用测试用例生成 Agent。**继承 test-case-generator 的人机两用规范**（8 字段 + agent-exec YAML 块 + 9 维度覆盖 + Markdown/Python 双形态），并叠加 Meeting Server 三条强制约束：(1) 涉及登录的需求必须从环境变量 TEST_ACCOUNT / TEST_PASSWORD 读取账号密码，禁止硬编码；(2) 需要"已存在会议"作为前置的用例，必须在 setup 中先调用创建会议接口拿到 meeting_id；(3) 凡 setup 中创建过的会议，teardown 必须调用删除会议接口清理，禁止留垃圾数据；(4) setup 中创建会议的日期默认取**次月 1 号**（防止用例临近会议时间窗触发"进行中会议不可删除"等业务限制）。本 skill 仅产出 Meeting Server 测试用例。触发词：meeting 测试用例、meeting-server 用例、会议测试用例、会议接口用例、会议预约用例、会议中心 case、create meeting case、delete meeting case、openUBMC meeting 用例、会议管理用例、会议室用例、cycle meeting 用例、周期会议用例。仅产出测试用例，不闲聊、不发散、不做无文档依据的推断。
---

# Meeting Server 测试用例生成（人机两用）

## 角色定位

资深 Meeting Server 测试工程师。**继承 test-case-generator 的全部规范**（详见 [../../../test_skills_base/test-case-generator/SKILL.md](../../../test_skills_base/test-case-generator/SKILL.md)），在此基础上对 Meeting Server 类系统（会议预约 / 会议室管理 / 周期会议 / 会议提醒）追加领域约束。**只做一件事**：把会议相关需求/接口/UI 转成可在本仓 `services/meeting-server/` 下直接执行的测试用例。

## 强约束（继承 test-case-generator + Meeting 领域追加）

继承自 base 的 6 条强约束（唯输出用例 / 严格基于输入 / 信息缺失立即停 / AI 可执行性 / 数据具体值 / 9 维度全覆盖）**全部生效**。

**Meeting Server 追加 4 条**（违反即视为失败交付）：

1. **登录凭据来源唯一**：用例中的登录账号/密码**只能**写成 `${TEST_ACCOUNT}` / `${TEST_PASSWORD}`（占位符引用环境变量），**禁止硬编码任何账号或密码字面量**。Markdown 用例的"前置条件"列必须显式声明"已设置 TEST_ACCOUNT、TEST_PASSWORD 环境变量"；Python 模式必须 `os.environ["TEST_ACCOUNT"]` / `os.environ["TEST_PASSWORD"]`。

2. **登录前置自动织入**：凡需要鉴权的用例（即接口路径以 `/api-meeting/` 开头或 UI 进入 `/personal/meeting` 等已登录页），其 `agent-exec` 块必须含 `setup.login` 步骤；详细模板见 [references/meeting-fixtures.md](references/meeting-fixtures.md)。

3. **依赖"已存在会议"的用例必须先建会再清理**：当用例的预期行为是"对一个已存在的会议执行 X"（删除会议、修改会议、查看详情、加入会议、邀请成员、取消会议……），其 `agent-exec` 块必须按以下顺序：
   - `setup.login` → 登录拿 token + cookies
   - `setup.create_meeting` → 调 `POST /api-meeting/v1/meeting/` 创建一个**测试专用会议**，捕获 `meeting_id`
   - `steps` → 执行被测操作
   - `teardown.delete_meeting` → 调 `DELETE /api-meeting/v1/meeting/{meeting_id}/` **强制清理**
   - **即使被测操作本身就是"删除会议"**，teardown 仍需带兜底删除（用 `ignore_errors: true`，避免重复删除报错），保证不留脏数据
   - **即使用例失败/中断**，teardown 也必须执行（Python 模式落到 `pytest fixture yield 后`；Markdown agent-exec 用 `teardown.always_run: true`）

4. **建会日期固定取次月 1 号**：setup 创建的"测试会议"日期字段必须用占位符 `{{NEXT_MONTH_FIRST_DAY}}`，AI 执行时按"当前日期所在月份的次月 1 号"动态计算（如当前是 2026/05/23 → 2026/06/01；当前是 2026/12/15 → 2027/01/01）。理由：避免用例运行时间临近会议起止时间，触发"进行中会议禁止删除""会议已开始无法取消"等业务侧保护逻辑导致 teardown 失败。**禁止用 `_date_offset(2)`、明天、后天等近期相对日期作为 setup 默认值**——这是历史包袱，不要照搬。

## 用例 ID 前缀

`TC-MEETING-<MODULE>-NNN`，其中 MODULE 取自被测功能：

| 模块 | MODULE 取值 | 示例 |
|---|---|---|
| 创建会议 | `CREATE` | TC-MEETING-CREATE-001 |
| 删除/取消会议 | `DELETE` | TC-MEETING-DELETE-001 |
| 修改会议 | `UPDATE` | TC-MEETING-UPDATE-001 |
| 查询会议（列表/详情） | `QUERY` | TC-MEETING-QUERY-001 |
| 周期会议 | `CYCLE` | TC-MEETING-CYCLE-001 |
| 加入/邀请 | `JOIN` | TC-MEETING-JOIN-001 |
| 提醒/通知 | `NOTIFY` | TC-MEETING-NOTIFY-001 |
| 登录鉴权 | `AUTH` | TC-MEETING-AUTH-001 |
| 其他 | `MISC` | TC-MEETING-MISC-001 |

UI 用例改前缀 `TC-MEETING-UI-<MODULE>-NNN`。

## agent-exec 块的 Meeting 专属增强

base 的 `agent-exec` schema 不变（type / tool / request / steps / assertions / side_effects），Meeting 模式仅在外层追加可选 `setup` / `teardown` 字段：

```yaml
type: api
tool: curl
setup:                                    # 可选；需要登录或建会时填
  login:                                  # 见 references/meeting-fixtures.md
    account_env: TEST_ACCOUNT
    password_env: TEST_PASSWORD
    # 执行后捕获 {{TOKEN}} {{YG}}
  create_meeting:                         # 仅当用例需要"已存在的会议"时填
    date: '{{NEXT_MONTH_FIRST_DAY}}'      # 固定占位符
    topic: 'testcase-{{TC_ID}}-{{TS}}'    # 隔离命名，避免撞主题
    # 详细字段见 references/meeting-fixtures.md
    # 执行后捕获 {{MEETING_ID}}
request:
  method: DELETE
  url: https://openubmc-website.test.osinfra.cn/api-meeting/v1/meeting/{{MEETING_ID}}/
  headers:
    token: '{{TOKEN}}'
  cookies:
    _U_T_: '{{TOKEN}}'
    _Y_G_: '{{YG}}'
assertions:
  - http_status: 200
  - jsonpath: $.code
    equals: 200
teardown:
  always_run: true                        # 不论 steps 成败都执行
  delete_meeting:                         # 兜底清理 setup 创建的会议
    meeting_id: '{{MEETING_ID}}'
    ignore_errors: true                   # 已被被测操作删过则忽略 404
```

**字段语义、占位符清单、动态值计算规则、Python 模式映射**全部见 [references/meeting-fixtures.md](references/meeting-fixtures.md)，必须读了再生成。

## 占位符约定

| 占位符 | 来源 | 何时计算 |
|---|---|---|
| `{{TEST_ACCOUNT}}` | `os.environ["TEST_ACCOUNT"]` | 执行时 |
| `{{TEST_PASSWORD}}` | `os.environ["TEST_PASSWORD"]` | 执行时 |
| `{{TOKEN}}` | login 响应 `body.data.token` 或 `_U_T_` cookie | setup.login 完成后 |
| `{{YG}}` | login 响应 Set-Cookie 中的 `_Y_G_` | setup.login 完成后 |
| `{{NEXT_MONTH_FIRST_DAY}}` | `(today.replace(day=1) + relativedelta(months=1)).strftime('%Y-%m-%d')` | setup.create_meeting 前 |
| `{{MEETING_ID}}` | create_meeting 响应 `body.data.id` 或 `body.data.meetingId` | setup.create_meeting 完成后 |
| `{{TC_ID}}` | 当前用例 ID（如 `TC-MEETING-DELETE-001`） | 用例渲染时 |
| `{{TS}}` | `int(time.time())`，避免主题撞库 | 执行时 |

## 工作流程

继承 base 的 Step 1–5，所有改动集中在 **Step 0（前置门禁）** 与 **Step 4（agent-exec 织入）**。

### Step 0：前置门禁（Meeting 专属）

生成用例前**必须先确认 3 项输入**，缺一立即停下来要求用户补齐，不允许硬编码兜底：

1. **登录账号来源是否已约定为 TEST_ACCOUNT / TEST_PASSWORD**？
   - 若用户提供的需求文档指定了别的环境变量名，应主动询问"是否仍统一为 TEST_ACCOUNT/TEST_PASSWORD"；
   - 若用户未提，按 skill 默认（TEST_ACCOUNT / TEST_PASSWORD），但要在用例文件头注明。
2. **被测接口的 host / 路径前缀**是否已知？默认按 `services/meeting-server/base_community/conftest.py` 的 `HOST_URL = openubmc-website.test.osinfra.cn` 与 `/api-meeting/v1/...`；若需求另指定环境，主动询问后再生成。
3. **建会必填字段约束**（platform 枚举、group_name 取值、cycle 规则等）是否已在需求中明示？缺则列入「需补充信息」。

### Step 1–3：识别输入 / 检查完备性 / 9 维度覆盖

**完全沿用 base [test-case-generator/SKILL.md](../../../test_skills_base/test-case-generator/SKILL.md)** 的对应步骤，不重复展开。

### Step 4：维度标识 + 优先级 + Meeting 专属织入

每条用例落地到 `agent-exec` 块时，按下表自动决定 setup/teardown 配置：

| 用例性质 | setup.login | setup.create_meeting | teardown.delete_meeting |
|---|---|---|---|
| 登录本身（TC-MEETING-AUTH-*） | ❌（被测对象） | ❌ | ❌ |
| 创建会议正向流（CREATE，断言"会议成功创建"） | ✅ | ❌（被测对象） | ✅（用 steps 捕获到的 meeting_id） |
| 创建会议异常/边界（CREATE，断言"创建失败"） | ✅ | ❌ | ❌（未真正建会） |
| 删除会议（DELETE） | ✅ | ✅ 先建一个再删 | ✅ ignore_errors=true 兜底 |
| 修改/查询/取消会议（UPDATE / QUERY / JOIN） | ✅ | ✅ | ✅ |
| 周期会议创建（CYCLE，正向） | ✅ | ❌ | ✅（清理 series） |
| 周期会议删除/修改（CYCLE，需已存在） | ✅ | ✅（is_cycle=true） | ✅ |
| 权限/越权（无 token 或错 token） | ❌（故意不带） | ❌ | ❌ |

### Step 5：分模块结构化输出

完全沿用 base 的 [markdown-template.md](../../../test_skills_base/test-case-generator/references/markdown-template.md)，文件头额外加一行：

```markdown
> 登录凭据来源：环境变量 TEST_ACCOUNT、TEST_PASSWORD（执行前需 export）
> setup 建会日期：{{NEXT_MONTH_FIRST_DAY}}（次月 1 号，避免临近会议时间触发业务保护）
> teardown 强制清理：所有 setup 创建的会议在用例结束/失败/异常中断后均会被删除
```

## Python 模式（继承 base + Meeting 织入）

触发条件、文件命名、自动化判定**完全沿用** base 的 [python-script-output.md](../../../test_skills_base/test-case-generator/references/python-script-output.md)。Meeting 专属差异：

1. **登录 fixture**：可直接复用本仓 `services/meeting-server/base_community/conftest.py` 中的 `login_creds` fixture（已实现 RSA 加密 + token 缓存）。**唯一需要改动**：将其中的 `MEETING_ACCOUNT` / `PASSWORD` 改读 `TEST_ACCOUNT` / `TEST_PASSWORD`（或在新生成的 conftest.py 中明确读取这两个变量）。

2. **建会 fixture**：每条需要"已存在会议"的用例使用 `created_meeting` fixture，函数签名与实现见 [references/meeting-fixtures.md](references/meeting-fixtures.md) 第 4 节。fixture 必须用 `yield` 模式，`yield` 后强制调用删除接口；`pytest.fail` / 异常都不能跳过删除。

3. **次月 1 号计算**：使用纯 stdlib：

   ```python
   from datetime import date
   def next_month_first_day() -> str:
       today = date.today()
       year = today.year + (1 if today.month == 12 else 0)
       month = 1 if today.month == 12 else today.month + 1
       return date(year, month, 1).strftime("%Y-%m-%d")
   ```

4. **隔离命名**：会议主题使用 `f"testcase-{tc_id}-{int(time.time())}"`，禁用固定字符串以免并发撞主题。

完整 Python 模式样例见 [references/meeting-fixtures.md](references/meeting-fixtures.md) 第 5 节。

## AI 可执行性自检清单（Meeting 专属增量）

base 自检清单全部生效。Meeting 增量自检（每条用例必查）：

- [ ] 登录步骤是否使用 `${TEST_ACCOUNT}` / `${TEST_PASSWORD}` 占位符？无硬编码？
- [ ] 用例若需要"已存在会议"，setup 是否先建会并捕获 `{{MEETING_ID}}`？
- [ ] setup 建会的 `date` 字段是否为 `{{NEXT_MONTH_FIRST_DAY}}`？
- [ ] setup 建会的 `topic` 是否含用例 ID 与时间戳，避免撞主题？
- [ ] teardown 是否含 `delete_meeting` 且 `always_run: true`？
- [ ] 删除类用例的 teardown 是否带 `ignore_errors: true`？
- [ ] 文件头是否注明环境变量约定与建会日期策略？

## 拒答策略

非「Meeting Server 测试用例生成」请求一律拒绝：

> 本 skill 为 Meeting Server 专用测试用例生成 Agent，仅产出会议相关人机两用测试用例。请提供 Meeting Server 接口文档/PRD/UI 原型作为输入。其他测试任务请改用通用 [test-case-generator](../../../test_skills_base/test-case-generator/) skill。

## 文件索引

- [meeting-fixtures.md](references/meeting-fixtures.md) — 登录 / 建会 / 删会 setup-teardown 模板，占位符计算规则，Python fixture 完整实现
- [meeting-case-patterns.md](references/meeting-case-patterns.md) — Meeting Server 用例特有模式：时间冲突规避、cycle 会议、并发建会、会议状态机、典型反例
- 继承自 base：[coverage-checklist.md](../../../test_skills_base/test-case-generator/references/coverage-checklist.md) ｜ [case-types.md](../../../test_skills_base/test-case-generator/references/case-types.md) ｜ [agent-executable-spec.md](../../../test_skills_base/test-case-generator/references/agent-executable-spec.md) ｜ [markdown-template.md](../../../test_skills_base/test-case-generator/references/markdown-template.md) ｜ [python-script-output.md](../../../test_skills_base/test-case-generator/references/python-script-output.md)

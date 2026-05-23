# Meeting Server 用例特有模式

本文档列出 Meeting Server 类系统在测试设计中**与通用接口/UI 测试不同**的领域模式与坑点。生成用例时遇到对应场景，请按下表的模式落地，避免重复踩坑。

## 目录

- [1. 时间冲突规避](#1-时间冲突规避)
- [2. 周期会议（cycle）](#2-周期会议cycle)
- [3. 并发建会与幂等](#3-并发建会与幂等)
- [4. 会议状态机（用例覆盖矩阵参考）](#4-会议状态机用例覆盖矩阵参考)
- [5. 鉴权与越权](#5-鉴权与越权)
- [6. 已知反例：常见错误用例写法](#6-已知反例常见错误用例写法)

---

## 1. 时间冲突规避

**业务规则（从 base_community 实测得出）**：同一会议室 + 同一日期 + 时间窗交叠 ±30 min → 报"会议时间冲突"。

**用例侧后果**：

- 多条用例在 setup.create_meeting 时若都用 `start=10:00 / end=10:30`，并发或顺序执行都会撞冲突。
- 同一个会议被反复建立时，相邻 30 min 内同 group_name 也会撞。

**设计要点**：

1. **每条用例的 start 偏移自身序号**：`start = (10*60 + idx*30) // 60 : (idx*30 % 60)`，确保用例间错峰 30 分钟以上。
2. **topic 必含用例 ID + TS**（已在 setup.create_meeting 模板中默认）。
3. **次月 1 号本身已大幅缓解**：因为日期都落在未来很远，多次执行同一用例只要 topic 不撞、时间窗不撞即可。
4. 设计「时间冲突」专用用例时，**显式构造冲突**而不是靠"碰巧"——先 setup 一个 10:00-10:30 的会议，再 steps 建一个 10:15-10:45 的会议，断言报冲突。

---

## 2. 周期会议（cycle）

**关键字段**（base 文档未必覆盖，需求未明示则列入「需补充信息」）：

```json
{
  "is_cycle": true,
  "cycle": {
    "type": "WEEK",            // DAY / WEEK / MONTH 等枚举
    "interval": 1,              // 间隔
    "weekdays": [1, 3, 5],      // type=WEEK 时的星期数（1=周一）
    "end_date": "2026-08-01"    // 结束日期 / 或 count 次数
  }
}
```

**用例特殊设计**：

| 维度 | 周期会议特有用例 |
|---|---|
| 正常流 | 创建 WEEK / MONTH 周期会议成功，列表查询返回所有展开实例 |
| 边界 | end_date = 起始日（仅 1 次） / end_date 跨年 / weekdays = [1,2,3,4,5,6,7] 全选 |
| 异常 | 删除「整个周期」vs 删除「单个实例」的区别（接口字段如 `delete_type=SERIES/INSTANCE`） |
| 唯一性 | 同周期同时间窗重复创建 |
| 重复操作 | 同周期先删 SERIES 再删某 INSTANCE，期望 404 |

**teardown 注意**：周期会议的 setup 创建后，teardown 删除时建议带 `delete_type=SERIES` 一次性清完，避免遗留实例。

---

## 3. 并发建会与幂等

**典型用例**：

- 同账号同时间窗并发创建 2 个会议 → 仅 1 个成功
- 客户端网络抖动重试同一请求（含 idempotency-key 头时）→ 业务侧应去重

**实现提示**：agent-exec 现版本不直接支持并发；并发用例归到 Python 模式产出，用 `concurrent.futures.ThreadPoolExecutor` 提交，断言成功数 = 1。

---

## 4. 会议状态机（用例覆盖矩阵参考）

会议有以下状态（按业务文档为准，需求未明示时列入「需补充信息」并暂按以下默认）：

```
[未开始] --(到达 start)--> [进行中] --(到达 end)--> [已结束]
   |                            |
   |--(取消/删除)              |--(中途结束)
   v                            v
[已取消]                   [已结束]
```

**状态相关用例必须覆盖的转换**：

| 起始状态 | 操作 | 预期 |
|---|---|---|
| 未开始 | 删除 | 200 成功 |
| 进行中 | 删除 | 通常被业务保护，403 / 400 / 200 + warning（按文档为准） |
| 已结束 | 删除 | 通常报"会议已结束不可删除" |
| 已取消 | 再删 | 404 / 重复操作幂等 |
| 进行中 | 修改 topic | 通常拒绝 |
| 进行中 | 修改 end 时间 | 视业务规则 |

**为什么 setup 必须用次月 1 号**：上表中"进行中""已结束"是用例**故意**构造的状态，不该由"用例运行时间恰好撞上 setup 创建的会议时间窗"被动触发——次月 1 号确保 setup 的会议永远在未来，删除/查询/修改类用例不会被状态保护误拦。

---

## 5. 鉴权与越权

**鉴权类用例不要建会、不要登录**（或显式构造错误鉴权）：

| 用例 | setup.login | 鉴权头 | 预期 |
|---|---|---|---|
| TC-MEETING-AUTH-001 [权限] 不带任何鉴权访问 | ❌ | 不带 | 401 "账号已退登" |
| TC-MEETING-AUTH-002 [权限] 仅带 token header 不带 cookie | ❌ | header 有 token，cookie 无 | 401 |
| TC-MEETING-AUTH-003 [权限] 仅带 _Y_G_ 不带 _U_T_ | ❌ | header 无 token，cookie 仅 _Y_G_ | 401 |
| TC-MEETING-AUTH-004 [权限] token 过期 | ✅（拿到合法 token 后人为污染） | 篡改 token 末位 | 401/403 |
| TC-MEETING-AUTH-005 [越权] A 用户删除 B 用户的会议 | ✅（用 TEST_ACCOUNT 登录） | 用 B 的 meeting_id | 403 |

**TC-MEETING-AUTH-005 越权用例的特殊处理**：B 的会议 meeting_id 需求侧未提供时，列入「需补充信息」要求用户提供另一个测试账号 + 其会议 ID，**不要硬编码假 ID**——假 ID 可能恰好命中某个合法会议，污染数据。

---

## 6. 已知反例：常见错误用例写法

### 6.1 ❌ 反例：硬编码账号密码

```yaml
# 错误
setup:
  login:
    account: 19938204520
    password: Aa123456@
```

```yaml
# 正确
setup:
  login:
    account_env: TEST_ACCOUNT
    password_env: TEST_PASSWORD
```

### 6.2 ❌ 反例：建会日期用 today + 2 days

```python
# 错误：模仿 base_community/test_meeting_create_delete.py 的旧写法
"date": _date_offset(2)
```

```python
# 正确
"date": next_month_first_day()
```

理由：用例运行时间一长（>2 天）就会撞会议起止时间，触发"进行中会议禁止删除"，teardown 失败、留垃圾数据。次月 1 号给足缓冲。

### 6.3 ❌ 反例：teardown 缺失或无兜底

```yaml
# 错误：删除类用例没有 teardown
type: api
setup:
  create_meeting: ...
request:
  method: DELETE
  url: .../meeting/{{MEETING_ID}}/
# 没有 teardown
```

后果：steps 失败时（如断言不通过、网络抖动）会议未被删，留垃圾数据。

```yaml
# 正确：teardown.always_run=true + ignore_errors=true 双保险
teardown:
  always_run: true
  delete_meeting:
    path: /api-meeting/v1/meeting/{{MEETING_ID}}/
    method: DELETE
    ignore_errors: true
    expected_status: [200, 404]
```

### 6.4 ❌ 反例：把"创建会议"作为另一条用例的前置文字描述，不写 setup

```markdown
| TC-MEETING-DELETE-001 | ... | 前置条件 | 1.系统中已存在一个会议 | ...
```

仅文字描述前置 → AI 执行时无从下手；必须落到 `agent-exec.setup.create_meeting`。

### 6.5 ❌ 反例：teardown 用 fixed meeting_id

```yaml
teardown:
  delete_meeting:
    meeting_id: 12345           # 错：固定 ID
```

正确：teardown 必须引用 setup/steps 中 capture 出来的 `{{MEETING_ID}}`。

### 6.6 ❌ 反例：setup 建会时 topic 不带用例 ID / TS

```yaml
topic: '自动化测试会议'              # 错：并发跑会撞主题
```

```yaml
topic: 'testcase-{{TC_ID}}-{{TS}}'   # 正确
```

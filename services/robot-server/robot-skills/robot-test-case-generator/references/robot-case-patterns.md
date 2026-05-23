# Robot 类用例常见模式

本文档提供 Robot 类（机器人/Bot/自动化处理）服务的标准用例骨架，每种模式给出推荐用例集与对应 agent-exec 模板。**实际生成时必须以 Step 1 探测结果替换占位文案与字段**。

## 模式 1：自动分配默认负责人（Default Assignee）

### 典型 Robot 行为
- Issue 创建 → 若 currentAssignee 为空 → 分配给 `default_assignee` 并发一条通知评论
- Issue 创建 → 若 currentAssignee 非空 → 不覆盖、不评论
- Issue 更新 → 不重新触发分配

### 推荐用例集

| 用例 | 维度 | 关键断言 |
|---|---|---|
| 创建无 assignee 的 Issue → 应被默认分配 | 正常流 | `assignee.login == <default_assignee>` + Bot 评论含 `<default assignee 文案>` |
| 创建已指派的 Issue → 不被覆盖 | 反向 | `assignee.login == <用户指定>` + 评论列表无 Bot 默认分配通知 |
| 默认负责人配置为非 member → 应拒绝 | 权限/反向 | `assignee == null` + Bot 评论含拒绝文案 |
| PATCH 更新 Issue → 不重新触发分配 | 联动/反向 | 评论时间戳过滤后 Bot 无新评论 |
| 并发创建 N 个 Issue → 全部正确分配且无重复评论 | 唯一性/联动 | N 个 Issue 各自 1 条默认分配评论 |

### agent-exec 骨架（默认分配正常流）

```yaml
type: api
tool: curl
steps:
  - id: create_issue
    request:
      method: POST
      url: <平台 base>/repos/<o>/<r>/issues
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        repo: <r>           # gitcode 必填
        title: "[Test] Default Assignee Normal Flow"
        body: "verify default assignee"
    assertions:
      - http_status: 200   # 以 P5 探测结果为准（gitcode=200, gitee/github=201）
      - jsonpath: $.number
        not_empty: true
    capture_as:
      number: $.number
  - action: wait
    timeout_ms: 15000
  - id: verify_assignee
    request:
      method: GET
      url: <平台 base>/repos/<o>/<r>/issues/{{CAPTURE_number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: '<default_assignee 实测值>'
  - id: verify_bot_comment
    request:
      method: GET
      url: <平台 base>/repos/<o>/<r>/issues/{{CAPTURE_number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $[?(@.user.login=='<bot_login>')].body
        contains: '<默认分配文案核心子串>'
```

## 模式 2：评论命令管理负责人（/assign /unassign）

### 典型 Robot 行为
- 评论 `/assign` → 评论者自身设为负责人
- 评论 `/assign @user` → user 设为负责人（若为 member）
- 评论 `/assign @user1 @user2` → 多人，预期 msg_multiple_assignee 拒绝
- 评论 `/assign @already_assigned` → 重复，预期 msg_assign_repeatedly
- 评论 `/assign @non_member` → 权限，预期 msg_not_allow_assign
- 评论 `/unassign` → 取消自己
- 评论 `/unassign @other` → 非当前负责人，预期 msg_not_allow_unassign

### 推荐用例集（与设计文档对齐 + 实测补充）

| 用例 | 维度 | 备注 |
|---|---|---|
| /assign 自身正常流 | 正常流 | 评论者必须是 member |
| /assign @member 正常流 | 正常流 | — |
| /assign @非 member | 权限/反向 | 实测 Bot 文案断言 |
| /assign 重复同一负责人 | 唯一性/反向 | 实测文案断言 |
| /assign 多人 | 反向 | 注意：实测中部分 Robot 静默丢弃，需用实测结果覆盖文档假设 |
| /assign 大小写 `/ASSIGN` | 异常输入 | 实测命令正则是否大小写敏感 |
| /assign 前后空格 / 换行 | 异常输入 | 验证命令解析容忍度 |
| 评论非命令格式（如"请 @user 处理"） | 反向 | 不应触发分配，无 Bot 回写 |
| /assign + XSS 片段 | 特殊字符/XSS | 不应被执行，回写应转义 |
| /unassign 自身（当前是评论者） | 正常流 | 注意联动：unassign 后默认分配可能再次触发 |
| /unassign @非当前负责人 | 反向 | 实测文案断言 |
| /unassign 无负责人 | 空值/反向 | — |
| enable_issue_assign=false 时 /assign 不工作 | 权限/反向 | 需切配置，通常阻塞 |

### agent-exec 骨架（/assign 正常流）

```yaml
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_issue_number}}'
steps:
  - id: post_assign
    request:
      method: POST
      url: <base>/repos/<o>/<r>/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: "/assign"
    assertions:
      - http_status: 200
      - jsonpath: $.id
        not_empty: true
    capture_as:
      comment_created_at: $.created_at
  - action: wait
    timeout_ms: 12000
  - id: verify_assignee
    request:
      method: GET
      url: <base>/repos/<o>/<r>/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - jsonpath: $.assignee.login
        equals: '<token 持有者 login>'
  - id: verify_no_bot_response
    request:
      method: GET
      url: <base>/repos/<o>/<r>/issues/{{inputs.number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - jsonpath: $[?(@.user.login=='<bot_login>' && @.created_at > '{{CAPTURE_comment_created_at}}')]
        length: 0
```

## 模式 3：自动归集到看板 / 项目板（Auto-Add to Dashboard）

### 适用前提
- Step 1 P6 探测确认平台支持组织看板 API（否则全部阻塞）

### 推荐用例集

| 用例 | 维度 | 备注 |
|---|---|---|
| issue_type=缺陷 → 入缺陷看板 | 正常流 | 需 P6 + P7 双探测通过 |
| issue_type=需求 → 入需求看板 | 正常流 | 同上 |
| enable_auto_add=false → 不归集 | 反向 | 切配置场景，通常阻塞 |
| 看板描述不匹配前缀 → 不归集 | 反向 | — |
| issue_type 为空 → 不归集 | 空值 | — |
| 多看板同时匹配前缀 → 加入策略 | 联动/唯一性 | 验证 Robot 是「全部加入」还是「首个匹配」 |
| 看板前缀大小写敏感性 | 异常输入 | — |
| PATCH 更新 → 不重复入板 | 联动/反向 | — |

### agent-exec 骨架

需调用平台对应的看板查询/加入 API，按 [platform-api-cheatsheet.md](platform-api-cheatsheet.md) 选择端点。

## 模式 4：自动打标（Auto-Label / sig-* / kind-*）

### 典型 Robot 行为
- 评论 `/kind bug` / `/sig storage` 等 → Robot 加对应 label
- 评论 `/remove-label foo` → 移除 label
- Issue 标题命中模板 → 自动加 label

### 推荐用例集

| 用例 | 维度 | 关键断言 |
|---|---|---|
| `/kind bug` 加 label | 正常流 | GET Issue 后 `labels[].name` 含 `kind/bug` |
| `/kind nonexistent` 不存在的 kind | 反向 | label 未加 + Bot 拒绝评论 |
| 标题命中 `[Bug]` 模板自动加 label | 联动 | label 含 `kind/bug` |
| `/remove-label kind/bug` 移除 | 正常流 | label 中无 `kind/bug` |

### agent-exec 骨架

```yaml
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_issue_number}}'
steps:
  - id: post_kind_command
    request:
      method: POST
      url: <base>/repos/<o>/<r>/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: "/kind bug"
    assertions:
      - http_status: 200
  - action: wait
    timeout_ms: 12000
  - id: verify_label_added
    request:
      method: GET
      url: <base>/repos/<o>/<r>/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - jsonpath: $.labels[?(@.name=='kind/bug')]
        length: 1
```

## 模式 5：状态流转（/approve /lgtm /close /reopen）

### 推荐用例集

| 用例 | 维度 | 关键断言 |
|---|---|---|
| 维护者评论 `/lgtm` → 加 lgtm label | 正常流 + 权限 | label 含 `lgtm` |
| 非维护者评论 `/lgtm` → 拒绝 | 权限/反向 | Bot 拒绝评论 |
| `/close` → Issue 状态 closed | 正常流 | `state == 'closed'` |
| 已 closed 再 `/close` | 反向 | 状态不变 + 可能拒绝评论 |
| `/reopen` → 状态 open | 正常流 | `state == 'open'` |

## 通用约定（所有模式）

### 异步等待
所有 POST 评论 / 创建 Issue 之后，**必须有 `- action: wait\n  timeout_ms: 10000-15000`**，Robot 需要时间响应 Webhook。

### 文案断言
- 文案用实测语种（英文/中文）的核心子串而非完整字符串，避免标点/空格差异
- 用 jsonpath 数组过滤定位 Bot 评论：`$[?(@.user.login=='<bot_login>')].body`
- 多次执行同一用例时，按 `created_at` 时间戳过滤新评论

### 副作用断言
不只断言主字段（assignee/labels），还要断言"什么没发生"：
- 评论列表中无意外的 Bot 新评论（通过 created_at 过滤）
- assignee 在错误命令下保持原值
- 状态在异常路径下不变化

### 数据清理
- 测试 Issue 标题加 `[Test]` / `[AutoTest]` 前缀
- 用例文档结尾追加"清理建议"：列出新建 Issue 编号，提醒维护人关闭

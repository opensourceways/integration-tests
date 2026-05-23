# 测试用例集：Universal Issue Assign Robot
> 输入文档：D:\gxz\ai_gxz\robot\designDoc.md（设计文档）+ 历史执行报告（2026-05-22）
> 被测对象：Universal Issue Assign Robot（机器人账号 `openeuler-ci-bot`）
> 被测仓库：https://gitcode.com/openeuler-test/test-feature
> 测试方式：通过 gitcode 平台 REST API 调用模拟用户行为，触发机器人 Webhook 处理逻辑
> 用例总数：9 条 ｜ P0：4 ｜ P1：4 ｜ P2：1
> AI 执行工具：curl（Bash 工具调用）
> 指派目标用户：xiaoguozhi34（验证 Robot 拒绝非协作者）；实际"已通过"用例使用 `weixin_55883847` 作评论者/受让人
> 覆盖维度自检：见末尾覆盖矩阵

## 通用接口说明（用例步骤中复用，不重复书写）

| 操作 | Method | URL 模板 |
|---|---|---|
| 创建 Issue | POST | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues` |
| 获取 Issue 详情 | GET | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{number}` |
| 更新 Issue | PATCH | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{number}` |
| 评论 Issue | POST | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{number}/comments` |
| 查询 Issue 评论列表 | GET | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{number}/comments` |

通用请求头（除特别声明外，所有请求均带）：
- `Content-Type: application/json`
- `PRIVATE-TOKEN: {{TOKEN}}` ← gitcode 平台实测鉴权头（**不是** `Authorization: token ...`）
- `User-Agent: api-test/1.0`

**POST /issues 关键约定**：body 必须含 `repo` 字段，值为 `"test-feature"`（与 URL 路径中的 repo 同名）；缺失该字段会失败。
**创建 Issue 实际返回 HTTP 200**（**不是 201**）。
**评论 commentId 字段在响应 body.id**。

## Assign Robot 用例列表

| 用例ID | 所属模块 | 功能点 | 测试标题 | 前置条件 | 操作步骤 | 预期结果 | 实际结果 | 优先级 | 重要等级 |
|---|---|---|---|---|---|---|---|---|---|
| TC-API-ASSIGN-002 | 自动分配/POST /issues | 创建 Issue 自动分配默认负责人 | [反向] 创建时 body 已含 assignee 时不覆盖 | 1. repoConfig.default_assignee=`Guangyue-Xu`（实测）<br>2. weixin_55883847 与 Guangyue-Xu 均为协作者 | 1. POST issues，Body：{"repo":"test-feature","title":"TC-API-ASSIGN-002 已指派不覆盖","body":"...","assignee":"weixin_55883847"}<br>2. 等待 15s<br>3. GET issues/{number}<br>4. GET issues/{number}/comments | 1. 创建 HTTP 200，body.number 非空<br>2. 详情 assignee.login=`weixin_55883847`，未被覆盖<br>3. 评论列表无机器人默认分配评论<br>4. Robot 日志含 currentAssignee not empty, skip default |  | P0 | 高 |

```agent-exec
type: api
tool: curl
steps:
  - id: create_issue
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        repo: test-feature
        title: TC-API-ASSIGN-002 已指派不覆盖
        body: 接口自动化用例，验证 Robot 不覆盖已指派 assignee
        assignee: weixin_55883847
    assertions:
      - http_status: 200
      - jsonpath: $.number
        not_empty: true
      - jsonpath: $.assignee.login
        equals: weixin_55883847
    capture_as:
      number: $.number
  - action: wait
    timeout_ms: 15000
  - id: get_issue
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{CAPTURE_number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: weixin_55883847
  - id: list_comments
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{CAPTURE_number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot' && @.body=~/default assignee/)]
        length: 0
```

| TC-API-ASSIGN-006 | 自动分配/PATCH /issues | 创建 Issue 自动分配默认负责人 | [反向][联动] PATCH 更新 Issue 不触发默认分配 | 1. repoConfig.default_assignee=`Guangyue-Xu`<br>2. 已存在 Issue #{N}，assignee=`weixin_55883847` | 1. PATCH issues/{N}，Body：{"repo":"test-feature","title":"TC-API-ASSIGN-006 更新触发","body":"updated body"}<br>2. 等待 12s<br>3. GET issues/{N}<br>4. GET issues/{N}/comments | 1. PATCH HTTP 200<br>2. 详情 assignee.login 不变（仍 weixin_55883847）<br>3. 评论列表无机器人新增"默认分配"评论<br>4. Robot 日志含 update event ignored for default assign |  | P1 | 中 |

```agent-exec
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_existing_issue_number}}'  # 执行前由 AI 注入已存在的 Issue number
steps:
  - id: snapshot_before
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
    capture_as:
      comments_before: $.length
  - id: patch_issue
    request:
      method: PATCH
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        repo: test-feature
        title: TC-API-ASSIGN-006 更新触发
        body: updated body trigger update event
    assertions:
      - http_status: 200
  - action: wait
    timeout_ms: 12000
  - id: get_issue
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: weixin_55883847
  - id: list_comments_after
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot' && @.body=~/default assignee/)]
        length: 0
```

| TC-API-CMD-001 | 评论命令/POST /comments | /assign 不带参数 | [正常流] /assign 无参时将评论者自身设为负责人 | 1. enable_issue_assign=true<br>2. 已创建 Issue #{N1}，assignee=`Guangyue-Xu`（来自默认分配）<br>3. PAT {{TOKEN}} 持有人 weixin_55883847 为协作者 | 1. POST issues/{N1}/comments，Body：{"body":"/assign"}<br>2. 等待 12s<br>3. GET issues/{N1}<br>4. GET issues/{N1}/comments | 1. 评论 HTTP 200，body.id 非空<br>2. 详情 assignee.login=`weixin_55883847`（即评论者本人）<br>3. 评论列表无机器人附加评论（仅原 /assign 一条用户评论） |  | P0 | 高 |

```agent-exec
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_issue_number}}'
steps:
  - id: post_assign
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: /assign
    assertions:
      - http_status: 200
      - jsonpath: $.id
        not_empty: true
      - jsonpath: $.body
        equals: /assign
    capture_as:
      comment_id: $.id
  - action: wait
    timeout_ms: 12000
  - id: get_issue
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: weixin_55883847
  - id: list_comments
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      # 期望本次 /assign 之后没有 bot 追加评论；如有历史 bot 评论需通过时间戳过滤
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot' && @.created_at > '{{CAPTURE_comment_id_created_at}}')]
        length: 0
```

| TC-API-CMD-004 | 评论命令/POST /comments | /assign 重复分配 | [反向][唯一性] 重复分配同一负责人返回 msg_assign_repeatedly | 1. enable_issue_assign=true<br>2. Issue #{N4}.assignee=`weixin_55883847`<br>3. 实测 Robot 文案为英文 `This issue is already assigned to ***%s***. Please do not assign repeatedly.` | 1. POST issues/{N4}/comments，Body：{"body":"/assign @weixin_55883847"}<br>2. 等待 12s<br>3. GET issues/{N4}<br>4. GET issues/{N4}/comments | 1. 评论 HTTP 200<br>2. 详情 assignee.login 仍为 `weixin_55883847`<br>3. 评论列表新增 openeuler-ci-bot 评论，body 含 `This issue is already assigned to ***weixin_55883847***. Please do not assign repeatedly.` |  | P1 | 中 |

```agent-exec
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_issue_number}}'
steps:
  - id: post_repeat_assign
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: /assign @weixin_55883847
    assertions:
      - http_status: 200
      - jsonpath: $.id
        not_empty: true
  - action: wait
    timeout_ms: 12000
  - id: get_issue
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: weixin_55883847
  - id: list_comments
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot')].body
        contains: 'already assigned to'
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot')].body
        contains: weixin_55883847
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot')].body
        contains: 'do not assign repeatedly'
```

| TC-API-CMD-005 | 评论命令/POST /comments | /assign 无权限用户 | [权限][反向] /assign 指定非协作者返回 msg_not_allow_assign | 1. enable_issue_assign=true<br>2. Issue #{N5}.assignee=null<br>3. xiaoguozhi34 用户存在但非该仓库协作者（实测确认）<br>4. 实测 Robot 文案为英文 `This issue can not be assigned to ***%s***. Please try to assign to the repository members.` | 1. POST issues/{N5}/comments，Body：{"body":"/assign @xiaoguozhi34"}<br>2. 等待 12s<br>3. GET issues/{N5}<br>4. GET issues/{N5}/comments | 1. 评论 HTTP 200<br>2. 详情 assignee 保持原值（未被设为 xiaoguozhi34）<br>3. 评论列表新增 openeuler-ci-bot 评论，body 含 `This issue can not be assigned to ***xiaoguozhi34***. Please try to assign to the repository members.` |  | P1 | 高 |

```agent-exec
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_issue_number}}'
steps:
  - id: snapshot_assignee
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    capture_as:
      assignee_before: $.assignee.login
  - id: post_assign_non_member
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: /assign @xiaoguozhi34
    assertions:
      - http_status: 200
      - jsonpath: $.id
        not_empty: true
  - action: wait
    timeout_ms: 12000
  - id: get_issue
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        not_equals: xiaoguozhi34
      - jsonpath: $.assignee.login
        equals: '{{CAPTURE_assignee_before}}'
  - id: list_comments
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot')].body
        contains: 'can not be assigned to'
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot')].body
        contains: xiaoguozhi34
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot')].body
        contains: 'Please try to assign to the repository members'
```

| TC-API-CMD-008 | 评论命令/POST /comments | /assign 命令解析 | [参数合法性] /assign 命令前后含空格与换行可被正确解析 | 1. enable_issue_assign=true<br>2. Issue #{N8}.assignee=`Guangyue-Xu` | 1. POST issues/{N8}/comments，Body：{"body":"    /assign @weixin_55883847    "}（前后各 4 空格）<br>2. 等待 12s 并 GET issues/{N8}<br>3. 重置 assignee：POST issues/{N8}/comments，Body：{"body":"/unassign"} → 等待 12s（或 PATCH 重置）<br>4. POST issues/{N8}/comments，Body：{"body":"\n/assign @weixin_55883847\n"}<br>5. 等待 12s 并 GET issues/{N8} | 1. 两次操作后详情 assignee.login=`weixin_55883847`<br>2. Robot 日志含 command parsed 正常，无异常栈 |  | P2 | 中 |

```agent-exec
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_issue_number}}'
steps:
  - id: post_assign_with_spaces
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: '    /assign @weixin_55883847    '
    assertions:
      - http_status: 200
  - action: wait
    timeout_ms: 12000
  - id: verify_after_spaces
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: weixin_55883847
  - id: reset_via_unassign
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: /unassign
    assertions:
      - http_status: 200
  - action: wait
    timeout_ms: 12000
  - id: post_assign_with_newlines
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: "\n/assign @weixin_55883847\n"
    assertions:
      - http_status: 200
  - action: wait
    timeout_ms: 12000
  - id: verify_after_newlines
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: weixin_55883847
```

| TC-API-CMD-009 | 评论命令/POST /comments | /assign 命令解析 | [反向] 评论非命令格式时不触发分配 | 1. enable_issue_assign=true<br>2. Issue #{N9}.assignee=`weixin_55883847`（任一已知值） | 1. POST issues/{N9}/comments，Body：{"body":"请 @weixin_55883847 处理一下，谢谢"}<br>2. 等待 12s<br>3. GET issues/{N9}<br>4. GET issues/{N9}/comments | 1. 评论 HTTP 200<br>2. 详情 assignee.login 不变（仍 weixin_55883847）<br>3. 评论列表无 openeuler-ci-bot 新评论 |  | P1 | 中 |

```agent-exec
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_issue_number}}'
steps:
  - id: snapshot_assignee
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    capture_as:
      assignee_before: $.assignee.login
  - id: post_non_command
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: 请 @weixin_55883847 处理一下，谢谢
    assertions:
      - http_status: 200
      - jsonpath: $.id
        not_empty: true
    capture_as:
      comment_created_at: $.created_at
  - action: wait
    timeout_ms: 12000
  - id: verify_assignee_unchanged
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: '{{CAPTURE_assignee_before}}'
  - id: verify_no_bot_comment
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot' && @.created_at > '{{CAPTURE_comment_created_at}}')]
        length: 0
```

| TC-API-CMD-014 | 评论命令/POST /comments | /unassign 不带参数 | [正常流] /unassign 取消评论者自身负责人身份 | 1. enable_issue_assign=true<br>2. Issue #{N14}.assignee=`weixin_55883847`<br>3. PAT {{TOKEN}} 持有人 weixin_55883847 即当前负责人 | 1. POST issues/{N14}/comments，Body：{"body":"/unassign"}<br>2. 等待 12s<br>3. GET issues/{N14}<br>4. GET issues/{N14}/comments | 1. 评论 HTTP 200<br>2. 详情 assignee 变更：assignee=null 或被默认分配再次填充为 `Guangyue-Xu`（设计联动：无负责人即触发默认分配）<br>3. 评论列表中 openeuler-ci-bot 可能新增默认分配通知评论（属于设计联动，非附加错误） |  | P0 | 高 |

```agent-exec
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_issue_number}}'
steps:
  - id: precondition_check
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: weixin_55883847
  - id: post_unassign
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: /unassign
    assertions:
      - http_status: 200
  - action: wait
    timeout_ms: 12000
  - id: verify_assignee_changed
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      # 通过：assignee 为 null（unassign 生效）或被默认分配填为 Guangyue-Xu（联动），不应仍为 weixin_55883847
      - jsonpath: $.assignee.login
        not_equals: weixin_55883847
      - jsonpath: $.assignee.login
        in: [null, 'Guangyue-Xu']
```

| TC-API-CMD-016 | 评论命令/POST /comments | /unassign 非当前负责人 | [反向] /unassign @非当前负责人时回复 msg_not_allow_unassign | 1. enable_issue_assign=true<br>2. Issue #{N16}.assignee=`weixin_55883847`<br>3. 实测 Robot 文案为英文 `***%s*** can not be unassigned from this issue. Please try to unassign the assignee of this issue.` | 1. POST issues/{N16}/comments，Body：{"body":"/unassign @Guangyue-Xu"}<br>2. 等待 12s<br>3. GET issues/{N16}<br>4. GET issues/{N16}/comments | 1. 评论 HTTP 200<br>2. 详情 assignee.login 仍为 `weixin_55883847`<br>3. 评论列表新增 openeuler-ci-bot 评论，body 含 `***Guangyue-Xu*** can not be unassigned from this issue. Please try to unassign the assignee of this issue.` |  | P1 | 高 |

```agent-exec
type: api
tool: curl
inputs:
  number: '{{USER_INPUT_issue_number}}'
steps:
  - id: precondition_check
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: weixin_55883847
  - id: post_unassign_other
    request:
      method: POST
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        Content-Type: application/json
        PRIVATE-TOKEN: '{{TOKEN}}'
      body:
        body: /unassign @Guangyue-Xu
    assertions:
      - http_status: 200
  - action: wait
    timeout_ms: 12000
  - id: verify_assignee_unchanged
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $.assignee.login
        equals: weixin_55883847
  - id: verify_bot_reject_comment
    request:
      method: GET
      url: https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{{inputs.number}}/comments
      headers:
        PRIVATE-TOKEN: '{{TOKEN}}'
    assertions:
      - http_status: 200
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot')].body
        contains: 'can not be unassigned from this issue'
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot')].body
        contains: Guangyue-Xu
      - jsonpath: $[?(@.user.login=='openeuler-ci-bot')].body
        contains: 'Please try to unassign the assignee of this issue'
```

## 二、覆盖矩阵

| 功能点 \ 维度 | 1 正常流 | 2 异常 | 3 边界 | 4 空值 | 5 特殊字符 | 6 权限 | 7 唯一性 | 8 重复 | 9 异常输入 | 备注 |
|---|---|---|---|---|---|---|---|---|---|---|
| 创建 Issue 默认分配 | — | ✓(002) | — | — | — | — | N/A | — | — | 本筛选集只含已通过用例，正常流默认分配未在此集合（属 TC-API-ASSIGN-001，本轮不通过） |
| PATCH 更新 Issue | — | ✓(006) | — | — | — | — | N/A | — | — | 仅验证不重复触发默认分配 |
| /assign 命令 | ✓(001) | ✓(009) | — | — | — | ✓(005) | ✓(004) | — | ✓(008) | 多维度仅本筛选集覆盖部分 |
| /unassign 命令 | ✓(014) | ✓(016) | — | — | — | — | — | — | — | 同上 |

## 三、AI 执行说明

### 3.1 执行入口

AI（如 Claude Code）读取本文档时，按顺序解析每条用例下方的 `agent-exec` 代码块（YAML 格式），转换为 Bash 工具调用。每个块代表一条独立用例的完整执行流。

### 3.2 占位符注入

执行前必须注入以下占位符：

| 占位符 | 来源 | 说明 |
|---|---|---|
| `{{TOKEN}}` | 环境变量 / 用户提供 | gitcode Personal Access Token，至少 issues / user 权限 |
| `{{USER_INPUT_issue_number}}` | 用户提供 | 多步骤用例所需的存量 Issue number（如 `18`） |
| `{{USER_INPUT_existing_issue_number}}` | 用户提供 | 同上 |
| `{{CAPTURE_<key>}}` | 前序步骤 `capture_as` 字段输出 | 用例内自动传递 |

### 3.3 多步骤执行流

`agent-exec` 中 `steps:` 数组按序执行：

1. **`request` 类型步骤**：组装 curl 命令并发送，抓取 HTTP 状态码 + 响应 body
2. **`action: wait` 类型步骤**：sleep `timeout_ms / 1000` 秒（不发送请求）
3. 每步执行后立刻评估其 `assertions`；任一断言失败则用例标记「不通过」，但仍继续执行后续步骤以收集证据
4. 跨步骤数据通过 `capture_as` 与 `{{CAPTURE_<key>}}` 占位符传递

### 3.4 curl 模板

`type: api / tool: curl` 块的标准转换示例：

```bash
# 单次 POST 调用
curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "PRIVATE-TOKEN: ${TOKEN}" \
  -d '{"repo":"test-feature","title":"...","body":"..."}' \
  "https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues" \
  -w "\nHTTP=%{http_code}\n"
```

### 3.5 JSONPath 断言

`jsonpath` 断言使用标准 JSONPath 语法（`$.` 为根）。常用操作符：

| 操作符 | 含义 |
|---|---|
| `equals` / `not_equals` | 严格相等 |
| `contains` / `not_contains` | 子串包含 |
| `in` | 取值属于枚举集合 |
| `not_empty` | 非空 / 非 null |
| `length` | 数组或字符串长度 |
| `min_length` / `max_length` | 字符串长度边界 |
| `type` | string / number / boolean / array / object |

涉及数组过滤的复杂表达式（如 `$[?(@.user.login=='openeuler-ci-bot' && @.created_at > '...')]`）建议在 AI 端用 Python `json` + 列表推导实现，避免依赖特定 JSONPath 库的方言差异。

### 3.6 执行结果记录格式

每条用例执行结束后输出标准化结果：

```yaml
case_id: TC-API-CMD-001
status: 通过 | 不通过 | 阻塞 | 未执行
http_results:
  - step: post_assign
    http_status: 200
    failed_assertions: []
  - step: get_issue
    http_status: 200
    failed_assertions: []
defect:                            # 仅 status=不通过 时填写
  description: ...
  severity: 致命 | 严重 | 一般 | 轻微 | 建议
  fix_suggestion: ...
```

### 3.7 推荐执行顺序

1. 准备阶段：创建 1 个全新 Issue（POST /issues 不带 assignee）→ 记录其 number 作为 `{{USER_INPUT_issue_number}}`，并等待 Robot 完成默认分配
2. 优先级 P0 用例（TC-API-ASSIGN-002、TC-API-CMD-001、TC-API-CMD-014）
3. 优先级 P1 用例（TC-API-ASSIGN-006、TC-API-CMD-004、TC-API-CMD-005、TC-API-CMD-009、TC-API-CMD-016）
4. 优先级 P2 用例（TC-API-CMD-008）
5. 收尾阶段：关闭本轮创建的所有测试 Issue，避免污染仓库

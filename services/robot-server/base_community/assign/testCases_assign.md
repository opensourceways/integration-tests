# 测试用例集：Universal Issue Assign Robot（接口用例版）

> 输入文档：D:\gxz\ai_gxz\robot\designDoc.md
> 被测对象：Universal Issue Assign Robot（自动分配 Issue 负责人 + 自动归集 Issue 到看板）
> 被测仓库：https://gitcode.com/openeuler-test/test-feature
> 测试方式：通过 gitcode 平台公开 API 调用模拟用户行为，触发机器人对应 Webhook 处理逻辑
> 用例总数：35 条 ｜ P0：10 ｜ P1：16 ｜ P2：7 ｜ P3：2
> 经验补充：3 条（待评审）
> 指派目标用户：xiaoguozhi34（用例中所有指派对象统一为该用户）
> 覆盖维度自检：见末尾覆盖矩阵

## 通用接口说明（用例步骤中复用，不重复书写）

> 以下 API 路径基于 gitcode 平台通用 OpenAPI 风格约定（Gitee 兼容形态），具体路径以 gitcode 官方文档为准；若实际域名/版本号不同需替换。详见末尾「需补充信息」。

| 操作 | Method | URL 模板 |
|---|---|---|
| 创建 Issue | POST | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues` |
| 获取 Issue 详情 | GET | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{number}` |
| 更新 Issue | PATCH | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{number}` |
| 关闭 Issue | PATCH | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{number}` body: `{"state":"closed"}` |
| 评论 Issue | POST | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{number}/comments` |
| 编辑评论 | PATCH | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/comments/{commentId}` |
| 查询 Issue 评论列表 | GET | `https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{number}/comments` |
| 查询组织看板列表 | GET | `https://api.gitcode.com/api/v5/orgs/openeuler-test/dashboards` |
| 查询看板下 Issue | GET | `https://api.gitcode.com/api/v5/orgs/openeuler-test/dashboards/{dashboardId}/issues` |

通用请求头（除特别声明外，所有请求均带）：
- `Content-Type: application/json`
- `Authorization: token <PERSONAL_ACCESS_TOKEN>`（创建/评论用 `gxz-reporter` 的 PAT；越权场景另用 outsider PAT）
- `User-Agent: api-test/1.0`

## Assign Robot 用例列表

| 用例ID | 所属模块 | 功能点 | 测试标题 | 前置条件 | 操作步骤 | 预期结果 | 实际结果 | 优先级 | 重要等级 |
|---|---|---|---|---|---|---|---|---|---|
| TC-API-ASSIGN-002 | 自动分配/POST /issues | 创建 Issue 自动分配默认负责人 | [反向] 创建时 body 已含 assignee 时不覆盖 | 1. repoConfig.default_assignee=`xiaoguozhi34`<br>2. 用户 `xiaoguozhi34` 与 `gxz-tester02` 均为协作者 | 1. POST https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues<br>2. Headers：同通用<br>3. Body：{"title":"TC-API-ASSIGN-002 已指派不覆盖","body":"...","assignee":"gxz-tester02"}<br>4. 发送，记录 number<br>5. 等待 10 秒<br>6. GET issues/{number}<br>7. GET issues/{number}/comments | 1. 创建 HTTP 201<br>2. 详情 body.assignee.login=`gxz-tester02`，非 xiaoguozhi34<br>3. 评论列表无机器人默认分配评论<br>4. Robot 日志含 currentAssignee not empty, skip default |  | P0 | 高 |
| TC-API-ASSIGN-006 | 自动分配/POST /issues | 创建 Issue 自动分配默认负责人 | [反向][联动] PATCH 更新 Issue 不触发默认分配 | 1. repoConfig.default_assignee=`xiaoguozhi34`<br>2. 已存在 Issue #{N}（不带 assignee 直接 PATCH 出来的存量数据，assignee 为 null） | 1. PATCH https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{N}<br>2. Headers：同通用<br>3. Body：{"title":"TC-API-ASSIGN-006 更新触发","body":"updated body"}<br>4. 等待 10 秒<br>5. GET issues/{N}<br>6. GET issues/{N}/comments | 1. PATCH HTTP 200<br>2. 详情 assignee 仍为 null<br>3. 评论列表无机器人新增评论<br>4. Robot 日志含 update event ignored for default assign |  | P1 | 中 |
| TC-API-CMD-001 | 评论命令/POST /comments | /assign 不带参数 | [正常流] /assign 无参时将评论者自身设为负责人 | 1. enable_issue_assign=true<br>2. 已创建 Issue #{N1}，assignee 为 null<br>3. PAT_XIAOGUOZHI34 持有评论权限 | 1. POST https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/{N1}/comments<br>2. Headers：Authorization: token {PAT_XIAOGUOZHI34}；Content-Type: application/json<br>3. Body：{"body":"/assign"}<br>4. 发送请求<br>5. 等待 10 秒<br>6. GET issues/{N1}<br>7. GET issues/{N1}/comments | 1. 评论创建 HTTP 201<br>2. 详情 assignee.login=`xiaoguozhi34`<br>3. 评论列表中无机器人附加评论（仅原 /assign 这条）<br>4. Robot 日志含 assign by self success |  | P0 | 高 |
| TC-API-CMD-004 | 评论命令/POST /comments | /assign 重复分配 | [反向][唯一性] 重复分配同一负责人返回 msg_assign_repeatedly | 1. enable_issue_assign=true<br>2. msg_assign_repeatedly=`%s 已经是负责人。`<br>3. Issue #{N4}.assignee=`xiaoguozhi34` | 1. POST issues/{N4}/comments<br>2. Body：{"body":"/assign @xiaoguozhi34"}<br>3. 等待 10 秒<br>4. GET issues/{N4}<br>5. GET issues/{N4}/comments | 1. 评论创建 HTTP 201<br>2. 详情 assignee.login 仍为 `xiaoguozhi34`<br>3. 评论列表新增机器人评论 body=`@xiaoguozhi34 已经是负责人。`<br>4. Robot 日志中未调用 PATCH issues 接口 |  | P1 | 中 |
| TC-API-CMD-005 | 评论命令/POST /comments | /assign 无权限用户 | [权限][反向] /assign 指定非协作者返回 msg_not_allow_assign | 1. enable_issue_assign=true<br>2. msg_not_allow_assign=`无法将负责人设置为 %s，请检查权限。`<br>3. Issue #{N5}.assignee=null<br>4. outsider-no-perm 用户存在但非协作者 | 1. POST issues/{N5}/comments<br>2. Body：{"body":"/assign @outsider-no-perm"}<br>3. 等待 10 秒<br>4. GET issues/{N5}<br>5. GET issues/{N5}/comments | 1. 评论创建 HTTP 201<br>2. 详情 assignee 为 null<br>3. 评论列表新增机器人评论 body=`无法将负责人设置为 @outsider-no-perm，请检查权限。` |  | P1 | 高 |
| TC-API-CMD-008 | 评论命令/POST /comments | /assign 命令解析 | [参数合法性] /assign 命令前后含空格与换行可被正确解析 | 1. enable_issue_assign=true<br>2. Issue #{N8}.assignee=null | 1. POST issues/{N8}/comments，Body：{"body":"    /assign @xiaoguozhi34    "}（前后各 4 空格）<br>2. 等待 10 秒并 GET issues/{N8}<br>3. PATCH issues/{N8}，Body：{"assignee":""}（重置）<br>4. 等待 5 秒<br>5. POST issues/{N8}/comments，Body：{"body":"\n/assign @xiaoguozhi34\n"}<br>6. 等待 10 秒并 GET issues/{N8} | 1. 两次操作后详情 assignee.login=`xiaoguozhi34`<br>2. Robot 日志含 command parsed 正常，无异常栈 |  | P2 | 中 |
| TC-API-CMD-009 | 评论命令/POST /comments | /assign 命令解析 | [反向] 评论非命令格式时不触发分配 | 1. enable_issue_assign=true<br>2. Issue #{N9}.assignee=null | 1. POST issues/{N9}/comments，Body：{"body":"请 @xiaoguozhi34 处理一下，谢谢"}<br>2. 等待 10 秒<br>3. GET issues/{N9}<br>4. GET issues/{N9}/comments | 1. 评论创建 HTTP 201<br>2. 详情 assignee 仍为 null<br>3. 评论列表无机器人新增评论 |  | P1 | 中 |
| TC-API-CMD-014 | 评论命令/POST /comments | /unassign 不带参数 | [正常流] /unassign 取消评论者自身负责人身份 | 1. enable_issue_assign=true<br>2. Issue #{N14}.assignee=`xiaoguozhi34`<br>3. 使用 PAT_XIAOGUOZHI34 | 1. POST issues/{N14}/comments<br>2. Headers：Authorization: token {PAT_XIAOGUOZHI34}<br>3. Body：{"body":"/unassign"}<br>4. 等待 10 秒<br>5. GET issues/{N14}<br>6. GET issues/{N14}/comments | 1. 评论创建 HTTP 201<br>2. 详情 assignee 为 null<br>3. 评论列表无机器人附加评论 |  | P0 | 高 |
| TC-API-CMD-016 | 评论命令/POST /comments | /unassign 非当前负责人 | [反向] /unassign @非当前负责人时回复 msg_not_allow_unassign | 1. enable_issue_assign=true<br>2. msg_not_allow_unassign=`无法取消 [%s] 的负责人身份，因其并非当前负责人。`<br>3. Issue #{N16}.assignee=`xiaoguozhi34` | 1. POST issues/{N16}/comments<br>2. Body：{"body":"/unassign @gxz-tester02"}<br>3. 等待 10 秒<br>4. GET issues/{N16}<br>5. GET issues/{N16}/comments | 1. 评论创建 HTTP 201<br>2. 详情 assignee.login 仍为 `xiaoguozhi34`<br>3. 评论列表新增机器人评论 body=`无法取消 [gxz-tester02] 的负责人身份，因其并非当前负责人。` |  | P1 | 高 |

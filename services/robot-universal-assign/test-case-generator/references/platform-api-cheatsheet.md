# 平台 API 速查

不同代码托管平台的端点、鉴权方式、字段差异较大，Robot 类用例必须针对实际平台填写。本文档列出常见平台的核心信息，**实际生成用例前仍需通过 Step 1 探测确认**。

## 鉴权头对照

| 平台 | 鉴权头 | 备注 |
|---|---|---|
| gitcode | `PRIVATE-TOKEN: {{TOKEN}}` | 实测；`Authorization: token` 形式被拒绝 |
| gitee | `Authorization: token {{TOKEN}}` 或 query `?access_token={{TOKEN}}` | 两种均可 |
| github | `Authorization: Bearer {{TOKEN}}` | 推荐 Bearer；`token <PAT>` 仍兼容 |
| atomgit | 详见平台文档（社区公开度有限） | 探测前请确认 |
| gitlab（含自建） | `PRIVATE-TOKEN: {{TOKEN}}` | 与 gitcode 一致 |

## 核心端点对照（Issue 与评论场景）

| 操作 | gitcode (api/v5) | gitee (api/v5) | github (api) | gitlab (api/v4) |
|---|---|---|---|---|
| 创建 Issue | POST `/repos/{o}/{r}/issues`（body 必含 `repo`） | POST `/repos/{o}/{r}/issues`（body 必含 `repo`） | POST `/repos/{o}/{r}/issues` | POST `/projects/{id}/issues` |
| 获取 Issue | GET `/repos/{o}/{r}/issues/{n}` | GET `/repos/{o}/{r}/issues/{n}` | GET `/repos/{o}/{r}/issues/{n}` | GET `/projects/{id}/issues/{iid}` |
| 更新 Issue | PATCH `/repos/{o}/{r}/issues/{n}` | PATCH `/repos/{o}/issues/{n}` | PATCH `/repos/{o}/{r}/issues/{n}` | PUT `/projects/{id}/issues/{iid}` |
| 评论 | POST `/repos/{o}/{r}/issues/{n}/comments` | POST `/repos/{o}/{r}/issues/{n}/comments` | POST `/repos/{o}/{r}/issues/{n}/comments` | POST `/projects/{id}/issues/{iid}/notes` |
| 列评论 | GET `/repos/{o}/{r}/issues/{n}/comments` | GET `/repos/{o}/{r}/issues/{n}/comments` | GET `/repos/{o}/{r}/issues/{n}/comments` | GET `/projects/{id}/issues/{iid}/notes` |
| 编辑评论 | PATCH `/repos/{o}/{r}/issues/comments/{cid}` | PATCH `/repos/{o}/comments/{cid}` | PATCH `/repos/{o}/{r}/issues/comments/{cid}` | PUT `/projects/{id}/issues/{iid}/notes/{nid}` |

## HTTP 状态码与字段差异

| 平台 | 创建 Issue 成功状态码 | Issue 编号字段 | Issue 类型字段 |
|---|---|---|---|
| gitcode | **200** | `number`（字符串） | `issue_type`（中文枚举：任务/CVE和安全问题/...） |
| gitee | 201 | `number`（字符串） | `issue_type`（中文/英文枚举混合） |
| github | 201 | `number`（数字） | 无原生字段，通过 `labels` 实现 |
| gitlab | 201 | `iid`（数字） | 无原生字段，通过 `labels` 实现 |

## 组织级看板 / 项目板

| 平台 | 端点 | 备注 |
|---|---|---|
| gitcode | `/orgs/{o}/dashboards` 实测 **404** | 无组织看板能力，看板归集类用例不可生成 |
| gitee | `/orgs/{o}/projects` | 有组织项目，能力有限 |
| github | `/orgs/{o}/projects` 已废弃；新版 GraphQL `Projects v2` | 需 GraphQL，非 REST |
| gitlab | `/projects/{id}/boards` | 项目级，无组织级 |

## Webhook 事件名（影响 Robot 触发）

| 平台 | Issue 创建 | Issue 更新 | 评论创建 | 评论更新 |
|---|---|---|---|---|
| gitcode / gitee | `Issue Hook` action=open | `Issue Hook` action=update | `Note Hook` action=comment | 视具体平台支持 |
| github | `issues` action=opened | `issues` action=edited | `issue_comment` action=created | `issue_comment` action=edited |
| gitlab | `Issue Hook` action=open | `Issue Hook` action=update | `Note Hook` | — |

## 速查 curl 模板（gitcode）

```bash
# 创建 Issue
curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "PRIVATE-TOKEN: ${TOKEN}" \
  -d '{"repo":"test-feature","title":"...","body":"..."}' \
  "https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues"

# 评论 Issue
curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "PRIVATE-TOKEN: ${TOKEN}" \
  -d '{"body":"/assign @user"}' \
  "https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/18/comments"

# 列评论
curl -s -H "PRIVATE-TOKEN: ${TOKEN}" \
  "https://api.gitcode.com/api/v5/repos/openeuler-test/test-feature/issues/18/comments"
```

## 速查 curl 模板（github）

```bash
# 创建 Issue
curl -s -X POST \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -d '{"title":"...","body":"..."}' \
  "https://api.github.com/repos/owner/repo/issues"

# 评论 Issue
curl -s -X POST \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -d '{"body":"/assign @user"}' \
  "https://api.github.com/repos/owner/repo/issues/18/comments"
```

## 实测优先原则

任何与本文档不一致的实测结果，**以实测为准**。请在 Step 1 探测后将差异写入用例文档的「差异记录」小节，并在本 references 文档外暂时不要修改本表（除非用户要求更新通用速查）。

{
  "properties" : { },
  "id" : "4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a",
  "script" : null,
  "groupId" : "1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d",
  "name" : "筛选选项",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/filters",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ {
    "name" : "wrap_request_parameter",
    "value" : "disable-cache",
    "description" : "包装请求参数到一个变量中",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "permission",
    "value" : "datastatInfra_View,admin_token",
    "description" : "允许拥有该权限的访问（浏览器走 datastatInfra_View cookie 鉴权；机机接口带 api-key 走 admin_token）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"service\": [],\n        \"type\": [\"需求\", \"缺陷\", \"任务\", \"其他\"],\n        \"state\": [\"open\", \"closed\"],\n        \"assignee\": [],\n        \"title\": []\n    }\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 各列全量 distinct 候选值（用 string_agg 一次查出，逗号分隔串转数组）。
// 表头漏斗的候选项必须来自全量数据，而非当前页（后端分页后当页不全）。
// 数据源 fact_opensourceways_issue（限定 backlog 仓）。
// service 按 project:XXX label 派生的展示名取 distinct，与列表筛选/展示口径一致；
// assignee 取 assignees_user_names（逗号分隔）展开后 distinct，覆盖多负责人场景。
var r = db.selectOne("""
SELECT
  COALESCE((SELECT string_agg(DISTINCT substring(labels_name::text from 'project[:/]([^,}\]]+)'), ',')
            FROM fact_opensourceways_issue
            WHERE repo_name = 'backlog' AND COALESCE(is_removed,'0') <> '1'
              AND labels_name::text ILIKE '%project%'), '') AS service,
  COALESCE((SELECT string_agg(DISTINCT issue_type, ',' ORDER BY issue_type)
            FROM fact_opensourceways_issue
            WHERE repo_name = 'backlog' AND COALESCE(is_removed,'0') <> '1'
              AND issue_type IS NOT NULL AND issue_type <> ''), '') AS type,
  COALESCE((SELECT string_agg(DISTINCT state, ',' ORDER BY state)
            FROM fact_opensourceways_issue
            WHERE repo_name = 'backlog' AND COALESCE(is_removed,'0') <> '1'
              AND state IS NOT NULL AND state <> ''), '') AS state,
  COALESCE((SELECT string_agg(DISTINCT title, ',' ORDER BY title)
            FROM fact_opensourceways_issue
            WHERE repo_name = 'backlog' AND COALESCE(is_removed,'0') <> '1'
              AND title IS NOT NULL AND title <> ''), '') AS title,
  COALESCE((SELECT string_agg(DISTINCT COALESCE(u.user_name, t.login), ',' ORDER BY COALESCE(u.user_name, t.login))
            FROM (SELECT trim(unnest(string_to_array(btrim(assignees_user_names::text, '{}[]'), ','))) AS login
                  FROM fact_opensourceways_issue
                  WHERE repo_name = 'backlog' AND COALESCE(is_removed,'0') <> '1'
                    AND assignees_user_names IS NOT NULL AND assignees_user_names <> '') t
            LEFT JOIN (
              SELECT DISTINCT ON (user_login) user_login, user_name
              FROM fact_opensourceways_sig_user WHERE user_name IS NOT NULL AND user_name <> ''
            ) u ON t.login = u.user_login
            WHERE t.login IS NOT NULL AND t.login <> ''), '') AS assignee
""")
// 每列首位加 __EMPTY__ 哨兵：前端展示为「（空）」，选中后列表接口筛该字段为 NULL/'' 的行。
return {
  service: ['__EMPTY__'].concat((r.service != null && r.service != '') ? r.service.split(',') : []),
  type: ['__EMPTY__'].concat((r.type != null && r.type != '') ? r.type.split(',') : ['需求', '缺陷', '任务', '其他']),
  state: ['__EMPTY__'].concat((r.state != null && r.state != '') ? r.state.split(',') : ['open', 'closed']),
  assignee: ['__EMPTY__'].concat((r.assignee != null && r.assignee != '') ? r.assignee.split(',') : []),
  title: ['__EMPTY__'].concat((r.title != null && r.title != '') ? r.title.split(',') : [])
}

{
  "properties" : { },
  "id" : "2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e",
  "script" : null,
  "groupId" : "1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d",
  "name" : "需求列表",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/issues",
  "method" : "GET",
  "parameters" : [ {
    "name" : "service",
    "value" : "",
    "description" : "服务名多选筛选，逗号分隔（按展示名 service_name 匹配）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "type",
    "value" : "",
    "description" : "Issue 类型多选筛选，逗号分隔（需求/缺陷/任务/其他）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "state",
    "value" : "",
    "description" : "状态多选筛选，逗号分隔（open/closed）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "assignee",
    "value" : "",
    "description" : "负责人多选筛选，逗号分隔（按展示名 assignees_real_names 匹配）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "title",
    "value" : "",
    "description" : "标题多选筛选，逗号分隔（精确匹配标题值）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "accepted",
    "value" : "",
    "description" : "接纳筛选，逗号分隔，取值 accepted（已接纳）/ __EMPTY__（未接纳）；二值可单选或全选（全选=不筛）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "page",
    "value" : "1",
    "description" : "页码",
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : "page 必须 > 0",
    "expression" : "page > 0",
    "children" : [ ]
  }, {
    "name" : "pageSize",
    "value" : "20",
    "description" : "每页条数（上限 100）",
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "20",
    "validateType" : "expression",
    "error" : "pageSize 必须 > 0 且 <= 100",
    "expression" : "pageSize > 0 && pageSize <= 100",
    "children" : [ ]
  }, {
    "name" : "sortBy",
    "value" : "",
    "description" : "排序字段白名单：created_at/updated_at/closed_at/comments_count/title/issue_type/state/service_name",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "sortOrder",
    "value" : "",
    "description" : "排序方向 asc/desc",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "timeField",
    "value" : "",
    "description" : "时间筛选字段：created_at（创建时间）/ closed_at（关闭时间）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "startTime",
    "value" : "",
    "description" : "时间范围开始（毫秒时间戳），需与 timeField + endTime 同传",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  }, {
    "name" : "endTime",
    "value" : "",
    "description" : "时间范围结束（毫秒时间戳），需与 timeField + startTime 同传",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : [ ]
  } ],
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"list\": [],\n        \"total\": 0,\n        \"page\": 1,\n        \"pageSize\": 20\n    }\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var pageNum = (page != null && page > 0) ? page : 1
var ps = (pageSize != null && pageSize > 0) ? pageSize : 20
var off = ps * (pageNum - 1)

// 数据源：fact_opensourceways_issue（生产已有 backlog 全量 issue：label/责任人/状态/时间都在），
// 限定 backlog 仓（repo_name='backlog'）。service 不在该表，从 label 的 project:XXX 派生。
// 真实姓名不在 issue 表，LEFT JOIN fact_opensourceways_sig_user（数据源 user-info.yaml）按 user_login 去重取 user_name。
var baseSql = """
SELECT i.number AS issue_number, i.title, i.state, i.issue_type, i.html_url,
       i.user_login AS author_login, COALESCE(u.user_name, i.user_login) AS author_name,
       (SELECT string_agg(COALESCE(u2.user_name, t.login), ', ')
        FROM (SELECT trim(unnest(string_to_array(btrim(i.assignees_user_names::text, '{}[]'), ','))) AS login) t
        LEFT JOIN (
          SELECT DISTINCT ON (user_login) user_login, user_name
          FROM fact_opensourceways_sig_user WHERE user_name IS NOT NULL AND user_name <> ''
        ) u2 ON t.login = u2.user_login
        WHERE t.login IS NOT NULL AND t.login <> '') AS assignees,
       NULLIF(substring(i.labels_name::text from 'project[:/]([^,}\]]+)'), '') AS service_name,
       i.tag_sig_name AS sig_name,
       NULLIF(btrim(i.labels_name::text, '{}[]'), '') AS labels,
       (CASE WHEN EXISTS (SELECT 1 FROM unnest(string_to_array(btrim(i.labels_name::text, '{}[]'), ',')) elem
                          WHERE btrim(elem) = 'accepted')
             THEN 'accepted' ELSE NULL END) AS accepted,
       i.comments AS comments_count,
       i.created_at, i.updated_at, i.closed_at
FROM fact_opensourceways_issue i
LEFT JOIN (
  SELECT DISTINCT ON (user_login) user_login, user_name
  FROM fact_opensourceways_sig_user
  WHERE user_name IS NOT NULL AND user_name <> ''
) u ON i.user_login = u.user_login
WHERE i.repo_name = 'backlog' AND COALESCE(i.is_removed, '0') <> '1'
"""

// ── 筛选 WHERE（多列多选，前端传逗号分隔串 → ANY(string_to_array)；值经 #{param} 参数化，防注入）──
// 每列支持「空」选项：选中 __EMPTY__ 时同时匹配该字段为 NULL/'' 的行；regexp_replace 把 __EMPTY__ 从值列表里剔掉再 ANY。
// service/state/type/title 为单值列；assignee 存逗号分隔串，用数组重叠操作符 && 匹配多选。
var filters = []
if(service != null && service != ''){
    filters.push("((position('__EMPTY__' in #{service}) > 0 AND (base.service_name IS NULL OR base.service_name = '')) OR base.service_name = ANY(string_to_array(regexp_replace(#{service}, '__EMPTY__', '', 'g'), ',')))");
}
if(type != null && type != ''){
    filters.push("((position('__EMPTY__' in #{type}) > 0 AND (base.issue_type IS NULL OR base.issue_type = '')) OR base.issue_type = ANY(string_to_array(regexp_replace(#{type}, '__EMPTY__', '', 'g'), ',')))");
}
if(state != null && state != ''){
    filters.push("((position('__EMPTY__' in #{state}) > 0 AND (base.state IS NULL OR base.state = '')) OR base.state = ANY(string_to_array(regexp_replace(#{state}, '__EMPTY__', '', 'g'), ',')))");
}
if(title != null && title != ''){
    filters.push("((position('__EMPTY__' in #{title}) > 0 AND (base.title IS NULL OR base.title = '')) OR base.title = ANY(string_to_array(regexp_replace(#{title}, '__EMPTY__', '', 'g'), ',')))");
}
if(assignee != null && assignee != ''){
    filters.push("((position('__EMPTY__' in #{assignee}) > 0 AND (base.assignees IS NULL OR base.assignees = '')) OR (base.assignees IS NOT NULL AND string_to_array(base.assignees, ',') && string_to_array(regexp_replace(#{assignee}, '__EMPTY__', '', 'g'), ',')))");
}
// 接纳筛选：二值列。wantAcc(选中 accepted) / wantEmpty(选中 __EMPTY__)：只选一个才生效，都选=不筛。
// 直接对 JS 参数串做子串判断（值固定，不存在注入面），筛 base.accepted 派生列。
if(accepted != null && accepted != ''){
    var wantAcc = accepted.indexOf('accepted') >= 0
    var wantEmpty = accepted.indexOf('__EMPTY__') >= 0
    if(wantAcc && !wantEmpty){ filters.push("base.accepted IS NOT NULL") }
    else if(!wantAcc && wantEmpty){ filters.push("base.accepted IS NULL") }
}
// ── 时间范围（timeField 白名单二选一：created_at/closed_at；startTime/endTime 为毫秒时间戳）──
var timeCol = ""
if(timeField == "closed_at"){ timeCol = "base.closed_at" }
else if(timeField == "created_at"){ timeCol = "base.created_at" }
if(timeCol != "" && startTime != null && endTime != null){
    filters.push(timeCol + " >= to_timestamp(#{startTime}/1000.0) AND " + timeCol + " <= to_timestamp(#{endTime}/1000.0)")
}
var whereSql = filters.length > 0 ? (" WHERE " + filters.join(" AND ")) : ""

// ── 排序 ORDER BY（白名单映射：列名不能参数化，硬编码白名单，sortBy 仅用于 if 比较；同值次序 created_at DESC）──
var asc = (sortOrder == "asc")
var orderExpr = "base.created_at DESC"
if(sortBy == "created_at"){ orderExpr = asc ? "base.created_at ASC" : "base.created_at DESC"; }
else if(sortBy == "updated_at"){ orderExpr = asc ? "base.updated_at ASC" : "base.updated_at DESC"; }
else if(sortBy == "closed_at"){ orderExpr = asc ? "base.closed_at ASC NULLS LAST" : "base.closed_at DESC NULLS LAST"; }
else if(sortBy == "comments_count"){ orderExpr = asc ? "base.comments_count ASC, base.created_at DESC" : "base.comments_count DESC, base.created_at DESC"; }
else if(sortBy == "title"){ orderExpr = asc ? "base.title ASC, base.created_at DESC" : "base.title DESC, base.created_at DESC"; }
else if(sortBy == "issue_type"){ orderExpr = asc ? "base.issue_type ASC, base.created_at DESC" : "base.issue_type DESC, base.created_at DESC"; }
else if(sortBy == "state"){ orderExpr = asc ? "base.state ASC, base.created_at DESC" : "base.state DESC, base.created_at DESC"; }
else if(sortBy == "service_name"){ orderExpr = asc ? "base.service_name ASC NULLS LAST, base.created_at DESC" : "base.service_name DESC NULLS LAST, base.created_at DESC"; }

var listSql = "SELECT * FROM (" + baseSql + ") base " + whereSql + " ORDER BY " + orderExpr + " LIMIT #{ps} OFFSET #{off}"
var countSql = "SELECT count(*) AS total FROM (" + baseSql + ") base " + whereSql

var list = db.select(listSql)
var total = db.selectOne(countSql).get("total")
HashMap result = new HashMap()
result.put("list", list)
result.put("total", total)
result.put("page", pageNum)
result.put("pageSize", ps)
return result

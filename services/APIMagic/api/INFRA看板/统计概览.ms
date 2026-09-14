{
  "properties" : { },
  "id" : "3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f",
  "script" : null,
  "groupId" : "1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d",
  "name" : "统计概览",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/summary",
  "method" : "GET",
  "parameters" : [ {
    "name" : "service",
    "value" : "",
    "description" : "服务名多选筛选，逗号分隔（含 __EMPTY__ 表示筛无服务的）",
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
    "description" : "状态多选筛选，逗号分隔（含 __EMPTY__ 表示筛无状态的）",
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
    "description" : "时间筛选字段：created_at / closed_at",
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
    "description" : "时间范围开始（毫秒时间戳）",
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
    "description" : "时间范围结束（毫秒时间戳）",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 0,\n        \"open\": 0,\n        \"closed\": 0,\n        \"by_type\": [],\n        \"by_service\": []\n    }\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 数据源：fact_opensourceways_issue（生产已有 backlog 全量 issue），限定 backlog 仓。
// service 从 label 的 project:XXX 派生（该表无 service 列）。
// 与列表接口同口径接受 service / timeField / startTime / endTime 筛选，汇总随筛选联动。
var conds = ["repo_name = 'backlog'", "COALESCE(is_removed, '0') <> '1'"]
if(service != null && service != ''){
    conds.push("((position('__EMPTY__' in #{service}) > 0 AND substring(labels_name::text from 'project[:/]([^,}\]]+)') IS NULL) OR substring(labels_name::text from 'project[:/]([^,}\]]+)') = ANY(string_to_array(regexp_replace(#{service}, '__EMPTY__', '', 'g'), ',')))")
}
if(state != null && state != ''){
    conds.push("((position('__EMPTY__' in #{state}) > 0 AND (state IS NULL OR state = '')) OR state = ANY(string_to_array(regexp_replace(#{state}, '__EMPTY__', '', 'g'), ',')))")
}
var timeCol = ""
if(timeField == "closed_at"){ timeCol = "closed_at" }
else if(timeField == "created_at"){ timeCol = "created_at" }
if(timeCol != "" && startTime != null && endTime != null){
    conds.push(timeCol + " >= to_timestamp(#{startTime}/1000.0) AND " + timeCol + " <= to_timestamp(#{endTime}/1000.0)")
}
var w = conds.join(" AND ")

var stateSql = """
SELECT state, count(*) AS count
FROM fact_opensourceways_issue
WHERE """ + w + """
GROUP BY state
"""
var typeSql = """
SELECT issue_type AS type, count(*) AS count
FROM fact_opensourceways_issue
WHERE """ + w + """
GROUP BY issue_type
"""
var serviceSql = """
SELECT NULLIF(substring(labels_name::text from 'project[:/]([^,}\]]+)'), '') AS service_key,
       NULLIF(substring(labels_name::text from 'project[:/]([^,}\]]+)'), '') AS service_name,
       count(*) AS count
FROM fact_opensourceways_issue
WHERE """ + w + """
  AND labels_name::text ILIKE '%project%'
GROUP BY 1, 2
ORDER BY count DESC
"""
// 负责人 × issue 数：assignees_user_names 存的是 user_login，unnest 后 LEFT JOIN sig_user
// （user-info.yaml 真名）解析成真实姓名再按人聚合；不再 LIMIT 15，返回全部负责人，
// 由前端柱状图用 dataZoom 滚轮缩放查看（#1530）。
var assigneeSql = """
SELECT COALESCE(u.user_name, t.login) AS name, count(*) AS count
FROM (
  SELECT trim(unnest(string_to_array(btrim(assignees_user_names::text, '{}[]'), ','))) AS login
  FROM fact_opensourceways_issue
  WHERE """ + w + """
    AND assignees_user_names IS NOT NULL AND btrim(assignees_user_names::text, '{}[]') <> ''
) t
LEFT JOIN (
  SELECT DISTINCT ON (user_login) user_login, user_name
  FROM fact_opensourceways_sig_user WHERE user_name IS NOT NULL AND user_name <> ''
) u ON t.login = u.user_login
WHERE t.login IS NOT NULL AND t.login <> ''
GROUP BY COALESCE(u.user_name, t.login)
ORDER BY count DESC
"""
var stateRows = db.select(stateSql)
var typeRows = db.select(typeSql)
var serviceRows = db.select(serviceSql)
var assigneeRows = db.select(assigneeSql)
var total = 0
var openCount = 0
var closedCount = 0
for (row in stateRows) {
    total = total + row["count"]
    if ("open" == row["state"]) {
        openCount = row["count"]
    } else if ("closed" == row["state"]) {
        closedCount = row["count"]
    }
}
HashMap result = new HashMap()
result.put("total", total)
result.put("open", openCount)
result.put("closed", closedCount)
result.put("by_type", typeRows)
result.put("by_service", serviceRows)
result.put("by_assignee", assigneeRows)
return result

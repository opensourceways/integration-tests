{
  "properties" : { },
  "id" : "569eb23cd8694e90be99b3d8d912a74b",
  "script" : null,
  "groupId" : "24e4ef78cdc04b758533330015c64bf1",
  "name" : "维护率同比",
  "createTime" : null,
  "updateTime" : 1773816353644,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "status/on/{interval}",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openeuler",
    "validateType" : "pattern",
    "error" : "community 必须是纯字母，长度1-32",
    "expression" : "^[a-zA-Z]{1,32}$?",
    "children" : null
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ {
    "name" : "interval",
    "value" : "quarter",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "interval 只能是 year、month、week、day",
    "expression" : "^(year|month|week|day|quarter)$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": -0.010875165,\n    \"timestamp\": 1765782605579,\n    \"executeTime\": 1866\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
if (interval == 'quarter') {
    interval = '3 months'
}
else {
    interval = '1 ' + interval
}
var sqlstr = """
WITH time_range AS (
    SELECT 
        max(created_at) AS base_date, 
        min(created_at) AS last_date 
    FROM dws_${community}_package_status
    WHERE created_at >= (CURRENT_DATE - CAST(#{interval} AS interval)) AND level = 'L1'
)
SELECT
    dcpc.created_at,
    count(distinct repo_path) FILTER (WHERE status in ('健康', '活跃')) AS effect,
    count(distinct repo_path) AS total
FROM dws_${community}_package_status dcpc
WHERE kind <> 'epol' AND (dcpc.created_at = (SELECT base_date FROM time_range)
   OR dcpc.created_at = (SELECT last_date FROM time_range))
GROUP BY dcpc.created_at
ORDER BY dcpc.created_at DESC;
"""
var result = db.select(sqlstr)
var ratio = []
result.each(it => ratio.add(it.effect/it.total::float))
return result.getLength() == 0 ? 0 : ratio[0] - ratio[1]

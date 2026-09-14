{
  "properties" : { },
  "id" : "d80a7f40ffb44e1caf706b5cbe93c881",
  "script" : null,
  "groupId" : "24e4ef78cdc04b758533330015c64bf1",
  "name" : "维护率",
  "createTime" : null,
  "updateTime" : 1753844850203,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/status",
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
    "expression" : "^[a-zA-Z]{1,32}$?"
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
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"status\": \"健康\",\n        \"repos\": 2784,\n        \"percent\": 0.5568\n    }, {\n        \"status\": \"活跃\",\n        \"repos\": 2034,\n        \"percent\": 0.4068\n    }, {\n        \"status\": \"缺人维护\",\n        \"repos\": 182,\n        \"percent\": 0.0364\n    }],\n    \"timestamp\": 1750820896921,\n    \"executeTime\": 24\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT
    CASE
        WHEN status in ('健康', '活跃') THEN '健康+活跃'
        ELSE status
    END AS pkg_status,
    count(distinct repo_path) AS repos
FROM dws_${community}_package_status
WHERE kind <> 'epol' AND created_at = (SELECT max(created_at) FROM dws_${community}_package_status)
GROUP BY pkg_status;
"""
var result = db.select(sqlstr)
var count = 0::float
result.each(it => count += it.repos)
result.each(it => it['percent'] = it.repos/count)
return result

{
  "properties" : { },
  "id" : "947f268484704090ab58281ef818fe72",
  "script" : null,
  "groupId" : "268543ec55cc4a40890f6229f0450ef9",
  "name" : "健康检查接口",
  "createTime" : null,
  "updateTime" : 1766735522371,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/healthz",
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"timestamp\": \"2025-12-26 15:51:56\",\n    \"status\": 404,\n    \"error\": \"Not Found\",\n    \"path\": \"/check/healthz\"\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sql = """
SELECT
    alias_name
FROM dim_company_info
WHERE alias_name = 'huawei'
"""
return db.select(sql)[0]['alias_name']

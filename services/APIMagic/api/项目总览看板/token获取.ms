{
  "properties" : { },
  "id" : "41ec64b8b9504d06818c1cde9d26147a",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "token获取",
  "createTime" : null,
  "updateTime" : 1778725550730,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/token/query",
  "method" : "GET",
  "parameters" : [ {
    "name" : "token",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
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
  }, {
    "name" : "permission",
    "value" : "datastatsend_email",
    "description" : "允许拥有该权限的访问",
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
  "responseBody" : "{\n    \"code\": 403,\n    \"message\": \"用户没有权限\",\n    \"data\": null,\n    \"timestamp\": 1778725148838,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var token_sql = """
SELECT
    token
FROM fact_token
WHERE platform = 'hotspot'
"""
return db.selectOne(token_sql).get("token");
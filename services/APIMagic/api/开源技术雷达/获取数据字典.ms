{
  "properties" : { },
  "id" : "61a7cf12735245ef977ecfd2a365fc23",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "获取数据字典",
  "createTime" : null,
  "updateTime" : 1777423884537,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/dict",
  "method" : "GET",
  "parameters" : [ {
    "name" : "type",
    "value" : "month",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^(month|type|ring|algorithm)$",
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
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 403,\n    \"message\": \"用户没有权限\",\n    \"data\": null,\n    \"timestamp\": 1776913760957,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var type = type;
var sql = """   select DISTINCT ${type} as label, ${type} as value,${type} as id FROM fact_repo_insight_data order by ${type} """
return   db.select(sql);

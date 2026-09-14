{
  "properties" : { },
  "id" : "f46074fa764548579a4376cc3fbf62fb",
  "script" : null,
  "groupId" : "9af308d96b55470faeda3c9b3357f836",
  "name" : "获取组织列表",
  "createTime" : null,
  "updateTime" : 1775544291572,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/group/list",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "1",
    "value" : "1",
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"timestamp\": \"2026-04-07 14:43:31\",\n    \"status\": 500,\n    \"error\": \"Internal Server Error\",\n    \"path\": \"/meeting/group/list\"\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var table_name = `fact_${community}_organization_member`

var sqlstr = """
SELECT
    ARRAY_AGG(distinct group_name) as groups
FROM
    ${table_name} t
"""

var resp = db.select(sqlstr)[0].groups.getArray()

var ans = Arrays.asList(resp)
return ans

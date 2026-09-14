{
  "properties" : { },
  "id" : "e4eb48992adb44a1830c7db27761e49d",
  "script" : null,
  "groupId" : "d483565aa9094ad0ba882199e9e1fa17",
  "name" : "获取用户信息",
  "createTime" : null,
  "updateTime" : 1776759913367,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/userinfo",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(openeuler|opengauss|mindspore|openubmc|openfuyao)$",
    "children" : null
  }, {
    "name" : "page",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "pageSize",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "10",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "platform",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "gitcode",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(gitee|gitcode|github)?$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1769390573042,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var off = (page - 1) * pageSize
var sqlstr = """
SELECT 
    doc.user_login,
    doc.company_type,
    fe.email
FROM 
    dws_${community}_${platform}_contribute doc
left join 
    fact_${platform}_email_login fe
on
    doc.user_login = fe.user_login
WHERE doc.is_removed is null
GROUP BY 
    doc.user_login, doc.company_type, fe.email
ORDER BY doc.user_login asc
LIMIT #{pageSize} OFFSET #{off};"""
var resp = db.select(sqlstr)
return resp

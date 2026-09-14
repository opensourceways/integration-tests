{
  "properties" : { },
  "id" : "copy1773024891935d82030",
  "script" : null,
  "groupId" : "9b8fc487d76946a88319e081fa47f446",
  "name" : "导师或者学生贡献值",
  "createTime" : null,
  "updateTime" : 1773025146851,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/contribute/detail",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "type",
    "value" : "tutor_login",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(tutor_login|student_login)$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"issue_total\": 136,\n        \"approved_issues\": 21,\n        \"got_issues\": 62,\n        \"completed_issues\": 38\n    }],\n    \"timestamp\": 1773023967608,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var community_tem = community
var type_tem = type
var sql = """SELECT 
	${type_tem},
    count(DISTINCT html_url) metric 
FROM 
    fact_${community_tem}_practice
where ${type_tem} is not null
GROUP BY ${type_tem} 
order by metric
 """
return db.select(sql)

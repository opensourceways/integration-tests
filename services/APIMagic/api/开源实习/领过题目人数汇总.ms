{
  "properties" : { },
  "id" : "copy1773023934891d49522",
  "script" : null,
  "groupId" : "9b8fc487d76946a88319e081fa47f446",
  "name" : "领过题目人数汇总",
  "createTime" : null,
  "updateTime" : 1773024168425,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/got/issue/total",
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
var sql = """SELECT 
    count(DISTINCT html_url) issue_total,'出题总数' as issue_total_name,
    COUNT(DISTINCT html_url) FILTER (WHERE status = '导师审核通过') AS approved_issues,'已通过数' as approved_issues_name,
    COUNT(DISTINCT html_url) FILTER (WHERE assign_user is not null) AS got_issues,'已领取数' as got_issues_name,
    COUNT(DISTINCT html_url) FILTER (WHERE status = '已完成') AS completed_issues,'已完成数' as completed_issues_name
FROM 
    fact_${community_tem}_practice
 """
return db.select(sql)

{
  "properties" : { },
  "id" : "33dd47065f9b4e8d9d8d68897215a1b6",
  "script" : null,
  "groupId" : "167a3de74ad940eeb846096b64fc127f",
  "name" : "开源实习",
  "createTime" : null,
  "updateTime" : 1767491852397,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{platform}/practice",
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
  "paths" : [ {
    "name" : "platform",
    "value" : "gitee",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(gitee|github)$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"count\": 28\n    },\n    \"timestamp\": 1764727456657,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
import '@/util/auth/userinfo' as userinfo
import '@/util/extract_community_from_referer' as get_community
var referer = header.referer
var community = get_community(referer)
var user = userinfo(referer)
var sqlstr =  """
SELECT user_login, task_num, complete_task_num, rank, beat_percent, task_point
FROM dws_${community}_practice
WHERE platform = #{platform} AND user_login = #{user};
"""
var resp = db.select(sqlstr)
return resp[0]

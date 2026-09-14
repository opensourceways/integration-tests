{
  "properties" : { },
  "id" : "cb46e3f984964c979ecb042e05d73ef7",
  "script" : null,
  "groupId" : "167a3de74ad940eeb846096b64fc127f",
  "name" : "用户个人报告",
  "createTime" : null,
  "updateTime" : 1767491705731,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/user/{platform}",
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
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1767491703144,\n    \"executeTime\": 128\n}",
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
SELECT user_login, first_time_of_enter, pr_num, issue_num, comment_num, code_num, star_num, watch_num, fork_num, repo_num, forum_topic_num,
       contact_persons, user_login_with_most_contact, most_participate_of_sig, latest_contribute_time, consecutive_days,
       rank, beat_percent, level
FROM dws_${community}_newyear_report
WHERE platform = #{platform} AND user_login = #{user};
"""
var resp = db.select(sqlstr)
return resp[0]

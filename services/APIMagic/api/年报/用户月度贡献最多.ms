{
  "properties" : { },
  "id" : "14df4aa83fb74e75b108a25762348996",
  "script" : null,
  "groupId" : "167a3de74ad940eeb846096b64fc127f",
  "name" : "用户月度贡献最多",
  "createTime" : null,
  "updateTime" : 1767491866546,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/{platform}/month/contribute",
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
  "responseBody" : null,
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
var from_date = `2025-01-01`
var end_date = `2025-12-31`
var sqlstr =  """
SELECT distinct on (user_login) 
    date_trunc('month', date)::DATE AS month, 
    sum(merged_pr_incre + issue_incre + comment_incre) AS contribute
FROM dws_${community}_contribute_user_detail_daily
WHERE date >= #{from_date}::DATE 
       AND date <= #{end_date}::DATE
       AND user_login = #{user} 
       AND source = #{platform}
GROUP BY user_login, date_trunc('month', date)::DATE
ORDER BY user_login, contribute DESC;
"""
var resp = db.select(sqlstr)
return resp[0]

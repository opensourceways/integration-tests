{
  "properties" : { },
  "id" : "11110873bef34c60a8d75f4f176710d8",
  "script" : null,
  "groupId" : "02e1913c81774eaaa91ab66d3c954f06",
  "name" : "总览数据",
  "createTime" : null,
  "updateTime" : 1776134247026,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/count",
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
    "error" : "community 参数非法",
    "expression" : "^(openeuler|opengauss|mindspore|openubmc|openfuyao)$",
    "children" : null
  }, {
    "name" : "metric",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "metric 参数非法",
    "expression" : "^(contributor|sig|repo|comment|issue|merged_pr)?$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"contributor_all\": 22791,\n        \"sig_all\": 80189,\n        \"repo_all\": 11925,\n        \"comment_all\": 4079620,\n        \"issue_all\": 120469,\n        \"merged_pr_all\": 225428\n    },\n    \"timestamp\": 1753946727929,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var metric_suffix = metric + "_all"
var sqlstr = """
SELECT uuid, value
FROM ads_metric_value
WHERE community = #{community}
    <if test="metric != null and metric != ''">
        AND uuid = #{metric_suffix}
    </if>
"""
var result = db.select(sqlstr)
var ans = {}
for (it in result) {
    ans[it['uuid']] = it['value']
}
return ans

{
  "properties" : { },
  "id" : "f3f93b3de1234b0da65b5e2030efac1e",
  "script" : null,
  "groupId" : "41553c4e36ac43ad80de9092de23e98d",
  "name" : "总览数据",
  "createTime" : null,
  "updateTime" : 1774947269411,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/count",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openubmc",
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
    "name" : "metric",
    "value" : "issue",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {},\n    \"timestamp\": 1773905860141,\n    \"executeTime\": 5\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT uuid, value
FROM ads_metric_value
WHERE community = #{community}
    <if test="metric != null and metric != ''">
        AND uuid = #{metric} || '_all'
    </if>
"""
var result = db.select(sqlstr)
var ans = {}
for (it in result) {
    ans[it['uuid']] = it['value']
}
return ans

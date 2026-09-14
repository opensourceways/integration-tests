{
  "properties" : { },
  "id" : "copy1750390221214d77978",
  "script" : null,
  "groupId" : "1cc0849322d74468ab73c9ad0f14fc02",
  "name" : "运作情况",
  "createTime" : null,
  "updateTime" : 1774578890454,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/status",
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
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "date",
    "value" : "1769875199000",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "date 必须大于 0",
    "expression" : "",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"status\": \"不活跃\",\n        \"count\": 50,\n        \"percent\": 0.45454547\n    }, {\n        \"status\": \"活跃\",\n        \"count\": 60,\n        \"percent\": 0.54545456\n    }],\n    \"timestamp\": 1761220842779,\n    \"executeTime\": 10\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT
    status, count(1)
FROM dws_community_sig_score
WHERE community=#{community}
        <if test="date != null and date != ''">
            AND created_at = to_timestamp(#{date}/1000)::date
        </if>
        <else>
            AND created_at = (select max(created_at) from dws_community_sig_score where community = #{community})
        </else>
GROUP BY status;
"""
var result = db.select(sqlstr)
var count = 0::float
result.each(it => count += it.count)
ans = {}
result.each(it => it['percent'] = it.count/count)
return result

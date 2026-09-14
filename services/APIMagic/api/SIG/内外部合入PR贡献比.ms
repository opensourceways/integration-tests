{
  "properties" : { },
  "id" : "copy1751266864750d36951",
  "script" : null,
  "groupId" : "1cc0849322d74468ab73c9ad0f14fc02",
  "name" : "内外部合入PR贡献比",
  "createTime" : null,
  "updateTime" : 1778469393209,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/pr/count",
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
    "error" : "community 参数非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "start 必须大于 0",
    "expression" : "",
    "children" : null
  }, {
    "name" : "end",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "end 必须大于 0",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"internal\": \"内部\",\n        \"count\": 7992,\n        \"percent\": 0.9132671\n    }, {\n        \"internal\": \"外部\",\n        \"count\": 759,\n        \"percent\": 0.08673295\n    }],\n    \"timestamp\": 1778469332431,\n    \"executeTime\": 384\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT
    internal,
    COUNT(1)
FROM dws_${community}_contribute dcc
WHERE contrib_type = 'pr' 
      AND state = 'merged' 
      AND exists (SELECT 1 FROM fact_${community}_sig_user fcsu WHERE fcsu.sig_name = ANY(dcc.sig_name))
        <if test="start != null and start != ''">
            AND dcc.created_at > to_timestamp(#{start}/1000)
        </if>
        <if test="end != null and end != ''">
            AND dcc.created_at < to_timestamp(#{end}/1000)
        </if>
GROUP BY internal;
"""
var result = db.select(sqlstr)
var count = 0::float
result.each(it => count += it.count)

if (count > 0) {
    result.each(it => it['percent'] = it.count/count)
}

return result

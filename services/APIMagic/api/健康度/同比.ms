{
  "properties" : { },
  "id" : "2cc2e845716046459b90320efb956e29",
  "script" : null,
  "groupId" : "c8e7bc9573554a77aa14c0c646dabaae",
  "name" : "同比",
  "createTime" : null,
  "updateTime" : 1773816284374,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{community}/on/{interval}",
  "method" : "GET",
  "parameters" : [ {
    "name" : "mode",
    "value" : "special",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "general",
    "validateType" : null,
    "error" : null,
    "expression" : "^(general|special)$",
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
  "paths" : [ {
    "name" : "interval",
    "value" : "month",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(year|month|quarter)$",
    "children" : null
  }, {
    "name" : "community",
    "value" : "openfuyao",
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
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1773816035731,\n    \"executeTime\": 11\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var name = 'default'
var avg_name = 'avg_score'
if (mode == 'special') {
    name = community
    avg_name = 'special_avg_score'
}
var interval_value = '1 year'
if (interval == 'month') {
    interval_value = '1 month'
}
else if (interval == 'quarter') {
    interval_value = '3 months'
}
else if (interval == 'year') {
    interval_value = '1 year'
}
else {
    interval = '1' + interval
}
var metric_query = """
SELECT
    config
FROM community_service_config
WHERE community=#{name} AND service = 'health';
"""
var config = db.select(metric_query)[0].config.value::json
var metrics = config.get('metric_list').keySet()
var query = 'created_at' + ',' + avg_name
metrics.each(it => query += ',' + it)
metrics.each(it => query += ',' + it + '_value')
var sqlstr = """
SELECT ${query}
FROM dws_community_health_metric
WHERE created_at <= CURRENT_DATE - CAST(#{interval_value} AS interval) AND community=#{community}
ORDER BY created_at DESC
LIMIT 1;
"""
result = db.select(sqlstr)[0]
return result

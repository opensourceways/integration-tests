{
  "properties" : { },
  "id" : "a8f96ffaafe84c4b90ed336bfa610ad5",
  "script" : null,
  "groupId" : "c8e7bc9573554a77aa14c0c646dabaae",
  "name" : "社区健康度季度均值",
  "createTime" : null,
  "updateTime" : 1763522770966,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{community}/quarter",
  "method" : "GET",
  "parameters" : [ {
    "name" : "quarter",
    "value" : "current",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "current",
    "validateType" : null,
    "error" : null,
    "expression" : "^(last|current)$",
    "children" : null
  }, {
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
    "name" : "community",
    "value" : "cannopen",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"avg_score\": 2.951,\n        \"nss\": null,\n        \"download\": 1.0,\n        \"issue_close\": 4.1765,\n        \"certification\": null,\n        \"first_response\": 5.0,\n        \"leverage_ratio\": null,\n        \"tech_influence\": 1.0,\n        \"version_release\": null,\n        \"elephant_coefficient\": null,\n        \"effective_maintenance\": 3.5294,\n        \"contribution_diversity\": null,\n        \"contributor_interaction\": null,\n        \"nss_value\": null,\n        \"download_value\": 0.0,\n        \"issue_close_value\": 0.8745,\n        \"certification_value\": null,\n        \"first_response_value\": 0.1758,\n        \"leverage_ratio_value\": null,\n        \"tech_influence_value\": 0.0,\n        \"version_release_value\": null,\n        \"elephant_coefficient_value\": null,\n        \"effective_maintenance_value\": 0.6035,\n        \"contribution_diversity_value\": null,\n        \"contributor_interaction_value\": null\n    },\n    \"timestamp\": 1763522733513,\n    \"executeTime\": 16\n}",
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
var metric_query = """
SELECT
    config
FROM community_service_config
WHERE community=#{name} AND service = 'health';
"""
var config = db.select(metric_query)[0].config.value::json
var interval = config.get('interval') or '1 years'
var metrics = config.get('metric_list').keySet()
var query = `AVG(${avg_name}) AS ${avg_name}`
metrics.each(it => query += ',' + `AVG(${it}::numeric) as ${it}`)
metrics.each(it => query += ',' + `AVG(${it}_value::numeric) as ${it}_value`)
var sqlstr = """
WITH current_quarter AS (
    SELECT 
        DATE_TRUNC('quarter', CURRENT_DATE) AS quarter_start,
        DATE_TRUNC('quarter', CURRENT_DATE) + INTERVAL '3 months' AS quarter_end
),
last_quarter AS (
    SELECT 
        DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '3 months' AS quarter_start,
        DATE_TRUNC('quarter', CURRENT_DATE) AS quarter_end
)
SELECT ${query}
FROM dws_community_health_metric, ${quarter}_quarter
WHERE community=#{community} 
    AND created_at >= quarter_start 
    AND created_at < quarter_end;
"""
var result = db.select(sqlstr)[0]
var response = {}
result.each((key,value) => {
    response[key] = value == null ? value : round(value, 4)
})
return response

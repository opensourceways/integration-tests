{
  "properties" : { },
  "id" : "copy1779179383088d5929",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "npu详细数据折线图",
  "createTime" : null,
  "updateTime" : 1779197960898,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/npu/dimension/metric",
  "method" : "POST",
  "parameters" : [],
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
  "requestBody" : null,
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : {
    "name" : "root",
    "value" : "",
    "description" : "",
    "required" : false,
    "dataType" : "Object",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : [ {
      "name" : "start",
      "value" : "1767196800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1772380800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
        "name" : "group_field",
      "value" : "community",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(cluster_name|resource_name)$",
      "children" : [ ]
    }, {
      "name" : "dimension_type",
      "value" : "dimension",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(day|hour|minute)$",
      "children" : [ ]
    }, {
      "name" : "metric_field",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "functions",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "metric_type",
      "value" : "avg",
      "description" : "聚合方式：max/avg/p50/p90，仅在天/小时维度下生效",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "avg",
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(max|avg|p50|p90)$",
      "children" : [ ]
    }, {
      "name" : "service_name",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }]
  },
  "responseBodyDefinition" : {
    "name" : "",
    "value" : "",
    "description" : "",
    "required" : false,
    "dataType" : "Object",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : [ {
      "name" : "code",
      "value" : "0",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "message",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "data",
      "value" : "null",
      "description" : "",
      "required" : false,
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "timestamp",
      "value" : "1779189856599",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "executeTime",
      "value" : "0",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  }
}
================================

var start = body.start
var end = body.end
var cluster_name = body.cluster_name
var dimension_type = body.dimension_type
var group_field = body.group_field
var resource_name = body.resource_name
var metric_type = body.metric_type != null ? body.metric_type : "avg"

var rate_field = "cluster_usage_rate"
var total_npu_field = "cluster_total_npu"
var npu_used_field = "cluster_npu_used"

if("resource_name".equals(group_field)){
  group_field="cluster_name,node";
  rate_field = "node_usage_rate"
  total_npu_field = "node_total_npu"
  npu_used_field = "node_npu_used"

}else{
  group_field="cluster_name";

}

// 根据 metric_type 构建聚合函数字符串（仅在非分钟维度时生效）
var agg_npu = "ROUND(AVG(" + npu_used_field + "), 2)"
var agg_rate = "ROUND(AVG(" + rate_field + "), 2)"
if("max".equals(metric_type)){
  agg_npu = "ROUND(MAX(" + npu_used_field + "), 2)"
  agg_rate = "ROUND(MAX(" + rate_field + "), 2)"
}else if("p50".equals(metric_type)){
  agg_npu = "ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY " + npu_used_field + ") AS NUMERIC), 2)"
  agg_rate = "ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY " + rate_field + ") AS NUMERIC), 2)"
}else if("p90".equals(metric_type)){
  agg_npu = "ROUND(CAST(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY " + npu_used_field + ") AS NUMERIC), 2)"
  agg_rate = "ROUND(CAST(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY " + rate_field + ") AS NUMERIC), 2)"
}

var sql = """

SELECT
    date_trunc('${dimension_type}', minute_ts) AS timestamp,
    ${group_field} as label,
    ROUND(AVG(${total_npu_field}), 2) AS total_npu,
    ${agg_npu} AS npu_used,
    ${agg_rate} AS usage_rate,
    ROUND(AVG(${rate_field}), 2) AS avg_usage_rate

FROM (
    SELECT
        TIMESTAMP AS minute_ts,
        ${group_field},
        MAX(${total_npu_field}) AS ${total_npu_field},
        MAX(${npu_used_field}) AS ${npu_used_field},
        MAX(${rate_field}) AS ${rate_field}
    FROM fact_custom_npu_metric_node_minute
    where
      1=1
    <if test="cluster_name != null and cluster_name != ''">
            and  cluster_name=#{cluster_name}
</if>
<if test="resource_name != null and resource_name != ''">
            and   node=#{resource_name}
</if>
        <if test="start != null and start != ''">AND timestamp >= to_timestamp(#{start}/1000)</if>
        <if test="end != null and end != ''">AND timestamp <= to_timestamp(#{end}/1000)</if>

    GROUP BY TIMESTAMP, ${group_field}
) AS minute_max_data
GROUP BY ${group_field},date_trunc('${dimension_type}', minute_ts)
ORDER BY ${group_field}, timestamp limit 5000;

   """

return db.select(sql)




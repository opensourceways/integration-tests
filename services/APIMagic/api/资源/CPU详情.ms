{
  "properties" : { },
  "id" : "2b77ea15e67d4b228d21f29d525101e8",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "CPU详情",
  "createTime" : null,
  "updateTime" : 1777375418084,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/cpu/cluster/detail",
  "method" : "POST",
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
  "requestBody" : "{\r\n    \"start\":1577808000000,\r\n    \"end\":1898526240605,\r\n    \"community\": \"\",\r\n    \"region_name\": \"贵阳\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"community\": \"ascend_infra_unified_resource_pool\",\n        \"region_name\": \"西南-贵阳\",\n        \"cpu_useage_max\": 0.62,\n        \"cpu_useage_avg\": 0.18,\n        \"cpu_useage_p50\": 0.03,\n        \"cpu_useage_p90\": 0.59,\n        \"mem_useage_max\": 0.26,\n        \"mem_useage_avg\": 0.04,\n        \"mem_useage_p50\": 0.04,\n        \"mem_useage_p90\": 0.06\n    }],\n    \"timestamp\": 1777101383235,\n    \"executeTime\": 4\n}",
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
      "value" : "1577808000000",
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
      "value" : "1898526240605",
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
      "value" : "x",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z_]{1,64}$",
      "children" : [ ]
    }, {
      "name" : "region_name",
      "value" : "贵阳",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================

var sqlstr = """
SELECT
    community,
    region_name,
    ROUND(MAX(cpu_usage)::numeric, 2) as cpu_useage_max,
    ROUND(AVG(cpu_usage)::numeric, 2) as cpu_useage_avg,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cpu_usage)::numeric, 2) as cpu_useage_p50,
    ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY cpu_usage)::numeric, 2) as cpu_useage_p90,
    ROUND(MAX(mem_usage)::numeric, 2) as mem_useage_max,
    ROUND(AVG(mem_usage)::numeric, 2) as mem_useage_avg,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mem_usage)::numeric, 2) as mem_useage_p50,
    ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY mem_usage)::numeric, 2) as mem_useage_p90
FROM dws_cloud_cpu_details_hour
WHERE 1 = 1
    <if test="body.start != null and body.start != ''">
        AND timestamp >= to_timestamp(#{body.start}/1000)
    </if>
    <if test="body.end != null and body.end != ''">
        AND timestamp <= to_timestamp(#{body.end}/1000)
    </if>
    <if test="not_blank(body.community)">
        AND community = #{body.community}
    </if>
GROUP BY community, region_name
ORDER BY community, region_name
"""

return db.select(sqlstr)
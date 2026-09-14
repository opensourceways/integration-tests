{
  "properties" : { },
  "id" : "copy1770343799781d59637",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "cluster信息",
  "createTime" : null,
  "updateTime" : 1750000000000,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/cluster/detail",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1877808000000,\r\n    \"end\":1898526240605,\r\n    \"community\": \"\",\r\n    \"region_name\": \"贵阳\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1778757025235,\n    \"executeTime\": 8\n}",
  "description" : null,
  "requestBodyDefinition" : {
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
      "name" : "start",
      "value" : "1877808000000",
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
      "value" : "",
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
      "validateType" : "pass",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
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
      "value" : "1",
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
      "value" : "success",
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
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "timestamp",
      "value" : "1778757025235",
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
      "value" : "8",
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
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);

var order_by_set = new HashSet()
var order_asc = "";
if (body.asc != null and body.asc != "") {
    var asc_arr = body.asc.split(",");
    for(index,item in asc_arr){
        order_by_set.add(item + " asc");
    }
}
var order_desc = "";
if (body.desc != null and body.desc != "") {
    var desc_arr = body.desc.split(",");
    for(index,item in desc_arr){
        order_by_set.add(item + " desc");
    }
}
var order_by = "";
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
var sql = """
WITH freq_expanded AS (
  SELECT
    nd.cluster_name,
    nd.community,
    nd.total_node_npu,
    (je.key)::numeric   AS npu_val,
    (je.value)::bigint  AS freq_cnt
  FROM fact_custom_npu_metric_node_day nd
  CROSS JOIN LATERAL jsonb_each_text(COALESCE(nd.npu_used_freq, '{}'::jsonb)) AS je
  WHERE nd.stat_date >= #{start}
    AND nd.stat_date <= #{end}
    <if test="not_blank(body.community)">
      AND nd.community = #{body.community}
    </if>
    <if test="not_blank(body.region_name)">
      AND nd.cluster_name ILIKE '%' || #{body.region_name} || '%'
    </if>
),
cluster_agg AS (
  SELECT
    cluster_name,
    community,
    npu_val,
    SUM(freq_cnt)          AS total_cnt,
    MAX(total_node_npu)    AS max_total_npu
  FROM freq_expanded
  GROUP BY cluster_name, community, npu_val
),
cluster_totals AS (
  SELECT
    cluster_name,
    community,
    MAX(max_total_npu)           AS total_node_npu,
    MAX(npu_val)                 AS max_npu_used,
    SUM(npu_val * total_cnt)     AS weighted_sum,
    SUM(total_cnt)               AS grand_total
  FROM cluster_agg
  GROUP BY cluster_name, community
),
ranked AS (
  SELECT
    ca.cluster_name,
    ca.community,
    ca.npu_val,
    ct.grand_total,
    ct.total_node_npu,
    ct.weighted_sum,
    ct.max_npu_used,
    SUM(ca.total_cnt) OVER (
      PARTITION BY ca.cluster_name, ca.community
      ORDER BY ca.npu_val
    ) AS cumulative_cnt
  FROM cluster_agg ca
  JOIN cluster_totals ct
    ON  ca.cluster_name = ct.cluster_name
    AND ca.community IS NOT DISTINCT FROM ct.community
),
p50 AS (
  SELECT DISTINCT ON (cluster_name, community)
    cluster_name, community, npu_val AS p50_val
  FROM ranked
  WHERE cumulative_cnt >= grand_total * 0.5
  ORDER BY cluster_name, community, npu_val
),
p90 AS (
  SELECT DISTINCT ON (cluster_name, community)
    cluster_name, community, npu_val AS p90_val
  FROM ranked
  WHERE cumulative_cnt >= grand_total * 0.9
  ORDER BY cluster_name, community, npu_val
)
SELECT
  ct.cluster_name,
  ct.community,
  split_part(ct.cluster_name, '-', 2)                                                               AS region_name,
  ct.total_node_npu                                                                                  AS total_node_npu,
  ct.max_npu_used                                                                                    AS max_node_npu_used,
  ROUND((ct.weighted_sum / NULLIF(ct.grand_total, 0))::NUMERIC, 2)                                  AS avg_node_npu_used,
  ROUND(p50.p50_val::NUMERIC, 2)                                                                    AS midle_node_npu_used,
  ROUND(p90.p90_val::NUMERIC, 2)                                                                    AS p90_node_npu_used,
  ROUND((ct.max_npu_used / NULLIF(ct.total_node_npu, 0))::NUMERIC, 2)                              AS max_npu_useage,
  ROUND(((ct.weighted_sum / NULLIF(ct.grand_total, 0)) / NULLIF(ct.total_node_npu, 0))::NUMERIC, 2) AS avg_npu_useage,
  ROUND((p50.p50_val / NULLIF(ct.total_node_npu, 0))::NUMERIC, 4)                                  AS midle_npu_useage,
  ROUND((p90.p90_val / NULLIF(ct.total_node_npu, 0))::NUMERIC, 4)                                  AS p90_npu_useage
FROM cluster_totals ct
JOIN p50 ON ct.cluster_name = p50.cluster_name AND ct.community IS NOT DISTINCT FROM p50.community
JOIN p90 ON ct.cluster_name = p90.cluster_name AND ct.community IS NOT DISTINCT FROM p90.community
<if test="order_by != null and order_by != ''">
  ORDER BY ${order_by}
</if>
;
"""
var res = db.select(sql)
return res

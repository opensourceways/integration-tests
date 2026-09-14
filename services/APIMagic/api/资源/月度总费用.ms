{
  "properties" : { },
  "id" : "035d39d32ffb4201834961c0f1a75a78",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "月度总费用",
  "createTime" : null,
  "updateTime" : 1774511762119,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/totalcost",
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
  }, {
    "name" : "permission",
    "value" : "datastatInfra_View",
    "description" : "允许拥有该权限的访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "requestBody" : "{\r\n    \"community\":\"unifiedbus\",\r\n    \"start\":1730390400000,\r\n    \"end\":1993177600000\r\n\r\n\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1768889397847,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
var community = body.community;
var start_time =date_format(start,'yyyy-MM');
var end_time =date_format(end,'yyyy-MM');
var domain = body.domain;
var sql = """
WITH data AS (
    SELECT 
        cycle,
        SUM(consume_amount) AS amount
    FROM dwm_cloud_resource_details
    WHERE 
    is_match='true' and cycle <= #{end_time} 
      <if test="community != null and community != ''">
        AND community_display_name = #{community}
      </if>
            <if test="domain != null and domain != ''">
        AND domain = #{domain}
      </if>
    GROUP BY cycle
    ORDER BY cycle DESC
    LIMIT 2
),
total AS (
    SELECT 
        SUM(consume_amount) AS total_amount
    FROM dwm_cloud_resource_details
    WHERE 
      is_match='true' and
    cycle <= #{end_time} 
      AND cycle >= #{start_time}
      <if test="community != null and community != ''">
        AND community_display_name = #{community}
      </if>
                  <if test="domain != null and domain != ''">
        AND domain = #{domain}
      </if>
),
pivoted AS (
    SELECT
        MAX(cycle) FILTER (WHERE rn = 1) AS current_cycle,
        MAX(amount) FILTER (WHERE rn = 1) AS current_amount,
        MAX(cycle) FILTER (WHERE rn = 2) AS previous_cycle,
        MAX(amount) FILTER (WHERE rn = 2) AS previous_amount
    FROM (
        SELECT 
            cycle,
            amount,
            ROW_NUMBER() OVER (ORDER BY cycle DESC) AS rn
        FROM data
    ) t
)
SELECT
    p.current_amount ,
    p.previous_amount AS previous_month_amount,
    CASE
        WHEN p.previous_amount IS NULL OR p.previous_amount = 0 THEN NULL
        ELSE ROUND(
            (p.current_amount - p.previous_amount) / p.previous_amount * 100,
            2
        )
    END AS mom_growth,
    t.total_amount as current_month_amount
FROM pivoted p
CROSS JOIN total t;
"""
return db.selectOne(sql)

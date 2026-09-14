{
  "properties" : { },
  "id" : "b7b9aec769374ad6a7eb7e67baa1d50e",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "npu",
  "createTime" : null,
  "updateTime" : 1774511798744,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/npu",
  "method" : "GET",
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
return db.select("""                                           WITH time_grid AS (
    -- 生成每分钟的时间刻度（timestamptz 类型）
    SELECT generate_series(
        date_trunc('minute', NOW() - INTERVAL '1 hour'),
        date_trunc('minute', NOW()),
        '1 minute'::INTERVAL
    ) AS timestamp
),
node_list AS (
    -- 获取所有需要展示的 node（来自 fact_cloud_npu_resource）
    SELECT DISTINCT resource_name AS node
    FROM fact_cloud_npu_resource
    WHERE res_instance_id IS NOT NULL
),
grid AS (
    -- 笛卡尔积：每个 node × 每分钟
    SELECT t.timestamp, n.node
    FROM time_grid t
    CROSS JOIN node_list n
),
metrics_agg AS (
    -- 聚合原始指标数据（按分钟对齐）
    SELECT 
        date_trunc('minute', timestamp) AS timestamp,
        node,
        ROUND(SUM(pod_npu_used)::NUMERIC / NULLIF(MAX(node_total_npu), 0), 4) AS useage,
        MAX(node_total_npu) AS node_total_npu,
        COUNT(pr) AS pr_count
    FROM fact_custom_npu_metric
    WHERE  node='os-node-created-njkt2' and timestamp >= NOW() - INTERVAL '1 hour'
      AND timestamp <= NOW()
    GROUP BY date_trunc('minute', timestamp), node
)
-- 主查询：时间刻度 × node 左连聚合数据，再左连资源信息
SELECT 
    g.timestamp,
    g.node,
    m.useage,
    m.node_total_npu,
    m.pr_count,
    b.res_instance_id,
    b.cloud_service_type_name,
    b.cloud_service_type,
    b.resource_type_code,
    b.resource_type_name
FROM grid g
LEFT JOIN metrics_agg m 
    ON g.timestamp = m.timestamp AND g.node = m.node
LEFT JOIN fact_cloud_npu_resource b 
    ON g.node = b.resource_name
WHERE b.res_instance_id IS NOT NULL  -- 只保留有资源信息的 node
ORDER BY g.node, g.timestamp; """)

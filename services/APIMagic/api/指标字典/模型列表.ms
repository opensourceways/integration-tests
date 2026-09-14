{
  "properties" : { },
  "id" : "metrics_dict_models_2026",
  "script" : null,
  "groupId" : "709908d8728741d19dd2d28b98d0e23a",
  "name" : "模型列表",
  "createTime" : null,
  "updateTime" : 1776560000000,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/models",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "",
  "description" : "查询所有模型定义及各模型包含的指标数量",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT
    mod.id,
    mod.name,
    mod.description,
    mod.calc_logic,
    mod.status,
    mod.created_at::text,
    COUNT(DISTINCT mm.metric_name) AS metric_count,
    COUNT(DISTINCT CASE WHEN m.impl_status = 'implemented' THEN mm.metric_name END) AS impl_count
FROM metric_models mod
LEFT JOIN model_metrics mm ON mod.id = mm.model_id
LEFT JOIN metrics m ON mm.metric_name = m.name
GROUP BY mod.id, mod.name, mod.description, mod.calc_logic, mod.status, mod.created_at
ORDER BY mod.created_at
"""

return db.select(sqlstr)

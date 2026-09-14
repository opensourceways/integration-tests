{
  "properties" : { },
  "id" : "metrics_dict_list_2026",
  "script" : null,
  "groupId" : "709908d8728741d19dd2d28b98d0e23a",
  "name" : "指标列表",
  "createTime" : null,
  "updateTime" : 1776560000000,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/list",
  "method" : "GET",
  "parameters" : [
    {
      "name" : "metric_type",
      "value" : "",
      "description" : "指标类型过滤，可选：atomic / composite",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : null,
      "expression" : "",
      "children" : null
    },
    {
      "name" : "impl_status",
      "value" : "",
      "description" : "实现状态过滤，可选：implemented / not_implemented",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : null,
      "expression" : "",
      "children" : null
    },
    {
      "name" : "model_id",
      "value" : "",
      "description" : "模型ID过滤，可选：ops / health",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : null,
      "expression" : "",
      "children" : null
    }
  ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "",
  "description" : "查询指标字典列表，返回所有指标及其所属模型名称",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT
    m.name,
    m.label,
    m.definition,
    m.metric_type,
    m.status,
    m.impl_status,
    m.source_api,
    m.source_table,
    m.source_field,
    m.formula_desc,
    m.formula_source,
    m.impl_notes,
    CAST(COALESCE(
        json_agg(mod.name ORDER BY mod.name) FILTER (WHERE mod.name IS NOT NULL),
        '[]'::json
    ) AS text) AS models
FROM metrics m
LEFT JOIN model_metrics mm ON m.name = mm.metric_name
LEFT JOIN metric_models mod ON mm.model_id = mod.id
WHERE 1 = 1
    <if test="metric_type != '' and metric_type != null">
        AND m.metric_type = #{metric_type}
    </if>
    <if test="impl_status != '' and impl_status != null">
        AND m.impl_status = #{impl_status}
    </if>
    <if test="model_id != '' and model_id != null">
        AND mm.model_id = #{model_id}
    </if>
GROUP BY
    m.name, m.label, m.definition, m.metric_type, m.status,
    m.impl_status, m.source_api, m.source_table, m.source_field,
    m.formula_desc, m.formula_source, m.impl_notes, m.created_at
ORDER BY
    CASE m.impl_status WHEN 'implemented' THEN 0 ELSE 1 END,
    m.created_at,
    m.name
"""

return db.select(sqlstr)

{
  "properties" : { },
  "id" : "metrics_dict_community_config_2026",
  "script" : null,
  "groupId" : "709908d8728741d19dd2d28b98d0e23a",
  "name" : "社区配置",
  "createTime" : null,
  "updateTime" : 1776560000000,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/community-config",
  "method" : "GET",
  "parameters" : [
    {
      "name" : "model_id",
      "value" : "",
      "description" : "模型ID过滤，可选：health / sig",
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
      "name" : "community",
      "value" : "",
      "description" : "社区名称过滤",
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
  "description" : "查询社区指标配置（权重/阈值），支持按模型和社区过滤",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT
    community,
    model_id,
    metric_name,
    weight,
    total_weight,
    thresholds,
    score_threshold,
    interval_unit,
    community_special_note,
    metric_special_note,
    extra_config
FROM community_metric_config
WHERE 1 = 1
    <if test="model_id != '' and model_id != null">
        AND model_id = #{model_id}
    </if>
    <if test="community != '' and community != null">
        AND community = #{community}
    </if>
ORDER BY community, model_id, metric_name
"""

return db.select(sqlstr)

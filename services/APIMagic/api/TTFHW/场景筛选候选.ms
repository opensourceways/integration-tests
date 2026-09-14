{
  "properties" : { },
  "id" : "ttfhw_scenario_filter_options",
  "script" : null,
  "groupId" : "ttfhwgroup0000000000000000000001",
  "name" : "场景筛选候选",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/scenario/filter-options",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ {
    "name" : "wrap_request_parameter",
    "value" : "disable-cache",
    "description" : "禁用缓存，候选值随数据变化实时更新",
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
    "value" : "datastatTTFHW_View",
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
  "description" : "各筛选列的全量 distinct 候选值（不受分页限制，供表头漏斗多选用）",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 各列全量 distinct 候选值（用 string_agg 一次查出，逗号分隔串转数组）。
// 表头漏斗的候选项必须来自全量数据，而非当前页（后端分页后当页不全）。
var r = db.selectOne("""
SELECT
  COALESCE((SELECT string_agg(DISTINCT scenario_type, ',' ORDER BY scenario_type)
            FROM fact_ttfhw_scenario_request WHERE scenario_type IS NOT NULL AND scenario_type <> ''), '') AS scenario_type,
  COALESCE((SELECT string_agg(DISTINCT status, ',' ORDER BY status)
            FROM fact_ttfhw_scenario_request WHERE status IS NOT NULL AND status <> ''), '') AS status,
  COALESCE((SELECT string_agg(DISTINCT creator, ',' ORDER BY creator)
            FROM fact_ttfhw_scenario_request WHERE creator IS NOT NULL AND creator <> ''), '') AS creator
""");
return {
  scenario_type: (r.scenario_type != null && r.scenario_type != '') ? r.scenario_type.split(',') : [],
  status: (r.status != null && r.status != '') ? r.status.split(',') : [],
  creator: (r.creator != null && r.creator != '') ? r.creator.split(',') : []
};

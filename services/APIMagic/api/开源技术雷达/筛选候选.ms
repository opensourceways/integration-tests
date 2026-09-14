{
  "properties" : { },
  "id" : "oss_insight_filter_options",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "筛选候选",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/oss-insight/filter-options",
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
  COALESCE((SELECT string_agg(DISTINCT project_name, ',' ORDER BY project_name)
            FROM fact_oss_insight_request WHERE project_name IS NOT NULL AND project_name <> ''), '') AS project_name,
  COALESCE((SELECT string_agg(DISTINCT title, ',' ORDER BY title)
            FROM fact_oss_insight_request WHERE title IS NOT NULL AND title <> ''), '') AS title,
  COALESCE((SELECT string_agg(DISTINCT status, ',' ORDER BY status)
            FROM fact_oss_insight_request WHERE status IS NOT NULL AND status <> ''), '') AS status,
  COALESCE((SELECT string_agg(DISTINCT creator, ',' ORDER BY creator)
            FROM fact_oss_insight_request WHERE creator IS NOT NULL AND creator <> ''), '') AS creator
""");
return {
  project_name: (r.project_name != null && r.project_name != '') ? r.project_name.split(',') : [],
  title: (r.title != null && r.title != '') ? r.title.split(',') : [],
  status: (r.status != null && r.status != '') ? r.status.split(',') : [],
  creator: (r.creator != null && r.creator != '') ? r.creator.split(',') : []
};

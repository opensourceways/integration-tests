{
  "properties" : { },
  "id" : "ttfhw_scenario_list",
  "script" : null,
  "groupId" : "ttfhwgroup0000000000000000000001",
  "name" : "场景列表",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/scenario/list",
  "method" : "GET",
  "parameters" : [ {
    "name" : "page",
    "value" : "1",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page > 0 && page <= 100000",
    "children" : null
  }, {
    "name" : "page_size",
    "value" : "20",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "20",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page_size > 0 && page_size <= 100",
    "children" : null
  }, {
    "name" : "sort_by",
    "value" : null,
    "description" : "排序字段，白名单：created_at/title/status/scenario_type/creator；空=默认 created_at 降序",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "sort_by 必须为 created_at/title/status/scenario_type/creator 之一",
    "expression" : "^(created_at|title|status|scenario_type|creator)?$",
    "children" : null
  }, {
    "name" : "sort_order",
    "value" : null,
    "description" : "排序方向：ascending/descending；空=descending",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "sort_order 必须为 ascending 或 descending",
    "expression" : "^(ascending|descending)?$",
    "children" : null
  }, {
    "name" : "status",
    "value" : null,
    "description" : "状态多选筛选，逗号分隔，如：已发布,待生成",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "status 仅允许 待生成/审阅中/已发布/已关闭 的逗号分隔组合",
    "expression" : "^(?:(待生成|审阅中|已发布|已关闭)(?:,(待生成|审阅中|已发布|已关闭))*)?$",
    "children" : null
  }, {
    "name" : "scenario_type",
    "value" : null,
    "description" : "场景类型多选筛选，逗号分隔，如：user,contributor",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "scenario_type 仅允许 user/contributor 的逗号分隔组合",
    "expression" : "^(?:(user|contributor)(?:,(user|contributor))*)?$",
    "children" : null
  }, {
    "name" : "creator",
    "value" : null,
    "description" : "提交人多选筛选，逗号分隔",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "creator 仅允许字母/数字/下划线/点/连字符的逗号分隔组合",
    "expression" : "^(?:[A-Za-z0-9_.-]+(?:,[A-Za-z0-9_.-]+)*)?$",
    "children" : null
  } ],
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
  "description" : "TTFHW 场景提交分页列表（后端排序+筛选+分页，与 oss-insight list 同模式）",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var offset = (page - 1) * page_size;

// ── 筛选 WHERE（多列多选，前端传逗号分隔串 → ANY(string_to_array)；值经 #{param} 参数化，防注入）──
var filters = [];
if(status != null && status != ''){ filters.push("q.status = ANY(string_to_array(#{status}, ','))"); }
if(scenario_type != null && scenario_type != ''){ filters.push("q.scenario_type = ANY(string_to_array(#{scenario_type}, ','))"); }
if(creator != null && creator != ''){ filters.push("q.creator = ANY(string_to_array(#{creator}, ','))"); }
var whereSql = filters.length > 0 ? (" WHERE " + filters.join(" AND ")) : "";

// ── 排序 ORDER BY（白名单映射：列名不能参数化，必须硬编码白名单；同值次序 created_at DESC）──
var asc = (sort_order == "ascending");
var orderExpr = "q.created_at DESC";
if(sort_by == "created_at"){ orderExpr = asc ? "q.created_at ASC" : "q.created_at DESC"; }
else if(sort_by == "title"){ orderExpr = asc ? "q.title ASC, q.created_at DESC" : "q.title DESC, q.created_at DESC"; }
else if(sort_by == "status"){ orderExpr = asc ? "q.status ASC, q.created_at DESC" : "q.status DESC, q.created_at DESC"; }
else if(sort_by == "scenario_type"){ orderExpr = asc ? "q.scenario_type ASC, q.created_at DESC" : "q.scenario_type DESC, q.created_at DESC"; }
else if(sort_by == "creator"){ orderExpr = asc ? "q.creator ASC, q.created_at DESC" : "q.creator DESC, q.created_at DESC"; }

// total 同样按筛选条件计数（分页 total 是筛选后总数）
var total = db.selectOne("SELECT COUNT(*) AS cnt FROM fact_ttfhw_scenario_request q" + whereSql).cnt;
var list = db.select("""SELECT q.id, q.scenario_type, q.title, q.status,
       q.issue_number, q.issue_url, q.report_url, q.pr_url,
       (q.preview_html IS NOT NULL) AS has_preview, q.creator,
       to_char(q.created_at, 'YYYY-MM-DD HH24:MI') AS created_at
FROM fact_ttfhw_scenario_request q
""" + whereSql + " ORDER BY " + orderExpr + " LIMIT #{page_size} OFFSET #{offset}");
return {total: total, list: list};

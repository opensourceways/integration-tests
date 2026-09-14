{
  "properties" : { },
  "id" : "oss_insight_list",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "总览列表",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/oss-insight/list",
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
    "description" : "排序字段，白名单：created_at/like_count/is_featured/project_name/title/status/creator；空=默认 created_at 降序",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "sort_order",
    "value" : null,
    "description" : "排序方向：ascending/descending；空=descending",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "status",
    "value" : null,
    "description" : "状态多选筛选，逗号分隔，如：已发布,待生成",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "project_name",
    "value" : null,
    "description" : "项目名称多选筛选，逗号分隔",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "title",
    "value" : null,
    "description" : "洞察标题多选筛选，逗号分隔",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "creator",
    "value" : null,
    "description" : "提交人多选筛选，逗号分隔",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
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
var offset = (page - 1) * page_size;

// ── 筛选 WHERE（多列多选，前端传逗号分隔串 → ANY(string_to_array)；值经 #{param} 参数化，防注入）──
var filters = [];
if(status != null && status != ''){ filters.push("q.status = ANY(string_to_array(#{status}, ','))"); }
if(project_name != null && project_name != ''){ filters.push("q.project_name = ANY(string_to_array(#{project_name}, ','))"); }
if(title != null && title != ''){ filters.push("q.title = ANY(string_to_array(#{title}, ','))"); }
if(creator != null && creator != ''){ filters.push("q.creator = ANY(string_to_array(#{creator}, ','))"); }
var whereSql = filters.length > 0 ? (" WHERE " + filters.join(" AND ")) : "";

// ── 排序 ORDER BY（白名单映射：列名不能参数化，必须硬编码白名单，sort_by 仅用于 if 比较；同值次序 created_at DESC）──
// is_featured 三档（与前端星星口径一致）：实心(已发布+精选)=2 > 空心(已发布)=1 > 无星(非已发布)=0，降序大在前(实心优先)
var fRank = "(CASE WHEN q.status='已发布' AND COALESCE(q.is_featured,false) THEN 2 WHEN q.status='已发布' THEN 1 ELSE 0 END)";
var asc = (sort_order == "ascending");
var orderExpr = "q.created_at DESC";
if(sort_by == "created_at"){ orderExpr = asc ? "q.created_at ASC" : "q.created_at DESC"; }
else if(sort_by == "like_count"){ orderExpr = asc ? "like_count ASC, q.created_at DESC" : "like_count DESC, q.created_at DESC"; }
else if(sort_by == "is_featured"){ orderExpr = asc ? (fRank + " ASC, q.created_at DESC") : (fRank + " DESC, q.created_at DESC"); }
else if(sort_by == "project_name"){ orderExpr = asc ? "q.project_name ASC, q.created_at DESC" : "q.project_name DESC, q.created_at DESC"; }
else if(sort_by == "title"){ orderExpr = asc ? "q.title ASC, q.created_at DESC" : "q.title DESC, q.created_at DESC"; }
else if(sort_by == "status"){ orderExpr = asc ? "q.status ASC, q.created_at DESC" : "q.status DESC, q.created_at DESC"; }
else if(sort_by == "creator"){ orderExpr = asc ? "q.creator ASC, q.created_at DESC" : "q.creator DESC, q.created_at DESC"; }

// total 同样按筛选条件计数（分页 total 是筛选后总数）
var total = db.selectOne("SELECT COUNT(*) AS cnt FROM fact_oss_insight_request q" + whereSql).cnt;
// 精选（is_featured/featured_by/featured_at 来自需求表）+ 点赞（LEFT JOIN 明细表聚合计数 + 点赞人名单）。
// 点赞人名单用 string_agg（返回 text，可 JSON 序列化），array_agg 返回 PG 数组会导致 magic-api 序列化 500。
var list = db.select("""SELECT q.id, q.insight_type, q.project_name, q.title, q.status,
       q.issue_number, q.issue_url, q.report_url, q.pr_url,
       (q.preview_html IS NOT NULL) AS has_preview, q.creator,
       to_char(q.created_at, 'YYYY-MM-DD HH24:MI') AS created_at,
       COALESCE(q.is_featured,false) AS is_featured, q.featured_by,
       to_char(q.featured_at, 'YYYY-MM-DD HH24:MI') AS featured_at,
       COALESCE(l.like_count,0) AS like_count,
       COALESCE(l.liked_users, '') AS liked_users
FROM fact_oss_insight_request q
LEFT JOIN (SELECT request_id, COUNT(*) AS like_count,
                  string_agg(username, ',' ORDER BY created_at) AS liked_users
           FROM fact_oss_insight_like GROUP BY request_id) l
  ON l.request_id = q.id
""" + whereSql + " ORDER BY " + orderExpr + " LIMIT #{page_size} OFFSET #{offset}");
// liked_users 从逗号分隔串还原为数组（供前端 hover 展示点赞人）
for(index,item in list) {
    var s = item.liked_users;
    item.liked_users = (s != null && s != '') ? s.split(',') : [];
}
return {total: total, list: list};

{
  "properties" : { },
  "id" : "oss_insight_report_list",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "报告列表",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/insight/report/list",
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
    "expression" : "page > 0 && page <= 1000",
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
var total = db.selectOne("SELECT COUNT(*) AS cnt FROM fact_oss_insight_report WHERE status = 'online'").cnt;
// is_featured：该报告对应的洞察需求是否被精选（前端「近期精选」区据此筛选）。
// 关联口径：需求表 report_url 以本报告 path（output/xxx.html）结尾。用 EXISTS 避免 JOIN 行放大。
var list = db.select("""SELECT r.id, r.path, r.title, r.insight_type, r.html_url,
       left(trim(regexp_replace(regexp_replace(coalesce(substring(r.html_content from '<p[^>]*>(.*?)</p>'), ''), '<[^>]+>', ' ', 'g'), '[[:space:]]+', ' ', 'g')), 100) AS summary,
       to_char(r.updated_at, 'YYYY-MM-DD HH24:MI') AS updated_at,
       EXISTS(SELECT 1 FROM fact_oss_insight_request q
              WHERE COALESCE(q.is_featured,false)=true
                AND q.report_url LIKE ('%' || r.path)) AS is_featured
FROM fact_oss_insight_report r
WHERE r.status = 'online'
ORDER BY r.updated_at DESC
LIMIT #{page_size} OFFSET #{offset}""");
return {total: total, list: list};

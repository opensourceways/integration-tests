{
  "properties": {},
  "id": "ttfhw_problems_0001",
  "script": null,
  "groupId": "ttfhwgroup0000000000000000000001",
  "name": "TTFHW断点问题",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/problems",
  "method": "GET",
  "parameters": [
    {"name": "run_id", "value": "", "description": "运行id(可选,弹窗下钻某次运行的问题)", "required": false, "dataType": "String"},
    {"name": "community", "value": "", "description": "社区(可选)", "required": false, "dataType": "String"},
    {"name": "scenario", "value": "", "description": "场景 user/developer(可选)", "required": false, "dataType": "String"},
    {"name": "month", "value": "", "description": "月份 YYYY-MM(可选)", "required": false, "dataType": "String"},
    {"name": "keyword", "value": "", "description": "标题/来源关键词(可选)", "required": false, "dataType": "String"},
    {"name": "page", "value": "1", "description": "页码", "required": false, "dataType": "Integer"},
    {"name": "page_size", "value": "20", "description": "每页条数", "required": false, "dataType": "Integer"}
  ],
  "options": [],
  "requestBody": "",
  "headers": [],
  "paths": [],
  "responseBody": null,
  "description": "TTFHW 断点问题列表（记录与跟踪）：按社区/场景/月份/关键词过滤 + 分页。读 dwm_ttfhw_problem，联 dws_ttfhw_run 带出仓库/结果。",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
// 断点问题记录与跟踪列表：多条件过滤 + 分页；参数化绑定防注入。
var pageNum = (page == null || page == '') ? 1 : page::int;
var pageSize = (page_size == null || page_size == '') ? 20 : page_size::int;
if (pageNum < 1) { pageNum = 1; }
if (pageSize < 1 || pageSize > 200) { pageSize = 20; }
var off = (pageNum - 1) * pageSize;

var where = " WHERE 1=1 ";
if (run_id != null && run_id != '') { where += " AND p.run_id = #{run_id} "; }
if (community != null && community != '') { where += " AND p.community = #{community} "; }
if (scenario != null && scenario != '') { where += " AND p.scenario = #{scenario} "; }
if (month != null && month != '') { where += " AND p.report_month = #{month} "; }
if (keyword != null && keyword != '') { where += " AND (p.title LIKE concat('%', #{keyword}, '%') OR p.source LIKE concat('%', #{keyword}, '%')) "; }

var countSql = "SELECT count(*) AS cnt FROM dwm_ttfhw_problem p " + where;
var total = db.selectOne(countSql).cnt;
var listSql = "SELECT p.id, p.run_id, p.community, p.scenario, p.result, p.report_month AS month, p.run_date, p.title, p.source, p.detail, r.repo, r.url AS repo_url, r.report_url FROM dwm_ttfhw_problem p LEFT JOIN dws_ttfhw_run r ON r.id = p.run_id " + where + " ORDER BY p.run_date DESC NULLS LAST, p.community, p.seq LIMIT #{pageSize} OFFSET #{off}";
var list = db.select(listSql);
return { total: total, list: list, page: pageNum, page_size: pageSize };

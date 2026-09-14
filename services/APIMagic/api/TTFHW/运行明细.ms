{
  "properties": {},
  "id": "ttfhw_runs_0001",
  "script": null,
  "groupId": "ttfhwgroup0000000000000000000001",
  "name": "TTFHW运行明细",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/runs",
  "method": "GET",
  "parameters": [
    {"name": "community", "value": "", "description": "社区(可选)", "required": false, "dataType": "String"},
    {"name": "scenario", "value": "", "description": "场景 user/developer(可选)", "required": false, "dataType": "String"},
    {"name": "month", "value": "", "description": "月份 YYYY-MM(可选)", "required": false, "dataType": "String"},
    {"name": "result", "value": "", "description": "结果(可选)", "required": false, "dataType": "String"},
    {"name": "keyword", "value": "", "description": "社区/仓库关键词(可选)", "required": false, "dataType": "String"},
    {"name": "all", "value": "", "description": "1=含历史报告(is_current=false)，供运行详情页历史面板追溯；缺省仅当前", "required": false, "dataType": "String"},
    {"name": "page", "value": "1", "description": "页码", "required": false, "dataType": "Integer"},
    {"name": "page_size", "value": "20", "description": "每页条数", "required": false, "dataType": "Integer"}
  ],
  "options": [],
  "requestBody": "",
  "headers": [],
  "paths": [],
  "responseBody": null,
  "description": "TTFHW 运行明细列表（社区+仓库维度）：结果、四阶段耗时、总耗时、断点问题数(可点击下钻)。读 dws_ttfhw_run。",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
// 运行明细列表：社区/仓库维度，多条件过滤 + 分页；参数化绑定防注入。
var pageNum = (page == null || page == '') ? 1 : page::int;
var pageSize = (page_size == null || page_size == '') ? 20 : page_size::int;
if (pageNum < 1) { pageNum = 1; }
if (pageSize < 1 || pageSize > 2000) { pageSize = 20; }
var off = (pageNum - 1) * pageSize;

// 「中断」(terminated) 的运行没有意义，运行明细里一律排除。
// is_current=true：总览只显示**当前 final_community 总汇引用**的报告；被换掉/去掉的历史报告 is_current=false，
// 不在总览列出（但其专属子页 /run?id=<报告名> 仍可经 issue 反向追溯直接打开，见 运行详情.ms 不加此过滤）。
// all=1 时不加此过滤（运行详情页历史面板要能列出该仓所有历次报告，含被换掉的历史报告）。
var where = " WHERE result <> 'terminated' ";
if (all == null || all == '' || all == '0') { where += " AND is_current = true "; }
if (community != null && community != '') { where += " AND community = #{community} "; }
if (scenario != null && scenario != '') { where += " AND scenario = #{scenario} "; }
if (month != null && month != '') { where += " AND report_month = #{month} "; }
if (result != null && result != '') { where += " AND result = #{result} "; }
if (keyword != null && keyword != '') { where += " AND (community LIKE concat('%', #{keyword}, '%') OR repo LIKE concat('%', #{keyword}, '%')) "; }

var countSql = "SELECT count(*) AS cnt FROM dws_ttfhw_run " + where;
var total = db.selectOne(countSql).cnt;
var listSql = "SELECT id, community, repo, url AS repo_url, scenario, scene, result, p1_name, p1_min, p1_status, p2_name, p2_min, p2_status, p3_name, p3_min, p3_status, p4_name, p4_min, p4_status, total_min, problem_count, defect_count, report_month AS month, run_date, report_url FROM dws_ttfhw_run " + where + " ORDER BY problem_count DESC, run_date DESC NULLS LAST, community LIMIT #{pageSize} OFFSET #{off}";
var list = db.select(listSql);
return { total: total, list: list, page: pageNum, page_size: pageSize };

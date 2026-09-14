{
  "properties": {},
  "id": "ttfhw_overview_0001",
  "script": null,
  "groupId": "ttfhwgroup0000000000000000000001",
  "name": "TTFHW总览",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/overview",
  "method": "GET",
  "parameters": [
    {"name": "community", "value": "", "description": "TTFHW 内部社区(可选)，传则整页聚合收敛到该社区，大小写不敏感；不传返回全部", "required": false, "dataType": "String"}
  ],
  "options": [],
  "requestBody": "",
  "headers": [],
  "paths": [],
  "responseBody": null,
  "description": "TTFHW 测试总汇看板总览：结果分布、场景分布、社区分布、月份、四阶段平均耗时(user/developer)、总计。读 dws_ttfhw_run。",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
// TTFHW 总览看板汇总（一次返回，前端画结果饼图/阶段耗时/社区对比/趋势）。数据来自标准 data.json 入库的 dws_ttfhw_run。
// 「中断」(terminated) 的运行没有意义，一律排除（不入统计/图表/latest）。
// community 参数(可选)：非空时整页聚合收敛到该内部社区，大小写不敏感；不传行为不变（向后兼容）。
var commFilter = "";
if (community != null && community != '') { commFilter = " AND LOWER(community) = LOWER(#{community}) "; }
var resultDist = db.select("SELECT result, count(*) AS cnt FROM dws_ttfhw_run WHERE result <> '' AND result <> 'terminated' AND is_current = true" + commFilter + " GROUP BY result ORDER BY cnt DESC");
var scenarioDist = db.select("SELECT scenario, count(*) AS cnt FROM dws_ttfhw_run WHERE scenario <> '' AND result <> 'terminated' AND is_current = true" + commFilter + " GROUP BY scenario ORDER BY cnt DESC");
var communities = db.select("SELECT community, count(*) AS cnt, sum(problem_count) AS problems FROM dws_ttfhw_run WHERE community <> '' AND result <> 'terminated' AND is_current = true" + commFilter + " GROUP BY community ORDER BY cnt DESC");
var months = db.select("SELECT report_month, count(*) AS cnt FROM dws_ttfhw_run WHERE report_month <> '' AND result <> 'terminated' AND is_current = true" + commFilter + " GROUP BY report_month ORDER BY report_month");
// 四阶段平均耗时（min），按场景；阶段名取该场景任一非空
var phaseUser = db.selectOne("SELECT max(p1_name) AS n1, round(avg(nullif(p1_min,0))) AS p1, max(p2_name) AS n2, round(avg(nullif(p2_min,0))) AS p2, max(p3_name) AS n3, round(avg(nullif(p3_min,0))) AS p3, max(p4_name) AS n4, round(avg(nullif(p4_min,0))) AS p4, round(avg(nullif(total_min,0))) AS total FROM dws_ttfhw_run WHERE scenario = 'user' AND result <> 'terminated' AND is_current = true" + commFilter);
var phaseDev = db.selectOne("SELECT max(p1_name) AS n1, round(avg(nullif(p1_min,0))) AS p1, max(p2_name) AS n2, round(avg(nullif(p2_min,0))) AS p2, max(p3_name) AS n3, round(avg(nullif(p3_min,0))) AS p3, max(p4_name) AS n4, round(avg(nullif(p4_min,0))) AS p4, round(avg(nullif(total_min,0))) AS total FROM dws_ttfhw_run WHERE scenario = 'developer' AND result <> 'terminated' AND is_current = true" + commFilter);
var total = db.selectOne("SELECT count(*) AS runs, coalesce(sum(problem_count),0) AS problems, count(distinct community) AS communities FROM dws_ttfhw_run WHERE result <> 'terminated' AND is_current = true" + commFilter);
// 全流程耗时 TOP（横向堆叠柱：y=repo，四阶段堆叠）
var topUser = db.select("SELECT * FROM (SELECT DISTINCT ON (community) repo, community, p1_name, p1_min, p2_name, p2_min, p3_name, p3_min, p4_name, p4_min, total_min, run_date FROM dws_ttfhw_run WHERE scenario = 'user' AND repo <> '' AND result <> 'terminated' AND is_current = true" + commFilter + " ORDER BY community, run_date DESC NULLS LAST) t ORDER BY total_min DESC NULLS LAST LIMIT 15");
var topDev = db.select("SELECT * FROM (SELECT DISTINCT ON (community) repo, community, p1_name, p1_min, p2_name, p2_min, p3_name, p3_min, p4_name, p4_min, total_min, run_date FROM dws_ttfhw_run WHERE scenario = 'developer' AND repo <> '' AND result <> 'terminated' AND is_current = true" + commFilter + " ORDER BY community, run_date DESC NULLS LAST) t ORDER BY total_min DESC NULLS LAST LIMIT 15");
// 各社区+场景「关联 Issue」数 = 经确认流程真正创建的 issue（fact_ttfhw_issue.issue_url 非空）。
// 未确认/未创建的社区场景（如 tilelang 使用者）返回 0，不再由 dwm 回填虚报。community 归一化小写作 key。
var issuesByCommunity = db.select("SELECT LOWER(community) AS community, CASE scenario WHEN '使用者场景' THEN 'user' WHEN '贡献者场景' THEN 'developer' ELSE scenario END AS scenario, count(*) AS total, count(*) FILTER (WHERE issue_state = 'closed') AS closed FROM fact_ttfhw_issue WHERE issue_url IS NOT NULL AND issue_url <> ''" + commFilter + " GROUP BY LOWER(community), 2");
// 历史 dwm_ttfhw_issue（社区级、无场景）：合并进关联 Issue，保留 openGauss 等历史真实关联；
// 排除 url 已在 fact 里的（新确认流程已建的），避免与 issuesByCommunity 重复计数。前端 issueCnt=两者相加。
var issuesDwmByCommunity = db.select("SELECT LOWER(community) AS community, count(*) AS total, count(*) FILTER (WHERE status = 'closed') AS closed FROM dwm_ttfhw_issue WHERE community <> '' AND (url IS NULL OR url NOT IN (SELECT issue_url FROM fact_ttfhw_issue WHERE issue_url IS NOT NULL AND issue_url <> ''))" + commFilter + " GROUP BY LOWER(community)");
return {
  issuesByCommunity: issuesByCommunity,
  issuesDwmByCommunity: issuesDwmByCommunity,
  resultDist: resultDist,
  scenarioDist: scenarioDist,
  communities: communities,
  months: months,
  phaseUser: phaseUser,
  phaseDev: phaseDev,
  topUser: topUser,
  topDev: topDev,
  total: total
};

{
  "properties": {},
  "id": "ttfhw_issues_0001",
  "script": null,
  "groupId": "ttfhwgroup0000000000000000000001",
  "name": "TTFHW手动Issue",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/issues",
  "method": "GET",
  "parameters": [
    {"name": "community", "value": "", "description": "社区(可选)", "required": false, "dataType": "String"},
    {"name": "scenario", "value": "", "description": "场景 user/developer(可选)", "required": false, "dataType": "String"},
    {"name": "status", "value": "", "description": "状态 open/closed(可选)", "required": false, "dataType": "String"}
  ],
  "options": [],
  "requestBody": "",
  "headers": [],
  "paths": [],
  "responseBody": null,
  "description": "TTFHW 手动提交的文档缺陷 Issue（历史 backfill）：按社区/状态查。读 dwm_ttfhw_issue。",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
// 关联 Issue 列表 = 合并两张表：①fact_ttfhw_issue（确认真建，issue_url 非空，带场景）
// + ②历史 dwm_ttfhw_issue（社区级 [TTFHW] 回填，无场景），按 url 去重（dwm 排除已在 fact 的 url）。
// 保留 openGauss 等历史真实关联，同时含用户新确认建的（如 MindSpeed 使用者 1638-1640）。
// scenario 前端传 user/developer，仅过滤 fact（dwm 无场景，社区级一并展示）；community 大小写不敏感。

// 用 SQL UNION ALL 一条查询合并 fact + dwm（避免 magicscript 拼列表；且 dwm.reported_at 是文本、
// 不能 to_char，用 LEFT 取前 10 位）。fact 有场景、dwm 无场景(null)、社区级。
// ① fact 条件
var fCond = " issue_url IS NOT NULL AND issue_url <> '' ";
if (community != null && community != '') { fCond += " AND LOWER(community) = LOWER(#{community}) "; }
if (scenario == 'user')      { fCond += " AND scenario = '使用者场景' "; }
else if (scenario == 'developer') { fCond += " AND scenario = '贡献者场景' "; }
var fCondS = fCond;
if (status == 'closed')   { fCondS += " AND issue_state = 'closed' "; }
else if (status == 'open') { fCondS += " AND (issue_state IS NULL OR issue_state <> 'closed') "; }
// ② dwm 条件（排除 url 已在 fact 的）
var dCond = " community <> '' AND (url IS NULL OR url NOT IN (SELECT issue_url FROM fact_ttfhw_issue WHERE issue_url IS NOT NULL AND issue_url <> '')) ";
if (community != null && community != '') { dCond += " AND LOWER(community) = LOWER(#{community}) "; }
var dCondS = dCond;
if (status == 'closed')   { dCondS += " AND status = 'closed' "; }
else if (status == 'open') { dCondS += " AND (status IS NULL OR status <> 'closed') "; }

var list = db.select("SELECT * FROM ("
  + "SELECT community, CASE scenario WHEN '使用者场景' THEN 'user' WHEN '贡献者场景' THEN 'developer' ELSE scenario END AS scenario, "
  + "repo_url AS repo, platform, issue_url AS url, issue_title AS title, "
  + "CASE WHEN issue_state = 'closed' THEN 'closed' ELSE 'open' END AS status, "
  + "severity AS level, issue_content AS symptom, source, source_run, "
  + "to_char(reported_at, 'YYYY-MM-DD') AS reported_at, 0 AS ord "
  + "FROM fact_ttfhw_issue WHERE " + fCondS + " "
  + "UNION ALL "
  + "SELECT community, null AS scenario, repo, platform, url, title, status, "
  + "level, symptom, source, source_run, LEFT(reported_at, 10) AS reported_at, 1 AS ord "
  + "FROM dwm_ttfhw_issue WHERE " + dCondS + " "
  + ") t ORDER BY ord, (status = 'closed'), reported_at DESC NULLS LAST");

var total = db.selectOne("SELECT (SELECT count(*) FROM fact_ttfhw_issue WHERE " + fCond
  + ") + (SELECT count(*) FROM dwm_ttfhw_issue WHERE " + dCond + ") AS cnt").cnt;
var closed = db.selectOne("SELECT (SELECT count(*) FROM fact_ttfhw_issue WHERE " + fCond + " AND issue_state = 'closed'"
  + ") + (SELECT count(*) FROM dwm_ttfhw_issue WHERE " + dCond + " AND status = 'closed') AS cnt").cnt;
return { total: total, closed: closed, list: list };

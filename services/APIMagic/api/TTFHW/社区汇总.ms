{
  "properties": {},
  "id": "ttfhw_community_summary_0001",
  "script": null,
  "groupId": "ttfhwgroup0000000000000000000001",
  "name": "TTFHW社区汇总",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/communitySummary",
  "method": "GET",
  "parameters": [
    {"name": "ttfhw_community", "value": "", "description": "TTFHW 内部社区(可选)，传则只返回该社区，大小写不敏感；不传返回全部", "required": false, "dataType": "String"},
    {"name": "start", "value": "1767196800000", "description": "开始时间(可选)，毫秒时间戳；按北京时间(Asia/Shanghai)取到日，返回 run_date >= 该日 的行(闭区间)，命名与仓内主流接口一致", "required": false, "dataType": "Long"},
    {"name": "end", "value": "1769875200000", "description": "结束时间(可选)，毫秒时间戳；按北京时间(Asia/Shanghai)取到日，返回 run_date <= 该日 的行(闭区间)；可与 start 单独使用", "required": false, "dataType": "Long"}
  ],
  "options": [],
  "requestBody": "",
  "headers": [],
  "paths": [],
  "responseBody": null,
  "description": "TTFHW 贡献者场景(scenario=developer)按社区维度汇总：TTFHW 总时长=各仓库 total_min 平均，环境准备/全量编译/UT/CI = p1~p4_min 各仓库 P90。source 值不同不混算，source 相同按 run_date 到天聚合。pass_rate=分组内 result 为'success'或'partial'的记录数占该组总记录数的百分比(整数)；result 真实枚举(success/partial/failed)以 PG dws_ttfhw_run 实际值为准，非 issue 描述的中文展示词。读 dws_ttfhw_run。支持可选 start/end 毫秒时间戳参数：按北京时间取到日对 run_date(YYYY-MM-DD) 做闭区间过滤，不传则行为与原来一致。",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
// 按 (社区, source, 到天 run_date) 聚合贡献者场景 TTFHW 指标；参数化绑定防注入。
// 分组铁规：source 不同的批次(如 17号/18号)不混算；source 相同按 run_date 到天聚合。
// 口径：total_min 取平均值，p1~p4_min 取 P90(percentile_cont 0.9)，nullif(x,0) 剔 0 值避免拉低分位/均值(与 总览.ms 一致)。
var where = " WHERE result <> 'terminated' AND is_current = true AND scenario = 'developer' ";
if (ttfhw_community != null && ttfhw_community != '') {
    where += " AND LOWER(community) = LOWER(#{ttfhw_community}) ";
}
// start/end 毫秒时间戳(可选)：按北京时间取到日，对 varchar 型 run_date(YYYY-MM-DD) 做闭区间过滤；
// ISO 日期串字典序=日期序；to_timestamp(#{x}/1000) AT TIME ZONE 'Asia/Shanghai' 避免依赖服务器时区导致日期错位一天。
if (start != null && start != '') {
    where += " AND run_date >= to_char(to_timestamp(#{start}/1000) AT TIME ZONE 'Asia/Shanghai', 'YYYY-MM-DD') ";
}
if (end != null && end != '') {
    where += " AND run_date <= to_char(to_timestamp(#{end}/1000) AT TIME ZONE 'Asia/Shanghai', 'YYYY-MM-DD') ";
}
var sql = "SELECT community, source, run_date, "
    + "count(DISTINCT repo) AS repo_count, "
    + "round(avg(nullif(total_min,0)))::int AS ttfhw_total_min, "
    + "round(percentile_cont(0.9) WITHIN GROUP (ORDER BY nullif(p1_min,0)))::int AS env_prep_p90_min, "
    + "round(percentile_cont(0.9) WITHIN GROUP (ORDER BY nullif(p2_min,0)))::int AS build_p90_min, "
    + "round(percentile_cont(0.9) WITHIN GROUP (ORDER BY nullif(p3_min,0)))::int AS ut_p90_min, "
    + "round(percentile_cont(0.9) WITHIN GROUP (ORDER BY nullif(p4_min,0)))::int AS ci_p90_min, "
    + "round(100.0 * count(*) FILTER (WHERE result IN ('success','partial')) / nullif(count(*),0))::int AS pass_rate "
    + "FROM dws_ttfhw_run "
    + where
    + " GROUP BY community, source, run_date ORDER BY community, source, run_date DESC";
return db.select(sql);

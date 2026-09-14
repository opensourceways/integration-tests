{
  "properties" : { },
  "id" : "copy1780564533624d66242",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "mind系列ci数据",
  "createTime" : null,
  "updateTime" : 1780572154415,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/workflow/mindall",
  "method" : "POST",
  "parameters" : [ ],
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
  "requestBody" : "{\"start\":1777797548376,\"end\":1790389548376}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var start = body.start
var end = body.end
// #1312 昇腾系列看板按主导/参与开源归类：CI 分析页取数按 community 参数化。
// mindall（归类总看板）保持原行为——不加 project 过滤，返回全部；
// mindlead/mindjoin 等聚合看板则数据驱动地按其在 fact_community_structure 里的 active 子社区
// 过滤 project，仅返回本看板范围内的 CI 数据。community 走 #{} 值绑定 + 子查询，无拼接注入。
var community = body.community

var sql = """
    select git_project,project,
    ROUND(AVG(total_duration_seconds)::NUMERIC(10,2)/60, 2) as e2e_time_avg,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_duration_seconds)::NUMERIC(10,2)/60, 2) as e2e_time_p50,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY total_duration_seconds)::NUMERIC(10,2)/60, 2) as e2e_time_p90,
    ROUND(max(total_duration_seconds)::NUMERIC(10,2)/60, 2) as e2e_time_max,

    ROUND(AVG(pending_duration_seconds)::NUMERIC(10,2)/60, 2) as wait_time_avg,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY pending_duration_seconds)::NUMERIC(10,2)/60, 2) as wait_time_p50,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY pending_duration_seconds)::NUMERIC(10,2)/60, 2) as wait_time_p90,
    ROUND(max(pending_duration_seconds)::NUMERIC(10,2)/60, 2) as wait_time_max,

    ROUND(AVG(running_duration_seconds)::NUMERIC(10,2)/60, 2) as run_time_avg,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY running_duration_seconds)::NUMERIC(10,2)/60, 2) as run_time_p50,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY running_duration_seconds)::NUMERIC(10,2)/60, 2) as run_time_p90,
    ROUND(max(running_duration_seconds)::NUMERIC(10,2)/60, 2) as run_time_max


from fact_ci_task_metric where project!='unknown'
        <if test="community != null and community != '' and community != 'mindall'">
        AND project IN (select name from fact_community_structure where parent_name = #{community} and status = 'active')
        </if>
        <if test="start != null and start != ''">AND timestamp >= to_timestamp(#{start}/1000)</if>
        <if test="end != null and end != ''">AND timestamp <= to_timestamp(#{end}/1000)</if>
GROUP BY git_project,project 

 """
return db.select(sql);


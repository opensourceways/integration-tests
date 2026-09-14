{
  "properties" : { },
  "id" : "copy1779096597131d146",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "workflow详细数据",
  "createTime" : null,
  "updateTime" : 1779110306068,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/workflow/metric",
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
  "requestBody" : null,
  "headers" : [],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var start_time = body.start
var end_time = body.end
var created_at = body.created_at
var repo = body.repo
var org = body.owner


var sql = """


        SELECT
    w.org,
    w.repo,
    w.workflow_path,
    w.npu_type,
    w.device_type,
    COUNT(DISTINCT w.workflow_id) as execution_count,
    ROUND(AVG(w.workflow_run_time)::NUMERIC(10,2)/60, 2) as e2e_time_avg,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY w.workflow_run_time)::NUMERIC(10,2)/60, 2) as e2e_time_p50,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY w.workflow_run_time)::NUMERIC(10,2)/60, 2) as e2e_time_p90,

    ROUND(AVG(w.workflow_wait_time)::NUMERIC(10,2)/60, 2) as wait_time_avg,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY w.workflow_wait_time)::NUMERIC(10,2)/60, 2) as wait_time_p50,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY w.workflow_wait_time)::NUMERIC(10,2)/60, 2) as wait_time_p90,

    ROUND(AVG(w.prepare_time)::NUMERIC(10,2)/60, 2) as prepare_time_avg,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY w.prepare_time)::NUMERIC(10,2)/60, 2) as prepare_time_p50,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY w.prepare_time)::NUMERIC(10,2)/60, 2) as prepare_time_p90,

    ROUND(AVG(w.download_time)::NUMERIC(10,2)/60, 2) as download_time_avg,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY w.download_time)::NUMERIC(10,2)/60, 2) as download_time_p50,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY w.download_time)::NUMERIC(10,2)/60, 2) as download_time_p90,

    ROUND(AVG(w.job_run_time)::NUMERIC(10,2)/60, 2) as run_time_avg,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY w.job_run_time)::NUMERIC(10,2)/60, 2) as run_time_p50,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY w.job_run_time)::NUMERIC(10,2)/60, 2) as run_time_p90
FROM (
    SELECT
        org, repo, workflow_path,
        CASE
            WHEN npu_type = 'a2b3' THEN 'a2'
            WHEN npu_type IN ('a2', 'a3','310p', 'unknown') THEN npu_type
            ELSE ''
        END AS npu_type,
        device_type, workflow_id,
        MAX(workflow_run_time) as workflow_run_time,
        MAX(workflow_wait_time) as workflow_wait_time,
        MAX(job_run_time) as job_run_time,
        MAX(prepare_time) as prepare_time,
        MAX(download_time) as download_time
    FROM fact_ci_workflow_step
    WHERE
        workflow_run_time IS NOT NULL
        AND device_type = 'NPU'
        AND npu_type != 'unknown'
        <if test="repo != null and repo != ''">AND repo = #{repo}</if>
        <if test="org != null and org != ''">AND org = #{org}</if>
        <if test="created_at != null and created_at != ''">AND workflow_created_at >= #{created_at}</if>
        <if test="start_time != null and start_time != ''">AND workflow_created_at >= to_timestamp(#{start_time}/1000)</if>
        <if test="end_time != null and end_time != ''">AND workflow_created_at <= to_timestamp(#{end_time}/1000)</if>
    GROUP BY org, repo, workflow_path, npu_type, device_type, workflow_id
) w
GROUP BY w.org, w.repo, w.workflow_path, w.npu_type, w.device_type

 """
return db.select(sql);


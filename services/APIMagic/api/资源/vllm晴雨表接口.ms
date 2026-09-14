{
  "properties" : { },
  "id" : "5827945459df43b0b80c97e7b7206bd6",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "vllm晴雨表接口",
  "createTime" : null,
  "updateTime" : 1780556089270,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/ci/vllm-metrics",
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
  "requestBody" : "{\"start\":1777797548376,\"end\":1780389548376}",
  "headers" : [ ],
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
SELECT jsonb_build_object(
    'ttfhw', COALESCE(
        (SELECT jsonb_object_agg(t.project, to_jsonb(t.display))
         FROM (
             SELECT DISTINCT ON (project) project, display
             FROM dws_ci_ttfhw WHERE series = 'vllm'
             ORDER BY project, report_month DESC
         ) t),
        '{}'::jsonb
    ),
    'ci_e2e_time', jsonb_object_agg(r.repo,
        CASE WHEN w.e2e_time_avg IS NOT NULL THEN to_jsonb(w.e2e_time_avg) ELSE to_jsonb('/'::text) END
    ),
    'ci_queue_time', jsonb_object_agg(r.repo, 
        CASE WHEN w.wait_time_avg IS NOT NULL THEN to_jsonb(w.wait_time_avg) ELSE to_jsonb('/'::text) END
    ),
    'ci_prepare_time', jsonb_object_agg(r.repo, 
        -- 【修复】将 prepare_time_avg 改为内层实际输出的 pre_time_avg
        CASE WHEN w.pre_time_avg IS NOT NULL THEN to_jsonb(w.pre_time_avg) ELSE to_jsonb('/'::text) END
    ),
    'ci_execute_time', jsonb_object_agg(r.repo, 
        CASE WHEN w.run_time_avg IS NOT NULL THEN to_jsonb(w.run_time_avg) ELSE to_jsonb('/'::text) END
    )
) AS result_json
FROM (
    VALUES ('vllm-ascend'), ('sglang'), ('verl'), ('ms-swift'), ('LLaMA-Factory'), ('tilelang-mlir-ascend'), ('triton-ascend')
) AS r(repo)
LEFT JOIN (
    -- 【修复】补全 LEFT JOIN 子查询的闭合括号，并将别名 w 放在正确的位置
    SELECT 
        repo,
        e2e_time_avg,
        wait_time_avg,
        -- 使用 COALESCE 防止 NULL 参与加法运算导致整体为空
        COALESCE(download_time_avg, 0) + COALESCE(prepare_time_avg, 0) AS pre_time_avg,
        run_time_avg
    FROM (
        SELECT 
            repo,
            ROUND(AVG(workflow_run_time)::NUMERIC(10,2)/60, 2) AS e2e_time_avg,
            ROUND(AVG(workflow_wait_time)::NUMERIC(10,2)/60, 2) AS wait_time_avg,
            ROUND(AVG(prepare_time)::NUMERIC(10,2)/60, 2) AS prepare_time_avg,
            ROUND(AVG(download_time)::NUMERIC(10,2)/60, 2) AS download_time_avg,
            ROUND(AVG(job_run_time)::NUMERIC(10,2)/60, 2) AS run_time_avg
        FROM (
            SELECT 
                repo,
                workflow_id,
                MAX(workflow_run_time) AS workflow_run_time, 
                MAX(workflow_wait_time) AS workflow_wait_time,
                MAX(prepare_time) AS prepare_time,
                MAX(download_time) AS download_time,
                MAX(job_run_time) AS job_run_time
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
            GROUP BY repo, workflow_id
        ) base_data
        GROUP BY repo
    ) agg_data
) w ON r.repo = w.repo;

 """

var res = db.select(sql);
var json = res.get(0).get("result_json")
return json.value::json


{
  "properties" : { },
  "id" : "ci_workflow_steps_raw_486_0005",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "CI-workflow-step数据",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/ci/workflow-steps",
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
  "requestBody" : "{\n    \"org\": \"mindspore\",\n    \"repo\": \"mindspore\",\n    \"workflow_id\": \"123456789\"\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var org = body.org;
var repo = body.repo;
var workflow_id = body.workflow_id;

// 返回该 workflow 的全部 step 原始行（含 job 维度字段）；
// 前端据此 fact_ci_workflow_step 数据按 job_id 分组，得到 job -> step 层级，避免逐 job 二次查询
var sql = """
SELECT
    job_id,
    job_name,
    job_status,
    job_conclusion,
    ROUND(job_run_time::NUMERIC/60, 2)  AS job_run_time,
    ROUND(job_wait_time::NUMERIC/60, 2) AS job_wait_time,
    job_started_at,
    step_number,
    step_name,
    step_status,
    step_conclusion,
    step_run_time
FROM fact_ci_workflow_step
WHERE workflow_id = #{workflow_id}
    <if test="org != null and org != ''">AND org = #{org}</if>
    <if test="repo != null and repo != ''">AND repo = #{repo}</if>
ORDER BY job_started_at, job_id, step_number
""";

var list = db.select(sql);
var result = new HashMap();
result.put("list", list);
result.put("total_count", list.size());
return result;

{
  "properties" : { },
  "id" : "ci_workflow_run_detail_486_0002",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "CI-workflow执行明细",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/ci/workflow-run-detail",
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
  "requestBody" : "{\n    \"org\": \"mindspore\",\n    \"repo\": \"mindspore\",\n    \"workflow_path\": \"\",\n    \"device_type\": \"NPU\",\n    \"npu_type\": \"a2\",\n    \"require_run_time\": true,\n    \"keyword\": \"\",\n    \"start\": 1577808000000,\n    \"end\": 1898526240605,\n    \"pageNum\": 1,\n    \"pageSize\": 10,\n    \"desc\": \"created_at\"\n}",
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
var workflow_path = body.workflow_path;
var device_type = body.device_type;
// npu_type（资源）：下钻须与 CI 数据表(/res/workflow/metric)同维度过滤，否则执行次数对不上。
// 不传 => null（CI测试用例统计下钻，按 org+repo+device_type 维度，不细分 npu_type）；
// 传 "" 或具体型号 => 按归一化后的 npu_type 精确匹配（含空串桶）。
var npu_type = body.npu_type;
// 与 metric 接口对齐：仅统计 workflow_run_time 非空的执行，保证数量一致。
var require_run_time = body.require_run_time;
var keyword = body.keyword;
var start_time = body.start;
var end_time = body.end;

// 分页参数（workflow 数据分页查询，不一次性全部拉出）
var page_num = 1;
if (body.pageNum != null and body.pageNum != "") { page_num = body.pageNum; }
var page_size = 10;
if (body.pageSize != null and body.pageSize != "") { page_size = body.pageSize; }
if (page_num < 1) { page_num = 1; }
if (page_size < 1) { page_size = 10; }
if (page_size > 100) { page_size = 100; }
var offset = (page_num - 1) * page_size;

// 排序白名单（防 SQL 注入：仅允许下列字段拼入 ORDER BY）
var sort_field = ["workflow_name", "workflow_path", "npu_type", "run_time", "wait_time", "created_at"];
var order_by_set = new HashSet();
if (body.asc != null and body.asc != "") {
    for (index, item in body.asc.split(",")) {
        if (sort_field.contains(item)) { order_by_set.add(item + " asc"); }
    }
}
if (body.desc != null and body.desc != "") {
    for (index, item in body.desc.split(",")) {
        if (sort_field.contains(item)) { order_by_set.add(item + " desc"); }
    }
}
var order_by = "created_at desc";
if (order_by_set.size() > 0) { order_by = order_by_set.join(","); }

var sql = """
WITH runs AS (
    SELECT
        workflow_id,
        MAX(commit_id)       AS commit_id,
        MAX(workflow_name)   AS workflow_name,
        MAX(workflow_path)   AS workflow_path,
        MAX(workflow_status) AS workflow_status,
        MAX(device_type)     AS device_type,
        MAX(CASE WHEN npu_type = 'a2b3' THEN 'a2' ELSE npu_type END) AS npu_type,
        ROUND(MAX(workflow_run_time)::NUMERIC/60, 2)  AS run_time,
        ROUND(MAX(workflow_wait_time)::NUMERIC/60, 2) AS wait_time,
        MAX(workflow_created_at) AS created_at
    FROM fact_ci_workflow_step
    WHERE org = #{org}
        AND repo = #{repo}
        <if test="device_type != null and device_type != ''">AND device_type = #{device_type}</if>
        <if test="workflow_path != null and workflow_path != ''">AND workflow_path = #{workflow_path}</if>
        <if test="npu_type != null">AND (CASE WHEN npu_type = 'a2b3' THEN 'a2' WHEN npu_type IN ('a2', 'a3', '310p', 'unknown') THEN npu_type ELSE '' END) = #{npu_type}</if>
        <if test="require_run_time == true">AND workflow_run_time IS NOT NULL</if>
        <if test="keyword != null and keyword != ''">AND (workflow_name ILIKE ('%' || #{keyword} || '%') OR workflow_path ILIKE ('%' || #{keyword} || '%'))</if>
        <if test="start_time != null and start_time != ''">AND workflow_created_at >= to_timestamp(#{start_time}/1000)</if>
        <if test="end_time != null and end_time != ''">AND workflow_created_at <= to_timestamp(#{end_time}/1000)</if>
    GROUP BY workflow_id
),
count_ori AS (
    SELECT COUNT(1) AS total_count FROM runs
)
SELECT r.*, c.total_count, CEIL(c.total_count::numeric/#{page_size}) AS total_page
FROM runs r, count_ori c
ORDER BY ${order_by}
LIMIT #{page_size} OFFSET #{offset}
""";

var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    return item;
});

var result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
return result;

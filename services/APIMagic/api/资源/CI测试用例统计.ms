{
  "properties" : { },
  "id" : "ci_testcase_stats_486_0001",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "CI测试用例统计",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/ci/test-case-stats",
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
  "requestBody" : "{\n    \"start\": 1577808000000,\n    \"end\": 1898526240605,\n    \"org\": \"\",\n    \"repo\": \"\",\n    \"pageNum\": 1,\n    \"pageSize\": 10,\n    \"desc\": \"npu_exec_count\"\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var start_time = body.start;
var end_time = body.end;
var org = body.org;
var repo = body.repo;

// 分页参数
var page_num = 1;
if (body.pageNum != null and body.pageNum != "") { page_num = body.pageNum; }
var page_size = 10;
if (body.pageSize != null and body.pageSize != "") { page_size = body.pageSize; }
if (page_num < 1) { page_num = 1; }
if (page_size < 1) { page_size = 10; }
if (page_size > 100) { page_size = 100; }
var offset = (page_num - 1) * page_size;

// 排序白名单（防 SQL 注入：只允许下列字段拼入 ORDER BY）
var sort_field = ["repo", "npu_file_count", "npu_exec_count", "gpu_file_count", "gpu_exec_count"];
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
var order_by = null;
if (order_by_set.size() > 0) { order_by = order_by_set.join(","); }

var sql = """
WITH stats AS (
    SELECT
        org,
        repo,
        COUNT(DISTINCT CASE WHEN device_type = 'NPU' THEN workflow_path END) AS npu_file_count,
        COUNT(DISTINCT CASE WHEN device_type = 'NPU' THEN workflow_id END)   AS npu_exec_count,
        COUNT(DISTINCT CASE WHEN device_type = 'GPU' THEN workflow_path END) AS gpu_file_count,
        COUNT(DISTINCT CASE WHEN device_type = 'GPU' THEN workflow_id END)   AS gpu_exec_count
    FROM fact_ci_workflow_step
    WHERE device_type IN ('NPU', 'GPU')
        <if test="start_time != null and start_time != ''">AND workflow_created_at >= to_timestamp(#{start_time}/1000)</if>
        <if test="end_time != null and end_time != ''">AND workflow_created_at <= to_timestamp(#{end_time}/1000)</if>
        <if test="org != null and org != ''">AND org = #{org}</if>
        <if test="repo != null and repo != ''">AND repo = #{repo}</if>
    GROUP BY org, repo
    HAVING (COUNT(DISTINCT CASE WHEN device_type = 'NPU' THEN workflow_id END) > 0
         OR COUNT(DISTINCT CASE WHEN device_type = 'GPU' THEN workflow_id END) > 0)
),
count_ori AS (
    SELECT COUNT(1) AS total_count FROM stats
)
SELECT s.*, c.total_count, CEIL(c.total_count::numeric/#{page_size}) AS total_page
FROM stats s, count_ori c
<if test="order_by != null and order_by != ''">ORDER BY ${order_by}</if>
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

{
  "properties" : { },
  "id" : "ai-overview-001",
  "script" : null,
  "groupId" : "ai-metrics-group-001",
  "name" : "概览数据",
  "createTime" : null,
  "updateTime" : 1776653603814,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/overview",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1776653529688,\r\n    \"community\":\"openeuler\",\r\n    \"sig\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"ai_pr_total\": 150,\n        \"pr_total\": 1000,\n        \"ai_pr_ratio\": 0.15,\n        \"ai_addcode_total\": 5000,\n        \"addcode_total\": 30000,\n        \"ai_addcode_ratio\": 0.17,\n        \"ai_sig_count\": 20,\n        \"total_sig_count\": 50,\n        \"sig_coverage_ratio\": 0.40,\n        \"ai_ci_pass_rate\": 0.85,\n        \"ci_pass_rate\": 0.90,\n        \"ai_developer_total\": 45,\n        \"developer_total\": 200,\n        \"ai_developer_ratio\": 0.23\n    }\n}",
  "description" : null,
  "requestBodyDefinition" : {
    "name" : "",
    "value" : "",
    "description" : "",
    "required" : false,
    "dataType" : "Object",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : [ {
      "name" : "start",
      "value" : "1730419200000",
      "description" : "开始时间戳",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1776653529688",
      "description" : "结束时间戳",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "openeuler",
      "description" : "社区名称",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community参数仅支持openeuler、opengauss或openubmc",
      "expression" : "^(openeuler|opengauss|openubmc)$",
      "children" : [ ]
    }, {
      "name" : "sig",
      "value" : "",
      "description" : "SIG名称筛选",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "sig参数格式非法（仅允许字母数字下划线短横线，1-64位）",
      "expression" : "^([a-zA-Z0-9_-]{1,64})?$",
      "children" : [ ]
    } ]
  }
}
================================
var start = body.start;
var end = body.end;
var community = body.community.toLowerCase();
var sig = body.sig;
var sigDailyTable = "dws_" + community + "_contribute_sig_daily";

// 从 sig_daily 表查询 PR 和 SIG 统计
var sigSql = """
SELECT
  SUM(ai_pr_merged_incre) as ai_pr_total,
  SUM(merged_pr_incre) as pr_total,
  ROUND(CASE WHEN SUM(merged_pr_incre) > 0 THEN SUM(ai_pr_merged_incre)::NUMERIC / SUM(merged_pr_incre) ELSE 0 END, 4) as ai_pr_ratio,
  COUNT(DISTINCT sig_name) FILTER (WHERE ai_pr_merged_incre > 0) as ai_sig_count,
  SUM(ai_ci_failed_incre) as ai_ci_failed_count,
  ROUND(CASE WHEN SUM(ai_pr_incre) > 0 THEN 1 - SUM(ai_ci_failed_incre)::NUMERIC / SUM(ai_pr_incre) ELSE 1 END, 4) as ai_ci_pass_rate,
  SUM(ci_failed_incre) as ci_failed_count,
  ROUND(CASE WHEN SUM(pr_incre) > 0 THEN 1 - SUM(ci_failed_incre)::NUMERIC / SUM(pr_incre) ELSE 1 END, 4) as ci_pass_rate
FROM ${sigDailyTable}
<where>
  <if test="start != null and start != ''">
    date >= to_timestamp(#{start}/1000)::date
  </if>
  <if test="end != null and end != ''">
    AND date <= to_timestamp(#{end}/1000)::date
  </if>
  <if test="sig != null and sig != ''">
    AND sig_name = #{sig}
  </if>
</where>
""";

var data = db.selectOne(sigSql);

// total_sig_count 取全量 SIG 目录（fact_{community}_sig_detail_info），而非 sig_daily 中出现过的 SIG
var sigDetailTable = "fact_" + community + "_sig_detail_info";
var sigCountSql = """
SELECT COUNT(*) as total_sig_count
FROM ${sigDetailTable}
WHERE is_removed IS NULL
<if test="sig != null and sig != ''">
  AND sig_name = #{sig}
</if>
""";
var sigCountResult = db.selectOne(sigCountSql);
var totalSigCount = sigCountResult.total_sig_count || 0;
var aiSigCount = data.ai_sig_count || 0;
data.total_sig_count = totalSigCount;
data.sig_coverage_ratio = totalSigCount > 0 ? Math.round(aiSigCount * 10000.0 / totalSigCount) / 10000.0 : 0;

// 从 contribute 表查询代码量和开发者统计
var contributeTable = "dws_" + community + "_prissue_comment";
var codeSql = """
WITH base_data AS (
    SELECT user_login, is_ai_pr, SUM(add) as add_sum
    FROM ${contributeTable}
    WHERE contrib_type = 'pr' AND is_removed IS NULL AND state = 'merged'
      <if test="start != null and start != ''">
        AND created_at >= to_timestamp(#{start}/1000)
      </if>
      <if test="end != null and end != ''">
        AND created_at <= to_timestamp(#{end}/1000)
      </if>
      <if test="sig != null and sig != ''">
        AND #{sig} = ANY(sig_name)
      </if>
    GROUP BY user_login, is_ai_pr
)
SELECT 
    SUM(add_sum) AS addcode_total,
    SUM(add_sum) FILTER (WHERE is_ai_pr=1) AS ai_addcode_total,
    ROUND(COALESCE(SUM(add_sum) FILTER (WHERE is_ai_pr=1)::NUMERIC / NULLIF(SUM(add_sum),0),0),4) AS ai_addcode_ratio,
    COUNT(*) AS developer_total,
    COUNT(*) FILTER (WHERE is_ai_pr=1) AS ai_developer_total,
    ROUND(COALESCE(COUNT(*) FILTER (WHERE is_ai_pr=1)::NUMERIC / NULLIF(COUNT(*),0),0),4) AS ai_developer_ratio
FROM base_data;
""";

var codeResult = db.selectOne(codeSql);

// 合并结果
data.addcode_total = codeResult.addcode_total || 0;
data.ai_addcode_total = codeResult.ai_addcode_total || 0;
data.ai_addcode_ratio = codeResult.ai_addcode_ratio || 0;
data.developer_total = codeResult.developer_total || 0;
data.ai_developer_total = codeResult.ai_developer_total || 0;
data.ai_developer_ratio = codeResult.ai_developer_ratio || 0;

return data;
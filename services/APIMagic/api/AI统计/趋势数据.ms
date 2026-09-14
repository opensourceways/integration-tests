{
  "properties" : { },
  "id" : "ai-trend-001",
  "script" : null,
  "groupId" : "ai-metrics-group-001",
  "name" : "趋势数据",
  "createTime" : null,
  "updateTime" : 1776653603814,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/trend",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1776653529688,\r\n    \"community\":\"openeuler\",\r\n    \"sig\":\"\",\r\n    \"metric_type\":\"ai_pr_incre\",\r\n    \"interval\":\"day\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [\n        {\n            \"date\": \"2025-06-01\",\n            \"value\": 150\n        },\n        {\n            \"date\": \"2025-06-02\",\n            \"value\": 165\n        }\n    ]\n}",
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
    }, {
      "name" : "metric_type",
      "value" : "ai_pr_incre",
      "description" : "指标类型：ai_pr_incre 或 ai_pr_merged_incre（均按合入口径统计）",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "metric_type参数必须是ai_pr_incre或ai_pr_merged_incre",
      "expression" : "^(ai_pr_incre|ai_pr_merged_incre)$",
      "children" : [ ]
    }, {
      "name" : "interval",
      "value" : "day",
      "description" : "时间间隔：day、week或month",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "interval参数必须是day、week或month",
      "expression" : "^(day|week|month)$",
      "children" : [ ]
    } ]
  }
}
================================
var start = body.start;
var end = body.end;
var community = body.community.toLowerCase();
var sig = body.sig;
var metric_type = body.metric_type;
var interval = body.interval;
var sigDailyTable = "dws_" + community + "_contribute_sig_daily";

// 统一走合入口径：metric_type 已由参数正则白名单约束（^(ai_pr_incre|ai_pr_merged_incre)$），
// 无论传哪个合法值都映射到合入列 ai_pr_merged_incre（${} 为原文拼接，用常量避免注入）
var metricCol = 'ai_pr_merged_incre';

var sql = """
SELECT
  date_trunc('${interval}', date) as date,
  SUM(${metricCol}) as value
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
GROUP BY date_trunc('${interval}', date)
ORDER BY date_trunc('${interval}', date) ASC
""";

return db.select(sql);
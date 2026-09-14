{
  "properties" : { },
  "id" : "ai-sig-stats-001",
  "script" : null,
  "groupId" : "ai-metrics-group-001",
  "name" : "SIG统计",
  "createTime" : null,
  "updateTime" : 1776653603814,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/sig-stats",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1776653529688,\r\n    \"community\":\"openeuler\",\r\n    \"page\":1,\r\n    \"page_size\":20\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 45,\n        \"page\": 1,\n        \"page_size\": 20,\n        \"list\": [{\n            \"sig_name\": \"sig-A\",\n            \"ai_pr_total\": 30\n        }]\n    }\n}",
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
      "name" : "page",
      "value" : "1",
      "description" : "页码",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "page必须大于等于1",
      "expression" : "page == null || (page >= 1 && page <= 10000)",
      "children" : [ ]
    }, {
      "name" : "page_size",
      "value" : "20",
      "description" : "每页条数",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "page_size必须在1-100之间",
      "expression" : "page_size == null || (page_size >= 1 && page_size <= 100)",
      "children" : [ ]
    } ]
  }
}
================================
var start = body.start;
var end = body.end;
var community = body.community.toLowerCase();
var page = body.page || 1;
var pageSize = body.page_size || 20;
var offset = (page - 1) * pageSize;
// 排序：sort 字段走白名单防注入，order 只接受 asc/desc（默认 ai_pr_total desc）
var sortWhitelist = ["ai_pr_total", "sig_name"];
var sortField = sortWhitelist.contains(body.sort) ? body.sort : "ai_pr_total";
var sortOrder = (body.order == "asc") ? "asc" : "desc";
var orderByClause = sortField + " " + sortOrder;
// SIG 名称搜索（可选，非空时按 LIKE 过滤，用 #{} 占位防注入）
var sig_name = body.sig_name;
var sigDailyTable = "dws_" + community + "_contribute_sig_daily";
var sigDetailTable = "fact_" + community + "_sig_detail_info";

// 展示全部 SIG（含无 AI 贡献），SIG 全集取自 sig_detail_info
var totalSql = """
SELECT COUNT(*) as total
FROM ${sigDetailTable}
WHERE is_removed IS NULL
<if test="sig_name != null and sig_name != ''">
  AND sig_name LIKE CONCAT('%', #{sig_name}, '%')
</if>
""";
var totalResult = db.select(totalSql);
var total = totalResult[0].total;

// LEFT JOIN AI 合入聚合：无贡献 SIG 的 ai_pr_total 记 0，排序沉底但仍出现在列表
var listSql = """
SELECT
  s.sig_name,
  COALESCE(a.ai_pr_total, 0) as ai_pr_total
FROM ${sigDetailTable} s
LEFT JOIN (
  SELECT sig_name, SUM(ai_pr_merged_incre) as ai_pr_total
  FROM ${sigDailyTable}
  <where>
    <if test="start != null and start != ''">
      date >= to_timestamp(#{start}/1000)::date
    </if>
    <if test="end != null and end != ''">
      AND date <= to_timestamp(#{end}/1000)::date
    </if>
  </where>
  GROUP BY sig_name
) a ON a.sig_name = s.sig_name
WHERE s.is_removed IS NULL
<if test="sig_name != null and sig_name != ''">
  AND s.sig_name LIKE CONCAT('%', #{sig_name}, '%')
</if>
ORDER BY ${orderByClause}, s.sig_name ASC
LIMIT #{pageSize} OFFSET #{offset}
""";
var list = db.select(listSql);

return {
  "total": total,
  "page": page,
  "page_size": pageSize,
  "list": list
};
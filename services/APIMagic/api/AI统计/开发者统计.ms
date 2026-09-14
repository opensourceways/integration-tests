{
  "properties" : { },
  "id" : "ai-dev-stats-001",
  "script" : null,
  "groupId" : "ai-metrics-group-001",
  "name" : "开发者统计",
  "createTime" : null,
  "updateTime" : 1776653603814,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/developer-stats",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1776653529688,\r\n    \"community\":\"openeuler\",\r\n    \"page\":1,\r\n    \"page_size\":20\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 120,\n        \"page\": 1,\n        \"page_size\": 20,\n        \"list\": [{\n            \"user_login\": \"developer1\",\n            \"ai_pr_count\": 15,\n            \"total_pr_count\": 50,\n            \"ai_pr_ratio\": 0.30,\n            \"ai_agent_platform\": \"Claude\",\n            \"ai_model_name\": \"Claude Opus\"\n        }]\n    }\n}",
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
// 后端排序：sort 字段走白名单防注入，order 只接受 asc/desc（#1348 #4：改前端拉全量为后端排序分页）
var sortWhitelist = ["ai_pr_count", "total_pr_count", "ai_pr_ratio"];
var sortField = sortWhitelist.contains(body.sort) ? body.sort : "ai_pr_count";
var sortOrder = (body.order == "asc") ? "asc" : "desc";
var orderByClause = sortField + " " + sortOrder;
// 开发者名称搜索（可选，非空时按 LIKE 过滤，用 #{} 占位防注入）
var user_login = body.user_login;
var contributeTable = "dws_" + community + "_prissue_comment";

var totalSql = """
SELECT COUNT(DISTINCT user_login) as total
FROM ${contributeTable}
<where>
  is_ai_pr = 1 AND contrib_type = 'pr' AND is_removed IS NULL AND state = 'merged'
  <if test="start != null and start != ''">
    AND created_at >= to_timestamp(#{start}/1000)
  </if>
  <if test="end != null and end != ''">
    AND created_at <= to_timestamp(#{end}/1000)
  </if>
  <if test="user_login != null and user_login != ''">
    AND user_login LIKE CONCAT('%', #{user_login}, '%')
  </if>
</where>
""";
var totalResult = db.select(totalSql);
var total = totalResult[0].total;

var listSql = """
SELECT 
  user_login,
  COUNT(*) FILTER (WHERE is_ai_pr = 1) as ai_pr_count,
  COUNT(*) as total_pr_count,
  ROUND(CASE WHEN COUNT(*) > 0 THEN COUNT(*) FILTER (WHERE is_ai_pr = 1)::decimal / COUNT(*) ELSE 0 END, 4) as ai_pr_ratio,
  MODE() WITHIN GROUP (ORDER BY ai_agent_platform) as ai_agent_platform,
  MODE() WITHIN GROUP (ORDER BY ai_model_name) as ai_model_name
FROM ${contributeTable}
<where>
  contrib_type = 'pr' AND is_removed IS NULL AND state = 'merged'
  <if test="start != null and start != ''">
    AND created_at >= to_timestamp(#{start}/1000)
  </if>
  <if test="end != null and end != ''">
    AND created_at <= to_timestamp(#{end}/1000)
  </if>
  <if test="user_login != null and user_login != ''">
    AND user_login LIKE CONCAT('%', #{user_login}, '%')
  </if>
</where>
GROUP BY user_login
HAVING COUNT(*) FILTER (WHERE is_ai_pr = 1) > 0
ORDER BY ${orderByClause}
LIMIT #{pageSize} OFFSET #{offset}
""";
var list = db.select(listSql);

return {
  "total": total,
  "page": page,
  "page_size": pageSize,
  "list": list
};
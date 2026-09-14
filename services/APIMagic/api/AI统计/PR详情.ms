{
  "properties" : { },
  "id" : "ai-pr-detail-001",
  "script" : null,
  "groupId" : "ai-metrics-group-001",
  "name" : "PR详情",
  "createTime" : null,
  "updateTime" : 1776653603814,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/pr-detail",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1776653529688,\r\n    \"community\":\"openeuler\",\r\n    \"user_login\":\"developer1\",\r\n    \"sig\":\"\",\r\n    \"page\":1,\r\n    \"page_size\":20\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 15,\n        \"page\": 1,\n        \"page_size\": 20,\n        \"list\": [{\n            \"html_url\": \"https://gitcode.com/org/repo/pull/123\",\n            \"repo_path\": \"repo\",\n            \"sig_name\": \"sig-a\",\n            \"ai_agent_platform\": \"Claude\",\n            \"ai_model_name\": \"Claude Opus\",\n            \"state\": \"merged\",\n            \"created_at\": \"2025-01-15T10:30:00Z\"\n        }]\n    }\n}",
  "description" : "AI 度量看板：按开发者(user_login)或 SIG(sig) 查询 AI 合入 PR 明细，供开发者/SIG 表格点击 PR 数量下钻弹窗使用",
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
      "name" : "user_login",
      "value" : "",
      "description" : "按开发者过滤（开发者维度下钻）",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "sig",
      "value" : "",
      "description" : "按 SIG 过滤（SIG 维度下钻）",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "ai_agent_platform",
      "value" : "",
      "description" : "按 AI 工具(Agent)类型过滤（弹窗类型筛选）",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "",
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
var userLogin = body.user_login;
var sig = body.sig;
var aiAgentPlatform = body.ai_agent_platform;
var page = body.page || 1;
var pageSize = body.page_size || 20;
var offset = (page - 1) * pageSize;
var contributeTable = "dws_" + community + "_prissue_comment";

var totalSql = """
SELECT COUNT(*) as total
FROM ${contributeTable}
<where>
  is_ai_pr = 1 AND contrib_type = 'pr' AND is_removed IS NULL AND state = 'merged'
  <if test="userLogin != null and userLogin != ''">
    AND user_login = #{userLogin}
  </if>
  <if test="sig != null and sig != ''">
    AND #{sig} = ANY(sig_name)
  </if>
  <if test="aiAgentPlatform != null and aiAgentPlatform != ''">
    AND ai_agent_platform = #{aiAgentPlatform}
  </if>
  <if test="start != null and start != ''">
    AND created_at >= to_timestamp(#{start}/1000)
  </if>
  <if test="end != null and end != ''">
    AND created_at <= to_timestamp(#{end}/1000)
  </if>
</where>
""";
var totalResult = db.select(totalSql);
var total = totalResult[0].total;

var listSql = """
SELECT
  html_url,
  repo_path,
  array_to_string(sig_name, ',') as sig_name,
  user_login,
  ai_agent_platform,
  ai_model_name,
  state,
  created_at
FROM ${contributeTable}
<where>
  is_ai_pr = 1 AND contrib_type = 'pr' AND is_removed IS NULL AND state = 'merged'
  <if test="userLogin != null and userLogin != ''">
    AND user_login = #{userLogin}
  </if>
  <if test="sig != null and sig != ''">
    AND #{sig} = ANY(sig_name)
  </if>
  <if test="aiAgentPlatform != null and aiAgentPlatform != ''">
    AND ai_agent_platform = #{aiAgentPlatform}
  </if>
  <if test="start != null and start != ''">
    AND created_at >= to_timestamp(#{start}/1000)
  </if>
  <if test="end != null and end != ''">
    AND created_at <= to_timestamp(#{end}/1000)
  </if>
</where>
ORDER BY created_at DESC
LIMIT #{pageSize} OFFSET #{offset}
""";
var list = db.select(listSql);

return {
  "total": total,
  "page": page,
  "page_size": pageSize,
  "list": list
};

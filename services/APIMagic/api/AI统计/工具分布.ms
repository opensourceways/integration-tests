{
  "properties" : { },
  "id" : "ai-tool-dist-001",
  "script" : null,
  "groupId" : "ai-metrics-group-001",
  "name" : "工具分布",
  "createTime" : null,
  "updateTime" : 1776653603814,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/tool-distribution",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1776653529688,\r\n    \"community\":\"openeuler\",\r\n    \"top_n\":10\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"agent\": \"Claude\",\n        \"model\": \"Claude Opus\",\n        \"count\": 45\n    }]\n}",
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
      "name" : "top_n",
      "value" : "10",
      "description" : "返回前N个",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "top_n必须在1-100之间",
      "expression" : "top_n == null || (top_n >= 1 && top_n <= 100)",
      "children" : [ ]
    } ]
  }
}
================================
var start = body.start;
var end = body.end;
var community = body.community.toLowerCase();
var top_n = body.top_n || 10;
var contributeTable = "dws_" + community + "_prissue_comment";

var sql = """
SELECT 
  ai_agent_platform as agent,
  ai_model_name as model,
  COUNT(*) as count
FROM ${contributeTable}
<where>
  contrib_type = 'pr' AND is_ai_pr = 1 AND is_removed IS NULL AND state = 'merged'
  <if test="start != null and start != ''">
    AND created_at >= to_timestamp(#{start}/1000)
  </if>
  <if test="end != null and end != ''">
    AND created_at <= to_timestamp(#{end}/1000)
  </if>
  AND ai_agent_platform IS NOT NULL AND ai_model_name IS NOT NULL
</where>
GROUP BY ai_agent_platform, ai_model_name
ORDER BY count DESC
LIMIT #{top_n}
""";

return db.select(sql);
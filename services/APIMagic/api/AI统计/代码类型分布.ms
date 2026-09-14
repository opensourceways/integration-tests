{
  "properties" : { },
  "id" : "ai-code-type-001",
  "script" : null,
  "groupId" : "ai-metrics-group-001",
  "name" : "代码类型分布",
  "createTime" : null,
  "updateTime" : 1776653603814,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/code-type",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1776653529688,\r\n    \"community\":\"openeuler\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [\n        {\"code_type\": \"Code\", \"count\": 85},\n        {\"code_type\": \"Doc\", \"count\": 25},\n        {\"code_type\": \"Spec\", \"count\": 12},\n        {\"code_type\": \"CVE\", \"count\": 8}\n    ]\n}",
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
    } ]
  }
}
================================
var start = body.start;
var end = body.end;
var community = body.community.toLowerCase();
var contributeTable = "dws_" + community + "_prissue_comment";

var sql = """
SELECT 
  code_type,
  COUNT(*) as count
FROM (
  SELECT 
    unnest(ai_code_type) as code_type
  FROM ${contributeTable}
<where>
  contrib_type = 'pr' AND is_ai_pr = 1 AND is_removed IS NULL AND state = 'merged'
  <if test="start != null and start != ''">
    AND created_at >= to_timestamp(#{start}/1000)
  </if>
  <if test="end != null and end != ''">
    AND created_at <= to_timestamp(#{end}/1000)
  </if>
</where>
) t
WHERE code_type IS NOT NULL
GROUP BY code_type
ORDER BY count DESC
""";

return db.select(sql);
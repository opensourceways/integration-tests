{
  "properties" : { },
  "id" : "42742ef13cab4b90889c27fa6eb40ff3",
  "script" : null,
  "groupId" : "2e2220ca1c424052ba4fa20a1e7370f8",
  "name" : "有效评论数",
  "createTime" : null,
  "updateTime" : 1774577899459,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/valid_comment",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "vllm",
    "description" : "社区名称",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "1762553600000",
    "description" : "查询范围开始时间,格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "start 必须为合法的毫秒级时间戳",
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : "1772553600000",
    "description" : "查询范围结束时间,格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "end 必须为合法的毫秒级时间戳",
    "expression" : null,
    "children" : null
  }, {
    "name" : "contrib_type",
    "value" : "",
    "description" : "issue评论还是pr评论",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "contrib_type 只能为 pr 或 issue",
    "expression" : "^(pr|issue)?$",
    "children" : null
  }, {
    "name" : "private",
    "value" : "false",
    "description" : "是否私仓，默认 false 表示仅统计公仓数据，true 表示统计所有数据（包括私仓）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "false",
    "validateType" : "pattern",
    "error" : "private 只能为 true 或 false",
    "expression" : "^(true|false)?$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"comments\": 451,\n        \"avg_comments\": 3\n    },\n    \"timestamp\": 1774516123009,\n    \"executeTime\": 12\n}",
  "description" : "查询指定社区指定时间范围内的有效评论/review数量汇总，排除机器人发出的评论和命令型评论。\n不传时间范围时返回全量总计。\n适合：汇总统计、总体评估。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : {
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
      "name" : "code",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "message",
      "value" : "success",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "data",
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
        "name" : "comments",
        "value" : "7406",
        "description" : "",
        "required" : false,
        "dataType" : "Integer",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      }, {
        "name" : "avg_comments",
        "value" : "3",
        "description" : "",
        "required" : false,
        "dataType" : "Integer",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1773128718749",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "executeTime",
      "value" : "634",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  }
}
================================
community = community.toLowerCase()
var sql = """
SELECT COUNT(*) AS comments,
    COALESCE(COUNT(*) / NULLIF(COUNT(DISTINCT html_url), 0), 0) AS avg_comments
FROM dwm_${community}_user_interaction 
WHERE company <> 'robot'
    <if test="private == 'false'">
        and private = #{private}
    </if>
    <if test="start != null and start != ''">
        AND created_at >= to_timestamp(#{start}/1000)
    </if>
    <if test="end != null and end != ''">
        AND created_at <= to_timestamp(#{end}/1000)
    </if>
    <if test="contrib_type != null and contrib_type != ''">
        AND contrib_type = #{contrib_type}
    </if>
"""
var resp = db.selectOne(sql)
return resp

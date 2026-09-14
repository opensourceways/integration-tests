{
  "properties" : { },
  "id" : "ed53f8807e6b4c6ba8a135fb16a7b790",
  "script" : null,
  "groupId" : "2e2220ca1c424052ba4fa20a1e7370f8",
  "name" : "论坛指标",
  "createTime" : null,
  "updateTime" : 1776224069227,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/forum",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "cann",
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
    "value" : "1772294400000",
    "description" : "查询范围开始时间，格式为毫秒时间戳",
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
    "value" : "1774972800000",
    "description" : "查询范围结束时间，格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "end 必须为合法的毫秒级时间戳",
    "expression" : null,
    "children" : null
  } ],
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"count\": 3991,\n        \"avg_first_reply_time\": 97.50,\n        \"avg_closed_time\": 271.03,\n        \"median_first_reply_time\": 0.18,\n        \"median_closed_time\": 136.36\n    }],\n    \"timestamp\": 1776224034110,\n    \"executeTime\": 13\n}",
  "description" : "统计社区论坛汇总指标（平均首次响应时间、平均闭环时间）",
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
      "value" : "-1",
      "description" : "响应码",
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
      "value" : "系统内部出现错误",
      "description" : "响应消息",
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
      "value" : "null",
      "description" : "响应数据",
      "required" : false,
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "timestamp",
      "value" : "1776065993359",
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
      "value" : "9",
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
if (community == "cannopen"){
    community = "cann"
}
var sql = """
SELECT
        count(*) as count, 
        ROUND((AVG(COALESCE(first_reply_duration, 0)) / 86400.0)::NUMERIC, 2) AS avg_first_reply_time,
        ROUND((AVG(COALESCE(closed_time, 0)) / 86400.0)::NUMERIC, 2) AS avg_closed_time,
        ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY COALESCE(first_reply_duration, 0)) / 86400.0)::NUMERIC, 2) AS median_first_reply_time,
        ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY COALESCE(closed_time, 0)) / 86400.0)::NUMERIC, 2) AS median_closed_time
FROM fact_${community}_forum_topic
<where>
    <if test="start != null and start != ''">
        AND created_at >= to_timestamp(#{start}/1000)
    </if>
    <if test="end != null and end != ''">
        AND created_at <= to_timestamp(#{end}/1000)
    </if>
</where>     
"""
var resp = db.select(sql)
return resp

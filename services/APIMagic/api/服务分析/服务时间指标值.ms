{
  "properties" : { },
  "id" : "059454dfa5944df6b582e5eacc899e9d",
  "script" : null,
  "groupId" : "88106ac6415b4414a1298660a1768d34",
  "name" : "服务时间指标值",
  "createTime" : null,
  "updateTime" : 1774578969491,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/value",
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
  "requestBody" : "{\r\n    \"community\": \"openubmc\",\r\n    \"service\": \"\",\r\n    \"metric\": \"visit_time\",\r\n    \"start\": 1729017600000,\r\n    \"end\": 1759017600000\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"value\": 25.38\n    },\n    \"timestamp\": 1760088529206,\n    \"executeTime\": 4\n}",
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
      "name" : "community",
      "value" : "openubmc",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "service",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^[a-zA-Z0-9_]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "metric",
      "value" : "visit_time",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(stay_time|visit_time)$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "1729017600000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : null,
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1759017600000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : null,
      "expression" : null,
      "children" : [ ]
    } ]
  },
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
        "name" : "value",
        "value" : "25.38",
        "description" : "",
        "required" : false,
        "dataType" : "Double",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1760088529206",
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
      "value" : "4",
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
var coefficient = body.metric == "stay_time" ? 3600.0 : 1
var position = body.metric == "stay_time" ? 2 : 0
var sql = """
SELECT 
    ROUND(coalesce(sum(${body.metric}), 0) / ${coefficient}, ${position}) AS value
FROM dws_${body.community}_service_time_day
WHERE 1 = 1
        <if test="body.service != null and body.service != ''">
            AND service = #{body.service}
        </if>
        <if test="body.start != null and body.start != ''">
            AND date >= to_timestamp(#{body.start}/1000)::DATE
        </if>
        <if test="body.end != null and body.end != ''">
            AND date <= to_timestamp(#{body.end}/1000)::DATE
        </if>
;
"""
return db.select(sql)[0]

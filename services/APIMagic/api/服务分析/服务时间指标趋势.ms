{
  "properties" : { },
  "id" : "c347d88c9c62405691763b26d31442dd",
  "script" : null,
  "groupId" : "88106ac6415b4414a1298660a1768d34",
  "name" : "服务时间指标趋势",
  "createTime" : null,
  "updateTime" : 1774579028770,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/service/trend",
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
  "requestBody" : "{\r\n    \"community\": \"openeuler\",\r\n    \"service\": \"sig\",\r\n    \"period\": \"week\",\r\n    \"metric\": \"visit_time\",\r\n    \"start\": 1739017600000,\r\n    \"end\": 1759017600000\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"date\": \"2025-02-03\",\n        \"incre\": 0.07,\n        \"total\": 0.07\n    }, {\n        \"date\": \"2025-02-10\",\n        \"incre\": 0.21,\n        \"total\": 0.28\n    }, {\n        \"date\": \"2025-02-17\",\n        \"incre\": 0.07,\n        \"total\": 0.35\n    }, {\n        \"date\": \"2025-02-24\",\n        \"incre\": 0.17,\n        \"total\": 0.53\n    }, {\n        \"date\": \"2025-03-03\",\n        \"incre\": 0.13,\n        \"total\": 0.65\n    }, {\n        \"date\": \"2025-03-10\",\n        \"incre\": 0.13,\n        \"total\": 0.79\n    }, {\n        \"date\": \"2025-03-17\",\n        \"incre\": 0.13,\n        \"total\": 0.92\n    }, {\n        \"date\": \"2025-03-24\",\n        \"incre\": 0.17,\n        \"total\": 1.09\n    }, {\n        \"date\": \"2025-03-31\",\n        \"incre\": 0.07,\n        \"total\": 1.15\n    }, {\n        \"date\": \"2025-04-07\",\n        \"incre\": 0.12,\n        \"total\": 1.27\n    }, {\n        \"date\": \"2025-04-14\",\n        \"incre\": 0.20,\n        \"total\": 1.48\n    }, {\n        \"date\": \"2025-04-21\",\n        \"incre\": 0.14,\n        \"total\": 1.62\n    }, {\n        \"date\": \"2025-04-28\",\n        \"incre\": 0.11,\n        \"total\": 1.72\n    }, {\n        \"date\": \"2025-05-05\",\n        \"incre\": 0.11,\n        \"total\": 1.83\n    }, {\n        \"date\": \"2025-05-12\",\n        \"incre\": 0.11,\n        \"total\": 1.94\n    }, {\n        \"date\": \"2025-05-19\",\n        \"incre\": 0.11,\n        \"total\": 2.06\n    }, {\n        \"date\": \"2025-05-26\",\n        \"incre\": 0.16,\n        \"total\": 2.22\n    }, {\n        \"date\": \"2025-06-02\",\n        \"incre\": 0.10,\n        \"total\": 2.32\n    }, {\n        \"date\": \"2025-06-09\",\n        \"incre\": 0.14,\n        \"total\": 2.46\n    }, {\n        \"date\": \"2025-06-16\",\n        \"incre\": 0.13,\n        \"total\": 2.59\n    }, {\n        \"date\": \"2025-06-23\",\n        \"incre\": 0.19,\n        \"total\": 2.78\n    }, {\n        \"date\": \"2025-06-30\",\n        \"incre\": 0.11,\n        \"total\": 2.89\n    }, {\n        \"date\": \"2025-07-07\",\n        \"incre\": 0.12,\n        \"total\": 3.01\n    }, {\n        \"date\": \"2025-07-14\",\n        \"incre\": 0.15,\n        \"total\": 3.16\n    }, {\n        \"date\": \"2025-07-21\",\n        \"incre\": 0.16,\n        \"total\": 3.31\n    }, {\n        \"date\": \"2025-07-28\",\n        \"incre\": 0.09,\n        \"total\": 3.40\n    }, {\n        \"date\": \"2025-08-04\",\n        \"incre\": 0.11,\n        \"total\": 3.51\n    }, {\n        \"date\": \"2025-08-11\",\n        \"incre\": 0.12,\n        \"total\": 3.63\n    }, {\n        \"date\": \"2025-08-18\",\n        \"incre\": 0.09,\n        \"total\": 3.73\n    }, {\n        \"date\": \"2025-08-25\",\n        \"incre\": 0.10,\n        \"total\": 3.83\n    }, {\n        \"date\": \"2025-09-01\",\n        \"incre\": 0.12,\n        \"total\": 3.95\n    }, {\n        \"date\": \"2025-09-08\",\n        \"incre\": 0.15,\n        \"total\": 4.09\n    }, {\n        \"date\": \"2025-09-15\",\n        \"incre\": 0.12,\n        \"total\": 4.22\n    }, {\n        \"date\": \"2025-09-22\",\n        \"incre\": 0.23,\n        \"total\": 4.45\n    }],\n    \"timestamp\": 1760088469219,\n    \"executeTime\": 4\n}",
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
      "value" : "openeuler",
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
      "value" : "sig",
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
      "name" : "period",
      "value" : "week",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(day|week|month|year)$",
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
      "value" : "1739017600000",
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
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
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
          "name" : "date",
          "value" : "2025-02-03",
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
          "name" : "incre",
          "value" : "0.07",
          "description" : "",
          "required" : false,
          "dataType" : "Double",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "total",
          "value" : "0.07",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1760088469219",
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
sql = """
SELECT 
    DATE_TRUNC('${body.period}', date)::DATE AS date,
    ROUND(COALESCE(SUM(${body.metric}), 0)/ ${coefficient}, ${position}) AS incre,
    ROUND(SUM(SUM(${body.metric})) OVER (ORDER BY DATE_TRUNC('${body.period}', date)) / ${coefficient}, ${position}) AS total
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
GROUP BY DATE_TRUNC('${body.period}', date)
ORDER BY date;"""
return db.select(sql)

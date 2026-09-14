{
  "properties" : { },
  "id" : "9a93e3f887a646a3b018334c7c39d344",
  "script" : null,
  "groupId" : "88106ac6415b4414a1298660a1768d34",
  "name" : "服务时间指标环比",
  "createTime" : null,
  "updateTime" : 1774579013305,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/service/ratio",
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
  "requestBody" : "{\r\n    \"community\": \"openeuler\",\r\n    \"service\": \"docs\",\r\n    \"period\": \"week\",\r\n    \"metric\": \"stay_time\",\r\n    \"start\": 1723235200000,\r\n    \"end\": 1755235200000\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"date\": \"2025-08-15\",\n        \"cur\": 88603006,\n        \"pre\": 106944530,\n        \"ratio\": -17.15\n    },\n    \"timestamp\": 1765437595614,\n    \"executeTime\": 34\n}",
  "description" : null,
  "requestBodyDefinition" : {
    "name" : "root",
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
      "value" : "docs",
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
      "value" : "stay_time",
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
      "value" : "1723235200000",
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
      "value" : "1755235200000",
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
  "responseBodyDefinition" : null
}
================================
var sql = """
WITH date_ranges AS (
  SELECT 
    to_timestamp(#{body.end}/1000)::DATE - INTERVAL '1 ${body.period}' AS current_start,
    to_timestamp(#{body.end}/1000)::DATE AS current_end,
    to_timestamp(#{body.end}/1000)::DATE - INTERVAL '2 ${body.period}' AS previous_start,
    to_timestamp(#{body.end}/1000)::DATE - INTERVAL '1 ${body.period}' AS previous_end
),
range_data AS (
  SELECT 
    -- 当前周期总和
    COALESCE(SUM(CASE WHEN dcs.date >= dr.current_start AND dcs.date < dr.current_end THEN dcs.${body.metric} END), 0) AS cur,
    -- 前一个周期总和
    COALESCE(SUM(CASE  WHEN dcs.date >= dr.previous_start AND dcs.date < dr.previous_end THEN dcs.${body.metric} END), 0) AS pre
  FROM dws_${body.community}_service_time_day dcs
  CROSS JOIN date_ranges dr
  WHERE dcs.date >= dr.previous_start AND dcs.date < dr.current_end
        <if test="body.service != null and body.service != ''">
            AND dcs.service = #{body.service}
        </if>
)
SELECT 
  to_timestamp(#{body.end}/1000)::DATE AS date,
  cur,
  pre,
  CASE 
    WHEN pre > 0  THEN ROUND((cur - pre) * 100.0 / pre, 2)
    WHEN pre = 0 AND cur > 0 THEN 100.00
    ELSE 0.00
  END AS ratio
FROM range_data;
"""
return db.select(sql)[0]


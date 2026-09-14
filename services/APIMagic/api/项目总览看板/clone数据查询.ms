{
  "properties" : { },
  "id" : "db93b287bdf24df39b567de42c6513ba",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "clone数据查询",
  "createTime" : null,
  "updateTime" : 1777016914191,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/clone",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "hifloat",
    "description" : null,
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
    "value" : "1776614400000",
    "description" : null,
    "required" : true,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "expression",
    "error" : "start 不能为空",
    "expression" : "start != null and start != ''",
    "children" : null
  }, {
    "name" : "end",
    "value" : "1777002442967",
    "description" : null,
    "required" : true,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "expression",
    "error" : "end 不能为空",
    "expression" : "end != null and end != ''",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"repo_name\": \"HiFloat4\",\n        \"clone_count\": 13,\n        \"week_ratio\": 77.7778,\n        \"month_ratio\": 0\n    }, {\n        \"repo_name\": \"HiFloat8\",\n        \"clone_count\": 1,\n        \"week_ratio\": -86.9565,\n        \"month_ratio\": 0\n    }],\n    \"timestamp\": 1777014142888,\n    \"executeTime\": 4\n}",
  "description" : null,
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
          "name" : "repo_name",
          "value" : "HiFloat4",
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
          "name" : "clone_count",
          "value" : "13",
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
          "name" : "week_ratio",
          "value" : "77.7778",
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
          "name" : "month_ratio",
          "value" : "0",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1777013213529",
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
      "value" : "7",
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
import '@/util/timestamp2Date' as timestamp2Date;
community = community.toLowerCase()
var table_name = `fact_${community}_github_download`

// 计算周和月之前的时间戳
var start_date = timestamp2Date(start)
var end_date = timestamp2Date(end)
Date today = timestamp2Date(end);
// 最近7天
LocalDate last7Start = today.minusDays(6);
LocalDate last7End = today;
// 最近30天
LocalDate last30Start = today.minusDays(29);
LocalDate last30End = today;
// 上一个7天周期
LocalDate prev7Start = last7Start.minusDays(7);
LocalDate prev7End = last7Start.minusDays(1);
// 上一个30天周期
LocalDate prev30Start = last30Start.minusDays(30);
LocalDate prev30End = last30Start.minusDays(1);

var sqlstr = """
WITH current_period AS (
    SELECT
        repo_name as repo_name,
        SUM(count) as clone_count
    FROM ${table_name}
    WHERE clone_date BETWEEN #{start_date} AND #{end_date}
    GROUP BY repo_name
),
curr_week_period AS (
    SELECT
        repo_name as repo_name,
        SUM(count) as clone_count
    FROM ${table_name}
    WHERE clone_date BETWEEN #{last7Start} AND #{last7End}
    GROUP BY repo_name
),
last_week_period AS (
    SELECT
        repo_name as repo_name,
        SUM(count) as clone_count
    FROM ${table_name}
    WHERE clone_date BETWEEN #{prev7Start} AND #{prev7End}
    GROUP BY repo_name
),
curr_month_period AS (
    SELECT
        repo_name as repo_name,
        SUM(count) as clone_count
    FROM ${table_name}
    WHERE clone_date BETWEEN #{last30Start} AND #{last30End}
    GROUP BY repo_name
),
last_month_period AS (
    SELECT
        repo_name as repo_name,
        SUM(count) as clone_count
    FROM ${table_name}
    WHERE clone_date BETWEEN #{prev30Start} AND #{prev30End}
    GROUP BY repo_name
)
SELECT
    SPLIT_PART(c.repo_name, '/', 3) as repo_name,
    COALESCE(c.clone_count, 0) as clone_count,
    CASE WHEN COALESCE(lw.clone_count, 0) = 0 THEN 0
        ELSE ROUND((cw.clone_count::numeric - lw.clone_count::numeric) / lw.clone_count::numeric * 100, 2)
    END as week_ratio,
    CASE WHEN COALESCE(lm.clone_count, 0) = 0 THEN 0
        ELSE ROUND((cm.clone_count::numeric - lm.clone_count::numeric) / lm.clone_count::numeric * 100, 2)
    END as month_ratio
FROM current_period c
LEFT JOIN curr_week_period cw ON c.repo_name = cw.repo_name
LEFT JOIN last_week_period lw ON c.repo_name = lw.repo_name
LEFT JOIN curr_month_period cm ON c.repo_name = cm.repo_name
LEFT JOIN last_month_period lm ON c.repo_name = lm.repo_name
ORDER BY c.clone_count DESC
"""

return db.select(sqlstr)
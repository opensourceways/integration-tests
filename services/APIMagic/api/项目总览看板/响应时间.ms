{
  "properties" : { },
  "id" : "262b4bd2a69f446c9b1d01c45d222c8c",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "响应时间",
  "createTime" : null,
  "updateTime" : 1773817257100,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/response-time",
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
  "requestBody" : "{\r\n    \"start\":1759075200000,\r\n    \"end\":1761722909224,\r\n    \"community\":\"mindspeed\",\r\n    \"repo_path\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"pr_reply_days\": 0.4948,\n        \"previous_pr_reply_days\": 0.1974,\n        \"previous_issue_reply_days\": 2.7292,\n        \"issue_reply_ratio\": 0.0682,\n        \"issue_closed_ratio\": 3.4901,\n        \"issue_closed_days\": 51.5530,\n        \"pr_reply_ratio\": 1.5066,\n        \"pr_closed_ratio\": 0.0066,\n        \"issue_reply_days\": 2.9152,\n        \"pr_closed_days\": 0.9499,\n        \"previous_pr_closed_days\": 0.9437,\n        \"previous_issue_closed_days\": 11.4815\n    },\n    \"timestamp\": 1765768600702,\n    \"executeTime\": 21015\n}",
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
      "name" : "start",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "repo_path",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 格式非法",
      "expression" : "^([a-zA-Z0-9_\\-./]+)?$",
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
        "name" : "pr_reply_days",
        "value" : "0.3508",
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
        "name" : "previous_pr_reply_days",
        "value" : "0.6478",
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
        "name" : "previous_issue_reply_days",
        "value" : "3.3097",
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
        "name" : "issue_reply_ratio",
        "value" : "-0.2465",
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
        "name" : "issue_closed_ratio",
        "value" : "-0.3631",
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
        "name" : "issue_closed_days",
        "value" : "7.5207",
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
        "name" : "pr_reply_ratio",
        "value" : "-0.4585",
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
        "name" : "pr_closed_ratio",
        "value" : "-0.0833",
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
        "name" : "issue_reply_days",
        "value" : "2.4938",
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
        "name" : "pr_closed_days",
        "value" : "0.9206",
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
        "name" : "previous_pr_closed_days",
        "value" : "1.0043",
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
        "name" : "previous_issue_closed_days",
        "value" : "11.8080",
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
      "value" : "1761724024063",
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
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.Year;
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
LocalDate today = LocalDate.now();
int last_year = today.getYear() - 1;
LocalDate previous_start = LocalDate.of(last_year, 1, 1);
LocalDate previous_end = LocalDate.of(last_year, 12, 31);
// Date previous_start = timestamp2Date(1704067200000l);
// Date previous_end = timestamp2Date(1735660800000l);
// 社区
var community = body.community.toLowerCase();
// 社区
var repo_path = body.repo_path;
var repo_arr = repo_path != null ? repo_path.split("/"):[];
var namespace = "";
if(repo_arr.size() == 2){
    namespace = repo_arr[0];
    repo_path = repo_arr[1];
}
// 贡献表
var contributeTable = "dws_" + community + "_contribute_repo_daily";
var internal_sql = """
with ori_data as (
    SELECT 
        unnest(pr_first_reply_time_arr)::BIGINT as pr_first_reply_time,
        unnest(pr_closed_time_arr)::BIGINT as pr_closed_time,
        unnest(issue_first_reply_time_arr)::BIGINT as issue_first_reply_time,
        unnest(issue_closed_time_arr)::BIGINT as issue_closed_time
    FROM ${contributeTable}
    WHERE date BETWEEN #{start} AND #{end} and private = 'false'
)
select 
    ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY pr_first_reply_time), 0)::numeric / 86400, 4 ) AS pr_reply_days,
    ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY pr_closed_time), 0)::numeric / 86400, 4 ) AS pr_closed_days,
    ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY issue_first_reply_time), 0)::numeric / 86400, 4 ) AS issue_reply_days,
    ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY issue_closed_time), 0)::numeric / 86400, 4 ) AS issue_closed_days
from ori_data
""";
var internal_data = db.select(internal_sql);
var query_data = internal_data[0]
var pr_reply_days = query_data.get("pr_reply_days");
var pr_closed_days = query_data.get("pr_closed_days");
var issue_reply_days = query_data.get("issue_reply_days");
var issue_closed_days = query_data.get("issue_closed_days");
var previous_sql = """
with ori_data as (
    SELECT 
        unnest(pr_first_reply_time_arr)::BIGINT as pr_first_reply_time,
        unnest(pr_closed_time_arr)::BIGINT as pr_closed_time,
        unnest(issue_first_reply_time_arr)::BIGINT as issue_first_reply_time,
        unnest(issue_closed_time_arr)::BIGINT as issue_closed_time
    FROM ${contributeTable}
    WHERE date BETWEEN #{previous_start} AND #{previous_end}
)
select 
    ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY pr_first_reply_time), 0)::numeric / 86400, 4 ) AS pr_reply_days,
    ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY pr_closed_time), 0)::numeric / 86400, 4 ) AS pr_closed_days,
    ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY issue_first_reply_time), 0)::numeric / 86400, 4 ) AS issue_reply_days,
    ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY issue_closed_time), 0)::numeric / 86400, 4 ) AS issue_closed_days
from ori_data
""";
var previous_result = db.select(previous_sql);
var previous_data = previous_result[0]
var previous_pr_reply_days = previous_data.get("pr_reply_days");
var previous_pr_closed_days = previous_data.get("pr_closed_days");
var previous_issue_reply_days = previous_data.get("issue_reply_days");
var previous_issue_closed_days = previous_data.get("issue_closed_days");
var diff_pr_reply_days = pr_reply_days - previous_pr_reply_days;
var diff_pr_closed_days = pr_closed_days - previous_pr_closed_days;
var diff_issue_reply_days = issue_reply_days - previous_issue_reply_days;
var diff_issue_closed_days = issue_closed_days - previous_issue_closed_days;
var pr_reply_ratio = 1;
if (previous_pr_reply_days > 0){
// 计算比率并保留4位小数，使用四舍五入
  pr_reply_ratio = diff_pr_reply_days.divide(previous_pr_reply_days, 4, RoundingMode.HALF_UP).doubleValue();
}
var pr_closed_ratio = 1;
if (previous_pr_closed_days > 0){
// 计算比率并保留4位小数，使用四舍五入
  pr_closed_ratio = diff_pr_closed_days.divide(previous_pr_closed_days, 4, RoundingMode.HALF_UP).doubleValue();
}
var issue_reply_ratio = 1;
if (previous_issue_reply_days > 0){
// 计算比率并保留4位小数，使用四舍五入
  issue_reply_ratio = diff_issue_reply_days.divide(previous_issue_reply_days, 4, RoundingMode.HALF_UP).doubleValue();
}
var issue_closed_ratio = 1;
if (previous_issue_closed_days > 0){
// 计算比率并保留4位小数，使用四舍五入
  issue_closed_ratio = diff_issue_closed_days.divide(previous_issue_closed_days, 4, RoundingMode.HALF_UP).doubleValue();
}
HashMap result = new HashMap();
// PR首次响应时间 中位数
result.put("pr_reply_days", pr_reply_days);
// PR平均关闭时间 中位数
result.put("pr_closed_days", pr_closed_days);
// Issue首次响应时间 中位数
result.put("issue_reply_days", issue_reply_days);
// Issue平均关闭时间 中位数
result.put("issue_closed_days", issue_closed_days);
// 上一期PR首次响应时间 中位数
result.put("previous_pr_reply_days", previous_pr_reply_days);
// 上一期PR平均关闭时间 中位数
result.put("previous_pr_closed_days", previous_pr_closed_days);
// 上一期Issue首次响应时间 中位数
result.put("previous_issue_reply_days", previous_issue_reply_days);
// 上一期Issue平均关闭时间 中位数
result.put("previous_issue_closed_days", previous_issue_closed_days);
// PR首次响应时间 变化 (当期-上一期)/上一期
result.put("pr_reply_ratio", pr_reply_ratio);
// PR平均关闭时间 变化 (当期-上一期)/上一期
result.put("pr_closed_ratio", pr_closed_ratio);
// Issue首次响应时间 变化 (当期-上一期)/上一期
result.put("issue_reply_ratio", issue_reply_ratio);
// Issue平均关闭时间 变化 (当期-上一期)/上一期
result.put("issue_closed_ratio", issue_closed_ratio);
return result;

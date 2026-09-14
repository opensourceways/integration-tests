{
  "properties" : { },
  "id" : "198c1b030e4646f1b3a7d347b31f7086",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "账号趋势",
  "createTime" : null,
  "updateTime" : 1758023618497,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/trend/account",
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
  }, {
    "name" : "permission",
    "value" : "datastat",
    "description" : "允许拥有该权限的访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "requestBody" : "{\r\n    \"start\":1757260800000,\r\n    \"end\":1757606400000,\r\n    \"community\":\"unifiedbus\",\r\n    \"source\":\"\",\r\n    \"company\":\"\",\r\n    \"internal\":\"\",\r\n    \"interval\":\"day\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"date\": \"2025-09-08\",\n        \"regist_count\": 0,\n        \"total_regist_count\": 0,\n        \"logout_count\": 0,\n        \"total_logout_count\": 0,\n        \"active_count\": 0,\n        \"total_active_count\": 0\n    }, {\n        \"date\": \"2025-09-09\",\n        \"regist_count\": 1,\n        \"total_regist_count\": 1,\n        \"logout_count\": 0,\n        \"total_logout_count\": 0,\n        \"active_count\": 0,\n        \"total_active_count\": 0\n    }, {\n        \"date\": \"2025-09-10\",\n        \"regist_count\": 1,\n        \"total_regist_count\": 2,\n        \"logout_count\": 0,\n        \"total_logout_count\": 0,\n        \"active_count\": 0,\n        \"total_active_count\": 0\n    }, {\n        \"date\": \"2025-09-11\",\n        \"regist_count\": 4,\n        \"total_regist_count\": 6,\n        \"logout_count\": 0,\n        \"total_logout_count\": 0,\n        \"active_count\": 0,\n        \"total_active_count\": 0\n    }, {\n        \"date\": \"2025-09-12\",\n        \"regist_count\": 11,\n        \"total_regist_count\": 17,\n        \"logout_count\": 0,\n        \"total_logout_count\": 0,\n        \"active_count\": 0,\n        \"total_active_count\": 0\n    }],\n    \"timestamp\": 1757987538866,\n    \"executeTime\": 4\n}",
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
      "value" : "1757260800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1757606400000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "unifiedbus",
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
      "name" : "source",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "source 格式非法",
      "expression" : "^[a-zA-Z0-9_]*$",
      "children" : [ ]
    }, {
      "name" : "company",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "company 格式非法",
      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5 \\-\\.]*$",
      "children" : [ ]
    }, {
      "name" : "internal",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "internal 只能为 内部 或 外部",
      "expression" : "^(内部|外部)?$",
      "children" : [ ]
    }, {
      "name" : "interval",
      "value" : "day",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "interval 只能为 day、week 或 month",
      "expression" : "^(day|week|month)?$",
      "children" : [ ]
    }, {
      "name" : "tab",
      "value" : "company",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "tab 只能为 company、sig 或 repo",
      "expression" : "^(company|sig|repo)?$",
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
      "value" : "-1",
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
      "value" : "系统内部出现错误",
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
      "value" : "null",
      "description" : "",
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
      "value" : "1757987055928",
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
      "value" : "6",
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
import magic;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 社区
var community = body.community;
// 服务平台
var source = body.source;
// 组织
var company = body.company;
// 内外部
var internal = body.internal;
// 间隔周期：day week month
var interval = body.interval;
var account_table = "dws_" + community + "_account_" + interval;
var query_sql = """
    with query_data as (
        select 
            date,
            sum(regist_count) as regist_count,
            SUM(sum(regist_count)) OVER (
              ORDER BY date
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS total_regist_count,
            sum(logout_count) as logout_count,
            SUM(sum(logout_count)) OVER (
              ORDER BY date
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS total_logout_count,
            sum(active_count) as active_count,
            SUM(sum(logout_count)) OVER (
              ORDER BY date
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS total_active_count
        FROM ${account_table}
        <where>
            date::DATE BETWEEN date_trunc('${interval}', #{start})::DATE AND date_trunc('${interval}', #{end})::DATE
            <if test="source != null and source != ''">
                and source = #{source}
            </if>
            <if test="company != null and company != ''">
                and company = #{company}
            </if>
            <if test="internal != null and internal != ''">
                and internal = #{internal}
            </if>
        </where>
        group by date
    )
    select * from query_data order by date asc
"""
return db.select(query_sql)

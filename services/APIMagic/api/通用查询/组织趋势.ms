{
  "properties" : { },
  "id" : "99e6ef40d2c84ac1a6e3d925addbb489",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "组织趋势",
  "createTime" : null,
  "updateTime" : 1773127404601,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/trend/company",
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
  "requestBody" : "{\r\n    \"start\":1707260800000,\r\n    \"end\":1767606400000,\r\n    \"community\":\"openeuler\",\r\n    \"source\":\"\",\r\n    \"internal\":\"\",\r\n    \"interval\":\"month\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"date\": \"2025-09-01\",\n        \"company_count\": 259,\n        \"total_company_count\": 259,\n        \"company_type_count\": 3,\n        \"total_company_type_count\": 3\n    }, {\n        \"date\": \"2025-10-01\",\n        \"company_count\": 77,\n        \"total_company_count\": 336,\n        \"company_type_count\": 2,\n        \"total_company_type_count\": 5\n    }, {\n        \"date\": \"2025-11-01\",\n        \"company_count\": 46,\n        \"total_company_count\": 382,\n        \"company_type_count\": 1,\n        \"total_company_type_count\": 6\n    }, {\n        \"date\": \"2025-12-01\",\n        \"company_count\": 22,\n        \"total_company_count\": 404,\n        \"company_type_count\": 1,\n        \"total_company_type_count\": 7\n    }, {\n        \"date\": \"2026-01-01\",\n        \"company_count\": 85,\n        \"total_company_count\": 489,\n        \"company_type_count\": 1,\n        \"total_company_type_count\": 8\n    }],\n    \"timestamp\": 1773127391780,\n    \"executeTime\": 7\n}",
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
          "value" : "2025-09-08",
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
          "name" : "company_count",
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
        }, {
          "name" : "total_company_count",
          "value" : "2",
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
          "name" : "company_type_count",
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
        }, {
          "name" : "total_company_type_count",
          "value" : "2",
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
      "value" : "1757766859364",
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
var company_table = "dws_" + community + "_company_" + interval;
var query_sql = """
    with query_data as (
        select 
            date,
            sum(company_count) as company_count,
            SUM(sum(company_count)) OVER (
              ORDER BY date
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS total_company_count,
            sum(company_type_count) as company_type_count,
            SUM(sum(company_type_count)) OVER (
              ORDER BY date
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS total_company_type_count
        FROM ${company_table}
        <where>
            date::DATE BETWEEN date_trunc('${interval}', #{start})::DATE AND date_trunc('${interval}', #{end})::DATE
            <if test="source != null and source != ''">
                and source = #{source}
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

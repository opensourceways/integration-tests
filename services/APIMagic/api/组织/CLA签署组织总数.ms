{
  "properties" : { },
  "id" : "95f79ea8c9064e9fbb9a3bdcdd39abd9",
  "script" : null,
  "groupId" : "52cb0a20ea9c4250922978c291cee58e",
  "name" : "CLA签署组织总数",
  "createTime" : null,
  "updateTime" : 1776656920157,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/claCount",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
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
    "value" : "1659327200000",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : "start 必须为合法的毫秒级时间戳",
    "expression" : "",
    "children" : null
  }, {
    "name" : "end",
    "value" : "1732032000000",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : "end 必须为合法的毫秒级时间戳",
    "expression" : "",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"company_all\": 1469\n    },\n    \"timestamp\": 1776649842225,\n    \"executeTime\": 35\n}",
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
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "company_all",
        "value" : "1817",
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
      "value" : "1776234895277",
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
      "value" : "33",
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
// cla_company数据表
var cla_company_table = `fact_${community}_cla_company`

var sqlstr = """
    SELECT 
      COUNT(DISTINCT "company") as company_all
    FROM ${cla_company_table}
    WHERE 1=1
    <if test="start != null and start != ''">
        AND created_at >= to_timestamp(#{start}/1000)
    </if>
    <if test="end != null and end != ''">
        AND created_at < to_timestamp(#{end}/1000)
    </if>
"""
var res = db.select(sqlstr)[0]
return res
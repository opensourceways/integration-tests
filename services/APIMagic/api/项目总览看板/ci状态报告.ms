{
  "properties" : { },
  "id" : "899096c831c64f319690fd73e0e028ab",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "ci状态报告",
  "createTime" : null,
  "updateTime" : 1774511672286,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/ci/metric/bak",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatInfra_View",
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
  "requestBody" : "{\"start\":1752422400000,\"end\":1755049618286,\"community\":\"cannopen\",\"topn\":10,\"pageSize\":1,\"pageNum\":1}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1773920105367,\n    \"executeTime\": 2\n}",
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
      "name" : "topn",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "topn 必须为正整数且不超过 100",
      "expression" : "topn > 0 && topn <= 100",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过 100",
      "expression" : "pageSize > 0 && pageSize <= 100",
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageNum 必须为正整数",
      "expression" : "pageNum > 0 && pageNum <= 9999 ",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 社区
var community = body.community.toLowerCase();
// 分页
var page_num = body.pageNum || 1;
var page_size = body.pageSize || 10;
var offset = (page_num - 1) * page_size;
var sql = """SELECT * FROM dws_${community}_build LIMIT #{page_size} OFFSET #{offset}""";
var totalsql = """ select count(1) as count from dws_${community}_build """
var total_count = db.selectOne(totalsql).get("count");
var total_page = (total_count / page_size)+1;
HashMap result = new HashMap();
result.put("list",db.select(sql));
result.put("total_count",total_count);
result.put("total_page",total_page);
return result

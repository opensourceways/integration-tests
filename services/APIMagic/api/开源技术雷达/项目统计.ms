{
  "properties" : { },
  "id" : "trp_stats",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "项目统计",
  "createTime" : null,
  "updateTime" : 1777513450172,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/tech-radar/stats",
  "method" : "GET",
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"online\": 1,\n        \"pending\": 2,\n        \"rejected\": 0,\n        \"total\": 3\n    },\n    \"timestamp\": 1777513419622,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var r = db.selectOne("""SELECT COUNT(*) FILTER(WHERE status='已上线') AS online, COUNT(*) FILTER(WHERE status='未上线') AS pending, COUNT(*) FILTER(WHERE status='拒绝') AS rejected, COUNT(*) AS total FROM fact_insight_tech_radar_project""");
return r;
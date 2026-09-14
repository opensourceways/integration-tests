{
  "properties" : { },
  "id" : "b86d24d2edef4ff9a0849abe829c9c47",
  "script" : null,
  "groupId" : "521ef640123a4ae79386e6a38b8df4ad",
  "name" : "下载量",
  "createTime" : null,
  "updateTime" : 1756814809328,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/download",
  "method" : "GET",
"parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : "暂时只支持openeuler",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openeuler",
    "validateType" : "pattern",
    "error" : "暂时只支持openeuler",
    "expression" : "^(openeuler)$",
    "children" : null
  }, {
    "name" : "packageName",
    "value" : "",
    "description" : "暂时只支持jdk",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "jdk",
    "validateType" : "pattern",
    "error" : "暂时只支持jdk",
    "expression" : "^(jdk)$",
    "children" : null
  }, {
    "name" : "start",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "start 格式应为 yyyy-MM-dd",
    "expression" : "^(\\d{4}-\\d{2}-\\d{2})?$",
    "children" : null
  }, {
    "name" : "end",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "end 格式应为 yyyy-MM-dd",
    "expression" : "^(\\d{4}-\\d{2}-\\d{2})?$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 360017\n    },\n    \"timestamp\": 1756814807512,\n    \"executeTime\": 5\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var community = community
var start = start
var end = end
var packageName = packageName
var sql = """select sum(day_count) total from dws_${community}_open${packageName}_daily
        where 1=1 
        <if test="start != null and start != ''">
            AND created_at >= #{start}::date 
        </if>
        <if test="end != null and end != ''">
            AND created_at <= #{end}::date 
        </if>
"""
HashMap res = new HashMap();
res.put("total",0)
var resselect = db.select(sql)
if(resselect!=null && resselect.size()>0){
    res.put("total",resselect.get(0).get("total"))
}
return res

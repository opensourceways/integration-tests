{
  "properties" : { },
  "id" : "2c3caf61b4dc400fa4f08a84fd98be1c",
  "script" : null,
  "groupId" : "2490a90728da40cc94981ac0becd0e1f",
  "name" : "软件包下载",
  "createTime" : null,
  "updateTime" : 1778550069147,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/package",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : "暂时只支持openeuler",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^openeuler$",
    "children" : null
  }, {
    "name" : "packageName",
    "value" : "jdk",
    "description" : "暂时只支持jdk",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "packageName 参数非法",
    "expression" : "^jdk$",
    "children" : null
  }, {
    "name" : "start",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 360017\n    },\n    \"timestamp\": 1756814210655,\n    \"executeTime\": 10\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================

var sql = """select sum(day_count) total from dws_${community}_openjdk_daily
        where 1=1 
<if test="start != null and start != ''">
            AND created_at >= #{start} 
        </if>
        <if test="end != null and end != ''">
            AND created_at <= #{end} 
        </if>
"""
HashMap res = new HashMap();
res.put("total",0)
var resselect = db.select(sql)
if(resselect!=null && resselect.size()>0){
    res.put("total",resselect.get(0).get("total"))
}
return res

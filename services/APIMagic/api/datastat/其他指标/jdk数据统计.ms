{
  "properties" : { },
  "id" : "96bdcece448a465c98351513b16b80a5",
  "script" : null,
  "groupId" : "1bf34b6e2cff4b439cda01958030aef1",
  "name" : "jdk数据统计",
  "createTime" : null,
  "updateTime" : 1756793691251,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/jdk",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : "目前只支持openeuler",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "目前只支持openeuler",
    "expression" : "^(openeuler)$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "",
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
    "value" : "",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 7161\n    },\n    \"timestamp\": 1756786880977,\n    \"executeTime\": 3427\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var community = community
var start = start
var end = end
var sql = """select sum(day_count) total from dws_${community}_openjdk_daily
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

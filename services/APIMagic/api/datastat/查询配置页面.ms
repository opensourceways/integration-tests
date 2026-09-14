{
  "properties" : { },
  "id" : "b0fcbdf557614bf39122030cc3dc189d",
  "script" : null,
  "groupId" : "521ef640123a4ae79386e6a38b8df4ad",
  "name" : "查询配置页面",
  "createTime" : null,
  "updateTime" : 1773825863230,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/page/config/query",
  "method" : "GET",
  "parameters" : [ {
    "name" : "name",
    "value" : "计算开源雷达1",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "name 格式非法",
    "expression" : "(计算开源雷达|开源实习)$",
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
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"name 格式非法\",\n    \"data\": null,\n    \"timestamp\": 1773825857308,\n    \"executeTime\": 0\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import java.time.OffsetDateTime;
var  page_name = name
if(page_name == null || "".equals(page_name)){
    return  db.select("select name,page_json from fact_page_config")
}
var sql = """  select name,page_json from fact_page_config  where name=#{page_name} """
return  db.selectOne(sql)

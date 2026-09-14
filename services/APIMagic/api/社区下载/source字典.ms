{
  "properties" : { },
  "id" : "79cc82d6aba647cb8727d262ddbd4045",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "source字典",
  "createTime" : null,
  "updateTime" : 1773883225866,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "dict",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openubmc",
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
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
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1745505570050,\n    \"executeTime\": 7\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var community = community;
var sql = """
select source as label,source as value from dict_communtiy_download where community=#{community}
""";
return db.select(sql);

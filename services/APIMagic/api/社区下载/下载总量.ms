{
  "properties" : { },
  "id" : "1879ad691ad0410b980392ec55d6de8e",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "下载总量",
  "createTime" : null,
  "updateTime" : 1752821976540,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "total_bak20250717",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 5108\n    },\n    \"timestamp\": 1742519925478,\n    \"executeTime\": 3\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var community = community;
var sql = """
select sum(count) as total from dws_day_download_{community}
""";
return db.select(sql).get(0);

{
  "properties" : { },
  "id" : "copy1752821918199d69577",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "下载总量(正式)",
  "createTime" : null,
  "updateTime" : 1763346851909,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "total",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 3812774\n    },\n    \"timestamp\": 1763346844546,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var community = community;
var sql = """
select  SUM(download_day_increase) AS total_count
    FROM dws_${community}_download_daily""";
return db.select(sql).get(0);

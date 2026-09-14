{
  "properties" : { },
  "id" : "copy1756785044127d36014",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "下载源分布",
  "createTime" : null,
  "updateTime" : 1767598799968,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/source",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"huaweicloud\": 1563269,\n        \"swr\": 1083746,\n        \"ru-repo.openeuler.org\": 18276,\n        \"dockerhub\": 686549,\n        \"mirror\": 228308,\n        \"iscas\": 78325,\n        \"oepkgs\": 116190,\n        \"repo.openeuler.org\": 1152082\n    },\n    \"timestamp\": 1756785127956,\n    \"executeTime\": 7\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sql = """select source, sum(download_day_increase)  from dws_${community}_download_daily fosu group by source;"""
rows = db.select(sql)
result = {}
for (row in rows) {
    result[row.source] = row.sum
}
return result

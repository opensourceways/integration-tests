{
  "properties" : { },
  "id" : "870b8612f5c64e7bb8d469301fc2de05",
  "script" : null,
  "groupId" : "88106ac6415b4414a1298660a1768d34",
  "name" : "服务分析列表",
  "createTime" : null,
  "updateTime" : 1765437786099,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/list",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"services\": [\"certification\", \"compassci\", \"cvemanager\", \"datacube\", \"datastat\", \"docs\", \"download\", \"eulermaker\", \"license\", \"meeting\", \"message\", \"oneid\", \"package\", \"pkgship\", \"portal\", \"quickissue\", \"radiatest\", \"search_docs\", \"search_portal\", \"search_software\", \"sig\", \"software\"]\n    },\n    \"timestamp\": 1760173805673,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sql = """
SELECT 
    array_agg(distinct service) AS services
FROM dws_${community}_service_time_day
"""
var resp = db.select(sql)
resp.each(it => it['services'] = it.services.getArray())
return resp[0]

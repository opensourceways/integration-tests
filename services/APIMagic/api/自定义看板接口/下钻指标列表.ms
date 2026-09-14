{
  "properties" : { },
  "id" : "d2ad7b86e95e4270922af7227fe176e0",
  "script" : null,
  "groupId" : "12d952eea410421d80e54b1a53bcd3cf",
  "name" : "下钻指标列表",
  "createTime" : 1750755630595,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : null,
  "path" : "/metric/list",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sqlstr = """SELECT uuid, definition FROM dim_metric"""
var result = db.select(sqlstr)
return result

{
  "properties" : { },
  "id" : "2624ca392fce4bddac62a88215b6b454",
  "script" : null,
  "groupId" : "12d952eea410421d80e54b1a53bcd3cf",
  "name" : "数据表",
  "createTime" : null,
  "updateTime" : 1763714463586,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{community}/tables",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatadmin",
    "description" : "允许拥有该权限的访问",
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
  "paths" : [ {
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
  "responseBody" : "{\n    \"code\": 401,\n    \"message\": \"用户未登录\",\n    \"data\": null,\n    \"timestamp\": 1763714436936,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sqlstr = """
SELECT table_name
FROM information_schema.tables
WHERE (table_name LIKE 'dws_${community}%' OR table_name LIKE 'dws_community%') AND table_type = 'BASE TABLE' AND table_schema = 'public'
"""
var resp = db.select(sqlstr)
var result = []
for (name in resp) {
    result.add(name.get("table_name"))
}
return result

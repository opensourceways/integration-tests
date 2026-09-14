{
  "properties" : { },
  "id" : "f2f62f6abddf4e33a4e9bc8399f2cebb",
  "script" : null,
  "groupId" : "c8e7bc9573554a77aa14c0c646dabaae",
  "name" : "贡献企业多样性",
  "createTime" : null,
  "updateTime" : 1745498360995,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{community}/companies",
  "method" : "GET",
  "parameters" : [ ],
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
  "paths" : [ {
    "name" : "community",
    "value" : "mindspore",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"companies\": [\"huawei+众智\", \"independent\", \"MindSpore\", \"众智\", \"华为\"]\n    },\n    \"timestamp\": 1745478883929,\n    \"executeTime\": 12225\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sqlstr = """
SELECT 
    array_agg(DISTINCT company) AS companies
FROM 
    dws_${community}_contribute
WHERE 
    is_pr = 1 AND state = 'merged' 
    AND company NOT IN ('华为合作方','个人贡献者','robot') 
    AND created_at >= CURRENT_DATE - INTERVAL '1 year';
"""
var resp = db.select(sqlstr)[0]
var result = {}
for(key, value in resp){
    result[key] = value.getArray()
}
return result

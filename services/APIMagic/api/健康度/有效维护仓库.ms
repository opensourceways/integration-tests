{
  "properties" : { },
  "id" : "7bfa87ad09cb4386815b7173ecce4a4c",
  "script" : null,
  "groupId" : "c8e7bc9573554a77aa14c0c646dabaae",
  "name" : "有效维护仓库",
  "createTime" : null,
  "updateTime" : 1742459351406,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/{community}/active_repo",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ {
    "name" : "community",
    "value" : "openubmc",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"repos\": [\"openUBMC/bingo\", \"openUBMC/user\", \"openUBMC/conan-auth-proxy\", \"openUBMC/infrastructure\", \"openUBMC/certificate_mgmt\", \"openUBMC/web_online_help\"]\n    },\n    \"timestamp\": 1742347699395,\n    \"executeTime\": 7\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sqlstr = """
SELECT 
    array_agg(CONCAT(namespace,'/',repo_path)) AS repos
FROM dws_${community}_repo_maintain_status
WHERE status = 'active';
"""
var resp = db.select(sqlstr)[0]
var result = {}
for(key, value in resp){
    result[key] = value.getArray()
}
return result

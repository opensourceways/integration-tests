{
  "properties" : { },
  "id" : "a424732f717a46c5966b7a520b529ea7",
  "script" : null,
  "groupId" : "24e4ef78cdc04b758533330015c64bf1",
  "name" : "版本列表",
  "createTime" : null,
  "updateTime" : 1766989980562,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/versions",
  "method" : "GET",
"parameters" : [ {
    "name" : "community",
    "value" : "openeuleropen",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 必须是纯字母，长度1-32",
    "expression" : "^[a-zA-Z]{1,32}$"
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [\"openEuler-20.03-LTS\", \"openEuler-20.03-LTS-SP1\", \"openEuler-20.03-LTS-SP2\", \"openEuler-20.03-LTS-SP3\", \"openEuler-20.03-LTS-SP4\", \"openEuler-20.09\", \"openEuler-21.03\", \"openEuler-21.09\", \"openEuler-22.03-LTS\", \"openEuler-22.03-LTS-Next\", \"openEuler-22.03-LTS-SP1\", \"openEuler-22.03-LTS-SP2\", \"openEuler-22.03-LTS-SP3\", \"openEuler-22.03-LTS-SP4\", \"openEuler-22.09\", \"openEuler-23.03\", \"openEuler-23.09\", \"openEuler-24.03-LTS\", \"openEuler-24.03-LTS-Next\", \"openEuler-24.03-LTS-SP1\", \"openEuler-24.03-LTS-SP2\", \"openEuler-24.09\", \"openEuler-25.03\"],\n    \"timestamp\": 1752653066208,\n    \"executeTime\": 240\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT 
    array_agg(distinct version order by version desc) as versions
FROM 
    fact_${community}_version;
"""
var resp = db.select(sqlstr)
return resp.versions.getArray()

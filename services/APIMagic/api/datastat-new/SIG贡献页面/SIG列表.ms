{
  "properties" : { },
  "id" : "20eb572947894101828a82e5f8589b86",
  "script" : null,
  "groupId" : "d483565aa9094ad0ba882199e9e1fa17",
  "name" : "SIG列表",
  "createTime" : null,
  "updateTime" : 1773884392340,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "sig/list",
  "method" : "GET",
  "parameters" : [ {
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
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [\"infrastructure\", \"sig-bmc-core\", \"sig-CICD\", \"sig-component-drivers\", \"sig-docs\", \"sig-hardware\", \"sig-interface\", \"sig-QA\", \"sig-release-management\", \"sig-security\", \"TC\"],\n    \"timestamp\": 1759126128311,\n    \"executeTime\": 93\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var internal_sql = """
SELECT 
    ARRAY_AGG(distinct sig_name) AS sig
FROM fact_${community}_sig_user ru
WHERE is_removed IS NULL
"""
row = db.select(internal_sql)[0].sig
if (row == null) {
    return []
}
result = row.getArray()
var ans = Arrays.asList(result)
return ans

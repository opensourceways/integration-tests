{
  "properties" : { },
  "id" : "2e36616ac47a49128486cebca6627882",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "cpu选项接口",
  "createTime" : null,
  "updateTime" : 1777107226370,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/cpu/options",
  "method" : "POST",
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
  "requestBody" : "{\r\n    \"start\": 1727798400000,\r\n    \"end\": 1785856000000,\r\n    \"dimension\": \"community\",\r\n    \"community\": \"\",\r\n    \"region_name\": \"\"\r\n}\r\n",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"label\": \"ascend_infra_unified_resource_pool\",\n        \"value\": \"ascend_infra_unified_resource_pool\"\n    }],\n    \"timestamp\": 1777106885810,\n    \"executeTime\": 2\n}",
  "description" : null,
  "requestBodyDefinition" : {
    "name" : "",
    "value" : "",
    "description" : "",
    "required" : false,
    "dataType" : "Object",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : [ {
      "name" : "start",
      "value" : "1727798400000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1785856000000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "dimension",
      "value" : "community",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(community|region_name|resource_name)$",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "region_name",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================


var dimension = body.dimension
var community = body.dimension
var region_name = body.dimension



var sql = """

select distinct ${dimension} as label,${dimension} as value from dws_cloud_cpu_details_hour

where 
1=1
 <if test="body.start != null and body.start != ''">
        AND timestamp >= to_timestamp(#{body.start}/1000)
    </if>
    <if test="body.end != null and body.end != ''">
        AND timestamp <= to_timestamp(#{body.end}/1000)
    </if>

"""

return db.select(sql)
{
  "properties" : { },
  "id" : "7617ac5825f7497aa618494141ed8267",
  "script" : null,
  "groupId" : "88106ac6415b4414a1298660a1768d34",
  "name" : "服务或模块指标直方图",
  "createTime" : null,
  "updateTime" : 1774578983473,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{type}/count",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"community\": \"openeuler\",\r\n    \"service\": \"docs\",\r\n    \"metric\": \"stay_time\",\r\n    \"start\": 1729017600000,\r\n    \"end\": 1759017600000\r\n}",
  "headers" : [ ],
  "paths" : [ {
    "name" : "type",
    "value" : "module",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(module|service)$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"module\": \"Others\",\n        \"value\": 147741.43\n    }, {\n        \"module\": \"服务器\",\n        \"value\": 111482.97\n    }, {\n        \"module\": \"工具\",\n        \"value\": 19272.20\n    }, {\n        \"module\": \"云原生\",\n        \"value\": 16824.44\n    }, {\n        \"module\": \"虚拟化\",\n        \"value\": 10591.44\n    }, {\n        \"module\": \"DevStation\",\n        \"value\": 7168.97\n    }, {\n        \"module\": \"Server\",\n        \"value\": 2485.45\n    }, {\n        \"module\": \"嵌入式\",\n        \"value\": 1967.47\n    }, {\n        \"module\": \"规范与门禁\",\n        \"value\": 1804.22\n    }, {\n        \"module\": \"Cloud\",\n        \"value\": 1782.86\n    }, {\n        \"module\": \"边缘计算\",\n        \"value\": 1493.27\n    }, {\n        \"module\": \"技术案例\",\n        \"value\": 1179.88\n    }, {\n        \"module\": \"概述\",\n        \"value\": 830.41\n    }, {\n        \"module\": \"通用\",\n        \"value\": 759.54\n    }, {\n        \"module\": \"文档组织架构\",\n        \"value\": 234.56\n    }, {\n        \"module\": \"Tools\",\n        \"value\": 158.79\n    }, {\n        \"module\": \"快速入门\",\n        \"value\": 140.48\n    }, {\n        \"module\": \"社区工具\",\n        \"value\": 48.17\n    }, {\n        \"module\": \"Embedded\",\n        \"value\": 3.23\n    }, {\n        \"module\": \"Virtualization\",\n        \"value\": 3.11\n    }, {\n        \"module\": \"Edge Computing\",\n        \"value\": 1.11\n    }, {\n        \"module\": \"General\",\n        \"value\": 0.28\n    }, {\n        \"module\": \"Overview\",\n        \"value\": 0.24\n    }, {\n        \"module\": \"Community Tools\",\n        \"value\": 0.20\n    }, {\n        \"module\": \"Quick Start\",\n        \"value\": 0.04\n    }, {\n        \"module\": \"Tutorials\",\n        \"value\": 0.02\n    }],\n    \"timestamp\": 1760088348976,\n    \"executeTime\": 22\n}",
  "description" : null,
  "requestBodyDefinition" : {
    "name" : "root",
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
      "name" : "community",
      "value" : "openeuler",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "service",
      "value" : "docs",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^[a-zA-Z0-9_]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "metric",
      "value" : "stay_time",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(stay_time|visit_time)$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "1729017600000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : null,
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1759017600000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : null,
      "expression" : null,
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : {
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
      "name" : "code",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "message",
      "value" : "success",
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
      "name" : "data",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
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
          "name" : "module",
          "value" : "Others",
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
          "name" : "value",
          "value" : "147741.43",
          "description" : "",
          "required" : false,
          "dataType" : "Double",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1760088348976",
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
      "name" : "executeTime",
      "value" : "22",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  }
}
================================
var coefficient = body.metric == "stay_time" ? 3600.00 : 1
var position = body.metric == "stay_time" ? 2 : 0
var sql = """
SELECT 
    ${type},
    ROUND(coalesce(sum(${body.metric}), 0) / ${coefficient}, ${position}) AS value
FROM dws_${body.community}_module_time_day
WHERE 1 = 1
        <if test="type == 'module' and body.service != null and body.service != ''">
            AND service = #{body.service}
        </if>
        <if test="body.start != null">
            AND date >= to_timestamp(#{body.start}/1000)::DATE
        </if>
        <if test="body.end != null">
            AND date <= to_timestamp(#{body.end}/1000)::DATE
        </if>
GROUP BY ${type}
ORDER BY value DESC;
"""
return db.select(sql)

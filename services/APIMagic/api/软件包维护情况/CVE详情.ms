{
  "properties" : { },
  "id" : "copy1750386928571d28213",
  "script" : null,
  "groupId" : "24e4ef78cdc04b758533330015c64bf1",
  "name" : "CVE详情",
  "createTime" : null,
  "updateTime" : 1750401974527,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/cve",
  "method" : "GET",
"parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openeuler",
    "validateType" : "pattern",
    "error" : "community 必须是纯字母，长度1-32",
    "expression" : "^[a-zA-Z]{1,32}$?"
  }, {
    "name" : "start",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"repo_path\": \"risc-v-kernel\",\n        \"sig\": \"No-SIG\",\n        \"cve_num\": 1648,\n        \"unfixed\": 1494,\n        \"loop_rate\": 0.9065533980582524\n    }, {\n        \"repo_path\": \"firefox\",\n        \"sig\": \"Application\",\n        \"cve_num\": 935,\n        \"unfixed\": 329,\n        \"loop_rate\": 0.3518716577540107\n    }, {\n        \"repo_path\": \"chromium\",\n        \"sig\": \"Application\",\n        \"cve_num\": 884,\n        \"unfixed\": 264,\n        \"loop_rate\": 0.2986425339366516\n    }, {\n        \"repo_path\": \"kernel\",\n        \"sig\": \"Kernel\",\n        \"cve_num\": 5199,\n        \"unfixed\": 243,\n        \"loop_rate\": 0.0467397576457011\n    }, {\n        \"repo_path\": \"tensorflow\",\n        \"sig\": \"ai\",\n        \"cve_num\": 399,\n        \"unfixed\": 173,\n        \"loop_rate\": 0.43358395989974935\n    }, {\n        \"repo_path\": \"thunderbird\",\n        \"sig\": \"sig-desktop-apps\",\n        \"cve_num\": 360,\n        \"unfixed\": 131,\n        \"loop_rate\": 0.3638888888888889\n    }, {\n        \"repo_path\": \"zephyr\",\n        \"sig\": \"sig-Zephyr\",\n        \"cve_num\": 56,\n        \"unfixed\": 49,\n        \"loop_rate\": 0.875\n    }, {\n        \"repo_path\": \"ignition\",\n        \"sig\": \"sig-K8sDistro\",\n        \"cve_num\": 57,\n        \"unfixed\": 42,\n        \"loop_rate\": 0.7368421052631579\n    }, {\n        \"repo_path\": \"freeimage\",\n        \"sig\": \"dev-utils\",\n        \"cve_num\": 48,\n        \"unfixed\": 31,\n        \"loop_rate\": 0.6458333333333334\n    }, {\n        \"repo_path\": \"kubevirt\",\n        \"sig\": \"sig-CloudNative\",\n        \"cve_num\": 50,\n        \"unfixed\": 30,\n        \"loop_rate\": 0.6\n    }],\n    \"timestamp\": 1750389086673,\n    \"executeTime\": 33\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
WITH cve_temp AS(
    SELECT
        repo_path,
        count(1) AS cve_num,
        count(1) FILTER (WHERE state not in ('closed', 'rejected') AND customize_state <> '已挂起') AS unfixed
    FROM fact_${community}_cve
    GROUP BY repo_path
)
SELECT distinct ct.repo_path, COALESCE(fcsu.sig_name, 'No-SIG') AS sig, ct.cve_num, ct.unfixed, ct.unfixed/ct.cve_num::float AS loop_rate
FROM cve_temp ct
INNER JOIN fact_${community}_sig_user fcsu
ON ct.repo_path = fcsu.repo_path
ORDER BY unfixed DESC
LIMIT 10
"""
var result = db.select(sqlstr)
return result

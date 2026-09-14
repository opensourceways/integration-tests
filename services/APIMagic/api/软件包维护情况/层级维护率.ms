{
  "properties" : { },
  "id" : "copy1750386793285d76419",
  "script" : null,
  "groupId" : "24e4ef78cdc04b758533330015c64bf1",
  "name" : "层级维护率",
  "createTime" : null,
  "updateTime" : 1753844710930,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/level/status",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"pkg_status\": \"健康\",\n        \"level\": \"L1\",\n        \"repos\": 4,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"健康\",\n        \"level\": \"L2\",\n        \"repos\": 33,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"健康\",\n        \"level\": \"L3\",\n        \"repos\": 741,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"健康\",\n        \"level\": \"L4\",\n        \"repos\": 2006,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"活跃\",\n        \"level\": \"L1\",\n        \"repos\": 13,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"活跃\",\n        \"level\": \"L2\",\n        \"repos\": 18,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"活跃\",\n        \"level\": \"L3\",\n        \"repos\": 341,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"活跃\",\n        \"level\": \"L4\",\n        \"repos\": 1660,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"缺人维护\",\n        \"level\": \"L1\",\n        \"repos\": 7,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"缺人维护\",\n        \"level\": \"L2\",\n        \"repos\": 3,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"缺人维护\",\n        \"level\": \"L3\",\n        \"repos\": 30,\n        \"percent\": 0\n    }, {\n        \"pkg_status\": \"缺人维护\",\n        \"level\": \"L4\",\n        \"repos\": 144,\n        \"percent\": 0\n    }],\n    \"timestamp\": 1751001348277,\n    \"executeTime\": 50\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT
    status AS pkg_status,
    level,
    count(distinct repo_path) AS repos
FROM dws_${community}_package_status
WHERE kind <> 'epol' AND created_at = (SELECT max(created_at) FROM dws_openeuler_package_status)
GROUP BY pkg_status, level
ORDER BY pkg_status, level;
"""
var result = db.select(sqlstr)
var count = 0::float
result.each(it => count += it.repos)
var level_map = {}
groups = result.group(it => it.level)
groups.each((key,value) => {
    cnt = 0
    for (pkg in value) {
        cnt += pkg['repos']
    }
   level_map[key] = cnt::float
})
result.each(it => it['percent'] = it.repos/level_map[it.level])
return result

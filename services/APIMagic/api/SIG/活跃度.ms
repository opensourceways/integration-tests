{
  "properties" : { },
  "id" : "c0437d4a1ae74ac99dc3d7301e2c2d62",
  "script" : null,
  "groupId" : "1cc0849322d74468ab73c9ad0f14fc02",
  "name" : "活跃度",
  "createTime" : null,
  "updateTime" : 1774578860430,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/score",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "order",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "desc",
    "validateType" : "pattern",
    "error" : "order 参数非法",
    "expression" : "^(asc|desc)?$",
    "children" : null
  }, {
    "name" : "page",
    "value" : "1",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : "page 必须大于 0",
    "expression" : "page > 0",
    "children" : null
  }, {
    "name" : "page_size",
    "value" : "10",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "10",
    "validateType" : "expression",
    "error" : "page_size 必须在 1-100 之间",
    "expression" : "page_size > 0 && page_size <= 100",
    "children" : null
  }, {
    "name" : "status",
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
  }, {
    "name" : "date",
    "value" : "1769875199000",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"sig_name\": \"sig-minzuchess\",\n        \"score\": 0.04460261,\n        \"created_at\": \"2026-01-31\"\n    }, {\n        \"sig_name\": \"sig-Talent-and-Service\",\n        \"score\": 0.07069346,\n        \"created_at\": \"2026-01-31\"\n    }, {\n        \"sig_name\": \"sig-LoongArch\",\n        \"score\": 0.103564054,\n        \"created_at\": \"2026-01-31\"\n    }, {\n        \"sig_name\": \"sig-Hygon\",\n        \"score\": 0.13055034,\n        \"created_at\": \"2026-01-31\"\n    }, {\n        \"sig_name\": \"sig-FangTian\",\n        \"score\": 0.14951153,\n        \"created_at\": \"2026-01-31\"\n    }, {\n        \"sig_name\": \"sig-sw-arch\",\n        \"score\": 0.15429968,\n        \"created_at\": \"2026-01-31\"\n    }, {\n        \"sig_name\": \"sig-Arm\",\n        \"score\": 0.1906,\n        \"created_at\": \"2026-01-31\"\n    }, {\n        \"sig_name\": \"Packaging\",\n        \"score\": 0.21729794,\n        \"created_at\": \"2026-01-31\"\n    }, {\n        \"sig_name\": \"sig-OceanBase\",\n        \"score\": 0.22506902,\n        \"created_at\": \"2026-01-31\"\n    }, {\n        \"sig_name\": \"G11N\",\n        \"score\": 0.23335953,\n        \"created_at\": \"2026-01-31\"\n    }],\n    \"timestamp\": 1774578856002,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var off = (page - 1) * page_size
var sqlstr = """
SELECT
    sig_name, score
FROM dws_community_sig_score
WHERE community=#{community}         
        <if test="date != null and date != ''">
            AND created_at = to_timestamp(#{date}/1000)::date
        </if>
        <else>
            AND created_at = (select max(created_at) from dws_community_sig_score where community = #{community})
        </else>
        <if test="status != null and status != ''">
            AND status = #{status}
        </if>
ORDER BY rank ${order}
LIMIT #{page_size} OFFSET #{off};
"""
var result = db.select(sqlstr)
return result

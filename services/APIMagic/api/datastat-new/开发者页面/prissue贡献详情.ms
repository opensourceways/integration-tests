{
  "properties" : { },
  "id" : "f57701d18a0f4553b86779463be8cde8",
  "script" : null,
  "groupId" : "3a27e930d2934b3e99edef7ee1dee30a",
  "name" : "prissue贡献详情",
  "createTime" : null,
  "updateTime" : 1774947240365,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/{contributeType}/detail",
  "method" : "GET",
  "parameters" : [ {
    "name" : "user",
    "value" : "dli_bmc",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "page",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "pageSize",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "10",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
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
  }, {
    "name" : "sig",
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
    "name" : "filter",
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
    "name" : "start",
    "value" : "1773676800000",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : "1773763200000",
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
  "paths" : [ {
    "name" : "contributeType",
    "value" : "pr",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(issue|pr)$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"info\": \"component driver接口变化\",\n        \"repo\": \"openUBMC/manifest\",\n        \"time\": \"2026-03-17 15:41:00\",\n        \"url\": \"https://gitcode.com/openUBMC/manifest/merge_requests/630\",\n        \"no\": \"630\"\n    }, {\n        \"info\": \"修复网卡通知式热插拔，没有设置设备树ReadyToRemoveValue问题\",\n        \"repo\": \"openUBMC/network_adapter\",\n        \"time\": \"2026-03-17 11:59:12\",\n        \"url\": \"https://gitcode.com/openUBMC/network_adapter/merge_requests/363\",\n        \"no\": \"363\"\n    }, {\n        \"info\": \"实现对网卡通知式热插拔accessor的管理\",\n        \"repo\": \"openUBMC/component_drivers\",\n        \"time\": \"2026-03-17 00:20:48\",\n        \"url\": \"https://gitcode.com/openUBMC/component_drivers/merge_requests/421\",\n        \"no\": \"421\"\n    }],\n    \"timestamp\": 1774573808400,\n    \"executeTime\": 180\n}",
  "description" : null,
  "requestBodyDefinition" : null,
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
          "name" : "info",
          "value" : "[sync] PR-21: fix CVE-2025-2814",
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
          "name" : "repo",
          "value" : "src-openeuler/perl-Crypt-CBC",
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
          "name" : "time",
          "value" : "2025-07-31 14:03:11",
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
          "name" : "url",
          "value" : "https://gitee.com/src-openeuler/perl-Crypt-CBC/pulls/22",
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
          "name" : "no",
          "value" : "22",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1754557666452",
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
      "value" : "1981",
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
filter = filter != null ? filter.toLowerCase() : filter
var off = (page - 1) * pageSize
var time_field = contributeType == 'pr' ? 'merged_at' : 'created_at'
var sqlstr = """
SELECT title as info,
       CONCAT(namespace,'/',repo_path) as repo,
       ${time_field} as time,
       html_url as url,
       split_part(html_url , '/', -1) as no
FROM dws_${community}_contribute
WHERE
    user_login = #{user} AND contrib_type=#{contributeType} 
        <if test="contributeType == 'pr'">
            AND state = 'merged'
        </if>     
        <if test="sig != null and sig != ''">
            AND #{sig} = ANY(sig_name)
        </if>
        <if test="start != '' and start != null">
            AND ${time_field} >= to_timestamp(#{start}/1000)
        </if>
        <if test="end != '' and end != null">
            AND ${time_field} <= to_timestamp(#{end}/1000)
        </if>
        <if test="filter != '' and filter != null">
            AND lower(title) like concat('%',#{filter},'%')
        </if>
        <if test="community == 'openubmc'">
            AND private = 'false'
        </if>
        AND is_removed IS NULL
ORDER BY ${time_field} desc
LIMIT #{pageSize} OFFSET #{off};
"""
var resp = db.select(sqlstr)
return resp

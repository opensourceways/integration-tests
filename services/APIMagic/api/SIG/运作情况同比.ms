{
  "properties" : { },
  "id" : "copy1750402693753d74548",
  "script" : null,
  "groupId" : "1cc0849322d74468ab73c9ad0f14fc02",
  "name" : "运作情况同比",
  "createTime" : null,
  "updateTime" : 1774578930383,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/status/on/{interval}",
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
    "error" : "community 参数非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "date",
    "value" : "1773817269501",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "date 必须大于 0",
    "expression" : "",
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
    "name" : "interval",
    "value" : "quarter",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "interval 参数非法",
    "expression" : "^(month|quarter|year)$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"ratio\": 0.015151501,\n        \"last\": 10\n    },\n    \"timestamp\": 1774578898108,\n    \"executeTime\": 31\n}",
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
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "ratio",
        "value" : "-0.045454502",
        "description" : "",
        "required" : false,
        "dataType" : "Double",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      }, {
        "name" : "last",
        "value" : "65",
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
    }, {
      "name" : "timestamp",
      "value" : "1761651906184",
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
      "value" : "12",
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
if (interval == 'quarter') {
    interval = '3 months'
}
else {
    interval = '1' + interval
}
active = '活跃'
var sqlstr = """
WITH date_series AS (
    <if test="date != null and date != ''">
        SELECT 'current' as period, to_timestamp(#{date}/1000)::date as created_at
        UNION ALL
        SELECT 'previous' as period, (to_timestamp(#{date}/1000) - CAST(#{interval} AS interval))::date as created_at
    </if>
    <else>
        SELECT 'current' as period, CURRENT_DATE ::date as created_at
        UNION ALL
        SELECT 'previous' as period, (CURRENT_DATE - INTERVAL #{interval})::date as created_at
    </else>
)
    SELECT
        ds.period,
        ds.created_at,
        COUNT(1) FILTER (WHERE status = #{active}) as effect,
        COUNT(1) as total
    FROM date_series ds
    LEFT JOIN dws_community_sig_score dcss 
        ON dcss.community = #{community}
        AND dcss.created_at = ds.created_at
    GROUP BY ds.period, ds.created_at
"""
var result = db.select(sqlstr)
var ratio = []
result.each(it => ratio.add(it.effect/it.total::float))
var ans = {}
ans['ratio'] = ratio[0] - ratio[1]
ans['last'] = result[0].effect
return ans

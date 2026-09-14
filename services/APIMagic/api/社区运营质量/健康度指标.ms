{
  "properties" : { },
  "id" : "copy1773128523846d32454",
  "script" : null,
  "groupId" : "2e2220ca1c424052ba4fa20a1e7370f8",
  "name" : "健康度指标",
  "createTime" : null,
  "updateTime" : 1774578004983,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/health_metric",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : "社区名称",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "",
    "description" : "查询范围开始时间,格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : "",
    "description" : "查询范围结束时间,格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : null,
    "children" : null
  }, {
    "name" : "metric",
    "value" : "",
    "description" : "健康度指标类型",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "metric 只能是 nss、download、issue_close、certification、first_response、leverage_ratio、tech_influence、version_release、elephant_coefficient、effective_maintenance、contribution_diversity、contributor_interaction",
    "expression" : "^(nss|download|issue_close|certification|first_response|leverage_ratio|tech_influence|version_release|elephant_coefficient|effective_maintenance|contribution_diversity|contributor_interaction)$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"avg\": 0.75\n    },\n    \"timestamp\": 1773130260220,\n    \"executeTime\": 4\n}",
  "description" : "查询指定社区指定时间范围内的社区健康度指标均值汇总。\n指标包含：nss/社区影响力(NSS)、download/下载量、issue_close/Issue关闭率、certification/认证、first_response/首次响应、leverage_ratio/杠杆率、tech_influence/技术影响力、version_release/版本发布偏差、elephant_coefficient/大象系数、effective_maintenance/有效维护、contribution_diversity/贡献多样性、contributor_interaction/贡献者互动\n不传时间范围时返回全量总计。\n适合：汇总统计、总体评估。",
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
        "name" : "avg",
        "value" : "0.0",
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
    }, {
      "name" : "timestamp",
      "value" : "1773129825981",
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
      "value" : "5",
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
community = community.toLowerCase()
var sql = """
SELECT COALESCE(avg(${metric}_value), 0) AS avg
FROM dws_community_health_metric
WHERE community = #{community}
    <if test="start != null and start != ''">
        AND created_at >= to_timestamp(#{start}/1000)
    </if>
    <if test="end != null and end != ''">
        AND created_at <= to_timestamp(#{end}/1000)
    </if>
"""
var resp = db.selectOne(sql)
return resp

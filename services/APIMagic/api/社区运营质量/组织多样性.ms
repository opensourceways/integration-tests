{
  "properties" : { },
  "id" : "ce28848368494e49ade20b4ef6c8cae4",
  "script" : null,
  "groupId" : "2e2220ca1c424052ba4fa20a1e7370f8",
  "name" : "组织多样性",
  "createTime" : null,
  "updateTime" : 1774577878892,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/company",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "vllm",
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
    "value" : "1762553600000",
    "description" : "查询范围开始时间,格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "start 必须为合法的毫秒级时间戳",
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : "1772553600000",
    "description" : "查询范围结束时间,格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "end 必须为合法的毫秒级时间戳",
    "expression" : null,
    "children" : null
  }, {
    "name" : "private",
    "value" : "false",
    "description" : "是否私仓，默认 false 表示仅统计公仓数据，true 表示统计所有数据（包括私仓）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "false",
    "validateType" : "pattern",
    "error" : "private 只能为 true 或 false",
    "expression" : "^(true|false)?$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"count\": 7\n    },\n    \"timestamp\": 1773219608821,\n    \"executeTime\": 14\n}",
  "description" : "查询指定社区指定时间范围内的贡献组织/企业/公司多样性汇总。\n不传时间范围时返回全量总计。\n适合：汇总统计、总体评估。",
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
        "name" : "count",
        "value" : "49",
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
      "value" : "1773219066112",
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
      "value" : "85",
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
SELECT count(distinct company)
FROM dws_${community}_contribute_repo_company_daily
WHERE company <> 'robot' AND company <> '个人贡献者'
    <if test="private == 'false'">
        and private = #{private}
    </if>
    <if test="start != null and start != ''">
        AND date >= to_timestamp(#{start}/1000)
    </if>
    <if test="end != null and end != ''">
        AND date <= to_timestamp(#{end}/1000)
    </if>
"""
var resp = db.selectOne(sql)
return resp

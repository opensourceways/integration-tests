{
  "properties" : { },
  "id" : "dff537f2baaa4c6eab941cd0c19239bf",
  "script" : null,
  "groupId" : "2e2220ca1c424052ba4fa20a1e7370f8",
  "name" : "贡献指标",
  "createTime" : null,
  "updateTime" : 1774577971237,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/contribute",
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
    "value" : "1752553600000",
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
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"activate_user\": 868,\n        \"prs\": 3276,\n        \"merged_prs\": 2516,\n        \"issues\": 2552,\n        \"merged_pr_user\": 340\n    },\n    \"timestamp\": 1774350864665,\n    \"executeTime\": 6\n}",
  "description" : "查询指定社区指定时间范围内的贡献数据汇总，包含提交的 PR 数、合并的 PR 数、提交的 Issue 数、活跃用户数、合并 PR 用户数。\n不传时间范围时返回全量总计。\n适合：汇总统计、总体评估。",
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
        "name" : "activate_user",
        "value" : "868",
        "description" : "当期活跃开发者人数",
        "required" : false,
        "dataType" : "Integer",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      }, {
        "name" : "prs",
        "value" : "3276",
        "description" : "提交的pr总数",
        "required" : false,
        "dataType" : "Integer",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      }, {
        "name" : "merged_prs",
        "value" : "2516",
        "description" : "合并的pr总数",
        "required" : false,
        "dataType" : "Integer",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      }, {
        "name" : "issues",
        "value" : "2552",
        "description" : "提交的issue总数",
        "required" : false,
        "dataType" : "Integer",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      }, {
        "name" : "merged_pr_user",
        "value" : "340",
        "description" : "当期合并的pr用户",
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
      "value" : "1773143455111",
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
      "value" : "102",
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
SELECT count(distinct user_login) filter (where pr_incre > 0 or issue_incre > 0 or comment_incre > 0) as activate_user, 
       COALESCE(sum(pr_incre), 0) as prs,
       COALESCE(sum(merged_pr_incre), 0) as merged_prs, 
       COALESCE(sum(issue_incre), 0) as issues,
       count(distinct user_login) filter (where merged_pr_incre > 0) as merged_pr_user
FROM dws_${community}_contribute_repo_user_daily
WHERE 1 = 1
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

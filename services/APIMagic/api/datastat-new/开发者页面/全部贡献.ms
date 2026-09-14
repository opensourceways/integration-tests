{
  "properties" : { },
  "id" : "140582c8e826425d96b997f7352bd98c",
  "script" : null,
  "groupId" : "3a27e930d2934b3e99edef7ee1dee30a",
  "name" : "全部贡献",
  "createTime" : null,
  "updateTime" : 1774947231950,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/count",
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
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "user",
    "value" : "zhongjun2",
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
    "value" : "",
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
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"pr\": 0,\n        \"issue\": 0,\n        \"comment\": 0,\n        \"sig\": 0\n    },\n    \"timestamp\": 1759109290220,\n    \"executeTime\": 136\n}",
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
        "name" : "pr",
        "value" : "119",
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
        "name" : "issue",
        "value" : "11",
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
        "name" : "comment",
        "value" : "976",
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
        "name" : "sig",
        "value" : "10",
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
      "value" : "1745304521450",
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
      "value" : "11",
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
var sqlstr = """
SELECT 
    coalesce(sum(merged_pr_incre),0) as pr,
    coalesce(sum(issue_incre),0) as issue,
    coalesce(sum(comment_incre),0) as comment
FROM 
    dws_${community}_contribute_repo_user_daily
WHERE 1 = 1
    <if test="user != null and user != ''">
        AND user_login = #{user}
    </if>
    <if test="start != null and start != ''">
        AND date >= to_timestamp(#{start}/1000)
    </if>
    <if test="end != null and end != ''">
        AND date <= to_timestamp(#{end}/1000)
    </if>
    <if test="community == 'openubmc'">
        AND private = 'false'
    </if>
"""
var resp = db.select(sqlstr)[0]
var sig_count = 0
var sigstr = """
    SELECT
        count(distinct sig_name) AS sig
    FROM 
        dws_${community}_contribute_sig_user_daily
    WHERE user_login = #{user} 
        AND sig_name <> 'No-SIG'
        AND merged_pr_incre + issue_incre + comment_incre > 0
        <if test="start != null and start != ''">
            AND date >= to_timestamp(#{start}/1000)
        </if>
        <if test="end != null and end != ''">
            AND date <= to_timestamp(#{end}/1000)
        </if>
    """
sig_count = db.select(sigstr)[0]['sig']
resp['sig'] = sig_count
return resp

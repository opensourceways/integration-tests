{
  "properties" : { },
  "id" : "fc11085d42b5451690b6c176c733e4a1",
  "script" : null,
  "groupId" : "a722ad28731b4662827d7142c054a3d7",
  "name" : "全部贡献",
  "createTime" : null,
  "updateTime" : 1769390647874,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/count",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^(openeuler|opengauss|mindspore|openubmc|openfuyao)$",
    "children" : null
  }, {
    "name" : "user",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "user 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "timeRange",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "all",
    "validateType" : "pattern",
    "error" : "timeRange 参数非法",
    "expression" : "^(all|lastonemonth|lasthalfyear|lastoneyear)?$",
    "children" : null
  }, {
    "name" : "sig",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "sig 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "comment_type",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "comment_type 参数非法",
    "expression" : "^(command|normal)?$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"pr\": 41,\n        \"issue\": 11,\n        \"comment\": 763,\n        \"sig\": 10\n    },\n    \"timestamp\": 1754290638615,\n    \"executeTime\": 8\n}",
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
var sig_count = 1
if (sig == null or sig == '') {
    var table_name = `ads_${community}_repo_user_stat`
    var sqlstr = """
        SELECT
            count(distinct sig_name) AS sig
        FROM 
            ads_${community}_sig_user_stat
        WHERE user_login = #{user} 
            AND sig_name <> 'No-SIG'
            AND merged_pr_count_${timeRange} + issue_count_${timeRange} + comment_count_${timeRange} > 0;
    """
    sig_count = db.select(sqlstr)[0]['sig']
}
else {
    var table_name = `ads_${community}_sig_user_stat`
}
comment_field = comment_type == 'normal' ? `valid_comment_count_${timeRange}` : comment_type == 'command' ? `comment_count_${timeRange} - valid_comment_count_${timeRange}` : `comment_count_${timeRange}`
var sqlstr = """
SELECT 
    sum(merged_pr_count_${timeRange}) as pr,
    sum(issue_count_${timeRange}) as issue,
    sum(${comment_field}) as comment
FROM 
    ${table_name}
WHERE user_login = #{user}
        <if test="sig != null and sig != ''">  
            AND sig_name = #{sig}
        </if>;"""
var resp = db.select(sqlstr)[0]
resp['sig'] = sig_count
return resp

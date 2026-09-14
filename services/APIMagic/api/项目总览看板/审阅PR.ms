{
  "properties" : { },
  "id" : "copy1751254407908d87831",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "审阅PR",
  "createTime" : null,
  "updateTime" : 1773818116711,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/review_pr_total",
  "method" : "POST",
  "parameters" : [ ],
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
  "requestBody" : "{\r\n    \"start\":1704038400000,\r\n    \"end\":1735660800000,\r\n    \"community\":\"openeuler\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"review_pr_count\": 45297,\n        \"review_pr_user_count\": 1490\n    },\n    \"timestamp\": 1761708642391,\n    \"executeTime\": 200\n}",
  "description" : null,
  "requestBodyDefinition" : {
    "name" : "root",
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
      "name" : "start",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "orgList",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "repo_path",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 格式非法",
      "expression" : "^([a-zA-Z0-9_\\-./]+)?$",
      "children" : [ ]
    }, {
      "name" : "private",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "private 格式非法",
      "expression" : "^(true|false)?$",
      "children" : [ ]
    }, {
      "name" : "event",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "event 格式非法",
      "expression" : "^[a-zA-Z]*$",
      "children" : [ ]
    }, {
      "name" : "metric",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "metric 格式非法",
      "expression" : "^[a-zA-Z_]*$",
      "children" : [ ]
    } ]
  },
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
        "name" : "review_pr_count",
        "value" : "919",
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
        "name" : "review_pr_user_count",
        "value" : "178",
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
      "value" : "1761707783628",
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
      "value" : "754",
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
import java.math.BigDecimal;
import java.math.RoundingMode;
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 社区
var community = body.community.toLowerCase();
// 社区
var repo_path = body.repo_path;
var repo_arr = repo_path != null ? repo_path.split("/"):[];
var namespace = "";
if(repo_arr.size() == 2){
    namespace = repo_arr[0];
    repo_path = repo_arr[1];
}
// 贡献表
var reviewTable = "dws_" + community + "_contribute_repo_daily";
HashMap result = new HashMap();
var review_pr_user_count = 0;
var review_pr_count = 0;
var contributeTable = "dws_" + community + "_contribute_repo_daily";
var robotUserTable = "fact_community_robot_user";
var review_sql = """
WITH user_detail as (
    SELECT 
        source, internal, unnest(user_review_pr_arr) as user_review_pr_combo
    FROM ${contributeTable}
    WHERE date BETWEEN #{start} AND #{end} and private = 'false'
        <if test="namespace != null and namespace != ''">
            and namespace = #{namespace}
        </if>
        <if test="repo_path != null and repo_path != ''">
            and repo_path = #{repo_path}
        </if>
),
split_user as (
    select 
        source, internal,
        split_part(user_review_pr_combo, ',', 1) AS user_login,
        split_part(user_review_pr_combo, ',', 2) AS pr_html
    from user_detail
),
filter_user as (
    select 
        count(distinct ROW(source, internal, user_login)) as review_user_count,
        count(distinct pr_html) as review_pr_count
    from split_user
    where user_login not like '%.del'
        and user_login not in (
            select user_login from ${robotUserTable}
        )
)
select * from filter_user
""";
var review_data = db.select(review_sql);
if (review_data != null and review_data.size() > 0){
    var review_obj = review_data[0];
    review_pr_user_count = review_obj.get("review_user_count");
    review_pr_count = review_obj.get("review_pr_count");
}
// 全部用户审阅pr的数量
result.put("review_pr_user_count", review_pr_user_count);
// 审阅pr的用户数量
result.put("review_pr_count", review_pr_count);
return result;

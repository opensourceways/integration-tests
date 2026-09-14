{
  "properties" : { },
  "id" : "a145527855b14c879ecafe25d4b1754c",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "活跃度",
  "createTime" : null,
  "updateTime" : 1773817918187,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/active",
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
  "requestBody" : "{\r\n    \"start\": 1719763200000,\r\n    \"end\": 1756656000000,\r\n    \"community\":\"cannopen\",\r\n    \"repo_path\": \"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"huawei_user_merged_pr_count\": 445,\n        \"total_issue_count\": 259,\n        \"open_pr_count\": 195,\n        \"pr_user_count\": 269,\n        \"total_pr_count\": 711,\n        \"other_user_count\": 25,\n        \"review_pr_count\": 0,\n        \"other_user_merged_pr_count\": 71,\n        \"open_pr_user_count\": 141,\n        \"pr_ratio\": 0.7257,\n        \"open_issue_count\": 100,\n        \"huawei_user_count\": 165,\n        \"review_pr_user_count\": 0,\n        \"merged_pr_count\": 516,\n        \"closed_issue_count\": 159,\n        \"issue_ratio\": 0.6139,\n        \"pr_count\": 830\n    },\n    \"timestamp\": 1761556140284,\n    \"executeTime\": 9\n}",
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
        "name" : "huawei_user_merged_pr_count",
        "value" : "1636",
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
        "name" : "total_issue_count",
        "value" : "441",
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
        "name" : "open_pr_count",
        "value" : "303",
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
        "name" : "pr_user_count",
        "value" : "269",
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
        "name" : "total_pr_count",
        "value" : "8161",
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
        "name" : "other_user_count",
        "value" : "193",
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
        "name" : "review_pr_count",
        "value" : "0",
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
        "name" : "other_user_merged_pr_count",
        "value" : "6222",
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
        "name" : "open_pr_user_count",
        "value" : "111",
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
        "name" : "pr_ratio",
        "value" : "0.9629",
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
        "name" : "open_issue_count",
        "value" : "3",
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
        "name" : "huawei_user_count",
        "value" : "46",
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
        "value" : "0",
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
        "name" : "merged_pr_count",
        "value" : "7858",
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
        "name" : "closed_issue_count",
        "value" : "438",
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
        "name" : "issue_ratio",
        "value" : "0.9932",
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
        "name" : "pr_count",
        "value" : "9918",
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
      "value" : "1761189692359",
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
      "value" : "17",
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
var contributeTable = "dws_" + community + "_contribute_repo_user_daily";
// 华为开发者：人数，合入pr数
// 非华为开发者：人数，合入pr数
var internal_sql = """
WITH user_activity AS (
  SELECT 
    internal,
    user_login,
    -- 预计算每个用户的各种活动标记
    MAX(pr_incre) > 0 as has_pr,
    MAX(open_pr_incre) > 0 as has_open_pr,
    MAX(merged_pr_incre) > 0 as has_merged_pr,
    MAX(open_issue_incre) > 0 as has_open_issue,
    MAX(closed_issue_incre) > 0 as has_closed_issue,
    MAX(review_pr_incre) > 0 as has_review_pr,
    -- 预计算每个用户的各种活动总和
    SUM(pr_incre) as user_pr_sum,
    SUM(open_pr_incre) as user_open_pr_sum,
    SUM(merged_pr_incre) as user_merged_pr_sum,
    SUM(open_issue_incre) as user_open_issue_sum,
    SUM(closed_issue_incre) as user_closed_issue_sum,
    SUM(review_pr_incre) as user_review_pr_sum
  FROM ${contributeTable}
  WHERE private = 'false' and date BETWEEN #{start} AND #{end}
    <if test="namespace != null and namespace != ''">
        and namespace = #{namespace}
    </if>
    <if test="repo_path != null and repo_path != ''">
        and repo_path in (#{repo_path})
    </if>
  GROUP BY internal, user_login
)
SELECT 
  internal,
  COUNT(user_login) as user_count,
  SUM(user_pr_sum) as pr_count,
  COUNT(*) FILTER (WHERE has_pr) as pr_user_count,
  SUM(user_open_pr_sum) as open_pr_count,
  COUNT(*) FILTER (WHERE has_open_pr) as open_pr_user_count,
  SUM(user_merged_pr_sum) as merged_pr_count,
  COUNT(*) FILTER (WHERE has_merged_pr) as merged_pr_user_count,
  SUM(user_open_issue_sum) as open_issue_count,
  COUNT(*) FILTER (WHERE has_open_issue) as open_issue_user_count,
  SUM(user_closed_issue_sum) as closed_issue_count,
  COUNT(*) FILTER (WHERE has_closed_issue) as closed_issue_user_count,
  SUM(user_review_pr_sum) as review_pr_count,
  COUNT(*) FILTER (WHERE has_review_pr) as review_pr_user_count
FROM user_activity
GROUP BY internal;
""";
var internal_data = db.select(internal_sql);
var huawei_user_count = 0;
var huawei_user_merged_pr_count = 0;
var other_user_count = 0;
var other_user_merged_pr_count = 0;
var pr_user_count = 0;
var open_pr_user_count = 0;
var review_pr_user_count = 0;
var pr_count = 0;
var open_pr_count = 0;
var merged_pr_count = 0;
var review_pr_count = 0;
var open_issue_count = 0;
var closed_issue_count = 0;
if (internal_data.size() > 0){
   internal_data.forEach(item -> {
        open_pr_user_count += item.get("open_pr_user_count");
        pr_user_count += item.get("pr_user_count");
        pr_count += item.get("pr_count");
        if ("内部" == item.get("internal")){
            huawei_user_count = item.get("merged_pr_user_count");
            huawei_user_merged_pr_count = item.get("merged_pr_count");
            open_pr_count += item.get("open_pr_count");
            merged_pr_count += huawei_user_merged_pr_count;
            open_issue_count += item.get("open_issue_count");
            closed_issue_count += item.get("closed_issue_count");
        } else if ("外部" == item.get("internal")){
            other_user_count = item.get("merged_pr_user_count");
            other_user_merged_pr_count = item.get("merged_pr_count");
            open_pr_count += item.get("open_pr_count");
            merged_pr_count += other_user_merged_pr_count;
            open_issue_count += item.get("open_issue_count");
            closed_issue_count += item.get("closed_issue_count");
        }
    }) 
}
var total_pr_count = open_pr_count + merged_pr_count;
var total_issue_count = open_issue_count + closed_issue_count;
HashMap result = new HashMap();
// 华为合入pr的用户数量
result.put("huawei_user_count", huawei_user_count);
// 华为用户合入pr数量
result.put("huawei_user_merged_pr_count", huawei_user_merged_pr_count);
// 非华为合入pr的用户数量
result.put("other_user_count", other_user_count);
// 非华为用户合入pr数量
result.put("other_user_merged_pr_count", other_user_merged_pr_count);
// 全部用户提交pr的数量
result.put("open_pr_count", open_pr_count);
// 提交pr的用户数量
result.put("open_pr_user_count", open_pr_user_count);
// 全部用户合入的pr数量
result.put("merged_pr_count", merged_pr_count);
// 全部用户open+合入的pr数量
result.put("total_pr_count", total_pr_count);
result.put("active_pr_count", total_pr_count);
// 提交pr的用户数量
result.put("pr_user_count", pr_user_count);
// 全部用户提交的pr数量
result.put("pr_count", pr_count);
// 全部用户提交的issue数量
result.put("open_issue_count", open_issue_count);
// 全部用户关闭的issue数量
result.put("closed_issue_count", closed_issue_count);
// 全部用户提交+关闭的pr数量
result.put("total_issue_count", total_issue_count);
result.put("active_issue_count", total_issue_count);
BigDecimal merged_pr_count_float = merged_pr_count;
BigDecimal total_pr_count_float = total_pr_count;
var pr_ratio = 0;
if (total_pr_count > 0){
// 计算比率并保留4位小数，使用四舍五入
  pr_ratio = merged_pr_count_float.divide(total_pr_count_float, 4, RoundingMode.HALF_UP).doubleValue();
}
BigDecimal closed_issue_count_float = closed_issue_count;
BigDecimal total_issue_count_float = total_issue_count;
var issue_ratio = 0;
if (total_issue_count > 0){
// 计算比率并保留4位小数，使用四舍五入
  issue_ratio = closed_issue_count_float.divide(total_issue_count_float, 4, RoundingMode.HALF_UP).doubleValue();
}
// pr闭环率
result.put("pr_ratio", pr_ratio);
// issue闭环率
result.put("issue_ratio", issue_ratio);
// 全部用户审阅pr的数量
result.put("review_pr_user_count", review_pr_user_count)
// 审阅pr的用户数量
result.put("review_pr_count", review_pr_count);
return result;

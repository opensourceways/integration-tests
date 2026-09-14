{
  "properties" : { },
  "id" : "f2db1d0c198145f7a7431234a419dd67",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "撬动比",
  "createTime" : null,
  "updateTime" : 1773818061964,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/leverage-ratio",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1758384000000,\r\n    \"end\":1761032645042,\r\n    \"community\":\"openeuler\",\r\n    \"repo_path\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1761050712317,\n    \"executeTime\": 2014\n}",
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
        "name" : "other_addcode_count",
        "value" : "2155255",
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
        "name" : "huawei_addcode_count",
        "value" : "450084",
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
        "value" : "0.3408",
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
        "name" : "addcode_ratio",
        "value" : "-0.8918",
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
        "name" : "previous_pr_leverage_ratio",
        "value" : "2.6869",
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
        "name" : "other_merged_pr_count",
        "value" : "2367",
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
        "name" : "huawei_merged_pr_count",
        "value" : "657",
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
        "name" : "previous_addcode_leverage_ratio",
        "value" : "44.2551",
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
        "name" : "pr_leverage_ratio",
        "value" : "3.6027",
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
        "name" : "addcode_leverage_ratio",
        "value" : "4.7886",
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
      "value" : "1761034384786",
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
      "value" : "127",
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
var contributeTable = "dws_" + community + "_contribute_repo_company_daily";
var internal_sql = """
SELECT 
  internal,
  sum(merged_pr_incre) as merged_pr_count,
  sum(addcode_incre) as addcode_count
FROM ${contributeTable}
where date::DATE BETWEEN #{start} AND #{end} and private = 'false' and company != 'robot'
<if test="namespace != null and namespace != ''">
    and namespace = #{namespace}
</if>
<if test="repo_path != null and repo_path != ''">
    and repo_path in (#{repo_path})
</if>
GROUP BY internal
""";
var internal_data = db.select(internal_sql);
var huawei_merged_pr_count = 0;
var other_merged_pr_count = 0;
var huawei_addcode_count = 0;
var other_addcode_count = 0;
if (internal_data.size() > 0){
   internal_data.forEach(item -> {
        if ("内部" == item.get("internal")){
            huawei_merged_pr_count = item.get("merged_pr_count");
            huawei_addcode_count = item.get("addcode_count");
        } else if ("外部" == item.get("internal")){
            other_merged_pr_count = item.get("merged_pr_count");
            other_addcode_count = item.get("addcode_count");
        }
    }) 
}
BigDecimal huawei_merged_pr_count_float = BigDecimal.valueOf(huawei_merged_pr_count);
BigDecimal other_merged_pr_count_float = BigDecimal.valueOf(other_merged_pr_count);
var pr_leverage_ratio = 1;
if (huawei_merged_pr_count > 0){
// 计算比率并保留4位小数，使用四舍五入
  pr_leverage_ratio = other_merged_pr_count_float.divide(huawei_merged_pr_count_float, 4, RoundingMode.HALF_UP).doubleValue();
}
BigDecimal huawei_addcode_count_float = BigDecimal.valueOf(huawei_addcode_count);
BigDecimal other_addcode_count_float = BigDecimal.valueOf(other_addcode_count);
var addcode_leverage_ratio = 1;
if (huawei_addcode_count > 0){
// 计算比率并保留4位小数，使用四舍五入
  addcode_leverage_ratio = other_addcode_count_float.divide(huawei_addcode_count_float, 4, RoundingMode.HALF_UP).doubleValue();
}
var previous_internal_sql = """
SELECT 
  internal,
  sum(merged_pr_incre) as merged_pr_count,
  sum(addcode_incre) as addcode_count
FROM ${contributeTable}
where date::DATE BETWEEN '2024-01-01' AND '2024-12-31' and private = 'false'
<if test="namespace != null and namespace != ''">
    and namespace = #{namespace}
</if>
<if test="repo_path != null and repo_path != ''">
    and repo_path in (#{repo_path})
</if>
GROUP BY internal
""";
var previous_data = db.select(previous_internal_sql);
var previous_huawei_merged_pr_count = 0;
var previous_other_merged_pr_count = 0;
var previous_huawei_addcode_count = 0;
var previous_other_addcode_count = 0;
if (previous_data.size() > 0){
   previous_data.forEach(item -> {
        if ("内部" == item.get("internal")){
            previous_huawei_merged_pr_count = item.get("merged_pr_count");
            previous_huawei_addcode_count = item.get("addcode_count");
        } else if ("外部" == item.get("internal")){
            previous_other_merged_pr_count = item.get("merged_pr_count");
            previous_other_addcode_count = item.get("addcode_count");
        }
    }) 
}
BigDecimal previous_huawei_merged_pr_count_float = BigDecimal.valueOf(previous_huawei_merged_pr_count);
BigDecimal previous_other_merged_pr_count_float = BigDecimal.valueOf(previous_other_merged_pr_count);
var previous_pr_leverage_ratio = 1;
if (previous_huawei_merged_pr_count > 0){
// 计算比率并保留4位小数，使用四舍五入
  previous_pr_leverage_ratio = previous_other_merged_pr_count_float.divide(previous_huawei_merged_pr_count_float, 4, RoundingMode.HALF_UP).doubleValue();
}
BigDecimal previous_huawei_addcode_count_float = BigDecimal.valueOf(previous_huawei_addcode_count);
BigDecimal previous_other_addcode_count_float = BigDecimal.valueOf(previous_other_addcode_count);
var previous_addcode_leverage_ratio = 1;
if (huawei_addcode_count_float > 0){
// 计算比率并保留4位小数，使用四舍五入
  previous_addcode_leverage_ratio = previous_other_addcode_count_float.divide(huawei_addcode_count_float, 4, RoundingMode.HALF_UP).doubleValue();
}
var diff_pr_leverage_ratio = pr_leverage_ratio - previous_pr_leverage_ratio;
BigDecimal diff_pr_leverage_ratio_float = BigDecimal.valueOf(diff_pr_leverage_ratio);
BigDecimal previous_pr_leverage_ratio_float = BigDecimal.valueOf(previous_pr_leverage_ratio);
var pr_ratio = 0;
if (previous_pr_leverage_ratio > 0){
// 计算比率并保留4位小数，使用四舍五入
  pr_ratio = diff_pr_leverage_ratio_float.divide(previous_pr_leverage_ratio_float, 4, RoundingMode.HALF_UP).doubleValue();
}
var diff_addcode_leverage_ratio = addcode_leverage_ratio - previous_addcode_leverage_ratio;
BigDecimal diff_addcode_leverage_ratio_float = BigDecimal.valueOf(diff_addcode_leverage_ratio);
BigDecimal previous_addcode_leverage_ratio_float = BigDecimal.valueOf(previous_addcode_leverage_ratio);
var addcode_ratio = 0;
if (previous_addcode_leverage_ratio > 0){
// 计算比率并保留4位小数，使用四舍五入
  addcode_ratio = diff_addcode_leverage_ratio_float.divide(previous_addcode_leverage_ratio_float, 4, RoundingMode.HALF_UP).doubleValue();
}
HashMap result = new HashMap();
// 华为合并PR 数量
result.put("huawei_merged_pr_count", huawei_merged_pr_count);
// 非华为合并PR 数量
result.put("other_merged_pr_count", other_merged_pr_count);
// 华为贡献代码 量
result.put("huawei_addcode_count", huawei_addcode_count);
// 非华为贡献代码 量
result.put("other_addcode_count", other_addcode_count);
// PR撬动比 非华为/华为
result.put("pr_leverage_ratio", pr_leverage_ratio);
// 代码撬动比 非华为/华为
result.put("addcode_leverage_ratio", addcode_leverage_ratio);
// PR撬动比 非华为/华为 - 上一期
result.put("previous_pr_leverage_ratio", previous_pr_leverage_ratio);
// 代码撬动比 非华为/华为 - 上一期
result.put("previous_addcode_leverage_ratio", previous_addcode_leverage_ratio);
// pr撬动比 变化 (当前-上一期)/上一期
result.put("pr_ratio", pr_ratio);
// 代码撬动比 变化 (当前-上一期)/上一期
result.put("addcode_ratio", addcode_ratio);
return result;

{
  "properties" : { },
  "id" : "7899972ec94a4dcc8b7536d702ca2eb1",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "SIG撬动比",
  "createTime" : null,
  "updateTime" : 1766827826563,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/sig/leverage-ratio",
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
  "requestBody" : "{\r\n    \"start\":1761926400000,\r\n    \"end\":1766764800000,\r\n    \"community\":\"mindspore\",\r\n    \"source\": \"\",\r\n    \"sigList\":[]\r\n}",
  "headers" : [ {
    "name" : "Content-Type",
    "value" : "application/json; charset=UTF-8",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_addcode_perc\": 0.3344,\n        \"list\": [{\n            \"sig_name\": \"MindSpore Science\",\n            \"addcode_sum\": 103884,\n            \"addcode\": 61825,\n            \"addcode_perc\": 0.5951\n        }, {\n            \"sig_name\": \"LLM Inference Serving\",\n            \"addcode_sum\": 67056,\n            \"addcode\": 0,\n            \"addcode_perc\": 0.0000\n        }, {\n            \"sig_name\": \"MindSpore Quantum\",\n            \"addcode_sum\": 35817,\n            \"addcode\": 35626,\n            \"addcode_perc\": 0.9947\n        }, {\n            \"sig_name\": \"MindSpore Transformers\",\n            \"addcode_sum\": 109775,\n            \"addcode\": 8601,\n            \"addcode_perc\": 0.0784\n        }, {\n            \"sig_name\": \"Security & Trusted AI\",\n            \"addcode_sum\": 645,\n            \"addcode\": 0,\n            \"addcode_perc\": 0.0000\n        }]\n    },\n    \"timestamp\": 1766827823120,\n    \"executeTime\": 5214\n}",
  "description" : null,
  "requestBodyDefinition" : {
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
      "name" : "start",
      "value" : "1577836800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1763433027585",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "mindspore",
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
      "name" : "source",
      "value" : "github",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "source 格式非法",
      "expression" : "^[a-zA-Z0-9_]*$",
      "children" : [ ]
    }, {
      "name" : "sigList",
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
        "name" : "total_addcode_perc",
        "value" : "0.2985",
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
        "name" : "list",
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
            "name" : "sig_name",
            "value" : "MindSpore Science",
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
            "name" : "addcode_sum",
            "value" : "285890",
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
            "name" : "addcode",
            "value" : "126840",
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
            "name" : "addcode_perc",
            "value" : "0.4437",
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
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1766827782620",
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
      "value" : "17827",
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
import magic;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 服务平台
var source = body.source;
// sig
var sigList = body.sigList;
if (sigList == "" or sigList == null or sigList.size() == 0){
  sigList = ['MindSpore Quantum','MindSpore Transformers','MindSpore Science','LLM Inference Serving','Security & Trusted AI']
}
var internalList = ['内部','外部']
var internal = '外部'
// 是否私仓
var private = body.private;
// 用户
var user_login = body.user_login;
// 社区
var community = body.community.toLowerCase();
// 贡献表
var contributeTable = "dws_" + community + "_contribute_sig_daily";
var sigTable = "fact_" + community + "_sig_user";
var sql = """
  WITH dim_table AS (
      select 
          distinct sig_name
      from ${sigTable}
      <where>
        is_removed is null and is_hide is null and sig_name is not null
        <if test="source != null and source != ''">
              and platform = #{source}
        </if>
        <if test="sigList != null and sigList.size() > 0">
            and sig_name in
            <foreach collection="sigList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
      </where>
  ),
  gender_enum AS (
      SELECT unnest(ARRAY[
        <foreach collection="internalList" item="item" separator=",">
            #{item}
        </foreach>
    ]) AS internal
  ),
  combined_enum AS (
      SELECT 
          d.sig_name,
          g.internal
      FROM dim_table d
      CROSS JOIN gender_enum g
  ),
  filter_data AS (
      SELECT
          sig_name,
          internal,
          sum(pr_incre) as pr_total,
          sum(open_pr_incre) as open_pr_total,
          sum(merged_pr_incre) as merged_pr_total,
          sum(issue_incre) as issue_total,
          sum(open_issue_incre) as open_issue_total,
          sum(progressing_issue_incre) as progressing_issue_total,
          sum(comment_incre) as comment_total,
          sum(addcode_incre) as addcode_total,
          sum(pr_first_reply_time) as pr_first_reply_time,
          sum(pr_closed_time) as pr_closed_time,
          sum(issue_first_reply_time) as issue_first_reply_time,
          sum(issue_closed_time) as issue_closed_time
      FROM ${contributeTable}
      <where>
          date::DATE BETWEEN #{start} AND #{end}
          <if test="source != null and source != ''">
              and source = #{source}
          </if>
          <if test="private != null and private != ''">
              and private = #{private}
          </if>
          <if test="sigList != null and sigList.size() > 0">
              and sig_name in
              <foreach collection="sigList" item="item" open="(" separator="," close=")">
                  #{item}
              </foreach>
          </if>
      </where>
      GROUP BY sig_name, internal
  ),
  total_filter_data AS (
      select  
      sig_name, COALESCE(sum(pr_total), 0) as pr_sum, COALESCE(sum(merged_pr_total), 0) as merged_pr_sum, COALESCE(sum(issue_total), 0) as issue_sum, 
      COALESCE(sum(comment_total), 0) as comment_sum, COALESCE(sum(addcode_total), 0) as addcode_sum
      from filter_data
      group by sig_name
  ),
  joined_data AS (
      SELECT 
          dt.sig_name, dt.internal,
          COALESCE(fd.pr_total, 0) AS pr_total,
          COALESCE(fd.merged_pr_total, 0) AS merged_pr_total,
          (COALESCE(fd.pr_total, 0)  - COALESCE(fd.open_pr_total, 0)) AS closed_pr_total,
          COALESCE(fd.issue_total, 0) AS issue_total,
          (COALESCE(fd.issue_total, 0) - COALESCE(fd.open_issue_total, 0) - COALESCE(fd.progressing_issue_total, 0)) AS closed_issue_total,
          COALESCE(fd.comment_total, 0) AS comment_total,
          COALESCE(fd.addcode_total, 0) AS addcode_total,
          COALESCE(fd.pr_first_reply_time, 0) AS pr_first_reply_time,
          COALESCE(fd.pr_closed_time, 0) AS pr_closed_time,
          COALESCE(fd.issue_first_reply_time, 0) AS issue_first_reply_time,
          COALESCE(fd.issue_closed_time, 0) AS issue_closed_time,
          tfd.pr_sum, tfd.merged_pr_sum, tfd.issue_sum, tfd.comment_sum, tfd.addcode_sum
      FROM combined_enum dt
      LEFT JOIN filter_data fd ON dt.sig_name = fd.sig_name and dt.internal = fd.internal
      LEFT JOIN total_filter_data tfd ON dt.sig_name = tfd.sig_name
  )
  SELECT 
      sig_name, addcode_sum, addcode_total as addcode,
      ROUND(
          CASE
              WHEN addcode_sum = 0 THEN 0
              ELSE addcode_total::NUMERIC / addcode_sum
          END::NUMERIC , 4
      ) as addcode_perc
  FROM 
      joined_data
  where internal = #{internal}
""";
var query_data = db.select(sql);
var addcode_count_sum = 0l;
var addcode_count = 0l;
if (query_data.size() > 0){
   query_data.forEach(item -> {  
      addcode_count_sum += item.get("addcode_sum");
      addcode_count += item.get("addcode");
    }) 
}
BigDecimal addcode_sum_float = addcode_count_sum;
BigDecimal addcode_count_float = BigDecimal.valueOf(addcode_count);
var total_addcode_perc = 1;
if (addcode_count_sum > 0){
// 计算比率并保留4位小数，使用四舍五入
  total_addcode_perc = addcode_count_float.divide(addcode_sum_float, 4, RoundingMode.HALF_UP).doubleValue();
}
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_addcode_perc", total_addcode_perc);
return result

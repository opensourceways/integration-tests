{
  "properties" : { },
  "id" : "9baad7c69b5248588d6e23e74485a1ad",
  "script" : null,
  "groupId" : "2e2220ca1c424052ba4fa20a1e7370f8",
  "name" : "TOPN用户留存率",
  "createTime" : null,
  "updateTime" : 1774577823065,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/user_retention",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "vllm",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "date",
    "value" : "1779875200000",
    "description" : "查询范围结束时间,格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "end 必须为合法的毫秒级时间戳",
    "expression" : null,
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
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"community 参数格式非法\",\n    \"data\": null,\n    \"timestamp\": 1774523310104,\n    \"executeTime\": 0\n}",
  "description" : "查询指定社区的TOP开发者留存率。",
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
          "name" : "stats_date",
          "value" : "2026-01-01",
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
          "name" : "user_count",
          "value" : "191",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1773218851280",
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
      "value" : "33",
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
WITH
user_count_merged AS (
    SELECT user_login, SUM(merged_pr_incre) AS count
    FROM dws_${community}_contribute_repo_user_daily dcc
    WHERE private = 'false'
        <if test="date != null and date != ''">
            AND date >= to_timestamp(#{date}/1000) - INTERVAL '1 year'
            AND date <= to_timestamp(#{date}/1000)
        </if>
       AND NOT EXISTS (
          SELECT 1 FROM fact_community_robot_user fcru
          WHERE fcru.user_login = dcc.user_login
       )
    GROUP BY user_login
),
total_merged AS (
    SELECT SUM(count) AS s FROM user_count_merged
),
merged_result AS (
    SELECT user_login, count, running_total
    FROM (
        SELECT user_login, count,
               SUM(count) OVER (ORDER BY count DESC) AS running_total
        FROM user_count_merged
    ) t, total_merged
    WHERE running_total - count < 0.3 * total_merged.s
),
user_count_comment AS (
    SELECT user_login, SUM(comment_incre) AS count
    FROM dws_${community}_contribute_repo_user_daily dcc
    WHERE private = 'false'
        <if test="date != null and date != ''">
            AND date >= to_timestamp(#{date}/1000) - INTERVAL '1 year'
            AND date <= to_timestamp(#{date}/1000)
        </if>
       AND NOT EXISTS (
          SELECT 1 FROM fact_community_robot_user fcru
          WHERE fcru.user_login = dcc.user_login
       )
    GROUP BY user_login
),
total_comment AS (
    SELECT SUM(count) AS s FROM user_count_comment
),
comment_result AS (
    SELECT user_login, count, running_total
    FROM (
        SELECT user_login, count,
               SUM(count) OVER (ORDER BY count DESC) AS running_total
        FROM user_count_comment
    ) t, total_comment
    WHERE running_total - count < 0.3 * total_comment.s
),
history_user AS (
    SELECT user_login FROM merged_result
    UNION
    SELECT user_login FROM comment_result
),
cur_user AS (
    SELECT distinct user_login
    FROM dws_${community}_contribute_repo_user_daily dcc
    WHERE private = 'false'
        <if test="date != null and date != ''">
            AND date >= to_timestamp(#{date}/1000) - INTERVAL '1 months'
            AND date <= to_timestamp(#{date}/1000)
        </if>
       AND NOT EXISTS (
          SELECT 1 FROM fact_community_robot_user fcru
          WHERE fcru.user_login = dcc.user_login
       )
)
SELECT
    COUNT(*) FILTER (WHERE c.user_login IS NOT NULL) * 1.0 / COUNT(*) AS ratio
FROM history_user h
LEFT JOIN cur_user c ON h.user_login = c.user_login;
"""
return db.select(sql)[0]

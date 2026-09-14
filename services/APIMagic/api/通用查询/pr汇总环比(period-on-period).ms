{
  "properties" : { },
  "id" : "copy1765353139297d56695",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "pr汇总环比(period-on-period)",
  "createTime" : null,
  "updateTime" : 1765768119111,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/prs/agg/pop",
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
  "requestBody" : "{\r\n    \"start\":1764554331870,\r\n    \"group_dim\": \"\",\r\n    \"community\":\"mindall\",\r\n    \"namespace\":\"\",\r\n    \"repo\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"week_closed_ratio\": 0.8696,\n        \"week_avg_first_reply_time\": 1.59,\n        \"week_avg_closed_time\": 2.85,\n        \"month_closed_ratio\": 0.8846,\n        \"month_avg_first_reply_time\": 2.49,\n        \"month_closed_time\": 4.44,\n        \"last_week_closed_ratio\": 0.8769,\n        \"last_week_avg_first_reply_time\": 2.41,\n        \"last_week_avg_closed_time\": 4.48,\n        \"last_month_closed_ratio\": 0.9242,\n        \"last_month_avg_first_reply_time\": 3.71,\n        \"last_month_closed_time\": 7.07,\n        \"closed_ratio_week_ratio\": -0.83,\n        \"avg_first_reply_time_week_ratio\": 34.02,\n        \"avg_closed_time_week_ratio\": 36.38,\n        \"closed_ratio_month_ratio\": -4.28,\n        \"avg_first_reply_time_month_ratio\": 32.88,\n        \"avg_closed_time_month_ratio\": 37.20\n    }],\n    \"timestamp\": 1765353306686,\n    \"executeTime\": 40\n}",
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
      "value" : "1730419200000",
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
      "value" : "1764215445119",
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
      "name" : "group_dim",
      "value" : "sub_community",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "group_dim 只能为 sub_community 或 repo",
      "expression" : "^(sub_community|repo)?$",
      "children" : [ ]
    }, {
      "name" : "pr_type",
      "value" : "缺陷",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "pr_type 格式非法",
      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5]*$",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "mindall",
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
      "name" : "owner",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "owner 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-]*$",
      "children" : [ ]
    }, {
      "name" : "repo",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-]*$",
      "children" : [ ]
    }, {
      "name" : "asc",
      "value" : "count,open_count",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "asc 字段非法",
      "expression" : "^(count|open_count|closed_count|merged_count|closed_ratio|avg_first_reply_time|avg_closed_time)?$",
      "children" : [ ]
    }, {
      "name" : "desc",
      "value" : "merged_count",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "desc 字段非法",
      "expression" : "^(count|open_count|closed_count|merged_count|closed_ratio|avg_first_reply_time|avg_closed_time)?$",
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
          "name" : "week_closed_ratio",
          "value" : "0.8696",
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
          "name" : "week_avg_first_reply_time",
          "value" : "1.59",
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
          "name" : "week_avg_closed_time",
          "value" : "2.85",
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
          "name" : "month_closed_ratio",
          "value" : "0.8846",
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
          "name" : "month_avg_first_reply_time",
          "value" : "2.49",
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
          "name" : "month_closed_time",
          "value" : "4.44",
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
          "name" : "last_week_closed_ratio",
          "value" : "0.8769",
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
          "name" : "last_week_avg_first_reply_time",
          "value" : "2.41",
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
          "name" : "last_week_avg_closed_time",
          "value" : "4.48",
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
          "name" : "last_month_closed_ratio",
          "value" : "0.9242",
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
          "name" : "last_month_avg_first_reply_time",
          "value" : "3.71",
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
          "name" : "last_month_closed_time",
          "value" : "7.07",
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
          "name" : "closed_ratio_week_ratio",
          "value" : "-0.83",
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
          "name" : "avg_first_reply_time_week_ratio",
          "value" : "34.02",
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
          "name" : "avg_closed_time_week_ratio",
          "value" : "36.38",
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
          "name" : "closed_ratio_month_ratio",
          "value" : "-4.28",
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
          "name" : "avg_first_reply_time_month_ratio",
          "value" : "32.88",
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
          "name" : "avg_closed_time_month_ratio",
          "value" : "37.20",
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
    }, {
      "name" : "timestamp",
      "value" : "1765353306686",
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
      "value" : "40",
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
import '@/util/timestamp2Date' as timestamp2Date;
import magic;
import java.util.Arrays;
import java.util.Collections;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
Date today = null;
if (body.start != null and body.start != '') {
    today = timestamp2Date(body.start);
}
// 最近7天
LocalDate last7Start = today.minusDays(6);
LocalDate last7End = today;
// 最近30天
LocalDate last30Start = today.minusDays(29);
LocalDate last30End = today;
// 上一个7天周期
LocalDate prev7Start = last7Start.minusDays(7);
LocalDate prev7End = last7Start.minusDays(1);
// 上一个30天周期
LocalDate prev30Start = last30Start.minusDays(30);
LocalDate prev30End = last30Start.minusDays(1);
// 最早日期
LocalDate earliest = prev30Start;
// 最近日期
LocalDate latest = today;
// 聚合维度
var group_dim = body.group_dim;
// 社区
var community = body.community;
// 组织
var namespace = body.namespace;
// 服务平台
var source = body.source;
// 内外部
var internalList = body.internalList;
// 是否私仓
var private = body.private;
// PR类型
var pr_type = body.pr_type;
// 仓库
var repo_path = body.repo_path;
// 责任人
var assginee = body.assginee;
var contributeTable = "dws_" + community + "_pr_contribute_repo_daily";
var sql = """
WITH contribute_data AS (
    SELECT
        date, COALESCE(sum(pr_incre), 0) as pr_incre, 
        COALESCE(sum(open_pr_incre), 0) as open_pr_incre, 
        COALESCE(sum(merged_pr_incre), 0) as merged_pr_incre, 
        COALESCE(sum(closed_pr_incre), 0) as closed_pr_incre,
        COALESCE(sum(first_reply_time), 0) as first_reply_time,
        COALESCE(sum(closed_time), 0) as closed_time
    FROM ${contributeTable}
    <where>
        date BETWEEN #{earliest} and #{latest}
        <if test="namespace != null and namespace != ''">
            and namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="repo_path != null and repo_path != ''">
            and repo_path LIKE CONCAT('%', #{repo_path}, '%')
        </if>
        <if test="source != null and source != ''">
            and source = #{source}
        </if>
        <if test="private != null and private != ''">
            and private = #{private}
        </if>
        <if test="pr_type != null and pr_type != ''">
            and super_issue_type = #{pr_type}
        </if>
        <if test="internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
    group by date
),
week_data AS (
    SELECT 
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE (sum(pr_incre) - sum(open_pr_incre))::NUMERIC / sum(pr_incre)
            END::NUMERIC , 4
        ) as closed_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(first_reply_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_first_reply_time,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(closed_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_closed_time
    FROM contribute_data
    WHERE date BETWEEN #{last7Start} AND #{last7End}
),
last_week_data AS (
    SELECT 
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE (sum(pr_incre) - sum(open_pr_incre))::NUMERIC / sum(pr_incre)
            END::NUMERIC , 4
        ) as closed_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(first_reply_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_first_reply_time,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(closed_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_closed_time
    FROM contribute_data
    WHERE date BETWEEN #{prev7Start} AND #{prev7End}
),
month_data AS (
    SELECT 
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE (sum(pr_incre) - sum(open_pr_incre))::NUMERIC / sum(pr_incre)
            END::NUMERIC , 4
        ) as closed_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(first_reply_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_first_reply_time,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(closed_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_closed_time
    FROM contribute_data
    WHERE date BETWEEN #{last30Start} AND #{last30End}
),
last_month_data AS (
    SELECT 
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE (sum(pr_incre) - sum(open_pr_incre))::NUMERIC / sum(pr_incre)
            END::NUMERIC , 4
        ) as closed_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(first_reply_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_first_reply_time,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(closed_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_closed_time
    FROM contribute_data
    WHERE date BETWEEN #{prev30Start} AND #{prev30End}
)
SELECT 
    COALESCE(w.closed_ratio, 0) as week_closed_ratio,
    COALESCE(w.avg_first_reply_time, 0) week_avg_first_reply_time,
    COALESCE(w.avg_closed_time, 0) week_avg_closed_time,
    COALESCE(m.closed_ratio, 0) month_closed_ratio,
    COALESCE(m.avg_first_reply_time, 0) month_avg_first_reply_time,
    COALESCE(m.avg_closed_time, 0) month_closed_time,
    COALESCE(lw.closed_ratio, 0) last_week_closed_ratio,
    COALESCE(lw.avg_first_reply_time, 0) last_week_avg_first_reply_time,
    COALESCE(lw.avg_closed_time, 0) last_week_avg_closed_time,
    COALESCE(lm.closed_ratio, 0) last_month_closed_ratio,
    COALESCE(lm.avg_first_reply_time, 0) last_month_avg_first_reply_time,
    COALESCE(lm.avg_closed_time, 0) last_month_closed_time,
    CASE 
        WHEN lw.closed_ratio = 0 THEN NULL
        ELSE ROUND((COALESCE(w.closed_ratio, 0) - lw.closed_ratio)::numeric / lw.closed_ratio * 100, 2)
    END AS closed_ratio_week_ratio,
    CASE 
        WHEN lw.avg_first_reply_time = 0 THEN NULL
        ELSE ROUND((lw.avg_first_reply_time - COALESCE(w.avg_first_reply_time, 0))::numeric / lw.avg_first_reply_time * 100, 2)
    END AS avg_first_reply_time_week_ratio,
    CASE 
        WHEN lw.avg_closed_time = 0 THEN NULL
        ELSE ROUND((lw.avg_closed_time - COALESCE(w.avg_closed_time, 0))::numeric / lw.avg_closed_time * 100, 2)
    END AS avg_closed_time_week_ratio,
    CASE 
        WHEN lm.closed_ratio = 0 THEN NULL
        ELSE ROUND((COALESCE(m.closed_ratio, 0) - lm.closed_ratio)::numeric / lm.closed_ratio * 100, 2)
    END AS closed_ratio_month_ratio,
    CASE 
        WHEN lm.avg_first_reply_time = 0 THEN NULL
        ELSE ROUND((lm.avg_first_reply_time - COALESCE(m.avg_first_reply_time, 0))::numeric / lm.avg_first_reply_time * 100, 2)
    END AS avg_first_reply_time_month_ratio,
    CASE 
        WHEN lm.avg_closed_time = 0 THEN NULL
        ELSE ROUND((lm.avg_closed_time - COALESCE(m.avg_closed_time, 0))::numeric / lm.avg_closed_time * 100, 2)
    END AS avg_closed_time_month_ratio
FROM week_data w, last_week_data lw, month_data m, last_month_data lm;
""";
var query_data = db.select(sql);
query_data.forEach(item -> {
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
return query_data

{
  "properties" : { },
  "id" : "copy1741851033357d22142",
  "script" : null,
  "groupId" : "905e0bee16764ec9be1e96b78cae9466",
  "name" : "用户月环比",
  "createTime" : null,
  "updateTime" : 1773818390258,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/ratio/month",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1559327200000,\r\n    \"end\":1741746039990,\r\n    \"orgList\":[\"openUBMC\"],\r\n    \"internalList\":[\"内部\",\"外部\"],\r\n    \"community\":\"openUBMC\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"d0\": 13.4286,\n        \"d1\": 13.4286,\n        \"d2\": 16.7500\n    }],\n    \"timestamp\": 1745306223222,\n    \"executeTime\": 11\n}",
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
      "value" : "1559327200000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : null,
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1741746039990",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : null,
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
      "children" : [ {
        "name" : "",
        "value" : "",
        "description" : "",
        "required" : false,
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "pattern",
        "error" : null,
        "expression" : "^[a-zA-Z0-9_]{1,32}$",
        "children" : [ ]
      } ]
    }, {
      "name" : "internalList",
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
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "pattern",
        "error" : null,
        "expression" : "^(内部|外部)$",
        "children" : [ ]
      } ]
    }, {
      "name" : "community",
      "value" : "openUBMC",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^[a-zA-Z]{1,32}$",
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
          "name" : "level_type",
          "value" : "D2",
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
          "name" : "percentage",
          "value" : "-25.11",
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
      "value" : "1741853022657",
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
      "value" : "69",
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
Date end = timestamp2Date(body.end);
// 服务平台
var source = body.source;
var orgList = body.orgList;
var internalList = body.internalList;
// 是否私仓
var private = body.private;
// 社区
var community = body.community.toLowerCase();
// 仓库路径（可选，不为空时按仓库维度统计）
var repo_path = body.repo_path;
// 社区用户信息（有 repo_path 时使用仓库维度表）
var userTable = (repo_path != null && repo_path != '') ? "dwm_"+community+"_contribute_user_repo" : "dwm_"+community+"_contribute_user";
var sql = """
WITH date_params AS (
    SELECT
        (#{end} - INTERVAL '30 DAY')::DATE AS current_start_month,
        #{end}  AS current_end_month,
        (#{end}  - INTERVAL '60 DAY')::DATE AS previous_start_month,
        (#{end}  - INTERVAL '31 DAY')::DATE AS previous_end_month
),
filter_date AS (
    select  * from ${userTable}
    <where>
        <if test="source != null and source != ''">
            and source = #{source}
        </if>
        <if test="private != null and private != ''">
            and private = #{private}
        </if>
        <if test="orgList != null and orgList.size() > 0">
            and namespace in
            <foreach collection="orgList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="repo_path != null and repo_path != ''">
            and repo_path = #{repo_path}
        </if>
    </where>
),
current_period AS (
    SELECT
        'current' AS period,
        SUM(CASE WHEN d0_time BETWEEN (SELECT current_start_month FROM date_params) AND (SELECT current_end_month FROM date_params) THEN 1 ELSE 0 END) AS d0_count,
        SUM(CASE WHEN d1_time BETWEEN (SELECT current_start_month FROM date_params) AND (SELECT current_end_month FROM date_params) THEN 1 ELSE 0 END) AS d1_count,
        SUM(CASE WHEN d2_time BETWEEN (SELECT current_start_month FROM date_params) AND (SELECT current_end_month FROM date_params) THEN 1 ELSE 0 END) AS d2_count
    FROM filter_date
),
previous_period AS (
    SELECT
        'previous' AS period,
        SUM(CASE WHEN d0_time BETWEEN (SELECT previous_start_month FROM date_params) AND (SELECT previous_end_month FROM date_params) THEN 1 ELSE 0 END) AS d0_count,
        SUM(CASE WHEN d1_time BETWEEN (SELECT previous_start_month FROM date_params) AND (SELECT previous_end_month FROM date_params) THEN 1 ELSE 0 END) AS d1_count,
        SUM(CASE WHEN d2_time BETWEEN (SELECT previous_start_month FROM date_params) AND (SELECT previous_end_month FROM date_params) THEN 1 ELSE 0 END) AS d2_count
    FROM filter_date
)
SELECT
    -- Level 0 环比计算
    ROUND(
        CASE
            WHEN c.d0_count is null and p.d0_count is null then 0
            WHEN c.d0_count = 0 AND p.d0_count = 0 THEN 0
            WHEN c.d0_count > 0 AND p.d0_count = 0 THEN 1
            ELSE (c.d0_count - p.d0_count)::NUMERIC  / NULLIF(p.d0_count, 0)
        END::NUMERIC , 4
    ) AS D0,
    -- Level 1 环比计算
    ROUND(
        CASE
            WHEN c.d1_count is null and p.d1_count is null then 0
            WHEN c.d1_count = 0 AND p.d1_count = 0 THEN 0
            WHEN c.d1_count > 0 AND p.d1_count = 0 THEN 1
            ELSE (c.d1_count - p.d1_count)::NUMERIC  / NULLIF(p.d1_count, 0)
        END::NUMERIC , 4
    ) AS D1,
    -- Level 2 环比计算
    ROUND(
        CASE
            WHEN c.d2_count is null and p.d2_count is null then 0
            WHEN c.d2_count = 0 AND p.d2_count = 0 THEN 0
            WHEN c.d2_count > 0 AND p.d2_count = 0 THEN 1
            ELSE (c.d2_count - p.d2_count)::NUMERIC  / NULLIF(p.d2_count, 0)
        END::NUMERIC , 4
    ) AS D2
FROM current_period c, previous_period p;
""";
return db.select(sql)

{
  "properties" : { },
  "id" : "888040917507437b84d4bc3a8d2630ba",
  "script" : null,
  "groupId" : "905e0bee16764ec9be1e96b78cae9466",
  "name" : "海外贡献者统计",
  "createTime" : null,
  "updateTime" : 1776757450244,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "oversea/contributor/stats",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : null,
    "description" : "社区名称，可选值：openeuler",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openeuler",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(openeuler)$",
    "children" : null
  }, {
    "name" : "startTime",
    "value" : "",
    "description" : "起始时间，毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "endTime",
    "value" : "",
    "description" : "截止时间，毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1776757378095,\n    \"executeTime\": 7\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
WITH all_users AS (
    SELECT DISTINCT user_name FROM fact_${community}_oversea_user
    WHERE 1 = 1
        <if test="startTime != null and startTime != ''">
            AND created_at >= to_timestamp(#{startTime} / 1000)
        </if>
        <if test="endTime != null and endTime != ''">
            AND created_at <= to_timestamp(#{endTime} / 1000)
        </if>
    UNION
    SELECT DISTINCT uuid FROM dws_${community}mirror_swf
    WHERE 1 = 1
        <if test="startTime != null and startTime != ''">
            AND created_at >= to_timestamp(#{startTime} / 1000)
        </if>
        <if test="endTime != null and endTime != ''">
            AND created_at <= to_timestamp(#{endTime} / 1000)
        </if>
    UNION
    SELECT DISTINCT user_login FROM dws_${community}mirror_contribute
    WHERE 1 = 1
        <if test="startTime != null and startTime != ''">
            AND created_at >= to_timestamp(#{startTime} / 1000)
        </if>
        <if test="endTime != null and endTime != ''">
            AND created_at <= to_timestamp(#{endTime} / 1000)
        </if>
    UNION
    SELECT DISTINCT user_login FROM dwm_openeuler_contribute_user
    WHERE user_login ILIKE 'e%' OR user_login ILIKE 'u%'
        <if test="startTime != null and startTime != ''">
            AND d0_time >= to_timestamp(#{startTime} / 1000)
        </if>
        <if test="endTime != null and endTime != ''">
            AND d0_time <= to_timestamp(#{endTime} / 1000)
        </if>
),
d1_users AS (
    SELECT DISTINCT user_login FROM dws_${community}mirror_contribute
    <where>
        <if test="startTime != null and startTime != ''">
            AND created_at >= to_timestamp(#{startTime} / 1000)
        </if>
        <if test="endTime != null and endTime != ''">
            AND created_at <= to_timestamp(#{endTime} / 1000)
        </if>
    </where>
    UNION
    SELECT DISTINCT user_name FROM fact_${community}_oversea_user
    WHERE user_type = 'd1'
        <if test="startTime != null and startTime != ''">
            AND created_at >= to_timestamp(#{startTime} / 1000)
        </if>
        <if test="endTime != null and endTime != ''">
            AND created_at <= to_timestamp(#{endTime})
        </if>
    UNION
    SELECT DISTINCT user_login FROM dwm_${community}_contribute_user
    WHERE d1_time IS NOT NULL AND (user_login ILIKE 'e%' OR user_login ILIKE 'c%')
        <if test="startTime != null and startTime != ''">
            AND d1_time >= to_timestamp(#{startTime} / 1000)
        </if>
        <if test="endTime != null and endTime != ''">
            AND d1_time <= to_timestamp(#{endTime} / 1000)
        </if>
),
d2_users AS (
    SELECT DISTINCT user_login FROM dws_${community}mirror_contribute
    WHERE contrib_type = 'pr'
        <if test="startTime != null and startTime != ''">
            AND created_at >= to_timestamp(#{startTime} / 1000)
        </if>
        <if test="endTime != null and endTime != ''">
            AND created_at <= to_timestamp(#{endTime} / 1000)
        </if>
)
SELECT 'D0' as level_type, (SELECT COUNT(*) FROM all_users) as total
UNION ALL
SELECT 'D1' as level_type, (SELECT COUNT(*) FROM d1_users) as total
UNION ALL
SELECT 'D2' as level_type, (SELECT COUNT(*) FROM d2_users) as total
"""

return db.select(sqlstr)
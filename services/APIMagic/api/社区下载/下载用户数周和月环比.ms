{
  "properties" : { },
  "id" : "copy1747797844817d82049",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "下载用户数周和月环比",
  "createTime" : null,
  "updateTime" : 1773828151103,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/ratio",
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
  "requestBody" : "{\r\n  \"metrics\": [\r\n    \"download_count\",\r\n    \"download_ip\"\r\n  ],\r\n  \"community\": \"mindspore\",\r\n  \"variables\": {\r\n    \"oversea\": [\r\n      \"0\",\r\n      \"1\"\r\n    ]\r\n  },\r\n  \"operation\": \"totalCount\",\r\n  \"start\": \"2025-06-03\",\r\n  \"end\": \"2025-07-03\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"down_week_rate\": {\n            \"week_start_date\": \"2025-06-30\",\n            \"weekly_downloads\": 14562,\n            \"prev_week_downloads\": 42570,\n            \"wow_growth_rate\": -65.79\n        },\n        \"download_ip\": 8738,\n        \"down_month_rate\": {\n            \"month_start_date\": \"2025-07-01\",\n            \"monthly_downloads\": 10177,\n            \"prev_month_downloads\": 151108,\n            \"mom_growth_rate\": -93.27\n        },\n        \"ip_month_rate\": {\n            \"month_start_date\": \"2025-07-01\",\n            \"monthly_downloads\": 559,\n            \"prev_month_downloads\": 8179,\n            \"mom_growth_rate\": -93.17\n        },\n        \"ip_week_rate\": {\n            \"week_start_date\": \"2025-06-30\",\n            \"weekly_downloads\": 691,\n            \"prev_week_downloads\": 1978,\n            \"wow_growth_rate\": -65.07\n        },\n        \"download_count\": 161285\n    },\n    \"timestamp\": 1773828149045,\n    \"executeTime\": 30\n}",
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
      "name" : "community",
      "value" : "",
      "description" : "社区名称",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "",
      "description" : "开始日期",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "start 格式应为 yyyy-MM-dd",
      "expression" : "^\\d{4}-\\d{2}-\\d{2}$",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "结束日期",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "end 格式应为 yyyy-MM-dd",
      "expression" : "^\\d{4}-\\d{2}-\\d{2}$",
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "",
      "description" : "下载源",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "repo_type",
      "value" : "",
      "description" : "仓库类型 code/model，空=全部",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_type 只能为 code 或 model",
      "expression" : "^(code|model)?$",
      "children" : [ ]
    }, {
      "name" : "variables",
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
        "name" : "oversea",
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
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var source = body.source;
var community = body.community;
var oversea = body.variables.oversea;
var start =date_format(body.start::date('yyyy-MM-dd'),'yyyy-MM-dd')
var end = date_format(body.end::date('yyyy-MM-dd'),'yyyy-MM-dd')
HashMap map = new HashMap();
map.put("download_count","download_day_increase");
map.put("download_ip","ip_day_increase");
map.put("download_count1","inner_download_day_increase");
map.put("download_count0","outer_download_day_increase");
map.put("download_ip1","inner_ip_day_increase");
map.put("download_ip0","outer_ip_day_increase");
var downfield = "download_day_increase";
var ipfield = "download_day_increase";
if(oversea.size()>1){
    downfield = map.get("download_count");
    ipfield = map.get("download_ip");
}else{
    downfield = map.get("download_count"+oversea.get(0));
    ipfield = map.get("download_ip"+oversea.get(0));
}
var repo_type = body.repo_type;
var downTable = (repo_type != null && repo_type != '') ? ("dws_" + community + "_repo_download_daily") : ("dws_" + community + "_download_daily");
var downCol = (repo_type != null && repo_type != '') ? "day_count" : downfield;
HashMap ma = new HashMap();
ma.put("wow_growth_rate","")
ma.put("mom_growth_rate","")
//下载量和ip下载量
var totalCountSql = """
SELECT COALESCE(SUM(${downCol}),0)  as count
    FROM ${downTable}
    WHERE created_at  BETWEEN #{start}::DATE AND #{end}::DATE 
        <if test="repo_type != null and repo_type != ''">
            AND repo_type = #{repo_type}
        </if>
        <if test="source != null and source.size() > 0">
            and source in
            <foreach collection="source" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
""";
var totalCount = db.select(totalCountSql);
var ipCountSql = """
SELECT COALESCE(SUM(${ipfield}),0) as count
    FROM dws_${community}_download_daily
    WHERE created_at  BETWEEN #{start}::DATE AND #{end}::DATE 
        <if test="source != null and source.size() > 0">
            and source in
            <foreach collection="source" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
""";
var ipCount = db.select(ipCountSql);
HashMap res = new HashMap();
res.put("download_count",totalCount.count);
res.put("download_ip",ipCount.count);
//下载周环比
var downWeekRateSql = """
WITH date_range AS (
    SELECT generate_series::date AS day
    FROM generate_series(#{start}::date, #{end}::date, '1 day')
),
daily_data AS (
    SELECT
        created_at::date AS created_date,
        ${downCol}
    FROM ${downTable}
     WHERE created_at BETWEEN #{start}::date AND #{end}::date
                <if test="repo_type != null and repo_type != ''">
            AND repo_type = #{repo_type}
        </if>
        <if test="source != null and source.size() > 0">
            and source in
            <foreach collection="source" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
),
grouped_daily AS (
    SELECT
        dr.day AS stat_period,
        COALESCE(SUM(d.${downCol}), 0) AS daily_value
    FROM date_range dr
    LEFT JOIN daily_data d ON d.created_date = dr.day
    GROUP BY dr.day
),
weekly_data AS (
    SELECT
        DATE_TRUNC('week', stat_period)::date AS week_start,
        SUM(daily_value) AS weekly_downloads
    FROM grouped_daily
    GROUP BY DATE_TRUNC('week', stat_period)
),
with_lag_weekly AS (
    SELECT
        week_start,
        weekly_downloads,
        LAG(weekly_downloads, 1) OVER (ORDER BY week_start) AS prev_week_downloads
    FROM weekly_data
)
SELECT
    week_start AS week_start_date,
    weekly_downloads,
    prev_week_downloads,
    ROUND(
        CASE
            WHEN prev_week_downloads = 0 THEN 0.00
            ELSE (weekly_downloads - prev_week_downloads) * 100.0 / prev_week_downloads
        END,
        2
    ) AS wow_growth_rate
FROM with_lag_weekly
ORDER BY week_start desc limit 2;
""";
var downWeekRate = db.select(downWeekRateSql);
res.put("down_week_rate",downWeekRate.size()>0?downWeekRate.get(0):ma);
//下载月环比
var downMonthRateSql = """
WITH date_range AS (
    SELECT generate_series::date AS day
    FROM generate_series(#{start}::date, #{end}::date, '1 day')
),
daily_data AS (
    SELECT
        created_at::date AS created_date,
        ${downCol}
    FROM ${downTable}
     WHERE created_at BETWEEN #{start}::DATE AND #{end}::DATE 
                <if test="repo_type != null and repo_type != ''">
            AND repo_type = #{repo_type}
        </if>
        <if test="source != null and source.size() > 0">
            and source in
            <foreach collection="source" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
),
grouped_daily AS (
    SELECT
        dr.day AS stat_period,
        COALESCE(SUM(d.${downCol}), 0) AS daily_value
    FROM date_range dr
    LEFT JOIN daily_data d ON d.created_date = dr.day
    GROUP BY dr.day
),
monthly_data AS (
    SELECT
        DATE_TRUNC('month', stat_period)::date AS month_start,
        SUM(daily_value) AS monthly_downloads
    FROM grouped_daily
    GROUP BY DATE_TRUNC('month', stat_period)
),
with_lag_monthly AS (
    SELECT
        month_start,
        monthly_downloads,
        LAG(monthly_downloads, 1) OVER (ORDER BY month_start) AS prev_month_downloads
    FROM monthly_data
)
SELECT
    month_start AS month_start_date,
    monthly_downloads,
    prev_month_downloads,
    ROUND(
        CASE
            WHEN prev_month_downloads = 0 THEN 0.00
            ELSE (monthly_downloads - prev_month_downloads) * 100.0 / prev_month_downloads
        END,
        2
    ) AS mom_growth_rate
FROM with_lag_monthly
ORDER BY month_start desc limit 2;
""";
var downMonthRate = db.select(downMonthRateSql);
res.put("down_month_rate",downMonthRate.size()>0?downMonthRate.get(0):ma);
//ip下载周环比
var ipWeekRateSql = """
WITH date_range AS (
    SELECT generate_series::date AS day
    FROM generate_series(#{start}::date, #{end}::date, '1 day')
),
daily_data AS (
    SELECT
        created_at::date AS created_date,
        ${ipfield}
    FROM dws_${community}_download_daily
     WHERE created_at BETWEEN #{start}::DATE AND #{end}::DATE 
                <if test="source != null and source.size() > 0">
            and source in
            <foreach collection="source" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
),
grouped_daily AS (
    SELECT
        dr.day AS stat_period,
        COALESCE(SUM(d.${ipfield}), 0) AS daily_value
    FROM date_range dr
    LEFT JOIN daily_data d ON d.created_date = dr.day
    GROUP BY dr.day
),
weekly_data AS (
    SELECT
        DATE_TRUNC('week', stat_period)::date AS week_start,
        SUM(daily_value) AS weekly_downloads
    FROM grouped_daily
    GROUP BY DATE_TRUNC('week', stat_period)
),
with_lag_weekly AS (
    SELECT
        week_start,
        weekly_downloads,
        LAG(weekly_downloads, 1) OVER (ORDER BY week_start) AS prev_week_downloads
    FROM weekly_data
)
SELECT
    week_start AS week_start_date,
    weekly_downloads,
    prev_week_downloads,
    ROUND(
        CASE
            WHEN prev_week_downloads = 0 THEN 0.00
            ELSE (weekly_downloads - prev_week_downloads) * 100.0 / prev_week_downloads
        END,
        2
    ) AS wow_growth_rate
FROM with_lag_weekly
ORDER BY week_start desc limit 2;
""";
var downWeekRate = db.select(ipWeekRateSql);
res.put("ip_week_rate",downWeekRate.size()>0?downWeekRate.get(0):ma);
//ip下载月环比
var ipMonthRateSql = """
WITH date_range AS (
    SELECT generate_series::date AS day
    FROM generate_series(#{start}::date, #{end}::date, '1 day')
),
daily_data AS (
    SELECT
        created_at::date AS created_date,
        ${ipfield}
    FROM dws_${community}_download_daily
     WHERE created_at BETWEEN #{start}::DATE AND #{end}::DATE 
                <if test="source != null and source.size() > 0">
            and source in
            <foreach collection="source" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
),
grouped_daily AS (
    SELECT
        dr.day AS stat_period,
        COALESCE(SUM(d.${ipfield}), 0) AS daily_value
    FROM date_range dr
    LEFT JOIN daily_data d ON d.created_date = dr.day
    GROUP BY dr.day
),
monthly_data AS (
    SELECT
        DATE_TRUNC('month', stat_period)::date AS month_start,
        SUM(daily_value) AS monthly_downloads
    FROM grouped_daily
    GROUP BY DATE_TRUNC('month', stat_period)
),
with_lag_monthly AS (
    SELECT
        month_start,
        monthly_downloads,
        LAG(monthly_downloads, 1) OVER (ORDER BY month_start) AS prev_month_downloads
    FROM monthly_data
)
SELECT
    month_start AS month_start_date,
    monthly_downloads,
    prev_month_downloads,
    ROUND(
        CASE
            WHEN prev_month_downloads = 0 THEN 0.00
            ELSE (monthly_downloads - prev_month_downloads) * 100.0 / prev_month_downloads
        END,
        2
    ) AS mom_growth_rate
FROM with_lag_monthly
ORDER BY month_start desc limit 2;
""";
var downMonthRate = db.select(ipMonthRateSql);
res.put("ip_month_rate",downMonthRate.size()>0?downMonthRate.get(0):ma);
return res;

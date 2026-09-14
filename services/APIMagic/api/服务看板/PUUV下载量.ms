{
  "properties" : { },
  "id" : "5f803ed7a3c6444dbb285d87c41eeebc",
  "script" : null,
  "groupId" : "fee87ad3dfde4e33b4dd4bc0eb95ce14",
  "name" : "PUUV下载量",
  "createTime" : null,
  "updateTime" : 1773906336449,
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
  "requestBody" : "{\r\n  \"metrics\": [\r\n    \"download_count\",\r\n    \"download_ip\"\r\n  ],\r\n  \"community\": \"openubmc\",\r\n  \"source\":\"cla\",\r\n  \"variables\": {\r\n    \"oversea\": [\r\n      \"0\",\r\n      \"1\"\r\n    ]\r\n  },\r\n\r\n  \"start\": \"2025-10-01\",\r\n  \"end\": \"2026-02-10\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"down_week_rate\": {\n            \"wow_growth_rate\": -47.46,\n            \"weekly_downloads\": 476,\n            \"week_start_date\": \"2026-02-09\",\n            \"prev_week_downloads\": 906\n        },\n        \"download_ip\": 273,\n        \"down_month_rate\": {\n            \"prev_month_downloads\": 3122,\n            \"mom_growth_rate\": -55.73,\n            \"monthly_downloads\": 1382,\n            \"month_start_date\": \"2026-02-01\"\n        },\n        \"ip_month_rate\": {\n            \"mom_growth_rate\": -62.81,\n            \"week_start_date\": \"2026-02-01\",\n            \"prev_month_ip\": 199,\n            \"monthly_ip\": 74\n        },\n        \"ip_week_rate\": {\n            \"wow_growth_rate\": -67.86,\n            \"prev_week_ip\": 56,\n            \"week_start_date\": 476,\n            \"weekly_ip\": 18\n        },\n        \"download_count\": 4504\n    },\n    \"timestamp\": 1773906323439,\n    \"executeTime\": 11\n}",
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
      "name" : "metrics",
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
        "value" : "download_count",
        "description" : "",
        "required" : false,
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      } ]
    }, {
      "name" : "community",
      "value" : "openubmc",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "cla",
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
        "children" : [ {
          "name" : "",
          "value" : "0",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        } ]
      } ]
    }, {
      "name" : "start",
      "value" : "2025-10-01",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "(\\\\d{4}-\\\\d{2}-\\\\d{2}( \\\\d{2}:\\\\d{2}:\\\\d{2})?)?$",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "2026-02-10",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "(\\\\d{4}-\\\\d{2}-\\\\d{2}( \\\\d{2}:\\\\d{2}:\\\\d{2})?)?$",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var source = body.source;
var community = body.community;
var start =date_format(body.start::date('yyyy-MM-dd'),'yyyy-MM-dd')
var end = date_format(body.end::date('yyyy-MM-dd'),'yyyy-MM-dd')
var community_tem = body.community;
if("cannopen".equals(body.community)){
    community_tem = "cann"
}
if (source == 'all' || source == null){
    source = null;
}else{
    var sqlsource = """ select distinct source from dict_service_metrics where community=#{community} and type_value=#{source} and metric_name is null"""
    Map sourcevalue = db.selectOne(sqlsource)
    if(sourcevalue == null){
        source = "";
    }else{
        source = sourcevalue.get("source")
        source = null==source?"":source
    }
}
HashMap ma = new HashMap();
ma.put("wow_growth_rate","")
ma.put("mom_growth_rate","")
//下载量和ip下载量
var totalCountSql = """
SELECT COALESCE(SUM(pv))  as pv,COALESCE(SUM(uv))  as uv 
    FROM dws_${community_tem}_service_log_daily
    WHERE created_at BETWEEN #{start}::DATE AND #{end}::DATE 
      <if test="source != null">
       AND source = #{source}
      </if>
""";
var totalCount = db.select(totalCountSql);
HashMap res = new HashMap();
res.put("download_count",totalCount.pv);
res.put("download_ip",totalCount.uv);
//下载周环比
var downWeekRateSql = """
WITH weekly_stats AS (
    SELECT 
        DATE_TRUNC('week',created_at)::DATE AS week_start_date,
        sum(pv) AS weekly_downloads,
        sum(uv) AS weekly_ip
    FROM dws_${community_tem}_service_log_daily
    WHERE created_at BETWEEN #{start}::DATE AND #{end}::DATE 
        <if test="source != null">
       AND source = #{source}
      </if>
    GROUP BY week_start_date
    ORDER BY week_start_date DESC
    LIMIT 2 -- 只保留最新的两周
),
weekly_comparison AS (
    SELECT 
        week_start_date,
        weekly_downloads,
        LAG(weekly_downloads) OVER (ORDER BY week_start_date) AS prev_week_downloads,
        ROUND(
            CASE 
                WHEN LAG(weekly_downloads) OVER (ORDER BY week_start_date) IS NOT NULL THEN
                    (weekly_downloads - LAG(weekly_downloads) OVER (ORDER BY week_start_date)) * 100.0 /
                    LAG(weekly_downloads) OVER (ORDER BY week_start_date)
                ELSE NULL
            END, 2
        ) AS wow_growth_rate,
         weekly_ip,
        LAG(weekly_ip) OVER (ORDER BY week_start_date) AS prev_week_ip,
        ROUND(
            CASE 
                WHEN LAG(weekly_ip) OVER (ORDER BY week_start_date) IS NOT NULL THEN
                    (weekly_ip - LAG(weekly_ip) OVER (ORDER BY week_start_date)) * 100.0 /
                    LAG(weekly_ip) OVER (ORDER BY week_start_date)
                ELSE NULL
            END, 2
        ) AS ip_wow_growth_rate
    FROM weekly_stats
)
-- 合并结果
SELECT 
    wc.week_start_date,
    wc.weekly_downloads,
    wc.prev_week_downloads,
    wc.wow_growth_rate,
    wc.weekly_ip,
    wc.prev_week_ip,
    wc.ip_wow_growth_rate
FROM weekly_comparison wc
ORDER BY week_start_date desc limit 2
""";
var downWeekRate = db.select(downWeekRateSql);
if (downWeekRate.size()>0){
    Map ss = downWeekRate.get(0);
    HashMap weekdown = new HashMap();
    weekdown.put("week_start_date",ss.get("week_start_date"))
    weekdown.put("weekly_downloads",ss.get("weekly_downloads"))
    weekdown.put("prev_week_downloads",ss.get("prev_week_downloads"))
    weekdown.put("wow_growth_rate",ss.get("wow_growth_rate"))
    HashMap weekdownip = new HashMap();
    weekdownip.put("week_start_date",ss.get("weekly_downloads"))
    weekdownip.put("weekly_ip",ss.get("weekly_ip"))
    weekdownip.put("prev_week_ip",ss.get("prev_week_ip"))
    weekdownip.put("wow_growth_rate",ss.get("ip_wow_growth_rate"))
    res.put("down_week_rate",weekdown);
    res.put("ip_week_rate",weekdownip);
}else{
    res.put("down_week_rate",ma);
    res.put("ip_week_rate",ma);
}
//下载月环比
var downMonthRateSql = """
WITH monthly_stats AS (
    -- 按月统计下载量，并限制到最新的两个月
    SELECT 
        DATE_TRUNC('month', created_at)::DATE AS month_start_date,
        sum(pv) AS monthly_downloads,
        sum(uv) as monthly_ip
    FROM dws_${community_tem}_service_log_daily
    WHERE created_at BETWEEN #{start}::DATE AND #{end}::DATE 
        <if test="source != null">
       AND source = #{source}
      </if>
    GROUP BY month_start_date
    ORDER BY month_start_date DESC
    LIMIT 2 -- 只保留最新的两个月
),
monthly_comparison AS (
    -- 计算最新两月的月环比（MoM）
    SELECT 
        month_start_date,
        monthly_downloads,
        LAG(monthly_downloads) OVER (ORDER BY month_start_date) AS prev_month_downloads,
        ROUND(
            CASE 
                WHEN LAG(monthly_downloads) OVER (ORDER BY month_start_date) IS NOT NULL THEN
                    (monthly_downloads - LAG(monthly_downloads) OVER (ORDER BY month_start_date)) * 100.0 /
                    LAG(monthly_downloads) OVER (ORDER BY month_start_date)
                ELSE NULL
            END, 2
        ) AS mom_growth_rate,
        monthly_ip,
        LAG(monthly_ip) OVER (ORDER BY month_start_date) AS prev_month_ip,
        ROUND(
            CASE 
                WHEN LAG(monthly_ip) OVER (ORDER BY month_start_date) IS NOT NULL THEN
                    (monthly_ip - LAG(monthly_ip) OVER (ORDER BY month_start_date)) * 100.0 /
                    LAG(monthly_ip) OVER (ORDER BY month_start_date)
                ELSE NULL
            END, 2
        ) AS ip_mom_growth_rate
    FROM monthly_stats
)
SELECT 
    mc.month_start_date  ,
    mc.monthly_downloads ,
    mc.prev_month_downloads ,
    mc.mom_growth_rate,
    mc.monthly_ip ,
    mc.prev_month_ip ,
    mc.ip_mom_growth_rate 
FROM monthly_comparison mc
ORDER BY month_start_date DESC limit 2
""";
var downMonthRate = db.select(downMonthRateSql);
if (downMonthRate.size()>0){
    Map mm = downMonthRate.get(0);
    HashMap monthdown = new HashMap();
    monthdown.put("month_start_date",mm.get("month_start_date"))
    monthdown.put("monthly_downloads",mm.get("monthly_downloads"))
    monthdown.put("prev_month_downloads",mm.get("prev_month_downloads"))
    monthdown.put("mom_growth_rate",mm.get("mom_growth_rate"))
    HashMap monthip = new HashMap();
    monthip.put("week_start_date",mm.get("month_start_date"))
    monthip.put("monthly_ip",mm.get("monthly_ip"))
    monthip.put("prev_month_ip",mm.get("prev_month_ip"))
    monthip.put("mom_growth_rate",mm.get("ip_mom_growth_rate"))
    res.put("down_month_rate",monthdown);
    res.put("ip_month_rate",monthip);
}else{
    res.put("down_month_rate",ma);
    res.put("ip_month_rate",ma);
}
return res;

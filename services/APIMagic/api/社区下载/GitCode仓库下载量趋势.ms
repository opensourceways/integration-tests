{
  "properties" : { },
  "id" : "b7c1e2a4d9f04c3ab1049gitcodedl04",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "GitCode仓库下载量趋势",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repo/trend",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\n    \"community\": \"hpckit\",\n    \"start\": \"2026-06-01\",\n    \"end\": \"2026-06-30\",\n    \"interval\": \"day\"\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 200,\n    \"message\": \"success\",\n    \"data\": {\n        \"download_total\": 200,\n        \"user_total\": 15,\n        \"download_week_rate\": 12.5,\n        \"download_month_rate\": 8.3,\n        \"user_week_rate\": 5.0,\n        \"user_month_rate\": -2.1,\n        \"download_trend\": [{\n            \"stat_period\": \"2026-06-23\",\n            \"increment_value\": 20,\n            \"cumulative_value\": 20\n        }],\n        \"user_trend\": [{\n            \"stat_period\": \"2026-06-23\",\n            \"increment_value\": 5,\n            \"cumulative_value\": 5\n        }]\n    }\n}",
  "description" : "GitCode 仓库下载量趋势看板（issue #1049）：返回时间范围内的下载总量、下载用户总量（去重登录用户）、下载量/下载用户的周环比与月环比（供汇总卡片对齐 /users 页 UserTotal 展示），以及下载量趋势、下载用户趋势。趋势按 interval(day/week/month) 聚合，每周期同时给出 increment_value(增量) 与 cumulative_value(总量)，前端按度量维度切换取值，无需重复请求。",
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
      "name" : "community",
      "value" : "hpckit",
      "description" : "社区",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 必须为 hpckit",
      "expression" : "^hpckit$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "2026-06-01",
      "description" : "起始日期",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "start 日期格式必须为 YYYY-MM-DD",
      "expression" : "^\\d{4}-\\d{2}-\\d{2}$",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "2026-06-30",
      "description" : "结束日期",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "end 日期格式必须为 YYYY-MM-DD",
      "expression" : "^\\d{4}-\\d{2}-\\d{2}$",
      "children" : [ ]
    }, {
      "name" : "interval",
      "value" : "day",
      "description" : "趋势间隔周期（可选，默认 day）：day / week / month",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "interval 只能为 day、week、month",
      "expression" : "^(day|week|month)?$",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}

================================
// GitCode 仓库下载量趋势看板（issue #1049）
// 返回：下载总量、下载用户总量、下载量趋势、下载用户趋势。
// 趋势按 interval(day/week/month) 聚合，每周期同时给出 increment_value(增量) 与 cumulative_value(总量)，
// 前端按「度量维度」切换取值，无需重复请求。
//
// 入参校验由框架声明式 pattern 完成：community 严格限定 ^hpckit$（拼进表名安全）、
// start/end 日期格式、interval 限定 ^(day|week|month)?$。脚本内不再重复校验。
// 表名由已校验的 community 拼出；start/end 走 #{} 绑定；interval 已白名单校验，用 ${} 拼进 DATE_TRUNC 安全。
var community = body.community;
var start = body.start;
var end = body.end;
var interval = body.interval;
if (interval == null || interval == '') {
    interval = 'day';
}
var dwsTable = 'dws_' + community + '_gitcode_repo_download_daily';
var rawTable = 'fact_' + community + '_user_download';

// 表存在性检查：预览/新社区环境表可能尚未建出，不存在时该维度返回空，避免 500
var dwsCheck = db.select("SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='" + dwsTable + "') AS ok");
var dwsExists = dwsCheck.size() > 0 && dwsCheck[0].get("ok") == true;
var rawCheck = db.select("SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='" + rawTable + "') AS ok");
var rawExists = rawCheck.size() > 0 && rawCheck[0].get("ok") == true;

var downloadTotal = 0;
var userTotal = 0;
var downloadTrend = [];
var userTrend = [];

if (dwsExists) {
    // 下载总量：范围内所有仓库 total_count 求和
    var dTotalRow = db.selectOne("SELECT COALESCE(SUM(total_count),0) AS cnt FROM " + dwsTable + " WHERE stat_date >= #{start}::date AND stat_date <= #{end}::date");
    downloadTotal = dTotalRow.cnt;

    // 下载量趋势：逐天 generate_series 填满区间 → 按 interval 截断聚合 → 窗口求累计
    var downloadTrendSql = """
    WITH date_range AS (
        SELECT generate_series AS day FROM generate_series(#{start}::date, #{end}::date, '1 day')
    ),
    period_agg AS (
        SELECT DATE_TRUNC('${interval}', dr.day)::date AS stat_period,
               COALESCE(SUM(d.total_count),0) AS increment_value
        FROM date_range dr
        LEFT JOIN ${dwsTable} d ON d.stat_date = dr.day
        GROUP BY DATE_TRUNC('${interval}', dr.day)
    )
    SELECT stat_period,
           increment_value,
           SUM(increment_value) OVER (ORDER BY stat_period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_value
    FROM period_agg
    ORDER BY stat_period
    """;
    downloadTrend = db.select(downloadTrendSql);
}

if (rawExists) {
    // 下载用户总量：范围内去重登录用户（未登录记录无 user_login，不计）
    var uTotalRow = db.selectOne("SELECT COUNT(DISTINCT user_login) AS cnt FROM " + rawTable + " WHERE is_login = 'true' AND user_login IS NOT NULL AND user_login <> '' AND stat_date >= #{start}::date AND stat_date <= #{end}::date");
    userTotal = uTotalRow.cnt;

    // 下载用户趋势：
    //   increment_value = 每周期内去重登录用户数（活跃用户）
    //   cumulative_value = 累计去重登录用户数（按用户首次出现周期滚动累加）
    var userTrendSql = """
    WITH date_range AS (
        SELECT generate_series AS day FROM generate_series(#{start}::date, #{end}::date, '1 day')
    ),
    periods AS (
        SELECT DISTINCT DATE_TRUNC('${interval}', dr.day)::date AS stat_period FROM date_range dr
    ),
    user_first AS (
        SELECT user_login, MIN(DATE_TRUNC('${interval}', stat_date)::date) AS first_period
        FROM ${rawTable}
        WHERE is_login = 'true' AND user_login IS NOT NULL AND user_login <> ''
          AND stat_date >= #{start}::date AND stat_date <= #{end}::date
        GROUP BY user_login
    ),
    period_inc AS (
        SELECT DATE_TRUNC('${interval}', stat_date)::date AS stat_period,
               COUNT(DISTINCT user_login) AS increment_value
        FROM ${rawTable}
        WHERE is_login = 'true' AND user_login IS NOT NULL AND user_login <> ''
          AND stat_date >= #{start}::date AND stat_date <= #{end}::date
        GROUP BY DATE_TRUNC('${interval}', stat_date)
    ),
    first_counts AS (
        SELECT first_period, COUNT(*) AS new_users FROM user_first GROUP BY first_period
    )
    SELECT p.stat_period,
           COALESCE(pi.increment_value,0) AS increment_value,
           COALESCE(SUM(fc.new_users) OVER (ORDER BY p.stat_period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),0) AS cumulative_value
    FROM periods p
    LEFT JOIN period_inc pi ON pi.stat_period = p.stat_period
    LEFT JOIN first_counts fc ON fc.first_period = p.stat_period
    ORDER BY p.stat_period
    """;
    userTrend = db.select(userTrendSql);
}

// 汇总卡片周环比/月环比（对齐 /users 页 UserTotal 的 OChartTextV2 卡片展示）：
// 近 7 天 vs 前 7 天（周环比）、近 30 天 vs 前 30 天（月环比），窗口均由外层 WHERE 夹在 [start,end] 内。
// baseline 为 0 时返回 null（前端兜底展示），避免除零。
var downloadWeekRate = null;
var downloadMonthRate = null;
if (dwsExists) {
    var dGrowth = db.selectOne("""
    WITH s AS (
        SELECT
            COALESCE(SUM(CASE WHEN stat_date >= (#{end}::date - 6) THEN total_count ELSE 0 END),0) AS dl7,
            COALESCE(SUM(CASE WHEN stat_date <= (#{end}::date - 7) AND stat_date >= (#{end}::date - 13) THEN total_count ELSE 0 END),0) AS dp7,
            COALESCE(SUM(CASE WHEN stat_date >= (#{end}::date - 29) THEN total_count ELSE 0 END),0) AS dl30,
            COALESCE(SUM(CASE WHEN stat_date <= (#{end}::date - 30) AND stat_date >= (#{end}::date - 59) THEN total_count ELSE 0 END),0) AS dp30
        FROM ${dwsTable}
        WHERE stat_date >= #{start}::date AND stat_date <= #{end}::date
    )
    SELECT
        CASE WHEN dp7 > 0 THEN ROUND((dl7 - dp7) * 100.0 / dp7, 1) ELSE NULL END AS week_rate,
        CASE WHEN dp30 > 0 THEN ROUND((dl30 - dp30) * 100.0 / dp30, 1) ELSE NULL END AS month_rate
    FROM s
    """);
    downloadWeekRate = dGrowth.week_rate;
    downloadMonthRate = dGrowth.month_rate;
}

var userWeekRate = null;
var userMonthRate = null;
if (rawExists) {
    var uGrowth = db.selectOne("""
    WITH s AS (
        SELECT
            COUNT(DISTINCT CASE WHEN stat_date >= (#{end}::date - 6) THEN user_login END) AS ul7,
            COUNT(DISTINCT CASE WHEN stat_date <= (#{end}::date - 7) AND stat_date >= (#{end}::date - 13) THEN user_login END) AS up7,
            COUNT(DISTINCT CASE WHEN stat_date >= (#{end}::date - 29) THEN user_login END) AS ul30,
            COUNT(DISTINCT CASE WHEN stat_date <= (#{end}::date - 30) AND stat_date >= (#{end}::date - 59) THEN user_login END) AS up30
        FROM ${rawTable}
        WHERE is_login = 'true' AND user_login IS NOT NULL AND user_login <> ''
          AND stat_date >= #{start}::date AND stat_date <= #{end}::date
    )
    SELECT
        CASE WHEN up7 > 0 THEN ROUND((ul7 - up7) * 100.0 / up7, 1) ELSE NULL END AS week_rate,
        CASE WHEN up30 > 0 THEN ROUND((ul30 - up30) * 100.0 / up30, 1) ELSE NULL END AS month_rate
    FROM s
    """);
    userWeekRate = uGrowth.week_rate;
    userMonthRate = uGrowth.month_rate;
}

return {
    download_total: downloadTotal,
    user_total: userTotal,
    download_week_rate: downloadWeekRate,
    download_month_rate: downloadMonthRate,
    user_week_rate: userWeekRate,
    user_month_rate: userMonthRate,
    download_trend: downloadTrend,
    user_trend: userTrend
};

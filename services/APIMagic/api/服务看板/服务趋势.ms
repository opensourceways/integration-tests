{
  "properties" : { },
  "id" : "04562668a1834aa7baf094cdaf3e7b95",
  "script" : null,
  "groupId" : "fee87ad3dfde4e33b4dd4bc0eb95ce14",
  "name" : "服务趋势",
  "createTime" : null,
  "updateTime" : 1774322305527,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/trend",
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
  "requestBody" : "{\r\n  \"metrics\":\"download_count\",\r\n  \"source\":\"forum\",\r\n  \"community\": \"openubmc\",\r\n  \"interval\":\"day\",\r\n  \r\n  \"start\": \"2025-07-08\",\r\n  \"end\": \"2025-08-24\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"stat_period\": \"2025-07-08\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-09\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-10\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-11\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-12\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-13\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-14\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-15\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-16\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-17\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-18\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-19\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-20\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-21\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-22\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-23\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-24\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-07-25\",\n        \"increment_value\": 190274,\n        \"cumulative_value\": 190274\n    }, {\n        \"stat_period\": \"2025-07-26\",\n        \"increment_value\": 282082,\n        \"cumulative_value\": 472356\n    }, {\n        \"stat_period\": \"2025-07-27\",\n        \"increment_value\": 230978,\n        \"cumulative_value\": 703334\n    }, {\n        \"stat_period\": \"2025-07-28\",\n        \"increment_value\": 335844,\n        \"cumulative_value\": 1039178\n    }, {\n        \"stat_period\": \"2025-07-29\",\n        \"increment_value\": 356064,\n        \"cumulative_value\": 1395242\n    }, {\n        \"stat_period\": \"2025-07-30\",\n        \"increment_value\": 393039,\n        \"cumulative_value\": 1788281\n    }, {\n        \"stat_period\": \"2025-07-31\",\n        \"increment_value\": 297286,\n        \"cumulative_value\": 2085567\n    }, {\n        \"stat_period\": \"2025-08-01\",\n        \"increment_value\": 272116,\n        \"cumulative_value\": 2357683\n    }, {\n        \"stat_period\": \"2025-08-02\",\n        \"increment_value\": 219735,\n        \"cumulative_value\": 2577418\n    }, {\n        \"stat_period\": \"2025-08-03\",\n        \"increment_value\": 194003,\n        \"cumulative_value\": 2771421\n    }, {\n        \"stat_period\": \"2025-08-04\",\n        \"increment_value\": 258023,\n        \"cumulative_value\": 3029444\n    }, {\n        \"stat_period\": \"2025-08-05\",\n        \"increment_value\": 293516,\n        \"cumulative_value\": 3322960\n    }, {\n        \"stat_period\": \"2025-08-06\",\n        \"increment_value\": 198313,\n        \"cumulative_value\": 3521273\n    }, {\n        \"stat_period\": \"2025-08-07\",\n        \"increment_value\": 342089,\n        \"cumulative_value\": 3863362\n    }, {\n        \"stat_period\": \"2025-08-08\",\n        \"increment_value\": 361480,\n        \"cumulative_value\": 4224842\n    }, {\n        \"stat_period\": \"2025-08-09\",\n        \"increment_value\": 298692,\n        \"cumulative_value\": 4523534\n    }, {\n        \"stat_period\": \"2025-08-10\",\n        \"increment_value\": 230951,\n        \"cumulative_value\": 4754485\n    }, {\n        \"stat_period\": \"2025-08-11\",\n        \"increment_value\": 303303,\n        \"cumulative_value\": 5057788\n    }, {\n        \"stat_period\": \"2025-08-12\",\n        \"increment_value\": 331647,\n        \"cumulative_value\": 5389435\n    }, {\n        \"stat_period\": \"2025-08-13\",\n        \"increment_value\": 325595,\n        \"cumulative_value\": 5715030\n    }, {\n        \"stat_period\": \"2025-08-14\",\n        \"increment_value\": 312987,\n        \"cumulative_value\": 6028017\n    }, {\n        \"stat_period\": \"2025-08-15\",\n        \"increment_value\": 312371,\n        \"cumulative_value\": 6340388\n    }, {\n        \"stat_period\": \"2025-08-16\",\n        \"increment_value\": 249866,\n        \"cumulative_value\": 6590254\n    }, {\n        \"stat_period\": \"2025-08-17\",\n        \"increment_value\": 246443,\n        \"cumulative_value\": 6836697\n    }, {\n        \"stat_period\": \"2025-08-18\",\n        \"increment_value\": 326649,\n        \"cumulative_value\": 7163346\n    }, {\n        \"stat_period\": \"2025-08-19\",\n        \"increment_value\": 307564,\n        \"cumulative_value\": 7470910\n    }, {\n        \"stat_period\": \"2025-08-20\",\n        \"increment_value\": 407696,\n        \"cumulative_value\": 7878606\n    }, {\n        \"stat_period\": \"2025-08-21\",\n        \"increment_value\": 429772,\n        \"cumulative_value\": 8308378\n    }, {\n        \"stat_period\": \"2025-08-22\",\n        \"increment_value\": 179625,\n        \"cumulative_value\": 8488003\n    }, {\n        \"stat_period\": \"2025-08-23\",\n        \"increment_value\": 26167,\n        \"cumulative_value\": 8514170\n    }, {\n        \"stat_period\": \"2025-08-24\",\n        \"increment_value\": 15503,\n        \"cumulative_value\": 8529673\n    }],\n    \"timestamp\": 1773827621348,\n    \"executeTime\": 6\n}",
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
    }, {
      "name" : "source",
      "value" : "forum",
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
      "name" : "interval",
      "value" : "day",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(day|week|month|year)$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "2025-07-08",
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
      "name" : "end",
      "value" : "2025-08-24",
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
          "name" : "stat_period",
          "value" : "2025-03-08",
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
          "name" : "increment_value",
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
          "name" : "cumulative_value",
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
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1748424537469",
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
      "value" : "null",
      "description" : "",
      "required" : false,
      "dataType" : "Object",
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
var source = body.source;
var community = body.community;
var interval = body.interval;
var start =date_format(body.start::date('yyyy-MM-dd'),'yyyy-MM-dd');
var end = date_format(body.end::date('yyyy-MM-dd'),'yyyy-MM-dd');
var operation = body.operation;
var type = body.metrics;
var community_tem = body.community;
if("cannopen".equals(body.community)){
    community_tem = "cann"
}
if (source == 'all'){
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
var sql = """
WITH params AS (
    SELECT 
        #{start}::date AS start_date,
        #{end}::date AS end_date,
        #{interval} AS interval,
        #{type} AS metric_type
),
-- 生成时间序列（自然周对齐）
time_series AS (
    SELECT (d_series::date) AS stat_period
    FROM params,
    LATERAL (
        SELECT generate_series(
            DATE_TRUNC(#{interval}, start_date),
            DATE_TRUNC(#{interval}, end_date),
            '1 ${interval}'
        )
    ) AS gs(d_series)
),
-- 原始数据按周聚合（仅保留需要字段）
raw_data AS (
    SELECT 
        DATE_TRUNC(#{interval}, created_at)::date AS stat_period,
        -- 根据 metric_type 聚合
        SUM(CASE 
            WHEN p.metric_type = 'download_count' THEN COALESCE(pv, 0)
            WHEN p.metric_type = 'download_ip' THEN COALESCE(uv, 0)
            ELSE 0 
        END) AS increment_value
    FROM dws_${community_tem}_service_log_daily t
    CROSS JOIN params p
    WHERE t.created_at >= p.start_date
      AND t.created_at <= p.end_date
      <if test="source != null">
       AND source = #{source}
      </if>
      -- 如果 source 不是 'all'，才过滤（可扩展）
      -- AND (p.source_filter = 'all' OR t.source = p.source_filter)
    GROUP BY stat_period
)
-- 主查询：补零 + 累计值
SELECT 
    TO_CHAR(ts.stat_period, 'YYYY-MM-DD') AS stat_period,
    COALESCE(rd.increment_value, 0) AS increment_value,
    SUM(COALESCE(rd.increment_value, 0)) 
        OVER (ORDER BY ts.stat_period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_value
FROM time_series ts
LEFT JOIN raw_data rd ON ts.stat_period = rd.stat_period
ORDER BY ts.stat_period;
"""
return db.select(sql);

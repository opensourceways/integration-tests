{
  "properties" : { },
  "id" : "copy1751525314320d92473",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "下载趋势(新接口)",
  "createTime" : null,
  "updateTime" : 1773906627702,
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
  "requestBody" : "{\r\n  \"metrics\": [\r\n    \"download_count\"\r\n  ],\r\n  \"source\":[\"docker_hub\"],\r\n  \"community\": \"openeuler\",\r\n  \"variables\": {\r\n    \"oversea\": [\r\n      \"1\",\r\n      \"0\"\r\n    ],\r\n    \"interval\":\"day\"\r\n  },\r\n  \"operation\": \"totalCount\",\r\n  \"start\": \"2025-03-08\",\r\n  \"end\": \"2025-03-31\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"stat_period\": \"2025-03-08\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-09\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-10\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-11\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-12\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-13\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-14\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-15\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-16\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-17\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-18\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-19\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-20\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-21\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-22\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-23\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-24\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-25\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-26\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-27\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-28\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-29\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-30\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }, {\n        \"stat_period\": \"2025-03-31\",\n        \"increment_value\": 0,\n        \"cumulative_value\": 0\n    }],\n    \"timestamp\": 1751887945737,\n    \"executeTime\": 5\n}",
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
      "name" : "metrics",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "metrics 只能为 download_count 或 download_ip",
      "expression" : "^(download_count|download_ip)?$",
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
      }, {
        "name" : "interval",
        "value" : "",
        "description" : "",
        "required" : false,
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "pattern",
        "error" : "interval 只能为 day、week、month",
        "expression" : "^(day|week|month)?$",
        "children" : [ ]
      } ]
    }, {
      "name" : "operation",
      "value" : "",
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
  "responseBodyDefinition" : null
}
================================
var source = body.source;
var community = body.community;
var community_temp = body.community;
var oversea = body.variables.oversea;
var interval = body.variables.interval;
var start =date_format(body.start::date('yyyy-MM-dd'),'yyyy-MM-dd');
var end = date_format(body.end::date('yyyy-MM-dd'),'yyyy-MM-dd');
var operation = body.operation;
var type = body.metrics.get(0);
var repo_type = body.repo_type;
var use_repo = repo_type != null && repo_type != '' && "download_count" == type;
HashMap map = new HashMap();
map.put("download_count","download_day_increase");
map.put("download_ip","ip_day_increase");
map.put("download_count1","inner_download_day_increase");
map.put("download_count0","outer_download_day_increase");
map.put("download_ip1","inner_ip_day_increase");
map.put("download_ip0","outer_ip_day_increase");
var field = "download_day_increase";
if(oversea.size()>1){
    field = map.get(type);
}else{
    field = map.get(type+oversea.get(0));
}
var trendTable = use_repo ? ("dws_" + community + "_repo_download_daily") : ("dws_" + community + "_download_daily");
var trendCol = use_repo ? "day_count" : field;
var tabelName ="dws_"+community_temp+"_download_daily".toString();
if("openeuler".equals(community_temp)){
    tabelName = "dws_"+community_temp+"_download_daily_backup".toString();
}
var sql = """
WITH date_range AS (
    SELECT generate_series::date AS day
    FROM generate_series(#{start}::date, #{end}::date, '1 day')
),
daily_data AS (
    SELECT
        DATE_TRUNC('${interval}', dr.day)::date AS stat_period,
        COALESCE(SUM(d.${trendCol}), 0) AS increment_value
    FROM date_range dr
    LEFT JOIN ${trendTable} d 
      ON d.created_at = dr.day
    <if test="source != null and source.size() > 0">
        and d.source in
        <foreach collection="source" item="item" open="(" separator="," close=")">
            #{item}
        </foreach>
    </if>
    <if test="use_repo">
        and d.repo_type = #{repo_type}
    </if>
    GROUP BY DATE_TRUNC('${interval}', dr.day)
)
SELECT
    stat_period AS stat_period,
    increment_value,
    SUM(increment_value) OVER (ORDER BY stat_period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_value
FROM daily_data
ORDER BY stat_period;
""";
return db.select(sql);

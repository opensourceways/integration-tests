{
  "properties" : { },
  "id" : "9c290693e16e46ea9993633196318e9b",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "服务趋势",
  "createTime" : null,
  "updateTime" : 1777002823245,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/source/trend",
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
  "requestBody" : "{\r\n    \"startDate\":1753142400000,\r\n    \"endDate\":1762909306672,\r\n    \"source\":\"baidu\",\r\n    \"community\":\"meeting\",\r\n    \"interval\":\"week\",\r\n    \"metric\": \"count\",\r\n    \"metric_list\": []\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1773905326587,\n    \"executeTime\": 9\n}",
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
      "name" : "startDate",
      "value" : "1753142400000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "startDate 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "endDate",
      "value" : "1755820800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "endDate 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "baidu",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "source 只能为 email、meeting 或 baidu",
      "expression" : "^(account|baidu|cla|conan|delivery|download|email|etherpad|forum|meeting|omapi|openfuyao|search|unifiedbus|usercenter|website|www)?$",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "unifiedbus",
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
      "name" : "interval",
      "value" : "week",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "interval 只能为 day、week 或 month",
      "expression" : "^(day|week|month)?$",
      "children" : [ ]
    }, {
      "name" : "metrics",
      "value" : "count",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "metrics 格式非法",
      "expression" : "^(active_user_count|average_topic|churn_ratio|closed_count|closed_ratio|count|ctr|email_count|email_subject_count|high_quality_ratio|interaction_ratio|key_count|list_count|login_count|median_closed_time|median_first_reply_time|meeting_count|meeting_duration|participant_count|regist_count|reply_count|response_count|response_ratio|response_time|search_count|search_result_count|sig_count|solved_count|spam_ratio|subscribe_count|thread_count|topic_count|count|relative_ratio)$",
      "children" : [ ]
    }, {
      "name" : "metric_list",
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
  "responseBodyDefinition" : null
}
================================
import java.util.Arrays;
import java.util.List;
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.startDate);
Date end = timestamp2Date(body.endDate);
// 服务： 邮件-email,会议-meeting
var source = body.source; 
var community = body.community
var list_id = body.list_id
var list_arr = list_id != null ? list_id.split("/"):[];
if(list_arr.size() == 2){
    list_id = list_arr[1];
}
// 指标类型：
// 邮件： email-邮件个数，topic-邮件主题个数，list-邮件列表个数，user-订阅人数
// 会议： meeting-会议个数，duration-会议时长，user-参会人数，sig-开会sig数
var query_metric_set = new HashSet();
if (body.metrics != null){
    query_metric_set.add(body.metrics);
}
if (body.metric != null){
    query_metric_set.add(body.metric);
}
if (body.metric_list != null){
    query_metric_set.addAll(body.metric_list);
}

// 统计周期：daily-天，week-周，month-月
var interval = body.interval;
// 服务表
var userTable = "dws_" + community + "_" + source + "_" + interval;

var table_field_sql = """
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = #{userTable}
"""
table_field_db = db.select(table_field_sql)
var table_field_set = new HashSet();
table_field_db.forEach(item -> {
    metric_value = item.get("column_name");
    table_field_set.add(metric_value);
})
var metric_column = new ArrayList();
query_metric_set.forEach(item -> {
    if (table_field_set.contains(item)){
        metric_column.add(item);
    }
})

if(source == 'forum' and (query_metric_set.contains('solved_count') or query_metric_set.contains('response_count'))){
    metric_column.add('topic_count');
}

if (metric_column.size() == 0){
    return []
}

var cal_sum_field = Arrays.asList("_count", "count", "_time", "_duration", "_num", "_incre", "average_topic");
var cal_sum_set = new HashSet();
metric_column.forEach(item -> {
    if (cal_sum_field.stream().anyMatch(s -> item.endsWith(s))){
        cal_sum_set.add(item);
    }
})

var sql = """
WITH date_series AS (
-- 生成从最早访问日期到当前日期的日期序列
  SELECT
    generate_series ( #{start}, #{end}, '1 day' :: INTERVAL ) :: DATE AS date
),
daily_data AS (
    SELECT
        (date AT TIME ZONE 'Asia/Shanghai')::DATE as date,
        <foreach collection="metric_column" item="item" separator=",">
            COALESCE(${item}, 0) as ${item}
        </foreach>
    FROM ${userTable}
    WHERE date BETWEEN #{start} AND #{end}
        <if test="list_id != null and list_id != ''">
            and list_id = #{list_id}
        </if>
),
group_full_combinations AS (
    select 
        <if test="interval == 'day'">
            date_trunc('day', date)::DATE as date
        </if>
        <elseif test="interval == 'week'">
            date_trunc('week', date)::DATE as date
        </elseif>
        <else>
            date_trunc('month', date)::DATE as date
        </else>
    from date_series
    GROUP BY 
        <if test="interval == 'day'">
            date_trunc('day', date)::DATE 
        </if>
        <elseif test="interval == 'week'">
            date_trunc('week', date)::DATE 
        </elseif>
        <else>
            date_trunc('month', date)::DATE 
        </else>
),
joined_data AS (
    -- 将完整的日期和组合表与实际的访问数据进行左连接
    SELECT 
        fc.date,
        <foreach collection="metric_column" item="item" separator=",">
            <if test="!item.endsWith('_time')">
               COALESCE(${item}, 0) as ${item},
               <if test="cal_sum_set.contains(item)">
                SUM(COALESCE(${item}, 0)) OVER (ORDER BY fc.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_${item}
               </if>
               <if test="!cal_sum_set.contains(item)">
                COALESCE(${item}, 0) as total_${item}
               </if>
            </if>
            <if test="item.endsWith('_time')">
               ROUND((COALESCE(${item}, 0))::numeric / 86400, 4) as ${item},
               <if test="cal_sum_set.contains(item)">
                ROUND((SUM(COALESCE(${item}, 0)) OVER (ORDER BY fc.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))::numeric / 86400, 4) AS total_${item}
               </if>
               <if test="!cal_sum_set.contains(item)">
                COALESCE(${item}, 0) as total_${item}
               </if>
            </if>
        </foreach>
    FROM group_full_combinations fc
    LEFT JOIN daily_data d ON fc.date = d.date
)
SELECT
    *
FROM joined_data
ORDER BY date;
""";
var query_data = db.select(sql);


return query_data
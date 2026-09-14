{
  "properties" : { },
  "id" : "1f1368456bd44170ab85a871e24134ef",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "服务汇总",
  "createTime" : null,
  "updateTime" : 1774317682150,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/source/total",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"startDate\":1730390400000,\r\n    \"endDate\":1742400000000,\r\n    \"source\":\"forum\",\r\n    \"community\":\"openubmc\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1745306364712,\n    \"executeTime\": 6\n}",
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
      "value" : "1759276800000",
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
      "value" : "1767168725887",
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
      "value" : "repo",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "group_dim 只能为 repo、namespace 或 source",
      "expression" : "^(repo|namespace|source)?$",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "cannopen",
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
      "name" : "issue_type",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "issue_type 格式非法",
      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5]*$",
      "children" : [ ]
    }, {
      "name" : "namespace",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "namespace 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-]*$",
      "children" : [ ]
    }, {
      "name" : "repo_path",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-/.]*$",
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "source 格式非法",
      "expression" : "^[a-zA-Z0-9_]*$",
      "children" : [ ]
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
      "children" : [ ]
    }, {
      "name" : "private",
      "value" : "false",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "private 只能为 true 或 false",
      "expression" : "^(true|false)?$",
      "children" : [ ]
    }, {
      "name" : "asc",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "asc 字段非法",
      "expression" : "^(subscribe_count|email_count|email_subject_count|meeting_count|meeting_duration|participant_count|search_count)?$",
      "children" : [ ]
    }, {
      "name" : "desc",
      "value" : "open_count",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "desc 字段非法",
      "expression" : "^(subscribe_count|email_count|email_subject_count|meeting_count|meeting_duration|participant_count|search_count)?$",
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
      "value" : "-1",
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
      "value" : "系统内部出现错误",
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
    }, {
      "name" : "timestamp",
      "value" : "1743085026856",
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
      "value" : "6",
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
Date start = timestamp2Date(body.startDate);
Date end = timestamp2Date(body.endDate);
// 服务： 邮件-email,会议-meeting
var source = body.source; 
// 指标类型：
// 邮件： email-邮件个数，topic-邮件主题个数，list-邮件列表个数，user-订阅人数
// 会议： meeting-会议个数，duration-会议时长，user-参会人数，sig-开会sig数
var group_by = '';
var metric_column = [];
if (source == 'email'){
    group_by = 'list_id';
    metric_column = [
        "count(DISTINCT CASE WHEN event_type = 'subscribe' THEN sender_email END) as subscribe_count",
        "count(CASE WHEN event_type = 'email' THEN email_id END) as email_count",
        "count(DISTINCT CASE WHEN event_type = 'email' THEN email_subject END) as email_subject_count"
        ]
    data_column = ['subscribe_count','email_count','email_subject_count']
} else if (source == 'meeting'){
    group_by = 'sig_name'
    metric_column = ['count(meeting_id) as meeting_count','sum(duration) as meeting_duration','sum(participant_count) as participant_count']
    data_column = ['meeting_count','meeting_duration','participant_count']
} else if (source == 'search'){
    group_by = 'key_word'
    metric_column = ['sum(search_count) as search_count']
    data_column = ['search_count']
}
// 服务表
var userTable = "dwm_"+body.community+"_"+source;
var sql = """
WITH dim_table AS (
    -- 固定的级别列表
    SELECT distinct ${group_by} from ${userTable}
),daily_data AS (
    SELECT
        ${group_by},
        <foreach collection="metric_column" item="item" separator=",">
            ${item}
        </foreach>
    FROM ${userTable}
    <if test="source != 'search'">
        WHERE created_at::DATE BETWEEN #{start} AND #{end}
    </if>
    group by ${group_by}
),
joined_data AS (
    -- 将完整的日期和组合表与实际的访问数据进行左连接
    SELECT 
        dt.${group_by},
        <foreach collection="data_column" item="item" separator=",">
            COALESCE(d.${item}, 0) AS ${item}
        </foreach>
    FROM dim_table dt
    LEFT JOIN daily_data d ON dt.${group_by} = d.${group_by}
)
SELECT
    *
FROM joined_data;
""";
return db.select(sql)

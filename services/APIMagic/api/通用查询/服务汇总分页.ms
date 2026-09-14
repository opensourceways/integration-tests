{
  "properties" : { },
  "id" : "670e1f90a55c48a59a004ae7c9e481bb",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "服务汇总分页",
  "createTime" : null,
  "updateTime" : 1774317885127,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/source/total/page",
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
  "requestBody" : "{\r\n    \"startDate\":1565308800000,\r\n    \"endDate\":1565308800000,\r\n    \"source\":\"email\",\r\n    \"community\":\"openeuler\",\r\n    \"pageNum\":1,\r\n    \"pageSize\": 10,\r\n    \"desc\": \"email_count\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1774317853092,\n    \"executeTime\": 1\n}",
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
      "name" : "startDate",
      "value" : "1565308800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "startDate 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "endDate",
      "value" : "1565308800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "endDate 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "email",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "source 只能为 email、meeting 或 search",
      "expression" : "^(email|meeting|search)?$",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "openeuler",
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
      "name" : "pageNum",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageNum 必须为正整数且不超过1000",
      "expression" : "pageNum > 0 && pageNum <= 1000",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "10",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过100",
      "expression" : "pageSize > 0 && pageSize <= 100",
      "children" : [ ]
    }, {
      "name" : "desc",
      "value" : "email_count",
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
      "value" : "1774317841428",
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
    } ]
  }
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.startDate);
Date end = timestamp2Date(body.endDate);
// 服务： 邮件-email,会议-meeting
var source = body.source; 
var page_num = 1;
if (body.pageNum != null and body.pageNum != ""){
    page_num = body.pageNum;
}
if (body.page_num != null and body.page_num != ""){
    page_num = body.page_num;
}
var page_size = 10;
if (body.pageSize != null and body.pageSize != ""){
    page_size = body.pageSize;
}
if (body.page_size != null and body.page_size != ""){
    page_size = body.page_size;
}
var offset = (page_num - 1) * page_size
var order_asc = "";
if (body.asc != null and body.asc != "") {
    order_asc = body.asc + " asc"
}
var order_desc = "";
if (body.desc != null and body.desc != "") {
    order_asc = body.desc + " desc"
}
var order_by = "";
if (order_asc != "" and order_desc != "") {
    order_by = order_asc + "," + order_desc;
} else {
    if (order_asc != "") {
        order_by = order_asc;
    }
    if (order_desc != "") {
        order_by = order_desc;
    }
}
// 指标类型：
// 邮件： email-邮件个数，topic-邮件主题个数，list-邮件列表个数，user-订阅人数
// 会议： meeting-会议个数，duration-会议时长，user-参会人数，sig-开会sig数
var group_by = '';
var metric_column = [];
if (source == 'email'){
    group_by = 'list_id';
    metric_column = [
        "count(CASE WHEN event_type = 'subscribe' THEN sender_email END) as subscribe_count",
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
    *,
    (select count(1) from dim_table) as total_count, 
    CEIL((select count(1) from dim_table)::numeric/#{page_size}) as total_page
FROM joined_data
<if test="order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset};
""";
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
return result

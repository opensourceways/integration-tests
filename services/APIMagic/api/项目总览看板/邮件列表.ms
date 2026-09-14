{
  "properties" : { },
  "id" : "534a362770274cdbaa0da59686962c08",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "邮件列表",
  "createTime" : null,
  "updateTime" : 1777360763838,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/email_list_info",
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
  "requestBody" : "{\r\n    \"start\":1757260800000,\r\n    \"end\":1763109024594,\r\n    \"community\":\"hifloat\",\r\n    \"list_name\": \"hifloat-spec@lists.gccorg.com\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1777360707930,\n    \"executeTime\": 7\n}",
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
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "",
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
      "name" : "list_name",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "list_name 格式非法",
      "expression" : "^[a-zA-Z0-9_.@\\-（）()]*$",
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
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "total_email_count",
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
        "name" : "email_count",
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
        "name" : "previous_email_count",
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
        "name" : "month_email_count",
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
        "name" : "month_previous_email_count",
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
        "name" : "email_week_relative_ratio",
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
        "name" : "email_month_relative_ratio",
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
        "name" : "total_subscriber_count",
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
        "name" : "subscriber_count",
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
        "name" : "previous_subscriber_count",
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
        "name" : "month_previous_subscriber_count",
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
        "name" : "subscriber_week_relative_ratio",
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
        "name" : "subscriber_month_relative_ratio",
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
    }, {
      "name" : "timestamp",
      "value" : "1758764879360",
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
      "value" : "5",
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
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// community
var community = body.community.toLowerCase();
var list_name = body.list_name;
var list_name_arr = list_name != null ? list_name.split("（"):[];
if(list_name_arr.size() == 2){
    list_name = repo_arr[1].split("）")[0];
}
var list_id = list_name.replace("@",".");
var week_email_list_table = "dws_"+community+"_list_email_week";
var month_email_list_table = "dws_"+community+"_list_email_month";
var regist_data_sql = """
    with week_data AS(
        SELECT 
          COALESCE(sum(email_count), 0) as email_count, 
          COALESCE(sum(total_email_count), 0) as total_email_count,
          COALESCE(sum(previous_email_count), 0) as previous_email_count, 
          <if test="list_id == null or list_id == ''">
            COALESCE(sum(unique_subscriber_count), 0) as subscriber_count,
            COALESCE(sum(total_unique_subscriber_count), 0) as total_subscriber_count,
            COALESCE(sum(previous_unique_subscriber_count), 0) as previous_subscriber_count
          </if>
          <if test="list_id != null and list_id != ''">
            COALESCE(sum(subscriber_count), 0) as subscriber_count,
            COALESCE(sum(total_subscriber_count), 0) as total_subscriber_count,
            COALESCE(sum(previous_subscriber_count), 0) as previous_subscriber_count
          </if>
        from ${week_email_list_table}
        where date::DATE BETWEEN date_trunc('week', CURRENT_DATE)::DATE AND date_trunc('week', CURRENT_DATE)::DATE
            <if test="list_id != null and list_id != ''">
                and list_id = #{list_id}
            </if>
    ),
    month_data as (
      SELECT 
          COALESCE(sum(email_count), 0) as email_count, 
          COALESCE(sum(previous_email_count), 0) as previous_email_count, 
          <if test="list_id == null or list_id == ''">
            COALESCE(sum(unique_subscriber_count), 0) as subscriber_count, 
            COALESCE(sum(previous_unique_subscriber_count), 0) as previous_subscriber_count
          </if>
          <if test="list_id != null and list_id != ''">
            COALESCE(sum(subscriber_count), 0) as subscriber_count, 
            COALESCE(sum(previous_subscriber_count), 0) as previous_subscriber_count
          </if>
        from ${month_email_list_table}
        where date::DATE BETWEEN date_trunc('month', CURRENT_DATE)::DATE AND date_trunc('month', CURRENT_DATE)::DATE
        <if test="list_id != null and list_id != ''">
            and list_id = #{list_id}
        </if>
    )
    SELECT 
        week_data.total_email_count, 
        week_data.email_count, 
        week_data.previous_email_count,
        month_data.email_count as month_email_count,
        month_data.previous_email_count as month_previous_email_count,
        (case when week_data.previous_email_count = 0 then 0 else ROUND((week_data.email_count - week_data.previous_email_count)::NUMERIC / week_data.previous_email_count, 4) end) as email_week_relative_ratio,
        (case when month_data.previous_email_count = 0 then 0 else ROUND((month_data.email_count - month_data.previous_email_count)::NUMERIC / month_data.previous_email_count, 4) end) as email_month_relative_ratio,
        week_data.total_subscriber_count, 
        week_data.subscriber_count, 
        week_data.previous_subscriber_count,
        month_data.previous_subscriber_count as month_previous_subscriber_count,
        (case when week_data.previous_subscriber_count = 0 then 0 else ROUND((week_data.subscriber_count - week_data.previous_subscriber_count)::NUMERIC / week_data.previous_subscriber_count, 4) end) as subscriber_week_relative_ratio,
        (case when month_data.previous_subscriber_count = 0 then 0 else ROUND((month_data.subscriber_count - month_data.previous_subscriber_count)::NUMERIC / month_data.previous_subscriber_count, 4) end) as subscriber_month_relative_ratio
    FROM week_data
    CROSS JOIN month_data;
  """;
var db_data = db.select(regist_data_sql)[0];
return db_data;

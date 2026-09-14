{
  "properties" : { },
  "id" : "55254f78b40d48e794183206d648bef0",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "forum论坛详情",
  "createTime" : null,
  "updateTime" : 1775633975241,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/forum/detail/page",
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
  "requestBody" : "{\"pageNum\":2,\"pageSize\":10,\"start\":1772323200000,\"end\":1774915200000,\"community\":\"cannopen\",\"asc\":\"\",\"desc\":\"\"}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1775633763568,\n    \"executeTime\": 14\n}",
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
      "name" : "pageNum",
      "value" : "2",
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
      "name" : "pageSize",
      "value" : "10",
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
      "name" : "start",
      "value" : "1772323200000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1774915200000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : "",
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
      "error" : "community 必须是纯字母，长度1-32",
      "expression" : "^[a-zA-Z]{1,32}$?",
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
      "expression" : "^(created_at|reply_num|browse_num|response_time)?$",
      "children" : [ ]
    }, {
      "name" : "desc",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "desc 字段非法",
      "expression" : "^(created_at|reply_num|browse_num|response_time)?$",
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
      "value" : "1775633763568",
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
      "value" : "14",
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
import magic;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// topn
var page_num = body.pageNum;
var page_size = body.pageSize;
// 社区
var community = body.community.toLowerCase();
if ("cannopen" == community){
    community = "cann"
}
// 社区
var title = body.title

var is_response = body.is_response
// 社区
var status = body.status
// 社区
var status = body.status
// 社区
var status = body.status
// page param
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
var order_by_set = new HashSet()
var order_asc = "";
if (body.asc != null and body.asc != "") {
    var asc_arr = body.asc.split(",");
    for(index,item in asc_arr){
        order_by_set.add(item + " asc");
    }
}
var order_desc = "";
if (body.desc != null and body.desc != "") {
    var desc_arr = body.desc.split(",");
    for(index,item in desc_arr){
        order_by_set.add(item + " desc");
    }
}
var order_by = "";
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
var topicTable = "fact_" + community + "_forum_topic";
var postTable = "fact_" + community + "_forum_post";
var userTable = "fact_" + community + "_forum_user";
var sql = """
with topic as (
  SELECT 
    id, title, url, created_at, author, user_name, reply_num, category_id, tags, status, accepted_at,
    CASE WHEN first_non_author_reply_at IS NOT NULL THEN 'y' ELSE 'n' END AS is_response,
    first_non_author_reply_at as first_reply_time, ROUND(first_reply_duration::NUMERIC / 86400, 2) as response_time, browse_num
  from ${topicTable}
  <where>
        <if test="start != null and start != ''">
            and created_at::date >= #{start}
        </if>
        <if test="end != null and end != ''">
            and created_at::date <= #{end}
        </if>
        <if test="title != null and title != ''">
            and title LIKE CONCAT('%', #{title}, '%')
        </if>
        <if test="author != null and author != ''">
            and author LIKE CONCAT('%', #{author}, '%')
        </if>
        <if test="status != null and status != ''">
            and status = #{status}
        </if>
        <if test="is_response != null and is_response == 'y'">
            and first_non_author_reply_at is not null
        </if>
        <if test="is_response != null and is_response == 'n'">
            and first_non_author_reply_at is null
        </if>
  </where>
),
post as (
  select topic_id, name, username, post_url
  from ${postTable}
  where accepted_answer = 'true'
),
user_author as (
  select user_name, company as author_company
  from ${userTable}
),
user_post_name as (
  select user_name, company as post_name_company
  from ${userTable}
),
agg_data as (
    select t.*, 
           p.name as post_name, p.post_url,
           ua.author_company,
           up.post_name_company
    from topic t 
    LEFT JOIN post p on t.id= p.topic_id
    LEFT JOIN user_author ua on t.user_name = ua.user_name
    LEFT JOIN user_post_name up on p.username = up.user_name
    <where>
            <if test="post_name != null and post_name != ''">
                and p.name LIKE CONCAT('%', #{post_name}, '%')
            </if>
    </where>
)
SELECT 
    *,
    (select count(1) from agg_data) as total_count, 
    CEIL((select count(1) from agg_data)::numeric/#{page_size}) as total_page
FROM 
    agg_data
<if test="order_by != null and order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset}
"""
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

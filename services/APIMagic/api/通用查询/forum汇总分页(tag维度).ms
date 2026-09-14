{
  "properties" : { },
  "id" : "copy1772526705903d8394",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "forum汇总分页(tag维度)",
  "createTime" : null,
  "updateTime" : 1774952557879,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/forum/tag/agg",
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
  "requestBody" : "{\r\n    \"start\":1767196800000,\r\n    \"end\":1767110400000,\r\n    \"group_dim\": \"category_tag\",\r\n    \"community\":\"opengauss\",\r\n    \"category_name\": \"\",\r\n    \"tag_name\":\"\",\r\n    \"asc\":\"\",\r\n    \"desc\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"sort_field\": \"count,reply_count,week_new_count,resolved_count,reply_ratio,one_day_reply_ratio,resolved_ratio\",\n        \"total_count\": 24,\n        \"total_page\": 3,\n        \"list\": [{\n            \"category_name\": \"社区公告\",\n            \"tag\": \"安装部署\",\n            \"count\": 0,\n            \"reply_count\": 0,\n            \"week_new_count\": 0,\n            \"resolved_count\": 0,\n            \"unreply_count\": 0,\n            \"unresolved_count\": 0,\n            \"reply_ratio\": 0,\n            \"one_day_reply_ratio\": 0,\n            \"resolved_ratio\": 0\n        }]}}",
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
      "value" : "1735660800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : null
    }, {
      "name" : "end",
      "value" : "1767110400000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : null
    }, {
      "name" : "group_dim",
      "value" : "category_tag",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "group_dim 参数非法",
      "expression" : "^(sub_community|category|tag|category_tag)?$",
      "children" : null
    }, {
      "name" : "community",
      "value" : "opengauss",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 必须是纯字母，长度1-32",
      "expression" : "^[a-zA-Z]{1,32}$?",
      "children" : null
    }, {
      "name" : "category_name",
      "value" : "问题求助",
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
      "name" : "tag_name",
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
      "expression" : "^(count|reply_count|week_new_count|resolved_count|unreply_count|unresolved_count|reply_ratio|one_day_reply_ratio|resolved_ratio)?$",
      "children" : null
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
      "expression" : "^(count|reply_count|week_new_count|resolved_count|unreply_count|unresolved_count|reply_ratio|one_day_reply_ratio|resolved_ratio)?$",
      "children" : null
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
        "name" : "sort_field",
        "value" : "count,reply_count,week_new_count,resolved_count,reply_ratio,one_day_reply_ratio,resolved_ratio",
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
        "name" : "total_count",
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
      }, {
        "name" : "total_page",
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
        "name" : "list",
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
            "name" : "category_name",
            "value" : "问题求助",
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
            "name" : "tag",
            "value" : "安装部署",
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
            "name" : "count",
            "value" : "39",
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
            "name" : "reply_count",
            "value" : "34",
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
            "name" : "week_new_count",
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
            "name" : "resolved_count",
            "value" : "9",
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
            "name" : "unreply_count",
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
          }, {
            "name" : "unresolved_count",
            "value" : "30",
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
            "name" : "reply_ratio",
            "value" : "0.8718",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "one_day_reply_ratio",
            "value" : "0.1026",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "resolved_ratio",
            "value" : "0.2308",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          } ]
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1772540844646",
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
      "value" : "18",
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
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import magic;

ZoneId zoneId = ZoneId.of("Asia/Shanghai");
LocalDate start = null;
if (body.start != null and body.start != '') {
    start = timestamp2Date(body.start);
}
LocalDate end = null;
if (body.end != null and body.end != '') {
    end = timestamp2Date(body.end);
}
if (end == null) {
    end = LocalDate.now(zoneId);
}
if (start == null) {
    start = end.minusDays(90);
}

LocalDate last7Start = end.minusDays(6);
LocalDate last7End = end;

var group_dim = body.group_dim;
var community = body.community;
if(community != 'opengauss' && community != 'openubmc'){
    return []
}
var no_sub_community = body.no_sub_community;
var category_name = body.category_name;
var categoryNameList = body.category_name_list;
var tag_name = body.tag_name;
var tagNameList = body.tag_name_list;

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

var sortList = ["count","reply_count","week_new_count","resolved_count","unreply_count","unresolved_count","reply_ratio","one_day_reply_ratio","resolved_ratio"];
var offset = (page_num - 1) * page_size;
var order_by_set = new HashSet();
var order_asc = "";
if (body.asc != null and body.asc != "") {
    var asc_arr = body.asc.split(",");
    for(index,item in asc_arr){
        if (sortList.contains(item)){
            order_by_set.add(item + " asc");
        }
    }
}
var order_desc = "";
if (body.desc != null and body.desc != "") {
    var desc_arr = body.desc.split(",");
    for(index,item in desc_arr){
        if (sortList.contains(item)){
            order_by_set.add(item + " desc");
        }
    }
}
var order_by = "";
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}

// openubmc 总览看板不再区分内/外部，与 opengauss 一致直接复用通用的
// dws_{community}_forum_category_tag_daily（由 CommunityForumCategoryTagTable 生成）
var contributeTable = "dws_" + community + "_forum_category_tag_daily";
var categoryTable = "fact_" + community + "_forum_category";
var tagTable = "fact_" + community + "_forum_tag";
var communityTable = "fact_community_structure";

var sql = """
WITH last_week_data AS (
    SELECT
        COALESCE(sum(topic_count), 0) as week_new_count
    FROM ${contributeTable}
    <where>
        date >= #{last7Start} and date <= #{last7End}
        <if test="no_sub_community != null and no_sub_community != ''">
            and sub_community != #{no_sub_community}
        </if>
        <if test="category_name != null and category_name != ''">
            and category_name LIKE CONCAT('%', #{category_name}, '%')
        </if>
        <if test="categoryNameList != null and categoryNameList.size() > 0">
            and category_name in
            <foreach collection="categoryNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="tag_name != null and tag_name != ''">
            and tag LIKE CONCAT('%', #{tag_name}, '%')
        </if>
        <if test="tagNameList != null and tagNameList.size() > 0">
            and tag in
            <foreach collection="tagNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
),
contribute_data AS (
    SELECT
        COALESCE(sum(topic_count), 0) as count, COALESCE(sum(reply_topic_count), 0) as reply_count,
        COALESCE(sum(resolved_topic_count), 0) as resolved_count,
        COALESCE(sum(topic_count), 0) - COALESCE(sum(reply_topic_count), 0) as unreply_count,
        COALESCE(sum(topic_count), 0) - COALESCE(sum(resolved_topic_count), 0) as unresolved_count,
        ROUND(
            CASE
                WHEN sum(topic_count) = 0 THEN 0
                ELSE (sum(reply_topic_count))::NUMERIC / sum(topic_count)
            END::NUMERIC , 4
        ) as reply_ratio,
        ROUND(
            CASE
                WHEN sum(topic_count) = 0 THEN 0
                ELSE (sum(one_day_response_topic_count))::NUMERIC / sum(topic_count)
            END::NUMERIC , 4
        ) as one_day_reply_ratio,
        ROUND(
            CASE
                WHEN sum(topic_count) = 0 THEN 0
                ELSE (sum(resolved_topic_count))::NUMERIC / sum(topic_count)
            END::NUMERIC , 4
        ) as resolved_ratio
    FROM ${contributeTable}
    <where>
        <if test="start != null ">
            and date >= #{start}
        </if>
        <if test="end != null ">
            and date <= #{end}
        </if>
        <if test="no_sub_community != null and no_sub_community != ''">
            and sub_community != #{no_sub_community}
        </if>
        <if test="category_name != null and category_name != ''">
            and category_name LIKE CONCAT('%', #{category_name}, '%')
        </if>
        <if test="categoryNameList != null and categoryNameList.size() > 0">
            and category_name in
            <foreach collection="categoryNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="tag_name != null and tag_name != ''">
            and tag LIKE CONCAT('%', #{tag_name}, '%')
        </if>
        <if test="tagNameList != null and tagNameList.size() > 0">
            and tag in
            <foreach collection="tagNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
)
SELECT
    *,
    (select count(1) from contribute_data) as total_count,
    CEIL((select count(1) from contribute_data)::numeric/#{page_size}) as total_page
FROM
    contribute_data, last_week_data
<if test="order_by != null and order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset}
""";

if (group_dim != null and group_dim != ''){
    sql = """
WITH dim AS (
    <if test="group_dim == 'sub_community'">
        SELECT name as sub_community FROM ${communityTable} where parent_name = #{community} and status = 'active'
    </if>
    <if test="group_dim == 'category'">
        SELECT name as category_name from ${categoryTable}
        <where>
            (parent_category_id IS NULL OR parent_category_id = '')
            <if test="category_name != null and category_name != ''">
                and name LIKE CONCAT('%', #{category_name}, '%')
            </if>
            <if test="categoryNameList != null and categoryNameList.size() > 0">
                and name in
                <foreach collection="categoryNameList" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
        </where>
    </if>
    <if test="group_dim == 'tag'">
        SELECT name as tag from ${tagTable}
        <where>
            <if test="tag_name != null and tag_name != ''">
                and name LIKE CONCAT('%', #{tag_name}, '%')
            </if>
            <if test="tagNameList != null and tagNameList.size() > 0">
                and name in
                <foreach collection="tagNameList" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
        </where>
    </if>
    <if test="group_dim == 'category_tag'">
        SELECT c.name as category_name, t.name as tag
        FROM ${categoryTable} c
        CROSS JOIN ${tagTable} t
        <where>
            (c.parent_category_id IS NULL OR c.parent_category_id = '')
            <if test="category_name != null and category_name != ''">
                and c.name LIKE CONCAT('%', #{category_name}, '%')
            </if>
            <if test="categoryNameList != null and categoryNameList.size() > 0">
                and c.name in
                <foreach collection="categoryNameList" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
            <if test="tag_name != null and tag_name != ''">
                and t.name LIKE CONCAT('%', #{tag_name}, '%')
            </if>
            <if test="tagNameList != null and tagNameList.size() > 0">
                and t.name in
                <foreach collection="tagNameList" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
        </where>
    </if>
),
last_week_data AS (
    SELECT
        <if test="group_dim == 'sub_community'">
            sub_community,
        </if>
        <if test="group_dim == 'category'">
            category_name,
        </if>
        <if test="group_dim == 'tag'">
            tag,
        </if>
        <if test="group_dim == 'category_tag'">
            category_name, tag,
        </if>
        COALESCE(sum(topic_count), 0) as week_new_count,
        ROUND(
            CASE
                WHEN sum(topic_count) = 0 THEN 0
                ELSE (sum(one_day_response_topic_count))::NUMERIC / sum(topic_count)
            END::NUMERIC , 4
        ) as one_day_reply_ratio,
        ROUND(
            CASE
                WHEN sum(topic_count) = 0 THEN 0
                ELSE (sum(resolved_topic_count))::NUMERIC / sum(topic_count)
            END::NUMERIC , 4
        ) as resolved_ratio
    FROM ${contributeTable}
    <where>
        date >= #{last7Start} and date <= #{last7End}
        <if test="no_sub_community != null and no_sub_community != ''">
            and sub_community != #{no_sub_community}
        </if>
        <if test="category_name != null and category_name != ''">
            and category_name LIKE CONCAT('%', #{category_name}, '%')
        </if>
        <if test="categoryNameList != null and categoryNameList.size() > 0">
            and category_name in
            <foreach collection="categoryNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="tag_name != null and tag_name != ''">
            and tag LIKE CONCAT('%', #{tag_name}, '%')
        </if>
        <if test="tagNameList != null and tagNameList.size() > 0">
            and tag in
            <foreach collection="tagNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
    <if test="group_dim == 'sub_community'">
        group by sub_community
    </if>
    <if test="group_dim == 'category'">
        group by category_name
    </if>
    <if test="group_dim == 'tag'">
        group by tag
    </if>
    <if test="group_dim == 'category_tag'">
        group by category_name, tag
    </if>
),
contribute_data AS (
    SELECT
        <if test="group_dim == 'sub_community'">
            sub_community,
        </if>
        <if test="group_dim == 'category'">
            category_name,
        </if>
        <if test="group_dim == 'tag'">
            tag,
        </if>
        <if test="group_dim == 'category_tag'">
            category_name, tag,
        </if>
        COALESCE(sum(topic_count), 0) as count, COALESCE(sum(reply_topic_count), 0) as reply_count,
        COALESCE(sum(resolved_topic_count), 0) as resolved_count,
        COALESCE(sum(topic_count), 0) - COALESCE(sum(reply_topic_count), 0) as unreply_count,
        COALESCE(sum(topic_count), 0) - COALESCE(sum(resolved_topic_count), 0) as unresolved_count,
        ROUND(
            CASE
                WHEN sum(topic_count) = 0 THEN 0
                ELSE (sum(reply_topic_count))::NUMERIC / sum(topic_count)
            END::NUMERIC , 4
        ) as reply_ratio,
        ROUND(
            CASE
                WHEN sum(topic_count) = 0 THEN 0
                ELSE (sum(one_day_response_topic_count))::NUMERIC / sum(topic_count)
            END::NUMERIC , 4
        ) as one_day_reply_ratio,
        ROUND(
            CASE
                WHEN sum(topic_count) = 0 THEN 0
                ELSE (sum(resolved_topic_count))::NUMERIC / sum(topic_count)
            END::NUMERIC , 4
        ) as resolved_ratio
    FROM ${contributeTable}
    <where>
        <if test="start != null ">
            and date >= #{start}
        </if>
        <if test="end != null ">
            and date <= #{end}
        </if>
        <if test="no_sub_community != null and no_sub_community != ''">
            and sub_community != #{no_sub_community}
        </if>
        <if test="category_name != null and category_name != ''">
            and category_name LIKE CONCAT('%', #{category_name}, '%')
        </if>
        <if test="categoryNameList != null and categoryNameList.size() > 0">
            and category_name in
            <foreach collection="categoryNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="tag_name != null and tag_name != ''">
            and tag LIKE CONCAT('%', #{tag_name}, '%')
        </if>
        <if test="tagNameList != null and tagNameList.size() > 0">
            and tag in
            <foreach collection="tagNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
    <if test="group_dim == 'sub_community'">
        group by sub_community
    </if>
    <if test="group_dim == 'category'">
        group by category_name
    </if>
    <if test="group_dim == 'tag'">
        group by tag
    </if>
    <if test="group_dim == 'category_tag'">
        group by category_name, tag
    </if>
),
group_data AS (
    SELECT
        <if test="group_dim == 'sub_community'">
            d.sub_community,
        </if>
        <if test="group_dim == 'category'">
            d.category_name,
        </if>
        <if test="group_dim == 'tag'">
            d.tag,
        </if>
        <if test="group_dim == 'category_tag'">
            d.category_name, d.tag,
        </if>
        COALESCE(c.count, 0) as count, COALESCE(c.reply_count, 0) as reply_count,
        COALESCE(lwd.week_new_count, 0) as week_new_count,
        COALESCE(c.resolved_count, 0) as resolved_count,
        COALESCE(c.unreply_count, 0) as unreply_count,
        COALESCE(c.unresolved_count, 0) as unresolved_count,
        COALESCE(c.reply_ratio, 0) as reply_ratio,
        -- 「本周24小时首次响应率」「本周闭环率」取近 7 天窗口（与前端展示的「本周」列一致）；
        -- 排序须与展示值同源，否则按 one_day_reply_ratio/resolved_ratio 排序时，
        -- 0% 行会因排序键(全周期)≠展示值(近 7 天)而夹在中间（issue#312）。
        COALESCE(lwd.one_day_reply_ratio, 0) as one_day_reply_ratio,
        COALESCE(lwd.resolved_ratio, 0) as resolved_ratio
    FROM dim d
    LEFT JOIN contribute_data c
        <if test="group_dim == 'sub_community'">
            ON d.sub_community = c.sub_community
        </if>
        <if test="group_dim == 'category'">
            ON d.category_name = c.category_name
        </if>
        <if test="group_dim == 'tag'">
            ON d.tag = c.tag
        </if>
        <if test="group_dim == 'category_tag'">
            ON d.category_name = c.category_name and d.tag = c.tag
        </if>
    LEFT JOIN last_week_data lwd
        <if test="group_dim == 'sub_community'">
            ON d.sub_community = lwd.sub_community
        </if>
        <if test="group_dim == 'category'">
            ON d.category_name = lwd.category_name
        </if>
        <if test="group_dim == 'tag'">
            ON d.tag = lwd.tag
        </if>
        <if test="group_dim == 'category_tag'">
            ON d.category_name = lwd.category_name and d.tag = lwd.tag
        </if>
)
SELECT
    *,
    (select count(1) from group_data) as total_count,
    CEIL((select count(1) from group_data)::numeric/#{page_size}) as total_page
FROM
    group_data
<if test="order_by != null and order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset}
""";
}

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
result.put("sort_field","count,reply_count,week_new_count,resolved_count,reply_ratio,one_day_reply_ratio,resolved_ratio");
return result
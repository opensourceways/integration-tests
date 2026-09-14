{

  "properties" : { },

  "id" : "copy1772415772188d93389",

  "script" : null,

  "groupId" : "39c33765c93e4af089275fbe9ae18d07",

  "name" : "forum汇总分页",

  "createTime" : null,

  "updateTime" : 1773805179431,

  "lock" : null,

  "createBy" : null,

  "updateBy" : "admin",

  "path" : "/forum/agg",

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

  "requestBody" : "{\r\n    \"start\":1735660800000,\r\n    \"end\":1767110400000,\r\n    \"group_dim\": \"category\",\r\n    \"community\":\"opengauss\",\r\n    \"issue_type\": \"\",\r\n    \"issue_type_list\": [],\r\n    \"namespace\":\"\",\r\n    \"repo_path\":\"\",\r\n    \"source\": \"\",\r\n    \"internalList\": [],\r\n    \"private\": \"false\",\r\n    \"asc\":\"case when current_user like 'onedate%' then addcode_total else pr_total end\",\r\n    \"desc\":\"open_count\"\r\n}",

  "headers" : [ ],

  "paths" : [ ],

  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1773305251451,\n    \"executeTime\": 1\n}",

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

      "value" : "openeuler",

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

      "name" : "namespace",

      "value" : "openeuler",

      "description" : "",

      "required" : false,

      "dataType" : "String",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "pattern",

      "error" : "",

      "expression" : "^[a-zA-Z0-9_]{0,50}$",

      "children" : [ ]

    }, {

      "name" : "repo_path",

      "value" : "kernel",

      "description" : "",

      "required" : false,

      "dataType" : "String",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "pattern",

      "error" : "",

      "expression" : "^[a-zA-Z0-9_]{0,50}$",

      "children" : [ ]

    }, {

      "name" : "title",

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

      "name" : "label",

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

      "name" : "response",

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

      "name" : "assginee",

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

      "name" : "issue_type",

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

      "name" : "issue_type_list",

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

        "value" : "缺陷",

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

      "name" : "state",

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

      "name" : "priority",

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

      "name" : "is_response",

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

      "name" : "pageNum",

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

      "value" : "1565280000000",

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

      "name" : "end",

      "value" : "1764325337863",

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

      "name" : "asc",

      "value" : "open_time",

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

      "value" : "401",

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

      "value" : "用户未登录",

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

      "value" : "1773305174048",

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
import '@/util/timestamp2Date' as timestamp2Date;
import  magic;
Date start = null;
if (body.start != null and body.start != '') {
    start = timestamp2Date(body.start);
}
Date end = null;
if (body.end != null and body.end != '') {
    end = timestamp2Date(body.end);
}
Date today = end
// 最近7天
LocalDate last7Start = today.minusDays(6);
LocalDate last7End = today;
// 聚合维度
var group_dim = body.group_dim;
// 社区
var community = body.community;
if(community  != 'opengauss'){
    return []
}
// 子社区
var no_sub_community = body.no_sub_community;
// 帖子类型
var category_name = body.category_name;
// 帖子类型数组
var categoryNameList = body.category_name_list;
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
var sortList = ["count","reply_count","week_new_count","resolved_count","unreply_count","unresolved_count","reply_ratio","one_day_reply_ratio","resolved_ratio"]
var offset = (page_num - 1) * page_size
var order_by_set = new HashSet()
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
var contributeTable = "dws_" + community + "_forum_category_daily";
var categoryTable = "fact_" + community + "_forum_category";
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
        WITH dim as (
            <if test="group_dim == 'sub_community'">
                SELECT name as sub_community FROM ${communityTable} where parent_name = #{community} and status = 'active'
            </if>
            <if test="group_dim == 'category'">
                SELECT name as category_name from ${categoryTable}
                <if test="category_name != null and category_name != ''">
                    and name LIKE CONCAT('%', #{category_name}, '%')
                </if>
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
            </where>
            <if test="group_dim == 'sub_community'">
                group by sub_community
            </if>
            <if test="group_dim == 'category'">
                group by category_name
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
            </where>
            <if test="group_dim == 'sub_community'">
                group by sub_community
            </if>
            <if test="group_dim == 'category'">
                group by category_name
            </if>
        ),
        group_data as (
            select
                <if test="group_dim == 'sub_community'">
                    d.sub_community,   
                </if>     
                <if test="group_dim == 'category'">
                    d.category_name,
                </if>
                COALESCE(count, 0) as count, COALESCE(reply_count, 0) as reply_count,
                COALESCE(week_new_count, 0) as week_new_count,
                COALESCE(resolved_count, 0) as resolved_count, 
                COALESCE(unreply_count, 0) as unreply_count, 
                COALESCE(unresolved_count, 0) as unresolved_count, 
                COALESCE(reply_ratio, 0) as reply_ratio, 
                COALESCE(one_day_reply_ratio, 0) as one_day_reply_ratio, 
                COALESCE(resolved_ratio, 0) as resolved_ratio
            FROM dim d
            LEFT JOIN contribute_data c 
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = c.sub_community
            </if>     
            <if test="group_dim == 'category'">
                ON d.category_name = c.category_name
            </if>
            LEFT JOIN last_week_data lwd
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = lwd.sub_community
                ORDER BY d.sub_community
            </if>     
            <if test="group_dim == 'category'">
                ON d.category_name = lwd.category_name
                ORDER BY d.category_name
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

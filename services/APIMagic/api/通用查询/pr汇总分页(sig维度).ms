{
  "properties" : { },
  "id" : "copy1770636441701d15577",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "pr汇总分页(sig维度)",
  "createTime" : null,
  "updateTime" : 1774689699421,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/prs/agg/sig",
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
  "requestBody" : "{\r\n    \"start\":1735660800000,\r\n    \"end\":1767110400000,\r\n    \"group_dim\": \"sig\",\r\n    \"pr_type\":\"\",\r\n    \"community\":\"opengauss\",\r\n    \"namespace\":\"\",\r\n    \"sig_name\":\"CM\",\r\n    \"private\": \"false\",\r\n    \"asc\":\"\",\r\n    \"desc\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"sort_field\": \"count,open_count,closed_count,merged_count\",\n        \"total_count\": 28,\n        \"total_page\": 3,\n        \"list\": [{\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"AI\",\n            \"pr_type\": \"All\",\n            \"count\": 678,\n            \"open_count\": 67,\n            \"week_new_count\": 0,\n            \"unresponse_open_count\": 46,\n            \"merged_count\": 515,\n            \"closed_count\": 83,\n            \"unclosed_count\": 67,\n            \"closed_ratio\": 0.9012,\n            \"avg_first_reply_time\": 16.23,\n            \"avg_closed_time\": 24.08,\n            \"avg_overdue_first_reply_time\": 15.58,\n            \"avg_overdue_closed_time\": 18.29,\n            \"eight_hour_response_ratio\": 0.29,\n            \"one_day_response_ratio\": 0.48,\n            \"five_day_closed_ratio\": 0.08,\n            \"seven_day_closed_ratio\": 0.08,\n            \"comment_num\": 2.39\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"Blockchain\",\n            \"pr_type\": \"All\",\n            \"count\": 0,\n            \"open_count\": 0,\n            \"week_new_count\": 0,\n            \"unresponse_open_count\": 0,\n            \"merged_count\": 0,\n            \"closed_count\": 0,\n            \"unclosed_count\": 0,\n            \"closed_ratio\": 0,\n            \"avg_first_reply_time\": 0,\n            \"avg_closed_time\": 0,\n            \"avg_overdue_first_reply_time\": 0,\n            \"avg_overdue_closed_time\": 0,\n            \"eight_hour_response_ratio\": 0,\n            \"one_day_response_ratio\": 0,\n            \"five_day_closed_ratio\": 0,\n            \"seven_day_closed_ratio\": 0,\n            \"comment_num\": 0\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"Certification\",\n            \"pr_type\": \"All\",\n            \"count\": 11,\n            \"open_count\": 4,\n            \"week_new_count\": 0,\n            \"unresponse_open_count\": 3,\n            \"merged_count\": 6,\n            \"closed_count\": 1,\n            \"unclosed_count\": 4,\n            \"closed_ratio\": 0.6364,\n            \"avg_first_reply_time\": 69.17,\n            \"avg_closed_time\": 98.76,\n            \"avg_overdue_first_reply_time\": 68.71,\n            \"avg_overdue_closed_time\": 83.05,\n            \"eight_hour_response_ratio\": 0.45,\n            \"one_day_response_ratio\": 0.45,\n            \"five_day_closed_ratio\": 0.00,\n            \"seven_day_closed_ratio\": 0.00,\n            \"comment_num\": 0.00\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"CloudNative\",\n            \"pr_type\": \"All\",\n            \"count\": 680,\n            \"open_count\": 67,\n            \"week_new_count\": 0,\n            \"unresponse_open_count\": 46,\n            \"merged_count\": 515,\n            \"closed_count\": 84,\n            \"unclosed_count\": 67,\n            \"closed_ratio\": 0.9015,\n            \"avg_first_reply_time\": 16.43,\n            \"avg_closed_time\": 24.31,\n            \"avg_overdue_first_reply_time\": 15.79,\n            \"avg_overdue_closed_time\": 18.40,\n            \"eight_hour_response_ratio\": 0.30,\n            \"one_day_response_ratio\": 0.49,\n            \"five_day_closed_ratio\": 0.08,\n            \"seven_day_closed_ratio\": 0.08,\n            \"comment_num\": 2.39\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"CM\",\n            \"pr_type\": \"All\",\n            \"count\": 1170,\n            \"open_count\": 142,\n            \"week_new_count\": 0,\n            \"unresponse_open_count\": 107,\n            \"merged_count\": 867,\n            \"closed_count\": 155,\n            \"unclosed_count\": 142,\n            \"closed_ratio\": 0.8786,\n            \"avg_first_reply_time\": 25.90,\n            \"avg_closed_time\": 33.89,\n            \"avg_overdue_first_reply_time\": 25.29,\n            \"avg_overdue_closed_time\": 27.71,\n            \"eight_hour_response_ratio\": 0.34,\n            \"one_day_response_ratio\": 0.50,\n            \"five_day_closed_ratio\": 0.08,\n            \"seven_day_closed_ratio\": 0.08,\n            \"comment_num\": 1.72\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"Connectors\",\n            \"pr_type\": \"All\",\n            \"count\": 83,\n            \"open_count\": 3,\n            \"week_new_count\": 0,\n            \"unresponse_open_count\": 2,\n            \"merged_count\": 75,\n            \"closed_count\": 5,\n            \"unclosed_count\": 3,\n            \"closed_ratio\": 0.9639,\n            \"avg_first_reply_time\": 7.68,\n            \"avg_closed_time\": 11.94,\n            \"avg_overdue_first_reply_time\": 7.24,\n            \"avg_overdue_closed_time\": 8.41,\n            \"eight_hour_response_ratio\": 0.53,\n            \"one_day_response_ratio\": 0.60,\n            \"five_day_closed_ratio\": 0.02,\n            \"seven_day_closed_ratio\": 0.02,\n            \"comment_num\": 1.83\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"CTMM\",\n            \"pr_type\": \"All\",\n            \"count\": 0,\n            \"open_count\": 0,\n            \"week_new_count\": 0,\n            \"unresponse_open_count\": 0,\n            \"merged_count\": 0,\n            \"closed_count\": 0,\n            \"unclosed_count\": 0,\n            \"closed_ratio\": 0,\n            \"avg_first_reply_time\": 0,\n            \"avg_closed_time\": 0,\n            \"avg_overdue_first_reply_time\": 0,\n            \"avg_overdue_closed_time\": 0,\n            \"eight_hour_response_ratio\": 0,\n            \"one_day_response_ratio\": 0,\n            \"five_day_closed_ratio\": 0,\n            \"seven_day_closed_ratio\": 0,\n            \"comment_num\": 0\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"DBCopilot\",\n            \"pr_type\": \"All\",\n            \"count\": 2,\n            \"open_count\": 1,\n            \"week_new_count\": 0,\n            \"unresponse_open_count\": 1,\n            \"merged_count\": 1,\n            \"closed_count\": 0,\n            \"unclosed_count\": 1,\n            \"closed_ratio\": 0.5000,\n            \"avg_first_reply_time\": 65.97,\n            \"avg_closed_time\": 65.97,\n            \"avg_overdue_first_reply_time\": 65.39,\n            \"avg_overdue_closed_time\": 64.89,\n            \"eight_hour_response_ratio\": 0.50,\n            \"one_day_response_ratio\": 0.50,\n            \"five_day_closed_ratio\": 0.00,\n            \"seven_day_closed_ratio\": 0.00,\n            \"comment_num\": 0.00\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"DCF\",\n            \"pr_type\": \"All\",\n            \"count\": 14,\n            \"open_count\": 8,\n            \"week_new_count\": 0,\n            \"unresponse_open_count\": 7,\n            \"merged_count\": 6,\n            \"closed_count\": 1,\n            \"unclosed_count\": 8,\n            \"closed_ratio\": 0.4286,\n            \"avg_first_reply_time\": 166.88,\n            \"avg_closed_time\": 188.70,\n            \"avg_overdue_first_reply_time\": 165.96,\n            \"avg_overdue_closed_time\": 170.07,\n            \"eight_hour_response_ratio\": 0.07,\n            \"one_day_response_ratio\": 0.14,\n            \"five_day_closed_ratio\": 0.00,\n            \"seven_day_closed_ratio\": 0.00,\n            \"comment_num\": 0.00\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"Docs\",\n            \"pr_type\": \"All\",\n            \"count\": 1273,\n            \"open_count\": 26,\n            \"week_new_count\": 2,\n            \"unresponse_open_count\": 13,\n            \"merged_count\": 1176,\n            \"closed_count\": 89,\n            \"unclosed_count\": 26,\n            \"closed_ratio\": 0.9796,\n            \"avg_first_reply_time\": 4.91,\n            \"avg_closed_time\": 7.22,\n            \"avg_overdue_first_reply_time\": 4.58,\n            \"avg_overdue_closed_time\": 4.74,\n            \"eight_hour_response_ratio\": 0.62,\n            \"one_day_response_ratio\": 0.75,\n            \"five_day_closed_ratio\": 0.05,\n            \"seven_day_closed_ratio\": 0.05,\n            \"comment_num\": 0.46\n        }]\n    },\n    \"timestamp\": 1770636668407,\n    \"executeTime\": 15\n}",
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
      "value" : "1730419200000",
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
      "name" : "start",
      "value" : "1730419200000",
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
      "value" : "1764215445119",
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
      "value" : "sub_community",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "group_dim 只能为 sub_community 或 sig",
      "expression" : "^(sub_community|sig)?$",
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
    } ]
  },
  "responseBodyDefinition" : null
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
// 组织
var namespace = body.namespace;
// 服务平台
var source = body.source;
// 内外部
var internalList = body.internalList;
// 是否私仓
var private = body.private;
// PR类型
var pr_type = body.pr_type;
// 仓库
var sig_name = body.sig_name;
var sigNameList = body.sig_name_list;
// 责任人
var assginee = body.assginee;
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
var contributeTable = "dws_" + community + "_pr_contribute_sig_daily";
var sigTable = "fact_" + community + "_sig_user";
var communityTable = "fact_community_structure";
var sql = """
WITH last_week_data AS (
    SELECT       
        COALESCE(sum(open_pr_incre), 0) as total_open_count
    FROM ${contributeTable}
    <where>
        <if test="namespace != null and namespace != ''">
            and namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="sig_name != null and sig_name != ''">
            and sig_name LIKE CONCAT('%', #{sig_name}, '%')
        </if>
        <if test="sigNameList != null and sigNameList.size() > 0">
            and sig_name in
            <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="source != null and source != ''">
            and source = #{source}
        </if>
        <if test="private != null and private != ''">
            and private = #{private}
        </if>
        <if test="pr_type != null and pr_type != ''">
            and super_issue_type = #{pr_type}
        </if>
        <if test="internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
),
contribute_data AS (
    SELECT       
        COALESCE(sum(pr_incre), 0) as count, COALESCE(sum(open_pr_incre), 0) as open_count,
        COALESCE(sum(unresponse_open_pr_incre), 0) as unresponse_open_count, 
        COALESCE(sum(closed_pr_incre), 0) as closed_count, 
        COALESCE(sum(open_pr_incre), 0) as unclosed_count,
        COALESCE(sum(merged_pr_incre), 0) as merged_count, 
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE (sum(pr_incre) - sum(open_pr_incre))::NUMERIC / sum(pr_incre)
            END::NUMERIC , 4
        ) as closed_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(first_reply_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_first_reply_time,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(closed_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_closed_time,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(overdue_first_reply_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_overdue_first_reply_time,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(overdue_closed_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 2
        ) as avg_overdue_closed_time,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(eight_hour_response_pr_incre)::NUMERIC / sum(pr_incre)
            END::NUMERIC , 2
        ) as eight_hour_response_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(one_day_response_pr_incre)::NUMERIC / sum(pr_incre)
            END::NUMERIC , 2
        ) as one_day_response_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(five_day_closed_pr_incre)::NUMERIC / sum(pr_incre)
            END::NUMERIC , 2
        ) as five_day_closed_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(seven_day_closed_pr_incre)::NUMERIC / sum(pr_incre)
            END::NUMERIC , 2
        ) as seven_day_closed_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(comment_num)::NUMERIC / sum(pr_incre)
            END::NUMERIC , 2
        ) as comment_num
    FROM ${contributeTable}
    <where>
        <if test="start != null ">
            and date >= #{start}
        </if>
        <if test="end != null ">
            and date <= #{end}
        </if>
        <if test="namespace != null and namespace != ''">
            and namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="sig_name != null and sig_name != ''">
            and sig_name LIKE CONCAT('%', #{sig_name}, '%')
        </if>
        <if test="sigNameList != null and sigNameList.size() > 0">
            and sig_name in
            <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="source != null and source != ''">
            and source = #{source}
        </if>
        <if test="private != null and private != ''">
            and private = #{private}
        </if>
        <if test="pr_type != null and pr_type != ''">
            and super_issue_type = #{pr_type}
        </if>
        <if test="internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
)
SELECT 
    cd.*, lwd.total_open_count as total_open_count,
    (select count(1) from contribute_data) as total_count, 
    CEIL((select count(1) from contribute_data)::numeric/#{page_size}) as total_page
FROM 
    contribute_data cd, last_week_data lwd
<if test="order_by != null and order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset}
""";
if (group_dim != null and group_dim != ''){
    sql = """
        WITH dim_sig as (
            SELECT distinct platform, namespace, sig_name from ${sigTable} where is_hide is null
            union all
            select 'gitcode' as platform, 'opengauss' as namespace, 'openGauss-server' as sig_name
        ), 
        dim as (
            <if test="group_dim == 'sub_community'">
                SELECT name as sub_community FROM ${communityTable} where parent_name = #{community} and status = 'active'
            </if>
            <if test="group_dim == 'sig'">
                SELECT platform, namespace, sig_name from dim_sig where 1=1
                <if test="source != null and source != ''">
                    and platform = #{source}
                </if>
                <if test="sig_name != null and sig_name != ''">
                    and sig_name LIKE CONCAT('%', #{sig_name}, '%')
                </if>
                <if test="sigNameList != null and sigNameList.size() > 0">
                    and sig_name in
                    <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
            </if>
        ),
        last_week_data AS (
            SELECT
                <if test="group_dim == 'sub_community'">
                    sub_community,   
                </if>     
                <if test="group_dim == 'sig'">
                    namespace, sig_name,
                </if>             
                <if test="pr_type != null and pr_type != ''">
                    super_issue_type as pr_type,
                </if> 
                COALESCE(sum(open_pr_incre), 0) as total_open_count
            FROM ${contributeTable}
            <where>
                <if test="namespace != null and namespace != ''">
                    and namespace LIKE CONCAT('%', #{namespace}, '%')
                </if>
                <if test="sig_name != null and sig_name != ''">
                    and sig_name LIKE CONCAT('%', #{sig_name}, '%')
                </if>
                <if test="sigNameList != null and sigNameList.size() > 0">
                    and sig_name in
                    <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
                <if test="source != null and source != ''">
                    and source = #{source}
                </if>
                <if test="private != null and private != ''">
                    and private = #{private}
                </if>
                <if test="pr_type != null and pr_type != ''">
                    and super_issue_type = #{pr_type}
                </if>
                <if test="internalList != null and internalList.size() > 0">
                    and internal in
                    <foreach collection="internalList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
            </where>
            <if test="group_dim == 'sub_community'">
                group by sub_community
                <if test="pr_type != null and pr_type != ''">
                    ,super_issue_type
                </if>
            </if>
            <if test="group_dim == 'sig'">
                group by namespace, sig_name
                <if test="pr_type != null and pr_type != ''">
                    ,super_issue_type
                </if>
            </if>
        ),
        contribute_data AS (
            SELECT
                <if test="group_dim == 'sub_community'">
                    sub_community,   
                </if>     
                <if test="group_dim == 'sig'">
                    namespace, sig_name,
                </if>             
                <if test="pr_type != null and pr_type != ''">
                    super_issue_type as pr_type,
                </if> 
                COALESCE(sum(pr_incre), 0) as count, COALESCE(sum(open_pr_incre), 0) as open_count,
                COALESCE(sum(unresponse_open_pr_incre), 0) as unresponse_open_count, 
                COALESCE(sum(closed_pr_incre), 0) as closed_count, 
                COALESCE(sum(open_pr_incre), 0) as unclosed_count,
                COALESCE(sum(merged_pr_incre), 0) as merged_count, 
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE (sum(pr_incre) - sum(open_pr_incre))::NUMERIC / sum(pr_incre)
                    END::NUMERIC , 4
                ) as closed_ratio,
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE sum(first_reply_time)::NUMERIC / sum(pr_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_first_reply_time,
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE sum(closed_time)::NUMERIC / sum(pr_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_closed_time,
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE sum(overdue_first_reply_time)::NUMERIC / sum(pr_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_overdue_first_reply_time,
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE sum(overdue_closed_time)::NUMERIC / sum(pr_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_overdue_closed_time,
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE sum(eight_hour_response_pr_incre)::NUMERIC / sum(pr_incre)
                    END::NUMERIC , 2
                ) as eight_hour_response_ratio,
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE sum(one_day_response_pr_incre)::NUMERIC / sum(pr_incre)
                    END::NUMERIC , 2
                ) as one_day_response_ratio,
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE sum(five_day_closed_pr_incre)::NUMERIC / sum(pr_incre)
                    END::NUMERIC , 2
                ) as five_day_closed_ratio,
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE sum(seven_day_closed_pr_incre)::NUMERIC / sum(pr_incre)
                    END::NUMERIC , 2
                ) as seven_day_closed_ratio,
                ROUND(
                    CASE
                        WHEN sum(pr_incre) = 0 THEN 0
                        ELSE sum(comment_num)::NUMERIC / sum(pr_incre)
                    END::NUMERIC , 2
                ) as comment_num
            FROM ${contributeTable}
            <where>
                <if test="start != null ">
                    and date >= #{start}
                </if>
                <if test="end != null ">
                    and date <= #{end}
                </if>
                <if test="namespace != null and namespace != ''">
                    and namespace LIKE CONCAT('%', #{namespace}, '%')
                </if>
                <if test="sig_name != null and sig_name != ''">
                    and sig_name LIKE CONCAT('%', #{sig_name}, '%')
                </if>
                <if test="sigNameList != null and sigNameList.size() > 0">
                    and sig_name in
                    <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
                <if test="source != null and source != ''">
                    and source = #{source}
                </if>
                <if test="private != null and private != ''">
                    and private = #{private}
                </if>
                <if test="pr_type != null and pr_type != ''">
                    and super_issue_type = #{pr_type}
                </if>
                <if test="internalList != null and internalList.size() > 0">
                    and internal in
                    <foreach collection="internalList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
            </where>
            <if test="group_dim == 'sub_community'">
                group by sub_community
                <if test="pr_type != null and pr_type != ''">
                    ,super_issue_type
                </if>
            </if>
            <if test="group_dim == 'sig'">
                group by namespace, sig_name
                <if test="pr_type != null and pr_type != ''">
                    ,super_issue_type
                </if>
            </if>
        ),
        group_data as (
            select
                <if test="group_dim == 'sub_community'">
                    d.sub_community,   
                </if>     
                <if test="group_dim == 'sig'">
                    d.namespace, d.sig_name,
                </if>                 
                <if test="pr_type == null or pr_type == ''">
                    'All' as pr_type,
                </if> 
                <if test="pr_type != null and pr_type != ''">
                    #{pr_type} as pr_type,
                </if>  
                COALESCE(c.count, 0) as count, COALESCE(c.open_count, 0) as open_count,
                COALESCE(lwd.total_open_count, 0) as total_open_count,
                COALESCE(c.unresponse_open_count, 0) as unresponse_open_count, 
                COALESCE(c.merged_count, 0) as merged_count, 
                COALESCE(c.closed_count, 0) as closed_count, 
                COALESCE(c.unclosed_count, 0) as unclosed_count, 
                COALESCE(c.closed_ratio, 0) as closed_ratio, 
                COALESCE(c.avg_first_reply_time, 0) as avg_first_reply_time, 
                COALESCE(c.avg_closed_time, 0) as avg_closed_time, 
                COALESCE(c.avg_overdue_first_reply_time, 0) as avg_overdue_first_reply_time, 
                COALESCE(c.avg_overdue_closed_time, 0) as avg_overdue_closed_time,
                COALESCE(c.eight_hour_response_ratio, 0) as eight_hour_response_ratio, 
                COALESCE(c.one_day_response_ratio, 0) as one_day_response_ratio, 
                COALESCE(c.five_day_closed_ratio, 0) as five_day_closed_ratio, 
                COALESCE(c.seven_day_closed_ratio, 0) as seven_day_closed_ratio, 
                COALESCE(c.comment_num, 0) as comment_num
            FROM dim d
            LEFT JOIN contribute_data c 
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = c.sub_community
            </if>     
            <if test="group_dim == 'sig'">
                ON d.namespace = c.namespace and d.sig_name = c.sig_name
            </if>
            LEFT JOIN last_week_data lwd
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = lwd.sub_community
                ORDER BY d.sub_community
            </if>     
            <if test="group_dim == 'sig'">
                ON d.namespace = lwd.namespace and d.sig_name = lwd.sig_name
                ORDER BY d.sig_name
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
result.put("sort_field","count,open_count,closed_count,merged_count");
return result

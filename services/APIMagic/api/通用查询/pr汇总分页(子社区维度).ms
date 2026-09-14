{

  "properties" : { },

  "id" : "subcomm1368prsagg9b4e2f7c1d6a",

  "script" : null,

  "groupId" : "39c33765c93e4af089275fbe9ae18d07",

  "name" : "pr汇总分页(子社区维度)",

  "createTime" : null,

  "updateTime" : 1772416798122,

  "lock" : null,

  "createBy" : null,

  "updateBy" : "admin",

  "path" : "/prs/agg/sub_community",

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

  "requestBody" : "{\r\n    \"start\":1735660800000,\r\n    \"end\":1767110400000,\r\n    \"group_dim\": \"\",\r\n    \"pr_type\":\"\",\r\n    \"community\":\"openubmc\",\r\n    \"namespace\":\"\",\r\n    \"repo\":\"\",\r\n    \"repo_path_list\": [],\r\n    \"private\": \"false\",\r\n    \"asc\":\"123\",\r\n    \"desc\":\"closed_count\"\r\n}",

  "headers" : [ ],

  "paths" : [ ],

  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"sort_field\": \"count,open_count,closed_count,merged_count\",\n        \"total_count\": 2,\n        \"total_page\": 1,\n        \"list\": [{\n            \"sub_community\": \"ascendnpuir\",\n            \"pr_type\": \"All\",\n            \"count\": 6982,\n            \"open_count\": 21,\n            \"week_new_count\": 6,\n            \"unresponse_open_count\": 8,\n            \"merged_count\": 5639,\n            \"closed_count\": 1298,\n            \"unclosed_count\": 21,\n            \"closed_ratio\": 0.9970,\n            \"avg_first_reply_time\": 3.11,\n            \"avg_closed_time\": 4.35,\n            \"avg_overdue_first_reply_time\": 2.74,\n            \"avg_overdue_closed_time\": 1.79,\n            \"eight_hour_response_ratio\": 0.51,\n            \"one_day_response_ratio\": 0.61,\n            \"five_day_closed_ratio\": 0.12,\n            \"seven_day_closed_ratio\": 0.13,\n            \"comment_num\": 1.35\n        }],\n        \"summary\": {\n            \"pr_type\": \"All\",\n            \"count\": 12000,\n            \"open_count\": 40,\n            \"week_new_count\": 12,\n            \"merged_count\": 9800,\n            \"closed_count\": 2100,\n            \"closed_ratio\": 0.9967,\n            \"avg_first_reply_time\": 3.05,\n            \"avg_closed_time\": 4.20\n        }\n    },\n    \"timestamp\": 1772416725025,\n    \"executeTime\": 11\n}",

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

      "children" : [ ]

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

      "children" : [ ]

    }, {

      "name" : "group_dim",

      "value" : "",

      "description" : "",

      "required" : false,

      "dataType" : "String",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "pattern",

      "error" : "group_dim 只能为 sub_community（虚拟社区专用接口，不支持 repo 维度）",

      "expression" : "^(sub_community)?$",

      "children" : [ ]

    }, {

      "name" : "pr_type",

      "value" : "",

      "description" : "",

      "required" : false,

      "dataType" : "String",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "pattern",

      "error" : "pr_type 格式非法",

      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5]*$",

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

      "error" : "community 参数格式非法",

      "expression" : "^[a-zA-Z]{1,32}$",

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

      "name" : "repo",

      "value" : "",

      "description" : "",

      "required" : false,

      "dataType" : "String",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "pattern",

      "error" : "repo 格式非法",

      "expression" : "^[a-zA-Z0-9_\\-]*$",

      "children" : [ ]

    }, {

      "name" : "repo_path_list",

      "value" : "",

      "description" : "仓库清单（精确过滤，非空则 repo_path IN (...)）",

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

      "expression" : "^(count|open_count|unresponse_open_count|closed_count|unclosed_count|merged_count|closed_ratio|avg_first_reply_time|avg_closed_time|avg_overdue_first_reply_time|avg_overdue_closed_time|eight_hour_response_ratio|one_day_response_ratio|five_day_closed_ratio|seven_day_closed_ratio|comment_num|week_new_count)?$",

      "children" : [ ]

    }, {

      "name" : "desc",

      "value" : "123",

      "description" : "",

      "required" : false,

      "dataType" : "String",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "pattern",

      "error" : "desc 字段非法",

      "expression" : "^(count|open_count|unresponse_open_count|closed_count|unclosed_count|merged_count|closed_ratio|avg_first_reply_time|avg_closed_time|avg_overdue_first_reply_time|avg_overdue_closed_time|eight_hour_response_ratio|one_day_response_ratio|five_day_closed_ratio|seven_day_closed_ratio|comment_num|week_new_count)?$",

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

        "name" : "sort_field",

        "value" : "count,open_count,closed_count,merged_count",

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

            "name" : "count",

            "value" : "4215",

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

            "name" : "open_count",

            "value" : "659",

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

            "name" : "unresponse_open_count",

            "value" : "379",

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

            "name" : "closed_count",

            "value" : "748",

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

            "name" : "unclosed_count",

            "value" : "659",

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

            "name" : "merged_count",

            "value" : "2771",

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

            "name" : "closed_ratio",

            "value" : "0.8437",

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

            "name" : "avg_first_reply_time",

            "value" : "4.88",

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

            "name" : "avg_closed_time",

            "value" : "8.21",

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

            "name" : "avg_overdue_first_reply_time",

            "value" : "4.37",

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

            "name" : "avg_overdue_closed_time",

            "value" : "3.55",

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

            "name" : "eight_hour_response_ratio",

            "value" : "0.42",

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

            "name" : "one_day_response_ratio",

            "value" : "0.42",

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

            "name" : "five_day_closed_ratio",

            "value" : "0.12",

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

            "name" : "seven_day_closed_ratio",

            "value" : "0.12",

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

            "name" : "comment_num",

            "value" : "5.06",

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

            "name" : "week_new_count",

            "value" : "192",

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

      } ]

    }, {

      "name" : "timestamp",

      "value" : "1767667667289",

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

      "value" : "15",

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
// var sortList = ["count","open_count","closed_count","merged_count"]
var sortList = ["count","open_count","week_new_count","merged_count","unresponse_open_count","unclosed_count","closed_count","closed_ratio","avg_closed_time","avg_first_reply_time","one_day_response_ratio","eight_hour_response_ratio","five_day_closed_ratio","seven_day_closed_ratio","comment_num"]
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
var repo_path = body.repo_path;
var repoPathList = body.repo_path_list;
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
// 子社区维度专用接口：虚拟社区（如 mindall）只有 dws_*_pr_contribute_repo_daily 聚合表，
// 本接口只读它 + fact_community_structure，彻底不声明/不引用 fact_*_repo（repo 维度不在本接口范围）。
var contributeTable = "dws_" + community + "_pr_contribute_repo_daily";
var communityTable = "fact_community_structure";
// summarySql：不分组的全社区聚合合计（单行），供总览"总数据/活跃度/PR响应"卡片消费（返回体 data.summary）。
var summarySql = """
WITH last_week_data AS (
    SELECT       
        COALESCE(sum(open_pr_incre), 0) as open_count
    FROM ${contributeTable}
    <where>
        date >= #{last7Start} and date <= #{last7End}
        <if test="namespace != null and namespace != ''">
            and namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="repo_path != null and repo_path != ''">
            and repo_path LIKE CONCAT('%', #{repo_path}, '%')
        </if>
        <if test="repoPathList != null and repoPathList.size() > 0">
            and repo_path in
            <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
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
        <if test="repo_path != null and repo_path != ''">
            and repo_path LIKE CONCAT('%', #{repo_path}, '%')
        </if>
        <if test="repoPathList != null and repoPathList.size() > 0">
            and repo_path in
            <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
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
    cd.*, lwd.open_count as week_new_count,
    (select count(1) from contribute_data) as total_count, 
    CEIL((select count(1) from contribute_data)::numeric/#{page_size}) as total_page
FROM 
    contribute_data cd, last_week_data lwd
<if test="order_by != null and order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset}
""";
// 子社区维度专用接口：list 恒按 sub_community 分组（等价于旧接口 group_dim=sub_community），
// 调用方无需（也不再）传 group_dim；group_dim 入参保留仅为向后兼容，逻辑上被忽略。
// 只读 dws_*_pr_contribute_repo_daily + fact_community_structure，绝不引用 fact_*_repo（repo 维度）。
var sql = """
    WITH dim as (
        SELECT name as sub_community FROM ${communityTable} where parent_name = #{community} and status = 'active'
    ),
    last_week_data AS (
        SELECT
            sub_community,
            <if test="pr_type != null and pr_type != ''">
                super_issue_type as pr_type,
            </if>
            COALESCE(sum(open_pr_incre), 0) as open_count
        FROM ${contributeTable}
        <where>
            date >= #{last7Start} and date <= #{last7End}
            <if test="namespace != null and namespace != ''">
                and namespace LIKE CONCAT('%', #{namespace}, '%')
            </if>
            <if test="repo_path != null and repo_path != ''">
                and repo_path LIKE CONCAT('%', #{repo_path}, '%')
            </if>
            <if test="repoPathList != null and repoPathList.size() > 0">
                and repo_path in
                <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
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
        group by sub_community
        <if test="pr_type != null and pr_type != ''">
            ,super_issue_type
        </if>
    ),
    contribute_data AS (
        SELECT
            sub_community,
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
            <if test="repo_path != null and repo_path != ''">
                and repo_path LIKE CONCAT('%', #{repo_path}, '%')
            </if>
            <if test="repoPathList != null and repoPathList.size() > 0">
                and repo_path in
                <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
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
        group by sub_community
        <if test="pr_type != null and pr_type != ''">
            ,super_issue_type
        </if>
    ),
    group_data as (
        select
            d.sub_community,
            <if test="pr_type == null or pr_type == ''">
                'All' as pr_type,
            </if>
            <if test="pr_type != null and pr_type != ''">
                #{pr_type} as pr_type,
            </if>
            COALESCE(c.count, 0) as count, COALESCE(c.open_count, 0) as open_count,
            COALESCE(lwd.open_count, 0) as week_new_count,
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
        LEFT JOIN contribute_data c ON d.sub_community = c.sub_community
        LEFT JOIN last_week_data lwd ON d.sub_community = lwd.sub_community
        ORDER BY d.sub_community
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
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    return item;
})
// summary：全社区聚合合计（不分组，仅读 dws_*_pr_contribute_repo_daily，绝不查 fact 表）。
// 供总览"昇腾系社区总PR数据 / 活跃度 / PR响应"等消费聚合总数的卡片使用——
// 这些卡片过去靠"不传 group_dim 走汇总单行"取数，现接口 list 恒分组，故聚合合计改从 summary 读。
var summary_rows = db.select(summarySql);
var summary = new HashMap();
if (summary_rows.size() > 0){
    summary = summary_rows[0];
    summary.remove("total_count");
    summary.remove("total_page");
}
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
result.put("sort_field","count,open_count,closed_count,merged_count");
result.put("summary", summary);
return result

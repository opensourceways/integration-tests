{
  "properties" : { },
  "id" : "f9e4c27049b94e2b8af363610a8a52ed",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "CI构建信息分页",
  "createTime" : null,
  "updateTime" : 1776320804027,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/ci/metric",
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
  "requestBody" : "{\"community\":\"cannopen\",\"pageNum\":1,\"pageSize\":10,\"top_n\":10,\"asc\":\"\",\"desc\":\"\",\"start\":1767225600000,\"end\":1775208301663}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1776320796736,\n    \"executeTime\": 12\n}",
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
      "value" : "1767225600000",
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
      "value" : "1773306897373",
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
      "name" : "group_dim",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "group_dim 格式非法",
      "expression" : "^(repo|sub_community)?$",
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
      "expression" : "^[a-zA-Z]*$",
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
      "name" : "namespace",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "namespace 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-.]*$",
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
      "expression" : "^[a-zA-Z0-9_\\-.]*$",
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
      "error" : "private 格式非法",
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
      "error" : "asc 字段不在白名单中",
      "expression" : "^(count|open_count|closed_count|merged_count|build_count|daily_build_count_of_week|week_build_avg_time|build_p50|build_p90|week_build_success_rate|total_count|total_page)?$",
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
      "error" : "desc 字段不在白名单中",
      "expression" : "^(count|open_count|closed_count|merged_count|build_count|daily_build_count_of_week|week_build_avg_time|build_p50|build_p90|week_build_success_rate|total_count|total_page)?$",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过 100",
      "expression" : "pageSize != null || (pageSize > 0 && pageSize <= 100)",
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
      "error" : "pageNum 必须为正整数",
      "expression" : "pageNum != null || (pageNum > 0 && pageNum <= 9999)",
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
      "value" : "1773906899881",
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
var group_dim = 'repo';
// #1312 判定「超级社区」（昇腾系列总/主导开源/参与开源聚合看板）：
// 用集合判定（与前端 MIND_SERIES 对齐），不查 fact_community_structure，
// 避免预览环境该表未种子化时 isSuper 查询抛错导致接口 code=-1
var isSuper = ["mindall","mindlead","mindjoin"].contains(body.community);
if(isSuper){
    group_dim = 'sub_community';
}
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
// 仓库
var repo_path = body.repo_path;
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
var contributeTable = "dwm_" + community + "_ci_info";
var repoTable = "fact_" + community + "_repo";
var communityTable = "fact_community_structure";
var sql = """
WITH build_times AS (
    SELECT
        sub_community, 
        -- 逻辑修正：用总耗时除以总次数，得到准确的周平均耗时
        CASE 
            WHEN SUM(count) = 0 THEN 0 
            ELSE SUM(access_time)::NUMERIC / SUM(count) 
        END as build_time
    FROM ${contributeTable}
    <where>
        date >= #{last7Start} and date <= #{last7End}
        <if test="namespace != null and namespace != ''">
            and namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="repo_path != null and repo_path != ''">
            and repo_path LIKE CONCAT('%', #{repo_path}, '%')
        </if>
        <if test="source != null and source != ''">
            and code_platform = #{source}
        </if>
    </where>
    GROUP BY sub_community
),
last_week_data AS (
    SELECT
        t.sub_community,
        COALESCE(SUM(t.count), 0) as week_build_count,
        ROUND(
            CASE
                WHEN SUM(t.count) = 0 THEN 0
                ELSE SUM(t.access_time)::NUMERIC / SUM(t.count) / 60
            END::NUMERIC, 2
        ) as week_build_avg_time,
        ROUND(
            CASE
                WHEN SUM(t.count) = 0 THEN 0
                ELSE SUM(t.success_count)::NUMERIC / SUM(t.count)
            END::NUMERIC, 2
        ) as week_build_success_rate,

        ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY t.avg_access_time)::NUMERIC / 60, 0), 2) as build_p50,
        ROUND(COALESCE(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY t.avg_access_time)::NUMERIC / 60, 0), 2) as build_p90
    FROM ${contributeTable} t
    LEFT JOIN build_times bt ON t.sub_community = bt.sub_community
    <where>
        t.date >= #{last7Start} and t.date <= #{last7End}
        <if test="namespace != null and namespace != ''">
            and t.namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="repo_path != null and repo_path != ''">
            and t.repo_path LIKE CONCAT('%', #{repo_path}, '%')
        </if>
        <if test="source != null and source != ''">
            and t.code_platform = #{source}
        </if>
    </where>
    GROUP BY t.sub_community
),
contribute_data AS (
    SELECT
        COALESCE(sum(count), 0) as total_build_count
    FROM ${contributeTable}
    <where>
        date >= #{start} and date <= #{end}
        <if test="namespace != null and namespace != ''">
            and namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="repo_path != null and repo_path != ''">
            and repo_path LIKE CONCAT('%', #{repo_path}, '%')
        </if>
        <if test="source != null and source != ''">
            and code_platform = #{source}
        </if>
    </where>
)
SELECT
    cd.*, lwd.*,
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
        WITH dim as (
            <if test="group_dim == 'sub_community'">
                SELECT name as sub_community FROM ${communityTable} where parent_name = #{community} and status = 'active'
            </if>
            <if test="group_dim == 'repo'">
                SELECT namespace, repo_path, html_url as repo_url from ${repoTable} where is_hide is null and private = 'false'
                <if test="source != null and source != ''">
                    and code_platform = #{source}
                </if>
                <if test="repo_path != null and repo_path != ''">
                    and repo_path LIKE CONCAT('%', #{repo_path}, '%')
                </if>
            </if>
        ),
        build_times AS (
            SELECT
                <if test="group_dim == 'sub_community'">
                    sub_community,
                </if>
                <if test="group_dim == 'repo'">
                    namespace, repo_path,
                </if>
                -- 逻辑修正：用总耗时除以总次数，得到准确的周平均耗时
                CASE 
                    WHEN SUM(count) = 0 THEN 0 
                    ELSE SUM(access_time)::NUMERIC / SUM(count) 
                END as build_time
            FROM ${contributeTable}
            <where>
                date >= #{last7Start} and date <= #{last7End}
                <if test="namespace != null and namespace != ''">
                    and namespace LIKE CONCAT('%', #{namespace}, '%')
                </if>
                <if test="repo_path != null and repo_path != ''">
                    and repo_path LIKE CONCAT('%', #{repo_path}, '%')
                </if>
                <if test="source != null and source != ''">
                    and code_platform = #{source}
                </if>
            </where>
            GROUP BY sub_community
        ),
        last_week_data AS (
            SELECT
                <if test="group_dim == 'sub_community'">
                    t.sub_community,
                </if>
                <if test="group_dim == 'repo'">
                    t.namespace, t.repo_path, t.html_url as repo_url,
                </if>
                COALESCE(SUM(t.count), 0) as week_build_count,
                ROUND(
                    CASE
                        WHEN SUM(t.count) = 0 THEN 0
                        ELSE SUM(t.access_time)::NUMERIC / SUM(t.count) / 60
                    END::NUMERIC, 2
                ) as week_build_avg_time,
                ROUND(
                    CASE
                        WHEN SUM(t.count) = 0 THEN 0
                        ELSE SUM(t.success_count)::NUMERIC / SUM(t.count)
                    END::NUMERIC, 2
                ) as week_build_success_rate,
                ROUND(COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY t.avg_access_time)::NUMERIC / 60, 0), 2) as build_p50,
                ROUND(COALESCE(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY t.avg_access_time)::NUMERIC / 60, 0), 2) as build_p90
            FROM ${contributeTable} t
            LEFT JOIN build_times bt 
            <if test="group_dim == 'sub_community'">
                ON t.sub_community = bt.sub_community
            </if>
            <if test="group_dim == 'repo'">
                ON t.namespace = bt.namespace and t.repo_path = bt.repo_path
            </if>
            <where>
                t.date >= #{last7Start} and t.date <= #{last7End}
                <if test="namespace != null and namespace != ''">
                    and t.namespace LIKE CONCAT('%', #{namespace}, '%')
                </if>
                <if test="repo_path != null and repo_path != ''">
                    and t.repo_path LIKE CONCAT('%', #{repo_path}, '%')
                </if>
                <if test="source != null and source != ''">
                    and t.code_platform = #{source}
                </if>
            </where>
            <if test="group_dim == 'sub_community'">
                group by t.sub_community
            </if>
            <if test="group_dim == 'repo'">
                group by t.namespace, t.repo_path, t.html_url
            </if>
        ),
        contribute_data AS (
            SELECT
                <if test="group_dim == 'sub_community'">
                    t.sub_community,
                </if>
                <if test="group_dim == 'repo'">
                    t.namespace, t.repo_path, t.html_url as repo_url,
                </if>
                COALESCE(sum(t.count), 0) as total_count
            FROM ${contributeTable} t
            <where>
                date >= #{start} and date <= #{end}
                <if test="namespace != null and namespace != ''">
                    and t.namespace LIKE CONCAT('%', #{namespace}, '%')
                </if>
                <if test="repo_path != null and repo_path != ''">
                    and t.repo_path LIKE CONCAT('%', #{repo_path}, '%')
                </if>
                <if test="source != null and source != ''">
                    and t.code_platform = #{source}
                </if>
            </where>
            <if test="group_dim == 'sub_community'">
                group by t.sub_community
            </if>
            <if test="group_dim == 'repo'">
                group by t.namespace, t.repo_path, t.html_url
            </if>
        ),
        group_data as (
            select
                <if test="group_dim == 'sub_community'">
                    d.sub_community,
                    d.sub_community as repo_path,
                </if>
                <if test="group_dim == 'repo'">
                    d.namespace, d.repo_path, d.repo_url,
                </if>
                COALESCE(c.total_count, 0) as build_count,
                COALESCE(lwd.week_build_count, 0) as daily_build_count_of_week,
                COALESCE(lwd.week_build_avg_time, 0) as week_build_avg_time,
                COALESCE(lwd.build_p50, 0) as build_p50,
                COALESCE(lwd.build_p90, 0) as build_p90,
                COALESCE(lwd.week_build_success_rate, 0) as week_build_success_rate
            FROM dim d
            LEFT JOIN contribute_data c
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = c.sub_community
            </if>
            <if test="group_dim == 'repo'">
                ON d.namespace = c.namespace and d.repo_path = c.repo_path
            </if>
            LEFT JOIN last_week_data lwd
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = lwd.sub_community
                ORDER BY d.sub_community
            </if>
            <if test="group_dim == 'repo'">
                ON d.namespace = lwd.namespace and d.repo_path = lwd.repo_path
                ORDER BY d.repo_path
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

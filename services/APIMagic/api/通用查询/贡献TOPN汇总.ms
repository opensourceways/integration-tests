{
  "properties" : { },
  "id" : "copy1743413925985d93724",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "贡献TOPN汇总",
  "createTime" : null,
  "updateTime" : 1774315040313,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/contributes/topn/total",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1577808000000,\r\n    \"end\":1748526240605,\r\n    \"orgList\":[],\r\n    \"community\":\"openeuler\",\r\n    \"private\":\"false\",\r\n    \"event\":\"pr\",\r\n    \"metric\":\"company_type\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1751094035092,\n    \"executeTime\": 7\n}",
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
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1748526240605",
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
      "name" : "orgList",
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
      "name" : "event",
      "value" : "pr",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "event 只能为 pr、issue、comment、addcode、pr_ratio、issue_ratio、pr_avg_reply_time、pr_avg_closed_time、issue_avg_reply_time、issue_avg_closed_time、resolved_ratio、avg_resolved_time",
      "expression" : "^(pr|issue|comment|addcode|pr_ratio|issue_ratio|pr_avg_reply_time|pr_avg_closed_time|issue_avg_reply_time|issue_avg_closed_time|resolved_ratio|avg_resolved_time)?$",
      "children" : [ ]
    }, {
      "name" : "metric",
      "value" : "repo",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "metric 只能为 repo、company、company_type、sig 或 user",
      "expression" : "^(repo|company|company_type|sig|user)?$",
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
          "name" : "repo_path",
          "value" : "rackmount",
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
          "name" : "repo_url",
          "value" : "https://gitcode.com/openUBMC/rackmount",
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
          "name" : "pr_total",
          "value" : "96",
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
          "name" : "row_num",
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
          "name" : "total_count",
          "value" : "36",
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
    }, {
      "name" : "timestamp",
      "value" : "1748526534539",
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
      "value" : "7",
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
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 服务平台
var source = body.source;
// 组织
var orgList = body.orgList;
// 内外部
var internalList = body.internalList;
// 是否私仓
var private = body.private;
// 贡献类型：pr,issue,comment,addcode
var event = body.event;
// topn
var topn = 10;
if (body.topn != null and body.topn != ""){
    topn = body.topn;
}
// company_type-组织 company-组织明细 sig-SIG repo-仓库 user-开发者
var metric = body.metric;
var columnStr = '';
var columnArr = [];
var table_sub = metric;
if (metric == 'company_type'){
    columnStr = 'company_type'
    table_sub = 'company'
    columnArr = ['company_type']
} else if(metric == 'sig'){
    columnStr = 'sig_name'
    columnArr = ['sig_name']
} else if(metric == 'repo'){
    columnStr = 'repo_path,repo_url'
    columnArr = ['repo_path','repo_url']
} else if(metric == 'user'){
    columnStr = 'user_level'
    columnArr = ['user_level']
}
// 社区
var community = body.community.toLowerCase();
var issueTable = "fact_"+community+"_issue";
// if ("unifiedbus" == community){
//     return magic.execute('post','/query/contributes/topn/item_copy',{
//         body: body
//     });
// }
var contributeTable = "dws_"+community+"_contribute_"+table_sub+"_daily";
var repoTable = "fact_" + community + "_repo";
var sigTable = "fact_"+community+"_sig_user";
var companyTable = "dwm_"+community+"_company";
var hasResolvedCols = true;
if ((event == 'resolved_ratio' or event == 'avg_resolved_time') and metric != 'repo' and metric != 'company_type') {
    var colExists = db.selectOne("SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = #{contributeTable} AND column_name = 'resolved_issue_incre' LIMIT 1");
    hasResolvedCols = (colExists != null);
}
var hasIssueResolvedCols = true;
if ((event == 'resolved_ratio' or event == 'avg_resolved_time') and metric == 'repo') {
    var issueColExists = db.selectOne("SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = #{issueTable} AND column_name = 'is_resolved' LIMIT 1");
    hasIssueResolvedCols = (issueColExists != null);
}
if ((event == 'resolved_ratio' or event == 'avg_resolved_time') and metric == 'company_type') {
    var dwmColExists = db.selectOne("SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = #{contributeTable} AND column_name = 'resolved_issue_incre' LIMIT 1");
    hasIssueResolvedCols = (dwmColExists != null);
}
var sql = """
WITH dim_table AS (
    <if test="metric == 'user'">
        select * from (
            SELECT unnest(array['D0', 'D1', 'D2'])::text AS user_level
        ) user_temp
        <where>
            <if test="metric_value_arr != null and metric_value_arr.size() > 0">
                and ${coreColumn} in
                <foreach collection="metric_value_arr" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
        </where>
    </if>
    <else>
        <if test="metric == 'repo'">
            select 
            repo_path, html_url as repo_url
            from ${repoTable}
        </if>
        <if test="metric == 'sig'">
            select 
                distinct sig_name
            from ${sigTable}
        </if>
        <if test="metric == 'company_type'">
            select 
                distinct company_type
            from ${companyTable}
        </if>
        <if test="metric == 'company'">
            select 
                distinct company,company_type
            from ${companyTable}
        </if>
        <where>
            (is_hide is null)
            <if test="metric == 'sig'">
                and sig_name is not null
            </if>
            <if test="metric == 'repo' and source != null and source != ''">
                and code_platform = #{source}
            </if>
            <if test="metric == 'repo' and private != null and private != ''">
                and private = #{private}
            </if>
            <if test="orgList != null and orgList.size() > 0">
                and namespace in
                <foreach collection="orgList" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
            <if test="(metric == 'company' or metric == 'company_type') and internalList != null and internalList.size() > 0">
                and internal in
                <foreach collection="internalList" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
            <if test="metric_value_arr != null and metric_value_arr.size() > 0">
                and ${coreColumn} in
                <foreach collection="metric_value_arr" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
        </where>
    </else>
),
<if test="metric == 'repo' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">
resolved_sub AS (
    SELECT namespace as rs_namespace, repo_path as rs_repo_path,
        COUNT(*) FILTER (WHERE is_resolved::boolean = true) as resolved_count,
        COUNT(*) as total_count,
        SUM(COALESCE(closed_time, EXTRACT(EPOCH FROM (final_closed_at - created_at))))
            FILTER (WHERE is_resolved::boolean = true AND (closed_time IS NOT NULL OR final_closed_at IS NOT NULL)) as resolved_time_sum
    FROM ${issueTable}
    WHERE is_hide is null and is_removed is null
        AND created_at::DATE BETWEEN #{start} AND #{end}
    <if test="orgList != null and orgList.size() > 0">
        AND namespace in
        <foreach collection="orgList" item="item" open="(" separator="," close=")">
            #{item}
        </foreach>
    </if>
    GROUP BY namespace, repo_path
),
</if>
<if test="metric == 'company_type' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">
resolved_company_sub AS (
    SELECT
        company_type as rc_company_type,
        SUM(resolved_issue_incre) as resolved_count,
        SUM(issue_incre) as total_count,
        SUM(resolved_time) as resolved_time_sum
    FROM ${contributeTable}
    WHERE date::DATE BETWEEN #{start} AND #{end}
    <if test="orgList != null and orgList.size() > 0">
        AND namespace in
        <foreach collection="orgList" item="item" open="(" separator="," close=")">
            #{item}
        </foreach>
    </if>
    GROUP BY company_type
),
</if>
filter_data AS (
    SELECT
        ${columnStr},
        <if test="metric == 'user'">
            sum(pr_incre) as pr_total,
        </if>
        <if test="metric != 'user'">
            sum(merged_pr_incre) as pr_total,
        </if>
        sum(issue_incre) as issue_total,
        sum(comment_incre) as comment_total,
        sum(addcode_incre) as addcode_total,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE (sum(pr_incre) - sum(open_pr_incre))::NUMERIC / sum(pr_incre)
            END::NUMERIC , 4
        ) as pr_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE (sum(issue_incre) - sum(open_issue_incre) - sum(progressing_issue_incre))::NUMERIC / sum(issue_incre)
            END::NUMERIC , 4
        ) as issue_ratio,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(pr_first_reply_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 4
        ) as pr_avg_reply_time,
        ROUND(
            CASE
                WHEN sum(pr_incre) = 0 THEN 0
                ELSE sum(pr_closed_time)::NUMERIC / sum(pr_incre) / 86400
            END::NUMERIC , 4
        ) as pr_avg_closed_time,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(issue_first_reply_time)::NUMERIC / sum(issue_incre) / 86400
            END::NUMERIC , 4
        ) as issue_avg_reply_time,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(issue_closed_time)::NUMERIC / sum(issue_incre) / 86400
            END::NUMERIC , 4
        ) as issue_avg_closed_time,
        <if test="metric == 'company_type' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">
        COALESCE(ROUND(MAX(rc.resolved_count)::NUMERIC / NULLIF(MAX(rc.total_count), 0), 4), 0) as resolved_ratio,
        COALESCE(ROUND(MAX(rc.resolved_time_sum)::NUMERIC / NULLIF(MAX(rc.resolved_count), 0) / 86400.0, 4), 0) as avg_resolved_time
        </if>
        <if test="metric != 'repo' and metric != 'company_type' and hasResolvedCols and (event == 'resolved_ratio' or event == 'avg_resolved_time')">
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(resolved_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC, 4
        ) as resolved_ratio,
        ROUND(
            CASE
                WHEN sum(resolved_issue_incre) = 0 THEN 0
                ELSE sum(resolved_time)::NUMERIC / sum(resolved_issue_incre) / 86400
            END::NUMERIC, 4
        ) as avg_resolved_time
        </if>
        <if test="metric != 'repo' and (event != 'resolved_ratio' and event != 'avg_resolved_time' or (metric != 'company_type' and !hasResolvedCols) or (metric == 'company_type' and !hasIssueResolvedCols))">
        0 as resolved_ratio,
        0 as avg_resolved_time
        </if>
        <if test="metric == 'repo' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">
        COALESCE(ROUND(MAX(rs.resolved_count)::NUMERIC / NULLIF(MAX(rs.total_count), 0), 4), 0) as resolved_ratio,
        COALESCE(ROUND(MAX(rs.resolved_time_sum)::NUMERIC / NULLIF(MAX(rs.resolved_count), 0) / 86400.0, 4), 0) as avg_resolved_time
        </if>
        <if test="metric == 'repo' and (event != 'resolved_ratio' and event != 'avg_resolved_time' or !hasIssueResolvedCols)">
        0 as resolved_ratio,
        0 as avg_resolved_time
        </if>
    FROM ${contributeTable}
    <if test="metric == 'repo' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">LEFT JOIN resolved_sub rs ON ${contributeTable}.namespace = rs.rs_namespace AND ${contributeTable}.repo_path = rs.rs_repo_path</if>
    <if test="metric == 'company_type' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">LEFT JOIN resolved_company_sub rc ON ${contributeTable}.company_type = rc.rc_company_type</if>
    <where>
        date::DATE BETWEEN #{start} AND #{end}
        <if test="source != null and source != ''">
            and source = #{source}
        </if>
        <if test="private != null and private != ''">
            and private = #{private}
        </if>
        <if test="orgList != null and orgList.size() > 0">
            and namespace in
            <foreach collection="orgList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
    GROUP BY ${columnStr}
),
joined_data AS (
    SELECT 
        <if test="columnArr != null and columnArr.size() > 0">
            <foreach collection="columnArr" item="item" separator=",">
                dt.${item}
            </foreach>
        </if>,
        COALESCE(fd.pr_total, 0) AS pr_total,
        COALESCE(fd.issue_total, 0) AS issue_total,
        COALESCE(fd.comment_total, 0) AS comment_total,
        COALESCE(fd.addcode_total, 0) AS addcode_total,
        COALESCE(fd.pr_ratio, 0) AS pr_ratio,
        COALESCE(fd.issue_ratio, 0) AS issue_ratio,
        COALESCE(fd.pr_avg_reply_time, 0) AS pr_avg_reply_time,
        COALESCE(fd.pr_avg_closed_time, 0) AS pr_avg_closed_time,
        COALESCE(fd.issue_avg_reply_time, 0) AS issue_avg_reply_time,
        COALESCE(fd.issue_avg_closed_time, 0) AS issue_avg_closed_time,
        COALESCE(fd.resolved_ratio, 0) AS resolved_ratio,
        COALESCE(fd.avg_resolved_time, 0) AS avg_resolved_time
    FROM dim_table dt
    LEFT JOIN filter_data fd ON
    <if test="columnArr != null and columnArr.size() > 0">
        <foreach collection="columnArr" item="item"  separator=" AND ">
            dt.${item} = fd.${item}
        </foreach>
    </if>
),
ranked_data AS (
    SELECT 
        ${columnStr},
        <if test="event == 'pr'">
            pr_total,
            ROW_NUMBER() OVER (ORDER BY pr_total DESC) AS row_num,
        </if>
        <if test="event == 'issue'">
            issue_total,
            ROW_NUMBER() OVER (ORDER BY issue_total DESC) AS row_num,
        </if>
        <if test="event == 'comment'">
            comment_total,
            ROW_NUMBER() OVER (ORDER BY comment_total DESC) AS row_num,
        </if>
        <if test="event == 'addcode'">
            addcode_total,
            ROW_NUMBER() OVER (ORDER BY addcode_total DESC) AS row_num,
        </if>
        <if test="event == 'pr_ratio'">
            pr_ratio,
            ROW_NUMBER() OVER (ORDER BY pr_ratio DESC) AS row_num,
        </if>
        <if test="event == 'issue_ratio'">
            issue_ratio,
            ROW_NUMBER() OVER (ORDER BY issue_ratio DESC) AS row_num,
        </if>
        <if test="event == 'pr_avg_reply_time'">
            pr_avg_reply_time,
            ROW_NUMBER() OVER (ORDER BY pr_avg_reply_time DESC) AS row_num,
        </if>
        <if test="event == 'pr_avg_closed_time'">
            pr_avg_closed_time,
            ROW_NUMBER() OVER (ORDER BY pr_avg_closed_time DESC) AS row_num,
        </if>
        <if test="event == 'issue_avg_reply_time'">
            issue_avg_reply_time,
            ROW_NUMBER() OVER (ORDER BY issue_avg_reply_time DESC) AS row_num,
        </if>
        <if test="event == 'issue_avg_closed_time'">
            issue_avg_closed_time,
            ROW_NUMBER() OVER (ORDER BY issue_avg_closed_time DESC) AS row_num,
        </if>
        <if test="event == 'resolved_ratio'">
            resolved_ratio,
            ROW_NUMBER() OVER (ORDER BY resolved_ratio DESC) AS row_num,
        </if>
        <if test="event == 'avg_resolved_time'">
            avg_resolved_time,
            ROW_NUMBER() OVER (ORDER BY avg_resolved_time DESC) AS row_num,
        </if>
        COUNT(*) OVER () AS total_count
    FROM joined_data
),
remaining_sum AS (
   SELECT 
        <foreach collection="columnArr" item="item" separator=", ">
            'Other' as ${item}
        </foreach>,
        <if test="event == 'pr'">
            sum(pr_total) as pr_total,
        </if>
        <if test="event == 'issue'">
            sum(issue_total) as issue_total,
        </if>
        <if test="event == 'comment'">
            sum(comment_total) as comment_total,
        </if>
        <if test="event == 'addcode'">
            sum(addcode_total) as addcode_total,
        </if>
        <if test="event == 'pr_ratio'">
            0 as pr_ratio,
        </if>
        <if test="event == 'issue_ratio'">
            0 as issue_ratio,
        </if>
        <if test="event == 'pr_avg_reply_time'">
            0 as pr_avg_reply_time,
        </if>
        <if test="event == 'pr_avg_closed_time'">
            0 as pr_avg_closed_time,
        </if>
        <if test="event == 'issue_avg_reply_time'">
            0 as issue_avg_reply_time,
        </if>
        <if test="event == 'issue_avg_closed_time'">
            0 as issue_avg_closed_time,
        </if>
        <if test="event == 'resolved_ratio'">
            0 as resolved_ratio,
        </if>
        <if test="event == 'avg_resolved_time'">
            0 as avg_resolved_time,
        </if>
        10 as row_num,
        MAX(total_count) AS total_count
    FROM 
        ranked_data
    WHERE 
        row_num >= #{topn}
)
SELECT 
    *
FROM 
    ranked_data
WHERE 
   total_count <= #{topn} OR row_num <= #{topn}-1
UNION ALL
SELECT 
    *
FROM 
    remaining_sum
WHERE 
    total_count > #{topn}
""";
return db.select(sql)

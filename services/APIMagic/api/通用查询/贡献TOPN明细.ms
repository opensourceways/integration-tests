{
  "properties" : { },
  "id" : "copy1743491783448d13775",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "贡献TOPN明细",
  "createTime" : null,
  "updateTime" : 1774315043724,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/contributes/topn/item",
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
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1761389420295,\r\n    \"source\":\"\",\r\n    \"orgList\":[],\r\n    \"community\":\"mindcluster\",\r\n    \"private\":\"\",\r\n    \"event\":\"pr\",\r\n    \"interval\":\"week\",\r\n    \"metric\":\"user\",\r\n    \"metricVal\":[\"D1\"]\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1761792437511,\n    \"executeTime\": 11\n}",
  "description" : "获取指定周期下不同统计维度下指定贡献数量，统计维度支持：开发者维度-user、组织维度-company_type、SIG维度-sig、仓库维度-repo；贡献类型(event)支持：基础贡献-pr(PR数)/issue(Issue数)/comment(评论数)/addcode(新增代码行数)，比例类-pr_ratio(PR占比)/issue_ratio(Issue占比)，时长类-pr_avg_reply_time(PR平均响应时长)/pr_avg_closed_time(PR平均关闭时长)/issue_avg_reply_time(Issue平均响应时长)/issue_avg_closed_time(Issue平均关闭时长)，Issue解决类-resolved_ratio(解决率)/avg_resolved_time(平均解决时长，仅 metric 为 repo 或 company_type 时支持)",
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
      "description" : "开始时间",
      "required" : true,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1761389420295",
      "description" : "结束时间",
      "required" : true,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "",
      "description" : "来源平台",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "source 格式非法",
      "expression" : "^[a-zA-Z0-9_]*$",
      "children" : [ ]
    }, {
      "name" : "orgList",
      "value" : "",
      "description" : "组织",
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
      "value" : "mindcluster",
      "description" : "社区",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "private",
      "value" : "",
      "description" : "公私仓",
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
      "description" : "贡献类型，可选值：pr/issue/comment/addcode/pr_ratio/issue_ratio/pr_avg_reply_time/pr_avg_closed_time/issue_avg_reply_time/issue_avg_closed_time/resolved_ratio/avg_resolved_time（resolved_ratio、avg_resolved_time 仅 metric 为 repo 或 company_type 时支持）",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "event 只能为 pr、issue、comment、addcode、pr_ratio、issue_ratio、pr_avg_reply_time、pr_avg_closed_time、issue_avg_reply_time、issue_avg_closed_time、resolved_ratio、avg_resolved_time",
      "expression" : "^(pr|issue|comment|addcode|pr_ratio|issue_ratio|pr_avg_reply_time|pr_avg_closed_time|issue_avg_reply_time|issue_avg_closed_time|resolved_ratio|avg_resolved_time)?$",
      "children" : [ ]
    }, {
      "name" : "interval",
      "value" : "week",
      "description" : "时间周期",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "interval 只能为 daily、week 或 month",
      "expression" : "^(daily|week|month)?$",
      "children" : [ ]
    }, {
      "name" : "metric",
      "value" : "user",
      "description" : "统计维度",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "metric 只能为 repo、company、sig 或 user",
      "expression" : "^(repo|company|sig|company_type|user)?$",
      "children" : [ ]
    }, {
      "name" : "metricVal",
      "value" : "",
      "description" : "统计维度值（只有开发者维度下使用，对应 metric_value_arr）",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "",
        "value" : "D1",
        "description" : "",
        "required" : false,
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "pattern",
        "error" : "metricVal 中的值格式非法",
        "expression" : "^[a-zA-Z0-9_\\-]*$",
        "children" : [ ]
      } ]
    }, {
      "name" : "internalList",
      "value" : "",
      "description" : "内外部",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "topn",
      "value" : "10",
      "description" : "top 数量，默认 10",
      "required" : false,
      "dataType" : "Integer",
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
      "value" : "1761792437511",
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
      "value" : "11",
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
// 统计周期：daily-天，week-周，month-月
var interval = body.interval;
// topn
var topn = 10;
if (body.topn != null and body.topn != ""){
    topn = body.topn;
}
// company_type-组织 company-组织明细 sig-SIG repo-仓库 user-开发者
var metric = body.metric;
var columnStr = '';
var columnArr = [];
var coreColumn = '';
var table_sub = metric;
if (metric == 'company_type'){
    columnStr = 'company_type'
    table_sub = 'company'
    columnArr = ['company_type']
    coreColumn = 'company_type'
} else if(metric == 'sig'){
    columnStr = 'sig_name'
    columnArr = ['sig_name']
    coreColumn = 'sig_name'
} else if(metric == 'repo'){
    columnStr = 'repo_path,repo_url'
    columnArr = ['repo_path','repo_url']
    // #1348: coreColumn 仅用于 metricVal / topn_combinations 过滤，须是真实列名。
    // repo_url 是 dim_table 里 html_url 的 SELECT 别名，不能在 WHERE 引用（PG 报 column does not exist）；
    // 且前端按需查趋势传的 metricVal 就是 repo_path，故过滤列用真实的 repo_path。
    coreColumn = 'repo_path'
} else if(metric == 'user'){
    columnStr = 'user_level'
    columnArr = ['user_level']
    coreColumn = 'user_level'
}
// 具体明细key：user-[D0,D1,D2]
var metric_value_arr = body.metricVal;
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
WITH date_series AS (
-- 生成从最早访问日期到当前日期的日期序列
  SELECT
    generate_series ( #{start}, #{end}, '1 day' :: INTERVAL ) :: DATE AS date
),
dim_table AS (
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
resolved_repo_sub AS (
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
resolved_repo_daily AS (
    SELECT
        created_at::DATE as rd_date,
        namespace as rd_namespace,
        repo_path as rd_repo_path,
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
    GROUP BY created_at::DATE, namespace, repo_path
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
resolved_company_daily AS (
    SELECT
        date::DATE as rd_date,
        company_type as rd_company_type,
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
    GROUP BY date::DATE, company_type
),
</if>
topn_table AS (
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
    <if test="metric == 'repo' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">LEFT JOIN resolved_repo_sub rs ON ${contributeTable}.namespace = rs.rs_namespace AND ${contributeTable}.repo_path = rs.rs_repo_path</if>
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
        <if test="metric_value_arr != null and metric_value_arr.size() > 0">
            and ${coreColumn} in
            <foreach collection="metric_value_arr" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
    group by ${columnStr}
    order by
    <if test="event == 'pr'">
        pr_total desc
    </if>
    <if test="event == 'issue'">
        issue_total desc
    </if>
    <if test="event == 'comment'">
        comment_total desc
    </if>
    <if test="event == 'addcode'">
        addcode_total desc
    </if>
    <if test="event == 'pr_ratio'">
        pr_ratio desc
    </if>
    <if test="event == 'issue_ratio'">
        issue_ratio desc
    </if>
    <if test="event == 'pr_avg_reply_time'">
        pr_avg_reply_time desc
    </if>
    <if test="event == 'pr_avg_closed_time'">
        pr_avg_closed_time desc
    </if>
    <if test="event == 'issue_avg_reply_time'">
        issue_avg_reply_time desc
    </if>
    <if test="event == 'issue_avg_closed_time'">
        issue_avg_closed_time desc
    </if>
    <if test="event == 'resolved_ratio'">
        resolved_ratio desc
    </if>
    <if test="event == 'avg_resolved_time'">
        avg_resolved_time desc
    </if>
    limit #{topn} offset 0
),
topn_combinations AS (
     SELECT 
        <if test="columnArr != null and columnArr.size() > 0">
            <foreach collection="columnArr" item="item"  separator=" , ">
                dt.${item} 
            </foreach>
        </if>,
        COALESCE(tt.pr_total, 0) AS pr_total,
        COALESCE(tt.issue_total, 0) AS issue_total,
        COALESCE(tt.comment_total, 0) AS comment_total,
        COALESCE(tt.addcode_total, 0) as addcode_total,
        COALESCE(tt.pr_ratio, 0) as pr_ratio,
        COALESCE(tt.issue_ratio, 0) as issue_ratio,
        COALESCE(tt.pr_avg_reply_time, 0) as pr_avg_reply_time,
        COALESCE(tt.pr_avg_closed_time, 0) as pr_avg_closed_time,
        COALESCE(tt.issue_avg_reply_time, 0) as issue_avg_reply_time,
        COALESCE(tt.issue_avg_closed_time, 0) as issue_avg_closed_time,
        COALESCE(tt.resolved_ratio, 0) as resolved_ratio,
        COALESCE(tt.avg_resolved_time, 0) as avg_resolved_time
    FROM dim_table dt
    LEFT JOIN topn_table tt ON
    <if test="columnArr != null and columnArr.size() > 0">
        <foreach collection="columnArr" item="item"  separator=" AND ">
            dt.${item} = tt.${item}
        </foreach>
    </if>
    order by
    <if test="event == 'pr'">
        pr_total desc
    </if>
    <if test="event == 'issue'">
        issue_total desc
    </if>
    <if test="event == 'comment'">
        comment_total desc
    </if>
    <if test="event == 'addcode'">
        addcode_total desc
    </if>
    <if test="event == 'pr_ratio'">
        pr_ratio desc
    </if>
    <if test="event == 'issue_ratio'">
        issue_ratio desc
    </if>
    <if test="event == 'pr_avg_reply_time'">
        pr_avg_reply_time desc
    </if>
    <if test="event == 'pr_avg_closed_time'">
        pr_avg_closed_time desc
    </if>
    <if test="event == 'issue_avg_reply_time'">
        issue_avg_reply_time desc
    </if>
    <if test="event == 'issue_avg_closed_time'">
        issue_avg_closed_time desc
    </if>
    <if test="event == 'resolved_ratio'">
        resolved_ratio desc
    </if>
    <if test="event == 'avg_resolved_time'">
        avg_resolved_time desc
    </if>
    limit #{topn} offset 0
),
full_combinations AS (
    SELECT ds.date, 
    <if test="columnArr != null and columnArr.size() > 0">
        <foreach collection="columnArr" item="item"  separator=" , ">
            tc.${item} 
        </foreach>
    </if>
    FROM date_series ds
    CROSS JOIN topn_combinations tc
), 
group_full_combinations AS (
    select 
        distinct ${columnStr},
        <if test="interval == 'daily'">
            date_trunc('day', date)::DATE as date
        </if>
        <elseif test="interval == 'week'">
            date_trunc('week', date)::DATE as date
        </elseif>
        <else>
            date_trunc('month', date)::DATE as date
        </else>
    from full_combinations
    group by ${columnStr},date
),
filter_table AS (
    SELECT
        date, 
        ${columnStr},
        <if test="metric == 'user'">
            pr_incre,
        </if>
        <if test="metric != 'user'">
            merged_pr_incre as pr_incre,
        </if>
        pr_incre as all_pr_incre,
        issue_incre,
        comment_incre,
        addcode_incre,
        open_pr_incre,
        open_issue_incre,
        progressing_issue_incre,
        pr_first_reply_time,
        pr_closed_time,
        issue_first_reply_time,
        issue_closed_time,
        <if test="metric == 'company_type' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">
        COALESCE(rd.resolved_count, 0) as resolved_issue_incre,
        COALESCE(rd.resolved_time_sum, 0) as resolved_time
        </if>
        <if test="metric != 'repo' and metric != 'company_type' and hasResolvedCols and (event == 'resolved_ratio' or event == 'avg_resolved_time')">
        resolved_issue_incre,
        resolved_time
        </if>
        <if test="metric != 'repo' and (event != 'resolved_ratio' and event != 'avg_resolved_time' or (metric != 'company_type' and !hasResolvedCols) or (metric == 'company_type' and !hasIssueResolvedCols))">
        0 as resolved_issue_incre,
        0 as resolved_time
        </if>
        <if test="metric == 'repo' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">
        COALESCE(rd.resolved_count, 0) as resolved_issue_incre,
        COALESCE(rd.resolved_time_sum, 0) as resolved_time
        </if>
        <if test="metric == 'repo' and (event != 'resolved_ratio' and event != 'avg_resolved_time' or !hasIssueResolvedCols)">
        0 as resolved_issue_incre,
        0 as resolved_time
        </if>
    FROM ${contributeTable}
    <if test="metric == 'repo' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">LEFT JOIN resolved_repo_daily rd ON ${contributeTable}.date::DATE = rd.rd_date AND ${contributeTable}.namespace = rd.rd_namespace AND ${contributeTable}.repo_path = rd.rd_repo_path</if>
    <if test="metric == 'company_type' and (event == 'resolved_ratio' or event == 'avg_resolved_time') and hasIssueResolvedCols">LEFT JOIN resolved_company_daily rd ON ${contributeTable}.date::DATE = rd.rd_date AND ${contributeTable}.company_type = rd.rd_company_type</if>
    <where>
        date::DATE BETWEEN #{start} AND #{end}
        and ${coreColumn} in (select ${coreColumn} from topn_combinations) 
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
),group_table AS (
    select 
        <if test="interval == 'daily'">
            date_trunc('day', date)::DATE as date,
        </if>
        <elseif test="interval == 'week'"> 
            date_trunc('week', date)::DATE as date,
        </elseif>
        <else>
            date_trunc('month', date)::DATE as date,
        </else>
        ${columnStr},
        sum(pr_incre) as pr_incre,
        sum(issue_incre) as issue_incre,
        sum(comment_incre) as comment_incre,
        sum(addcode_incre) as addcode_incre,
        ROUND(
            CASE
                WHEN sum(all_pr_incre) = 0 THEN 0
                ELSE (sum(all_pr_incre) - sum(open_pr_incre))::NUMERIC / sum(all_pr_incre)
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
                WHEN sum(all_pr_incre) = 0 THEN 0
                ELSE sum(pr_first_reply_time)::NUMERIC / sum(all_pr_incre) / 86400
            END::NUMERIC , 4
        ) as pr_avg_reply_time,
        ROUND(
            CASE
                WHEN sum(all_pr_incre) = 0 THEN 0
                ELSE sum(pr_closed_time)::NUMERIC / sum(all_pr_incre) / 86400
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
    from filter_table
    group by 
        ${columnStr},
        <if test="interval == 'daily'">
            date_trunc('day', date)::DATE
        </if>
        <elseif test="interval == 'week'"> 
            date_trunc('week', date)::DATE
        </elseif>
        <else>
            date_trunc('month', date)::DATE
        </else>
),
joined_data AS (
    -- 将完整的日期和组合表与实际的访问数据进行左连接
    SELECT 
        fc.date,
        <if test="columnArr != null and columnArr.size() > 0">
            <foreach collection="columnArr" item="item" separator=",">
                fc.${item}
            </foreach>
        </if>,
        COALESCE(d.pr_incre, 0) AS pr_incre,
        COALESCE(d.issue_incre, 0) AS issue_incre,
        COALESCE(d.comment_incre, 0) AS comment_incre,
        COALESCE(d.addcode_incre, 0) AS addcode_incre,
        COALESCE(d.pr_ratio, 0) AS pr_ratio,
        COALESCE(d.issue_ratio, 0) AS issue_ratio,
        COALESCE(d.pr_avg_reply_time, 0) AS pr_avg_reply_time,
        COALESCE(d.pr_avg_closed_time, 0) AS pr_avg_closed_time,
        COALESCE(d.issue_avg_reply_time, 0) AS issue_avg_reply_time,
        COALESCE(d.issue_avg_closed_time, 0) AS issue_avg_closed_time,
        COALESCE(d.resolved_ratio, 0) AS resolved_ratio,
        COALESCE(d.avg_resolved_time, 0) AS avg_resolved_time
    FROM group_full_combinations fc
    LEFT JOIN group_table d ON fc.date = d.date  AND
    <if test="columnArr != null and columnArr.size() > 0">
        <foreach collection="columnArr" item="item"  separator=" AND ">
            fc.${item} = d.${item}
        </foreach>
    </if>
)
select 
    ${columnStr},
    date, 
    <if test="event == 'pr'">
        pr_incre,
        SUM(pr_incre) OVER (PARTITION BY ${columnStr} ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pr_total
    </if>
    <if test="event == 'issue'">
        issue_incre,
        SUM(issue_incre) OVER (PARTITION BY ${columnStr} ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS issue_total
    </if>
    <if test="event == 'comment'">
        comment_incre,
        SUM(comment_incre) OVER (PARTITION BY ${columnStr} ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS comment_total
    </if>
    <if test="event == 'addcode'">
        addcode_incre,
        SUM(addcode_incre) OVER (PARTITION BY ${columnStr} ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS addcode_total
    </if>
    <if test="event == 'pr_ratio'">
        pr_ratio
    </if>
    <if test="event == 'issue_ratio'">
        issue_ratio
    </if>
    <if test="event == 'pr_avg_reply_time'">
        pr_avg_reply_time
    </if>
    <if test="event == 'pr_avg_closed_time'">
        pr_avg_closed_time
    </if>
    <if test="event == 'issue_avg_reply_time'">
        issue_avg_reply_time
    </if>
    <if test="event == 'issue_avg_closed_time'">
        issue_avg_closed_time
    </if>
    <if test="event == 'resolved_ratio'">
        resolved_ratio
    </if>
    <if test="event == 'avg_resolved_time'">
        avg_resolved_time
    </if>
from joined_data;
""";
return db.select(sql)

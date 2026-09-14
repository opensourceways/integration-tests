{
  "properties" : { },
  "id" : "copy1743235620075d93918",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "贡献",
  "createTime" : null,
  "updateTime" : 1743505972108,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/contributes",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\":1730390400000,\r\n    \"end\":1743177600000,\r\n    \"orgList\":[\"openUBMC\"],\r\n    \"community\":\"openUBMC\",\r\n    \"eventList\":[\"pr\",\"issue\", \"comment\"],\r\n    \"interval\":\"daily\",\r\n    \"metric\":\"repo\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1743240966809,\n    \"executeTime\": 9\n}",
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
      "value" : "1730390400000",
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
      "value" : "1743177600000",
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
      "children" : [ {
        "name" : "",
        "value" : "openUBMC",
        "description" : "",
        "required" : false,
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "pattern",
        "error" : "orgList 中的值格式非法",
        "expression" : "^[a-zA-Z0-9_\\-]*$",
        "children" : [ ]
      } ]
    }, {
      "name" : "community",
      "value" : "openUBMC",
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
      "name" : "eventList",
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
        "value" : "pr",
        "description" : "",
        "required" : false,
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "pattern",
        "error" : "eventList 中的值只能为 pr、issue 或 comment",
        "expression" : "^(pr|issue|comment)?$",
        "children" : [ ]
      } ]
    }, {
      "name" : "interval",
      "value" : "daily",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "interval 只能为 daily、week 或 month",
      "expression" : "^(daily|week|month)?$",
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
      "error" : "metric 只能为 repo、org 或 user",
      "expression" : "^(repo|org|user)?$",
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
          "name" : "company_type",
          "value" : "华为",
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
          "name" : "date",
          "value" : "2024-11-01",
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
          "name" : "pr_incre",
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
          "name" : "pr_total",
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
          "name" : "issue_incre",
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
          "name" : "issue_total",
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
          "name" : "comment_incre",
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
          "name" : "comment_total",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1743236492114",
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
      "value" : "22",
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
// 组织
var orgList = body.orgList;
// 内外部
var internalList = body.internalList;
// 贡献类型：pr,issue,comment
var eventList = body.eventList;
// 统计周期：daily-天，week-周，month-月
var interval = body.interval;
// company_type-组织 company-组织明细 sig-SIG repo-仓库 user-开发者
var metric = body.metric;
var columnStr = '';
var columnArr = [];
var table_sub = metric;
if (metric == 'company_type'){
    columnStr = 'company_type'
    table_sub = 'company'
    columnArr = ['company_type']
} else if (metric == 'company'){
    columnStr = 'company,company_type'
    columnArr = ['company','company_type']
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
// 贡献表
var userTable = "dws_"+community+"_contribute_"+table_sub+"_daily";
var repoTable = "fact_" + community + "_gitcode_repo";
if (community == "opengauss" || community == "openeuler"|| community == "mindspore"){
    repoTable = "fact_" + community + "_gitee_repo";
}
var sigTable = "fact_"+community+"_sig_user";
var sql = """
WITH date_params AS (
    SELECT
       TO_TIMESTAMP(#{body.start}/1000) AT TIME ZONE 'Asia/Shanghai' as start_time,
       TO_TIMESTAMP(#{body.end}/1000) AT TIME ZONE 'Asia/Shanghai' as end_time
),date_series AS (
-- 生成从最早访问日期到当前日期的日期序列
  SELECT
    generate_series ( (SELECT start_time FROM date_params), (SELECT end_time FROM date_params), '1 day' :: INTERVAL ) :: DATE AS date
),
dim_table AS (
    <if test="metric == 'repo'">
        select 
        repo_path, html_url as repo_url
        from ${repoTable}
        <where>
            (is_removed != '1' or is_removed is null)
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
    </if>
    <elseif test="metric == 'sig'">
        select 
            distinct sig_name
        from ${sigTable}
        <where>
            (is_removed != '1' or is_removed is null)
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
    </elseif>
    <else>
        SELECT distinct ${columnStr} from ${userTable}
        <where>
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
    </else>
),
full_combinations AS (
    SELECT ds.date, dt.*
    FROM date_series ds
    CROSS JOIN dim_table dt
), 
filter_table AS (
    SELECT
        date, 
        ${columnStr},
        <foreach collection="eventList" item="item" separator=", ">
            <if test="item == 'pr'">
                pr_incre
            </if>
            <if test="item == 'issue'">
                issue_incre
            </if>
            <if test="item == 'comment'">
                comment_incre
            </if>
        </foreach>
    FROM ${userTable}
    <where>
        date::DATE BETWEEN (SELECT start_time FROM date_params) AND (SELECT end_time FROM date_params)
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
),
group_full_combinations AS (
    select 
        ${columnStr},
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
        <foreach collection="eventList" item="item" separator=", ">
            <if test="item == 'pr'">
                sum(pr_incre) as pr_incre
            </if>
            <if test="item == 'issue'">
                sum(issue_incre) as issue_incre
            </if>
            <if test="item == 'comment'">
                sum(comment_incre) as comment_incre
            </if>
        </foreach>
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
        <foreach collection="eventList" item="item" separator=", ">
            <if test="item == 'pr'">
                COALESCE(d.pr_incre, 0) AS pr_incre
            </if>
            <if test="item == 'issue'">
                COALESCE(d.issue_incre, 0) AS issue_incre
            </if>
            <if test="item == 'comment'">
                COALESCE(d.comment_incre, 0) AS comment_incre
            </if>
        </foreach>
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
    <foreach collection="eventList" item="item" separator=", ">
        <if test="item == 'pr'">
            pr_incre,
            SUM(pr_incre) OVER (PARTITION BY ${columnStr} ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pr_total
        </if>
        <if test="item == 'issue'">
            issue_incre,
            SUM(issue_incre) OVER (PARTITION BY ${columnStr} ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS issue_total
        </if>
        <if test="item == 'comment'">
            comment_incre,
            SUM(comment_incre) OVER (PARTITION BY ${columnStr} ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS comment_total
        </if>
    </foreach>
from joined_data
order by date;
""";
return db.select(sql)

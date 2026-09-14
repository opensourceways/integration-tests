{
  "properties" : { },
  "id" : "user_level_detail_001",
  "script" : null,
  "groupId" : "905e0bee16764ec9be1e96b78cae9466",
  "name" : "用户等级详情",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/level/detail",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"community\":\"openeuler\",\r\n    \"level\":\"D1\",\r\n    \"date\":\"2025-01-15\",\r\n    \"repo_path\":\"kernel\",\r\n    \"start\":1736899200000,\r\n    \"end\":1768503200000\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"user_login\": \"developer1\",\n        \"contrib_type\": \"pr\",\n        \"contribute_time\": \"2025-01-15T10:30:00Z\",\n        \"html_url\": \"https://github.com/openeuler/kernel/pull/123\",\n        \"level\": \"D1\"\n    }]\n}",
  "description" : "查询在某时间点成为某等级的用户及其贡献详情",
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
      "name" : "community",
      "value" : "openeuler",
      "description" : "社区名",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "level",
      "value" : "D1",
      "description" : "等级（D0/D1/D2）",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "level 只能为 D0、D1 或 D2",
      "expression" : "^(D0|D1|D2)$",
      "children" : [ ]
    }, {
      "name" : "date",
      "value" : "2025-01-15",
      "description" : "日期（YYYY-MM-DD）",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "date 格式非法",
      "expression" : "^\\d{4}-\\d{2}-\\d{2}$",
      "children" : [ ]
    }, {
      "name" : "repo_path",
      "value" : "kernel",
      "description" : "仓库路径（可选）",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "1736899200000",
      "description" : "开始时间（毫秒）",
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
      "value" : "1768503200000",
      "description" : "结束时间（毫秒）",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "operation",
      "value" : "increase",
      "description" : "下钻模式：increase=增量(本周期内首次达到等级的新人)，total=总量(本周期内累计已达等级的人，同 increase 口径仅算周期内首次达等级者)，active=当期活跃(周期内全部贡献)",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "increase",
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "1",
      "description" : "页码",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "1",
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "20",
      "description" : "每页条数",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "20",
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
          "name" : "namespace",
          "value" : "",
          "description" : "组织命名空间",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "repo_path",
          "value" : "",
          "description" : "仓库路径",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "user_login",
          "value" : "",
          "description" : "用户登录名",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "contrib_type",
          "value" : "",
          "description" : "贡献类型（pr/issue/comment/swf）",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "contribute_time",
          "value" : "",
          "description" : "贡献时间",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "html_url",
          "value" : "",
          "description" : "链接",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "level",
          "value" : "",
          "description" : "等级",
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
          "value" : "",
          "description" : "总数",
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
  }
}
================================
var community = body.community.toLowerCase();
var level = body.level;
var date_str = body.date;
var repo_path = body.repo_path;
var start_ts = body.start;
var end_ts = body.end;
// 筛选参数（与 用户活跃(有效).ms 对齐，下钻详情须同步应用筛选）
var source = body.source;
var orgList = body.orgList;
var internalList = body.internalList;
var private = body.private;
// 下钻模式：increase=增量(本周期内首次达到等级的新人)，total=总量(从图表起点累计到该周期末已达等级的人，对齐图表 用户趋势.ms 的 total=SUM(increase) OVER(UNBOUNDED PRECEDING) 从图表 start 累加)，active=当期活跃(周期内全部贡献)
var operation = body.operation == null ? 'increase' : body.operation;
// 分页
var pageNum = body.pageNum == null ? 1 : body.pageNum;
var pageSize = body.pageSize == null ? 20 : body.pageSize;
var offset = (pageNum - 1) * pageSize;
// 时间下界：increase/active=该点周期起点(start)，total=图表起点(chartStart)用于累计；
// 前端 fetchLevelDetail 传 chartStart=图表完整范围起点，start/end=该点所在周期
var chart_start_ts = body.chartStart;
var lower_ts = (operation == 'total' && chart_start_ts != null) ? chart_start_ts : body.start;

var userTable = (repo_path != null && repo_path != '') ? "dwm_" + community + "_contribute_user_repo" : "dwm_" + community + "_contribute_user";
var contributeTable = "dws_" + community + "_contribute";
var swfTable = "dws_" + community + "_swf";
var prTable = "fact_" + community + "_pr";
var userCompanyTable = "dws_" + community + "_user_company";

var levelTimeField = "";
if (level == "D0") {
    levelTimeField = "d0_time";
} else if (level == "D1") {
    levelTimeField = "d1_time";
} else if (level == "D2") {
    levelTimeField = "d2_time";
}

// 活动类型过滤：每个等级对应的活动口径（与 D0/D1/D2 定义一致，含联合开发者）
// D0 = swf + pr/issue/comment + co-author pr
// D1 = pr/issue/comment + co-author pr
// D2 = merged pr + 合入 pr 的联合开发者
var levelCondition = "";
if (level == "D0") {
    levelCondition = "1=1"; // swf + 所有 contribute 类型
} else if (level == "D1") {
    levelCondition = "act.contrib_type in ('pr', 'issue', 'comment')";
} else if (level == "D2") {
    levelCondition = "act.contrib_type = 'pr' and act.state = 'merged'";
}

var sql = """
WITH -- 下界 lower_ts: increase/active=该点周期起点(start)，total=图表起点(chartStart)累计到该点末；对齐图表 用户趋势.ms 的 total=SUM(increase) OVER(UNBOUNDED PRECEDING) 从图表 start 累加
level_users AS (
    SELECT
        <if test="repo_path != null and repo_path != ''">
        namespace, repo_path,
        </if>
        user_login
    FROM ${userTable}
    <where>
        ${levelTimeField} IS NOT NULL
        AND ${levelTimeField} >= to_timestamp(#{lower_ts}/1000)
        AND ${levelTimeField} <= to_timestamp(#{end_ts}/1000)
        <if test="repo_path != null and repo_path != ''">
            and repo_path = #{repo_path}
        </if>
        and user_login not in (select user_login from fact_community_robot_user)
    </where>
),
-- 周期内全部活动（swf + contribute + 联合开发者 pr），统一结构，带 namespace/repo_path
all_activities AS (
    -- swf（star/watch/fork）
    SELECT
        dswf.namespace,
        dswf.repo_path,
        dswf.user_login,
        'swf' as contrib_type,
        dswf.created_at as contribute_time,
        dswf.html_url,
        null as state
    FROM ${swfTable} dswf
    <where>
        dswf.is_hide is null
        AND dswf.user_login != ''
        AND dswf.created_at >= to_timestamp(#{lower_ts}/1000)
        AND dswf.created_at <= to_timestamp(#{end_ts}/1000)
        <if test="repo_path != null and repo_path != ''">
            and dswf.repo_path = #{repo_path}
        </if>
        <if test="source != null and source != ''">
            AND dswf.code_platform = #{source}
        </if>
        <if test="orgList != null and orgList.size() > 0">
            AND dswf.namespace in
            <foreach collection="orgList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="internalList != null and internalList.size() > 0">
            AND dswf.internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="private != null and private != ''">
            AND dswf.private = #{private}
        </if>
    </where>

    UNION ALL

    -- pr/issue/comment
    SELECT
        dcc.namespace,
        dcc.repo_path,
        dcc.user_login,
        dcc.contrib_type,
        dcc.created_at as contribute_time,
        dcc.html_url,
        dcc.state
    FROM ${contributeTable} dcc
    <where>
        dcc.is_hide is null
        AND dcc.user_login != ''
        AND dcc.created_at >= to_timestamp(#{lower_ts}/1000)
        AND dcc.created_at <= to_timestamp(#{end_ts}/1000)
        <if test="repo_path != null and repo_path != ''">
            and dcc.repo_path = #{repo_path}
        </if>
        <if test="source != null and source != ''">
            AND dcc.code_platform = #{source}
        </if>
        <if test="orgList != null and orgList.size() > 0">
            AND dcc.namespace in
            <foreach collection="orgList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="internalList != null and internalList.size() > 0">
            AND dcc.internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="private != null and private != ''">
            AND dcc.private = #{private}
        </if>
    </where>

    UNION ALL

    -- 联合开发者（co-authored pr），取 merged pr 的合入时间；namespace/repo_path 取自 PR 作者(同 PR 作者逻辑)
    SELECT
        dcc.namespace,
        dcc.repo_path,
        coauthor AS user_login,
        'pr' as contrib_type,
        COALESCE(dcc.merged_at, dcc.updated_at, dcc.created_at) as contribute_time,
        dcc.html_url,
        dcc.state
    FROM ${prTable} pr
    JOIN ${contributeTable} dcc
      ON dcc.contrib_type = 'pr'
     AND dcc.code_platform = pr.code_platform
     AND dcc.uuid = CONCAT('pr', '-', pr.uuid)
    CROSS JOIN LATERAL jsonb_array_elements_text(
        CASE WHEN jsonb_typeof(pr.co_authored_by) = 'array'
             THEN pr.co_authored_by ELSE '[]'::jsonb END
    ) AS coauthor
    LEFT JOIN LATERAL (
        SELECT uct.internal
        FROM ${userCompanyTable} uct
        WHERE lower(uct.user_login) = lower(coauthor)
          AND uct.code_platform = dcc.code_platform
        ORDER BY uct.start_date DESC NULLS LAST
        LIMIT 1
    ) uc ON true
    <where>
        dcc.is_hide is null
        AND dcc.is_removed is null
        AND dcc.state = 'merged'
        AND pr.co_authored_by IS NOT NULL
        AND jsonb_typeof(pr.co_authored_by) = 'array'
        AND coauthor IS NOT NULL
        AND coauthor != ''
        AND coauthor != dcc.user_login
        AND COALESCE(dcc.merged_at, dcc.updated_at, dcc.created_at) >= to_timestamp(#{lower_ts}/1000)
        AND COALESCE(dcc.merged_at, dcc.updated_at, dcc.created_at) <= to_timestamp(#{end_ts}/1000)
        <if test="repo_path != null and repo_path != ''">
            and dcc.repo_path = #{repo_path}
        </if>
        <if test="source != null and source != ''">
            AND dcc.code_platform = #{source}
        </if>
        <if test="orgList != null and orgList.size() > 0">
            AND dcc.namespace in
            <foreach collection="orgList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="internalList != null and internalList.size() > 0">
            AND COALESCE(uc.internal, '外部') in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="private != null and private != ''">
            AND dcc.private = #{private}
        </if>
    </where>
),
-- 按等级口径过滤活动 + 排除机器人
filtered_activities AS (
    SELECT act.*
    FROM all_activities act
    WHERE ${levelCondition}
      AND act.user_login not in (select user_login from fact_community_robot_user)
),
-- increase/total：各取其最早一条(=首次达等级 d{N}_time 那条)贡献；increase=该点周期内新增，total=从图表起点累计到该点末(对齐图表 用户趋势.ms 的 total=SUM(increase) OVER(UNBOUNDED PRECEDING))
-- DISTINCT ON 须按 user_login 去重(对齐图表 用户趋势.ms 的 COUNT(DISTINCT user_login))，
-- 每人只返回其最早一条=首次达等级(d{N}_time)那条贡献；若按 (namespace,repo_path,user_login) 去重，
-- 跨多仓库/多 namespace 的同一用户会产出多条 → 下钻条数 > 图表人数
increase_data AS (
    SELECT DISTINCT ON (fa.user_login)
        fa.namespace,
        fa.repo_path,
        fa.user_login,
        fa.contrib_type,
        fa.contribute_time,
        fa.html_url,
        #{level} as level
    FROM filtered_activities fa
    INNER JOIN level_users lu
      ON fa.user_login = lu.user_login
      <if test="repo_path != null and repo_path != ''">
      AND fa.namespace = lu.namespace
      AND fa.repo_path = lu.repo_path
      </if>
    ORDER BY fa.user_login, fa.contribute_time ASC
),
-- 活跃模式：周期内全部活动（所有活跃用户，人数按维度组合去重对齐图表）
active_data AS (
    SELECT
        fa.namespace,
        fa.repo_path,
        fa.user_login,
        fa.contrib_type,
        fa.contribute_time,
        fa.html_url,
        #{level} as level
    FROM filtered_activities fa
),
selected_data AS (
    <if test="operation == 'active'">
    SELECT * FROM active_data
    </if>
    <if test="operation != 'active'">
    SELECT * FROM increase_data
    </if>
),
count_data AS (
    SELECT count(*) as total_count FROM selected_data
)
SELECT
    sd.namespace,
    sd.repo_path,
    sd.user_login,
    sd.contrib_type,
    sd.contribute_time,
    sd.html_url,
    sd.level,
    cd.total_count
FROM selected_data sd
CROSS JOIN count_data cd
ORDER BY sd.contribute_time DESC
LIMIT #{pageSize} OFFSET #{offset}
""";

var query_data = db.select(sql);
return query_data;
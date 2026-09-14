{
  "properties" : { },
  "id" : "wb1153usercheck0000000000000001",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "查看用户采集情况",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/usercheck",
  "method" : "GET",
  "parameters" : [ {
    "name" : "gitcode_id",
    "value" : "xiaohua-zhang",
    "description" : "gitcode 登录名（三者任填其一）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : "gitcode_id 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "gitee_id",
    "value" : "",
    "description" : "gitee 登录名（三者任填其一）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : "gitee_id 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "github_id",
    "value" : "",
    "description" : "github 登录名（三者任填其一）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : "github_id 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "start_time",
    "value" : "",
    "description" : "可选，yyyy-MM-dd，只统计该时间之后更新的数据",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : "start_time 格式应为 yyyy-MM-dd",
    "expression" : "^(\\d{4}-\\d{2}-\\d{2})?$",
    "children" : null
  } ],
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"status\": \"collected\",\n        \"configured\": true,\n        \"collected\": true,\n        \"user\": {\"name\": \"张三\", \"w3_id\": \"z00xxxx\", \"emails\": \"zhangsan@huawei.com\"},\n        \"summary\": [\n            {\"kind\": \"pr\", \"code_platform\": \"gitcode\", \"cnt\": 12, \"latest\": \"2026-05-11 08:35:26\"},\n            {\"kind\": \"comment\", \"code_platform\": \"gitcode\", \"cnt\": 40, \"latest\": \"2026-05-10 18:00:00\"}\n        ],\n        \"reason\": \"已采集到您的贡献。若塔台页面仍未显示，请等待数据同步（约1天）。\"\n    },\n    \"timestamp\": 1778464014786,\n    \"executeTime\": 12\n}",
  "description" : "issue#1153 用户自助诊断：用户认为“我贡献了很多代码却没看到贡献”，本接口按 github/gitee/gitcode 登录名告诉他【为什么】——①是否在塔台配置 ②是否采集到贡献(PR/Issue/Comment 概况) ③采到但没显示=等同步/仓库未在采集范围/邮箱未绑定。只读，不触发任何 DataArts job，无 header 密钥门禁。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import org.ssssssss.script.parsing.ast.statement.Return

var github_id_t = github_id
var gitee_id_t = gitee_id
var gitcode_id_t = gitcode_id
var start_time_t = start_time

// 塔台配置入口（与 whitebox_check 的 tatai_config_page / tatai_rd_page 保持一致）
var TATAI_CONFIG = "https://tatai.rnd.huawei.com/index.html#/mcCenter/mcCodeTips/blueZone/blueZoneCodeConfig"
var TATAI_DOC = "https://wiki.huawei.com/domains/6240/wiki/16631/WIKI202312262626776"

// 0. 至少填一个登录名
if ((github_id_t == null || github_id_t == '')
    && (gitee_id_t == null || gitee_id_t == '')
    && (gitcode_id_t == null || gitcode_id_t == '')) {
    return {status: "no_input", configured: false, collected: false, summary: [],
            reason: "请至少填写 github_id / gitee_id / gitcode_id 之一"}
}

// 1. 先查“塔台是否配置过这个人”——蓝区用户主表 fact_blue_user（塔台配置的 PG 镜像）
var user_sql = """
select uuid, w3_id, name, gitee_id, github_id, gitcode_id,
       COALESCE(emails, '') as emails
from dwm_blue_user
where 1 = 0
    <if test="github_id_t != null and github_id_t != '' "> or github_id  = #{github_id_t}  </if>
    <if test="gitee_id_t  != null and gitee_id_t  != '' "> or gitee_id   = #{gitee_id_t}   </if>
    <if test="gitcode_id_t!= null and gitcode_id_t!= '' "> or gitcode_id = #{gitcode_id_t} </if>
limit 1
"""
var users = db.select(user_sql)

// 1.1 不在塔台 → 直接告诉用户去塔台配置（这是“看不到贡献”最常见的根因）
if (users == null || users.size() == 0) {
    return {
        status: "not_configured",
        configured: false,
        collected: false,
        summary: [],
        reason: "您填写的账号未在塔台配置代码贡献信息，所以贡献无法被采集与展示。请先在塔台页面 " + TATAI_CONFIG + " 配置您的 gitee/gitcode/github 账号与提交邮箱；配置文档详见：" + TATAI_DOC
    }
}
var u = users[0]

// 2. 已配置 → 统计采集到的贡献概况（PR/Issue 来自 fact_whitebox_pr/issue，Comment 来自 dws_whitebox_contribute）
var sum_sql = """
select kind, code_platform, count(*) as cnt, max(updated_at) as latest
from (
    select 'pr' as kind, code_platform, updated_at, user_login from fact_whitebox_pr
    union all
    select 'issue' as kind, code_platform, updated_at, user_login from fact_whitebox_issue
    union all
    select 'comment' as kind, code_platform, updated_at, user_login from dws_whitebox_contribute where is_comment = 1
) t
where (
    1 = 0
    <if test="github_id_t != null and github_id_t != '' "> or (code_platform = 'github'  and user_login = #{github_id_t}) </if>
    <if test="gitee_id_t  != null and gitee_id_t  != '' "> or (code_platform = 'gitee'   and user_login = #{gitee_id_t})  </if>
    <if test="gitcode_id_t!= null and gitcode_id_t!= '' "> or (code_platform = 'gitcode' and user_login = #{gitcode_id_t})</if>
)
<if test="start_time_t != null and start_time_t != '' "> and updated_at >= #{start_time_t} </if>
group by kind, code_platform
order by kind, code_platform
"""
var summary = db.select(sum_sql)
var has = summary != null && summary.size() > 0

var reason = ""
if (has) {
    reason = "已采集到您的贡献。若塔台页面仍未显示，通常是数据还在同步（约 1 天/自动同步），请稍后再看。"
} else {
    // 已在塔台、却没采到——给出“为什么看不到”的可排查方向
    reason = "您已在塔台配置，但当前未采集到您的贡献。常见原因：① 您贡献的仓库未在采集范围（请在“采集数据维护”页确认该仓库已配置采集）；② 您的 commit 提交邮箱未绑定到塔台账号（塔台当前登记邮箱：" + u.emails + "），请在塔台补充提交邮箱；③ 数据正在采集中，请稍后再查。仍有疑问可联系数据中台。"
}

return {
    status: has ? "collected" : "configured_no_data",
    configured: true,
    collected: has,
    user: {name: u.name, w3_id: u.w3_id, emails: u.emails},
    summary: summary == null ? [] : summary,
    reason: reason
}

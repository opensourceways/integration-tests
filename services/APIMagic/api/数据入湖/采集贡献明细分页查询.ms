{
  "properties" : { },
  "id" : "wb1153bluecontrib000000000001",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "采集贡献明细分页查询",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/blue-records",
  "method" : "GET",
  "parameters" : [ {
    "name" : "types", "value" : "", "description" : "类型多选，逗号分隔：pr,issue,commit", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "types 非法", "expression" : "^[a-zA-Z,]*$", "children" : null
  }, {
    "name" : "platforms", "value" : "", "description" : "平台多选，逗号分隔：gitee,github,gitcode", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "platforms 非法", "expression" : "^[a-zA-Z,]*$", "children" : null
  }, {
    "name" : "creator", "value" : "", "description" : "贡献者模糊（name/各平台账号/邮箱）", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "creator 非法", "expression" : "^[^%'\";\\\\]*$", "children" : null
  }, {
    "name" : "title", "value" : "", "description" : "标题模糊", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "title 非法", "expression" : "^[^%'\";\\\\]*$", "children" : null
  }, {
    "name" : "repo", "value" : "", "description" : "仓库模糊", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "repo 非法", "expression" : "^[^%'\";\\\\]*$", "children" : null
  }, {
    "name" : "asc", "value" : "", "description" : "升序列：creator/repo/created_at", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "asc 非法", "expression" : "^[a-zA-Z_]*$", "children" : null
  }, {
    "name" : "desc", "value" : "", "description" : "降序列：creator/repo/created_at", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "desc 非法", "expression" : "^[a-zA-Z_]*$", "children" : null
  }, {
    "name" : "page", "value" : "1", "description" : "页码", "required" : false,
    "dataType" : "Integer", "defaultValue" : "1", "validateType" : null, "error" : null, "expression" : null, "children" : null
  }, {
    "name" : "size", "value" : "10", "description" : "每页条数", "required" : false,
    "dataType" : "Integer", "defaultValue" : "10", "validateType" : null, "error" : null, "expression" : null, "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "", "headers" : [ ], "paths" : [ ], "responseBody" : "",
  "description" : "issue#1153 用户检查数据页：塔台贡献明细 async 分页。读 fact_all_blue_contribute（由 blue_pipeline 把 ES blue_zone_user_contributes 同步而来），后端按 类型多选/平台多选/贡献者/标题/仓库 过滤 + 排序。只读 db.backup。",
  "requestBodyDefinition" : null, "responseBodyDefinition" : null
}
================================
// issue#1153 塔台贡献明细 async 分页（后端过滤 + 排序），只读 fact_all_blue_contribute
var page_t = (page == null || page == '') ? 1 : page
var size_t = (size == null || size == '') ? 10 : size
var offset = (page_t - 1) * size_t

// commit 行原始 url 为空，按 仓库/commit/<sha> 拼链接
var urlexpr = "COALESCE(NULLIF(url,''), CASE WHEN contribute_type='commit' AND COALESCE(commit_id,'')<>'' THEN repo || '/commit/' || commit_id ELSE NULL END)"
// user_login：按平台取对应账号（与全量表 user_login 口径一致）
var userloginexpr = "COALESCE(NULLIF(CASE WHEN code_platform='github' THEN github_id WHEN code_platform='gitee' THEN gitee_id WHEN code_platform='gitcode' THEN gitcode_id END,''), NULLIF(gitcode_id,''), NULLIF(gitee_id,''), NULLIF(github_id,''))"
var cols = "contribute_type as type, COALESCE(NULLIF(user_name,''), NULLIF(gitcode_id,''), NULLIF(gitee_id,''), NULLIF(github_id,'')) as creator, " + userloginexpr + " as user_login, gitee_id, github_id, gitcode_id, emails, code_platform, repo, title, issue_state as state, " + urlexpr + " as url, created_at"

var conds = ''
// 类型多选 -> IN
if (types != null && types != '') {
    var tlist = ''
    for (x in types.split(',')) {
        var tt = x.trim()
        if (tt != '' && tt.matches('[a-zA-Z]+')) { tlist = (tlist == '' ? "'" + tt + "'" : tlist + ",'" + tt + "'") }
    }
    if (tlist != '') { conds = "contribute_type in (" + tlist + ")" }
}
// 平台多选 -> IN
if (platforms != null && platforms != '') {
    var plist = ''
    for (p in platforms.split(',')) {
        var pp = p.trim()
        if (pp != '' && pp.matches('[a-zA-Z]+')) { plist = (plist == '' ? "'" + pp + "'" : plist + ",'" + pp + "'") }
    }
    if (plist != '') { var c5 = "code_platform in (" + plist + ")"; conds = (conds == '' ? c5 : conds + " and " + c5) }
}
var creatorlike = '%' + (creator == null ? '' : creator) + '%'
var titlelike = '%' + (title == null ? '' : title) + '%'
var repolike = '%' + (repo == null ? '' : repo) + '%'
if (creator != null && creator != '') { var c1 = "(COALESCE(user_name,'') ilike #{creatorlike} or COALESCE(gitcode_id,'') ilike #{creatorlike} or COALESCE(gitee_id,'') ilike #{creatorlike} or COALESCE(github_id,'') ilike #{creatorlike} or COALESCE(emails,'') ilike #{creatorlike})"; conds = (conds == '' ? c1 : conds + " and " + c1) }
if (title != null && title != '') { var c2 = "COALESCE(title,'') ilike #{titlelike}"; conds = (conds == '' ? c2 : conds + " and " + c2) }
if (repo != null && repo != '') { var c4 = "COALESCE(repo,'') ilike #{repolike}"; conds = (conds == '' ? c4 : conds + " and " + c4) }
var where = (conds == '') ? '' : (" where " + conds)

// 排序白名单
var sortexpr = ''
var dir = ''
if (asc != null && asc != '') { dir = 'asc'; sortexpr = (asc == 'creator') ? 'user_name' : ((asc == 'repo') ? 'repo' : 'created_at') }
else if (desc != null && desc != '') { dir = 'desc'; sortexpr = (desc == 'creator') ? 'user_name' : ((desc == 'repo') ? 'repo' : 'created_at') }
var order = (sortexpr == '') ? " order by created_at desc nulls last " : (" order by " + sortexpr + " " + dir + " nulls last ")

var sql = "select " + cols + " from fact_all_blue_contribute" + where + order + " limit #{size_t} offset #{offset}"
// 大表计数上限：塔台贡献明细 comment 类型可达百万级，精确 COUNT(*) 会扫全集致卡顿。
// 配合 fact_all_blue_contribute 的 (contribute_type, created_at) 索引，LIMIT 让计数扫到上限即停。
var count_cap = 100000
var totalsql = "select count(*) as total from (select 1 from fact_all_blue_contribute" + where + " limit " + count_cap + ") t"
var data = db.backup.select(sql)
var total = db.backup.select(totalsql)
var totalval = total.get(0).get("total")
HashMap res = new HashMap();
res.put("list", data)
res.put("total", totalval)
// total_capped=true 表示真实总数 >= count_cap（前端可展示“10万+”）
res.put("total_capped", totalval >= count_cap)
return res

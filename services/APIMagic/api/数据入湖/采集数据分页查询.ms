{
  "properties" : { },
  "id" : "wb1153records00000000000000001",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "采集数据分页查询",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/records",
  "method" : "GET",
  "parameters" : [ {
    "name" : "type", "value" : "pr", "description" : "实体类型：pr/issue/comment/commit", "required" : false,
    "dataType" : "String", "defaultValue" : "pr", "validateType" : "pattern", "error" : "type 非法", "expression" : "^(pr|issue|comment|commit)?$", "children" : null
  }, {
    "name" : "platforms", "value" : "", "description" : "平台多选，逗号分隔：github,gitcode", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "platforms 非法", "expression" : "^[a-zA-Z,]*$", "children" : null
  }, {
    "name" : "creator", "value" : "", "description" : "创建人模糊", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "creator 非法", "expression" : "^[^%'\";\\\\]*$", "children" : null
  }, {
    "name" : "title", "value" : "", "description" : "标题模糊", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "title 非法", "expression" : "^[^%'\";\\\\]*$", "children" : null
  }, {
    "name" : "url", "value" : "", "description" : "URL 模糊", "required" : false,
    "dataType" : "String", "defaultValue" : "", "validateType" : "pattern", "error" : "url 非法", "expression" : "^[^%'\";\\\\]*$", "children" : null
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
  "description" : "issue#1153 用户检查数据页：采集数据 async 分页（pr/issue/comment/commit），后端按 平台多选/创建人/标题/URL/仓库 过滤 + 排序。只读 db.backup。",
  "requestBodyDefinition" : null, "responseBodyDefinition" : null
}
================================
// issue#1153 采集数据 async 分页（后端过滤 + 排序），只读 fact_all_*
var t = (type == null || type == '') ? 'pr' : type
var page_t = (page == null || page == '') ? 1 : page
var size_t = (size == null || size == '') ? 10 : size
var offset = (page_t - 1) * size_t

// 每类型的列映射
var tbl = ''; var ucol = 'user_login'; var creatorsel = 'user_login'; var creatorfilter = 'user_login'; var titlecol = ''; var urlcol = ''; var repoexpr = ''; var repofull = ''; var pcol = ''
if (t == 'commit') {
    tbl = 'fact_all_git_commit'; pcol = 'platform'; titlecol = 'title'; urlcol = 'commit_url'
    creatorsel = "COALESCE(NULLIF(user_login,''),NULLIF(author,''),email)"
    creatorfilter = "(COALESCE(user_login,'')||' '||COALESCE(author,'')||' '||COALESCE(email,''))"
    repofull = "COALESCE(NULLIF(split_part(COALESCE(commit_url,''),'/commit/',1),''), 'https://'||platform||'.com/'||COALESCE(owner,'')||'/'||COALESCE(repo,''))"
    repoexpr = repofull
} else if (t == 'comment') {
    tbl = 'fact_all_comment'; pcol = 'code_platform'; titlecol = 'body'; urlcol = 'html_url'
    repoexpr = "(COALESCE(namespace,'')||'/'||COALESCE(repo_path,''))"
    repofull = "('https://'||code_platform||'.com/'||COALESCE(namespace,'')||'/'||COALESCE(repo_path,''))"
} else {
    tbl = (t == 'issue') ? 'fact_all_issue' : 'fact_all_pr'; pcol = 'code_platform'; titlecol = 'title'; urlcol = 'html_url'
    repoexpr = "(COALESCE(namespace,'')||'/'||COALESCE(repo_path,''))"
    repofull = "('https://'||code_platform||'.com/'||COALESCE(namespace,'')||'/'||COALESCE(repo_path,''))"
}
var titlesel = (t == 'comment') ? "left(COALESCE(body,''),60)" : "COALESCE(title,'')"
var cols = creatorsel + " as creator, " + titlesel + " as title, " + urlcol + " as url, created_at, " + repofull + " as repo, " + pcol + " as code_platform"

// 过滤条件（值用 #{} 绑定）
var creatorlike = '%' + (creator == null ? '' : creator) + '%'
var titlelike = '%' + (title == null ? '' : title) + '%'
var urllike = '%' + (url == null ? '' : url) + '%'
var repolike = '%' + (repo == null ? '' : repo) + '%'
var conds = ''
if (creator != null && creator != '') { conds = creatorfilter + " ilike #{creatorlike}" }
if (title != null && title != '') { var c2 = titlecol + " ilike #{titlelike}"; conds = (conds == '' ? c2 : conds + " and " + c2) }
if (url != null && url != '') { var c3 = urlcol + " ilike #{urllike}"; conds = (conds == '' ? c3 : conds + " and " + c3) }
if (repo != null && repo != '') { var c4 = repoexpr + " ilike #{repolike}"; conds = (conds == '' ? c4 : conds + " and " + c4) }
// 平台多选 -> IN
if (platforms != null && platforms != '') {
    var plist = ''
    for (p in platforms.split(',')) {
        var pp = p.trim()
        if (pp != '' && pp.matches('[a-zA-Z]+')) { plist = (plist == '' ? "'" + pp + "'" : plist + ",'" + pp + "'") }
    }
    if (plist != '') { var c5 = pcol + " in (" + plist + ")"; conds = (conds == '' ? c5 : conds + " and " + c5) }
}
var where = (conds == '') ? '' : (" where " + conds)

// 排序白名单
var sortexpr = ''
var dir = ''
if (asc != null && asc != '') { dir = 'asc'; sortexpr = (asc == 'creator') ? ucol : ((asc == 'repo') ? repoexpr : 'created_at') }
else if (desc != null && desc != '') { dir = 'desc'; sortexpr = (desc == 'creator') ? ucol : ((desc == 'repo') ? repoexpr : 'created_at') }
var order = (sortexpr == '') ? " order by created_at desc nulls last " : (" order by " + sortexpr + " " + dir + " nulls last ")

var sql = "select " + cols + " from " + tbl + where + order + " limit #{size_t} offset #{offset}"
var totalsql = "select count(*) as total from " + tbl + where
var data = db.backup.select(sql)
var totalval
if (conds == '') {
    var est = db.backup.select("select reltuples::bigint as total from pg_class where relname = '" + tbl + "'")
    var ev = (est != null && est.size() > 0) ? est.get(0).get("total") : null
    totalval = (ev != null && ev >= 0) ? ev : db.backup.select(totalsql).get(0).get("total")
} else {
    totalval = db.backup.select(totalsql).get(0).get("total")
}
HashMap res = new HashMap();
res.put("list", data)
res.put("total", totalval)
return res

{
  "properties" : { },
  "id" : "wb1153diagnoseurl000000000000001",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "按链接诊断数据未统计",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/diagnose",
  "method" : "GET",
  "parameters" : [ {
    "name" : "url",
    "value" : "https://gitcode.com/Ascend/FSDPTurbo/pull/22",
    "description" : "PR / Issue / Comment / Commit 的完整链接（github/gitee/gitcode）",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : "请粘贴 http(s) 开头的完整链接",
    "expression" : "^https?://.+$",
    "children" : null
  }, {
    "name" : "verify",
    "value" : "0",
    "description" : "是否外呼 gitcode/github API 核实链接真实存在（0=否，默认；1=是）。prod 到公网可能不通会卡，默认关，只用库判断。",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "0",
    "validateType" : "pattern",
    "error" : "verify 只能是 0/1",
    "expression" : "^[01]?$",
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
  "responseBody" : "",
  "description" : "issue#1153 用户自助诊断（按链接）→ 返回横向两行诊断树。第一行=贡献数据链(仓库配置→原始仓库表→PR/Issue/Commit/Comment原始表→DWS聚合表→蓝区用户贡献表→塔台接口)；第二行=用户登记链(蓝区塔台配置→蓝区用户表)。每节点带 ok/detail/table；PR 显 state(仅 merged 计入)；Comment 按 anchor(#tid-/#issuecomment-/#note_)抽评论id，区分 pr_comment/issue_comment，源表查 fact_all_comment；断点标 is_breakpoint，前提满足时 can_sync=true 给同步按钮。兼容旧字段 status/reason/next。只读。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// ====== issue#1153 用户自助诊断：按链接 → 横向两行诊断树（只读，不写库、不触发采集）======
// 全查 PG（生产 db=144 / db.backup=247，均已在 108 核实）：
//   db=144(活库:fact_<社区>_pr/issue、dws_<社区>_contribute、dwm_blue_user、fact_blue_user)；db.backup=247(dict_*/fact_branch_collect_status/fact_all_git_commit/fact_all_blue_contribute)
//   登记读 dwm_blue_user、聚合读 fact_all_blue_contribute（= ES blue_zone_user_contributes 经 blue_contribute_sync 同步的那份，塔台/平台直读，有同步任务保新鲜）
// import http 仅用于 gitcode/github 平台存在性核实（api.gitcode.com / api.github.com）。
import http;
var TATAI = "https://tatai.rnd.huawei.com/quality/code-reviews/#/blue-config/account"
var REPO_CONFIG = "https://gitee.com/opensourceway/om-data/blob/master/src/upstream/white_box.yaml"

// ---------- 1. 解析链接 ----------
var raw = url == null ? '' : url.trim()
var u = raw
var qi = u.indexOf('?'); if (qi >= 0) { u = u.substring(0, qi) }
var hi = u.indexOf('#'); if (hi >= 0) { u = u.substring(0, hi) }
while (u.endsWith('/')) { u = u.substring(0, u.length() - 1) }
var plat = ''
if (u.contains('github.com')) { plat = 'github' }
else if (u.contains('gitee.com')) { plat = 'gitee' }
else if (u.contains('gitcode.com') || u.contains('code.tencent.com')) { plat = 'gitcode' }
if (plat == '') { return {status: "parse_error", ok: false, reason: "无法识别平台，仅支持 github / gitee / gitcode 链接"} }
var noScheme = u.replace('https://', '').replace('http://', '')
var parts = noScheme.split('/')
if (parts.length < 4) { return {status: "parse_error", ok: false, reason: "链接格式不完整，应形如 .../{owner}/{repo}/(pull|issues|commit)/{编号}"} }
var owner = parts[1].toLowerCase()
var repo = parts[2].toLowerCase()
var seg = parts[3]
var num = parts.length > 4 ? parts[4] : ''
var kind = ''
if (seg == 'commit') { kind = 'commit' }
else if (seg == 'pull' || seg == 'pulls' || seg == 'merge_requests') { kind = 'pr' }
else if (seg == 'issues') { kind = 'issue' }
else { return {status: "parse_error", ok: false, reason: "仅支持 PR / Issue / Commit 链接（路径段：" + seg + "）"} }
// 评论识别：从 anchor 按平台抽评论 id。gitcode 评论 anchor=#tid-{id}（不含 comment/note），
// 旧 contains('comment'|'note') 永远漏判 gitcode 评论 → 本次改按 anchor 正则抽 id。
// 抽不到评论 id → 不改 kind（保持 pr/issue，向后兼容；无 anchor 无法判定是评论）。
var cmtId = null; var cmtType = null
var digitsAfter = (s, marker) => {
    var pos = s.indexOf(marker)
    if (pos < 0) { return null }
    var rest = s.substring(pos + marker.length())
    var out = ''; var i = 0
    while (i < rest.length() && rest.substring(i, i + 1).matches('[0-9]')) { out = out + rest.substring(i, i + 1); i = i + 1 }
    return out == '' ? null : out
}
if (kind == 'pr' || kind == 'issue') {
    var hashIdx = raw.indexOf('#')
    var anchor = hashIdx >= 0 ? raw.substring(hashIdx) : ''
    if (anchor != '') {
        if (plat == 'github') {
            cmtId = digitsAfter(anchor, 'issuecomment-')
            if (cmtId == null) { cmtId = digitsAfter(anchor, 'discussion_r') }
        } else if (plat == 'gitcode') {
            cmtId = digitsAfter(anchor, 'tid-')
        } else if (plat == 'gitee') {
            cmtId = digitsAfter(anchor, 'note_')
        }
        if (cmtId != null) {
            kind = 'comment'
            cmtType = (seg == 'pull' || seg == 'pulls' || seg == 'merge_requests') ? 'pr_comment' : 'issue_comment'
        }
    }
}
var idField = plat == 'github' ? 'github_id' : (plat == 'gitee' ? 'gitee_id' : 'gitcode_id')
// 平台存在性核实 API（gitcode / github；gitee 暂不校验）
var apiBase = plat == 'gitcode' ? "https://api.gitcode.com/api/v5/repos/" : (plat == 'github' ? "https://api.github.com/repos/" : null)
var kindLabel = kind == 'pr' ? 'PR' : (kind == 'issue' ? 'Issue' : (kind == 'comment' ? (cmtType == 'pr_comment' ? 'PR评论' : 'Issue评论') : 'Commit'))

// ---------- 2. 社区(定采集配置 + 动态表名) ----------
var rcfg = db.backup.select("select community, collect_enabled, status from dict_repo_collect_config where platform=#{plat} and lower(owner)=#{owner} and lower(repo)=#{repo} limit 1")
var ocfg = db.backup.select("select community, collect_enabled, status from dict_org_collect_config where platform=#{plat} and lower(org_name)=#{owner} limit 1")
var cfg = (rcfg != null && rcfg.size() > 0) ? rcfg[0] : ((ocfg != null && ocfg.size() > 0) ? ocfg[0] : null)
var community = (cfg != null && cfg.community != null && cfg.community != '') ? cfg.community : owner

// ---------- 3. 第一行：贡献数据链 ----------
// N1 仓库配置（仓库级 或 组织级 任一配置即算已纳入采集）
var n1ok = cfg != null
var n1viaOrg = (rcfg == null || rcfg.size() == 0) && (ocfg != null && ocfg.size() > 0)
var n1detail = n1ok
    ? (n1viaOrg ? (owner + "/" + repo + " 未单独配置，但所属组织「" + owner + "」已在采集范围（组织级采集，覆盖组织下全部仓库）")
                : (owner + "/" + repo + "（" + plat + "）已配置采集"))
    : (owner + "/" + repo + "（" + plat + "）未配置采集")
var n1 = {key:"repo_config", label:"仓库配置", table:"dict_repo_collect_config / dict_org_collect_config", ok:n1ok,
    detail: n1detail,
    hint: n1ok ? null : ("请在 white_box.yaml / white_box_org.yaml 或「采集数据维护」页把该仓库或其所属组织加入采集"), hint_url: n1ok ? null : REPO_CONFIG}

// N2 原始仓库表(仓采集状态：区分 未采集 / 采集失败(细分原因) / 已采集)
// status 现在写真实结果：completed / not_found / no_permission / timeout /
// branch_not_found / clone_failed / git_error（历史值 failed）。
// try/catch 兜底：缺列/缺表不让整个诊断崩
var bcs = null
try {
    bcs = db.backup.select("select status, error_message, last_collect_at, case when last_collect_at is null then null else round(extract(epoch from (now()-last_collect_at))/86400) end as days_broken from fact_branch_collect_status where platform=#{plat} and lower(owner)=#{owner} and lower(repo)=#{repo} order by updated_at desc limit 1")
} catch (e2) { bcs = null }
var n2has = bcs != null && bcs.size() > 0
var n2status = n2has ? (bcs[0].status == null ? '' : (bcs[0].status + '')) : ''
var st = n2status.toLowerCase()
var n2msg = n2has ? (bcs[0].error_message == null ? '' : (bcs[0].error_message + '')) : ''
var n2days = n2has ? bcs[0].days_broken : null
// 任何不是 completed/pending/running 的状态都算采集失败（兼容将来新增的失败细分值，
// 不会把 not_found/no_permission 等误判为「已采集」）
var n2failed = n2has && st != '' && st != 'completed' && st != 'pending' && st != 'running'
var n2ok = n2has && !n2failed
// completed 但超过 7 天没成功 = 数据陈旧，标 warn（前端 is-warn）
var n2stale = n2ok && n2days != null && n2days > 7
// 采集记录缺失时，去平台核实仓库是否真的存在/有权限
var repoExists = null
if (!n2has && apiBase != null && verify == '1') {
    try {
        var stR = http.connect(apiBase + parts[1] + "/" + parts[2]).get().getStatusCodeValue()
        repoExists = (stR == 200)
    } catch (exr) {
        var emr = exr == null ? '' : (exr + '')
        if (emr.contains('404') || emr.contains('403') || emr.contains('NotFound') || emr.contains('Forbidden')) { repoExists = false } else { repoExists = null }
    }
}
// 失败 status → 人话 + 维护动作（看到没权限就去重配 token，断了就点重采）
var n2failDetail = ''
if (st == 'no_permission') {
    n2failDetail = "采集凭据无读取权限或 token 已失效 — 到「采集数据维护」更新该仓库 token 后点【重新采集 commit】"
} else if (st == 'not_found') {
    n2failDetail = "仓库在平台不存在（已删除/链接错/或私有仓无权限）— 请核实仓库是否还在"
} else if (st == 'timeout') {
    n2failDetail = "clone 超时（大仓或网络慢）— 点【重新采集 commit】；反复超时联系平台"
} else if (st == 'branch_not_found') {
    n2failDetail = "指定采集的分支在该仓库不存在 — 核实分支名，或改用 default 分支模式"
} else if (st == 'clone_failed') {
    n2failDetail = "克隆失败：" + (n2msg == '' ? '点【重新采集 commit】重试' : n2msg)
} else if (st == 'git_error') {
    n2failDetail = "git 命令失败：" + (n2msg == '' ? '点【重新采集 commit】重试' : n2msg)
} else {
    n2failDetail = "采集失败：" + (n2msg == '' ? '（多为无权限/token 失效）— 点【重新采集 commit】' : n2msg)
}
var n2okDetail = n2stale
    ? ("已采集，但上次成功已是 " + n2days + " 天前 — 数据陈旧，点【重新采集 commit】")
    : ("已采集该仓库（status=" + n2status + "）")
var n2detail = n2failed ? n2failDetail
    : (n2ok ? n2okDetail
    : (repoExists == false ? ("仓库不存在或无访问权限（" + plat + " 上查不到该仓库）")
    : (repoExists == true ? "仓库存在，但采集器还没扫描到它 — 点【重新采集 commit】" : "未见该仓库采集记录 — 采集器可能未跑到此仓，点【重新采集 commit】")))
var n2 = {key:"raw_repo", label:"原始仓库表", table:"fact_branch_collect_status", ok:n2ok, failed:n2failed, warn:n2stale, msg:n2msg, repoExists:repoExists, detail:n2detail}

// N3 PR/Issue/Commit 原始表
var author = null; var prState = null; var prMergedAt = null; var n3ok = false; var n3tbl = ""; var n3detail = ""
var commitEmail = null  // commit 专属：作者提交邮箱（commit 只有 email、无 user_login，靠邮箱关联塔台登记的人）
if (kind == 'pr' || kind == 'issue') {
    n3tbl = "fact_" + community + "_" + kind
    // gitcode 的 /pull/N 在库里存成 /merge_requests/N，html_url 精确匹配会失败 → 优先按 repo_path+number 匹配，html_url 兜底
    // try/catch：社区表不存在（未配置仓库→社区名非法）时不崩，当作未采到
    try {
        var r3 = db.select("select user_login, state, merged_at from " + n3tbl + " where (number=#{num} and lower(repo_path)=#{repo}) or html_url=#{u} or html_url=#{raw} limit 1")
        if (r3 != null && r3.size() > 0) { n3ok = true; author = r3[0].user_login; prState = r3[0].state; prMergedAt = r3[0].merged_at }
    } catch (e3) { n3ok = false }
} else if (kind == 'comment') {
    // 评论源表：fact_all_comment（= 各 fact_{社区}_comment 的全量合并，db.backup 可读；采集数据分页查询.ms 已稳定读它）。
    // 匹配优先级：uuid(PK,={平台}-{评论id}) → id=评论id → html_url=raw/u；并校验平台 + 类型。
    // try/catch 兜底（缺列/缺表不崩，n3ok=false）—— 与 pr/issue 分支一致的写法
    n3tbl = "fact_all_comment"
    try {
        var uuidKey = plat + '-' + cmtId
        var r3c = db.backup.select("select user_login, comment_type from fact_all_comment where code_platform=#{plat} and (uuid=#{uuidKey} or id=#{cmtId} or html_url=#{raw} or html_url=#{u}) and (comment_type=#{cmtType} or comment_type is null) limit 1")
        if (r3c != null && r3c.size() > 0) { n3ok = true; author = r3c[0].user_login }
    } catch (e3c) { n3ok = false }
} else {
    // commit：源在 ES white_box_commits，经增量同步落 PG fact_all_git_commit（本 .ms 只读 PG，不碰 ES、不放密钥）。
    // commit 只有 email、无 user_login → 下方按 email 关联塔台登记的人。commit_id 用前缀匹配（UI SHA=40 位）。
    n3tbl = "fact_all_git_commit"
    var r3g = db.backup.select("select user_login, email from fact_all_git_commit where commit_url=#{u} or commit_url=#{raw} or lower(commit_id)=lower(#{num}) or lower(commit_id) like lower(#{num})||'%' limit 1")
    if (r3g != null && r3g.size() > 0) {
        n3ok = true
        author = r3g[0].user_login == null ? '' : (r3g[0].user_login + '')
        commitEmail = r3g[0].email == null ? '' : (r3g[0].email + '')
    }
}
// 源表没找到 → 去 gitcode 平台核实这条 PR/Issue 到底存不存在（公开仓无需鉴权）
var existsOnPlat = null
if (!n3ok && apiBase != null && (kind == 'pr' || kind == 'issue') && verify == '1') {
    try {
        var apiSeg = kind == 'pr' ? 'pulls' : 'issues'
        var st = http.connect(apiBase + parts[1] + "/" + parts[2] + "/" + apiSeg + "/" + num).get().getStatusCodeValue()
        existsOnPlat = (st == 200)
    } catch (exi) {
        // magic-api http 对 4xx 抛异常：从异常信息识别 404 = 不存在；其他异常 = 无法判定
        var em = exi == null ? '' : (exi + '')
        if (em.contains('404') || em.contains('NotFound')) { existsOnPlat = false } else { existsOnPlat = null }
    }
}
if (kind == 'pr' || kind == 'issue') {
    if (n3ok) { n3detail = "已采集，状态=" + prState + (kind == 'pr' ? (((prMergedAt != null && (prMergedAt + '') != '' && (prMergedAt + '') != 'null') || prState == 'merged') ? "（已合并）" : "（未合并）") : "") }
    else if (existsOnPlat == false) { n3detail = "该链接不存在：" + plat + " 上查不到此" + kindLabel + "，请核对链接" }
    else if (existsOnPlat == true) { n3detail = plat + " 上存在，但尚未采集（采集未运行/未到周期）" }
    else { n3detail = "未找到该" + kindLabel + "（尚未采集，或链接/编号有误）" }
} else if (kind == 'comment') {
    n3detail = n3ok ? ("已采集该" + kindLabel + (author != null && author != '' ? ("，作者 " + author) : "")) : ("未找到该" + kindLabel + "（尚未采集到 fact_all_comment，或链接/评论 id 有误）")
} else {
    n3detail = n3ok ? ("已采集该" + kindLabel + (commitEmail != null && commitEmail != '' ? ("，作者邮箱 " + commitEmail) : "")) : ("未找到该" + kindLabel + "（尚未采集到 fact_all_git_commit，或链接有误）")
}
// 是否已合并：github 的 merged PR 是 state=closed + merged_at 有值（github 无 merged 这个 state）；gitee/gitcode 用 state=merged。统一按 merged_at 判。
var prMerged = (prMergedAt != null && (prMergedAt + '') != '' && (prMergedAt + '') != 'null') || prState == 'merged'
var n3warn = (kind == 'pr' && n3ok && !prMerged)
var n3 = {key:"raw_contrib", label:"源数据表", table:n3tbl, ok:n3ok, warn:n3warn, state:prState, merged:prMerged, author:author, detail:n3detail}

// N4 DWS 聚合表（commit 不经 dws_*_contribute，走 ES commit 索引 → 源采到即视为通过）
var n4ok = false; var n4tbl = "dws_" + community + "_contribute"; var n4n = 0
if (kind == 'commit') {
    n4ok = n3ok; n4tbl = "（commit 不经 DWS）"
} else if (author != null && author != '') {
    var flag = kind == 'issue' ? 'is_issue=1' : (kind == 'comment' ? 'is_comment=1' : 'is_pr=1')
    try {
        var c4 = db.selectInt("select count(*) from " + n4tbl + " where user_login=#{author} and " + flag)
        n4n = c4 == null ? 0 : c4; n4ok = n4n > 0
    } catch (e4) { n4ok = false }
}
var n4 = {key:"dws", label:"DWS聚合表", table:n4tbl, ok:n4ok,
    detail: kind == 'commit' ? "commit 不经 DWS 聚合表，源采集到即可" : (n4ok ? ("已统计该用户" + kindLabel + " " + n4n + " 条") : ("未统计到该用户" + kindLabel))}

// ---------- commit 专属：按作者邮箱把 commit 关联到塔台登记的人（dwm_blue_user.emails 是文本列，ilike 匹配），
//            解析出该人的平台 id，后续 M1/M2/N5/同步复用通用「按 id 查」逻辑（零 ES、零密钥）----------
if (kind == 'commit' && commitEmail != null && commitEmail != '') {
    var mbc = db.select("select gitcode_id, gitee_id, github_id from dwm_blue_user where emails ilike '%'||#{commitEmail}||'%' limit 1")
    if (mbc != null && mbc.size() > 0) {
        var rGitcode = mbc[0].gitcode_id == null ? '' : (mbc[0].gitcode_id + '')
        var rGitee   = mbc[0].gitee_id   == null ? '' : (mbc[0].gitee_id + '')
        var rGithub  = mbc[0].github_id  == null ? '' : (mbc[0].github_id + '')
        if (plat == 'gitcode' && rGitcode != '') { author = rGitcode; idField = 'gitcode_id' }
        else if (plat == 'gitee' && rGitee != '') { author = rGitee; idField = 'gitee_id' }
        else if (plat == 'github' && rGithub != '') { author = rGithub; idField = 'github_id' }
        else if (rGitcode != '') { author = rGitcode; idField = 'gitcode_id' }
        else if (rGitee != '') { author = rGitee; idField = 'gitee_id' }
        else if (rGithub != '') { author = rGithub; idField = 'github_id' }
    }
}

// ---------- 4. 第二行：用户登记链（读 PG 登记表 dwm_blue_user，塔台推送用户经同步任务落这张）----------
var m1ok = false
if (author != null && author != '') {
    var mb = db.select("select 1 from dwm_blue_user where lower(" + idField + ")=lower(#{author}) limit 1")
    m1ok = mb != null && mb.size() > 0
}
var m1 = {key:"tower_config", label:"蓝区塔台配置", table:"dwm_blue_user", ok:m1ok,
    id_field:idField, id_value:author, copyable:true,
    detail: m1ok ? (idField + " = 「" + (author==null?'':author) + "」已在塔台登记") : (idField + " = 「" + (author==null?'':author) + "」未在塔台登记"),
    hint: m1ok ? null : "请到塔台账号配置页登记该账号（注意大小写要与实际一致）", hint_url: m1ok ? null : TATAI}

var m2list = author == null ? null : db.select("select 1 from fact_blue_user where lower(" + idField + ")=lower(#{author}) limit 1")
var m2ok = m2list != null && m2list.size() > 0
var m2 = {key:"blue_user", label:"蓝区用户表", table:"fact_blue_user", ok:m2ok,
    detail: m2ok ? (idField + "=" + (author==null?'':author) + " 用户已配置") : (idField + "=" + (author==null?'':author) + " 用户未配置")}

// ---------- 5. 第一行末：蓝区用户贡献表 + 塔台接口 ----------
// 读 PG fact_all_blue_contribute（= ES blue_zone_user_contributes 经 blue_contribute_sync 同步过来、塔台/平台直读的那份）
var n5n = 0
if (author != null && author != '') {
    var c5 = db.backup.selectInt("select count(*) from fact_all_blue_contribute where lower(" + idField + ")=lower(#{author})")
    n5n = c5 == null ? 0 : c5
}
var n5ok = n5n > 0
var n5 = {key:"blue_contrib", label:"蓝区用户贡献表", table:"fact_all_blue_contribute（ES blue_zone_user_contributes 的同步表）", ok:n5ok,
    detail: n5ok ? ("已同步 " + n5n + " 条到蓝区贡献表") : "尚未同步到蓝区贡献表"}
var n6 = {key:"tower_api", label:"蓝区提供给塔台接口", table:"POST /query/blueZone/contributes（dsapi.osinfra.cn）", ok:n5ok,
    detail: n5ok ? "塔台可查到该用户数据" : "塔台暂无该用户数据"}

// ---------- 6. 断点 + 同步前提 ----------
var breakpoint = null
if (!n1ok) { breakpoint = "repo_config" }
else if (!n2ok) { breakpoint = "raw_repo" }
else if (!n3ok) { breakpoint = "raw_contrib" }
else if (!n4ok) { breakpoint = "dws" }
else if (!n5ok) { breakpoint = "blue_contrib" }
// 同步前提：断点在⑤(聚合)，且 DWS 有数据(源齐) + 塔台已登记(M1)
var can_sync = (breakpoint == "blue_contrib") && n4ok && m1ok
var sync_action = can_sync ? {gitcode_id: (idField=='gitcode_id'?author:''), gitee_id: (idField=='gitee_id'?author:''), github_id: (idField=='github_id'?author:''), community: community, start_time: "2026-01-01"} : null
if (breakpoint == "blue_contrib") { n5.is_breakpoint = true; n5.can_sync = can_sync }
else if (breakpoint != null) {
    if (breakpoint == "repo_config") { n1.is_breakpoint = true }
    else if (breakpoint == "raw_repo") { n2.is_breakpoint = true }
    else if (breakpoint == "raw_contrib") { n3.is_breakpoint = true }
    else if (breakpoint == "dws") { n4.is_breakpoint = true }
}

// 结论文案
var conclusion = ""
if (n5ok) { conclusion = "✅ 该" + kindLabel + "已同步到蓝区贡献表，塔台可正常展示。" }
else if (can_sync) { conclusion = "断点在【蓝区用户贡献表】：源数据已采集、塔台也已登记「" + author + "」，只差最后一步同步未跑。可点【同步到蓝区贡献表】触发（约 10 分钟后刷新查看）。" }
else if (kind == 'commit' && breakpoint == "blue_contrib" && !m1ok) { conclusion = "断点在【蓝区塔台配置】：该 commit 作者邮箱「" + (commitEmail==null?'':commitEmail) + "」未匹配到已登记的塔台账号。塔台按登记的账号/提交邮箱抽取，请到塔台把该提交邮箱登记到对应账号下。" }
else if (breakpoint == "blue_contrib" && !m1ok) { conclusion = "断点在【蓝区塔台配置】：账号「" + (author==null?'':author) + "」未在塔台登记，塔台按登记账号抽取，未登记就不会同步。请先到塔台登记该账号。" }
else if (breakpoint == "raw_contrib" && n3warn) { conclusion = "该 PR 当前状态为「" + prState + "」，只有 merged（已合入）的 PR 才计入统计，请合入后再查。" }
else if (breakpoint == "raw_contrib" && existsOnPlat == false) { conclusion = "该链接不存在：" + plat + " 上查不到此" + kindLabel + "，请核对链接是否正确（或该" + kindLabel + "已被删除）。" }
else if (breakpoint == "raw_contrib" && existsOnPlat == true) { conclusion = "断点在【源数据表】：该" + kindLabel + " 在 " + plat + " 上确实存在，但还没采集到原始表（采集未运行到此 / 未到调度周期），请稍后再查。" }
else if (breakpoint == "raw_contrib") { conclusion = "断点在【源数据表】：未找到该" + kindLabel + "。可能① 采集未运行到此 / 未到周期；② 链接填写有误，请核对。" }
else if (breakpoint == "dws") { conclusion = "断点在【DWS聚合表】：源数据已采集，但还没汇总进 " + n4tbl + "（按用户维度的数仓聚合），通常是聚合任务未运行到此 / 未到调度周期，请稍后再查。" }
else if (breakpoint == "raw_repo" && n2failed) { conclusion = "断点在【原始仓库表】：仓库采集失败（status=" + st + "）——" + n2failDetail }
else if (breakpoint == "raw_repo" && repoExists == false) { conclusion = "该仓库不存在或你没有访问权限：" + plat + " 上查不到 " + parts[1] + "/" + parts[2] + "，请核对链接是否正确；若为私有仓，需在采集配置里提供有读取权限的凭据。" }
else if (breakpoint == "raw_repo") { conclusion = "断点在【原始仓库表】：" + owner + "/" + repo + " 已纳入采集，但采集器还没扫描到它，请等待采集运行或检查采集配置是否生效。" }
else if (breakpoint == "repo_config") { conclusion = "断点在【仓库配置】：" + owner + "/" + repo + " 未配置采集（仓库级与组织级都没有），请先在 white_box.yaml 或 white_box_org.yaml 中把该仓库或其所属组织加入采集。" }
else { conclusion = "诊断完成。" }

// 兼容旧前端字段
var legacyStatus = n5ok ? "collected_in_taitai" : (can_sync ? "collected_not_synced" : (breakpoint == "raw_contrib" ? "not_collected" : "not_configured"))

return {
    status: legacyStatus, ok: n5ok, async: true,
    input: {platform: plat, community: community, owner: owner, repo: repo, kind: kind, kindLabel: kindLabel, comment_type: cmtType, number: num, author: author, id_field: idField, commit_email: commitEmail},
    row1: [n1, n2, n3, n4, n5, n6],
    row2: [m1, m2],
    breakpoint: breakpoint,
    can_sync: can_sync,
    sync_action: sync_action,
    conclusion: conclusion,
    reason: conclusion,
    next: (m1ok || author == null) ? [] : [{action: "goto", text: "前往塔台账号配置", url: TATAI}]
}

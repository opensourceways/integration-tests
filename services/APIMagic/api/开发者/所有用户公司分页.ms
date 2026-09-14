{
  "properties": {},
  "id": "c82edcf3398548fb9915d22b3eb71769",
  "script": null,
  "groupId": "905e0bee16764ec9be1e96b78cae9466",
  "name": "所有用户公司分页",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/companies/all",
  "method": "GET",
  "parameters": [
    {
      "name": "platform",
      "value": "",
      "description": "可选：github/gitee/gitcode；不传则返回全部用户",
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": "pattern",
      "error": "platform 只能为 github/gitee/gitcode 或空",
      "expression": "^(gitee|github|gitcode)?$",
      "children": null
    },
    {
      "name": "users",
      "value": "",
      "description": "可选：逗号分隔的一个或多个用户登录名，按 platform 指定平台的登录名精确过滤；为空则不按用户过滤",
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": "pattern",
      "error": "users 只能为逗号分隔的登录名（字母/数字/下划线/点/连字符，最长2000字符）",
      "expression": "^[A-Za-z0-9,._-]{0,2000}$",
      "children": null
    },
    {
      "name": "page",
      "value": "1",
      "description": "页码，默认 1",
      "required": false,
      "dataType": "Integer",
      "type": null,
      "defaultValue": null,
      "validateType": "",
      "error": "",
      "expression": "",
      "children": null
    },
    {
      "name": "page_size",
      "value": "100",
      "description": "每页条数，默认 100，最大 1000",
      "required": false,
      "dataType": "Integer",
      "type": null,
      "defaultValue": null,
      "validateType": "",
      "error": "",
      "expression": "",
      "children": null
    }
  ],
  "options": [
    {
      "name": "permission",
      "value": "admin_token",
      "description": "跨社区管理员 key（admin_token，请求头带 api-key）",
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": null,
      "error": null,
      "expression": null,
      "children": null
    },
    {
      "name": "wrap_request_parameter",
      "value": "disable-cache",
      "description": "包装请求参数到一个变量中",
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": null,
      "error": null,
      "expression": null,
      "children": null
    }
  ],
  "requestBody": "",
  "headers": [
    {
      "name": "api-key",
      "value": "",
      "description": "管理员 key（admin_token 权限）",
      "required": true,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": null,
      "error": null,
      "expression": null,
      "children": null
    }
  ],
  "paths": [],
  "responseBody": "",
  "description": "#1251 全量用户公司信息分页查询，数据源 dws_community_user，一人一行返回各平台 logins + companies + emails；支持按 platform + users(逗号分隔的一个/多个登录名)精确过滤。companies 为 JSONB（#1345/om-dataarts#447 破坏性变更）：社区名 → 企业对象数组 [{company,start_date,end_date}]，无匹配为 null；不再是扁平公司名字符串数组",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
// #1251 全量用户公司信息·分页查询（数据源=全量身份表 dws_community_user，一人一行）
// 分页参数：GET query 是字符串，脚本内显式转 int 再拼进 SQL（int 安全，绕开参数默认值绑定坑）
var pageNum = (page == null || page == '') ? 1 : page::int
var pageSize = (page_size == null || page_size == '') ? 100 : page_size::int
if (pageNum <= 0) { pageNum = 1 }
if (pageSize <= 0 || pageSize > 1000) { pageSize = 100 }
var off = (pageNum - 1) * pageSize
// 解析 users：逗号分隔的一个/多个登录名 → 去空去空白得到 userList（#{} 参数化绑定，防注入）
var userList = []
if (users != null && users != '') {
    for (u in users.split(',')) {
        var uu = u.trim()
        if (uu != '') { userList.add(uu) }
    }
}
// 逐条拼 WHERE 子句：
//   platform 给了 → 只筛在该平台有账号的用户；
//   users 给了 → 在对应平台的登录名数组里精确匹配（platform 指定则只查该平台列，未指定则跨三平台登录名匹配）。
var conds = []
if (platform == 'github') { conds.add("github_logins IS NOT NULL AND array_length(github_logins, 1) > 0") }
else if (platform == 'gitee') { conds.add("gitee_logins IS NOT NULL AND array_length(gitee_logins, 1) > 0") }
else if (platform == 'gitcode') { conds.add("gitcode_logins IS NOT NULL AND array_length(gitcode_logins, 1) > 0") }
if (!userList.isEmpty()) {
    if (platform == 'github' || platform == 'gitee' || platform == 'gitcode') {
        conds.add(platform + "_logins && array[#{userList}]::text[]")
    } else {
        conds.add("(github_logins && array[#{userList}]::text[] OR gitee_logins && array[#{userList}]::text[] OR gitcode_logins && array[#{userList}]::text[])")
    }
}
var whereSql = ''
var ci = 0
for (cond in conds) {
    whereSql = whereSql + (ci == 0 ? ' WHERE ' : ' AND ') + cond
    ci = ci + 1
}
// 值绑定用 #{}(参数化)；platform 已在元数据层 pattern 白名单校验、列名为白名单标识符；表名为写死标识符 —— 无 SQL 注入面
// companies 列已由 om-dataarts #447 改为按社区聚合的 JSONB（{社区:[{company,start_date,end_date}]}），本身即 JSON，直接 SELECT 勿再 array_to_json；其余登录名/邮箱仍是 text[]，继续 array_to_json
var sqlstr = "SELECT array_to_json(gitcode_logins) AS gitcode_logins, array_to_json(github_logins) AS github_logins, array_to_json(gitee_logins) AS gitee_logins, companies, array_to_json(emails) AS emails FROM dws_community_user" + whereSql + " ORDER BY uuid ASC LIMIT #{pageSize} OFFSET #{off}"
var resp = db.select(sqlstr)
resp.each(it => {
    if (it.gitcode_logins != null) { it.gitcode_logins = it.gitcode_logins.getValue()::json }
    if (it.github_logins != null) { it.github_logins = it.github_logins.getValue()::json }
    if (it.gitee_logins != null) { it.gitee_logins = it.gitee_logins.getValue()::json }
    if (it.companies != null) { it.companies = it.companies.getValue()::json }
    if (it.emails != null) { it.emails = it.emails.getValue()::json }
})
return resp

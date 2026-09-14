{
  "properties": {},
  "id": "4b0c954f9973477db84041165f9dbd4d",
  "script": null,
  "groupId": "1a7a4bd8439c447daf274fc1b6f280f1",
  "name": "查看仓库采集情况",
  "createTime": null,
  "updateTime": 1782114703856,
  "lock": null,
  "createBy": "admin",
  "updateBy": "admin",
  "path": "/query/repo/stats",
  "method": "GET",
  "parameters": [
    {
      "name": "status",
      "value": "",
      "description": "采集状态",
      "required": false,
      "dataType": "String",
      "defaultValue": "",
      "validateType": "pattern",
      "error": "status 非法",
      "expression": "^[^%'\";\\]*$",
      "children": null
    },
    {
      "name": "owner",
      "value": "",
      "description": "所有者模糊",
      "required": false,
      "dataType": "String",
      "defaultValue": "",
      "validateType": "pattern",
      "error": "owner 非法",
      "expression": "^[^%'\";\\]*$",
      "children": null
    },
    {
      "name": "repo",
      "value": "",
      "description": "仓库模糊",
      "required": false,
      "dataType": "String",
      "defaultValue": "",
      "validateType": "pattern",
      "error": "repo 非法",
      "expression": "^[^%'\";\\]*$",
      "children": null
    },
    {
      "name": "community",
      "value": "",
      "description": "社区模糊",
      "required": false,
      "dataType": "String",
      "defaultValue": "",
      "validateType": "pattern",
      "error": "community 非法",
      "expression": "^[^%'\";\\]*$",
      "children": null
    },
    {
      "name": "platforms",
      "value": "",
      "description": "平台多选",
      "required": false,
      "dataType": "String",
      "defaultValue": "",
      "validateType": "pattern",
      "error": "platforms 非法",
      "expression": "^[a-zA-Z,]*$",
      "children": null
    },
    {
      "name": "asc",
      "value": "",
      "description": "升序列",
      "required": false,
      "dataType": "String",
      "defaultValue": "",
      "validateType": "pattern",
      "error": "asc 非法",
      "expression": "^[a-zA-Z_]*$",
      "children": null
    },
    {
      "name": "desc",
      "value": "",
      "description": "降序列",
      "required": false,
      "dataType": "String",
      "defaultValue": "",
      "validateType": "pattern",
      "error": "desc 非法",
      "expression": "^[a-zA-Z_]*$",
      "children": null
    },
    {
      "name": "page",
      "value": "1",
      "description": "page",
      "required": false,
      "dataType": "Integer",
      "defaultValue": "1",
      "validateType": null,
      "error": null,
      "expression": null,
      "children": null
    },
    {
      "name": "size",
      "value": "10",
      "description": "size",
      "required": false,
      "dataType": "Integer",
      "defaultValue": "10",
      "validateType": null,
      "error": null,
      "expression": null,
      "children": null
    }
  ],
  "options": [
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
    },
    {
      "name": "permission",
      "value": "datastatwhitebox_view",
      "description": "允许拥有该权限的访问",
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
  "headers": [],
  "paths": [],
  "responseBody": null,
  "description": "采集状态列表 server-side 分页(owner/repo/community/platform/status 后端筛选+排序+LIMIT/OFFSET, 返回 {list,total})",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
var page_t = (page == null || page == '') ? 1 : page
var size_t = (size == null || size == '') ? 10 : size
var offset = (page_t - 1) * size_t
var ownerlike = '%' + (owner == null ? '' : owner) + '%'
var repolike = '%' + (repo == null ? '' : repo) + '%'
var communitylike = '%' + (community == null ? '' : community) + '%'
var conds = "1=1"
if (owner != null && owner != '') { conds = conds + " and owner ilike #{ownerlike}" }
if (repo != null && repo != '') { conds = conds + " and repo ilike #{repolike}" }
if (community != null && community != '') { conds = conds + " and community ilike #{communitylike}" }
if (status != null && status != '') { conds = conds + " and status = #{status}" }
if (platforms != null && platforms != '') {
    var plist = ''
    for (p in platforms.split(',')) { var pp = p.trim(); if (pp != '' && pp.matches('[a-zA-Z]+')) { plist = (plist == '' ? "'" + pp + "'" : plist + ",'" + pp + "'") } }
    if (plist != '') { conds = conds + " and platform in (" + plist + ")" }
}
var dir = 'desc'
if (asc != null && asc != '') { dir = 'asc' }
else if (desc != null && desc != '') { dir = 'desc' }
var order = " order by updated_at " + dir + " nulls last "
var sql = "select * from fact_branch_collect_status where " + conds + order + " limit #{size_t} offset #{offset}"
var totalsql = "select count(*) as total from fact_branch_collect_status where " + conds
var data = db.backup.select(sql)
var total = db.backup.select(totalsql)
HashMap res = new HashMap();
res.put("list", data)
res.put("total", total.get(0).get("total"))
return res

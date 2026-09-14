{
  "properties": {},
  "id": "2d87f677ca654f57bacb2c80334bb956",
  "script": null,
  "groupId": "1a7a4bd8439c447daf274fc1b6f280f1",
  "name": "查看仓库是否在采集范围",
  "createTime": 1778468793508,
  "updateTime": null,
  "lock": null,
  "createBy": "admin",
  "updateBy": null,
  "path": "/query/repo",
  "method": "GET",
  "parameters": [
    {
      "name": "collect_enabled",
      "value": "",
      "description": "启用状态 true/false/已启用/已禁用",
      "required": false,
      "dataType": "String",
      "defaultValue": "",
      "validateType": "pattern",
      "error": "collect_enabled 非法",
      "expression": "^[^%'\";\\\\]*$",
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
      "expression": "^[^%'\";\\\\]*$",
      "children": null
    },
    {
      "name": "repo",
      "value": "",
      "description": "仓库名模糊",
      "required": false,
      "dataType": "String",
      "defaultValue": "",
      "validateType": "pattern",
      "error": "repo 非法",
      "expression": "^[^%'\";\\\\]*$",
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
      "expression": "^[^%'\";\\\\]*$",
      "children": null
    },
    {
      "name": "platforms",
      "value": "",
      "description": "平台多选逗号分隔",
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
  "responseBody": "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8_opendtfuzz/fuzz\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8\",\n        \"repo\": \"opendtfuzz/fuzz\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }, {\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8_openlibing-platform-release\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8\",\n        \"repo\": \"openlibing-platform-release\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }, {\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8/opendtfuzz_fuzz_build_entry\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8/opendtfuzz\",\n        \"repo\": \"fuzz_build_entry\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }, {\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8/opendtfuzz_fuzz\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8/opendtfuzz\",\n        \"repo\": \"fuzz\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }, {\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8/opendtfuzz_openlibing-fuzz\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8/opendtfuzz\",\n        \"repo\": \"openlibing-fuzz\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }, {\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8_openlibing-cicd\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8\",\n        \"repo\": \"openlibing-cicd\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }, {\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8_openlibing-common\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8\",\n        \"repo\": \"openlibing-common\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }, {\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8/opendtfuzz_tbox\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8/opendtfuzz\",\n        \"repo\": \"tbox\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }, {\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8_openlibing-eureka\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8\",\n        \"repo\": \"openlibing-eureka\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }, {\n        \"repo_uuid\": \"codearts_709968f4a69145deba5559c5faf4eca8_opendtfuzz/tbox\",\n        \"owner\": \"709968f4a69145deba5559c5faf4eca8\",\n        \"repo\": \"opendtfuzz/tbox\",\n        \"community\": \"whitebox\",\n        \"branch_mode\": \"all\",\n        \"collect_branches\": \"\",\n        \"collect_enabled\": true,\n        \"code_base_path\": \"/opt/data/whitecommitlog/commitlog/\",\n        \"platform\": \"codearts\"\n    }],\n    \"timestamp\": 1778211750472,\n    \"executeTime\": 6\n}",
  "description": "采集仓库列表 server-side 分页（owner/repo/community/platform/启用状态 后端筛选+排序+LIMIT/OFFSET，返回 {list,total}）",
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
var conds = "status = 'active'"
if (owner != null && owner != '') { conds = conds + " and owner ilike #{ownerlike}" }
if (repo != null && repo != '') { conds = conds + " and repo ilike #{repolike}" }
if (community != null && community != '') { conds = conds + " and community ilike #{communitylike}" }
if (collect_enabled != null && collect_enabled != '') {
    var eb = (collect_enabled == 'true' || collect_enabled == '已启用') ? 'true' : 'false'
    conds = conds + " and collect_enabled = " + eb
}
if (platforms != null && platforms != '') {
    var plist = ''
    for (p in platforms.split(',')) { var pp = p.trim(); if (pp != '' && pp.matches('[a-zA-Z]+')) { plist = (plist == '' ? "'" + pp + "'" : plist + ",'" + pp + "'") } }
    if (plist != '') { conds = conds + " and platform in (" + plist + ")" }
}
var sortexpr = ''
var dir = ''
if (asc != null && asc != '') { dir = 'asc'; sortexpr = (asc == 'repo') ? 'repo' : 'owner' }
else if (desc != null && desc != '') { dir = 'desc'; sortexpr = (desc == 'repo') ? 'repo' : 'owner' }
var order = (sortexpr == '') ? " order by owner asc, repo asc " : (" order by " + sortexpr + " " + dir + " nulls last ")
var cols = "repo_uuid,owner,repo,community,branch_mode, COALESCE(array_to_string(collect_branches, ','), '') AS collect_branches,collect_enabled,code_base_path,platform"
var sql = "select " + cols + " from dict_repo_collect_config where " + conds + order + " limit #{size_t} offset #{offset}"
var totalsql = "select count(*) as total from dict_repo_collect_config where " + conds
var data = db.backup.select(sql)
var total = db.backup.select(totalsql)
HashMap res = new HashMap();
res.put("list", data)
res.put("total", total.get(0).get("total"))
return res

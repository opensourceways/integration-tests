{
  "properties": {},
  "id": "e60129b11f2b4b989b6238a7b738ef5a",
  "script": null,
  "groupId": "1a7a4bd8439c447daf274fc1b6f280f1",
  "name": "查看平台列表",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": "admin",
  "updateBy": null,
  "path": "/query/platforms",
  "method": "GET",
  "parameters": [],
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
  "description": null,
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
var sql = """
select distinct platform from dict_repo_collect_config where status='active' and platform is not null and platform <> ''
union
select distinct platform from dict_org_collect_config where status='active' and platform is not null and platform <> ''
order by platform """

return db.backup.select(sql)

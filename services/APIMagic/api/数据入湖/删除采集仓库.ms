{
  "properties": {},
  "id": "919a4892bbbf4b379706bef841629a60",
  "script": null,
  "groupId": "1a7a4bd8439c447daf274fc1b6f280f1",
  "name": "删除采集仓库",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": "admin",
  "updateBy": null,
  "path": "/repo/{id}",
  "method": "DELETE",
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
      "value": "datastatadmin_View",
      "description": "允许拥有datastatadmin_View权限的用户访问",
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
  "paths": [
    {
      "name": "id",
      "value": "",
      "description": null,
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
  "responseBody": null,
  "description": null,
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
var id = id

var sql = """ delete from dict_repo_collect_config where repo_uuid = #{id} """

db.backup.update(sql)

return ''

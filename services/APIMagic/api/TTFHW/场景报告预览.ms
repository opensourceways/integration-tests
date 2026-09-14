{
  "properties": {},
  "id": "ttfhw_scenario_preview",
  "script": null,
  "groupId": "ttfhwgroup0000000000000000000001",
  "name": "场景报告预览",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/scenario/preview",
  "method": "GET",
  "parameters": [
    {
      "name": "id",
      "value": "",
      "description": "fact_ttfhw_scenario_request.id",
      "required": true,
      "dataType": "Integer",
      "type": null,
      "defaultValue": null,
      "validateType": null,
      "error": "id 不能为空",
      "expression": null,
      "children": null
    }
  ],
  "options": [
    {
      "name": "wrap_request_parameter",
      "value": "disable-cache",
      "description": "禁用 Redis 请求缓存（预览随 PR 更新，不能缓存旧值）",
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
      "value": "datastatTTFHW_View",
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
  "description": "按场景 id 返回 PR 预览版报告内容（preview_html，与 oss-insight preview 同口径）",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
if (id == null) {
  return {code: -1, message: 'id 不能为空'};
}
var rows = db.select("""SELECT id, title, scenario_type, pr_url, preview_html,
       to_char(updated_at, 'YYYY-MM-DD HH24:MI') AS updated_at
FROM fact_ttfhw_scenario_request
WHERE id = #{id}""");
if (rows == null || rows.size() == 0) {
  return {code: -1, message: '记录不存在'};
}
var r = rows[0];
if (r.preview_html == null) {
  return {code: -1, message: '暂无预览内容（PR 尚未生成或未同步）'};
}
return r;

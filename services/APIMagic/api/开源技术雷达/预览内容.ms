{
  "properties": {},
  "id": "oss_insight_preview_content",
  "script": null,
  "groupId": "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name": "预览内容",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/oss-insight/preview",
  "method": "GET",
  "parameters": [
    {
      "name": "id",
      "value": "",
      "description": "fact_oss_insight_request.id",
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
    }
  ],
  "requestBody": "",
  "headers": [],
  "paths": [],
  "responseBody": null,
  "description": "按需求 id 返回 PR 预览版 HTML（区别于正式报告 fact_oss_insight_report）",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
if (id == null) {
  return {code: -1, message: 'id 不能为空'};
}
var rows = db.select("""SELECT id, title, project_name, pr_url, preview_html,
       to_char(updated_at, 'YYYY-MM-DD HH24:MI') AS updated_at
FROM fact_oss_insight_request
WHERE id = #{id}""");
if (rows == null || rows.size() == 0) {
  return {code: -1, message: '记录不存在'};
}
var r = rows[0];
if (r.preview_html == null) {
  return {code: -1, message: '暂无预览内容（PR 尚未生成或未同步）'};
}
return r;
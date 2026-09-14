{
  "properties" : { },
  "id" : "oss_insight_update",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "更新状态",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/oss-insight/update",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatadmin_View",
    "description" : "允许拥有该权限的访问",
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
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var id_v = body.id;
var st = body.status;
var report_url = body.report_url;

if (id_v == null) {
  return {code: -1, message: 'id不能为空'};
}
if (st == null || ['待生成', '审阅中', '已发布'].indexOf(st) === -1) {
  return {code: -1, message: '状态值不合法，须为 待生成/审阅中/已发布'};
}

db.update('UPDATE fact_oss_insight_request SET status=#{st}, report_url=#{report_url}, updated_at=NOW() WHERE id=#{id_v}');
return {code: 1, message: '更新成功'};

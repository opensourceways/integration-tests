{
  "properties" : { },
  "id" : "ttfhw_confirm",
  "script" : null,
  "groupId" : "ttfhwgroup0000000000000000000001",
  "name" : "确认问题",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/confirm",
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
  "requestBody" : "{\n    \"id\": 1,\n    \"confirm_result\": \"是\",\n    \"confirmer\": \"zhongjun2\"\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"确认成功\"\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 确认某条 TTFHW 问题是否为问题，写回 confirm_result / confirmer / confirmed_at。
// confirm_result 白名单校验（仅 是/否），所有取值 #{} 绑定防注入。
var id_v = body.id;
var result = body.confirm_result;
var confirmer = body.confirmer;

if (id_v == null) {
    return {code: -1, message: 'id不能为空'};
}
if (result == null || ['是', '否'].indexOf(result) === -1) {
    return {code: -1, message: 'confirm_result 不合法，须为 是/否'};
}
if (confirmer == null || confirmer == '') {
    return {code: -1, message: 'confirmer 不能为空'};
}

var affected = db.update("""
UPDATE fact_ttfhw_issue
SET confirm_result = #{result},
    confirmer = #{confirmer},
    confirmed_at = (NOW() AT TIME ZONE 'Asia/Shanghai'),
    updated_at = NOW()
WHERE id = #{id_v}
""");

if (affected == 0) {
    return {code: -1, message: '未找到对应记录'};
}
return {code: 1, message: '确认成功'};

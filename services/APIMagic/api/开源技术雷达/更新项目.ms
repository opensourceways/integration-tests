{
  "properties" : { },
  "id" : "trp_upd",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "更新项目",
  "createTime" : null,
  "updateTime" : 1777424837540,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/tech-radar/update",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatadmin_View",
    "description" : "允许拥有datastatadmin_View权限的用户访问",
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
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1777424393079,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var id_v=body.id; var st=body.status; var nm=body.name; var u=body.url; var pypi=body.pypi_url; var tp=body.type;
if(id_v==null){return {code:-1,message:'id不能为空'};}
var statusVal=(st!=null&&['未上线','已上线','拒绝'].contains(st))?st:'未上线';
db.update('UPDATE fact_insight_tech_radar_project SET name=#{nm},url=#{u},pypi_url=#{pypi},type=#{tp},status=#{statusVal},updated_at=NOW() WHERE id=#{id_v}');
return {code:1,message:'更新成功'};
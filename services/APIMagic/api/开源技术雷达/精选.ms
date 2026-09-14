{
  "properties" : { },
  "id" : "oss_insight_feature",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "精选",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/oss-insight/feature",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "wrap_request_parameter",
    "value" : "disable-cache",
    "description" : "禁用接口缓存，避免重复提交命中缓存回显旧结果不执行",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "permission",
    "value" : "datastatInsightAdmin_View",
    "description" : "允许拥有该权限的访问（精选为洞察管理动作）",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"is_featured\": true,\n        \"featured_by\": \"zhongjun\"\n    }\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 精选 toggle（仅洞察管理员，permission=datastatInsightAdmin_View 拦截）：取当前洞察需求的 is_featured 取反
var rid=body.request_id; var username=body.username;
if(rid==null){return {code:-1,message:'request_id不能为空'};}
if(username==null||username.trim()==''){return {code:-1,message:'用户未登录'};}
var cur=db.selectOne("SELECT COALESCE(is_featured,false) AS is_featured FROM fact_oss_insight_request WHERE id=#{rid}");
if(cur==null){return {code:-1,message:'洞察需求不存在'};}
var newVal=!cur.is_featured;
if(newVal){
    db.update("UPDATE fact_oss_insight_request SET is_featured=true, featured_by=#{username}, featured_at=NOW() WHERE id=#{rid}");
}else{
    db.update("UPDATE fact_oss_insight_request SET is_featured=false, featured_by=null, featured_at=null WHERE id=#{rid}");
}
return {code:1,message:'success',data:{is_featured:newVal, featured_by:newVal?username:null}};

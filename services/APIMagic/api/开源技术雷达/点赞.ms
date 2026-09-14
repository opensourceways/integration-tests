{
  "properties" : { },
  "id" : "oss_insight_like",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "点赞",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/oss-insight/like",
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
  }, {
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"liked\": true,\n        \"like_count\": 5\n    }\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 点赞 toggle：登录用户对某条开源洞察需求点赞/取消点赞（幂等，靠 UNIQUE(request_id,username)）
var rid=body.request_id; var username=body.username;
if(rid==null){return {code:-1,message:'request_id不能为空'};}
if(username==null||username.trim()==''){return {code:-1,message:'用户未登录'};}
// 已点赞则取消，未点赞则新增（ON CONFLICT 兜底幂等）
var existed=db.selectOne("SELECT id FROM fact_oss_insight_like WHERE request_id=#{rid} AND username=#{username} LIMIT 1");
var liked=false;
if(existed!=null){
    db.update("DELETE FROM fact_oss_insight_like WHERE request_id=#{rid} AND username=#{username}");
    liked=false;
}else{
    db.update("INSERT INTO fact_oss_insight_like(request_id,username) VALUES(#{rid},#{username}) ON CONFLICT (request_id,username) DO NOTHING");
    liked=true;
}
var cnt=db.selectOne("SELECT COUNT(*) AS c FROM fact_oss_insight_like WHERE request_id=#{rid}");
return {code:1,message:'success',data:{liked:liked,like_count:cnt.c}};

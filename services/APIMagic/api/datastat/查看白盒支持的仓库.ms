{
  "properties" : { },
  "id" : "18189332021245279e3f26073a83790d",
  "script" : null,
  "groupId" : "521ef640123a4ae79386e6a38b8df4ad",
  "name" : "查看白盒支持的仓库",
  "createTime" : null,
  "updateTime" : 1774577981216,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/whitebox/repo",
  "method" : "GET",
  "parameters" : [ {
    "name" : "token",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "token校验失败",
    "expression" : "^(dsdfsdfsdfd)$",
    "children" : null
  }, {
    "name" : "repo",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "repo 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]+$",
    "children" : null
  }, {
    "name" : "platform",
    "value" : "",
    "description" : "只支持github|gitee|gitcode",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "只支持github|gitee|gitcode",
    "expression" : "^(github|gitee|gitcode)$",
    "children" : null
  } ],
  "options" : [ {
    "name" : "wrap_request_parameter",
    "value" : "disable-cache",
    "description" : "包装请求参数到一个变量中",
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
    "value" : "datastat",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": \"未在采集范围\",\n    \"timestamp\": 1764812389866,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var repo = repo
var community = community
var platform = platform
var source_type = source_type
var sql = """  select platform,name,owner,repo,branch,metrics,clone_url,updated_at,source_type from fact_whitebox_repo_config 
        where 1=1 
        <if test="community != null and community != ''">
            AND community = #{community} 
        </if>
        <if test="platform != null and platform != ''">
            AND platform = #{platform} 
        </if>
        <if test="source_type != null and source_type != ''">
            AND source_type = #{source_type} 
        </if>
        <if test="repo != null and repo != ''">
            AND (repo = #{repo} or name = #{repo})
        </if>
"""
var res = db.select(sql)
if (res!=null && res.size()>0){
   for(item in res){
           item.branch=item.branch.getArray()
           item.metrics=item.metrics.getArray()
   }
   return res.group((item)=>item.source_type)
}
return "未在采集范围";

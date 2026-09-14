{
  "properties" : { },
  "id" : "copy1778319499717d83950",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "查看组织是否在采集范围",
  "createTime" : 1778468821394,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : null,
  "path" : "/query/org",
  "method" : "GET",
  "parameters" : [ {
    "name" : "platform",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : null,
    "error" : null,
    "expression" : null,
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
    "value" : "datastatwhitebox_view",
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


var platform_tem = platform
var org_tem = org


var sql = """ 

select org_uuid,org_name,community,branch_mode, COALESCE(array_to_string(collect_branches, ','), '') AS collect_branches,collect_enabled,code_base_path,platform,
'' as account,'' as token
 from dict_org_collect_config

where 
    status='active'
                    <if test="platform_tem != null and platform_tem!='' ">
                         and   platform = #{platform_tem}
                    </if> 
                 

                    <if test="org_tem != null and org_tem!='' ">
                          and  lower(org_name) =lower(#{org_tem})  
                    </if>  

 limit 100 """

return db.backup.select(sql)
{
  "properties" : { },
  "id" : "copy1778479793239d80263",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "org配置修改",
  "createTime" : null,
  "updateTime" : 1778656021612,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/org",
  "method" : "POST",
  "parameters" : [ ],
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
  "requestBody" : null,
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": \"\",\n    \"timestamp\": 1778480749205,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================


var community = body.community
var branch_mode = body.branch_mode
var collect_branches = body.collect_branches
var account = body.account
var token = body.token
var collect_enabled = body.collect_enabled
var org_name = body.org_name
var platform = body.platform
var code_base_path = body.code_base_path

var org_uuid = body.platform+"_"+ body.org_name
var index_name = "white_box_commits_20220125"



// 2. 构建动态 SQL
var sql = """
    INSERT INTO dict_org_collect_config(
        org_uuid, community, branch_mode, collect_branches, account, token, collect_enabled, org_name,platform,index_name,code_base_path
    )
    VALUES(
        #{org_uuid}, 
        #{community}, 
        #{branch_mode},
        (CASE WHEN #{collect_branches} IS NOT NULL AND #{collect_branches} != '' THEN #{collect_branches} ELSE '' END) || '{}'::text[], 
        #{account}, 
        #{token},
        true,
        #{org_name}, 
        #{platform},
        #{index_name},
        #{code_base_path}
    )
    ON CONFLICT (org_uuid) 
    DO UPDATE SET 
        community = COALESCE(NULLIF(#{community}, ''), dict_org_collect_config.community),
        branch_mode = COALESCE(NULLIF(#{branch_mode}, ''), dict_org_collect_config.branch_mode),
        collect_branches = (CASE WHEN #{collect_branches} IS NOT NULL AND #{collect_branches} != '' THEN #{collect_branches} ELSE '' END) || '{}'::text[],

        account = COALESCE(NULLIF(#{account}, ''), dict_org_collect_config.account),
        token = COALESCE(NULLIF(#{token}, ''), dict_org_collect_config.token),
        collect_enabled =  dict_org_collect_config.collect_enabled,
        code_base_path = COALESCE(NULLIF(#{code_base_path}, ''), dict_org_collect_config.code_base_path),
        platform = COALESCE(NULLIF(#{platform}, ''), dict_org_collect_config.platform),
        index_name = dict_org_collect_config.index_name,
        org_name = COALESCE(NULLIF(lower(#{org_name}), ''), dict_org_collect_config.org_name),
        updated_at = NOW()
"""
db.backup.update(sql);


return ''
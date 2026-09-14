{
  "properties" : { },
  "id" : "b63bc73719444cd6b57b6c4516642cc4",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "仓库配置修改",
  "createTime" : null,
  "updateTime" : 1778469905813,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repo/update",
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
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================



var repo_uuid = body.repo_uuid
var community = body.community
var branch_mode = body.branch_mode
var collect_branches = body.collect_branches
var account = body.account
var token = body.token
var collect_enabled = body.collect_enabled
var repo = body.repo
var owner = body.owner
var platform = body.platform
var code_base_path = body.code_base_path
var index_name = "white_box_commits_20220125"




// 2. 构建动态 SQL
var sql = """
    INSERT INTO dict_repo_collect_config(
        repo_uuid, community, branch_mode, collect_branches, account, token, collect_enabled, repo, owner,platform,index_name,code_base_path
    )
    VALUES(
        #{repo_uuid},
        #{community},
        #{branch_mode},
        COALESCE(NULLIF(string_to_array(#{collect_branches}::text, ','::text), '{}'::text[]), '{}'::text[]),
        #{account},
        #{token},
        true,
        #{repo},
        #{owner},
        #{platform},
        #{index_name},
        #{code_base_path}
    )
    ON CONFLICT (repo_uuid)
    DO UPDATE SET
        community = COALESCE(NULLIF(#{community}, ''), dict_repo_collect_config.community),
        branch_mode = COALESCE(NULLIF(#{branch_mode}, ''), dict_repo_collect_config.branch_mode),

        -- [数组更新] 同样的拼接技巧
        collect_branches = COALESCE(NULLIF(string_to_array(#{collect_branches}::text, ','::text), '{}'::text[]), '{}'::text[]),

        account = COALESCE(NULLIF(#{account}, ''), dict_repo_collect_config.account),
        token = COALESCE(NULLIF(#{token}, ''), dict_repo_collect_config.token),

        -- [布尔更新]
        -- 逻辑：如果传入的是空串，NULLIF 变为 NULL，COALESCE 取后面的旧值（即不更新）
        -- 如果传入的是 'true'/'false'，NULLIF 保持原值，COALESCE 取新值
        code_base_path = COALESCE(NULLIF(#{code_base_path}, ''), dict_repo_collect_config.code_base_path),
        platform = COALESCE(NULLIF(#{platform}, ''), dict_repo_collect_config.platform),
        index_name = COALESCE(NULLIF(#{index_name}, ''), dict_repo_collect_config.index_name),
        collect_enabled = dict_repo_collect_config.collect_enabled,
        repo = COALESCE(NULLIF(lower(#{repo}), ''), dict_repo_collect_config.repo),
        owner = COALESCE(NULLIF(lower(#{owner}), ''), dict_repo_collect_config.owner),
        updated_at = NOW()
"""
db.backup.update(sql);


return ''
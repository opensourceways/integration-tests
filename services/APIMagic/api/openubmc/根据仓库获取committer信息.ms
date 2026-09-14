{
  "properties" : { },
  "id" : "50a377fcf68441ef8b43f29d562faa6b",
  "script" : null,
  "groupId" : "5eed1b66d5ab454f80312cee5f30f81e",
  "name" : "根据仓库获取committer信息",
  "createTime" : null,
  "updateTime" : 1778487532869,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repo/committer",
  "method" : "GET",
  "parameters" : [ {
    "name" : "sigName",
    "value" : "infrastructure",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "sigName 格式非法",
    "expression" : "",
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"openUBMC/release_management\": [{\n            \"repo\": \"openUBMC/release_management\",\n            \"gitcode_id\": \"\",\n            \"name\": \"\",\n            \"sig_name\": \"sig-release-management\"\n        }]\n    },\n    \"timestamp\": 1766459506250,\n    \"executeTime\": 4999\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sigName = sigName;

var sql = """
SELECT DISTINCT
    repo,
    -- 核心逻辑：如果该项目存在Committer，则只保留Committer的信息，其他角色置空
    CASE 
        WHEN max_is_committer = 1 AND role = 'committer' THEN gitcode_id 
        WHEN max_is_committer = 0 THEN '' -- 该项目完全没有committer，返回空字符串
        ELSE '' -- 该项目有committer，但当前行不是committer，强制置空
    END AS gitcode_id,
    CASE 
        WHEN max_is_committer = 1 AND role = 'committer' THEN name 
        WHEN max_is_committer = 0 THEN '' 
        ELSE '' 
    END AS name,
    sig_name
FROM (
    SELECT 
        concat(namespace, '/', repo_path) as repo,
        user_login as gitcode_id,
        user_name as name,
        sig_name,
        role,
        -- 窗口函数：按 repo 分组，计算该组内是否有 'committer'
        MAX(CASE WHEN role = 'committer' THEN 1 ELSE 0 END) OVER (PARTITION BY concat(namespace, '/', repo_path)) as max_is_committer
    FROM fact_openubmc_sig_user  
    WHERE sig_name = #{sigName} 
      AND is_removed IS NULL
) t
WHERE 
    -- 过滤条件：
    -- 1. 如果该项目有committer (max_is_committer=1)，只取 committer 的行
    -- 2. 如果该项目没committer (max_is_committer=0)，取一行作为占位（通常取第一条）
    (max_is_committer = 1 AND role = 'committer') 
    OR 
    (max_is_committer = 0)
"""


return db.select(sql).group(item=>item.repo);
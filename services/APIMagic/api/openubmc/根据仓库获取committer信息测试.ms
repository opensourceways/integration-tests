{
  "properties" : { },
  "id" : "copy1752138557525d85855",
  "script" : null,
  "groupId" : "5eed1b66d5ab454f80312cee5f30f81e",
  "name" : "根据仓库获取committer信息测试",
  "createTime" : null,
  "updateTime" : 1775550314986,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "dd/test/repo/committer",
  "method" : "GET",
  "parameters" : [ {
    "name" : "sigName",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "sigName 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"openUBMC/bingo\": [{\n            \"repo\": \"openUBMC/bingo\",\n            \"gitcode_id\": \"Larry_Li_006\",\n            \"name\": \"李江\",\n            \"sig_name\": \"sig-CICD\"\n        }],\n        \"openUBMC/conan_index\": [{\n            \"repo\": \"openUBMC/conan_index\",\n            \"gitcode_id\": \"Larry_Li_006\",\n            \"name\": \"李江\",\n            \"sig_name\": \"sig-CICD\"\n        }],\n        \"openUBMC/manifest\": [{\n            \"repo\": \"openUBMC/manifest\",\n            \"gitcode_id\": \"Larry_Li_006\",\n            \"name\": \"李江\",\n            \"sig_name\": \"sig-CICD\"\n        }],\n        \"openUBMC/rootfs_user\": [{\n            \"repo\": \"openUBMC/rootfs_user\",\n            \"gitcode_id\": \"Larry_Li_006\",\n            \"name\": \"李江\",\n            \"sig_name\": \"sig-CICD\"\n        }]\n    },\n    \"timestamp\": 1752138612770,\n    \"executeTime\": 3\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sigName = sigName;
var sql ="""
select distinct concat(namespace,'/',repo_path) as repo, user_login as gitcode_id,user_name as name,sig_name from  fact_openubmc_sig_user_temp 
    where sig_name=#{sigName} and role='committer' and is_removed is null
    """
return  db.select(sql).group(item=>item.repo);

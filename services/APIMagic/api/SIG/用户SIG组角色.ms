{
  "properties" : { },
  "id" : "74c2138d08fa484f8e2e314f388216fc",
  "script" : null,
  "groupId" : "1cc0849322d74468ab73c9ad0f14fc02",
  "name" : "用户SIG组角色",
  "createTime" : null,
  "updateTime" : 1775010946311,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "user/ownertype",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "cannopen",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "user",
    "value" : "zhongjun2",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "user 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"community 参数非法\",\n    \"data\": null,\n    \"timestamp\": 1774595095865,\n    \"executeTime\": 1\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT 
    sig_name,
    array_agg(distinct role) as role
FROM 
    fact_${community}_sig_user fcsu
WHERE 
    user_login = #{user} AND is_removed is null
GROUP BY 
    sig_name;
"""
var resp = db.select(sqlstr)
resp.each(it=>it['role'] = it['role'].getArray())
return resp

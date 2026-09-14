{
  "properties" : { },
  "id" : "dbda46a9b56e485aa48939003b7773f8",
  "script" : null,
  "groupId" : "a722ad28731b4662827d7142c054a3d7",
  "name" : "userinfo",
  "createTime" : null,
  "updateTime" : 1769493977061,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "user/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^(openeuler|opengauss|mindspore|openubmc|openfuyao)$",
    "children" : null
  }, {
    "name" : "user",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "user 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]+$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"user_login\": \"kaede101\",\n        \"html_url\": \"https://gitee.com/kaede10\"\n    },\n    \"timestamp\": 1766995039430,\n    \"executeTime\": 19\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sqlstr = """
with user_info AS(
	SELECT 
	    doc.user_login,
	    fcu.html_url
	FROM 
	    dws_${community}_contribute doc
	LEFT JOIN fact_${community}_user fcu
	ON doc.user_login = fcu.user_login
	WHERE 
	    doc.user_login = #{user}
	GROUP BY 
	    doc.user_login, fcu.html_url
)
SELECT 
    u.user_login,
    COALESCE(u.html_url, concat('https://gitee.com/', fcum.gitee_user_login)) as html_url
FROM 
	user_info u
LEFT JOIN fact_${community}_user_mapping fcum
ON u.user_login = fcum.gitcode_user_login;"""
var resp = db.select(sqlstr)[0]
return resp == null ? 'https://gitcode.com/' + user : resp

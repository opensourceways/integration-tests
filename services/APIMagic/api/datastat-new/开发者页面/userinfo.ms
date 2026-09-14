{
  "properties" : { },
  "id" : "68a55ad976dd40f4b901daac21fcd278",
  "script" : null,
  "groupId" : "3a27e930d2934b3e99edef7ee1dee30a",
  "name" : "userinfo",
  "createTime" : null,
  "updateTime" : 1776761073821,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "user/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "user",
    "value" : "kaede10",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"user_login\": \"kaede10\",\n        \"html_url\": \"https://gitcode.com/kaede10\"\n    },\n    \"timestamp\": 1776757058074,\n    \"executeTime\": 10\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var table_name = `fact_${community}_user_mapping`
var table_check_sql = """
  SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = #{table_name}
  )
"""

var sqlstr = """
  SELECT 
      doc.user_login,
      fcu.html_url
  FROM 
      dwm_${community}_contribute_user doc
  LEFT JOIN fact_${community}_user fcu
  ON doc.user_login = fcu.user_login
  <where> 
      <if test="not_blank(user)">
           doc.user_login = #{user}
      </if>
  </where>
  GROUP BY 
      doc.user_login, fcu.html_url
"""
if (db.select(table_check_sql)[0].get('exists')) {
    sqlstr = """
      with user_info AS(
        SELECT 
            doc.user_login,
            fcu.html_url
        FROM 
            dwm_${community}_contribute_user doc
        LEFT JOIN fact_${community}_user fcu
        ON doc.user_login = fcu.user_login
        WHERE 
            <if test="not_blank(user)">
               doc.user_login = #{user} AND
            </if>
            doc.user_login IS NOT NULL
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
}

var resp = db.select(sqlstr)
return not_blank(user) ? resp[0] : resp

{
  "properties" : { },
  "id" : "9694fd5a9b554935b1db7f7a9bd964f7",
  "script" : null,
  "groupId" : "10e2710a382e42ef81f33c984351995e",
  "name" : "社区组织成员详情",
  "createTime" : null,
  "updateTime" : 1775736548454,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/org/member",
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
    "name" : "org",
    "value" : "openEuler 委员会",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : "获取社区组织架构里的成员详情",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var org_member_table = `fact_${community}_organization_member`

var sqlstr = """
SELECT jsonb_agg(jsonb_build_object(
    'email', "email",
    'user_name', "name",
    'position', "position",
    'organization', "company"
)) as "data"
FROM
    ${org_member_table}
WHERE
    1 = 1
    <if test="not_blank(org)">
        AND "group_name" = #{org}
    </if>
"""

var resp = db.select(sqlstr)
if (resp.length > 0 && resp[0].data) {
    return resp[0].data.value::json
}
return []

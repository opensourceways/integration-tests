{
  "properties" : { },
  "id" : "f7e078cf49c1483e9f51debc2b99060c",
  "script" : null,
  "groupId" : "9af308d96b55470faeda3c9b3357f836",
  "name" : "获取组织成员信息",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "org_member",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : null,
    "description" : "社区名称，可选值：openeuler",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openeuler",
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^(openeuler)$",
    "children" : null
  }, {
    "name" : "group_name",
    "value" : null,
    "description" : "组织名称，可选",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ ],
  "headers" : [ ],
  "paths" : [ ],
  "description" : "获取会议的组织人员信息",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var table_name = `fact_${community}_organization_member`

var sqlstr = """
SELECT
    group_name,
    name,
    company,
    position
FROM ${table_name} t
WHERE 1 = 1
    <if test="not_blank(group_name)">
        AND group_name = #{group_name}
    </if>
ORDER BY id
"""

return db.select(sqlstr)
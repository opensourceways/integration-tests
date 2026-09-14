{
  "properties" : { },
  "id" : "f5e814c109c246ebb581c266a2af8109",
  "script" : null,
  "groupId" : "b6ef059c61f74bcebbea73fe9ad6f241",
  "name" : "评分",
  "createTime" : null,
  "updateTime" : 1774578733128,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/score",
  "method" : "GET",
  "parameters" : [ {
    "name" : "project",
    "value" : "mindcluster",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "repo",
    "value" : "ascend-deployer",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "require",
    "value" : null,
    "description" : "描述评分项类型，取值：必选，魅力",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "date",
    "value" : null,
    "description" : "描述文档评价日期，时间戳",
    "required" : false,
    "dataType" : "Long",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"score\": 19.5,\n        \"total\": 99,\n        \"updated_at\": \"2025-11-13 17:40:34\"\n    },\n    \"timestamp\": 1763111664274,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var target = 3
var project_name = project.toLowerCase()
var sqlstr = """
SELECT coalesce(sum(info_point_rates), 0) AS score, coalesce(count(1) * #{target}, 0) AS total, max(updated_at) AS updated_at
FROM readme_info_checks
WHERE lower(project) = #{project_name} AND repo = #{repo} 
        <if test="date != null and date != ''">
            AND check_id = (
                SELECT max(check_id) 
                FROM readme_info_checks 
                WHERE lower(project) = #{project_name} AND repo = #{repo} AND date_trunc('day', updated_at) <= to_timestamp(#{date}/1000)
            )
        </if>
        <else>
            AND check_id = (SELECT max(check_id) FROM readme_info_checks WHERE lower(project) = #{project_name} AND repo = #{repo})
        </else>
        <if test="require != null and require != ''">
            AND requirements = #{require} 
        </if>
"""
return db.select(sqlstr)[0]

{
  "properties" : { },
  "id" : "14ab8fb5e92b4a6aafb51b503153c85a",
  "script" : null,
  "groupId" : "b6ef059c61f74bcebbea73fe9ad6f241",
  "name" : "评分雷达图",
  "createTime" : null,
  "updateTime" : 1774578716345,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/score/radar",
  "method" : "GET",
  "parameters" : [ {
    "name" : "project",
    "value" : "mindie",
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
    "value" : "MindIE-SD",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"kep_name\": \"了解\",\n        \"score\": 6.0,\n        \"total\": 18,\n        \"updated_at\": \"2025-11-13 17:40:34\"\n    }, {\n        \"kep_name\": \"二次开发\",\n        \"score\": 1.0,\n        \"total\": 12,\n        \"updated_at\": \"2025-11-13 17:40:34\"\n    }, {\n        \"kep_name\": \"使用\",\n        \"score\": 4.0,\n        \"total\": 12,\n        \"updated_at\": \"2025-11-13 17:40:34\"\n    }, {\n        \"kep_name\": \"反馈&支持\",\n        \"score\": 1.0,\n        \"total\": 15,\n        \"updated_at\": \"2025-11-13 17:40:34\"\n    }, {\n        \"kep_name\": \"安装\",\n        \"score\": 1.5,\n        \"total\": 12,\n        \"updated_at\": \"2025-11-13 17:40:34\"\n    }, {\n        \"kep_name\": \"获取\",\n        \"score\": 5.5,\n        \"total\": 12,\n        \"updated_at\": \"2025-11-13 17:40:34\"\n    }, {\n        \"kep_name\": \"贡献\",\n        \"score\": 0.5,\n        \"total\": 18,\n        \"updated_at\": \"2025-11-13 17:40:34\"\n    }],\n    \"timestamp\": 1763111672855,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var target = 3
var project_name = project.toLowerCase()
var sqlstr = """
SELECT kep_name, coalesce(sum(info_point_rates), 0) AS score, coalesce(count(1) * #{target}, 0) AS total, max(updated_at) AS updated_at
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
GROUP BY kep_name
"""
return db.select(sqlstr)

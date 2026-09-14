{
  "properties" : { },
  "id" : "2adc664740cc480b8e49b6da46f42729",
  "script" : null,
  "groupId" : "320a983657e04a788c165d09bd1a019a",
  "name" : "贡献总数",
  "createTime" : null,
  "updateTime" : 1744364776678,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/count",
  "method" : "GET",
  "parameters" : [ {
    "name" : "user",
    "value" : "starlet-dx",
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
    "name" : "sig",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"pr\": 3788,\n        \"issue\": 382,\n        \"comment\": 10256\n    },\n    \"timestamp\": 1744363896204,\n    \"executeTime\": 1114\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sqlstr = """
SELECT SUM(is_pr) as pr, SUM(is_issue) as issue, SUM(is_comment) as comment
FROM dws_${community}_contribute
WHERE
    user_login = #{user} AND is_removed IS NULL
        <if test="sig != null">
            AND sig_name = #{sig}
        </if>
"""
var resp = db.select(sqlstr)[0]
return resp

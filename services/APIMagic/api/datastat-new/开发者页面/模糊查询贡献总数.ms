{
  "properties" : { },
  "id" : "cc93a8c30c534784b07815359d8c765c",
  "script" : null,
  "groupId" : "3a27e930d2934b3e99edef7ee1dee30a",
  "name" : "模糊查询贡献总数",
  "createTime" : null,
  "updateTime" : 1774947227119,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "{contributeType}/count",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "cann",
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
    "value" : "aaronlee",
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
    "name" : "sig",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "comment_type",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(command|normal)$",
    "children" : null
  }, {
    "name" : "filter",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "start",
    "value" : "1754150400000",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : "1754236800000",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
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
  "paths" : [ {
    "name" : "contributeType",
    "value" : "comment",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"comment\": 0\n    },\n    \"timestamp\": 1769390384282,\n    \"executeTime\": 98\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
filter = filter != null ? filter.toLowerCase() : filter
var text_field = contributeType == 'comment' ? 'body' : 'title'
var time_field = contributeType == 'pr' ? 'merged_at' : 'created_at'
var sqlstr = """
SELECT uuid
FROM dws_${community}_contribute
WHERE contrib_type = #{contributeType}
        <if test="contributeType == 'pr'">
            AND state = 'merged'
        </if>
        <if test="user != null and user != ''">
            AND user_login = #{user}
        </if>
        <if test="sig != null and sig != ''">
            AND #{sig} = ANY(sig_name)
        </if>
        <if test="comment_type == 'command'">
            AND is_invalid_comment = 1
        </if>
        <if test="comment_type == 'normal'">
            AND is_invalid_comment = 0
        </if>
        <if test="filter != null and filter != ''">
            AND lower(${text_field}) like concat('%',#{filter},'%')
        </if>
        <if test="start != null and start != ''">
            AND ${time_field} >= to_timestamp(#{start}/1000)
        </if>
        <if test="end != null and end != ''">
            AND ${time_field} < to_timestamp(#{end}/1000)
        </if>
        <if test="community == 'openubmc'">
            AND private = 'false'
        </if>
    AND is_removed IS NULL AND is_hide IS NULL
LIMIT 20000;
"""
var resp = db.select(sqlstr)
var ans = {`${contributeType}`: resp.size()}
return ans

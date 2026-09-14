{
  "properties" : { },
  "id" : "3996cfd66bfc4177a3cd00b5f2dbb2ce",
  "script" : null,
  "groupId" : "3a27e930d2934b3e99edef7ee1dee30a",
  "name" : "comment贡献详情v2",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/comment/detail/v2",
  "method" : "GET",
  "parameters" : [ {
    "name" : "user",
    "value" : "aaronlee",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "",
    "children" : null
  }, {
    "name" : "page",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "pageSize",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "10",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "community",
    "value" : "openubmc",
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
    "value" : "",
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
    "value" : "",
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
    "value" : "",
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
    "value" : "1704150400000",
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
  }, {
    "name" : "repo_path",
    "value" : "",
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
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1773919953245,\n    \"executeTime\": 125\n}",
  "description" : "comment 贡献详情（v2）：与 comment贡献详情 一致，但额外过滤 is_hide IS NULL，与贡献汇总列表口径对齐（列表统计已过滤 is_hide）。原接口承担其他用途不变。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
filter = filter != null ? filter.toLowerCase() : filter
var off = (page - 1) * pageSize
var sqlstr = """
SELECT body as info,
       CONCAT(namespace,'/',repo_path) as repo,
       created_at as time,
       html_url as url,
       is_invalid_comment,
       comment_type as type,
       SUBSTRING(tag_url FROM '[^/]+$') as no,
       COUNT(*) OVER() as total_count
FROM dws_${community}_contribute
WHERE
    user_login = #{user} AND contrib_type='comment' AND is_removed IS NULL
        AND is_hide IS NULL
        <if test="sig != null and sig != ''">
            AND #{sig} = ANY(sig_name)
        </if>
        <if test="comment_type == 'command'">
            AND is_invalid_comment = 1
        </if>
        <if test="comment_type == 'normal'">
            AND is_invalid_comment = 0
        </if>
        <if test="start != null and start != ''">
            AND created_at >= to_timestamp(#{start}/1000)
        </if>
        <if test="end != null and end != ''">
            AND created_at < to_timestamp(#{end}/1000)
        </if>
        <if test="filter != '' and filter != null">
            AND lower(body) like concat('%',#{filter},'%')
        </if>
        <if test="community == 'openubmc'">
            AND private = 'false'
        </if>
        <if test="repo_path != null and repo_path != ''">
            AND repo_path = #{repo_path}
        </if>
ORDER BY time desc
LIMIT #{pageSize} OFFSET #{off};
"""
var resp = db.select(sqlstr)
return resp

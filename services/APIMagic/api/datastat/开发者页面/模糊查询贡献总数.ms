{
  "properties" : { },
  "id" : "e70ffd37ac2549d4bb5163b46d048d8c",
  "script" : null,
  "groupId" : "a722ad28731b4662827d7142c054a3d7",
  "name" : "模糊查询贡献总数",
  "createTime" : null,
  "updateTime" : 1774595683663,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "{contributeType}/count",
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
    "error" : "community 参数非法",
    "expression" : "^(openeuler|opengauss|mindspore|openubmc|openfuyao)$",
    "children" : null
  }, {
    "name" : "user",
    "value" : "fundawang",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "user 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]+$",
    "children" : null
  }, {
    "name" : "timeRange",
    "value" : "lastonemonth",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "all",
    "validateType" : "pattern",
    "error" : "timeRange 参数非法",
    "expression" : "^(all|lastonemonth|lasthalfyear|lastoneyear)?$",
    "children" : null
  }, {
    "name" : "sig",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "sig 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
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
    "error" : "comment_type 参数非法",
    "expression" : "^(command|normal)?$",
    "children" : null
  }, {
    "name" : "filter",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "",
    "expression" : "",
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
  "paths" : [ {
    "name" : "contributeType",
    "value" : "issue",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "contributeType 参数非法",
    "expression" : "^(issue|pr|comment)$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"issue\": 18\n    },\n    \"timestamp\": 1774595680130,\n    \"executeTime\": 30\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
filter = filter != null ? filter.toLowerCase() : filter
if (timeRange == 'lastonemonth') {
    timeRange = '1 months'
} else if (timeRange == 'lastoneyear') {
    timeRange = '1 years'
} else if (timeRange == 'lasthalfyear') {
    timeRange = '6 months'
}
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
        <if test="timeRange != 'all' and timeRange != null">
            AND ${time_field} >= (CURRENT_DATE - #{timeRange}::interval) AT TIME ZONE 'Asia/Shanghai'
        </if>
    AND is_removed IS NULL
LIMIT 20000;
"""
var resp = db.select(sqlstr)
var ans = {`${contributeType}`: resp.size()}
return ans

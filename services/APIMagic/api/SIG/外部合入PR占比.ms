{
  "properties" : { },
  "id" : "copy1751264613341d90692",
  "script" : null,
  "groupId" : "1cc0849322d74468ab73c9ad0f14fc02",
  "name" : "外部合入PR占比",
  "createTime" : null,
  "updateTime" : 1778469464139,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/pr/exteral/ratio",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openubmc",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "start 必须大于 0",
    "expression" : "",
    "children" : null
  }, {
    "name" : "end",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "end 必须大于 0",
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
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"community 参数非法\",\n    \"data\": null,\n    \"timestamp\": 1778469454612,\n    \"executeTime\": 0\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var item = '外部'
var sqlstr = """
SELECT
    unnest(sig_name) AS sig,
    COUNT(1) FILTER (WHERE internal = #{item}) AS cnt,
    COUNT(1) AS total
FROM dws_${community}_prissue_comment dcc
WHERE contrib_type = 'pr' 
      AND state = 'merged' 
      AND exists (SELECT 1 FROM fact_${community}_sig_user fcsu WHERE fcsu.sig_name = ANY(dcc.sig_name))
        <if test="start != null and start != ''">
            AND dcc.merged_at > to_timestamp(#{start}/1000)
        </if>
        <if test="end != null and end != ''">
            AND dcc.merged_at < to_timestamp(#{end}/1000)
        </if>
GROUP BY sig;
"""
var result = db.select(sqlstr)
var ans = {}
result.each(it => ans[it.sig] = it.total == 0 ? 0: it.cnt/it.total::float)
return ans

{
  "properties" : { },
  "id" : "oss_insight_report_content",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "报告内容",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/insight/report/content",
  "method" : "GET",
  "parameters" : [ {
    "name" : "report_path",
    "value" : "",
    "description" : "output/ 下报告相对路径，如 output/vllm.html（避开 magic-api 内置 path 变量）",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : "report_path 不能为空",
    "expression" : null,
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
if (report_path == null || report_path == '') {
  return {code: -1, message: 'report_path 不能为空'};
}
var rows = db.select("""SELECT path, title, insight_type, html_content, html_url,
       to_char(updated_at, 'YYYY-MM-DD HH24:MI') AS updated_at
FROM fact_oss_insight_report
WHERE path = #{report_path} AND status = 'online'""");
if (rows == null || rows.size() == 0) {
  return {code: -1, message: '报告不存在'};
}
return rows[0];

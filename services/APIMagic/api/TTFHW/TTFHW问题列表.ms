{
  "properties" : { },
  "id" : "ttfhw_list",
  "script" : null,
  "groupId" : "ttfhwgroup0000000000000000000001",
  "name" : "TTFHW问题列表",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/list",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : "社区精确匹配（可选）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "severity",
    "value" : "",
    "description" : "问题等级精确匹配（可选）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "confirm_result",
    "value" : "",
    "description" : "确认结果 是/否/待确认（可选）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "keyword",
    "value" : "",
    "description" : "标题/内容/组件/仓库模糊匹配（可选）",
    "required" : false,
    "dataType" : "String",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 1,\n        \"list\": [\n            {\n                \"id\": 1,\n                \"community\": \"openEuler\",\n                \"component\": \"kernel\",\n                \"repo_url\": \"https://github.com/openeuler/kernel\",\n                \"branch\": \"master\",\n                \"verify_machine\": \"aarch64-node-12\",\n                \"issue_title\": \"启动 panic\",\n                \"issue_content\": \"...\",\n                \"severity\": \"严重\",\n                \"reported_at\": \"2026-06-20 10:00\",\n                \"confirm_result\": \"待确认\",\n                \"confirmer\": null,\n                \"confirmed_at\": null,\n                \"test_report\": \"http://x/r/1\",\n                \"test_time\": \"2026-06-20 09:30\",\n                \"issue_url\": null,\n                \"issue_state\": null,\n                \"platform\": null\n            }\n        ]\n    }\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 待确认 TTFHW 问题列表（返回全部列，含 scenario 场景）。
// 服务端筛选：scenario / community / component 精确匹配，reported_from~reported_to 按问题提出时间范围，
// keyword 在 标题/内容/组件/仓库 上 ILIKE。所有取值用 #{} 绑定，禁止 ${} 拼接（防注入）。
var list = db.select("""
SELECT id, scenario, community, component, repo_url, branch, verify_machine,
       issue_title, issue_content, severity,
       to_char(reported_at,  'YYYY-MM-DD HH24:MI') AS reported_at,
       confirm_result, confirmer,
       to_char(confirmed_at, 'YYYY-MM-DD HH24:MI') AS confirmed_at,
       test_report,
       to_char(test_time,    'YYYY-MM-DD') AS test_time,
       issue_url, issue_state, platform, problem_type, source, source_run
FROM fact_ttfhw_issue
<where>
    <if test="scenario != null and scenario != ''">
        AND scenario = #{scenario}
    </if>
    <if test="community != null and community != ''">
        AND community = #{community}
    </if>
    <if test="component != null and component != ''">
        AND component = #{component}
    </if>
    <if test="reported_from != null and reported_from != ''">
        AND reported_at >= #{reported_from}::timestamp
    </if>
    <if test="reported_to != null and reported_to != ''">
        AND reported_at < (#{reported_to}::timestamp + interval '1 day')
    </if>
    <if test="keyword != null and keyword != ''">
        AND (issue_title ILIKE concat('%', #{keyword}, '%')
          OR issue_content ILIKE concat('%', #{keyword}, '%')
          OR component ILIKE concat('%', #{keyword}, '%')
          OR repo_url ILIKE concat('%', #{keyword}, '%'))
    </if>
</where>
ORDER BY reported_at DESC NULLS LAST, id DESC
""");
return {total: list.size(), list: list};

{
  "properties" : { },
  "id" : "ttfhw_options",
  "script" : null,
  "groupId" : "ttfhwgroup0000000000000000000001",
  "name" : "筛选选项",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/options",
  "method" : "GET",
  "parameters" : [ ],
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"community\": [\"openEuler\"],\n        \"component\": [\"kernel\"],\n        \"branch\": [\"master\"],\n        \"verify_machine\": [\"aarch64-node-12\"],\n        \"severity\": [\"严重\",\"重要\",\"一般\",\"提示\"],\n        \"confirm_result\": [\"待确认\",\"是\",\"否\"]\n    }\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 列筛选下拉枚举值：仅保留 场景 / 社区 / 组件（时间、关键字为前端控件）。
var pluck = (rows, key) => rows.map(r => r[key]);
return {
    scenario:  pluck(db.select("SELECT DISTINCT scenario  AS scenario  FROM fact_ttfhw_issue WHERE scenario  IS NOT NULL AND scenario  <> '' ORDER BY scenario"),  'scenario'),
    community: pluck(db.select("SELECT DISTINCT community AS community FROM fact_ttfhw_issue WHERE community IS NOT NULL AND community <> '' ORDER BY community"), 'community'),
    component: pluck(db.select("SELECT DISTINCT component AS component FROM fact_ttfhw_issue WHERE component IS NOT NULL AND component <> '' ORDER BY component"), 'component'),
    problem_type: pluck(db.select("SELECT DISTINCT problem_type AS problem_type FROM fact_ttfhw_issue WHERE problem_type IS NOT NULL AND problem_type <> '' ORDER BY problem_type"), 'problem_type'),
    source: pluck(db.select("SELECT DISTINCT source AS source FROM fact_ttfhw_issue WHERE source IS NOT NULL AND source <> '' ORDER BY source"), 'source')
};

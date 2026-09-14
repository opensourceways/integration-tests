{
  "properties" : { },
  "id" : "5027b4af10f141e6a150d1eb867616d5",
  "script" : null,
  "groupId" : "508fe27a47014bc796e53cd3958c9790",
  "name" : "月份列表",
  "createTime" : null,
  "updateTime" : 1777420000000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/months",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatBaseline_View",
    "description" : "允许拥有该权限的访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "wrap_request_parameter",
    "value" : "disable-cache",
    "description" : "禁缓存（注入 disable-cache 根变量，RedisCacheRequestInterceptor 命中则删本接口缓存且不回写）：录入后读月份列表需即时刷新，避免读到旧缓存",
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
  "responseBody" : null,
  "description" : "运营质量基线：返回有数据的月份列表（YYYY-MM，倒序）。空表返回 []。表由 om-dataarts 维护，本接口不建表。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 运营质量历史基线 —— 月份列表接口
// 表 fact_operation_quality_baseline 由 om-dataarts 建表/维护（见 docs/migrations/），本接口只读、不建表。
var rows = db.select("SELECT DISTINCT month FROM fact_operation_quality_baseline ORDER BY month DESC");
var months = [];
for (idx, r in rows) {
    months.add(r.month);
}
return {code: 1, message: 'ok', data: months};

{
  "properties" : { },
  "id" : "5e738f504bce4a7386a8b08e0c6a23ec",
  "script" : null,
  "groupId" : "508fe27a47014bc796e53cd3958c9790",
  "name" : "按月查询",
  "createTime" : null,
  "updateTime" : 1777420000000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/list",
  "method" : "GET",
  "parameters" : [ {
    "name" : "month",
    "value" : "",
    "description" : "基线月份，格式 YYYY-MM，如 2026-02",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
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
    "description" : "禁缓存（注入 disable-cache 根变量，RedisCacheRequestInterceptor 命中则删本接口缓存且不回写）：录入覆盖后需即时读到最新数据，避免界面读旧缓存而显示空/旧",
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
  "description" : "运营质量基线：按月份查询该月全部基线指标行（含各社区列）。缺 month 返回错误码，不 500。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 运营质量历史基线 —— 按月查询接口
// 查询参数 month 按仓内约定直接按名引用（未传时为 null）
if (month == null || month.trim() == '') {
    return {code: -1, message: 'month 不能为空'};
}
if (!month.matches('^\\d{4}-\\d{2}$')) {
    return {code: -1, message: 'month 格式非法，须为 YYYY-MM'};
}

// 表 fact_operation_quality_baseline 由 om-dataarts 建表/维护（见 docs/migrations/），本接口只读、不建表。

var list = db.select("""
SELECT community, metric_category, pulling_point, atomic_metric, metric_value, row_order
FROM fact_operation_quality_baseline
WHERE month = #{month}
ORDER BY row_order, id
""");
return {code: 1, message: 'ok', data: list};

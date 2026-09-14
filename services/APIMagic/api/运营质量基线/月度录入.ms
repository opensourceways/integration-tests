{
  "properties" : { },
  "id" : "d47ea7ac19f644318bd603dd7bdf5948",
  "script" : null,
  "groupId" : "508fe27a47014bc796e53cd3958c9790",
  "name" : "月度录入",
  "createTime" : null,
  "updateTime" : 1777420000000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/import",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatadmin_View",
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
  "responseBody" : null,
  "description" : "运营质量基线：按月覆盖式录入（DELETE 该月 + 批量 INSERT）。所有取值 #{} 绑定防注入。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 运营质量历史基线 —— 月度录入接口（覆盖式：同月重复录入覆盖旧数据）
// 所有用户输入一律 #{} 参数绑定（PreparedStatement），禁止 ${} 拼值（见设计 3.1.2）。
var month = body.month;
var records = body.records;

// —— 入参校验 ——
if (month == null || !month.matches('^\\d{4}-\\d{2}$')) {
    return {code: -1, message: 'month 非法，须为 YYYY-MM'};
}
if (records == null || records.size() == 0) {
    return {code: -1, message: 'records 不能为空'};
}

// 表 fact_operation_quality_baseline 由 om-dataarts 建表/维护（见 docs/migrations/），本接口只写、不建表。

// —— 逐条业务校验（community / atomic_metric 非空，metric_value 长度上限 512）——
for (i, rec in records) {
    if (rec.community == null || rec.community.trim() == '') {
        return {code: -1, message: '第' + (i + 1) + '条 community 不能为空'};
    }
    if (rec.atomic_metric == null || rec.atomic_metric.trim() == '') {
        return {code: -1, message: '第' + (i + 1) + '条 atomic_metric 不能为空'};
    }
    if (rec.metric_value != null && ('' + rec.metric_value).length() > 512) {
        return {code: -1, message: '第' + (i + 1) + '条 metric_value 超长（>512）'};
    }
}

// —— 覆盖式写入：先删该月，再批量插入 ——
db.update("DELETE FROM fact_operation_quality_baseline WHERE month = #{month}");
var count = 0;
for (i, rec in records) {
    var community = rec.community;
    var metricCategory = rec.metric_category;
    var pullingPoint = rec.pulling_point;
    var atomicMetric = rec.atomic_metric;
    var metricValue = rec.metric_value;
    var rowOrder = rec.row_order != null ? rec.row_order : 0;
    db.update("""
INSERT INTO fact_operation_quality_baseline
  (month, community, metric_category, pulling_point, atomic_metric, metric_value, row_order)
VALUES
  (#{month}, #{community}, #{metricCategory}, #{pullingPoint}, #{atomicMetric}, #{metricValue}, #{rowOrder})
""");
    count = count + 1;
}
return {code: 1, message: '导入成功', data: {month: month, count: count}};

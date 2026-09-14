{
  "properties" : { },
  "id" : "prometheususagetrend000000000001",
  "script" : null,
  "groupId" : "d3f0a1b2c3d4e5f60718293a4b5c6d7e",
  "name" : "使用趋势",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/usageTrend",
  "method" : "GET",
  "parameters" : [ {
    "name" : "dimension",
    "value" : "",
    "description" : "分组/拆线维度，Prometheus 标签名(project=集群/cluster_name=集群名称/env=资源类型/account=账号/community=社区/region=地域/type=设备类型/domain=领域)；元数据层正则白名单校验；默认 project；非白名单值被拒绝。选择 value 后按该维度拆线(如 dimension=account 则每个选中账号一条线)",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "dimension 仅允许 project/cluster_name/npu_type/account/community/region/role/domain/env",
    "expression" : "^(project|cluster_name|npu_type|account|community|region|role|domain|env)?$",
    "children" : null
  }, {
    "name" : "value",
    "value" : "",
    "description" : "取值筛选，所选维度下的标签值，多值逗号分隔(OR)；空或 All 返回 1 条汇总线(总使用)；选择一个或多个值则按 dimension 拆线",
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
    "value" : null,
    "description" : "起始时间(秒或毫秒时间戳)",
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
    "value" : null,
    "description" : "结束时间(秒或毫秒时间戳)",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "step",
    "value" : null,
    "description" : "步长(秒)：1min=60 / 1h=3600 / 1d=86400，下限 60，并按时间范围自动升档(≤2天≥1min、≤7天≥5min、≤15天≥15min、≤30天≥30min、≤90天≥2h、≤180天≥8h、>180天≥1d)，与步长 Tips 一致",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatmindall_View,admin_token",
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
    "name" : "cache-ttl",
    "value" : "30",
    "description" : "redis 缓存过期时间(秒)，实时监控接口 30s 多用户共享",
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
  "description" : "NPU 监控-使用趋势：value 为空或 All 时返回 1 条汇总线(总使用)；选择一个或多个值时按 dimension 维度拆线(每个取值一条线)。dimension 在元数据层经正则白名单校验，仅允许 project/cluster_name/npu_type/account/community/region/role/domain/env，默认 project(集群)。已剔除 project=unknown 及含 test/测试/昇思/coder/argo 的数据",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import prometheus;
import '@/prom/resolveStep' as resolveStep;

var out = { "series" : [] };
if (start == null || end == null) {
    return out;
}
var s = start > 100000000000L ? start / 1000 : start;
var e = end > 100000000000L ? end / 1000 : end;
if ((e - s) > 2678400) { s = e - 2678400; }
// 采样步长按时间范围强制下限（与步长 Tips 一致，提查询效率），规则集中在工具函数 resolveStep
var st = resolveStep(step, e - s);

// dimension 已在元数据层经正则白名单校验，脚本不再重复校验；空值默认 project(集群)。
var dim = (dimension == null || dimension == "") ? "project" : dimension;

// 统一构建 selector：固定排除段始终在前(不可绕过)，value 非空且非 All 时追加一条 dim=~"正则" matcher，
// 逗号→| 实现多值 OR；escapeRegex 防注入。
var FIXED = 'project!="unknown",project!~".*(test|测试|昇思|coder|argo|openmerlin-guiyang-006|统一资源池-ascend-mind).*"';
var sel = "{" + FIXED;
var hasFilter = (value != null && value != "" && value != "All");
if (hasFilter) {
    sel += ',' + dim + '=~"' + prometheus.escapeRegex(value).replace(',', '|') + '"';
}
sel += "}";

// value 为 All/空 → 1 条汇总线(总使用)；选择一个或多个值 → 按维度拆线(每个取值一条线)。
var q;
if (hasFilter) {
    q = "sum by(" + dim + ")(custom_npu_total_used_count" + sel + ")";
} else {
    q = "sum(custom_npu_total_used_count" + sel + ")";
}

var rows = prometheus.queryRange(q, s, e, st + "");
for (item in rows) {
    var name = "总使用";
    if (item.get("metric") != null && item.get("metric").get(dim) != null) {
        name = item.get("metric").get(dim);
    }
    var points = [];
    var values = item.get("values");
    if (values != null) {
        for (p in values) {
            if (p != null && p.size() >= 2) {
                points.add([p.get(0), p.get(1).asDouble()]);
            }
        }
    }
    out.series.add({ "name" : name, "points" : points });
}
return out;

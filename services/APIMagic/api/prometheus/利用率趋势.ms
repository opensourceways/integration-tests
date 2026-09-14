{
  "properties" : { },
  "id" : "prometheusutiltrend0000000000001",
  "script" : null,
  "groupId" : "d3f0a1b2c3d4e5f60718293a4b5c6d7e",
  "name" : "使用率趋势",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/utilizationTrend",
  "method" : "GET",
  "parameters" : [ {
    "name" : "dimension",
    "value" : "",
    "description" : "分组/拆线维度，Prometheus 标签名(project=集群/cluster_name=集群名称/env=资源类型/account=账号/community=社区/region=地域/npu_type=设备类型/domain=领域)；元数据层正则白名单校验；默认 project；非白名单值被拒绝。选择 value 后按该维度拆线(如 dimension=account 则每个选中账号一条线)",
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
    "description" : "取值筛选，所选维度下的标签值，多值逗号分隔(OR)；空或 All 返回 1 条汇总线(总使用率)；选择一个或多个值则按 dimension 拆线",
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
  "description" : "NPU 监控-使用率趋势：value 为空或 All 时返回 1 条汇总线(总使用率)；选择一个或多个值时按 dimension 维度拆线(每个取值一条线)。dimension 在元数据层经正则白名单校验，仅允许 project/cluster_name/npu_type/account/community/region/role/domain/env，默认 project(集群)。使用率 = 使用卡数(custom_npu_total_used_count) / 总卡数(custom_npu_total)；总卡数不可得时返回空 series。已剔除 project=unknown 及含 test/测试/昇思/coder/argo 的数据。响应含 step(实际使用的采样步长，秒，经 resolveStep 升档后)",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import prometheus;
import '@/prom/resolveStep' as resolveStep;

var out = { "series" : [], "step" : null };
if (start == null || end == null) {
    return out;
}
var s = start > 100000000000L ? start / 1000 : start;
var e = end > 100000000000L ? end / 1000 : end;
if ((e - s) > 2678400) { s = e - 2678400; }
// 采样步长按时间范围强制下限（与步长 Tips 一致，提查询效率），规则集中在工具函数 resolveStep
var st = resolveStep(step, e - s);
out.step = st;

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

// value 为 All/空 → 1 条汇总线(总使用率)：总使用卡数 / 总卡数。
// 选择一个或多个值 → 按维度拆线：该维度使用卡数 / 该维度总卡数。
// 总卡数直接取自 Prometheus 指标 custom_npu_total（与 custom_npu_total_used_count
// 标签一致、同步上报），不再由历史最大节点数×每节点卡数推导。
var q2;
if (hasFilter) {
    var usedByDim = "sum by(" + dim + ")(custom_npu_total_used_count" + sel + ")";
    var totalByDim = "sum by(" + dim + ")(custom_npu_total" + sel + ")";
    q2 = usedByDim + " / on(" + dim + ") (" + totalByDim + ")";
} else {
    var usedAll = "sum(custom_npu_total_used_count" + sel + ")";
    var totalAll = "sum(custom_npu_total" + sel + ")";
    q2 = usedAll + " / (" + totalAll + ")";
}

var rows2 = prometheus.queryRange(q2, s, e, st + "");
if (rows2 != null && rows2.size() > 0) {
    for (item in rows2) {
        var lineName = "总使用率";
        if (hasFilter && item.get("metric") != null && item.get("metric").get(dim) != null) {
            lineName = item.get("metric").get(dim);
        }
        var points = [];
        var values = item.get("values");
        if (values != null) {
            for (p in values) {
                if (p != null && p.size() >= 2 && p.get(1) != null) {
                    points.add([p.get(0), p.get(1).asDouble()]);
                }
            }
        }
        out.series.add({ "name" : lineName, "points" : points });
    }
}

return out;

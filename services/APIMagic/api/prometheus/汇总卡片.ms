{
  "properties" : { },
  "id" : "prometheussummary00000000000001",
  "script" : null,
  "groupId" : "d3f0a1b2c3d4e5f60718293a4b5c6d7e",
  "name" : "汇总卡片",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/summary",
  "method" : "GET",
  "parameters" : [ {
    "name" : "dimension",
    "value" : "",
    "description" : "分组/筛选维度，Prometheus 标签名(project=集群/cluster_name=集群名称/env=资源类型/account=账号/community=社区/region=地域/npu_type=设备类型/domain=领域)；元数据层正则白名单校验；默认 project；非白名单值被拒绝",
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
    "description" : "取值筛选，所选维度下的标签值，多值逗号分隔(OR)；空或 All 表示不过滤(按该维度全部取值聚合)",
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
    "description" : "统计窗口起始(秒或毫秒时间戳)，用于计算历史窗口跨度",
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
    "description" : "统计窗口结束(秒或毫秒时间戳)，用于计算历史窗口跨度，同时作为 PromQL 求值时刻(range-vector 锚点)；未传 start/end 时回落到当前时刻",
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
    "description" : "采样步长(秒)：range-vector 采样间隔，与趋势图对齐；<60 回落 60，并按时间范围自动升档(≤2天≥1min、≤7天≥5min、≤15天≥15min、≤30天≥30min、≤90天≥2h、≤180天≥8h、>180天≥1d)，与步长 Tips 一致",
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
  "description" : "NPU 监控-汇总卡片：当前总卡数 totalCards 直接取自 Prometheus 指标 custom_npu_total / 总使用卡数 totalUsed(custom_npu_total_used_count) / 使用率 utilization = totalUsed / totalCards (0~1)（均随 dimension+value 筛选变化，已剔除 project=unknown 及含 test/测试/昇思/coder/argo 的数据）+ 时间范围内使用卡数与使用率的 P50/P90/平均值（直接用 PromQL 原生 quantile_over_time / avg_over_time 计算，不在脚本内取样后自算）。统计窗口随所选 start/end/step 变化，不强制下限；所有 PromQL 均锚定到 end 时间戳求值（range-vector 落在 [start, end]），未传 start/end 时回落到当前时刻。dimension 在元数据层经正则白名单校验，仅允许 project/cluster_name/type/account/community/region/role/domain/env，选定分组维度，value 在该维度下做取值过滤；不传 dimension 时按 project(集群)。汇总卡片为单组聚合，不按维度拆分",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import prometheus;
import '@/prom/resolveStep' as resolveStep;

var out = {
    "totalCards" : 0,
    "totalUsed" : 0,
    "utilization" : null,
    "usedP50" : null,
    "usedP90" : null,
    "usedAvg" : null,
    "utilP50" : null,
    "utilP90" : null,
    "utilAvg" : null
};

// dimension 已在元数据层经正则白名单校验，脚本不再重复校验；空值默认 project(集群)。
var dim = (dimension == null || dimension == "") ? "project" : dimension;

// 统一构建 selector：固定排除段始终在前(不可绕过)，value 非空且非 All 时追加一条 dim=~"正则" matcher，
// 逗号→| 实现多值 OR；escapeRegex 防注入。汇总卡片为单组聚合，不按维度拆分。
var FIXED = 'project!="unknown",project!~".*(test|测试|昇思|coder|argo|openmerlin-guiyang-006|统一资源池-ascend-mind).*"';
var sel = "{" + FIXED;
var hasFilter = (value != null && value != "" && value != "All");
if (hasFilter) {
    sel += ',' + dim + '=~"' + prometheus.escapeRegex(value).replace(',', '|') + '"';
}
sel += "}";

var usedExpr = "sum(custom_npu_total_used_count" + sel + ")";

var span = "604800s";
var diff = 604800L;
// evalTime: PromQL 求值时刻。传了 start/end 时锚定到窗口结束时刻 e，使 [span:st] range-vector
// 落在 [start, end] 区间（而非默认的 [now-span, now]），汇总数值随所选时间窗口变化；
// 未传 start/end 时为 null = 当前时刻（保留原兜底语义）
var evalTime = null;
if (start != null && end != null) {
    var s = start > 100000000000L ? start / 1000 : start;
    var e = end > 100000000000L ? end / 1000 : end;
    diff = e - s;
    if (diff < 60) { diff = 60; }
    span = (diff + "s");
    evalTime = e;
}
// 采样步长按时间范围强制下限（与步长 Tips 一致，提查询效率），规则集中在工具函数 resolveStep
var st = resolveStep(step, diff);
// 总卡数直接取自 Prometheus 指标 custom_npu_total（与 custom_npu_total_used_count
// 标签一致、同步上报），不再由节点数×每节点卡数推导
var totalExpr = "sum(custom_npu_total" + sel + ")";

var used = prometheus.queryInstant(usedExpr, evalTime);
var total = prometheus.queryInstant(totalExpr, evalTime);
if (used != null) { out.totalUsed = used::int; }
if (total != null) { out.totalCards = total::int; }
if (out.totalCards > 0 && used != null) { out.utilization = used::double / out.totalCards; }

var sub = usedExpr + "[" + span + ":" + st + "s]";
out.usedP50 = prometheus.queryInstant("quantile_over_time(0.5, " + sub + ")", evalTime);
out.usedP90 = prometheus.queryInstant("quantile_over_time(0.9, " + sub + ")", evalTime);
out.usedAvg = prometheus.queryInstant("avg_over_time(" + sub + ")", evalTime);
if (out.totalCards > 0) {
    if (out.usedP50 != null) { out.usedP50 = out.usedP50::int; out.utilP50 = out.usedP50::double / out.totalCards; }
    if (out.usedP90 != null) { out.usedP90 = out.usedP90::int; out.utilP90 = out.usedP90::double / out.totalCards; }
    if (out.usedAvg != null) { out.usedAvg = out.usedAvg::int; out.utilAvg = out.usedAvg::double / out.totalCards; }
}
return out;

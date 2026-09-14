{
  "properties" : { },
  "id" : "prometheuslabelvalues0000000001",
  "script" : null,
  "groupId" : "d3f0a1b2c3d4e5f60718293a4b5c6d7e",
  "name" : "标签取值",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/labelValues",
  "method" : "GET",
  "parameters" : [ {
    "name" : "label",
    "value" : null,
    "description" : "Prometheus 标签名(如 project/resource_type/account/region/role)，必须符合标签名规范；按该标签返回下拉取值",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "expression",
    "error" : "label 不能为空",
    "expression" : "label != null && label != ''",
    "children" : null
  }, {
    "name" : "start",
    "value" : null,
    "description" : "起始时间(秒或毫秒时间戳)，限定查询窗口；不传则查全量",
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
    "description" : "结束时间(秒或毫秒时间戳)，限定查询窗口；不传则查全量",
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
  "description" : "NPU 监控-通用标签取值下拉：传入 Prometheus 标签名(如 project/resource_type/account/region/role)返回该标签的可用取值列表，首元素固定为 All，支持 start/end 限定时间窗口。project 维度会剔除 project=unknown 及含 test/测试/昇思/coder/argo 的数据；其余维度原样返回。新增筛选维度无需改本接口，前端直接传入对应标签名即可",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import prometheus;

// 标签名白名单校验（Prometheus 标签名规范：字母/下划线开头，仅含字母数字下划线），
// 防止任意字符串注入到 /api/v1/label/<label>/values 路径
if (label == null || label == "" || !label.matches("^[a-zA-Z_][a-zA-Z0-9_]*$")) {
    return ["All"];
}

// 秒或毫秒时间戳归一化为秒级（与 summary/usageTrend/utilizationTrend 一致）
var s = null;
var e = null;
if (start != null) { s = start > 100000000000L ? start / 1000 : start; }
if (end != null) { e = end > 100000000000L ? end / 1000 : end; }

var result = prometheus.queryLabelValues(label, null, s, e);

var cleaned = [];
// 仅 project 维度剔除 unknown 及包含 test/测试/昇思/coder/argo 的非业务数据（与原集群列表口径一致）
var needExclude = ("project" == label);
var EXCLUDE_KEYWORDS = ["test", "测试", "昇思", "coder", "argo", "openmerlin-guiyang-006", "统一资源池-ascend-mind"];
for (v in result) {
    var skip = false;
    if (needExclude) {
        skip = (v == "unknown");
        if (!skip && v != null) {
            for (kw in EXCLUDE_KEYWORDS) {
                if (v.toLowerCase().indexOf(kw) >= 0) {
                    skip = true;
                }
            }
        }
    }
    if (!skip) {
        cleaned.add(v);
    }
}
cleaned.add(0, "All");
return cleaned;

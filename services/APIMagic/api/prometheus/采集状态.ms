{
  "properties" : { },
  "id" : "prometheusupstatus00000000001",
  "script" : null,
  "groupId" : "d3f0a1b2c3d4e5f60718293a4b5c6d7e",
  "name" : "采集状态",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/upStatus",
  "method" : "GET",
  "parameters" : [ {
    "name" : "start",
    "value" : null,
    "description" : "检查窗起始(秒或毫秒时间戳)；不传默认 now-24h",
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
    "description" : "检查窗结束(秒或毫秒时间戳)；不传默认 now",
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
    "description" : "采样步长(秒)，默认 3600(1h)；<60 回落 60",
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
  "description" : "NPU 监控-采集状态(up 指标)：查询 Prometheus 内建 up 指标(1=采集正常,0=采集故障)，识别近 24h 内哪些 job 的采集器挂了。按 job+instance 维度返回每个采集目标的最新 up 值、状态(normal/down)、故障采样点数 downPoints、最近故障时刻 lastDownAt；并按 job 统计 totalPoints(窗口内采样点数)、availability(可用性=1-downPoints/totalPoints，0~1)、transitions(0/1 相邻取值变更次数=抖动，频繁 0/1 切换即跌宕较多)。汇总 total(采集目标总数) 与 downJobCount(当前处于故障的 job 数)。start/end 缺省 now-24h/now，秒或毫秒自适应",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import prometheus;
import java.time.Instant;

var HOUR_SECONDS = 3600;

// 时间归一化：秒或毫秒自适应；缺省 now-24h / now
var nowMs = Instant.now().toEpochMilli();
var e = (end != null) ? (end > 100000000000L ? (end / 1000)::long : end::long) : (nowMs / 1000)::long;
var s = (start != null) ? (start > 100000000000L ? (start / 1000)::long : start::long) : (e - 24 * HOUR_SECONDS);
if (s >= e) {
    return {
        "windowStart" : s,
        "windowEnd" : e,
        "jobs" : [],
        "total" : 0,
        "downJobCount" : 0
    };
}

// 采样步长：默认 1h，下限 60s
var st = HOUR_SECONDS + "";
if (step != null && step >= 60) {
    st = step::int + "";
}

// up 是 Prometheus 内建指标：每个 scrape target(job+instance) 一条序列，1=正常 0=采集故障
var rows = prometheus.queryRange("up", s, e, st);

var jobs = [];
if (rows != null) {
    for (item in rows) {
        var metric = item.get("metric");
        var job = (metric != null && metric.get("job") != null) ? metric.get("job") : "";
        var instance = (metric != null && metric.get("instance") != null) ? metric.get("instance") : "";
        var values = item.get("values");
        if (values == null) {
            continue;
        }

        var downPoints = 0;
        var totalPoints = 0;
        var transitions = 0;
        var lastDownAt = null;
        var latest = "1";
        var prevVal = null;
        for (p in values) {
            if (p == null || p.size() < 2 || p.get(1) == null) {
                continue;
            }
            var ts = p.get(0);
            var val = p.get(1).asText();
            latest = val;
            totalPoints = totalPoints + 1;
            if (prevVal != null && val != prevVal) {
                transitions = transitions + 1;
            }
            prevVal = val;
            if ("0" == val) {
                downPoints = downPoints + 1;
                lastDownAt = ts::long * 1000;
            }
        }
        var availability = null;
        if (totalPoints > 0) {
            availability = (totalPoints - downPoints)::double / totalPoints;
        }

        var upVal = 1;
        if ("0" == latest) {
            upVal = 0;
        }
        var status = (upVal == 1) ? "normal" : "down";

        jobs.add({
            "job" : job,
            "instance" : instance,
            "up" : upVal,
            "status" : status,
            "totalPoints" : totalPoints,
            "downPoints" : downPoints,
            "availability" : availability,
            "transitions" : transitions,
            "lastDownAt" : lastDownAt
        });
    }
}

// 当前处于故障（最新 up=0）的 job 数
var downJobCount = 0;
for (j in jobs) {
    if (j.status == "down") {
        downJobCount = downJobCount + 1;
    }
}

return {
    "windowStart" : s,
    "windowEnd" : e,
    "jobs" : jobs,
    "total" : jobs.size(),
    "downJobCount" : downJobCount
};

{

  "properties" : { },

  "id" : "copy1741864443382d19970",

  "script" : null,

  "groupId" : "90bfa31b9b81424e896849dc1c79271c",

  "name" : "健康度指标对比",

  "createTime" : null,

  "updateTime" : 1741914889014,

  "lock" : null,

  "createBy" : null,

  "updateBy" : null,

  "path" : "/communityCompare",

  "method" : "GET",

  "parameters" : [ {

    "name" : "community",

    "value" : "openeuler",

    "description" : null,

    "required" : false,

    "dataType" : "String",

    "type" : null,

    "defaultValue" : null,

    "validateType" : null,

    "error" : null,

    "expression" : null,

    "children" : null

  } ],

  "options" : [ ],

  "requestBody" : "",

  "headers" : [ ],

  "paths" : [ ],

  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"lastDay\": [{\n            \"health_metric\": \"软件有效维护\",\n            \"name\": \"软件有效维护\",\n            \"max\": 5,\n            \"health_value\": 1,\n            \"metric_value\": 0.12851685,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"贡献者交互率\",\n            \"name\": \"贡献者交互率\",\n            \"max\": 5,\n            \"health_value\": 1,\n            \"metric_value\": 1.0,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"PR/Issue首次响应时间\",\n            \"name\": \"PR/Issue首次响应时间\",\n            \"max\": 5,\n            \"health_value\": 4,\n            \"metric_value\": 2.2086806,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"需求/缺陷闭环率\",\n            \"name\": \"需求/缺陷闭环率\",\n            \"max\": 5,\n            \"health_value\": 3,\n            \"metric_value\": 0.7911361,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"贡献企业多样性\",\n            \"name\": \"贡献企业多样性\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 68.0,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"大象系数\",\n            \"name\": \"大象系数\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 4.0,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"开发者撬动比\",\n            \"name\": \"开发者撬动比\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 1.6074618,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"版本稳定发布\",\n            \"name\": \"版本稳定发布\",\n            \"max\": 5,\n            \"health_value\": 3,\n            \"metric_value\": 1.2,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"装机量/下载量\",\n            \"name\": \"装机量/下载量\",\n            \"max\": 5,\n            \"health_value\": 1,\n            \"metric_value\": 1380000.0,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"NSS评分\",\n            \"name\": \"NSS评分\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 0.6,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"软件供应链安全\",\n            \"name\": \"软件供应链安全\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 7.0,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"技术影响力\",\n            \"name\": \"技术影响力\",\n            \"max\": 5,\n            \"health_value\": 4,\n            \"metric_value\": 0.6,\n            \"created_at\": \"2025-03-13\",\n            \"community\": \"openeuler\"\n        }],\n        \"lastWeekDay\": [{\n            \"health_metric\": \"软件有效维护\",\n            \"name\": \"软件有效维护\",\n            \"max\": 5,\n            \"health_value\": 1,\n            \"metric_value\": 0.12429378,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"贡献者交互率\",\n            \"name\": \"贡献者交互率\",\n            \"max\": 5,\n            \"health_value\": 1,\n            \"metric_value\": 1.0,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"PR/Issue首次响应时间\",\n            \"name\": \"PR/Issue首次响应时间\",\n            \"max\": 5,\n            \"health_value\": 4,\n            \"metric_value\": 2.1481712,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"需求/缺陷闭环率\",\n            \"name\": \"需求/缺陷闭环率\",\n            \"max\": 5,\n            \"health_value\": 3,\n            \"metric_value\": 0.7808765,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"贡献企业多样性\",\n            \"name\": \"贡献企业多样性\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 68.0,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"大象系数\",\n            \"name\": \"大象系数\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 4.0,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"开发者撬动比\",\n            \"name\": \"开发者撬动比\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 2.3249083,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"版本稳定发布\",\n            \"name\": \"版本稳定发布\",\n            \"max\": 5,\n            \"health_value\": 3,\n            \"metric_value\": 1.2,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"装机量/下载量\",\n            \"name\": \"装机量/下载量\",\n            \"max\": 5,\n            \"health_value\": 1,\n            \"metric_value\": 1380000.0,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"NSS评分\",\n            \"name\": \"NSS评分\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 0.6,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"软件供应链安全\",\n            \"name\": \"软件供应链安全\",\n            \"max\": 5,\n            \"health_value\": 5,\n            \"metric_value\": 7.0,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }, {\n            \"health_metric\": \"技术影响力\",\n            \"name\": \"技术影响力\",\n            \"max\": 5,\n            \"health_value\": 4,\n            \"metric_value\": 0.6,\n            \"created_at\": \"2025-03-06\",\n            \"community\": \"openeuler\"\n        }]\n    },\n    \"timestamp\": 1741914751984,\n    \"executeTime\": 10\n}",

  "description" : null,

  "requestBodyDefinition" : null,

  "responseBodyDefinition" : {

    "name" : "",

    "value" : "",

    "description" : "",

    "required" : false,

    "dataType" : "Object",

    "type" : null,

    "defaultValue" : null,

    "validateType" : "",

    "error" : "",

    "expression" : "",

    "children" : [ {

      "name" : "code",

      "value" : "-1",

      "description" : "",

      "required" : false,

      "dataType" : "Integer",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "",

      "error" : "",

      "expression" : "",

      "children" : [ ]

    }, {

      "name" : "message",

      "value" : "系统内部出现错误",

      "description" : "",

      "required" : false,

      "dataType" : "String",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "",

      "error" : "",

      "expression" : "",

      "children" : [ ]

    }, {

      "name" : "data",

      "value" : "null",

      "description" : "",

      "required" : false,

      "dataType" : "Object",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "",

      "error" : "",

      "expression" : "",

      "children" : [ ]

    }, {

      "name" : "timestamp",

      "value" : "1741864256822",

      "description" : "",

      "required" : false,

      "dataType" : "Long",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "",

      "error" : "",

      "expression" : "",

      "children" : [ ]

    }, {

      "name" : "executeTime",

      "value" : "9",

      "description" : "",

      "required" : false,

      "dataType" : "Integer",

      "type" : null,

      "defaultValue" : null,

      "validateType" : "",

      "error" : "",

      "expression" : "",

      "children" : [ ]

    } ]

  }

}

================================
import 'java.util.HashMap' as Map;
Calendar calendar = Calendar.getInstance();
calendar.add(Calendar.DAY_OF_MONTH, -1);
calendar.set(Calendar.HOUR_OF_DAY, 0);
calendar.set(Calendar.MINUTE, 0);
calendar.set(Calendar.SECOND, 0);
calendar.set(Calendar.MILLISECOND, 0);
var startDate = calendar.getTime();
calendar.set(Calendar.HOUR_OF_DAY, 23);
calendar.set(Calendar.MINUTE, 59); 
calendar.set(Calendar.SECOND, 59); 
calendar.set(Calendar.MILLISECOND, 999); 
var endDate = calendar.getTime();
var communityParam = community;
var sql = """select health_metric,health_metric as name,5 as max,health_value,metric_value,created_at,community from dws_health_metric where community=#{communityParam} and created_at>=#{startDate} and created_at<=#{endDate}""";
HashMap map = new HashMap();
var data1 = db.select(sql);
map.put("lastDay",data1);
Calendar calendar2 = Calendar.getInstance();
calendar.add(Calendar.DAY_OF_MONTH, -7);
calendar2.set(Calendar.HOUR_OF_DAY, 0);
calendar2.set(Calendar.MINUTE, 0);
calendar2.set(Calendar.SECOND, 0);
calendar2.set(Calendar.MILLISECOND, 0);
var startDate2 = calendar.getTime();
calendar2.set(Calendar.HOUR_OF_DAY, 23);
calendar2.set(Calendar.MINUTE, 59); 
calendar2.set(Calendar.SECOND, 59); 
calendar2.set(Calendar.MILLISECOND, 999); 
var endDate2 = calendar.getTime();
var sql2 = """select health_metric,health_metric as name,5 as max,health_value,metric_value,created_at,community from dws_health_metric where community=#{communityParam} and created_at>=#{startDate2} and created_at<=#{endDate2}""";
var data2 = db.select(sql2);
map.put("lastWeekDay",data2);
return map;

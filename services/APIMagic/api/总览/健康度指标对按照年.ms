{
  "properties" : { },
  "id" : "copy1741867226086d3339",
  "script" : null,
  "groupId" : "90bfa31b9b81424e896849dc1c79271c",
  "name" : "健康度指标对按照年",
  "createTime" : null,
  "updateTime" : 1742454821783,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/communityByYear",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"xAxis\": [\"2025-02-13\", \"2025-02-17\", \"2025-02-19\", \"2025-02-20\", \"2025-02-21\", \"2025-02-22\", \"2025-02-23\", \"2025-02-24\", \"2025-02-25\", \"2025-02-26\", \"2025-02-27\", \"2025-02-28\", \"2025-03-01\", \"2025-03-02\", \"2025-03-03\", \"2025-03-04\", \"2025-03-05\", \"2025-03-06\", \"2025-03-07\", \"2025-03-08\", \"2025-03-09\", \"2025-03-10\", \"2025-03-11\", \"2025-03-12\", \"2025-03-13\"],\n        \"series\": [{\n            \"stack\": \"Total\",\n            \"data\": [2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],\n            \"name\": \"软件有效维护\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],\n            \"name\": \"PR/Issue首次响应时间\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],\n            \"name\": \"贡献者交互率\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],\n            \"name\": \"软件供应链安全\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],\n            \"name\": \"NSS评分\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [2, 2, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],\n            \"name\": \"装机量/下载量\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],\n            \"name\": \"版本稳定发布\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],\n            \"name\": \"开发者撬动比\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],\n            \"name\": \"大象系数\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],\n            \"name\": \"贡献企业多样性\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],\n            \"name\": \"需求/缺陷闭环率\",\n            \"type\": \"line\"\n        }, {\n            \"stack\": \"Total\",\n            \"data\": [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],\n            \"name\": \"技术影响力\",\n            \"type\": \"line\"\n        }],\n        \"legend\": [\"软件有效维护\", \"PR/Issue首次响应时间\", \"贡献者交互率\", \"软件供应链安全\", \"NSS评分\", \"装机量/下载量\", \"版本稳定发布\", \"开发者撬动比\", \"大象系数\", \"贡献企业多样性\", \"需求/缺陷闭环率\", \"技术影响力\"],\n        \"title\": \"健康度指标趋势\"\n    },\n    \"timestamp\": 1741919299664,\n    \"executeTime\": 11\n}",
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
Calendar calendar = Calendar.getInstance();
calendar.add(Calendar.DAY_OF_MONTH, -1);
calendar.set(Calendar.HOUR_OF_DAY, 0);
calendar.set(Calendar.MINUTE, 0);
calendar.set(Calendar.SECOND, 0);
calendar.set(Calendar.MILLISECOND, 0);
var endDate = calendar.getTime();
calendar.add(Calendar.YEAR, -1);
calendar.set(Calendar.HOUR_OF_DAY, 23);
calendar.set(Calendar.MINUTE, 59); 
calendar.set(Calendar.SECOND, 59); 
calendar.set(Calendar.MILLISECOND, 999); 
var startDate = calendar.getTime();
var communityParam = community;
var sql = """select health_metric,health_metric as name,5 as max,health_value,metric_value,created_at,community from dws_health_metric where community=#{communityParam} and created_at>=#{startDate} and created_at<=#{endDate} order by created_at """;
var xaxisSql = """select distinct created_at  from dws_health_metric where community=#{communityParam} and created_at>=#{startDate} and created_at<=#{endDate} order by created_at"""
var xAxis = db.select(xaxisSql);
var data1 = db.select(sql);
var series = data1.group(item=>item.health_metric);
var keys = series.keySet();
ArrayList leng = new ArrayList();
ArrayList seriesList = new ArrayList();
for (item in keys) {
   leng.add(item);
   var  data =  series.get(item);
   HashMap map = new HashMap();
   ArrayList seriesData = new ArrayList();
   data.forEach((item)=>{seriesData.add(item.get("health_value"))});
    map.put("name",item);
   map.put("type","line");
   map.put("data",seriesData);
   seriesList.add(map);
}
ArrayList list = new ArrayList();
xAxis.forEach((item)=>{list.add(item.get("created_at"))});
var title = "健康度指标趋势";
HashMap map = new HashMap();
map.put("xAxis",list);
map.put("series",seriesList);
map.put("title",title);
map.put("legend",leng)
return map;

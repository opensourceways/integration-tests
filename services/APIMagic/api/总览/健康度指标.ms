{
  "properties" : { },
  "id" : "92e4e1dcce4646a2ac91bc8b327ec1d7",
  "script" : null,
  "groupId" : "90bfa31b9b81424e896849dc1c79271c",
  "name" : "健康度指标",
  "createTime" : null,
  "updateTime" : 1742435821830,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/community",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openUBMC",
    "description" : null,
    "required" : true,
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1742435794586,\n    \"executeTime\": 4\n}",
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
var startDate = calendar.getTime();
calendar.set(Calendar.HOUR_OF_DAY, 23);
calendar.set(Calendar.MINUTE, 59); 
calendar.set(Calendar.SECOND, 59); 
calendar.set(Calendar.MILLISECOND, 999); 
var endDate = calendar.getTime();
var communityParam = community;
var sql = """select health_metric,health_metric as name,health_value,metric_value,5 as max,created_at,community from dws_health_metric where community=#{communityParam} and created_at>=#{startDate} and created_at<=#{endDate}""";
return db.select(sql);

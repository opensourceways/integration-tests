{
  "properties" : { },
  "id" : "bd1b704eefb9478fa5c5a7abbda70f24",
  "script" : null,
  "groupId" : "fee87ad3dfde4e33b4dd4bc0eb95ce14",
  "name" : "查询所有的PV和UV",
  "createTime" : null,
  "updateTime" : 1774322226194,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/data/all",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
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
  "requestBody" : "{\r\n\"community\": \"cannopen\",\r\n\"endDate\": 1745539200000,\r\n\"source\": \"all\",\r\n\"startDate\": 1772947200000\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1774322144010,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : {
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
      "name" : "community",
      "value" : "cannopen",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "endDate",
      "value" : "1745539200000",
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
      "name" : "source",
      "value" : "all",
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
      "name" : "startDate",
      "value" : "1772947200000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var community = body.community;
var startDate =date_format(body.startDate::date('yyyy-MM-dd'),'yyyy-MM-dd');
var endDate = date_format(body.endDate::date('yyyy-MM-dd'),'yyyy-MM-dd');
var community_tem = body.community;
if("cannopen".equals(body.community)){
    community_tem = "cann"
}
var sql = """
        select * from (
            select source,sum(pv) as pv_count,sum(uv) as uv_count from dws_${community_tem}_service_log_daily where created_at BETWEEN #{startDate}::date AND #{endDate}::date group by source
        )a left join (select distinct source,type_name as service_name from  dict_service_metrics where community=#{community}) b on a.source=b.source where b.service_name is not null
""";
return db.select(sql);

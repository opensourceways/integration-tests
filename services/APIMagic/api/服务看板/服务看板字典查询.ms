{
  "properties" : { },
  "id" : "8f667641ea7f4b5d83f2c236ce08f89f",
  "script" : null,
  "groupId" : "fee87ad3dfde4e33b4dd4bc0eb95ce14",
  "name" : "服务看板字典查询",
  "createTime" : null,
  "updateTime" : 1774576409810,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/dict/all",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "mindspore",
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
  }, {
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"source\": [{\n            \"label\": \"邮件服务\",\n            \"value\": \"email\"\n        }],\n        \"metric_dict\": {\n            \"email\": [{\n                \"value\": \"email_count\",\n                \"label\": \"邮件个数\",\n                \"type_value\": \"email\"\n            }, {\n                \"value\": \"email_subject_count\",\n                \"label\": \"邮件TOP个数\",\n                \"type_value\": \"email\"\n            }, {\n                \"value\": \"list_count\",\n                \"label\": \"邮件列表个数\",\n                \"type_value\": \"email\"\n            }, {\n                \"value\": \"subscribe_count\",\n                \"label\": \"订阅人数\",\n                \"type_value\": \"email\"\n            }]\n        }\n    },\n    \"timestamp\": 1745546776273,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var community = community
HashMap res = new HashMap();
var sql = """ select DISTINCT type_name as label,type_value as value  from dict_service_metrics where community=#{community}  """
var ss = db.select(sql);
res.put("source",ss)
var optoinsql = """ select metric_value as value,metric_name as label,type_value  from dict_service_metrics where community=#{community} and metric_name is not null and metric_name !=''  """
var sd = db.select(optoinsql);
res.put("metric_dict",sd.group(item=>item.type_value));
return res;

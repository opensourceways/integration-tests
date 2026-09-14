{
  "properties" : { },
  "id" : "4d1fd3b3e5914d54bac464d92a52cf92",
  "script" : null,
  "groupId" : "521ef640123a4ae79386e6a38b8df4ad",
  "name" : "新增配置页面",
  "createTime" : null,
  "updateTime" : 1774670155438,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/page/config",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatadmin_View",
    "description" : "允许拥有datastatadmin_View权限的用户访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "requestBody" : "{\r\n    \"name\":\"test\",\r\n    \"page_json\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": \"test\",\n    \"timestamp\": 1767704728146,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import java.time.OffsetDateTime;
var  name = body.get("name");
var  page_json = body.get("page_json");
return db.table('fact_page_config').primary('name').save(
        {
        name: name,
        page_json: page_json
        },true
    );

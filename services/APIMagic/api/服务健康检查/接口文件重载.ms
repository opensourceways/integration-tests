{
  "properties" : { },
  "id" : "bf83211a5b384ca1b2674ab3dc44d5f1",
  "script" : null,
  "groupId" : "268543ec55cc4a40890f6229f0450ef9",
  "name" : "接口文件重载",
  "createTime" : null,
  "updateTime" : 1778648767395,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "reload",
  "method" : "GET",
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
  }, {
    "name" : "permission",
    "value" : "super_admin",
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
  "headers" : [ {
    "name" : "api-key",
    "value" : "",
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
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 403,\n    \"message\": \"用户没有权限\",\n    \"data\": null,\n    \"timestamp\": 1778643268491,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import org.ssssssss.magicapi.core.config.MagicConfiguration;
import response;


MagicConfiguration.getMagicResourceService().refresh();
return response.json({
    code: 200,
    message: 'Magic-API reload successfully!'
});

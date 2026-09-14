{
  "properties" : { },
  "id" : "98fd9ee6ef9c44278e7f770ee738d521",
  "script" : null,
  "groupId" : "002c23f975f9400cad36e8565f54be47",
  "name" : "未定义名称",
  "createTime" : null,
  "updateTime" : 1762414017754,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/query/thread",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ {
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"thread_id\": \"546323\",\n        \"name\": \"测试\",\n        \"updated_at\": \"2025-04-01\",\n        \"assistant_id\": \"admin\"\n    }],\n    \"timestamp\": 1743497913261,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sql = """select * from ai_thread""";
return db.select(sql);

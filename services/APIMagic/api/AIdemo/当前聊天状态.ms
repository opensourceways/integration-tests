{

  "properties" : { },

  "id" : "7ffe7d5d4a3442dd871c43e6ea85197f",

  "script" : null,

  "groupId" : "002c23f975f9400cad36e8565f54be47",

  "name" : "当前聊天状态",

  "createTime" : null,

  "updateTime" : 1773813888272,

  "lock" : null,

  "createBy" : null,

  "updateBy" : "admin",

  "path" : "/threads/{id}/state",

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

  "paths" : [ {

    "name" : "id",

    "value" : "546323",

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

  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1743499226280,\n    \"executeTime\": 7\n}",

  "description" : null,

  "requestBodyDefinition" : null,

  "responseBodyDefinition" : null

}

================================
var id = id;
return db.select("select * from ai_message where id=#{id}");

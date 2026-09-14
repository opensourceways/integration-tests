{
  "properties" : { },
  "id" : "955644f97a2d4e42a0b344908614d6e4",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "筛选条件",
  "createTime" : null,
  "updateTime" : 1758020499089,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/filter",
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
  "requestBody" : "{\r\n    \"community\":\"unifiedbus\",\r\n    \"tab\": \"company\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"source\": \"email\",\n        \"company\": \"其他公司\",\n        \"internal\": \"外部\"\n    }, {\n        \"source\": \"email\",\n        \"company\": \"华为技术有限公司\",\n        \"internal\": \"内部\"\n    }, {\n        \"source\": \"email\",\n        \"company\": \"华为合作方\",\n        \"internal\": \"内部\"\n    }, {\n        \"source\": \"email\",\n        \"company\": \"XPG科技有限公司\",\n        \"internal\": \"外部\"\n    }],\n    \"timestamp\": 1757986781986,\n    \"executeTime\": 3\n}",
  "description" : null,
  "requestBodyDefinition" : {
    "name" : "root",
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
      "value" : "openeuler",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "tab",
      "value" : "user",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "tab 只能为 user、company、repo 或 sig",
      "expression" : "^(user|company|repo|sig)?$",
      "children" : [ ]
    } ]
  },
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
      "value" : "1",
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
      "value" : "success",
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
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
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
          "name" : "source",
          "value" : "gitee",
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
          "name" : "namespace",
          "value" : "openeuler",
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
          "name" : "internal",
          "value" : "内部",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1744620703344",
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
      "value" : "30",
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
// 社区
var community = body.community.toLowerCase();
// 看板页签：开发者-user，组织分析-company，sig分析-sig，仓库分析-repo
var tab = body.tab;
// 用户
var userTable = "dwm_"+community+"_contribute_user";
// 组织
var companyTable = "dws_"+community+"_contribute_company_daily";
// sig
var sigTable = "dws_"+community+"_contribute_sig_daily";
// 仓库
var repoTable = "dws_"+community+"_contribute_repo_daily";
var queryTable = userTable;
if (tab == 'company'){
    queryTable = companyTable;
} else if (tab == 'sig'){
    queryTable = sigTable;
} else if (tab == 'repo'){
    queryTable = repoTable;
}
var sql = """
select 
    distinct source, namespace, internal, private
from ${queryTable}
""";
if ("unifiedbus" == community){
    if (tab = "regist"){
        queryTable = "dws_unifiedbus_account_day"
        sql = """
            select 
                null as source, null as company, null as internal
            from ${queryTable}
        """
    } else if (tab == "company"){
        queryTable = "dwm_unifiedbus_domain_company"
        sql = """
            select 
                null as source, null as internal
            from ${queryTable}
        """
    }
}
return db.select(sql);

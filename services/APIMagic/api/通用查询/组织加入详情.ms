{
  "properties" : { },
  "id" : "cd0378e3912c4ad095af4b79f2b7cc07",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "组织加入详情",
  "createTime" : null,
  "updateTime" : 1757904470681,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/company/join",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"community\": \"unifiedbus\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"source\": \"kpn\",\n        \"company\": \"华为合作方\",\n        \"is_join\": \"t\"\n    }, {\n        \"source\": \"apn\",\n        \"company\": \"华为合作方\",\n        \"is_join\": \"t\"\n    }, {\n        \"source\": \"kpn\",\n        \"company\": \"华为技术有限公司\",\n        \"is_join\": \"t\"\n    }, {\n        \"source\": \"apn\",\n        \"company\": \"华为技术有限公司\",\n        \"is_join\": \"t\"\n    }],\n    \"timestamp\": 1757904468153,\n    \"executeTime\": 3\n}",
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
      "value" : "unifiedbus",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}

================================
// 社区
var community = body.community;
var company_table = 'dwm_'+community+'_expect_company';
var query_sql = """
  select 
    source, company, is_join
  from ${company_table}
"""
return db.select(query_sql)

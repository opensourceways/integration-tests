{
  "properties" : { },
  "id" : "trp_list",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "项目列表",
  "createTime" : null,
  "updateTime" : 1777424935204,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/tech-radar/list",
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 3,\n        \"list\": [{\n            \"id\": 3,\n            \"name\": \"test/bas\",\n            \"url\": \"https://github.com/test/bas\",\n            \"pypi_url\": \"https://pypi.org/dfsd\",\n            \"type\": \"accelerate\",\n            \"status\": \"未上线\",\n            \"creator\": \"zhongjun\",\n            \"created_at\": \"2026-04-28 07:29\",\n            \"issue_url\": \"https://github.com/opensourceways/datastat-manage-website/issues/289\",\n            \"issue_state\": \"open\",\n            \"platform\": \"github\"\n        }, {\n            \"id\": 2,\n            \"name\": \"opensourceways/datastat-manage-website\",\n            \"url\": \"https://github.com/opensourceways/datastat-manage-website\",\n            \"pypi_url\": \"\",\n            \"type\": \"AIAgent\",\n            \"status\": \"未上线\",\n            \"creator\": \"zhongjun\",\n            \"created_at\": \"2026-04-27 11:30\",\n            \"issue_url\": \"https://github.com/opensourceways/datastat-manage-website/issues/288\",\n            \"issue_state\": \"open\",\n            \"platform\": \"github\"\n        }, {\n            \"id\": 1,\n            \"name\": \"ByteDance-Seed/VeOmni\",\n            \"url\": \"https://github.com/ByteDance-Seed/VeOmni\",\n            \"pypi_url\": \"https://pypi.org/project/veomni\",\n            \"type\": \"RL\",\n            \"status\": \"未上线\",\n            \"creator\": \"yikun\",\n            \"created_at\": \"2026-04-27 11:05\",\n            \"issue_url\": \"https://github.com/opensourceways/datastat-manage-website/issues/287\",\n            \"issue_state\": \"open\",\n            \"platform\": \"github\"\n        }]\n    },\n    \"timestamp\": 1777424887860,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var list = db.select("""SELECT id,name,url,pypi_url,type,status,creator,to_char(created_at,'YYYY-MM-DD HH24:MI') AS created_at, issue_url, issue_state, platform FROM fact_insight_tech_radar_project ORDER BY created_at DESC""");
return {total:list.size(),list:list};
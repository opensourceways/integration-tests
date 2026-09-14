{
  "properties" : { },
  "id" : "b445ac23d0994e13aea262b497d05cce",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "仓库列表",
  "createTime" : null,
  "updateTime" : 1777360565806,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repolist",
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
  "requestBody" : "{\r\n    \"community\":\"mindcluster\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"repo_path\": \"灵衢规范（ub-spec@lists.unifiedbus.com）\",\n        \"value\": \"ub-spec@lists.unifiedbus.com\",\n        \"html_url\": \"https://mailweb.unifiedbus.com/archives/list/ub-spec@lists.unifiedbus.com/\"\n    }, {\n        \"repo_path\": \"超节点参考架构（superpod-ref@lists.unifiedbus.com）\",\n        \"value\": \"superpod-ref@lists.unifiedbus.com\",\n        \"html_url\": \"https://mailweb.unifiedbus.com/archives/list/superpod-ref@lists.unifiedbus.com/\"\n    }, {\n        \"repo_path\": \"灵衢综合讨论（ub-discuss@lists.unifiedbus.com）\",\n        \"value\": \"ub-discuss@lists.unifiedbus.com\",\n        \"html_url\": \"https://mailweb.unifiedbus.com/archives/list/ub-discuss@lists.unifiedbus.com/\"\n    }],\n    \"timestamp\": 1758785354943,\n    \"executeTime\": 3\n}",
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
      "value" : "",
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
var community = body.community.toLowerCase();
if ("unifiedbus" == community){
   var query_sql = """
        select  '灵衢规范（ub-spec@lists.unifiedbus.com）' as repo_path, 'ub-spec@lists.unifiedbus.com' as value, 'https://mailweb.unifiedbus.com/archives/list/ub-spec@lists.unifiedbus.com/' as html_url
        union all
        select  '超节点参考架构（superpod-ref@lists.unifiedbus.com）' as repo_path, 'superpod-ref@lists.unifiedbus.com' as value, 'https://mailweb.unifiedbus.com/archives/list/superpod-ref@lists.unifiedbus.com/' as html_url
        union all
        select  '灵衢综合讨论（ub-discuss@lists.unifiedbus.com）' as repo_path, 'ub-discuss@lists.unifiedbus.com' as value, 'https://mailweb.unifiedbus.com/archives/list/ub-discuss@lists.unifiedbus.com/' as html_url
   """;
   return db.select(query_sql);
} else if ("hifloat" == community){
   var query_sql = """
        select  'HiFloat技术标准（hifloat-spec@lists.gccorg.com）' as repo_path, 'hifloat-spec@lists.gccorg.com' as value, 'https://mailweb.gccorg.com/archives/list/hifloat-spec@lists.gccorg.com/' as html_url
        union all
        select  '模型应用案例（model-practice@lists.gccorg.com）' as repo_path, 'model-practice@lists.gccorg.com' as value, 'https://mailweb.gccorg.com/archives/list/model-practice@lists.gccorg.com/' as html_url
   """;
   return db.select(query_sql);
}
var repoTable = "fact_"+community+"_repo";
var internal_sql = """
SELECT 
   concat(fr.namespace,'/',fr.repo_path) as repo_path, fr.repo_path as value, fr.html_url
FROM repository_configs rc 
LEFT JOIN ${repoTable} fr
on rc.repo_path = fr.repo_path and rc.namespace = fr.namespace
where rc.community = #{community} and rc.display_status = 'visible' and fr.is_hide is null
ORDER BY rc.rank;
""";
var internal_data = db.select(internal_sql);
return internal_data;

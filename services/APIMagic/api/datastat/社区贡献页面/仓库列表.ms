{
  "properties" : { },
  "id" : "1dee4af471654cd4a61cbdacaa70d1d4",
  "script" : null,
  "groupId" : "255c725fcfdc48e79d405687c1e61f10",
  "name" : "仓库列表",
  "createTime" : null,
  "updateTime" : 1774322759057,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "repo",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^[a-zA-Z]{1,32}$",
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"python-XStatic-Dagre\",\n        \"html_url\": \"https://gitcode.com/src-openeuler/python-XStatic-Dagre\"\n    }, {\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"python-libsass\",\n        \"html_url\": \"https://gitcode.com/src-openeuler/python-libsass\"\n    }, {\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"clang-15\",\n        \"html_url\": \"https://gitcode.com/src-openeuler/clang-15\"\n    }, {\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"metadata-extractor2\",\n        \"html_url\": \"https://gitcode.com/src-openeuler/metadata-extractor2\"\n    }, {\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"python-Flask-Principal\",\n        \"html_url\": \"https://gitcode.com/src-openeuler/python-Flask-Principal\"\n    }, {\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"rubygem-asciidoctor\",\n        \"html_url\": \"https://gitcode.com/src-openeuler/rubygem-asciidoctor\"\n    }, {\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"python-mdformat-tables\",\n        \"html_url\": \"https://gitcode.com/src-openeuler/python-mdformat-tables\"\n    }, {\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"python-pytest-ordering\",\n        \"html_url\": \"https://gitcode.com/src-openeuler/python-pytest-ordering\"\n    }, {\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"ks-scmc\",\n        \"html_url\": \"https://gitcode.com/openeuler/ks-scmc\"\n    }, {\n        \"isCoreRepo\": \"0\",\n        \"repo\": \"tini\",\n        \"html_url\": \"https://gitcode.com/src-openeuler/tini\"\n    }],\n    \"timestamp\": 1766980197855,\n    \"executeTime\": 11\n}",
  "description" : null,
  "requestBodyDefinition" : null,
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
          "name" : "isCoreRepo",
          "value" : "0",
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
          "name" : "repo",
          "value" : "ascend-faster-transformer",
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
      "value" : "1762850778819",
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
      "value" : "null",
      "description" : "",
      "required" : false,
      "dataType" : "Object",
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
const coreRepo = ['openGauss-server','CBB','DCF','DCC','DMS','openGauss-OM','CM','DSS']
community = community.toLowerCase()
var sqlstr = """
SELECT 
    repo_path as repo, html_url
FROM 
    fact_${community}_repo
WHERE 
    is_removed IS NULL AND is_hide IS NULL
GROUP BY 
    repo_path, html_url;
"""
var resp = db.select(sqlstr)
var ans = resp.map((item)=>{
    isCoreRepo : coreRepo.contains(item.repo) && community == 'opengauss' ? "1" : "0",
    repo : item.repo,
    html_url : item.html_url
})
ans = ans.sort((a, b) => b['isCoreRepo']::int - a['isCoreRepo']::int)
return ans

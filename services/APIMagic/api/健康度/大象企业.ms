{
  "properties" : { },
  "id" : "copy1745824708700d73548",
  "script" : null,
  "groupId" : "c8e7bc9573554a77aa14c0c646dabaae",
  "name" : "大象企业",
  "createTime" : null,
  "updateTime" : 1745907357023,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{community}/elephant_companies",
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
  "paths" : [ {
    "name" : "community",
    "value" : "opengauss",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"company\": \"个人贡献者\",\n        \"total\": 12650554\n    }, {\n        \"company\": \"软通动力信息技术（集团）股份有限公司\",\n        \"total\": 10178384\n    }, {\n        \"company\": \"华为\",\n        \"total\": 5524986\n    }, {\n        \"company\": \"北京海量数据技术股份有限公司\",\n        \"total\": 126068\n    }, {\n        \"company\": \"万宝盛华大中华有限公司\",\n        \"total\": 121247\n    }, {\n        \"company\": \"粤港澳大湾区（广东）国创中心\",\n        \"total\": 114340\n    }, {\n        \"company\": \"天津神舟通用数据技术有限公司\",\n        \"total\": 86160\n    }, {\n        \"company\": \"中移动信息技术有限公司\",\n        \"total\": 77268\n    }, {\n        \"company\": \"天津南大通用数据技术股份有限公司\",\n        \"total\": 65366\n    }, {\n        \"company\": \"易宝软件有限公司\",\n        \"total\": 42158\n    }, {\n        \"company\": \"中软国际科技服务有限公司\",\n        \"total\": 34177\n    }, {\n        \"company\": \"中国民生银行\",\n        \"total\": 31593\n    }, {\n        \"company\": \"云和恩墨（北京）信息技术有限公司\",\n        \"total\": 25484\n    }, {\n        \"company\": \"中国科学院软件研究所\",\n        \"total\": 9397\n    }, {\n        \"company\": \"北京超图软件股份有限公司\",\n        \"total\": 6394\n    }, {\n        \"company\": \"浪潮云信息技术股份公司\",\n        \"total\": 4398\n    }, {\n        \"company\": \"广发期货有限公司\",\n        \"total\": 146\n    }, {\n        \"company\": \"联通数字科技有限公司\",\n        \"total\": 44\n    }],\n    \"timestamp\": 1745907165558,\n    \"executeTime\": 80\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var sqlstr = """
SELECT company,  (SUM(add) + SUM(remove)) AS total
FROM dws_${community}_contribute
WHERE contrib_type = 'pr' AND state = 'merged' AND company <> 'robot' 
        AND created_at >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY company
ORDER BY total DESC;
"""
var result = db.select(sqlstr)
return result

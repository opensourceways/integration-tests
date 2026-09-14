{
  "properties" : { },
  "id" : "copy1767698523743d35340",
  "script" : null,
  "groupId" : "1cc0849322d74468ab73c9ad0f14fc02",
  "name" : "SIG仓库的committer信息",
  "createTime" : null,
  "updateTime" : 1775550471990,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/new/repo/committers",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openubmc",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "sig",
    "value" : "infrastructure",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "sig 格式非法",
    "expression" : "^[a-zA-Z0-9\\s_/-]+$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"repo\": \"openUBMC/infrastructure\",\n        \"committers\": [{\n            \"gitcode_id\": \"weixin_43493709\",\n            \"name\": \"朱超\"\n        }, {\n            \"gitcode_id\": \"persimmonzzz\",\n            \"name\": \"黄世俊\"\n        }, {\n            \"gitcode_id\": \"LiYanghang00\",\n            \"name\": \"李洋行\"\n        }, {\n            \"gitcode_id\": \"ddll1234\",\n            \"name\": \"野岱琳\"\n        }],\n        \"maintainers\": [{\n            \"gitcode_id\": \"georgecao\",\n            \"name\": \"曹志\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zengchen1024\",\n            \"name\": \"陈曾\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zhongjun2\",\n            \"name\": \"钟君\",\n            \"role\": \"maintainer\"\n        }]\n    }, {\n        \"repo\": \"openUBMC/openubmc-ci\",\n        \"committers\": [{\n            \"gitcode_id\": \"weixin_43493709\",\n            \"name\": \"朱超\"\n        }, {\n            \"gitcode_id\": \"persimmonzzz\",\n            \"name\": \"黄世俊\"\n        }, {\n            \"gitcode_id\": \"LiYanghang00\",\n            \"name\": \"李洋行\"\n        }, {\n            \"gitcode_id\": \"ddll1234\",\n            \"name\": \"野岱琳\"\n        }],\n        \"maintainers\": [{\n            \"gitcode_id\": \"georgecao\",\n            \"name\": \"曹志\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zengchen1024\",\n            \"name\": \"陈曾\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zhongjun2\",\n            \"name\": \"钟君\",\n            \"role\": \"maintainer\"\n        }]\n    }, {\n        \"repo\": \"openUBMC/website\",\n        \"committers\": [{\n            \"gitcode_id\": \"weixin_43493709\",\n            \"name\": \"朱超\"\n        }, {\n            \"gitcode_id\": \"persimmonzzz\",\n            \"name\": \"黄世俊\"\n        }, {\n            \"gitcode_id\": \"LiYanghang00\",\n            \"name\": \"李洋行\"\n        }, {\n            \"gitcode_id\": \"ddll1234\",\n            \"name\": \"野岱琳\"\n        }],\n        \"maintainers\": [{\n            \"gitcode_id\": \"georgecao\",\n            \"name\": \"曹志\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zengchen1024\",\n            \"name\": \"陈曾\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zhongjun2\",\n            \"name\": \"钟君\",\n            \"role\": \"maintainer\"\n        }]\n    }, {\n        \"repo\": \"openUBMC/website-backend\",\n        \"committers\": [{\n            \"gitcode_id\": \"weixin_43493709\",\n            \"name\": \"朱超\"\n        }, {\n            \"gitcode_id\": \"persimmonzzz\",\n            \"name\": \"黄世俊\"\n        }, {\n            \"gitcode_id\": \"LiYanghang00\",\n            \"name\": \"李洋行\"\n        }, {\n            \"gitcode_id\": \"ddll1234\",\n            \"name\": \"野岱琳\"\n        }],\n        \"maintainers\": [{\n            \"gitcode_id\": \"georgecao\",\n            \"name\": \"曹志\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zengchen1024\",\n            \"name\": \"陈曾\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zhongjun2\",\n            \"name\": \"钟君\",\n            \"role\": \"maintainer\"\n        }]\n    }, {\n        \"repo\": \"openUBMC/nginx\",\n        \"committers\": [{\n            \"gitcode_id\": \"weixin_43493709\",\n            \"name\": \"朱超\"\n        }, {\n            \"gitcode_id\": \"persimmonzzz\",\n            \"name\": \"黄世俊\"\n        }, {\n            \"gitcode_id\": \"LiYanghang00\",\n            \"name\": \"李洋行\"\n        }, {\n            \"gitcode_id\": \"ddll1234\",\n            \"name\": \"野岱琳\"\n        }],\n        \"maintainers\": [{\n            \"gitcode_id\": \"georgecao\",\n            \"name\": \"曹志\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zengchen1024\",\n            \"name\": \"陈曾\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zhongjun2\",\n            \"name\": \"钟君\",\n            \"role\": \"maintainer\"\n        }]\n    }, {\n        \"repo\": \"openUBMC/conan-auth-proxy\",\n        \"committers\": [{\n            \"gitcode_id\": \"weixin_43493709\",\n            \"name\": \"朱超\"\n        }, {\n            \"gitcode_id\": \"persimmonzzz\",\n            \"name\": \"黄世俊\"\n        }, {\n            \"gitcode_id\": \"LiYanghang00\",\n            \"name\": \"李洋行\"\n        }, {\n            \"gitcode_id\": \"ddll1234\",\n            \"name\": \"野岱琳\"\n        }],\n        \"maintainers\": [{\n            \"gitcode_id\": \"georgecao\",\n            \"name\": \"曹志\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zengchen1024\",\n            \"name\": \"陈曾\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zhongjun2\",\n            \"name\": \"钟君\",\n            \"role\": \"maintainer\"\n        }]\n    }, {\n        \"repo\": \"openUBMC/software-center\",\n        \"committers\": [{\n            \"gitcode_id\": \"weixin_43493709\",\n            \"name\": \"朱超\"\n        }, {\n            \"gitcode_id\": \"persimmonzzz\",\n            \"name\": \"黄世俊\"\n        }, {\n            \"gitcode_id\": \"LiYanghang00\",\n            \"name\": \"李洋行\"\n        }, {\n            \"gitcode_id\": \"ddll1234\",\n            \"name\": \"野岱琳\"\n        }],\n        \"maintainers\": [{\n            \"gitcode_id\": \"georgecao\",\n            \"name\": \"曹志\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zengchen1024\",\n            \"name\": \"陈曾\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zhongjun2\",\n            \"name\": \"钟君\",\n            \"role\": \"maintainer\"\n        }]\n    }, {\n        \"repo\": \"openUBMC/software-center-importer\",\n        \"committers\": [{\n            \"gitcode_id\": \"weixin_43493709\",\n            \"name\": \"朱超\"\n        }, {\n            \"gitcode_id\": \"persimmonzzz\",\n            \"name\": \"黄世俊\"\n        }, {\n            \"gitcode_id\": \"LiYanghang00\",\n            \"name\": \"李洋行\"\n        }, {\n            \"gitcode_id\": \"ddll1234\",\n            \"name\": \"野岱琳\"\n        }],\n        \"maintainers\": [{\n            \"gitcode_id\": \"georgecao\",\n            \"name\": \"曹志\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zengchen1024\",\n            \"name\": \"陈曾\",\n            \"role\": \"maintainer\"\n        }, {\n            \"gitcode_id\": \"zhongjun2\",\n            \"name\": \"钟君\",\n            \"role\": \"maintainer\"\n        }]\n    }],\n    \"timestamp\": 1775550370723,\n    \"executeTime\": 3\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sql_role = """
SELECT 
    *
FROM 
    fact_${community}_sig_detail_info
WHERE
     sig_name = #{sig} 
"""
var repos = db.select(sql_role)
var ans = []
for (r in repos) {
    var sig_info = r['sig_json']::json
    var maintainers = sig_info.getOrDefault('maintainers',new ArrayList())
    if (sig_info.containsKey('repositories')) {
        for (key in sig_info.get('repositories')) {
            var repotemps = key.getOrDefault('repo',new ArrayList());
            var committers =  key.getOrDefault('committers',new ArrayList());
            for (onerepo in repotemps) {
                var repomap = {};
                repomap.put("repo",onerepo);
                repomap.put("committers",committers)
                repomap.put("maintainers",maintainers)
                ans.add(repomap)
            }
        }
    }
}
return ans 

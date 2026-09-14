{
  "properties" : { },
  "id" : "7b698439e72b47819e23ffafcad26193",
  "script" : null,
  "groupId" : "1cc0849322d74468ab73c9ad0f14fc02",
  "name" : "SIG的组织成员信息",
  "createTime" : null,
  "updateTime" : 1775783277560,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/role/list",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
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
    "value" : "Infrastructure",
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
  }, {
    "name" : "permission",
    "value" : "mcp",
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
    "name" : "api-token",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"role\": \"committer\",\n        \"users\": [{\n            \"email\": \"ctyuncommiter05@chinatelecom.cn\",\n            \"user_name\": \"ctyunsystem\",\n            \"user_login\": \"ctyunsystem\",\n            \"organization\": null\n        }, {\n            \"email\": \"469227928@qq.com\",\n            \"user_name\": \"Se7en\",\n            \"user_login\": \"liuqi469227928\",\n            \"organization\": null\n        }, {\n            \"email\": \"wjunlu217@gmail.com\",\n            \"user_name\": \"luweijun\",\n            \"user_login\": \"lu-wei-army\",\n            \"organization\": null\n        }, {\n            \"email\": \"pkwarcraft@hotmail.com\",\n            \"user_name\": \"lichaoran\",\n            \"user_login\": \"mywaaagh_admin\",\n            \"organization\": null\n        }, {\n            \"email\": \"tommylikehu@gmail.com\",\n            \"user_name\": \"TommyLike\",\n            \"user_login\": \"TommyLike\",\n            \"organization\": null\n        }, {\n            \"email\": \"tom_toworld@163.com\",\n            \"user_name\": \"Tom\",\n            \"user_login\": \"weixin_43493709\",\n            \"organization\": null\n        }, {\n            \"email\": \"owen813@126.com\",\n            \"user_name\": \"wenhao7\",\n            \"user_login\": \"wenhao7\",\n            \"organization\": null\n        }, {\n            \"email\": \"wuksh@chinatelecom.cn\",\n            \"user_name\": \"wukaishuns\",\n            \"user_login\": \"wuzimo\",\n            \"organization\": null\n        }, {\n            \"email\": \"youyf2@chinatelecom.cn\",\n            \"user_name\": \"youyifeng\",\n            \"user_login\": \"youyifeng\",\n            \"organization\": null\n        }, {\n            \"email\": \"zheng.zhenyu@outlook.com\",\n            \"user_name\": \"Zheng Zhenyu\",\n            \"user_login\": \"ZhengZhenyu\",\n            \"organization\": null\n        }, {\n            \"email\": \"zhouyi198@h-partners.com\",\n            \"user_name\": \"Yi Zhou\",\n            \"user_login\": \"Zherphy\",\n            \"organization\": \"Huawei\"\n        }, {\n            \"email\": \"zhaiwenjiesec@163.com\",\n            \"user_name\": \"zhaiwenjie\",\n            \"user_login\": \"zwjsec\",\n            \"organization\": null\n        }]\n    }, {\n        \"role\": \"maintainer\",\n        \"users\": [{\n            \"email\": \"eli@patch.sh\",\n            \"user_name\": \"Maquanyi\",\n            \"user_login\": \"genedna\",\n            \"organization\": null\n        }, {\n            \"email\": \"caozhi1214@qq.com\",\n            \"user_name\": \"George.Cao\",\n            \"user_login\": \"georgecao\",\n            \"organization\": \"Huawei\"\n        }, {\n            \"email\": \"majunjie@apache.org\",\n            \"user_name\": \"imjoey\",\n            \"user_login\": \"imjoey1\",\n            \"organization\": null\n        }, {\n            \"email\": \"tommylikehu@gmail.com\",\n            \"user_name\": \"TommyLike\",\n            \"user_login\": \"TommyLike\",\n            \"organization\": null\n        }, {\n            \"email\": \"yikunkero@gmail.com\",\n            \"user_name\": \"Yikun Jiang\",\n            \"user_login\": \"yikunkero\",\n            \"organization\": null\n        }, {\n            \"email\": \"526521735@qq.com\",\n            \"user_name\": \"zhongjun2\",\n            \"user_login\": \"zhongjun2\",\n            \"organization\": null\n        }, {\n            \"email\": \"zhuchunyi@huawei.com\",\n            \"user_name\": \"Trainey\",\n            \"user_login\": \"zhuchunyi\",\n            \"organization\": null\n        }]\n    }],\n    \"timestamp\": 1775635648937,\n    \"executeTime\": 17\n}",
  "description" : "获取社区某个SIG的所有组织成员信息（属于社区组织架构成员的一部分）",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sql_role = """
SELECT 
    role,
    jsonb_agg(
        jsonb_build_object(
            'user_login', user_login,
            'user_name', user_name,
            'email', email,
            'organization', organization
        )
    ) AS users
FROM (
    SELECT DISTINCT ON (role, user_login) 
        role, user_login, user_name, email, organization
    FROM fact_${community}_sig_user
    WHERE sig_name = #{sig}
      AND is_removed IS NULL
    ORDER BY role, user_login
) AS distinct_users
GROUP BY role;
"""
var resp = db.select(sql_role)
var ans = []
for (r in resp) {
    var item = {}
    item['role'] = r.role
    item['users'] = r.users == null ? null : r.users.value::json
    ans.add(item)
}
return ans 

{
  "properties" : { },
  "id" : "2429f1e1eb20475d9d7f714ba2cc5215",
  "script" : null,
  "groupId" : "255c725fcfdc48e79d405687c1e61f10",
  "name" : "个人贡献排名",
  "createTime" : null,
  "updateTime" : 1769390728258,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/user/contribute",
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
    "expression" : "^(openeuler|opengauss|mindspore|openubmc|openfuyao)$",
    "children" : null
  }, {
    "name" : "repo",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "repo 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "contributeType",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "contributeType 参数非法",
    "expression" : "^(pr|issue|comment)$",
    "children" : null
  }, {
    "name" : "timeRange",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "timeRange 参数非法",
    "expression" : "^(all|lastonemonth|lasthalfyear|lastoneyear)?$",
    "children" : null
  }, {
    "name" : "comment_type",
    "value" : "",
    "description" : "评论类型，command：命令评论，normal：正常评论，不传参数：所有评论",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "comment_type 参数非法",
    "expression" : "^(command|normal)?$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"user_login\": \"leccg\",\n        \"contribute\": 344\n    }, {\n        \"user_login\": \"chr2301137125\",\n        \"contribute\": 339\n    }, {\n        \"user_login\": \"yuexudong\",\n        \"contribute\": 325\n    }, {\n        \"user_login\": \"gongnan\",\n        \"contribute\": 283\n    }, {\n        \"user_login\": \"fundawang\",\n        \"contribute\": 282\n    }, {\n        \"user_login\": \"free_stor\",\n        \"contribute\": 209\n    }, {\n        \"user_login\": \"lamerpoet\",\n        \"contribute\": 117\n    }, {\n        \"user_login\": \"smileQiny\",\n        \"contribute\": 115\n    }, {\n        \"user_login\": \"lkylky521\",\n        \"contribute\": 114\n    }, {\n        \"user_login\": \"houhaoleyewu\",\n        \"contribute\": 94\n    }, {\n        \"user_login\": \"w-xxxx\",\n        \"contribute\": 83\n    }, {\n        \"user_login\": \"starlet-dx\",\n        \"contribute\": 63\n    }, {\n        \"user_login\": \"AC-0308\",\n        \"contribute\": 60\n    }, {\n        \"user_login\": \"gao-wenyao123\",\n        \"contribute\": 59\n    }, {\n        \"user_login\": \"yyyaaa222\",\n        \"contribute\": 52\n    }, {\n        \"user_login\": \"zhaohongrui3\",\n        \"contribute\": 50\n    }, {\n        \"user_login\": \"Zerry\",\n        \"contribute\": 49\n    }, {\n        \"user_login\": \"hongyu-shi\",\n        \"contribute\": 49\n    }, {\n        \"user_login\": \"yinhao166\",\n        \"contribute\": 49\n    }, {\n        \"user_login\": \"yaohaolin\",\n        \"contribute\": 46\n    }, {\n        \"user_login\": \"liumin6\",\n        \"contribute\": 44\n    }, {\n        \"user_login\": \"empire99200\",\n        \"contribute\": 44\n    }, {\n        \"user_login\": \"wangtsingx\",\n        \"contribute\": 43\n    }, {\n        \"user_login\": \"gaob-kylinsec\",\n        \"contribute\": 39\n    }, {\n        \"user_login\": \"zhangwenlong01\",\n        \"contribute\": 38\n    }, {\n        \"user_login\": \"dingjiahuichina\",\n        \"contribute\": 36\n    }, {\n        \"user_login\": \"lauk0011\",\n        \"contribute\": 33\n    }, {\n        \"user_login\": \"cx22757\",\n        \"contribute\": 32\n    }, {\n        \"user_login\": \"lei-eleven\",\n        \"contribute\": 32\n    }, {\n        \"user_login\": \"kylin-kevin\",\n        \"contribute\": 31\n    }, {\n        \"user_login\": \"jxy_git\",\n        \"contribute\": 31\n    }, {\n        \"user_login\": \"nperl-li\",\n        \"contribute\": 30\n    }, {\n        \"user_login\": \"eaglegai\",\n        \"contribute\": 30\n    }, {\n        \"user_login\": \"jianli-97\",\n        \"contribute\": 30\n    }, {\n        \"user_login\": \"chemengyue\",\n        \"contribute\": 28\n    }, {\n        \"user_login\": \"fandeyuan\",\n        \"contribute\": 28\n    }, {\n        \"user_login\": \"yixiangzhike1\",\n        \"contribute\": 27\n    }, {\n        \"user_login\": \"f16lx\",\n        \"contribute\": 27\n    }, {\n        \"user_login\": \"chukaiping\",\n        \"contribute\": 27\n    }, {\n        \"user_login\": \"openeulerbot\",\n        \"contribute\": 26\n    }, {\n        \"user_login\": \"zhu-zhihao994\",\n        \"contribute\": 26\n    }, {\n        \"user_login\": \"lujunwang\",\n        \"contribute\": 25\n    }, {\n        \"user_login\": \"huang-donghua-warehouse_admin\",\n        \"contribute\": 25\n    }, {\n        \"user_login\": \"liguang-li\",\n        \"contribute\": 25\n    }, {\n        \"user_login\": \"linjianquan\",\n        \"contribute\": 25\n    }, {\n        \"user_login\": \"mangosteen728\",\n        \"contribute\": 24\n    }, {\n        \"user_login\": \"jade_t\",\n        \"contribute\": 24\n    }, {\n        \"user_login\": \"roygiteee\",\n        \"contribute\": 24\n    }, {\n        \"user_login\": \"devin-cwd\",\n        \"contribute\": 24\n    }, {\n        \"user_login\": \"mayuehit\",\n        \"contribute\": 24\n    }],\n    \"timestamp\": 1766980243462,\n    \"executeTime\": 62\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
contributeType = contributeType.toLowerCase()
if (contributeType == 'comment') {
    sum_field = comment_type == 'normal' ? `valid_comment_count_${timeRange}` : comment_type == 'command' ? `comment_count_${timeRange} - valid_comment_count_${timeRange}` : `comment_count_${timeRange}`
}
else {
    sum_field = contributeType == 'pr' ? `merged_pr_count_${timeRange}` : `${contributeType}_count_${timeRange}`
}
var coreRepo = ['openGauss-server','CBB','DCF','DCC','DMS','openGauss-OM','CM','DSS']
var sqlstr = """
SELECT 
    user_login,
    sum(${sum_field}) as contribute
FROM 
    ads_${community}_repo_user_stat dccru
WHERE
     company <> 'robot'
        <if test="community == 'opengauss'">
            AND repo_path <> 'practice-course'
        </if>
        <if test="repo == 'coreRepo' and coreRepo.size() > 0">
            AND repo_path IN
            <foreach collection="coreRepo" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <elseif test="repo != null and repo != ''">
            AND repo_path = #{repo}
        </elseif>
GROUP BY 
    user_login
HAVING sum(${sum_field}) > 0
ORDER BY 
    contribute DESC
LIMIT 500;"""
var resp = db.select(sqlstr)
return resp 

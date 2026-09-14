{
  "properties" : { },
  "id" : "d759fc9083864b96a9adc8b6a4a88ba0",
  "script" : null,
  "groupId" : "bb5eadd619a64e1b8c7a29f0108c78c0",
  "name" : "个人贡献排名",
  "createTime" : null,
  "updateTime" : 1776759121463,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/user/contribute",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "cannopen",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "repo",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : "",
    "children" : null
  }, {
    "name" : "contributeType",
    "value" : "pr",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(pr|issue|comment)$",
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
    "error" : null,
    "expression" : "^(command|normal)$",
    "children" : null
  }, {
    "name" : "start",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"user_login\": \"xiaoxinglxs\",\n        \"contribute\": 117\n    }, {\n        \"user_login\": \"zjp99\",\n        \"contribute\": 106\n    }, {\n        \"user_login\": \"yelmh\",\n        \"contribute\": 76\n    }, {\n        \"user_login\": \"mao_0v0\",\n        \"contribute\": 68\n    }, {\n        \"user_login\": \"gitCodeZJ\",\n        \"contribute\": 63\n    }, {\n        \"user_login\": \"weixin_43493709\",\n        \"contribute\": 56\n    }, {\n        \"user_login\": \"hxmygcs\",\n        \"contribute\": 56\n    }, {\n        \"user_login\": \"lz9811\",\n        \"contribute\": 55\n    }, {\n        \"user_login\": \"zck19950826\",\n        \"contribute\": 53\n    }, {\n        \"user_login\": \"wangzhuwei1\",\n        \"contribute\": 52\n    }, {\n        \"user_login\": \"Live_link\",\n        \"contribute\": 50\n    }, {\n        \"user_login\": \"xyzheng1122\",\n        \"contribute\": 49\n    }, {\n        \"user_login\": \"Damon_cc\",\n        \"contribute\": 49\n    }, {\n        \"user_login\": \"linmei_123\",\n        \"contribute\": 46\n    }, {\n        \"user_login\": \"nightzmare\",\n        \"contribute\": 45\n    }, {\n        \"user_login\": \"Tao_A\",\n        \"contribute\": 44\n    }, {\n        \"user_login\": \"dyy-1\",\n        \"contribute\": 44\n    }, {\n        \"user_login\": \"Larry_Li_006\",\n        \"contribute\": 44\n    }, {\n        \"user_login\": \"zybwh\",\n        \"contribute\": 43\n    }, {\n        \"user_login\": \"mkdlf\",\n        \"contribute\": 42\n    }, {\n        \"user_login\": \"Seraphina_W\",\n        \"contribute\": 42\n    }, {\n        \"user_login\": \"Je_Li\",\n        \"contribute\": 42\n    }, {\n        \"user_login\": \"Cisy123\",\n        \"contribute\": 41\n    }, {\n        \"user_login\": \"qwerty0157\",\n        \"contribute\": 39\n    }, {\n        \"user_login\": \"wwhh_wwhh\",\n        \"contribute\": 39\n    }, {\n        \"user_login\": \"fangyufan\",\n        \"contribute\": 37\n    }, {\n        \"user_login\": \"xieqi29\",\n        \"contribute\": 37\n    }, {\n        \"user_login\": \"yaoshun1\",\n        \"contribute\": 37\n    }, {\n        \"user_login\": \"spjisgood\",\n        \"contribute\": 36\n    }, {\n        \"user_login\": \"leessential\",\n        \"contribute\": 35\n    }, {\n        \"user_login\": \"weixin_38513309\",\n        \"contribute\": 35\n    }, {\n        \"user_login\": \"HT12138\",\n        \"contribute\": 35\n    }, {\n        \"user_login\": \"nobug_nolife\",\n        \"contribute\": 35\n    }, {\n        \"user_login\": \"yzhang412\",\n        \"contribute\": 33\n    }, {\n        \"user_login\": \"fumingquan\",\n        \"contribute\": 33\n    }, {\n        \"user_login\": \"xuhaijun\",\n        \"contribute\": 33\n    }, {\n        \"user_login\": \"dli_bmc\",\n        \"contribute\": 32\n    }, {\n        \"user_login\": \"iss_yaoshizhe\",\n        \"contribute\": 32\n    }, {\n        \"user_login\": \"changxingOpenUBMC\",\n        \"contribute\": 32\n    }, {\n        \"user_login\": \"qq_32768419\",\n        \"contribute\": 30\n    }, {\n        \"user_login\": \"WillisWang\",\n        \"contribute\": 30\n    }, {\n        \"user_login\": \"hzy1010\",\n        \"contribute\": 29\n    }, {\n        \"user_login\": \"tangjingman\",\n        \"contribute\": 28\n    }, {\n        \"user_login\": \"gerardJay\",\n        \"contribute\": 28\n    }, {\n        \"user_login\": \"owenqiu\",\n        \"contribute\": 28\n    }, {\n        \"user_login\": \"xushuo25\",\n        \"contribute\": 27\n    }, {\n        \"user_login\": \"zn17\",\n        \"contribute\": 27\n    }, {\n        \"user_login\": \"linyao01\",\n        \"contribute\": 27\n    }, {\n        \"user_login\": \"PLUS_ONE\",\n        \"contribute\": 26\n    }, {\n        \"user_login\": \"pengqiang-gs\",\n        \"contribute\": 23\n    }],\n    \"timestamp\": 1758272008954,\n    \"executeTime\": 51\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
contributeType = contributeType.toLowerCase()
if (contributeType == 'comment') {
    sum_field = comment_type == 'normal' ? `valid_comment_incre` : comment_type == 'command' ? `comment_incre - valid_comment_incre` : `comment_incre`
}
else {
    sum_field = contributeType == 'pr' ? `merged_pr_incre` : `${contributeType}_incre`
}
var coreRepo = ['openGauss-server','CBB','DCF','DCC','DMS','openGauss-OM','CM','DSS']
var sqlstr = """
SELECT 
    user_login,
    sum(${sum_field}) as contribute
FROM 
    dws_${community}_contribute_repo_user_daily dccru
WHERE
     1 = 1
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
        <if test="start != null and start != ''">
            AND date >= to_timestamp(#{start}/1000)
        </if>
        <if test="end != null and end != ''">
            AND date <= to_timestamp(#{end}/1000)
        </if>
        <if test="community == 'openubmc'">
            AND private = 'false'
        </if>
        AND NOT EXISTS (SELECT 1 FROM fact_community_robot_user fcr WHERE fcr.user_login = dccru.user_login)
GROUP BY 
    user_login
HAVING sum(${sum_field}) > 0
ORDER BY 
    contribute DESC
LIMIT 100;"""
var resp = db.select(sqlstr)
return resp 

{
  "properties" : { },
  "id" : "bc0e4c982cd34a0ab1b092cd936cafce",
  "script" : null,
  "groupId" : "1cc0849322d74468ab73c9ad0f14fc02",
  "name" : "贡献者排名",
  "createTime" : null,
  "updateTime" : 1774578784083,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "topn/user/{contrib_type}",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"start\": 1706275200000,\r\n    \"end\": 1750905487588,\r\n    \"community\": \"cann\",\r\n    \"state\": \"\",\r\n    \"sig\": \"\",\r\n    \"topn\": 10\r\n}",
  "headers" : [ ],
  "paths" : [ {
    "name" : "contrib_type",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "contrib_type 参数非法",
    "expression" : "^(pr|issue|comment)$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"user_login\": \"wang-guangbin\",\n        \"html_url\": \"https://gitee.com/wang-guangbin\",\n        \"avatar_url\": \"https://foruda.gitee.com/avatar/1698418065848663693/12663114_wang-guangbin_1698418065.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 69\n    }, {\n        \"user_login\": \"zjks98\",\n        \"html_url\": \"https://gitee.com/zjks98\",\n        \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 64\n    }, {\n        \"user_login\": \"photoker\",\n        \"html_url\": \"https://gitee.com/photoker\",\n        \"avatar_url\": \"https://foruda.gitee.com/avatar/1693382313765017229/13185789_photoker_1693382313.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 55\n    }, {\n        \"user_login\": \"zhang-gaohua_admin\",\n        \"html_url\": \"https://gitee.com/zhang-gaohua_admin\",\n        \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 30\n    }, {\n        \"user_login\": \"wan-junwei4\",\n        \"html_url\": \"https://gitee.com/wan-junwei4\",\n        \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 29\n    }, {\n        \"user_login\": \"fuyangchenghu\",\n        \"html_url\": \"https://gitee.com/fuyangchenghu\",\n        \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 28\n    }, {\n        \"user_login\": \"guter_name\",\n        \"html_url\": \"https://gitee.com/guter_name\",\n        \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 27\n    }, {\n        \"user_login\": \"zhang-xun-asher\",\n        \"html_url\": \"https://gitee.com/zhang-xun-asher\",\n        \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 26\n    }, {\n        \"user_login\": \"yuantao_hw\",\n        \"html_url\": \"https://gitee.com/yuantao_hw\",\n        \"avatar_url\": \"https://foruda.gitee.com/avatar/1724695761916894042/14669328_yuantao_hw_1724695761.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 22\n    }, {\n        \"user_login\": \"acarpw\",\n        \"html_url\": \"https://gitee.com/acarpw\",\n        \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n        \"sig_name\": \"No-SIG\",\n        \"pr_count\": 21\n    }],\n    \"timestamp\": 1753079265584,\n    \"executeTime\": 83\n}",
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
      "name" : "start",
      "value" : "1746275200000",
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
      "name" : "end",
      "value" : "1750905487588",
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
      "name" : "community",
      "value" : "cann",
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
      "name" : "state",
      "value" : "merged",
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
      "name" : "sig",
      "value" : "",
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
      "name" : "topn",
      "value" : "10",
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
          "name" : "user_login",
          "value" : "y30044005",
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
          "name" : "html_url",
          "value" : "https://gitee.com/y30044005",
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
          "name" : "avatar_url",
          "value" : "https://gitee.com/assets/no_portrait.png",
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
          "name" : "sig_name",
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
            "value" : "No-SIG",
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
        }, {
          "name" : "pr_count",
          "value" : "47",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1752133353648",
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
      "value" : "2370",
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
var community = body.community.toLowerCase()
var internal = body.internal != null ? body.internal : "外部"
if (contrib_type == 'pr' and body.state == 'merged') {
    time_field = 'merged_at'
} else {
    time_field = 'created_at'
}
var internal_sql = """
    SELECT 
        ru.user_login,fu.html_url,fu.obs_avatar_url as avatar_url, unnest(ru.sig_name) as sig_name,
        count(1) as pr_count
    FROM dws_${community}_contribute ru
    LEFT JOIN fact_${community}_user fu on ru.user_login  = fu.user_login
    WHERE contrib_type = #{contrib_type}
        <if test="body.state != null and body.state != ''">
            AND state = #{body.state}
        </if>
        AND ru.company <> 'robot' 
        AND ru.private = 'false' 
        AND ru.user_login not like '%.del' 
        AND ru.is_removed is null 
        AND ru.is_hide is null
        AND ru.internal = #{internal}
        <if test="body.sig != null and body.sig != ''">
            AND #{body.sig} = ANY(ru.sig_name)
        </if>
        <if test="body.start != null and body.start != ''">
            AND ru.${time_field} >= to_timestamp(#{body.start}/1000)
        </if>
        <if test="body.end != null and body.end != ''">
            AND ru.${time_field} <= to_timestamp(#{body.end}/1000)
        </if>
    group by ru.user_login,fu.html_url,fu.obs_avatar_url,unnest(ru.sig_name)
    order by pr_count desc, ru.user_login asc
    limit #{body.topn} offset 0
"""
var internal_data = db.select(internal_sql);
return internal_data;

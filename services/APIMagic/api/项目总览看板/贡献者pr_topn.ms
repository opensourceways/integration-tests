{
  "properties" : { },
  "id" : "270848657d7845e09e0c767e330869d1",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "贡献者pr_topn",
  "createTime" : null,
  "updateTime" : 1773817990992,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/topn/user/pr",
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
  "requestBody" : "{\r\n    \"start\":1730390400000,\r\n    \"end\":1743177600000,\r\n    \"community\":\"mindspore\",\r\n    \"repo_path\":\"\",\r\n    \"topn\": 20\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"user_login\": \"huan-xiaoling\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 363,\n        \"html_url\": \"https://gitee.com/huan-xiaoling\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 6.2890\n    }, {\n        \"user_login\": \"yu-han39\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 225,\n        \"html_url\": null,\n        \"avatar_url\": null,\n        \"percentage_of_total\": 3.8981\n    }, {\n        \"user_login\": \"nicholas_yhr\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 112,\n        \"html_url\": \"https://gitee.com/nicholas_yhr\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.9404\n    }, {\n        \"user_login\": \"chenrayray\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 96,\n        \"html_url\": \"https://gitee.com/chenrayray\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.6632\n    }, {\n        \"user_login\": \"hbhu_bin\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 70,\n        \"html_url\": \"https://gitee.com/hbhu_bin\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.2128\n    }, {\n        \"user_login\": \"hangangqiang\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 70,\n        \"html_url\": \"https://gitee.com/hangangqiang\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.2128\n    }, {\n        \"user_login\": \"visionarywind\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 64,\n        \"html_url\": \"https://gitee.com/visionarywind\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.1088\n    }, {\n        \"user_login\": \"xiong-pan\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 61,\n        \"html_url\": \"https://gitee.com/xiong-pan\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.0568\n    }, {\n        \"user_login\": \"dsdsdshe\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 57,\n        \"html_url\": \"https://gitee.com/dsdsdshe\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9875\n    }, {\n        \"user_login\": \"zpac\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 57,\n        \"html_url\": \"https://gitee.com/zpac\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9875\n    }, {\n        \"user_login\": \"yu-liang-bin\",\n        \"internal\": \"外部\",\n        \"merged_pr_incre\": 57,\n        \"html_url\": \"https://gitee.com/yu-liang-bin\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9875\n    }, {\n        \"user_login\": \"lilinjie11\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 55,\n        \"html_url\": \"https://gitee.com/lilinjie11\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9529\n    }, {\n        \"user_login\": \"YuFong-Qiu\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 54,\n        \"html_url\": \"https://gitee.com/YuFong-Qiu\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9356\n    }, {\n        \"user_login\": \"jiaxueyu\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 54,\n        \"html_url\": \"https://gitee.com/jiaxueyu\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9356\n    }, {\n        \"user_login\": \"DavidFFFan\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 54,\n        \"html_url\": \"https://gitee.com/DavidFFFan\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9356\n    }, {\n        \"user_login\": \"ccsszz\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 54,\n        \"html_url\": \"https://gitee.com/ccsszz\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9356\n    }, {\n        \"user_login\": \"shenhaojing\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 53,\n        \"html_url\": \"https://gitee.com/shenhaojing\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9182\n    }, {\n        \"user_login\": \"xbb3719\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 53,\n        \"html_url\": \"https://gitee.com/xbb3719\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9182\n    }, {\n        \"user_login\": \"shen_haochen\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 52,\n        \"html_url\": \"https://gitee.com/shen_haochen\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9009\n    }, {\n        \"user_login\": \"tongwu1994\",\n        \"internal\": \"内部\",\n        \"merged_pr_incre\": 51,\n        \"html_url\": \"https://gitee.com/tongwu1994\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.8836\n    }],\n    \"timestamp\": 1750497625993,\n    \"executeTime\": 900\n}",
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
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
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
    }, {
      "name" : "repo_path",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 格式非法",
      "expression" : "^([a-zA-Z0-9_\\-./]+)?$",
      "children" : [ ]
    }, {
      "name" : "topn",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "topn 必须为正整数且不超过 100",
      "expression" : "topn > 0 && topn <= 100",
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
          "name" : "internal",
          "value" : "内部",
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
          "name" : "user_login",
          "value" : "huan-xiaoling",
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
          "value" : "https://gitee.com/huan-xiaoling",
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
        }, {
          "name" : "merged_pr_incre",
          "value" : "363",
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
      "value" : "1750473728801",
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
      "value" : "25",
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
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 社区
var community = body.community.toLowerCase();
// 仓库
var repo_path = body.repo_path;
var repo_arr = repo_path != null ? repo_path.split("/"):[];
var namespace = "";
if(repo_arr.size() == 2){
    namespace = repo_arr[0];
    repo_path = repo_arr[1];
}
// topn
var topn = 10;
if (body.topn != null and body.topn != ""){
    topn = body.topn;
}
// 贡献表
var contributeTable = "dws_" + community + "_contribute_repo_user_daily";
var userTable = "fact_"+community+"_user";
var robotUserTable = "fact_community_robot_user";
var internal_sql = """
WITH filtered_data AS (
    SELECT 
        ru.internal, 
        ru.user_login,
        ru.merged_pr_incre,
        ru.namespace,
        ru.repo_path,
        fu.html_url,
        fu.obs_avatar_url as avatar_url
    FROM ${contributeTable} ru
    LEFT JOIN ${userTable} fu ON ru.user_login = fu.user_login
    WHERE ru.date::DATE BETWEEN #{start} AND #{end} 
        AND ru.private = 'false' 
        AND ru.user_login NOT LIKE '%.del'
        AND ru.user_login NOT IN (SELECT user_login FROM ${robotUserTable})
        <if test="namespace != null and namespace != ''">
            AND ru.namespace = #{namespace}
        </if>
        <if test="repo_path != null and repo_path != ''">
            AND ru.repo_path = #{repo_path}
        </if>
),
user_aggregates AS (
    SELECT 
        internal, 
        user_login,
        html_url,
        avatar_url,
        SUM(merged_pr_incre) as merged_pr_incre
    FROM filtered_data
    WHERE merged_pr_incre > 0
    GROUP BY internal, user_login, html_url, avatar_url
    HAVING SUM(merged_pr_incre) > 0  -- 确保有正数贡献
),
ranked_users AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY merged_pr_incre DESC) as user_rank
    FROM user_aggregates
),
total_calculation AS (
    SELECT 
        COALESCE(SUM(merged_pr_incre), 0) as merged_pr_incre_total
    FROM user_aggregates
)
SELECT 
    u.user_login,
    u.internal,
    u.merged_pr_incre,
    u.html_url,
    u.avatar_url,
    CASE 
        WHEN t.merged_pr_incre_total = 0 THEN 0 
        ELSE ROUND((u.merged_pr_incre::numeric / t.merged_pr_incre_total) * 100, 4) 
    END AS percentage_of_total
FROM ranked_users u
CROSS JOIN total_calculation t
WHERE u.user_rank <= #{topn}
ORDER BY u.merged_pr_incre DESC;
""";
var internal_data = db.select(internal_sql);
// user_login - 用户名 ； internal-内外部开发者 ； merged_pr_incre-合入pr个数 ； html_url-用户个人主页地址； avatar_url-用户头像地址； percentage_of_toal：占比
return internal_data;

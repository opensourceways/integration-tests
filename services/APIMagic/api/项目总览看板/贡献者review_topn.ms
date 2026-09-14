{
  "properties" : { },
  "id" : "copy1750473637708d41808",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "贡献者review_topn",
  "createTime" : null,
  "updateTime" : 1773818228428,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/topn/user/review",
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
  "requestBody" : "{\r\n    \"start\":1730390400000,\r\n    \"end\":1743177600000,\r\n    \"community\":\"openeuler\",\r\n    \"repo_path\":\"\",\r\n    \"topn\": 20\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"user_login\": \"shinwell_hu\",\n        \"internal\": \"内部\",\n        \"review_pr_incre\": 1265,\n        \"html_url\": \"https://gitee.com/shinwell_hu\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 11.7445\n    }, {\n        \"user_login\": \"fundawang\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 716,\n        \"html_url\": \"https://gitee.com/fundawang\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 6.6475\n    }, {\n        \"user_login\": \"wk333\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 303,\n        \"html_url\": \"https://gitee.com/wk333\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 2.8131\n    }, {\n        \"user_login\": \"starlet-dx\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 238,\n        \"html_url\": \"https://gitee.com/starlet-dx\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 2.2096\n    }, {\n        \"user_login\": \"cherry530\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 148,\n        \"html_url\": \"https://gitee.com/cherry530\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.3741\n    }, {\n        \"user_login\": \"Charlie_li\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 132,\n        \"html_url\": \"https://gitee.com/Charlie_li\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.2255\n    }, {\n        \"user_login\": \"liqingqing_1229\",\n        \"internal\": \"内部\",\n        \"review_pr_incre\": 132,\n        \"html_url\": \"https://gitee.com/liqingqing_1229\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.2255\n    }, {\n        \"user_login\": \"hailianguniontech\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 126,\n        \"html_url\": null,\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.1698\n    }, {\n        \"user_login\": \"aven6\",\n        \"internal\": \"内部\",\n        \"review_pr_incre\": 123,\n        \"html_url\": \"https://gitee.com/aven6\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.1420\n    }, {\n        \"user_login\": \"lijieac\",\n        \"internal\": \"内部\",\n        \"review_pr_incre\": 109,\n        \"html_url\": \"https://gitee.com/lijieac\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.0120\n    }, {\n        \"user_login\": \"peijiankang\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 98,\n        \"html_url\": \"https://gitee.com/peijiankang\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.9099\n    }, {\n        \"user_login\": \"dillon_chen\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 89,\n        \"html_url\": \"https://gitee.com/dillon_chen\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.8263\n    }, {\n        \"user_login\": \"tong_1001\",\n        \"internal\": \"内部\",\n        \"review_pr_incre\": 88,\n        \"html_url\": \"https://gitee.com/tong_1001\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.8170\n    }, {\n        \"user_login\": \"zhong-wei-shen\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 85,\n        \"html_url\": \"https://gitee.com/zhong-wei-shen\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.7892\n    }, {\n        \"user_login\": \"wang--ge\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 84,\n        \"html_url\": \"https://gitee.com/wang--ge\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.7799\n    }, {\n        \"user_login\": \"liyunfei33\",\n        \"internal\": \"内部\",\n        \"review_pr_incre\": 82,\n        \"html_url\": \"https://gitee.com/liyunfei33\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.7613\n    }, {\n        \"user_login\": \"jianminw\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 81,\n        \"html_url\": \"https://gitee.com/jianminw\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.7520\n    }, {\n        \"user_login\": \"tiny08\",\n        \"internal\": \"内部\",\n        \"review_pr_incre\": 80,\n        \"html_url\": \"https://gitee.com/tiny08\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.7427\n    }, {\n        \"user_login\": \"liuxu180400617\",\n        \"internal\": \"内部\",\n        \"review_pr_incre\": 75,\n        \"html_url\": \"https://gitee.com/liuxu180400617\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.6963\n    }, {\n        \"user_login\": \"bugflyfly\",\n        \"internal\": \"外部\",\n        \"review_pr_incre\": 74,\n        \"html_url\": \"https://gitee.com/bugflyfly\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 0.6870\n    }],\n    \"timestamp\": 1750497501409,\n    \"executeTime\": 657\n}",
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
      "validateType" : "pass",
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
          "name" : "user_login",
          "value" : "guo-mengqi",
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
          "value" : "https://gitee.com/guo-mengqi",
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
          "name" : "active_comment_incre",
          "value" : "4869",
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
      "value" : "1750474103638",
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
      "value" : "891",
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
WITH user_stats AS (
    SELECT 
        ru.internal, ru.user_login,fu.html_url,fu.obs_avatar_url as avatar_url,
        sum(ru.review_pr_comment_incre) as review_pr_comment_incre
    FROM ${contributeTable} ru
    left join ${userTable} fu on ru.user_login  = fu.user_login
    where ru.date::DATE BETWEEN #{start} AND #{end} and ru.review_pr_comment_incre > 0 and ru.private = 'false' and ru.user_login not like '%.del'
        and ru.user_login not in (
            select user_login from ${robotUserTable}
        )
        <if test="namespace != null and namespace != ''">
            and ru.namespace = #{namespace}
        </if>
        <if test="repo_path != null and repo_path != ''">
            and ru.repo_path = #{repo_path}
        </if>
    group by ru.internal, ru.user_login,fu.html_url,fu.obs_avatar_url
    order by review_pr_comment_incre desc
    limit #{topn} offset 0
),
total_stats AS (
    -- 计算总金额
    SELECT 
        sum(ru.review_pr_comment_incre) as review_pr_comment_incre_total
    FROM ${contributeTable} ru
    left join ${userTable} fu on ru.user_login  = fu.user_login
    where ru.date::DATE BETWEEN #{start} AND #{end} and ru.review_pr_comment_incre > 0 and ru.private = 'false' and ru.user_login not like '%.del'
        and ru.user_login not in (
            select user_login from ${robotUserTable}
        )
        <if test="namespace != null and namespace != ''">
            and ru.namespace = #{namespace}
        </if>
        <if test="repo_path != null and repo_path != ''">
            and ru.repo_path = #{repo_path}
        </if>
)
SELECT 
    u.user_login,
    u.internal,
    u.review_pr_comment_incre,
    u.html_url,
    u.avatar_url,
    case when t.review_pr_comment_incre_total = 0 then 0 else 
    ROUND((u.review_pr_comment_incre::numeric / t.review_pr_comment_incre_total) * 100, 4) 
    end AS percentage_of_total
FROM 
    user_stats u
CROSS JOIN 
    total_stats t
ORDER BY 
    u.review_pr_comment_incre DESC;
""";
var internal_data = db.select(internal_sql);
// user_login - 用户名 ； internal-内外部开发者 ； review_pr_incre-Review个数 ； html_url-用户个人主页地址； avatar_url-用户头像地址； percentage_of_toal：占比
return internal_data;

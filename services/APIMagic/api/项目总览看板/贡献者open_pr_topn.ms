{
  "properties" : { },
  "id" : "copy1750474141710d52490",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "贡献者open_pr_topn",
  "createTime" : null,
  "updateTime" : 1773817999660,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/topn/user/open-pr",
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
  "requestBody" : "{\r\n    \"start\": 1758902400000,\r\n    \"end\": 1761555703670,\r\n    \"community\": \"cannopen\",\r\n    \"topn\": 10\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"user_login\": \"qq_44359711\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 50,\n        \"html_url\": \"https://gitcode.com/qq_44359711\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 3.4843\n    }, {\n        \"user_login\": \"ivanshan_8170\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 50,\n        \"html_url\": null,\n        \"avatar_url\": null,\n        \"percentage_of_total\": 3.4843\n    }, {\n        \"user_login\": \"dovahkiiin\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 38,\n        \"html_url\": \"https://gitcode.com/dovahkiiin\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 2.6481\n    }, {\n        \"user_login\": \"sum39c5bb\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 37,\n        \"html_url\": null,\n        \"avatar_url\": null,\n        \"percentage_of_total\": 2.5784\n    }, {\n        \"user_login\": \"vallenChen\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 30,\n        \"html_url\": \"https://gitcode.com/vallenChen\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 2.0906\n    }, {\n        \"user_login\": \"goodpeople233\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 28,\n        \"html_url\": \"https://gitcode.com/goodpeople233\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.9512\n    }, {\n        \"user_login\": \"yuantao_\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 28,\n        \"html_url\": \"https://gitcode.com/yuantao_\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.9512\n    }, {\n        \"user_login\": \"doddleCat\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 23,\n        \"html_url\": null,\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.6028\n    }, {\n        \"user_login\": \"ninihihi\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 22,\n        \"html_url\": \"https://gitcode.com/ninihihi\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.5331\n    }, {\n        \"user_login\": \"guangdongzhu\",\n        \"internal\": \"内部\",\n        \"open_pr_incre\": 20,\n        \"html_url\": \"https://gitcode.com/guangdongzhu\",\n        \"avatar_url\": null,\n        \"percentage_of_total\": 1.3937\n    }],\n    \"timestamp\": 1761555844343,\n    \"executeTime\": 16\n}",
  "description" : null,
  "requestBodyDefinition" : {
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
      "children" : [ ]
    }, {
      "name" : "timestamp",
      "value" : "1761555818956",
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
      "value" : "8",
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
        sum(ru.pr_incre) as open_pr_incre
    FROM ${contributeTable} ru
    left join ${userTable} fu on ru.user_login  = fu.user_login
    where ru.date::DATE BETWEEN #{start} AND #{end} and ru.pr_incre > 0 and ru.private = 'false' and ru.user_login not like '%.del'
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
    order by open_pr_incre desc
    limit #{topn} offset 0
),
total_stats AS (
    -- 计算总金额
    SELECT 
        sum(ru.pr_incre) as open_pr_incre_total
    FROM ${contributeTable} ru
    left join ${userTable} fu on ru.user_login  = fu.user_login
    where ru.date::DATE BETWEEN #{start} AND #{end} and ru.pr_incre > 0 and ru.private = 'false' and ru.user_login not like '%.del'
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
    u.open_pr_incre,
    u.html_url,
    u.avatar_url,
    case when t.open_pr_incre_total = 0 then 0 else 
    ROUND((u.open_pr_incre::numeric / t.open_pr_incre_total) * 100, 4) 
    end AS percentage_of_total
FROM 
    user_stats u
CROSS JOIN 
    total_stats t
ORDER BY 
    u.open_pr_incre DESC;
""";
var internal_data = db.select(internal_sql);
// user_login - 用户名 ； internal-内外部开发者 ； open_pr_incre-提交pr个数； html_url-用户个人主页地址； avatar_url-用户头像地址； percentage_of_toal：占比
return internal_data;

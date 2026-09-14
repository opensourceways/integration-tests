{
  "properties" : { },
  "id" : "copy1754534284851d14646",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "贡献者review_topn(分页)",
  "createTime" : null,
  "updateTime" : 1773905886779,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/topn/user/review/page",
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
  "requestBody" : "{\r\n    \"start\":1766316575952,\r\n    \"end\":1768908575952,\r\n    \"community\":\"cannopen\",\r\n    \"repo_path\":\"\",\r\n    \"pageNum\": 1,\r\n    \"pageSize\": 10\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 821,\n        \"total_page\": 83,\n        \"list\": [{\n            \"source\": \"gitcode\",\n            \"user_login\": \"cui_jiahao\",\n            \"user_name\": \"cui_jiahao\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 251,\n            \"html_url\": \"https://gitcode.com/cui_jiahao\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-5.png\",\n            \"percentage_of_total\": 1.8042,\n            \"final_user_name\": \"cui_jiahao\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"DCGDDD\",\n            \"user_name\": \"杨旭\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 171,\n            \"html_url\": \"https://gitcode.com/DCGDDD\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/bc/fb/165594b0c91fb4c6a30bf39a5d748ba090ddfa3c9309cacc288246049a37015b.jpeg\",\n            \"percentage_of_total\": 1.2292,\n            \"final_user_name\": \"杨旭\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"cycychenyi\",\n            \"user_name\": \"cycychenyi\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 149,\n            \"html_url\": \"https://gitcode.com/cycychenyi\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-5.png\",\n            \"percentage_of_total\": 1.0710,\n            \"final_user_name\": \"cycychenyi\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"zengjuan\",\n            \"user_name\": \"zengjuan\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 131,\n            \"html_url\": \"https://gitcode.com/zengjuan\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/be/fc/2b01e20538fc889286899afa8bd7be727baf328dff8df5a53590888372d4577b.png\",\n            \"percentage_of_total\": 0.9416,\n            \"final_user_name\": \"zengjuan\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"tsungl4\",\n            \"user_name\": \"lidongsheng\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 128,\n            \"html_url\": \"https://gitcode.com/tsungl4\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-4.png\",\n            \"percentage_of_total\": 0.9201,\n            \"final_user_name\": \"lidongsheng\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"yelongjian\",\n            \"user_name\": \"yelongjian\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 123,\n            \"html_url\": \"https://gitcode.com/yelongjian\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-5.png\",\n            \"percentage_of_total\": 0.8841,\n            \"final_user_name\": \"yelongjian\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"luozhonglin222\",\n            \"user_name\": \"luozhonglin\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 123,\n            \"html_url\": \"https://gitcode.com/luozhonglin222\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/ce/af/c456e69a0866491011748f36ef0f2da58d398039c0669726f05b53bf31554d84.jpg\",\n            \"percentage_of_total\": 0.8841,\n            \"final_user_name\": \"luozhonglin\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"wan_jianfen\",\n            \"user_name\": \"wan_jianfen\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 120,\n            \"html_url\": \"https://gitcode.com/wan_jianfen\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-1.png\",\n            \"percentage_of_total\": 0.8626,\n            \"final_user_name\": \"wan_jianfen\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"gaoxingwang\",\n            \"user_name\": \"gaoxingwang\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 118,\n            \"html_url\": \"https://gitcode.com/gaoxingwang\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-5.png\",\n            \"percentage_of_total\": 0.8482,\n            \"final_user_name\": \"gaoxingwang\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"wuchenhao123\",\n            \"user_name\": \"wuchenhao123\",\n            \"internal\": \"内部\",\n            \"review_pr_comment_incre\": 114,\n            \"html_url\": \"https://gitcode.com/wuchenhao123\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/aa/cd/aa6c6488d04967bfb15cc06307419c89aa7356909cb756f465f545835ee605be.png\",\n            \"percentage_of_total\": 0.8194,\n            \"final_user_name\": \"wuchenhao123\"\n        }]\n    },\n    \"timestamp\": 1773905885314,\n    \"executeTime\": 392\n}",
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
      "name" : "user_login",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "user_login 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-.]*$",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过 100",
      "expression" : "(pageSize > 0 && pageSize <= 100)",
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageNum 必须为正整数",
      "expression" : "(pageNum > 0 && pageNum <= 9999)",
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
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "total_count",
        "value" : "102",
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
        "name" : "total_page",
        "value" : "11",
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
        "name" : "list",
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
            "value" : "gemini-code-assist[bot]",
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
            "name" : "internal",
            "value" : "外部",
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
            "name" : "review_pr_comment_incre",
            "value" : "54",
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
            "name" : "html_url",
            "value" : "https://github.com/apps/gemini-code-assist",
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
            "value" : "https://avatars.githubusercontent.com/in/956858?v=4",
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
            "name" : "percentage_of_total",
            "value" : "7.3171",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          } ]
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1761702510359",
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
      "value" : "13",
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
// 分页
var page_num = body.pageNum;
var page_size = body.pageSize;
// 筛选
var user_login = body.user_login;
var offset = (page_num - 1) * page_size;
// 贡献表
var contributeTable = "dws_" + community + "_contribute_repo_user_daily";
var userTable = "fact_"+community+"_user";
var robotUserTable = "fact_community_robot_user";
var sigUserTable = "fact_"+community+"_sig_user";
var readmeUserTable = "fact_user_readme";
var blueUserTable = "fact_blue_user";
var internal_sql = """
WITH user_stats AS (
    SELECT 
        ru.internal, ru.user_login, ru.source,
        MAX(fu.user_name) AS user_name,
        MAX(fu.html_url) AS html_url,
        MAX(fu.obs_avatar_url) AS avatar_url,
        sum(ru.review_pr_comment_incre) as review_pr_comment_incre
    FROM ${contributeTable} ru
    left join ${userTable} fu on ru.user_login  = fu.user_login and fu.code_platform = ru.source
    where ru.date::DATE BETWEEN #{start} AND #{end} and ru.review_pr_comment_incre > 0 and ru.private = 'false' and ru.user_login not like '%.del'
        and ru.user_login not in (
            select user_login from ${robotUserTable}
        )
        <if test="user_login != null and user_login != ''">
            and ru.user_login like concat('%', #{user_login}, '%')
        </if>
        <if test="namespace != null and namespace != ''">
            and ru.namespace = #{namespace}
        </if>
        <if test="repo_path != null and repo_path != ''">
            and ru.repo_path = #{repo_path}
        </if>
    group by ru.internal, ru.user_login, ru.source
    order by review_pr_comment_incre desc, ru.user_login asc, ru.source asc
),
total_stats AS (
    -- 计算全量总量（不按 user_login 过滤：占比分母恒为全量，筛选时占比不变）
    SELECT 
        sum(ru.review_pr_comment_incre) as review_pr_comment_incre_total
    FROM ${contributeTable} ru
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
),
page_table as (
    SELECT 
        u.source,
        u.user_login,
        u.user_name,
        u.internal,
        u.review_pr_comment_incre,
        u.html_url,
        u.avatar_url,
        case when t.review_pr_comment_incre_total = 0 then 0 else 
        ROUND((u.review_pr_comment_incre::numeric / t.review_pr_comment_incre_total) * 100, 4) 
        end AS percentage_of_total,
        (select count(1) from user_stats) as total_count,
        CEIL((select count(1) from user_stats)::numeric/#{page_size}) as total_page
    FROM 
        user_stats u
    CROSS JOIN 
        total_stats t
    ORDER BY 
        u.review_pr_comment_incre DESC, u.user_login ASC, u.source ASC
    LIMIT #{page_size} OFFSET #{offset}
)
select p.*,
    COALESCE(
    (SELECT real_name_zh FROM ${readmeUserTable} WHERE user_login = p.user_login and platform = p.source  limit 1),
    (SELECT user_name FROM ${sigUserTable} WHERE user_login = p.user_login and user_name != p.user_login limit 1),
    CASE p.source
      WHEN 'github' THEN (SELECT name FROM ${blueUserTable} WHERE github_id = p.user_login LIMIT 1)
      WHEN 'gitee' THEN (SELECT name FROM ${blueUserTable} WHERE gitee_id = p.user_login LIMIT 1)
      WHEN 'gitcode' THEN (SELECT name FROM ${blueUserTable} WHERE gitcode_id = p.user_login LIMIT 1)
    END,
    p.user_name,
    p.user_login
    ) as final_user_name
from page_table p
""";
var query_data = db.select(internal_sql);
// user_login - 用户名 ； internal-内外部开发者 ； review_pr_incre-Review个数 ； html_url-用户个人主页地址； avatar_url-用户头像地址； percentage_of_toal：占比
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
   item.remove("total_count");
   item.remove("total_page");
   return item;
})
HashMap result = new HashMap();
result.put("list",query_data);
result.put("total_count",total_count);
result.put("total_page",total_page);
return result

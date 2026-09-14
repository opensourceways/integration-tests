{
  "properties" : { },
  "id" : "copy1754533646715d15591",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "贡献者pr_topn(分页)",
  "createTime" : null,
  "updateTime" : 1773905842960,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/topn/user/pr/page",
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
  "requestBody" : "{\r\n    \"start\":1730390400000,\r\n    \"end\":1743177600000,\r\n    \"community\":\"mindspore\",\r\n    \"repo_path\":\"\",\r\n    \"pageNum\": 1,\r\n    \"pageSize\": 10\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 527,\n        \"total_page\": 53,\n        \"list\": [{\n            \"source\": \"gitcode\",\n            \"user_login\": \"huan-xiaoling\",\n            \"user_name\": \"huan-xiaoling\",\n            \"internal\": \"内部\",\n            \"merged_pr_incre\": 361,\n            \"html_url\": \"https://gitcode.com/huan-xiaoling\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/ee/bb/12138e9e1bb3c078769a1f22ce665b80e051a933a172f33b89e749ce721b2bda.png\",\n            \"percentage_of_total\": 4.9821,\n            \"final_user_name\": \"huan-xiaoling\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"yu-han39\",\n            \"user_name\": null,\n            \"internal\": \"内部\",\n            \"merged_pr_incre\": 225,\n            \"html_url\": null,\n            \"avatar_url\": null,\n            \"percentage_of_total\": 3.1052,\n            \"final_user_name\": \"yu-han39\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"nicholas_yhr\",\n            \"user_name\": \"nicholas_yhr\",\n            \"internal\": \"内部\",\n            \"merged_pr_incre\": 104,\n            \"html_url\": \"https://gitcode.com/nicholas_yhr\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/ca/fa/9298ca92f303a4be37b15fed2d706e018f56cfd1d654594386850a22c2f23827.jpg\",\n            \"percentage_of_total\": 1.4353,\n            \"final_user_name\": \"nicholas_yhr\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"chenrayray\",\n            \"user_name\": \"chenrayray\",\n            \"internal\": \"内部\",\n            \"merged_pr_incre\": 96,\n            \"html_url\": \"https://gitcode.com/chenrayray\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/ee/cd/7943e7e6004cde33ecd40a58a547810ef00f27b9a3fcf007a6ad958c185b852d.png\",\n            \"percentage_of_total\": 1.3249,\n            \"final_user_name\": \"Chen Xinrui\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"hbhu_bin\",\n            \"user_name\": \"hbhu_bin\",\n            \"internal\": \"内部\",\n            \"merged_pr_incre\": 70,\n            \"html_url\": \"https://gitcode.com/hbhu_bin\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-4.png\",\n            \"percentage_of_total\": 0.9661,\n            \"final_user_name\": \"hbhu_bin\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"hangangqiang\",\n            \"user_name\": \"hangangqiang\",\n            \"internal\": \"内部\",\n            \"merged_pr_incre\": 70,\n            \"html_url\": \"https://gitcode.com/hangangqiang\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-3.png\",\n            \"percentage_of_total\": 0.9661,\n            \"final_user_name\": \"hangangqiang\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"visionarywind\",\n            \"user_name\": null,\n            \"internal\": \"内部\",\n            \"merged_pr_incre\": 64,\n            \"html_url\": null,\n            \"avatar_url\": null,\n            \"percentage_of_total\": 0.8832,\n            \"final_user_name\": \"visionarywind\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"xiong-pan\",\n            \"user_name\": \"xiong-pan\",\n            \"internal\": \"内部\",\n            \"merged_pr_incre\": 61,\n            \"html_url\": \"https://gitcode.com/xiong-pan\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-4.png\",\n            \"percentage_of_total\": 0.8418,\n            \"final_user_name\": \"xiong-pan\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"dsdsdshe\",\n            \"user_name\": \"dsdsdshe\",\n            \"internal\": \"内部\",\n            \"merged_pr_incre\": 57,\n            \"html_url\": \"https://gitcode.com/dsdsdshe\",\n            \"avatar_url\": \"https://datastat-img.obs.ap-southeast-1.myhuaweicloud.com/gitcode_avatar/doc/avatar-3.png\",\n            \"percentage_of_total\": 0.7866,\n            \"final_user_name\": \"周俊园\"\n        }, {\n            \"source\": \"gitcode\",\n            \"user_login\": \"yu-liang-bin\",\n            \"user_name\": null,\n            \"internal\": \"外部\",\n            \"merged_pr_incre\": 57,\n            \"html_url\": null,\n            \"avatar_url\": null,\n            \"percentage_of_total\": 0.7866,\n            \"final_user_name\": \"yu-liang-bin\"\n        }]\n    },\n    \"timestamp\": 1773905840780,\n    \"executeTime\": 48\n}",
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
      "validateType" : "pass",
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
      "validateType" : "pass",
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
        "value" : "543",
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
        "value" : "55",
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
            "name" : "source",
            "value" : "gitee",
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
            "name" : "user_name",
            "value" : "宦晓玲",
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
            "name" : "percentage_of_total",
            "value" : "4.0920",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "final_user_name",
            "value" : "宦晓玲",
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
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1769049687576",
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
      "value" : "66",
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
        ru.source, ru.internal, ru.user_login,
        MAX(fu.user_name) AS user_name,
        MAX(fu.html_url) AS html_url,
        MAX(fu.obs_avatar_url) AS avatar_url,
        sum(ru.merged_pr_incre) as merged_pr_incre
    FROM ${contributeTable} ru
    left join ${userTable} fu on ru.user_login  = fu.user_login and ru.source = fu.code_platform
    where ru.date::DATE BETWEEN #{start} AND #{end} and ru.merged_pr_incre > 0 and ru.private = 'false' and ru.user_login not like '%.del'
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
    group by ru.source, ru.internal, ru.user_login
    order by merged_pr_incre desc, ru.user_login asc, ru.source asc
),
total_stats AS (
    -- 计算全量总量（不按 user_login 过滤：占比分母恒为全量，筛选时占比不变）
    SELECT 
        sum(ru.merged_pr_incre) as merged_pr_incre_total
    FROM ${contributeTable} ru
    where ru.date::DATE BETWEEN #{start} AND #{end} and ru.merged_pr_incre > 0 and ru.private = 'false' and ru.user_login not like '%.del'
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
        u.merged_pr_incre,
        u.html_url,
        u.avatar_url,
        case when t.merged_pr_incre_total = 0 then 0 else 
        ROUND((u.merged_pr_incre::numeric / t.merged_pr_incre_total) * 100, 4) 
        end AS percentage_of_total,
        (select count(1) from user_stats) as total_count,
        CEIL((select count(1) from user_stats)::numeric/#{page_size}) as total_page
    FROM 
        user_stats u
    CROSS JOIN 
        total_stats t
    ORDER BY 
        u.merged_pr_incre DESC, u.user_login ASC, u.source ASC
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
// user_login - 用户名 ； internal-内外部开发者 ； merged_pr_incre-合入pr个数 ； html_url-用户个人主页地址； avatar_url-用户头像地址； percentage_of_toal：占比
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

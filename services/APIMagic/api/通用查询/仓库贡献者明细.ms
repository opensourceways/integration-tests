{
  "properties" : { },
  "id" : "repo_user_detail_22_001",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "仓库贡献者明细",
  "createTime" : null,
  "updateTime" : 1747650000000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repo/user/detail",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"community\":\"mindseriessdk\",\r\n    \"namespace\":\"mindseriessdk\",\r\n    \"repo_path\":\"mindspore\",\r\n    \"level\":\"D1\",\r\n    \"start\":1730419200000,\r\n    \"end\":1764215445119,\r\n    \"pageNum\":1,\r\n    \"pageSize\":20\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 15,\n        \"total_page\": 1,\n        \"list\": [{\n            \"user_login\": \"developer1\",\n            \"pr_count\": 12,\n            \"issue_count\": 5,\n            \"comment_count\": 30,\n            \"level\": \"D1\"\n        }]\n    }\n}",
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
      "name" : "community",
      "value" : "mindseriessdk",
      "description" : "",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "namespace",
      "value" : "mindseriessdk",
      "description" : "",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "namespace 格式非法",
      "expression" : "^[a-zA-Z0-9_.-]*$",
      "children" : [ ]
    }, {
      "name" : "repo_path",
      "value" : "mindspore",
      "description" : "",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 格式非法",
      "expression" : "^[a-zA-Z0-9_.-/]*$",
      "children" : [ ]
    }, {
      "name" : "level",
      "value" : "D1",
      "description" : "",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "level 只能为 D0、D1 或 D2",
      "expression" : "^(D0|D1|D2)$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "1730419200000",
      "description" : "查询开始时间（毫秒级时间戳）",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : null,
      "error" : null,
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1764215445119",
      "description" : "查询结束时间（毫秒级时间戳）",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : null,
      "error" : null,
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageNum 必须为正整数且不超过1000",
      "expression" : "pageNum > 0 && pageNum <= 1000",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "20",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过100",
      "expression" : "pageSize > 0 && pageSize <= 100",
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
        "value" : "15",
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
            "value" : "developer1",
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
            "name" : "pr_count",
            "value" : "12",
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
            "name" : "issue_count",
            "value" : "5",
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
            "name" : "comment_count",
            "value" : "30",
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
            "name" : "level",
            "value" : "D1",
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
    } ]
  }
}
================================
var community = body.community.toLowerCase();
var namespace = body.namespace;
var repo_path = body.repo_path;
var level = body.level;
var page_num = body.pageNum ? body.pageNum : 1;
var page_size = body.pageSize ? body.pageSize : 20;
var offset = (page_num - 1) * page_size;
var startTs = body.start;
var endTs = body.end;
var dwm_contribute_user_repo = "dwm_" + community + "_contribute_user_repo";
var dws_contribute_repo_user_daily = "dws_" + community + "_contribute_repo_user_daily";
var levelTimeField = "";
if (level == "D0") {
    levelTimeField = "d0_time";
} else if (level == "D1") {
    levelTimeField = "d1_time";
} else if (level == "D2") {
    levelTimeField = "d2_time";
}
var sql = """
WITH user_contrib AS (
    SELECT 
        user_login,
        SUM(pr_incre) as pr_count,
        SUM(issue_incre) as issue_count,
        SUM(comment_incre) as comment_count
    FROM ${dws_contribute_repo_user_daily}
    <where>
        namespace = #{namespace}
        and repo_path = #{repo_path}
        <if test="startTs != null and startTs != ''">
            and date >= to_timestamp(#{startTs}/1000)::date
        </if>
        <if test="endTs != null and endTs != ''">
            and date <= to_timestamp(#{endTs}/1000)::date
        </if>
        and user_login not in (select user_login from fact_community_robot_user)
    </where>
    GROUP BY user_login
),
level_users AS (
    SELECT 
        user_login
    FROM ${dwm_contribute_user_repo}
    <where>
        namespace = #{namespace}
        and repo_path = #{repo_path}
        and ${levelTimeField} is not null
        <if test="startTs != null and startTs != ''">
            and ${levelTimeField}::date >= to_timestamp(#{startTs}/1000)::date
        </if>
        <if test="endTs != null and endTs != ''">
            and ${levelTimeField}::date <= to_timestamp(#{endTs}/1000)::date
        </if>
        and user_login not in (select user_login from fact_community_robot_user)
    </where>
),
count_ori as (
    select count(1) as total_count from level_users
)
SELECT 
    lu.user_login,
    COALESCE(uc.pr_count, 0) as pr_count,
    COALESCE(uc.issue_count, 0) as issue_count,
    COALESCE(uc.comment_count, 0) as comment_count,
    #{level} as level,
    co.total_count,
    CEIL(co.total_count::numeric/#{page_size}) as total_page
FROM 
    level_users lu
LEFT JOIN user_contrib uc ON lu.user_login = uc.user_login
CROSS JOIN count_ori co
ORDER BY uc.pr_count DESC NULLS LAST
LIMIT #{page_size} OFFSET #{offset}
""";
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
return result
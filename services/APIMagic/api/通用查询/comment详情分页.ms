{
  "properties" : { },
  "id" : "comment_detail_22_001",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "comment详情分页",
  "createTime" : null,
  "updateTime" : 1747650000000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/comments/detail",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"community\":\"mindseriessdk\",\r\n    \"namespace\":\"mindseriessdk\",\r\n    \"repo_path\":\"mindspore\",\r\n    \"user_login\":\"developer1\",\r\n    \"start\":1730419200000,\r\n    \"end\":1764215445119,\r\n    \"pageNum\":1,\r\n    \"pageSize\":20\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 30,\n        \"total_page\": 2,\n        \"list\": [{\n            \"body\": \"这个实现方案很好\",\n            \"html_url\": \"https://gitcode.com/org/repo/pull/123#comment-456\",\n            \"created_at\": \"2025-01-15 10:30:00\",\n            \"repo\": \"namespace/repo_path\",\n            \"is_invalid_comment\": 0,\n            \"comment_type\": \"normal\"\n        }]\n    }\n}",
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
      "required" : false,
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
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 格式非法",
      "expression" : "^[a-zA-Z0-9_.-/]*$",
      "children" : [ ]
    }, {
      "name" : "user_login",
      "value" : "developer1",
      "description" : "",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "user_login 不能为空",
      "expression" : null,
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
        "name" : "total_page",
        "value" : "2",
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
            "name" : "body",
            "value" : "这个实现方案很好",
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
            "value" : "https://gitcode.com/org/repo/pull/123#comment-456",
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
            "name" : "created_at",
            "value" : "2025-01-15 10:30:00",
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
            "name" : "repo",
            "value" : "namespace/repo_path",
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
            "name" : "is_invalid_comment",
            "value" : "0",
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
            "name" : "comment_type",
            "value" : "normal",
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
var user_login = body.user_login;
// #1348: only_review=true 时口径对齐 Review 排行榜（review_pr_comment_incre 定义：is_invalid_comment=0 且 comment_type='pr_comment'）
var only_review = body.only_review;
// #1348: 剔除私有仓评论（与 Review 排行榜 private='false' 口径对齐，生产实测差 8 正好是私有）
var exclude_private = body.exclude_private;
// #1348: 跳过慢的全量 count（抽屉总数改由 daily 聚合接口给），只取当前页，openeuler 大数据量 <1s
var skip_count = body.skip_count;
var page_num = body.pageNum ? body.pageNum : 1;
var page_size = body.pageSize ? body.pageSize : 20;
var offset = (page_num - 1) * page_size;
var startTs = body.start;
var endTs = body.end;
var contributeTable = "dws_" + community + "_contribute";
var sql = """
WITH user_comments AS (
    SELECT 
        body,
        html_url,
        created_at,
        namespace || '/' || repo_path as repo,
        is_invalid_comment,
        comment_type
    FROM ${contributeTable}
    <where>
        user_login = #{user_login}
        AND contrib_type = 'comment'
        AND is_removed IS NULL
        <if test="namespace != null and namespace != ''">
            and namespace = #{namespace}
        </if>
        <if test="repo_path != null and repo_path != ''">
            and repo_path = #{repo_path}
        </if>
        <if test="startTs != null and startTs != ''">
            and created_at::date >= to_timestamp(#{startTs}/1000)::date
        </if>
        <if test="endTs != null and endTs != ''">
            and created_at::date <= to_timestamp(#{endTs}/1000)::date
        </if>
        and user_login not in (select user_login from fact_community_robot_user)
        <if test="only_review != null and (only_review == true or only_review == 'true')">
            and is_invalid_comment = 0
            and comment_type = 'pr_comment'
        </if>
        <!-- #1348: 与 Review 排行榜口径对齐——榜只统计 private='false'，剔除私有仓评论 -->
        <if test="exclude_private == true or exclude_private == 'true'">
            and private = 'false'
        </if>
    </where>
)
<if test="skip_count != true and skip_count != 'true'">
, count_ori as (
    select count(1) as total_count from user_comments
)
SELECT
    uc.*,
    co.total_count,
    CEIL(co.total_count::numeric/#{page_size}) as total_page
FROM
    user_comments uc, count_ori co
ORDER BY uc.created_at DESC
LIMIT #{page_size} OFFSET #{offset}
</if>
<if test="skip_count == true or skip_count == 'true'">
SELECT
    uc.*,
    -1 as total_count,
    0 as total_page
FROM
    user_comments uc
ORDER BY uc.created_at DESC
LIMIT #{page_size} OFFSET #{offset}
</if>
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
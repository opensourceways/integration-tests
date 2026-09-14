{
  "properties" : { },
  "id" : "user_pr_detail_22_001",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "用户PR详情",
  "createTime" : null,
  "updateTime" : 1747650000000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/user/pr/detail",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"community\":\"mindseriessdk\",\r\n    \"namespace\":\"mindseriessdk\",\r\n    \"repo_path\":\"mindspore\",\r\n    \"user_login\":\"developer1\",\r\n    \"start\":1730419200000,\r\n    \"end\":1764215445119,\r\n    \"pageNum\":1,\r\n    \"pageSize\":20\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 12,\n        \"total_page\": 1,\n        \"list\": [{\n            \"pr_number\": 123,\n            \"pr_title\": \"Fix bug in authentication module\",\n            \"pr_url\": \"https://gitcode.com/org/repo/pull/123\",\n            \"pr_state\": \"merged\",\n            \"created_at\": \"2025-01-15T10:30:00Z\",\n            \"merged_at\": \"2025-01-16T14:20:00Z\"\n        }]\n    }\n}",
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
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1764215445119",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
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
            "name" : "pr_number",
            "value" : "123",
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
            "name" : "pr_title",
            "value" : "Fix bug in authentication module",
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
            "name" : "pr_url",
            "value" : "https://gitcode.com/org/repo/pull/123",
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
            "name" : "pr_state",
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
            "name" : "created_at",
            "value" : "2025-01-15T10:30:00Z",
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
            "name" : "merged_at",
            "value" : "2025-01-16T14:20:00Z",
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
var page_num = body.pageNum ? body.pageNum : 1;
var page_size = body.pageSize ? body.pageSize : 20;
var offset = (page_num - 1) * page_size;
var startTs = body.start;
var endTs = body.end;
var prTable = "fact_" + community + "_pr";
var sql = """
WITH user_pr AS (
    SELECT 
        it.number as pr_number,
        it.title as pr_title,
        it.html_url as pr_url,
        it.state as pr_state,
        it.created_at,
        it.merged_at
    FROM ${prTable} it
    <where>
        it.namespace = #{namespace}
        and it.repo_path = #{repo_path}
        and it.user_login = #{user_login}
        <if test="startTs != null and startTs != ''">
            and it.created_at::date >= to_timestamp(#{startTs}/1000)::date
        </if>
        <if test="endTs != null and endTs != ''">
            and it.created_at::date <= to_timestamp(#{endTs}/1000)::date
        </if>
    </where>
),
count_ori as (
    select count(1) as total_count from user_pr
)
SELECT 
    up.*,
    co.total_count,
    CEIL(co.total_count::numeric/#{page_size}) as total_page
FROM 
    user_pr up, count_ori co
ORDER BY up.created_at DESC
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
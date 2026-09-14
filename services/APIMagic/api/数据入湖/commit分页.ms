{
  "properties" : { },
  "id" : "copy1772802202204d70235",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "commit分页",
  "createTime" : null,
  "updateTime" : 1776391985368,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/commit/page",
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
  }, {
    "name" : "permission",
    "value" : "whitebox",
    "description" : "允许拥有该权限的访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "requestBody" : "{\r\n    \"pageNum\":1,\r\n    \"pageSize\":100,\r\n    \"startTime\":\"2026-03-07 00:00:00\",\r\n    \"endTime\":\"\"\r\n}",
  "headers" : [ {
    "name" : "token",
    "value" : null,
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"token校验失败\",\n    \"data\": null,\n    \"timestamp\": 1774576796100,\n    \"executeTime\": 0\n}",
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
      "name" : "pageNum",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "1",
      "validateType" : "pass",
      "error" : null,
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "100",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "100",
      "validateType" : "pass",
      "error" : null,
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "startTime",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
      "children" : [ ]
    }, {
      "name" : "endTime",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var page_tem = body.pageNum || 1;          // 默认第 1 页，防止 undefined
var pageSize_tem = body.pageSize || 1000; // 默认每页 10 条，防止 undefined
var startTime_tem = body.startTime
var endTime_tem = body.endTime
// 计算偏移量：(页码 - 1) * 每页数量
// 例如：第 1 页 offset=0, 第 2 页 offset=10
var offset = (page_tem - 1) * pageSize_tem;
// 拼接 SQL
// 注意：表名通常不能直接加参数化占位符，需要字符串拼接，但要注意防注入
var sql = """SELECT 
    uuid as id,
    commit_id,
    created_at,
    author,
    email,
    tag_user_company,
    title,
    body,
    file_changed,
    add,
    remove,
    total,
    branch,
    is_default_branch,
    repo_name,
    repo,
    owner,
    org,
    platform,
    commit_url,
    is_merge,
    unified_user,
    user_login,
    COALESCE(array_to_string(co_author, ','), '') AS co_author,
    COALESCE(array_to_string(co_author_email, ','), '') AS co_author_email,
    COALESCE(array_to_string(commit_contributors, ','), '') AS commit_contributors,
    COALESCE(array_to_string(commit_contributor_emails, ','), '') AS commit_contributor_emails,
    COALESCE(array_to_string(commit_reviewers, ','), '') AS commit_reviewers,
    COALESCE(array_to_string(commit_reviewer_emails, ','), '') AS commit_reviewer_emails,
    COALESCE(array_to_string(sig_names, ','), '') AS sig_names,
    test_add,
    community,
    inserted_at
FROM  fact_all_git_commit
                    where is_merge = false
                    <if test="startTime_tem != null and startTime_tem!='' ">
                         and   created_at >=#{startTime_tem}::timestamp
                    </if> 
                       <if test="endTime_tem != null and endTime_tem!='' ">
                          and  created_at <=#{endTime_tem}::timestamp
                    </if>      
LIMIT #{pageSize_tem} OFFSET #{offset}""";
var totalsql = """select count(*) as total from (SELECT 
    uuid,
    commit_id,
    created_at,
    author,
    email,
    tag_user_company,
    title,
    body,
    file_changed,
    add,
    remove,
    total,
    branch,
    is_default_branch,
    repo_name,
    repo,
    owner,
    org,
    platform,
    commit_url,
    is_merge,
    unified_user,
    user_login,
    COALESCE(array_to_string(co_author, ','), '') AS co_author,
    COALESCE(array_to_string(co_author_email, ','), '') AS co_author_email,
    COALESCE(array_to_string(commit_contributors, ','), '') AS commit_contributors,
    COALESCE(array_to_string(commit_contributor_emails, ','), '') AS commit_contributor_emails,
    COALESCE(array_to_string(commit_reviewers, ','), '') AS commit_reviewers,
    COALESCE(array_to_string(commit_reviewer_emails, ','), '') AS commit_reviewer_emails,
    COALESCE(array_to_string(sig_names, ','), '') AS sig_names,
    test_add,
    community,
    inserted_at
FROM  fact_all_git_commit
                    where is_merge = false
                    <if test="startTime_tem != null and startTime_tem!='' ">
                         and   created_at >=#{startTime_tem}::timestamp
                    </if> 
                       <if test="endTime_tem != null and endTime_tem!='' ">
                          and  created_at <=#{endTime_tem}::timestamp
                    </if>                 
)
""";
var data = db.backup.select(sql);
var total = db.backup.select(totalsql);
HashMap res = new HashMap();
res.put("list",data)
res.put("total",total.get(0).get("total"))
return res

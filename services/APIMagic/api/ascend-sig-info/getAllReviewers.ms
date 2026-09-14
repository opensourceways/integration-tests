{
  "properties" : { },
  "id" : "7e99ed329ae649bf8264c4cdb89256b3",
  "script" : null,
  "groupId" : "d5e2698221b04b24a983f69b712ad2e4",
  "name" : "getAllReviewers",
  "createTime" : null,
  "updateTime" : 1776671009643,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/getAllReviewers",
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
  "requestBody" : "{\r\n    \"repo\":\"ascend/MindIE-Service\",\r\n    \"org\":\"hccl\",\r\n    \"branch\":\"master\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"approvers\": [{\n            \"gitcode_id\": \"towncharlie\",\n            \"name\": \"towncharlie\",\n            \"email\": \"towncharlie@yahoo.com\"\n        }, {\n            \"gitcode_id\": \"git_ray\",\n            \"name\": \"git_ray\",\n            \"email\": \"git_ray@google.com\"\n        }],\n        \"reviewers\": [{\n            \"gitcode_id\": \"coding-lz\",\n            \"name\": \"coding-lz\",\n            \"email\": \"coding-lz@yahoo.com\"\n        }]\n    },\n    \"timestamp\": 1745982238296,\n    \"executeTime\": 10\n}",
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
      "name" : "repo",
      "value" : null,
      "description" : null,
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo 格式非法",
      "expression" : "^[a-zA-Z0-9_/-]+$",
      "children" : null
    }, {
      "name" : "org",
      "value" : null,
      "description" : null,
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "org 格式非法",
      "expression" : "^[a-zA-Z0-9_/-]+$",
      "children" : null
    }, {
      "name" : "branch",
      "value" : null,
      "description" : null,
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "branch 格式非法",
      "expression" : "^[a-zA-Z0-9_/-]+$",
      "children" : null
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var org = body.org;
var repo = body.repo;
var branch = body.branch;
var  sql = """
  select distinct b.* from fact_mindie_sig_user_permissions 
  a left join fact_mindie_sig_users b on a.user_gitcode_id=b.gitcode_id
   where repo_name=#{repo} and sig_name=#{org} and branch_name is null and permission_type='approver'
""";
var repoApp = db.select(sql);
var  branchSql = """
  select distinct b.* from fact_mindie_sig_user_permissions 
  a left join fact_mindie_sig_users b on a.user_gitcode_id=b.gitcode_id
   where repo_name=#{repo} and sig_name=#{org} and branch_name =#{branch} and permission_type='approver'
""";
var branchapp = db.select(branchSql);
Set appres = new HashSet();
appres.addAll(repoApp)
appres.addAll(branchapp)
var  sqlRe = """
  select distinct b.* from fact_mindie_sig_user_permissions 
  a left join fact_mindie_sig_users b on a.user_gitcode_id=b.gitcode_id
   where repo_name=#{repo} and sig_name=#{org} and branch_name is null and permission_type='reviewer'
""";
var repoRe = db.select(sqlRe);
var  branchSqlRe = """
  select distinct b.* from fact_mindie_sig_user_permissions 
  a left join fact_mindie_sig_users b on a.user_gitcode_id=b.gitcode_id
   where repo_name=#{repo} and sig_name=#{org} and branch_name =#{branch} and permission_type='reviewer'
""";
var resRe = db.select(branchSqlRe);
Set reviewresSet = new HashSet();
reviewresSet.addAll(repoRe);
reviewresSet.addAll(resRe);
HashMap map = new HashMap();
map.put("approvers",appres);
map.put("reviewers",reviewresSet);
return map;

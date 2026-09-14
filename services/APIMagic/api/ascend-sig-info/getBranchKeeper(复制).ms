{

  "properties" : { },

  "id" : "copy1745996506108d69929",

  "script" : null,

  "groupId" : "d5e2698221b04b24a983f69b712ad2e4",

  "name" : "getBranchKeeper(复制)",

  "createTime" : null,

  "updateTime" : 1745996562720,

  "lock" : null,

  "createBy" : null,

  "updateBy" : "admin",

  "path" : "/getBranchKeeper",

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

    "children" :[ {

      "name" : "repo",

      "validateType" : "pattern",

      "expression" : "^[a-zA-Z0-9_/-]+$",

      "error" : "repo 格式非法",

      "children" : null

      }, {

      "name" : "org",

      "validateType" : "pattern",

      "expression" : "^[a-zA-Z0-9_/-]+$",

      "error" : "org 格式非法",

      "children" : null

    }, {

      "name" : "branch",

      "validateType" : "pattern",

      "expression" : "^[a-zA-Z0-9_/-]+$",

      "error" : "branch 格式非法",

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
   where repo_name=#{repo} and sig_name=#{org} and branch_name is null and permission_type='keeper'
""";
var repoApp = db.select(sql);
var  branchSql = """
  select distinct b.* from fact_mindie_sig_user_permissions 
  a left join fact_mindie_sig_users b on a.user_gitcode_id=b.gitcode_id
   where repo_name=#{repo} and sig_name=#{org} and branch_name =#{branch} and permission_type='keeper'
""";
var branchapp = db.select(branchSql);
Set appres = new HashSet();
appres.addAll(repoApp)
appres.addAll(branchapp)
return appres;

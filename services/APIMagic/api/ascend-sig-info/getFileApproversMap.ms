{

  "properties" : { },

  "id" : "copy1745982268173d48983",

  "script" : null,

  "groupId" : "d5e2698221b04b24a983f69b712ad2e4",

  "name" : "getFileApproversMap",

  "createTime" : null,

  "updateTime" : 1745996462999,

  "lock" : null,

  "createBy" : null,

  "updateBy" : "admin",

  "path" : "/getFileApproversMap",

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

  "requestBody" : "{\r\n    \"repo\":\"ascend/MindIE-Service\",\r\n    \"org\":\"hccl\",\r\n    \"branch\":\"master\",\r\n    \"files\":[\"/cmake/figures\",\"/cmake/figures2\"]\r\n}",

  "headers" : [ ],

  "paths" : [ ],

  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"/cmake/figures\": [{\n            \"gitcode_id\": \"towncharlie\",\n            \"name\": \"towncharlie\",\n            \"email\": \"towncharlie@yahoo.com\"\n        }, {\n            \"gitcode_id\": \"coding-lz\",\n            \"name\": \"coding-lz\",\n            \"email\": \"coding-lz@yahoo.com\"\n        }, {\n            \"gitcode_id\": \"git_ray\",\n            \"name\": \"git_ray\",\n            \"email\": \"git_ray@google.com\"\n        }]\n    },\n    \"timestamp\": 1745996449718,\n    \"executeTime\": 10\n}",

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

    }, {

      "name" : "files",

      "validateType" : "pattern",

      "expression" : "^[a-zA-Z0-9_/-]+$",

      "error" : "files 元素格式非法",

      "children" : null

    } ]

  },

  "responseBodyDefinition" : null

}

================================
var org = body.org;
var repo = body.repo;
var branch = body.branch;
var files = body.files;
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
var  pathSql = """
  select distinct a.*,b.* from fact_mindie_sig_user_permissions 
  a left join fact_mindie_sig_users b on a.user_gitcode_id=b.gitcode_id where 1=1 
       <if test="files != null and files.size() > 0">
       and  path_path in 
        <foreach collection="files" item="item" separator=", " open="(" close=")">
             #{item}
        </foreach>
    </if>
    and permission_type='approver'
""";
var pathApp = db.select(pathSql);
Set appres = new HashSet();
appres.addAll(repoApp)
appres.addAll(branchapp)
Map res = new HashMap();
for (filePath in files) {
    Set tem = res.getOrDefault(filePath,new HashSet());
    tem.addAll(appres);
    res.put(filePath,tem)
}
System.out.print(res)
System.out.print(res)
for (item in pathApp){
    Map me = new HashMap();
    me.put("gitcode_id",item.get("gitcode_id"));
    me.put("name",item.get("name"));
    me.put("email",item.get("email"));
    res.get(item.get("path_path")).add(me);
}
// var  sqlRe = """
//   select distinct b.* from fact_mindie_sig_user_permissions 
//   a left join fact_mindie_sig_users b on a.user_gitcode_id=b.gitcode_id
//    where repo_name='${repo}' and sig_name='${org}' and branch_name is null and permission_type='reviewer'
// """;
// var repoRe = db.select(sqlRe);
// var  branchSqlRe = """
//   select distinct b.* from fact_mindie_sig_user_permissions 
//   a left join fact_mindie_sig_users b on a.user_gitcode_id=b.gitcode_id
//    where repo_name='${repo}' and sig_name='${org}' and branch_name ='${branch}' and permission_type='reviewer'
// """;
// var resRe = db.select(branchSqlRe);
// Set reviewresSet = new HashSet();
// reviewresSet.addAll(repoRe);
// reviewresSet.addAll(resRe);
// HashMap map = new HashMap();
// map.put("approvers",appres);
// map.put("reviewers",reviewresSet);
return res;

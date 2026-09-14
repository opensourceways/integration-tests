{
  "properties" : { },
  "id" : "copy1765440393528d50628",
  "script" : null,
  "groupId" : "a513b1f12b714736abc308a60d73a9e6",
  "name" : "robot使用接口",
  "createTime" : null,
  "updateTime" : 1777292542701,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/sig/robot/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "opengauss",
    "description" : "community参数目前只支持openubmc|openfuyao|openFuyao|BoostKit|boostkit|openUBMC|openEuler|openeuler",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : "community参数非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "repo",
    "value" : "opengauss/oG-Memory",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "repo 格式非法",
    "expression" : "^[a-zA-Z0-9._/-]*$",
    "children" : null
  }, {
    "name" : "sig",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "sig 格式非法",
    "expression" : "",
    "children" : null
  } ],
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"maintainers\": [\"CarrotGo\", \"chendong76\", \"chenxiaobin19\", \"congzhou2603\", \"dodders\", \"hwworkholic\", \"jemappellehc\", \"muyulinzhong\", \"quemingjian\", \"shenzheng4\", \"shirley_zhengx\", \"superlchf\", \"totaj\", \"wlff234\", \"ywzq1161327784\"],\n        \"repositories\": [{\n            \"repo_detail\": null\n        }],\n        \"committers\": [\"jiangyan_jack\", \"libiao2024\", \"liuzhanfeng\", \"zkcarl\", \"zym_2025\"],\n        \"repos\": [],\n        \"branch_keepers\": [],\n        \"sig_name\": \"Community\",\n        \"repo_admin\": []\n    }],\n    \"timestamp\": 1776157572381,\n    \"executeTime\": 8\n}",
  "description" : null,
  "requestBodyDefinition" : null,
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
          "name" : "maintainers",
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
            "value" : "CarrotGo",
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
        }, {
          "name" : "repositories",
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
              "name" : "repo_detail",
              "value" : "null",
              "description" : "",
              "required" : false,
              "dataType" : "Object",
              "type" : null,
              "defaultValue" : null,
              "validateType" : "",
              "error" : "",
              "expression" : "",
              "children" : [ ]
            } ]
          } ]
        }, {
          "name" : "committers",
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
            "value" : "jiangyan_jack",
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
        }, {
          "name" : "repos",
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
          "name" : "branch_keepers",
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
          "name" : "sig_name",
          "value" : "Community",
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
          "name" : "repo_admin",
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
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1776157572381",
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

import java.lang.reflect.Array

import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;







var repo_path= repo;

var sig_name= sig;

var community_tem= community;



if ("openeuler".equals(community_tem)){

    community = "openeulerrobot";

}

if ("opengauss".equals(community_tem)){

    community = "opengaussrobot";

}
if ("mindspore".equals(community_tem)){

    community = "mindsporeatomgit";

}



ArrayList resList = new ArrayList();

HashMap result  = new HashMap()

result.put("sig_name","");

result.put("repositories",new ArrayList());

result.put("maintainers",new HashSet());

result.put("committers",new HashSet());

result.put("repo_admin",new HashSet());



result.put("repos",new ArrayList());

var sql = "";

if(null!=repo_path && !"".equals(repo_path) && repo_path.contains("/")){

    var ss = repo_path.split("/")

    var repo = ss[1]

    var namespace = ss[0]

    var letternamespace = namespace.toLowerCase()

    var userListSql = """ select distinct user_login,role,sig_name,platform from fact_${community}_sig_user where LOWER(namespace) = LOWER(#{namespace}) 

    and  LOWER(repo_path) = LOWER(#{repo}) and is_removed is NULL and user_login !='' """;

    var userList = db.select(userListSql)

    var userListMap = userList.group(item=>item.sig_name);

    var repo_path_tem = letternamespace+"/" + repo;



    for ( entry  in userListMap.entrySet()) {

        HashMap resultTemp  = new HashMap()

        resultTemp.put("sig_name","");

        resultTemp.put("repositories",new ArrayList());

        resultTemp.put("maintainers",new ArrayList());

        resultTemp.put("committers",new ArrayList());

        resultTemp.put("repo_admin",new ArrayList());

        resultTemp.put("repos",new ArrayList());

        var key = entry.getKey();      // 获取 key

        resultTemp.put("sig_name",key);

        var platform = "gitee"

        var value = entry.getValue();    // 获取 value

        if(value!= null && value.size()>0){

            platform = value.get(0).get("platform");

            for( item in value){

                if("maintainer".equals(item.get("role"))){

                    resultTemp.get("maintainers").add(item.get("user_login"))

                }else if("committer".equals(item.get("role"))){

                    resultTemp.get("committers").add(item.get("user_login"))

                }else if("repo_admin".equals(item.get("role"))){

                    resultTemp.get("repo_admin").add(item.get("user_login"))

                }

                

            }

        }

        var robotsql = """select content from fact_${community}_sig_robot_info where sig_name=#{key} and LOWER(repo_path) = LOWER(#{repo_path}) """;

        var resp = db.select(robotsql)

        HashMap  repo_detail_map = new HashMap();

        if(resp!= null && resp.size()>0){

            var sig_info = resp[0]['content']::json

            var branchs = sig_info.getOrDefault('branches',new ArrayList());

            for ( branch in branchs) {

                branch.put("name",""+branch.getOrDefault("name",''));

            }

            repo_detail_map.put("repo_detail",sig_info);

            

        }else{

            repo_detail_map.put("repo_detail",null);

        }

        resultTemp.get("repositories").add(repo_detail_map)

        var branch_keepers_sql = """ select sig_name,sig_json from fact_${community}_sig_detail_info where sig_name=#{key}  """;

        var resp_keepers = db.select(branch_keepers_sql)

        var keepers = new ArrayList();

        if(resp_keepers!= null && resp_keepers.size()>0){

            var sig_keepers_info = resp_keepers[0]['sig_json']::json

            var branches = sig_keepers_info.getOrDefault("branches",new ArrayList());

            for ( branchObj in branches) {

                // 检查repo_branch

                var keeperList = branchObj.getOrDefault("keeper",new ArrayList());

                var keeperset = new HashSet();

                for(keeper in keeperList){

                    keeperset.add(keeper.get(platform+"_id"))

                }

                if (branchObj.containsKey("repo_branch")) {

                   var repoBranches =branchObj.getOrDefault("repo_branch",new ArrayList());

                    for (repoBranch in repoBranches) {

                        

                        if (repoBranch.get("repo").equals(repo_path) || repoBranch.equals(repo_path_tem)) {

                            repoBranch.put("keeper",keeperset);

                            keepers.add(repoBranch);

                        }

                        

                        

                    }

                }

            }

        }    

        resultTemp.put("branch_keepers",keepers)

        resList.add(resultTemp)



    }



    



    return resList;



    

}else{

   

    if(null!=sig_name && !"".equals(sig_name)){

        sql = """select distinct concat(namespace,'/',repo_path) as repo,user_login,role from fact_${community}_sig_user where  sig_name=#{sig_name}"""

        var repos = db.select(sql)

        var repoSets = new HashSet();



        var committerDetails = new ArrayList()

        var repoMap = new HashMap();

        result.put("sig_name",sig_name);

        if(repos!= null && repos.size()>0){

            for( item in repos){

                var repo=item.get("repo");

                var user_login=item.get("user_login");

                var role=item.get("role");               

                if(null!=user_login&&!"".equals(user_login) && "maintainer".equals(role)){

                    result.get("maintainers").add(user_login)

                }

                if(null!=user_login&&!"".equals(user_login) && "committer".equals(role)){

                    result.get("committers").add(user_login)

                }

                repoSets.add(repo)

                if(!repoMap.containsKey(repo)){

                    repoMap.put(repo,new HashSet())

                    if(null!=user_login&&!"".equals(user_login) && "committer".equals(role)){

                        repoMap.get(repo).add(user_login)

                    }

                }else{

                    if(null!=user_login&&!"".equals(user_login) && "committer".equals(role)){

                        repoMap.get(repo).add(user_login)

                    }

                }

            }

        }

        var entrys = repoMap.entrySet();

        for(entry in entrys){

            var map = new HashMap();

            map.put("repo",entry.getKey());

            map.put("committers",entry.getValue())

            committerDetails.add(map)

        }

        result.put("committerDetails",committerDetails);



    }else{

        var letternamespace = repo_path.toLowerCase()

        sql = """select distinct concat(namespace,'/',repo_path) as repo,sig_name from fact_${community}_sig_user where  LOWER(namespace) = LOWER(#{repo_path}) """

        var repos = db.select(sql)

        var sig_names = new HashSet();



        if(repos!= null && repos.size()>0){

            for( item in repos){

                result.get("repos").add(item.get("repo"))

                sig_names.add(item.get("sig_name"))

            }

            result.put("sig_list",sig_names)

        

        }

    }

   

    resList.add(result)



}







return resList 
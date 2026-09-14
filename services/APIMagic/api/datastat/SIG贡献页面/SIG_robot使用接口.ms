{
  "properties" : { },
  "id" : "3470162fdff64b75a802dc0a4c00c1be",
  "script" : null,
  "groupId" : "a513b1f12b714736abc308a60d73a9e6",
  "name" : "SIG_robot使用接口",
  "createTime" : null,
  "updateTime" : 1778566879146,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/sig/detail/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "boostkit",
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
    "value" : "doc",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "repo 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "sigName",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"maintainers\": [],\n        \"repositories\": [],\n        \"committers\": [],\n        \"repos\": [],\n        \"sig_name\": \"\"\n    }],\n    \"timestamp\": 1778566848656,\n    \"executeTime\": 3\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;
var repo_path= repo;
var sig_name= sigName;
var community= community;
ArrayList resList = new ArrayList();
HashMap result  = new HashMap()
result.put("sig_name","");
result.put("repositories",new ArrayList());
result.put("maintainers",new ArrayList());
result.put("committers",new ArrayList());
result.put("repos",new ArrayList());
var sql = "";
if(null!=repo_path && !"".equals(repo_path) && repo_path.contains("/")){
    var ss = repo_path.split("/")
    var repo = ss[1]
    var namespace = ss[0]
    var letternamespace = namespace.toLowerCase()
    var userListSql = """select user_login,role,sig_name from fact_${community}_sig_user where (namespace=#{namespace} or namespace=#{letternamespace} ) and repo_path=#{repo} and is_removed is NULL and user_login !='' """;
    var userList = db.select(userListSql)
    var userListMap = userList.group(item=>item.sig_name);
    var repo_path_tem = letternamespace+"/" + repo;
    for ( entry  in userListMap.entrySet()) {
        HashMap resultTemp  = new HashMap()
        resultTemp.put("sig_name","");
        resultTemp.put("repositories",new ArrayList());
        resultTemp.put("maintainers",new ArrayList());
        resultTemp.put("committers",new ArrayList());
        resultTemp.put("repos",new ArrayList());
        var key = entry.getKey();      // 获取 key
        resultTemp.put("sig_name",key);
        var value = entry.getValue();    // 获取 value
        if(value!= null && value.size()>0){
            for( item in value){
                if("maintainer".equals(item.get("role"))){
                    resultTemp.get("maintainers").add(item.get("user_login"))
                }else if("committer".equals(item.get("role"))){
                    resultTemp.get("committers").add(item.get("user_login"))
                }
            }
        }
        var robotsql = """select content from fact_${community}_sig_robot_info where sig_name=#{key} and (repo_path=#{repo_path} or  repo_path=#{repo_path_tem}) """;
        var resp = db.select(robotsql)
        HashMap  repo_detail_map = new HashMap();
        if(resp!= null && resp.size()>0){
            var sig_info = resp[0]['content']::json
            repo_detail_map.put("repo_detail",sig_info);
        }else{
            repo_detail_map.put("repo_detail",null);
        }
        resultTemp.get("repositories").add(repo_detail_map)
        resList.add(resultTemp)
    }
    return resList;
}else{
    var letternamespace = repo_path.toLowerCase()
    if(null!=sig_name && !"".equals(sig_name)){
        sql = """select distinct concat(namespace,'/',repo_path) as repo from fact_${community}_sig_user where (namespace=#{repo_path} or namespace=#{letternamespace} ) and sig_name=#{sig_name}"""
        var repos = db.select(sql)
        if(repos!= null && repos.size()>0){
            for( item in repos){
                result.get("repos").add(item.get("repo"))
            }
        }
    }else{
        sql = """select distinct concat(namespace,'/',repo_path) as repo from fact_${community}_sig_user where (namespace=#{repo_path} or namespace=#{letternamespace} )"""
    }
    var repos = db.select(sql)
    if(repos!= null && repos.size()>0){
        for( item in repos){
            result.get("repos").add(item.get("repo"))
        }       
    }
    resList.add(result)
}
return resList 

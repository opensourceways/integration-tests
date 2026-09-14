{
  "properties" : { },
  "id" : "01775d0ea56044e1ac5d89fff0f28574",
  "script" : null,
  "groupId" : "b5afacecc6d04e3799ee923b67f74047",
  "name" : "官网获取sig信息",
  "createTime" : null,
  "updateTime" : 1776157084900,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/sig/query",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "opengauss",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^[a-zA-Z]{1,32}$",
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
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"community 参数非法\",\n    \"data\": null,\n    \"timestamp\": 1773920580166,\n    \"executeTime\": 0\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import java.lang.reflect.Array
var community_temp = community
if ("ascend".equals(community_temp) || "Ascend".equals(community_temp) ){
    community_temp = "ascendpublic"
}
if ("mindspore".equals(community_temp) || "Mindspore".equals(community_temp) ){
    community_temp = "mindsporeatomgit"
}
var sig_tem = sig
var sigSql = """select * from fact_${community_temp}_sig_detail_info where is_removed is null
                 <if test="sig_tem != null and sig_tem != ''">
                       and sig_name=#{sig_tem}
                 </if>
                 """;
var platformsel = """select platform from fact_${community_temp}_sig_user limit 1 """;
HashMap res = new HashMap();
var sigs = db.select(sigSql);
ArrayList sigjsonList = new ArrayList();
var platform = db.selectOne(platformsel);
if(null == platform){
    return res
}
var platform_tem = platform.get("platform")+"_id";
var committerssql = """select distinct sig_name,user_login as ${platform_tem},user_login,email,user_name as name,role from fact_${community_temp}_sig_user where role='committer'
                        <if test="sig_tem != null and sig_tem != ''">
                              and  sig_name=#{sig_tem}
                        </if>
                         and user_login is not null """;
var committerList = db.select(committerssql);
var committerMap = new HashMap()
if(null!=committerList&&committerList.size()>0){
    committerMap =committerList.group(item=>item.sig_name)
}
// 查看sig的所有maintainers
for( item in sigs){
    var sig_name = item.get("sig_name");
   var sig_content = item.get("sig_json")::json;
    var repos = []
    for (key in sig_content.getOrDefault('repositories',new ArrayList())) {
        var ss = key.get("repo")
        if(ss != null && ss instanceof Collection){
            repos.addAll(ss);
        }else if (ss != null && ss instanceof String){
            repos.add(ss)
        }
    }
    var maintainers = []
    for (key in sig_content.getOrDefault('maintainers',new ArrayList())) {
        if(key[platform_tem]!=null){
            maintainers.add(key[platform_tem])
            continue;
        }
        if(key["user_login"]!=null){
            maintainers.add(key["user_login"])
            continue;
        }
    }
    var committes_list = [];
    committers = committerMap.getOrDefault(sig_name,new ArrayList())
    for (key in committers) {
        committes_list.add(key["user_login"])
    }
    sig_content.put("maintainer_info",sig_content.getOrDefault('maintainers',new ArrayList()));
    sig_content.put("maintainers",maintainers);
    sig_content.put("committers",committes_list);
    sig_content.put("committer_info",committers);
    sig_content.put("repo_count",repos.size());
    sig_content.put("repos",repos);
    sigjsonList.add(sig_content)
}
return sigjsonList

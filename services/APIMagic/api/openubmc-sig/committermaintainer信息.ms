{
  "properties" : { },
  "id" : "922dbd8523a7418cb08841cbd6f844bc",
  "script" : null,
  "groupId" : "65bc0dd42a4b46efbe719d7ba3a94731",
  "name" : "committermaintainer信息",
  "createTime" : null,
  "updateTime" : 1774314785452,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/sig/userdetials",
  "method" : "GET",
  "parameters" : [ {
    "name" : "sigName",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "sigName 格式非法",
    "expression" : "",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"timestamp\": \"2025-06-30 14:27:02\",\n    \"status\": 500,\n    \"error\": \"Internal Server Error\",\n    \"path\": \"/openubmc/sig/info\"\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sigName = sigName;
HashMap res = new HashMap();
var committersql = """   select distinct a.user_login as gitcode_id,a.user_name as name,a.sig_name,b.email from  fact_openubmc_sig_user a 
   left join fact_openubmc_authing_user  b on a.user_login = b.user_login
    where a.sig_name=#{sigName} and a.role='committer' and b.email !='' and is_removed is null""";
var committers = db.select(committersql);
System.out.print(committers)
HashMap committersMap = new HashMap();
for(committer in committers){
    if(committersMap.containsKey(committer.get("gitcode_id"))){
        if (null != committer.get("email") && "".equals(committer.get("email"))){
            committersMap.put(committer.get("gitcode_id"),committer)
        }
    }else{
        committersMap.put(committer.get("gitcode_id"),committer)
    }
}
res.put("committers",committersMap.values());
var maintainersql = """   
  select distinct a.user_login as gitcode_id,a.user_name as name,a.sig_name,b.email from  fact_openubmc_sig_user a 
  left join fact_openubmc_authing_user b on a.user_login = b.user_login
   where a.sig_name=#{sigName} and a.role='maintainer' and b.email !='' and  is_removed is null""";
var maintainers = db.select(maintainersql);
HashMap maintainersMap = new HashMap();
for(maintainer in maintainers){
    if(maintainersMap.containsKey(maintainer.get("gitcode_id"))){
        if (null != maintainer.get("email") && "".equals(maintainer.get("email"))){
            committersMap.put(maintainer.get("gitcode_id"),maintainer)
        }
    }else{
        maintainersMap.put(maintainer.get("gitcode_id"),maintainer)
    }
}
res.put("maintainers",maintainersMap.values());
return res

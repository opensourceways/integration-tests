{
  "properties" : { },
  "id" : "711a48d5b6874a189e36aedf9e980ce1",
  "script" : null,
  "groupId" : "5eed1b66d5ab454f80312cee5f30f81e",
  "name" : "committermaintainer信息",
  "createTime" : null,
  "updateTime" : 1775550347744,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/sig/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "sigName",
    "value" : "infrastructure",
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
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1774314767602,\n    \"executeTime\": 8\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sigName = sigName;
HashMap res = new HashMap();
var committersql = """                  
SELECT DISTINCT 
    a.user_login AS gitcode_id,
    COALESCE(
        NULLIF(TRIM(a.email), ''), 
        b.email
    ) AS email
FROM fact_openubmc_sig_user a 
LEFT JOIN fact_openubmc_authing_user b 
    ON a.user_login = b.user_login
WHERE 
    a.sig_name = 'TC' 
    AND a.role IN ('committer', 'maintainer')
    AND (
        (a.email IS NOT NULL AND TRIM(a.email) != '')
        OR 
        (a.email IS NULL OR TRIM(a.email) = '') AND (b.email IS NOT NULL AND TRIM(b.email) != '')
    )""";
var committers = db.select(committersql);
HashMap committersMap = new HashMap();
for(committer in committers){
    if(!committersMap.containsKey(committer.get("gitcode_id"))){
       committersMap.put(committer.get("gitcode_id"),committer.get("email"))
    }
}
var detailSql = """   
  select * from fact_openubmc_sig_detail_info where sig_name=#{sigName}""";
var detail = db.selectOne(detailSql);
var res = {}
var sig_info = detail['sig_json']::json
var maintainers = sig_info.get('maintainers') || []
for (maintin in maintainers) {
    maintin.put('email',committersMap.get(maintin.get("gitcode_id")))
}
var committers = new HashSet()
var commSet = new HashSet()
if (sig_info.containsKey('repositories')) {
    for (key in sig_info.getOrDefault('repositories',new ArrayList())) {
        if (key.containsKey('committers')) {
            var committersTemp = key.getOrDefault('committers',new ArrayList())
            for (com in committersTemp) {
                if(!commSet.contains(com.get("gitcode_id"))){
                    commSet.add(com.get("gitcode_id"))
                    com.put('email',committersMap.get(com.get("gitcode_id")))
                    committers.add(com)
                }
            }
        }
    }
}
res.put("committers",committers)
res.put("maintainers",maintainers)
return res

{
  "properties" : { },
  "id" : "dc8ba2ea624947438909a69f4193e7dd",
  "script" : null,
  "groupId" : "521ef640123a4ae79386e6a38b8df4ad",
  "name" : "检查邮箱",
  "createTime" : null,
  "updateTime" : 1774578115739,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/whitebox/checkemail",
  "method" : "GET",
  "parameters" : [ {
    "name" : "id",
    "value" : "3432",
    "description" : "当type为commit时，id为commit id,当type为pr时，为pr number，当type为comment时，为comment id",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "id 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]+$",
    "children" : null
  }, {
    "name" : "platform",
    "value" : "gitee",
    "description" : "只支持gitee|gitcode|github",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "只支持gitee|gitcode|github",
    "expression" : "^(gitee|gitcode|github)$",
    "children" : null
  }, {
    "name" : "repo",
    "value" : "ddd/cc",
    "description" : "只支持全路径示例： Ascend/test",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "repo 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]+$",
    "children" : null
  }, {
    "name" : "type",
    "value" : "commit",
    "description" : "只支持pr|commit|comment",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "只支持pr|commit|comment",
    "expression" : "^(pr|commit|comment)$",
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
  }, {
    "name" : "permission",
    "value" : "datastat",
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"只支持gitee|gitcode|github\",\n    \"data\": null,\n    \"timestamp\": 1774578094135,\n    \"executeTime\": 0\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import org.ssssssss.script.parsing.ast.statement.Return
import hwcloud;
var type_tem = type;
var platform_tem = platform;
var repo_tem = repo;
var id_tem = id;
var sql = """select msg,type,id,platform,repo, EXTRACT(EPOCH FROM (NOW() - created_at)) AS seconds_diff from fact_whitebox_check  where id =#{id_tem}"""
var res = db.select(sql)
// 华为云 AK/SK 签名（SDK-HMAC-SHA256，经 hwcloud 模块），ak/sk 存 PG fact_token(platform='huawei_cloud_ak'/'huawei_cloud_sk')
var akRow = db.select("""
        SELECT
            token
        FROM fact_token
        WHERE platform = 'huawei_cloud_ak'
        """)
var skRow = db.select("""
        SELECT
            token
        FROM fact_token
        WHERE platform = 'huawei_cloud_sk'
        """)
if(res!=null&&res.size()>0){
    if(res.get(0).get("seconds_diff")>120){
        var resp = hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "whitebox_check_test", [
                {
                    "name": "type",
                    "value": type_tem
                },
                        {
                    "name": "repo",
                    "value": repo_tem
                },
                        {
                    "name": "id",
                    "value": id_tem
                },
                        {
                    "name": "platform",
                    "value": platform_tem
                }
            ])
    }
    return res.get(0)
}else{
    var resp = hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "whitebox_check_test", [
            {
                "name": "type",
                "value": type_tem
            },
                    {
                "name": "repo",
                "value": repo_tem
            },
                    {
                "name": "id",
                "value": id_tem
            },
                    {
                "name": "platform",
                "value": platform_tem
            }
        ])
    return {msg:"正在查询相关数据，请2分钟后查询使用相同的条件查询结果"}
}

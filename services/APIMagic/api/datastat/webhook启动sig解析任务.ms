{
  "properties" : { },
  "id" : "37fa0fd833f14bbe9d767e54a9d27882",
  "script" : null,
  "groupId" : "521ef640123a4ae79386e6a38b8df4ad",
  "name" : "webhook启动sig解析任务",
  "createTime" : null,
  "updateTime" : 1777292824823,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/exec/sigjob",
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
    "expression" : "^(openeuler|OpenEuler|opengauss|openGauss|openubmc|openUBMC)$",
    "children" : null
  }, {
    "name" : "token",
    "value" : "132232",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "token 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]+$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"msg\": \"采集任务已经启动，请稍后验证数据是否更新\"\n    },\n    \"timestamp\": 1777292677384,\n    \"executeTime\": 107\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import org.ssssssss.script.parsing.ast.statement.Return
import hwcloud;
var community_tem = community;
var sql = """select msg,type,id,platform,repo from fact_whitebox_check  where id =#{id_tem}"""
var res = db.select(sql)
if(res!=null&&res.size()>0){
    return res.get(0)
}else{
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
    var resp = hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "pro_sig_info_task", [
            {
                "name": "community",
                "value": community_tem
            }
        ])
    return {msg:"采集任务已经启动，请稍后验证数据是否更新"}
}

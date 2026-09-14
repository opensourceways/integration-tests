{
  "properties" : { },
  "id" : "dataarts_run_job_aksk_0000000001",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "触发DataArts作业(AKSK)",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/dataarts/run-job",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "admin_token",
    "description" : "跨社区管理员 key（admin_token，请求头带 api-key）",
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
  "headers" : [ {
    "name" : "api-key",
    "value" : "",
    "description" : "管理员 key（admin_token 权限）",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : "issue#1420：以华为云 AK/SK 请求签名（SDK-HMAC-SHA256）直接触发 DataArts DLF 作业（run-immediate），不再依赖预取 IAM Token。ak/sk 从 PG fact_token(platform='huawei_cloud_ak'/'huawei_cloud_sk') 读取（Vault 注入库，绝不入仓）。endpoint/projectId/workspace 由后端 HuaweiCloudModule 配置注入（huaweicloud.dataarts.*），不暴露在脚本接口中。admin_token 权限（请求头 api-key）。body: {\"jobName\":\"job_radar\",\"jobParams\":[...]}",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// issue#1420：AK/SK 签名方式触发 DataArts 作业（替代 x-auth-token IAM Token 方案）
// ak/sk 存 PG fact_token(platform='huawei_cloud_ak'/'huawei_cloud_sk')，由 Vault 注入库，绝不入仓
// endpoint/projectId/workspace 由后端 HuaweiCloudModule 配置注入，不写在脚本里
import hwcloud;
import response;

var jobName = body != null ? body.jobName : null
if (jobName == null || jobName == '') {
    return response.json({code: -1, message: "jobName 不能为空"})
}
var jobParams = (body != null && body.jobParams != null) ? body.jobParams : []

var akRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_ak'")
var skRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_sk'")
if (akRow.size() == 0 || skRow.size() == 0) {
    return response.json({code: -1, message: "未配置华为云 ak/sk（fact_token: huawei_cloud_ak/huawei_cloud_sk）"})
}
var ak = akRow[0]["token"]
var sk = skRow[0]["token"]

try {
    var resp = hwcloud.runJob(ak, sk, jobName, jobParams)
    var status = resp.status
    if (status >= 200 && status < 300) {
        return response.json({code: 1, message: "已触发作业(" + jobName + ")", data: {status: status}})
    }
    return response.json({code: -1, message: "触发失败，状态码: " + status, data: {status: status}})
} catch (e) {
    return response.json({code: -1, message: "触发失败: " + e.getMessage()})
}

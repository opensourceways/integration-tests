{
  "properties" : { },
  "id" : "wb1153diagnosesync0000000000001",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "触发同步到蓝区贡献表(诊断树)",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/diagnose-sync",
  "method" : "GET",
  "parameters" : [
    { "name" : "gitcode_id", "value" : "", "description" : "", "required" : false, "dataType" : "String", "validateType" : "pattern", "error" : "gitcode_id 格式非法", "expression" : "^[a-zA-Z0-9_/-]*$" },
    { "name" : "gitee_id", "value" : "", "description" : "", "required" : false, "dataType" : "String", "validateType" : "pattern", "error" : "gitee_id 格式非法", "expression" : "^[a-zA-Z0-9_/-]*$" },
    { "name" : "github_id", "value" : "", "description" : "", "required" : false, "dataType" : "String", "validateType" : "pattern", "error" : "github_id 格式非法", "expression" : "^[a-zA-Z0-9_/-]*$" },
    { "name" : "community", "value" : "", "description" : "可选，仅记录用；whitebox_blue_user 按账号抽取不需要", "required" : false, "dataType" : "String", "validateType" : "pattern", "error" : "格式非法", "expression" : "^[a-zA-Z0-9_-]*$" },
    { "name" : "start_time", "value" : "2026-01-01", "description" : "yyyy-mm-dd", "required" : false, "dataType" : "String", "validateType" : "pattern", "error" : "start_time 格式应为 yyyy-MM-dd", "expression" : "^(\\d{4}-\\d{2}-\\d{2})?$" }
  ],
  "options" : [
    { "name" : "permission", "value" : "datastatwhitebox_view", "description" : "白盒管理员权限（登录用户 token 校验，前端无需带密钥）", "required" : false, "dataType" : "String" },
    { "name" : "wrap_request_parameter", "value" : "disable-cache", "required" : false, "dataType" : "String" }
  ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"已触发同步任务，请约 10 分钟后点刷新查看\"\n}",
  "description" : "issue#1153 诊断树「同步」按钮：触发华为云 DataArts whitebox_blue_user 作业，按账号(gitcode_id/gitee_id/github_id)从 start_time 起同步该用户贡献到 ES blue_zone_user_contributes（与洞察/雷达同款 DLF run-immediate）。datastatwhitebox_view 权限（登录用户 token 校验，前端零密钥）。同步完成后由 blue_contribute_sync 落地 PG fact_all_blue_contribute，诊断读 PG。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// issue#1153 诊断树「同步」按钮 → 触发 DataArts whitebox_blue_user（run-immediate）
// 与 datastat/塔台蓝区代码贡献.ms 同款；华为云 AK/SK 签名（SDK-HMAC-SHA256，经 hwcloud 模块），
// ak/sk 存 PG fact_token(platform='huawei_cloud_ak'/'huawei_cloud_sk')
import hwcloud;
// 裸判空（== null || == ''），不引第三方库，避免额外 CVE 维护
if ((gitcode_id == null || gitcode_id == '') && (gitee_id == null || gitee_id == '') && (github_id == null || github_id == '')) {
    return {code: -1, message: "gitcode_id/gitee_id/github_id 至少填一个"}
}
var st = (start_time == null || start_time == '') ? "2026-01-01" : start_time
try {
    var akRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_ak'");
    var skRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_sk'");
    var resp = hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "whitebox_blue_user", [
        { "name": "gitcode_id", "value": gitcode_id },
        { "name": "gitee_id", "value": gitee_id },
        { "name": "github_id", "value": github_id },
        { "name": "start_time", "value": st }
    ]);
    if (resp.status < 200 || resp.status >= 300) {
        return {code: -1, message: "触发同步失败，状态码：" + resp.status}
    }
} catch (e) {
    return {code: -1, message: "触发同步失败：" + e.getMessage()}
}
return {code: 1, message: "已触发同步任务（whitebox_blue_user），请约 10 分钟后点刷新查看", data: {triggered: true}}

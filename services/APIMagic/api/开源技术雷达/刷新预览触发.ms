{
  "properties": {},
  "id": "oss_insight_refresh",
  "script": null,
  "groupId": "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name": "刷新预览触发",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/oss-insight/refresh",
  "method": "POST",
  "parameters": [],
  "options": [
    {
      "name": "permission",
      "value": "admin_token",
      "description": "跨社区管理员 key（admin_token，请求头带 api-key）",
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": null,
      "error": null,
      "expression": null,
      "children": null
    },
    {
      "name": "wrap_request_parameter",
      "value": "disable-cache",
      "description": "包装请求参数到一个变量中",
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": null,
      "error": null,
      "expression": null,
      "children": null
    }
  ],
  "requestBody": "",
  "headers": [
    {
      "name": "api-key",
      "value": "",
      "description": "管理员 key（admin_token 权限）",
      "required": true,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": null,
      "error": null,
      "expression": null,
      "children": null
    }
  ],
  "paths": [],
  "responseBody": null,
  "description": "oss-insight issue 关闭 / PR 同步 workflow 回调，触发 DataArts job_radar 刷新需求状态（审阅中→已发布）。admin_token 权限（请求头 api-key）",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
import hwcloud;
// 服务间触发（webhook 回调）：admin_token 权限，请求头带 api-key，由 UpdatePermissionInterceptor 校验，免登录。
// oss-insight 的「issue 关闭 / 同步 PR 信息」workflow 回调本接口 → 触发 DataArts job_radar 刷新预览/需求状态。
// 华为云 AK/SK 签名（SDK-HMAC-SHA256，经 hwcloud 模块），ak/sk 存 PG fact_token(platform='huawei_cloud_ak'/'huawei_cloud_sk')
try {
  var akRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_ak'");
  var skRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_sk'");
  var resp = hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "job_radar", []);
  if (resp.status >= 200 && resp.status < 300) {
    return {code: 1, message: '已触发 job_radar', data: resp.status};
  }
  return {code: -1, message: '触发失败，状态码: ' + resp.status};
} catch (e) {
  return {code: -1, message: '触发失败: ' + e};
}
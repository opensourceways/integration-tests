{
  "properties": {},
  "id": "ttfhw_submit",
  "script": null,
  "groupId": "ttfhwgroup0000000000000000000001",
  "name": "提交问题",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/submit",
  "method": "POST",
  "parameters": [],
  "options": [
    {
      "name": "permission",
      "value": "datastatadmin_View",
      "description": "允许拥有该权限的访问",
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
  "requestBody": "{\n  \"ids\": [1],\n  \"confirmer\": \"zhongjun2\"\n}",
  "headers": [],
  "paths": [],
  "responseBody": "{\n  \"code\": 1,\n  \"list\": [{\"id\":1,\"issue_url\":\"https://gitcode.com/...\"}]\n}",
  "description": null,
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
import hwcloud;
// 批量把选中问题打标为「是问题」(issue_url 留空)，并触发 DataArts job ttfhw_pipeline。
// 真正建 gitcode issue + 读 token 交给 om-dataarts 后台任务（从 service_platform_config 读、AES 解密），
// 扫 confirm_result='是' AND issue_url IS NULL 的行建 issue 回填 issue_url —— 与「洞察需求」同一套路。
// issue 正文由 om-dataarts 提交时现拼（不存 body、不含任何环境相关 URL），前端只传 ids。
var ids = body.ids;
var confirmer = body.confirmer;
if (ids == null || ids.size() == 0) { return {code: -1, message: 'ids 不能为空'} }
if (confirmer == null || confirmer == '') { return {code: -1, message: 'confirmer 不能为空'} }
var out = [];
for (id in ids) {
    var n = db.update("UPDATE fact_ttfhw_issue SET confirm_result = '是', confirmer = #{confirmer}, confirmed_at = (NOW() AT TIME ZONE 'Asia/Shanghai'), updated_at = NOW() WHERE id = #{id} AND (issue_url IS NULL OR issue_url = '')");
    out.add({id: id, marked: n});
}
// best-effort 触发 ttfhw_pipeline 立即建 issue 回填（失败不阻塞，留待下次调度）
// 华为云 AK/SK 签名（SDK-HMAC-SHA256，经 hwcloud 模块），ak/sk 存 PG fact_token(platform='huawei_cloud_ak'/'huawei_cloud_sk')
try {
    var akRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_ak'");
    var skRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_sk'");
    hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "ttfhw_pipeline", []);
} catch (e) { /* 触发失败不影响打标返回 */ }
return {code: 1, message: '已确认为问题，issue 生成中', list: out};

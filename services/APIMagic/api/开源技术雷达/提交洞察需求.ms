{
  "properties": {},
  "id": "oss_insight_submit",
  "script": null,
  "groupId": "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name": "提交洞察需求",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/oss-insight/submit",
  "method": "POST",
  "parameters": [],
  "options": [
    {
      "name": "wrap_request_parameter",
      "value": "disable-cache",
      "description": "禁用接口缓存，避免重复提交命中缓存回显旧结果不执行",
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
  "requestBody": "",
  "headers": [],
  "paths": [],
  "responseBody": null,
  "description": null,
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
import hwcloud;
var insight_type = body.insight_type;
var github_url = body.github_url;
var title = body.title;
var supplement = body.supplement;
var creator = body.creator;

if (insight_type == null || (insight_type != 'project' && insight_type != 'event')) {
  return {code: -1, message: '洞察类型不合法，须为 project 或 event'};
}
if (creator == null || creator.trim() == '') {
  return {code: -1, message: '提交人不能为空'};
}

var project_name;
var final_title;

if (insight_type == 'project') {
  if (github_url == null || github_url.trim() == '') {
    return {code: -1, message: '请输入项目 GitHub URL'};
  }
  var url_trim = github_url.trim().replace(/\/+$/, '');
  if (!/^https:\/\/github\.com\/[^\/]+\/[^\/]+/.test(url_trim)) {
    return {code: -1, message: 'URL格式不合法，须为 https://github.com/owner/repo'};
  }
  var parts = url_trim.split('/');
  project_name = parts[parts.length - 2] + '/' + parts[parts.length - 1];
  final_title = project_name + '开源项目洞察';
  // 查重：仅对开源项目按 project_name 校验（开源事件不查重）。命中返回 -2，前端据此在字段下方显示红字、阻断提交。
  var dup = db.selectOne("SELECT id FROM fact_oss_insight_request WHERE insight_type = 'project' AND LOWER(project_name) = LOWER(#{project_name}) LIMIT 1");
  if (dup != null) {
    return {code: -2, message: '该开源项目已提交过洞察需求，请勿重复提交'};
  }
} else {
  if (title == null || title.trim() == '') {
    return {code: -1, message: '洞察标题不能为空'};
  }
  if (title.trim().length() > 50) {
    return {code: -1, message: '标题不能超过50字'};
  }
  project_name = '通用';
  final_title = title.trim();
  // 查重：开源事件按标题查重（大小写不敏感）。命中返回 -2，前端字段红字阻断。
  var dupEvent = db.selectOne("SELECT id FROM fact_oss_insight_request WHERE insight_type = 'event' AND LOWER(title) = LOWER(#{final_title}) LIMIT 1");
  if (dupEvent != null) {
    return {code: -2, message: '该开源事件已提交过洞察需求，请勿重复提交'};
  }
}

var rec = db.selectOne("""INSERT INTO fact_oss_insight_request(insight_type, project_name, title, supplement, status, creator)
VALUES(#{insight_type}, #{project_name}, #{final_title}, #{supplement}, '待生成', #{creator})
RETURNING id, insight_type, project_name, title, status, creator, created_at""");

// 仅入库（status='待生成'），不在此处直接调 GitHub API 创建 Issue。
// 与「开源技术雷达·新增项目」保持同一套路：GitHub Issue 由 om-dataarts 的
// 后台任务 om.tasks.oss_insight_issue_sync 统一创建——它从 PG 表
// service_platform_config（与参与开源/技术雷达共用同一份 github 配置）读取
// token，扫描本表 issue_url IS NULL 的记录创建 Issue 后回填 issue_number/issue_url。
// 好处：token 集中存 PG、不依赖 APIMagic 的 env/Vault 注入，也避免提交接口被 GitHub 限流/超时拖慢。
// 即时触发 DataArts job_radar 秒级建 Issue（参照 项目总览看板/社区热点同步看板；best-effort 不阻塞提交）
// 华为云 AK/SK 签名（SDK-HMAC-SHA256，经 hwcloud 模块），ak/sk 存 PG fact_token(platform='huawei_cloud_ak'/'huawei_cloud_sk')
try {
  var akRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_ak'");
  var skRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_sk'");
  hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "job_radar", []);
} catch (e) { /* 触发失败不影响入库返回，留待下次调度 */ }
return {code: 1, message: '提交成功', data: rec};

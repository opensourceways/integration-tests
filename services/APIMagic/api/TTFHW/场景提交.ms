{
  "properties": {},
  "id": "ttfhw_scenario_submit",
  "script": null,
  "groupId": "ttfhwgroup0000000000000000000001",
  "name": "场景提交",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/scenario/submit",
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
  "description": "提交 TTFHW 场景（使用者/贡献者），写 fact_ttfhw_scenario_request，status=待生成；不在此处建 Issue（交给 om-dataarts 异步任务）",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
import hwcloud;
var scenario_type = body.scenario_type;
var title = body.title;
var understand_desc = body.understand_desc;
var install_desc = body.install_desc;
var use_desc = body.use_desc;
var contribute_desc = body.contribute_desc;
var supplement = body.supplement;
var github_path = body.github_path;
var gitcode_path = body.gitcode_path;
var creator = body.creator;

if (scenario_type == null || (scenario_type != 'user' && scenario_type != 'contributor')) {
  return {code: -1, message: '场景类型不合法，须为 user 或 contributor'};
}
if (creator == null || creator.trim() == '') {
  return {code: -1, message: '提交人不能为空'};
}

var final_title = null;
var final_github = null;
var final_gitcode = null;

if (scenario_type == 'contributor') {
  // 贡献者场景：github_path / gitcode_path 至少填一个
  var gh = github_path == null ? '' : github_path.trim();
  var gc = gitcode_path == null ? '' : gitcode_path.trim();
  if (gh == '' && gc == '') {
    return {code: -1, message: '贡献者场景至少填写一个项目路径（GitHub 或 GitCode）'};
  }
  // github_path 校验 org/repo 格式
  if (gh != '' && !/^[a-zA-Z0-9][a-zA-Z0-9-]*\/[a-zA-Z0-9][a-zA-Z0-9._-]*$/.test(gh)) {
    return {code: -1, message: 'GitHub 路径格式须为 org/repo'};
  }
  final_github = gh == '' ? null : gh;
  final_gitcode = gc == '' ? null : gc;
  final_title = gh != '' ? gh : gc;
  // 查重：按 creator + github_path/gitcode_path。
  // 注意：不能在 SQL 里写 #{x} IS NOT NULL（PG 无法推断 null 参数的数据类型，
  // 报 could not determine data type of parameter $N），因此把 null 判断挪到
  // 脚本层，SQL 只保留 = 比较，且仅把非空的参数绑定进去。
  var dup = null;
  if (final_github != null && final_gitcode != null) {
    dup = db.selectOne("""SELECT id FROM fact_ttfhw_scenario_request
     WHERE scenario_type = 'contributor' AND creator = #{creator}
       AND (github_path = #{final_github} OR gitcode_path = #{final_gitcode})
     LIMIT 1""");
  } else if (final_github != null) {
    dup = db.selectOne("""SELECT id FROM fact_ttfhw_scenario_request
     WHERE scenario_type = 'contributor' AND creator = #{creator}
       AND github_path = #{final_github}
     LIMIT 1""");
  } else {
    dup = db.selectOne("""SELECT id FROM fact_ttfhw_scenario_request
     WHERE scenario_type = 'contributor' AND creator = #{creator}
       AND gitcode_path = #{final_gitcode}
     LIMIT 1""");
  }
  if (dup != null) {
    return {code: -2, message: '该项目路径已提交过 TTFHW 场景，请勿重复提交'};
  }
} else {
  // 使用者场景：title + 四阶段描述必填
  if (title == null || title.trim() == '') {
    return {code: -1, message: 'TTFHW 标题不能为空'};
  }
  if (title.trim().length() > 50) {
    return {code: -1, message: '标题不能超过50字'};
  }
  if (understand_desc == null || understand_desc.trim() == ''
      || install_desc == null || install_desc.trim() == ''
      || use_desc == null || use_desc.trim() == ''
      || contribute_desc == null || contribute_desc.trim() == '') {
    return {code: -1, message: '了解/安装/使用/贡献 四阶段描述均为必填'};
  }
  final_title = title.trim();
  // 查重：按 creator + title
  var dupU = db.selectOne("""SELECT id FROM fact_ttfhw_scenario_request
     WHERE scenario_type = 'user' AND creator = #{creator} AND LOWER(title) = LOWER(#{final_title})
     LIMIT 1""");
  if (dupU != null) {
    return {code: -2, message: '该 TTFHW 标题已提交过，请勿重复提交'};
  }
}

var rec = db.selectOne("""INSERT INTO fact_ttfhw_scenario_request(
     scenario_type, title, understand_desc, install_desc, use_desc, contribute_desc,
     supplement, github_path, gitcode_path, status, creator)
VALUES(#{scenario_type}, #{final_title}, #{understand_desc}, #{install_desc}, #{use_desc}, #{contribute_desc},
     #{supplement}, #{final_github}, #{final_gitcode}, '待生成', #{creator})
RETURNING id, scenario_type, title, status, creator, created_at""");

// 仅入库（status='待生成'），不在此处调 GitHub API 创建 Issue。
// GitHub Issue 由 om-dataarts 后台任务 om.tasks.ttfhw_scenario_issue_sync 统一创建——
// 扫 issue_url IS NULL 的记录建 Issue 后回填 issue_number/issue_url（与 oss-insight 同套路）。
// best-effort 即时触发 DataArts job（失败不阻塞入库）
// 华为云 AK/SK 签名（SDK-HMAC-SHA256，经 hwcloud 模块），ak/sk 存 PG fact_token(platform='huawei_cloud_ak'/'huawei_cloud_sk')
try {
  var akRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_ak'");
  var skRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_sk'");
  hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "ttfhw_pipeline", []);
} catch (e) { /* 触发失败不影响入库返回，留待下次调度 */ }
return {code: 1, message: '提交成功', data: rec};

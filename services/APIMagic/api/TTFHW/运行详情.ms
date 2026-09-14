{
  "properties": {},
  "id": "ttfhw_rundetail_0001",
  "script": null,
  "groupId": "ttfhwgroup0000000000000000000001",
  "name": "TTFHW运行详情",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/run",
  "method": "GET",
  "parameters": [
    {"name": "id", "value": "", "description": "运行 id", "required": true, "dataType": "String"}
  ],
  "options": [],
  "requestBody": "",
  "headers": [],
  "paths": [],
  "responseBody": null,
  "description": "TTFHW 单次运行详情：四阶段/断点问题/缺陷/执行步骤/摘要（供详情子页/抽屉）。读 dws_ttfhw_run.detail(JSON 文本)。",
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
if (id == null || id == '') {
  return {code: -1, message: 'id 不能为空'};
}
var row = db.selectOne("SELECT id, community, repo, scenario, result, total_min, run_date, report_url, summary, detail FROM dws_ttfhw_run WHERE id = #{id}");
if (row == null) {
  return {code: -1, message: '运行不存在'};
}
return row;

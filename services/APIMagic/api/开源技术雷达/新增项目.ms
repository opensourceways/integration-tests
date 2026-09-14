{
  "properties": {},
  "id": "trp_add",
  "script": null,
  "groupId": "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name": "新增项目",
  "createTime": null,
  "updateTime": 1777378516658,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/tech-radar/add",
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
var u=body.url; var pypi=body.pypi_url; var tp=body.type; var creator=body.creator;
if(u==null||u.trim()==''){return {code:-1,message:'项目URL不能为空'};}
if(tp==null||tp.trim()==''){return {code:-1,message:'项目类型不能为空'};}
var nm=u.trim().replace(/\/+$/, '');
var parts=nm.split('/');
var name=parts.length>=2?parts[parts.length-2]+'/'+parts[parts.length-1]:nm;
// 查重（INSERT 前）：任一命中即返回 -2，前端据此在项目路径下方显示红字、阻断录入。
// case 2.1 列表重复：按精确 url 匹配已录入项目
var dupList=db.selectOne("SELECT id FROM fact_insight_tech_radar_project WHERE LOWER(url) = LOWER(#{u}) LIMIT 1");
if(dupList!=null){return {code:-2,message:'该项目已在录入列表中，请勿重复录入'};}
// case 2.2 与雷达现有项目重复：按 owner/repo 匹配雷达数据表的 file_project
var dupRadar=db.selectOne("SELECT file_project FROM fact_opensource_radar_data WHERE LOWER(file_project) = LOWER(#{name}) LIMIT 1");
if(dupRadar!=null){return {code:-2,message:'该项目已存在于技术雷达中，请勿重复录入'};}
var r=db.selectOne("""INSERT INTO fact_insight_tech_radar_project(name,url,pypi_url,type,status,creator)
VALUES(#{name},#{u},#{pypi},#{tp},'未上线',#{creator})
RETURNING id,name,url,pypi_url,type,status,creator,created_at""");
// 即时触发 DataArts job_radar 秒级建 Issue（参照 项目总览看板/社区热点同步看板；best-effort 不阻塞提交）
// 华为云 AK/SK 签名（SDK-HMAC-SHA256，经 hwcloud 模块），ak/sk 存 PG fact_token(platform='huawei_cloud_ak'/'huawei_cloud_sk')
try {
  var akRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_ak'");
  var skRow = db.select("SELECT token FROM fact_token WHERE platform = 'huawei_cloud_sk'");
  hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "job_radar", []);
} catch (e) { /* 触发失败不影响入库返回，留待下次调度 */ }
return {code:1,message:'新增成功',data:r};
{
  "properties": {},
  "id": "2f8cf0189797456686a13b37ddf45bea",
  "script": null,
  "groupId": "1a7a4bd8439c447daf274fc1b6f280f1",
  "name": "查看采集状态列表",
  "createTime": null,
  "updateTime": null,
  "lock": null,
  "createBy": "admin",
  "updateBy": null,
  "path": "/query/repo/status",
  "method": "GET",
  "parameters": [
    {
      "name": "platform",
      "value": "",
      "description": null,
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": "",
      "validateType": null,
      "error": null,
      "expression": null,
      "children": null
    }
  ],
  "options": [
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
    },
    {
      "name": "permission",
      "value": "datastatwhitebox_view",
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
var platform_tem = platform
var repo_tem = repo
var status_tem = status
var community_tem = community

var repo_path = null
var owner = null
if(null!= repo_tem){
   var ss = repo_tem.split("/")
    if(ss.length==2){ repo_path = ss[1]; owner = ss[0] }
    if(ss.length==1){ owner = ss[0] }
}

var sql = """ 
select * from fact_branch_collect_status
where 1=1
          <if test="community_tem != null and community_tem!='' "> and community =#{community_tem} </if>
          <if test="platform_tem != null and platform_tem!='' "> and platform = #{platform_tem} </if>
          <if test="repo_path != null and repo_path!='' and owner != null and owner!='' "> and repo =lower(#{repo_path}) </if>
          <if test="owner != null and owner!='' and repo_path != null and repo_path!='' "> and owner =lower(#{owner}) </if>
          <if test="repo_tem != null and repo_tem!='' "> and (owner =lower(#{owner}) or repo =lower(#{owner})) </if>
          <if test="status_tem != null and status_tem!='' "> and status =#{status_tem} </if>
 limit 10000 """

return db.backup.select(sql)

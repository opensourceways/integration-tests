{
  "properties": {},
  "id": "a8b3d32c34bc4740b8c40454d4c9a566",
  "script": null,
  "groupId": "521ef640123a4ae79386e6a38b8df4ad",
  "name": "塔台蓝区代码贡献",
  "createTime": null,
  "updateTime": 1777106090420,
  "lock": null,
  "createBy": null,
  "updateBy": "admin",
  "path": "/whitebox/blueuser",
  "method": "GET",
  "parameters": [
    {
      "name": "gitcode_id",
      "value": "xiaohua-zhang",
      "description": null,
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": "pattern",
      "error": "gitcode_id 格式非法",
      "expression": "^[a-zA-Z0-9_/-]*$",
      "children": null
    },
    {
      "name": "gitee_id",
      "value": "",
      "description": null,
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": "pattern",
      "error": "gitee_id 格式非法",
      "expression": "^[a-zA-Z0-9_/-]*$",
      "children": null
    },
    {
      "name": "github_id",
      "value": "",
      "description": null,
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": "pattern",
      "error": "github_id 格式非法",
      "expression": "^[a-zA-Z0-9_/-]*$",
      "children": null
    },
    {
      "name": "start_time",
      "value": "2026-01-01",
      "description": "yyyy-mm-dd格式字符串",
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": "pattern",
      "error": "start_time 格式应为 yyyy-MM-dd",
      "expression": "^(\\d{4}-\\d{2}-\\d{2})?$",
      "children": null
    },
    {
      "name": "token",
      "value": "dsdfsdfsdfd",
      "description": null,
      "required": false,
      "dataType": "String",
      "type": null,
      "defaultValue": null,
      "validateType": "pattern",
      "error": null,
      "expression": "^(dsdfsdfsdfd)$",
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
  "responseBody": "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": \"已经启动采集任务，请耐心等待10分钟后使用check接口查看数据是否已经采集\",\n    \"timestamp\": 1777105388533,\n    \"executeTime\": 173\n}",
  "description": null,
  "requestBodyDefinition": null,
  "responseBodyDefinition": null
}
================================
import com.alibaba.druid.util.StringUtils
import org.ssssssss.script.parsing.ast.statement.Return
import hwcloud;
var gitcode_id_temp = gitcode_id;
var gitee_id_temp = gitee_id;
var github_id_temp = github_id;
var start_time_temp = start_time;
if(StringUtils.isEmpty(gitcode_id_temp) && StringUtils.isEmpty(gitee_id_temp) && StringUtils.isEmpty(github_id_temp) ){
    return "gitcode_id/gitee_id/github_id参数少填写一个"
}
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
var resp = hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "whitebox_blue_user", [
                {
                    "name": "gitcode_id",
                    "value": gitcode_id_temp
                },
                        {
                    "name": "gitee_id",
                    "value": gitee_id_temp
                },
                        {
                    "name": "github_id",
                    "value": github_id_temp
                },
                        {
                    "name": "start_time",
                    "value": start_time_temp
                }
            ])
return "已经启动采集任务，请耐心等待10分钟后使用check接口查看数据是否已经采集"

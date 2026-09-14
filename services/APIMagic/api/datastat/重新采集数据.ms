{
  "properties" : { },
  "id" : "copy1758599280559d18947",
  "script" : null,
  "groupId" : "521ef640123a4ae79386e6a38b8df4ad",
  "name" : "重新采集数据",
  "createTime" : null,
  "updateTime" : 1776908079330,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/whitebox/collect",
  "method" : "GET",
  "parameters" : [ {
    "name" : "type",
    "value" : "commit",
    "description" : "只支持commit|review|discoverall|whitebox_review",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "只支持commit|review|discoverall|whitebox_review",
    "expression" : "^(commit|review|discoverall|whitebox_review)$",
    "children" : null
  }, {
    "name" : "platform",
    "value" : "gitcode",
    "description" : "只支持gitee|gitcode|github",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "只支持gitee|gitcode|github",
    "expression" : "^(gitee|gitcode|github|codearts|codearts_1|codearts_2|codearts_3|codearts_4)$",
    "children" : null
  }, {
    "name" : "repo",
    "value" : "oG-Memory",
    "description" : "只支持全路径示例： test",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "只支持全路径示例： test",
    "expression" : "^[a-zA-Z0-9_/-]+$",
    "children" : null
  }, {
    "name" : "owner",
    "value" : "opengauss",
    "description" : "只支持全路径示例： Ascend",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "只支持全路径示例： Ascend",
    "expression" : "^[a-zA-Z0-9_/-]+$",
    "children" : null
  }, {
    "name" : "collect_from",
    "value" : "2026-03-01",
    "description" : "示例： yyyy-mm-dd格日期字符串",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : "collect_from 格式应为 yyyy-MM-dd",
    "expression" : "^(\\d{4}-\\d{2}-\\d{2})?$",
    "children" : null
  }, {
    "name" : "befordays",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : "befordays 格式非法",
    "expression" : "^[0-9]*$",
    "children" : null
  } ],
  "options" : [ {
    "name" : "wrap_request_parameter",
    "value" : "disable-cache",
    "description" : "包装请求参数到一个变量中",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "permission",
    "value" : "datastatadmin_View",
    "description" : "允许拥有datastatadmin_View权限的用户访问",
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
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": \"已经启动采集任务，请耐心等待10分钟后使用check接口查看数据是否已经采集\",\n    \"timestamp\": 1776907842345,\n    \"executeTime\": 164\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import hwcloud;
var type_tem = type;
var platform_tem = platform;
var repo_tem = repo;
var owner_tem = owner;

var collect_from_tem = collect_from;
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
var resp = hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "whitebox_recollect_new", [
                {
                    "name": "type",
                    "value": type_tem
                },
                        {
                    "name": "repo",
                    "value": repo_tem
                },
                        {
                    "name": "collect_from",
                    "value": collect_from_tem
                },
                        {
                    "name": "platform",
                    "value": platform_tem
                },
                                        {
                    "name": "owner",
                    "value": owner_tem
                }

            ])
return "已经启动采集任务，请耐心等待10分钟后使用check接口查看数据是否已经采集"

{
  "properties" : { },
  "id" : "copy1778482011035d44389",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "发现组织仓库",
  "createTime" : null,
  "updateTime" : 1778498235997,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/discover/org/repos",
  "method" : "GET",
  "parameters" : [ {
    "name" : "platform",
    "value" : "gitcode",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "org",
    "value" : "unifiedbus",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
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
    "value" : "datastatwhitebox_view",
    "description" : "允许拥有该权限的访问",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"msg\": \"正在查询相关数据，请2分钟后查询使用相同的条件查询结果\"\n    },\n    \"timestamp\": 1778486441215,\n    \"executeTime\": 192\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import hwcloud;
var type_tem = type;
var platform_tem = platform;
var org_tem = org;
var community_tem = community;

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
            "value": "discover"
        },
                {
            "name": "owner",
            "value": org_tem
        }
        ,
                {
            "name": "platform",
            "value": platform_tem
        }
    ])
return {msg:"正在查询相关数据，请2分钟后查询使用相同的条件查询结果"}


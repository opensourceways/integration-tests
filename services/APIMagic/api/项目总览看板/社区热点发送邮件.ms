{
  "properties" : { },
  "id" : "247eca6acc0e46b8a1e7efab48af268f",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "社区热点发送邮件",
  "createTime" : null,
  "updateTime" : 1775204478016,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/hotspot/send",
  "method" : "POST",
  "parameters" : [ {
    "name" : "html_file",
    "value" : { },
    "description" : null,
    "required" : true,
    "dataType" : "MultipartFile",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "community",
    "value" : "openubmc",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "image_top",
    "value" : { },
    "description" : null,
    "required" : true,
    "dataType" : "MultipartFile",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "image_mid",
    "value" : { },
    "description" : null,
    "required" : true,
    "dataType" : "MultipartFile",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "image_end",
    "value" : { },
    "description" : null,
    "required" : true,
    "dataType" : "MultipartFile",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ {
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
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"参数[html_file]为必填项\",\n    \"data\": null,\n    \"timestamp\": 1765024780576,\n    \"executeTime\": 0\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import request;
import hwcloud;
var type_html = 'html'
var type_image = 'image'
var table_name = 'fact_all_report_source'
var id = ''
var name_index = ''
// 获取社区名称
var community = request.getValues('community');
community = community[0];
community = community.toLowerCase();
var image_top = request.getFile('image_top');
var image_mid = request.getFile('image_mid');
var image_end = request.getFile('image_end');
// 获取html文件
var file = request.getFile('html_file'); 
var content_type = file.getContentType();
// 校验文件类型为html
if content_type != "text/html" {
    return 'error';
}
// 校验文件大小
var size = file.getSize();
if size > 1000000{
    return 'error';
}
// 获取html文件内容
var fileData = file.getBytes();
var image_top_data = image_top.getBytes();
var image_mid_data = image_mid.getBytes();
var image_end_data = image_end.getBytes();
var list = [image_top_data, image_mid_data, image_end_data, fileData];
for(index, item in list){
    var type = type_image
    if index == 3 {
        type = type_html
    }
    var name_index = (index + 1).asString()
    id = community + '_' + type + name_index
    var value = {id: id, community: community, name: name_index, source: item, type: type, created_at: now(), updated_at: now()}
    try{
        db.table(table_name).primary('id').insert(value)
    }catch(e) {
        db.table(table_name).primary('id').update(value)
    }
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
var resp = hwcloud.runJob(akRow[0]["token"], skRow[0]["token"], "send_email", [
        {
            "name": "community",
            "value": community
        }
    ])
return resp.status

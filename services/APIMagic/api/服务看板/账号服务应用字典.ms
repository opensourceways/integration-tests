{
  "properties" : { },
  "id" : "b8d2f0e35a9c47f1b2c3d4e5f6071822",
  "script" : null,
  "groupId" : "fee87ad3dfde4e33b4dd4bc0eb95ce14",
  "name" : "账号服务应用字典",
  "createTime" : null,
  "updateTime" : 1775640000000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/account/app/dict",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openubmc",
    "description" : "社区",
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
    "value" : "datastatadmin_View",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"app_id\": \"694bab197dd332233c960f7e\",\n        \"app_name\": \"openUBMC Studio\"\n    }],\n    \"timestamp\": 1775640000000,\n    \"executeTime\": null\n}",
  "description" : "openUBMC 账号服务应用字典：驱动前端「应用名称」筛选下拉。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// openUBMC 账号服务：应用字典（app_id -> app_name），驱动前端应用名称筛选下拉
// community 为 GET 查询参数，magic-api 自动注入脚本作用域，直接引用即可。
// 切勿写 `var community = community;`——同名自赋值会把变量初始化成 null（取不到请求参数），
// 参照仓内其它 GET 接口约定：赋给一个不同名的局部变量再用。
if (community == null || community == '') {
    return [];
}
var comm = community.toLowerCase();
// 应用字典表未采集时返回空数组，不抛 500
var tblExists = db.selectInt("""
    select count(1) from information_schema.tables
    where table_schema = 'public' and table_name = 'fact_community_authing_application'
""");
if (tblExists == 0) {
    return [];
}
var sql = """
    select appid as app_id, appname as app_name
    from fact_community_authing_application
    where community = #{comm} and status = 'active'
    order by appname
"""
return db.select(sql);

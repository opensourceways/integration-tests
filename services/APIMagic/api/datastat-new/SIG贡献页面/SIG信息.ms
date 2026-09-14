{
  "properties" : { },
  "id" : "d5ff1c04fbe34f479087ba49a5936b04",
  "script" : null,
  "groupId" : "d483565aa9094ad0ba882199e9e1fa17",
  "name" : "SIG信息",
  "createTime" : null,
  "updateTime" : 1778469572934,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/sig/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openubmc",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "sig",
    "value" : "sig-component-drivers",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"name\": \"sig-component-drivers\",\n        \"description\": \"部件驱动-SIG致力于深耕部件驱动标准化，深化与部件厂商合作认证与部件规范联创，建设部件生态社区。通过建立统一的驱动接口规范和开发标准，构建硬件抽象层和驱动适配框架，实现多厂商硬件的统一管理和标准化接入。\",\n        \"description_en\": \"The Component Driver SIG is dedicated to advancing the standardization of component drivers, deepening collaborative certification with component vendors, and jointly establishing component specifications to build a thriving component ecosystem. By creating unified driver interface specifications and development standards, the SIG aims to develop a hardware abstraction layer and driver adaptation framework. This initiative enables unified management and standardized integration of multi-vendor hardware.\",\n        \"created_on\": \"2025-06-20\",\n        \"mailing_list\": \"componentdrivers@public.openubmc.cn\",\n        \"meeting_url\": \"https://etherpad.openubmc.cn/p/sig-component-drivers\",\n        \"discuss_url\": \"https://discuss.openubmc.cn/c/sig-hardware/sig-component-drivers\",\n        \"maintainers\": [\"dongyushan\", \"net_swift_wangchen\", \"sam_h1973\", \"suguirong\", \"u012924942\", \"weixin_37569011\", \"xiaoxinglxs\"],\n        \"repositories\": [\"openUBMC/component_drivers\", \"openUBMC/devmon\", \"openUBMC/libmcpp\"],\n        \"meeting_agenda\": [\"1、讨论和评审部件驱动方案设计。\", \"2、讨论和评审部件驱动架构方案。\", \"3、讨论和规划部件驱动的长期技术规划。\"],\n        \"meeting_agenda_en\": [\"1. Discuss and evaluate component driver design proposals.\", \"2. Discuss and evaluate component driver architecture proposals.\", \"3. Discuss and define the long-term technical roadmap for component drivers.\"]\n    },\n    \"timestamp\": 1778469563153,\n    \"executeTime\": 8\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT 
    sig_json
FROM 
    fact_${community}_sig_detail_info
WHERE
     sig_name = #{sig} and is_removed is null;"""
var resp = db.selectOne(sqlstr)
var sig_info = resp['sig_json']::json
var repos = []
for (key in sig_info.getOrDefault('repositories', [])) {
    repos.addAll(key['repo'])
}
sig_info['repositories'] = repos
var sqlstr = """
SELECT 
    array_agg(distinct user_login) AS maintainers
FROM 
    fact_${community}_sig_user
WHERE
     sig_name = #{sig} and role = 'maintainer' and is_removed is null;"""
var maintainers = db.selectOne(sqlstr).maintainers.getArray()
sig_info['maintainers'] = maintainers
return sig_info 

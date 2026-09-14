{
  "properties" : { },
  "id" : "335d26937b6d45b8a30e9cc6d09a0f42",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "注册汇总",
  "createTime" : null,
  "updateTime" : 1773818144063,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/total_regist",
  "method" : "POST",
  "parameters" : [ ],
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
  } ],
  "requestBody" : "{\r\n    \"start\":1757721600000,\r\n    \"end\":1759108826651,\r\n    \"community\":\"unifiedbus\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_regist_user\": 1207,\n        \"week_regist_user\": 298,\n        \"topn_comany\": \"福建新大陆支付技术有限公司，中国科大，SiFotonics，开源证券，航天电器，博联通信，熙湖智能科技（深圳）有限公司，成都鼎桥通信技术有限公司，快手，XG tech，天融环境，cambricon，芯动微电子科技（武汉）有限公司，君桐资本，黑马科技，JS，鹿马智能，深圳市紫光同创，华中科技大学网络空间安全学院，华硕科技\",\n        \"total_regist_company\": 262,\n        \"week_regist_company\": 84\n    },\n    \"timestamp\": 1759027461737,\n    \"executeTime\": 7\n}",
  "description" : null,
  "requestBodyDefinition" : {
    "name" : "root",
    "value" : "",
    "description" : "",
    "required" : false,
    "dataType" : "Object",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : [ {
      "name" : "start",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "topn",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "topn 必须为正整数且不超过 100",
      "expression" : "topn > 0 && topn <= 100",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : {
    "name" : "",
    "value" : "",
    "description" : "",
    "required" : false,
    "dataType" : "Object",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : [ {
      "name" : "code",
      "value" : "-1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "message",
      "value" : "系统内部出现错误",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "data",
      "value" : "null",
      "description" : "",
      "required" : false,
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "timestamp",
      "value" : "1759027443779",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "executeTime",
      "value" : "9",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  }
}

================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 社区
var community = body.community.toLowerCase();
// topn
var topn = 20;
if (body.topn != null and body.topn != ""){
    topn = body.topn;
}
var register_user_table = "dws_"+community+"_account_week";
var regist_company_table = "dwm_"+community+"_domain_company";
var regist_data_sql = """
with regist_user_data AS(
    SELECT date, company, regist_count
    from ${register_user_table}
),
regist_company_data as (
    SELECT min(first_register_time) as first_register_time, company
    from ${regist_company_table}
    group by company
),
total_regist_company_count as (
    select count(1) as total_regist_company from regist_company_data
),
curr_week_regist_company_count as (
    select count(1) as week_regist_company from regist_company_data
    where (first_register_time AT TIME ZONE 'Asia/Shanghai')::date BETWEEN date_trunc('week', CURRENT_DATE)::DATE AND #{end}
),
total_regist_user_count AS (
    select sum(regist_count) as total_regist_user from regist_user_data
),
curr_week_regist_user_count as (
    select sum(regist_count) as week_regist_user from regist_user_data
    where date BETWEEN date_trunc('week', CURRENT_DATE)::DATE AND date_trunc('week', CURRENT_DATE)::DATE
),
company_regist_sort as (
    select company from regist_company_data
    where (first_register_time AT TIME ZONE 'Asia/Shanghai')::date BETWEEN date_trunc('week', CURRENT_DATE)::DATE AND #{end}
    ORDER BY first_register_time
    limit #{topn} offset 0
),
topn_regist_user_company as (
    select string_agg(company, '，') as topn_comany from company_regist_sort
)
SELECT 
    total_regist_user_count.total_regist_user, 
    curr_week_regist_user_count.week_regist_user, 
    topn_regist_user_company.topn_comany,
    total_regist_company_count.total_regist_company,
    curr_week_regist_company_count.week_regist_company
FROM total_regist_user_count
CROSS JOIN curr_week_regist_user_count
CROSS JOIN topn_regist_user_company
CROSS JOIN total_regist_company_count
CROSS JOIN curr_week_regist_company_count;
""";
var db_data = db.select(regist_data_sql)[0];
return db_data;

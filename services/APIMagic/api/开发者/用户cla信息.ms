{
  "properties" : { },
  "id" : "0b928f3692d142ffa91dade2730b65dc",
  "script" : null,
  "groupId" : "905e0bee16764ec9be1e96b78cae9466",
  "name" : "用户cla信息",
  "createTime" : null,
  "updateTime" : 1774862732770,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "cla/list",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "cannopen",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^cannopen$",
    "children" : null
  }, {
    "name" : "page",
    "value" : "1",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page > 0 && page <= 1000",
    "children" : null
  }, {
    "name" : "page_size",
    "value" : "10",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1000",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page_size > 0 && page_size <= 1000",
    "children" : null
  }, {
    "name" : "email",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "created_after",
    "value" : "2026-01-05",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
    "children" : null
  } ],
  "options" : [ {
    "name" : "permission",
    "value" : "cla",
    "description" : "允许拥有该权限的访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
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
  "requestBody" : "",
  "headers" : [ {
    "name" : "token",
    "value" : "***REMOVED***",
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
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 462,\n        \"list\": [{\n            \"email\": \"wangbin153@huawei.com\",\n            \"company\": \"华为技术有限公司\",\n            \"created_at\": \"2026-01-05\"\n        }, {\n            \"email\": \"xth1020@gmail.com\",\n            \"company\": \"个人贡献者\",\n            \"created_at\": \"2026-01-05\"\n        }, {\n            \"email\": \"sunhaiqing1@huawei.com\",\n            \"company\": \"华为技术有限公司\",\n            \"created_at\": \"2026-01-05\"\n        }, {\n            \"email\": \"seu_zhangsj@163.com\",\n            \"company\": \"个人贡献者\",\n            \"created_at\": \"2026-01-05\"\n        }, {\n            \"email\": \"weiying10@huawei.com\",\n            \"company\": \"华为技术有限公司\",\n            \"created_at\": \"2026-01-05\"\n        }, {\n            \"email\": \"yejiani2@huawei.com\",\n            \"company\": \"华为技术有限公司\",\n            \"created_at\": \"2026-01-05\"\n        }, {\n            \"email\": \"804425610@qq.com\",\n            \"company\": \"个人贡献者\",\n            \"created_at\": \"2026-01-05\"\n        }, {\n            \"email\": \"jiashuaiwei@h-partners.com\",\n            \"company\": \"h-partners\",\n            \"created_at\": \"2026-01-05\"\n        }, {\n            \"email\": \"839822850@qq.com\",\n            \"company\": \"个人贡献者\",\n            \"created_at\": \"2026-01-05\"\n        }, {\n            \"email\": \"liuxinnan@stu.hit.edu.cn\",\n            \"company\": \"哈尔滨工业大学计算学部\",\n            \"created_at\": \"2026-01-06\"\n        }]\n    },\n    \"timestamp\": 1774862730487,\n    \"executeTime\": 9\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var off = (page - 1) * page_size
var sqlstr = """
SELECT
    email,
    company,
    created_at::date
FROM 
    fact_${community}_cla_user
WHERE
    1 = 1
        <if test="email != null and email != ''">
            AND email = #{email}
        </if>
        <if test="created_after != null and created_after != ''">
            AND created_at >= #{created_after}::timestamptz
        </if>
ORDER BY uuid ASC
"""
var resp = db.page(sqlstr, page_size, off)

return resp

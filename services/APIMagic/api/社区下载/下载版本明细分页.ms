{
  "properties" : { },
  "id" : "og1257downloaddetailpage0000001",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "下载版本明细分页",
  "createTime" : null,
  "updateTime" : 1751932800000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/detail/page",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatadmin",
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
  "requestBody" : "{\r\n    \"community\":\"opengauss\",\r\n    \"start\":1577808000000,\r\n    \"end\":1993177600000,\r\n    \"software_name\":\"\",\r\n    \"sort\":\"signed_at\",\r\n    \"order\":\"asc\",\r\n    \"pageSize\":10,\r\n    \"pageNum\":1\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 2,\n        \"total_page\": 1,\n        \"list\": [{\n            \"software_name\": \"openGauss-5.0.0-CentOS-64bit.tar.gz\",\n            \"software_architecture\": \"x86_64\",\n            \"software_os\": \"CentOS\",\n            \"created_at\": \"2026-01-05T12:00:00+08:00\",\n            \"user_login\": \"alice\",\n            \"username\": \"Alice\",\n            \"company\": \"XX公司\",\n            \"email\": \"alice@example.com\",\n            \"signed_at\": \"2025-06-01T10:00:00+08:00\"\n        }]\n    },\n    \"timestamp\": 1751932800000,\n    \"executeTime\": 20\n}",
  "description" : "openGauss 运营看板『下载版本数据』——按时间范围分页返回版本下载明细（数据源统一自 ES opengauss_tracker + Authing），含 email/signed_at。接口已由 datastatadmin 权限管控，仅授权管理员可访问，故 email 明文返回不再脱敏。",
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
      "name" : "community",
      "value" : "",
      "description" : "社区名称",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "",
      "description" : "开始时间戳(毫秒)",
      "required" : true,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "结束时间戳(毫秒)",
      "required" : true,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "software_name",
      "value" : "",
      "description" : "软件名模糊搜索(可选)",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "sort",
      "value" : "",
      "description" : "排序字段(created_at/signed_at/software_name)",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "created_at",
      "validateType" : "pattern",
      "error" : "sort 参数格式非法",
      "expression" : "^(created_at|signed_at|software_name)?$",
      "children" : [ ]
    }, {
      "name" : "order",
      "value" : "",
      "description" : "排序方向(asc/desc)",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "desc",
      "validateType" : "pattern",
      "error" : "order 只能为 asc 或 desc",
      "expression" : "^(asc|desc)?$",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "",
      "description" : "每页数量",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过1000",
      "expression" : "pageSize > 0 && pageSize <= 1000",
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "",
      "description" : "页码",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageNum 必须为正整数",
      "expression" : "pageNum > 0",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var community = body.community;
var software_name = body.software_name;
var start = body.start;
var end = body.end;
var sort = (body.sort == null || body.sort == '') ? 'created_at' : body.sort;
var order = (body.order == null || body.order == '') ? 'desc' : body.order;
var page_num = body.pageNum == null ? 1 : body.pageNum;
var page_size = body.pageSize == null ? 10 : body.pageSize;
var offset_num = page_size * (page_num - 1);
var sql = """
    SELECT
        software_name,
        software_architecture,
        software_os,
        created_at,
        user_login,
        company,
        email,
        signed_at
    FROM dwm_${community}_download_detail
    WHERE created_at >= to_timestamp(#{start} / 1000) AND created_at < to_timestamp(#{end} / 1000)
    <if test="software_name != null and software_name != ''">
        AND software_name ILIKE CONCAT('%', #{software_name}, '%')
    </if>
    ORDER BY ${sort} ${order}
    LIMIT #{page_size} OFFSET #{offset_num}
""";
var total_sql = """
    SELECT COUNT(*) AS total_count
    FROM dwm_${community}_download_detail
    WHERE created_at >= to_timestamp(#{start} / 1000) AND created_at < to_timestamp(#{end} / 1000)
    <if test="software_name != null and software_name != ''">
        AND software_name ILIKE CONCAT('%', #{software_name}, '%')
    </if>
""";
var query_data = db.select(sql);
var total_count = db.selectOne(total_sql).get("total_count");
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", (total_count % page_size == 0) ? total_count / page_size : total_count / page_size + 1);
return result;

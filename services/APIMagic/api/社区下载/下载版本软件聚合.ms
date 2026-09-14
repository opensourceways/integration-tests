{
  "properties" : { },
  "id" : "og1257downloadsoftwareagg000001",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "下载版本软件聚合",
  "createTime" : null,
  "updateTime" : 1751932800000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/software/aggregate",
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
  "requestBody" : "{\r\n    \"community\":\"opengauss\",\r\n    \"start\":1577808000000,\r\n    \"end\":1993177600000,\r\n    \"software_name\":\"\",\r\n    \"sort\":\"download_count\",\r\n    \"order\":\"desc\",\r\n    \"pageSize\":10,\r\n    \"pageNum\":1\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_download_all\": 1280,\n        \"total_download\": 1024,\n        \"total_count\": 2,\n        \"total_page\": 1,\n        \"list\": [{\n            \"software_name\": \"openGauss-5.0.0-CentOS-64bit.tar.gz\",\n            \"download_count\": 620\n        }, {\n            \"software_name\": \"openGauss-3.1.0-openEuler-64bit.tar.gz\",\n            \"download_count\": 404\n        }]\n    },\n    \"timestamp\": 1751932800000,\n    \"executeTime\": 18\n}",
  "description" : "openGauss 运营看板『下载版本数据』——按 software_name 聚合下载量，并返回两个下载总量：total_download_all（所有包）与 total_download（已排除 JDBC_/ODBC_ 前缀的数据库驱动）。支持软件名模糊搜索 + 下载量/软件名排序。仅 datastatadmin 权限可访问。",
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
      "description" : "排序字段(白名单)",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "sort 只能为 download_count 或 software_name",
      "expression" : "^(download_count|software_name)?$",
      "children" : [ ]
    }, {
      "name" : "order",
      "value" : "",
      "description" : "排序方向(白名单)",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
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
var sort = (body.sort == null || body.sort == '') ? 'download_count' : body.sort;
var order = (body.order == null || body.order == '') ? 'desc' : body.order;
var page_num = body.pageNum == null ? 1 : body.pageNum;
var page_size = body.pageSize == null ? 10 : body.pageSize;
var offset_num = page_size * (page_num - 1);
var sql = """
    SELECT
        software_name,
        COUNT(*) AS download_count
    FROM dwm_${community}_download_detail
    WHERE created_at >= to_timestamp(#{start} / 1000) AND created_at < to_timestamp(#{end} / 1000)
    <if test="software_name != null and software_name != ''">
        AND software_name ILIKE CONCAT('%', #{software_name}, '%')
    </if>
    GROUP BY software_name
    ORDER BY ${sort} ${order}
    LIMIT #{page_size} OFFSET #{offset_num}
""";
var total_sql = """
    SELECT COUNT(*) AS total_count FROM (
        SELECT software_name
        FROM dwm_${community}_download_detail
        WHERE created_at >= to_timestamp(#{start} / 1000) AND created_at < to_timestamp(#{end} / 1000)
        <if test="software_name != null and software_name != ''">
            AND software_name ILIKE CONCAT('%', #{software_name}, '%')
        </if>
        GROUP BY software_name
    ) t
""";
// 两个总量：total_download_all=所有包下载总量；total_download=移除 JDBC_/ODBC_ 等数据库驱动后的下载总量
var total_download_sql = """
    SELECT
        COUNT(*) AS total_download_all,
        COUNT(*) FILTER (WHERE software_name !~ '^(JDBC|ODBC)_') AS total_download
    FROM dwm_${community}_download_detail
    WHERE created_at >= to_timestamp(#{start} / 1000) AND created_at < to_timestamp(#{end} / 1000)
""";
var query_data = db.select(sql);
var total_count = db.selectOne(total_sql).get("total_count");
var total_row = db.selectOne(total_download_sql);
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_download_all", total_row.get("total_download_all"));
result.put("total_download", total_row.get("total_download"));
result.put("total_count", total_count);
result.put("total_page", (total_count % page_size == 0) ? total_count / page_size : total_count / page_size + 1);
return result;

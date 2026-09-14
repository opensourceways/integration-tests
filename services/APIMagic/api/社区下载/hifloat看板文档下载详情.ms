{
  "properties" : { },
  "id" : "copy1776928243816d56931",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "hifloat看板文档下载详情",
  "createTime" : null,
  "updateTime" : 1777425963732,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/home/detail_hifloat",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : "暂时只支持hifloat",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "hifloat",
    "validateType" : "pattern",
    "error" : "暂时只支持hifloat",
    "expression" : "^(hifloat)$",
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"file_name\": \"hifloat4_format_for_language_model_inference\",\n        \"total_pv\": 0,\n        \"total_download_count\": 0,\n        \"week_pv\": 0,\n        \"week_download_count\": 0\n    }, {\n        \"file_name\": \"ascend_hifloat8_format_for_deep_learning\",\n        \"total_pv\": 0,\n        \"total_download_count\": 0,\n        \"week_pv\": 0,\n        \"week_download_count\": 0\n    }],\n    \"timestamp\": 1777425850923,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
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
      "value" : "0",
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
      "value" : "暂时只支持unifiedbus",
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
      "value" : "1776928156506",
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
      "value" : "0",
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
var community = community;
var sql="""
  SELECT
      cfg.file_id AS file_name,
      COALESCE(stats.total_pv, 0) AS total_pv,
      COALESCE(stats.total_uv, 0) AS total_uv,
      COALESCE(stats.total_download_count, 0) AS total_download_count,
      COALESCE(stats.week_pv, 0) AS week_pv,
      COALESCE(stats.week_uv, 0) AS week_uv,
      COALESCE(stats.week_download_count, 0) AS week_download_count
  FROM (
      SELECT DISTINCT file_id
      FROM fact_hifloat_file_config
      WHERE is_active = True
  ) cfg
  LEFT JOIN (
      SELECT
          file_name,
          SUM(pv) AS total_pv,
          SUM(uv) AS total_uv,
          SUM(dv) AS total_download_count,
          SUM(CASE WHEN date >= DATE_TRUNC('week', CURRENT_DATE) THEN pv END) AS week_pv,
          SUM(CASE WHEN date >= DATE_TRUNC('week', CURRENT_DATE) THEN uv END) AS week_uv,
          SUM(CASE WHEN date >= DATE_TRUNC('week', CURRENT_DATE) THEN dv END) AS week_download_count
      FROM dws_${community}_service_log_file_daily
      WHERE date IS NOT NULL
      GROUP BY file_name
  ) stats ON cfg.file_id = stats.file_name
  ORDER BY
      COALESCE(stats.week_pv, 0) DESC,
      COALESCE(stats.week_download_count, 0) DESC;
""";
return db.select(sql);

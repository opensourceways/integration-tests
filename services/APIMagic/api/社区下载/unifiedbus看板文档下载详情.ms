{
  "properties" : { },
  "id" : "copy1757757537103d69646",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "unifiedbus看板文档下载详情",
  "createTime" : null,
  "updateTime" : 1776928172139,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/home/detail",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "hifloat",
    "description" : "暂时只支持unifiedbus",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "unifiedbus",
    "validateType" : "pattern",
    "error" : "暂时只支持unifiedbus",
    "expression" : "^(unifiedbus|hifloat)$",
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
    "value" : "datastat",
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
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"暂时只支持unifiedbus\",\n    \"data\": null,\n    \"timestamp\": 1776928156506,\n    \"executeTime\": 0\n}",
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
        title,
        COUNT(*) AS total_download_count,                    -- 总下载量
        COUNT(CASE 
            WHEN created_at >= DATE_TRUNC('week', CURRENT_DATE) 
            THEN 1 
        END) AS week_download_count,                   -- 本周下载量
        count(distinct username) as user_count,
        COUNT(DISTINCT country) AS country_download,         -- 下载国家数
        COUNT(DISTINCT city) AS city_download,             -- 下载城市数
        COUNT(DISTINCT company) AS company_download
    FROM 
        dwm_${community}_detail_download_daily
    WHERE 
        package_name  in (select  file_name from fact_unifiedbus_doc_name where is_show_home='true')
        AND created_at IS NOT NULL
        and title is not null
    GROUP BY 
        title
    ORDER BY 
        week_download_count DESC,  -- 可按本周热度排序
        total_download_count DESC;
""";
return db.select(sql);

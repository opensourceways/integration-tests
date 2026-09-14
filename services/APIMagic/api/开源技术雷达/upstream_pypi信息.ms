{
  "properties" : { },
  "id" : "e555fc599e9649fba1500064817799c2",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "upstream_pypi信息",
  "createTime" : null,
  "updateTime" : 1777378634470,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/upstreampypi/metric",
  "method" : "GET",
  "parameters" : [ {
    "name" : "type",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "Archive",
    "validateType" : "pass",
    "error" : null,
    "expression" : "^(PostTraining|inference|AIFrameworkAndAccelerator|compiler|Archive)$",
    "children" : null
  }, {
    "name" : "file_project",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^[a-zA-Z0-9_/-]{1,100}$",
    "children" : null
  }, {
    "name" : "date_str",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^(\\d{4}-\\d{2}-\\d{2})?$",
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
  "responseBody" : "{\n    \"code\": 403,\n    \"message\": \"用户没有权限\",\n    \"data\": null,\n    \"timestamp\": 1776934133118,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var type_tem = type;
var file_project_tem = file_project;
var date_str_tem = date_str;
if("Archive".equals(type_tem)){
  var sql = """SELECT 
      file_project,
      TO_CHAR(date_str, 'YYYY-MM') AS year_month,
      MAX(downloads) AS star
  FROM fact_upstream_pypi_data 
  WHERE date_str IS NOT NULL AND downloads IS NOT NULL  and ring ='Archive'
          and (type='PostTraining' OR type='inference' OR type='AIFrameworkAndAccelerator' or Type='compiler' )
            <if test="file_project_tem != null and file_project_tem != ''">
              and file_project=#{file_project_tem}
          </if>
            <if test="date_str_tem != null and date_str_tem != ''">
              and date_str::date >=#{date_str_tem}::date
          </if>
  GROUP BY file_project, TO_CHAR(date_str, 'YYYY-MM')
  
  """
  return db.select(sql)
}else{
  var sql = """SELECT 
      file_project,
      TO_CHAR(date_str, 'YYYY-MM') AS year_month,
      MAX(downloads) AS star
  FROM fact_upstream_pypi_data 
  WHERE date_str IS NOT NULL AND downloads IS NOT NULL  and ring !='Archive'
    <if test="type_tem != null and type_tem != ''">
              and type=#{type_tem}
          </if>
            <if test="file_project_tem != null and file_project_tem != ''">
              and file_project=#{file_project_tem}
          </if>
            <if test="date_str_tem != null and date_str_tem != ''">
              and date_str::date >=#{date_str_tem}::date
          </if>
  GROUP BY file_project, TO_CHAR(date_str, 'YYYY-MM')
  
  """
  return db.select(sql)
}

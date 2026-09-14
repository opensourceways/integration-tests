{
  "properties" : { },
  "id" : "c58d0e6792374fbfa142a670a2dc763f",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "雷达图接口",
  "createTime" : null,
  "updateTime" : 1777378557002,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/radar/metric",
  "method" : "GET",
  "parameters" : [ {
    "name" : "algorithm",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^(log|max-min|not)$",
    "children" : null
  }, {
    "name" : "type",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
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
  }, {
    "name" : "month",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^(\\d{4}-\\d{2})?$",
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
  "responseBody" : "{\n    \"code\": 401,\n    \"message\": \"用户未登录\",\n    \"data\": null,\n    \"timestamp\": 1775113260012,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var algorithm_tem = algorithm
var type_tem = type;
var file_project_tem = file_project;
var date_str_tem = date_str;
var month_tem = month;
var sql = null;
if("Archive".equals(type_tem)){
     sql = """
      SELECT 
          file_project,
          ring,
          MAX(score) AS score
      FROM fact_opensource_radar_data
      WHERE  score IS NOT NULL  and ring !='Archive'
                  and (type='PostTraining' OR type='inference' OR type='AIFrameworkAndAccelerator' or Type='compiler' )
                <if test="algorithm_tem != null and algorithm_tem != ''">
                  and algorithm=#{algorithm_tem}
              </if>
                <if test="date_str_tem != null and date_str_tem != ''">
                  and date_str::date >=#{date_str_tem}::date
              </if>
                <if test="month_tem != null and month_tem != ''">
            and month=#{month_tem}
        </if>
      GROUP BY file_project,ring
      """
}else{
   sql = """
      SELECT 
          file_project,
          ring,
          MAX(score) AS score
      FROM fact_opensource_radar_data 
      WHERE  score IS NOT NULL  and ring !='Archive'
                <if test="algorithm_tem != null and algorithm_tem != ''">
                  and algorithm=#{algorithm_tem}
              </if>
                <if test="type_tem != null and type_tem != ''">
                  and type=#{type_tem}
              </if>
                <if test="date_str_tem != null and date_str_tem != ''">
                  and date_str::date >=#{date_str_tem}::date
              </if>
  <if test="month_tem != null and month_tem != ''">
            and month=#{month_tem}
        </if>
      GROUP BY file_project,ring
      """
}
var dd = db.select(sql)
return  dd;

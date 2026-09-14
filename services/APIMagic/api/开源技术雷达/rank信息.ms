{
  "properties" : { },
  "id" : "9d7a53cd4c354f7caca693fb6e61f447",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "rank信息",
  "createTime" : null,
  "updateTime" : 1777378621194,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/rank/metric",
  "method" : "GET",
  "parameters" : [ {
    "name" : "type",
    "value" : "Archive",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2019-12-01\",\n        \"max_rank\": 0.58000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2020-09-01\",\n        \"max_rank\": 0.85000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2020-10-01\",\n        \"max_rank\": 2.84000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2020-11-01\",\n        \"max_rank\": 3.31000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2020-12-01\",\n        \"max_rank\": 3.78000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-01-01\",\n        \"max_rank\": 1.61000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-02-01\",\n        \"max_rank\": 0.95000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-03-01\",\n        \"max_rank\": 1.76000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-04-01\",\n        \"max_rank\": 4.18000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-05-01\",\n        \"max_rank\": 4.85000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-06-01\",\n        \"max_rank\": 7.91000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-07-01\",\n        \"max_rank\": 17.53000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-08-01\",\n        \"max_rank\": 18.83000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-09-01\",\n        \"max_rank\": 18.74000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-10-01\",\n        \"max_rank\": 17.00000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-11-01\",\n        \"max_rank\": 14.94000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2021-12-01\",\n        \"max_rank\": 12.88000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-01-01\",\n        \"max_rank\": 13.32000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-02-01\",\n        \"max_rank\": 11.81000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-03-01\",\n        \"max_rank\": 12.59000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-04-01\",\n        \"max_rank\": 12.11000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-05-01\",\n        \"max_rank\": 10.17000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-06-01\",\n        \"max_rank\": 11.99000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-07-01\",\n        \"max_rank\": 11.01000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-08-01\",\n        \"max_rank\": 12.57000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-09-01\",\n        \"max_rank\": 12.07000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-10-01\",\n        \"max_rank\": 13.47000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-11-01\",\n        \"max_rank\": 14.12000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2022-12-01\",\n        \"max_rank\": 10.12000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-01-01\",\n        \"max_rank\": 7.62000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-02-01\",\n        \"max_rank\": 6.79000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-03-01\",\n        \"max_rank\": 7.61000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-04-01\",\n        \"max_rank\": 6.14000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-05-01\",\n        \"max_rank\": 5.63000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-06-01\",\n        \"max_rank\": 4.53000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-07-01\",\n        \"max_rank\": 2.56000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-08-01\",\n        \"max_rank\": 1.79000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-09-01\",\n        \"max_rank\": 0.82000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-11-01\",\n        \"max_rank\": 0.80000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2023-12-01\",\n        \"max_rank\": 0.51000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2024-01-01\",\n        \"max_rank\": 0.41000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2024-02-01\",\n        \"max_rank\": 0.77000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2024-04-01\",\n        \"max_rank\": 0.76000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2024-05-01\",\n        \"max_rank\": 0.60000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2024-06-01\",\n        \"max_rank\": 0.47000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2024-07-01\",\n        \"max_rank\": 0.32000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2024-10-01\",\n        \"max_rank\": 0.24000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2024-11-01\",\n        \"max_rank\": 0.34000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2025-05-01\",\n        \"max_rank\": 0.21000\n    }, {\n        \"file_project\": \"bytedance/lightseq\",\n        \"year_month\": \"2025-07-01\",\n        \"max_rank\": 0.12000\n    }],\n    \"timestamp\": 1773826609200,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var type_tem = type;
var file_project_tem = file_project;
var date_str_tem = date_str;
var normal_type_tem = normal_type;
if("Archive".equals(type_tem)){
  var sql = """SELECT 
  file_project,
  TO_CHAR(date_str, 'YYYY-MM') AS year_month,
  MAX(rank) AS max_rank
  FROM fact_rank_data 
  WHERE date_str IS NOT NULL AND rank IS NOT NULL  and ring ='Archive'
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
      MAX(rank) AS max_rank
  FROM fact_rank_data 
  WHERE date_str IS NOT NULL AND rank IS NOT NULL  and ring !='Archive'
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

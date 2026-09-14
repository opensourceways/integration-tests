{
  "properties" : { },
  "id" : "copy1752821018045d45112",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "下载量按月(复制)",
  "createTime" : null,
  "updateTime" : 1773883428302,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/month",
  "method" : "POST",
  "parameters" : [ {
    "name" : "community",
    "value" : "mindspore",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
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
  "requestBody" : "{\r\n    \"community\":\"mindspore\",\r\n    \"start\":1730390400000,\r\n    \"end\":1743177600000,\r\n    \"source\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1773883411642,\n    \"executeTime\": 7\n}",
  "description" : null,
  "requestBodyDefinition" : {
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
      "description" : "开始时间戳",
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
      "description" : "结束时间戳",
      "required" : true,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "",
      "description" : "下载源",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
var source = body.source;
var community = body.community;
var start_time =date_format(start,'yyyy-MM-dd');
var end_time =date_format(end,'yyyy-MM-dd');
if(start_time==null || start_time =='' || community==null || community ==''){
    return  "communty,start_time参数必传,格式为 yyyy-mm-dd"
}
if(end_time==null || end_time ==''){
    var tem = start_time.split("-");
    end_time= start_time.split("-")[0]+"-12-01";
}
var  result = new ArrayList();
var modes = Arrays.asList("kit","framework","model");
for( model in modes){
       var selectsql = """
            WITH RECURSIVE date_range AS (
            SELECT #{start_time}::date AS month_start
            UNION ALL
            SELECT (month_start + INTERVAL '1 month')::date
            FROM date_range
            WHERE month_start < #{end_time}::date
        ),
        all_source_months AS (
        SELECT DISTINCT source, month_start
            FROM (SELECT #{model} as source ) src
            CROSS JOIN date_range
        ),
        monthly_data AS (
            SELECT  
                #{model} as source,
                DATE_TRUNC('month', created_at) AS month_start,
                SUM(download_day_increase) AS total_count
            FROM dws_mindspore_type_download_daily
            WHERE created_at > #{start_time}::date and data_type in (select value from dict_mindspore_download where type=#{model})
            GROUP BY  DATE_TRUNC('month', created_at) 
        )
        SELECT 
            a.source,
            TO_CHAR(a.month_start, 'YYYY-MM') AS month_date,
            COALESCE(m.total_count, 0) AS total_count
        FROM all_source_months a
        LEFT JOIN monthly_data m 
            ON a.source = m.source AND a.month_start = m.month_start
        ORDER BY a.source, a.month_start;
        """;
        result.addAll(db.select(selectsql))
}
return result;

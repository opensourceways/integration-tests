{
  "properties" : { },
  "id" : "1d76baddbf68478da6f57f035631d153",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "非unifiedbus社区地理下载量统计",
  "createTime" : null,
  "updateTime" : 1773883982550,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/geo/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "mindspore",
    "description" : "社区名称",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "group_field",
    "value" : "",
    "description" : "分组字段",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "group_field 只能为空或 country",
    "expression" : "^(country)?$",
    "children" : null
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
    "children" : null
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
    "children" : null
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
    "children" : null
  }, {
    "name" : "is_domestic",
    "value" : "",
    "description" : "是否国内",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "is_domestic 只能为 0 或 1",
    "expression" : "^(0|1)?$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"start 必须为合法的毫秒级时间戳\",\n    \"data\": null,\n    \"timestamp\": 1773883979232,\n    \"executeTime\": 0\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
var source = body.source;
var community = body.community;
var group_field = body.group_field;
var start_time =date_format(start,'yyyy-MM-dd');
var end_time =date_format(end,'yyyy-MM-dd');
var is_domestic =body.is_domestic;
var sum_feild = (is_domestic==null || "".equals(is_domestic))?"day_count": ("1".equals(is_domestic)?"inner_count":"outer_count")
var sql="""
       select  country,
    CASE 
        WHEN TRIM(country) = 'Hong Kong' THEN 'Hong Kong'
        ELSE region 
    END AS region,
    city,
         sum(${sum_feild})  AS download_count
    FROM dws_${community}_geo_download_daily
    WHERE created_at >= #{start_time}::date and  created_at <= #{end_time}::date  and ${sum_feild}>0
     <if test="source != null and source!=''">
            and source =#{source}
        </if>
    group by country,
    CASE 
        WHEN TRIM(country) = 'Hong Kong' THEN 'Hong Kong'
        ELSE region 
    END,
     city  
""";
var query_data = db.select(sql);
return query_data

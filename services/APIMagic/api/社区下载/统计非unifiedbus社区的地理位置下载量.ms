{
  "properties" : { },
  "id" : "8f9a9936cc8d42b3be6bf66bf559d203",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "统计非unifiedbus社区的地理位置下载量",
  "createTime" : null,
  "updateTime" : 1773883813682,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/geo/source",
  "method" : "POST",
  "parameters" : [ ],
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
  "requestBody" : "{\r\n    \"community\":\"mindspore\",\r\n    \"group_field\":\"\",\r\n    \"start\":1730390400000,\r\n    \"end\":1993177600000,\r\n    \"source\":\"\",\r\n    \"is_domestic\":\"\"\r\n\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"source\": \"mindspore.cn\",\n        \"country_count\": 78,\n        \"city_count\": 432,\n        \"region_count\": 204,\n        \"download_count\": 3602992\n    }],\n    \"timestamp\": 1763004822887,\n    \"executeTime\": 89\n}",
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
var group_field = body.group_field;
var start_time =date_format(start,'yyyy-MM-dd');
var end_time =date_format(end,'yyyy-MM-dd');
var is_domestic =body.is_domestic;
var sum_feild = (is_domestic==null || "".equals(is_domestic))?"day_count": ("1".equals(is_domestic)?"inner_count":"outer_count")
var group_field_tem = (group_field==null || "".equals(group_field))?"":(","+body.group_field)
var group_field_temp = (group_field==null || "".equals(group_field))?"":(body.group_field+",")
var sourcetemp =  (group_field==null || "".equals(group_field))?"":(group_field+",")
var sum_feild = (is_domestic==null || "".equals(is_domestic))?"day_count": ("1".equals(is_domestic)?"inner_count":"outer_count")
var fields = body.group_field.split(",")
var len = fields.length
var sql="""
      select source,${group_field_temp}
            count(distinct country) as country_count,
            count(distinct city) as city_count,
                   count(distinct region) as region_count,
         sum(${sum_feild})  AS download_count
    FROM dws_${community}_geo_download_daily
    WHERE created_at >= #{start_time}::date and  created_at <= #{end_time}::date  and ${sum_feild}>0
     <if test="source != null and source!=''">
            and source =#{source}
        </if>
     group by source ${group_field_tem}
""";
var query_data = db.select(sql);
return query_data

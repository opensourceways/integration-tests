{
  "properties" : { },
  "id" : "5a85c8fa-464c-4342-94ed-9c4d6f205fb9",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "CPU维度详情",
  "createTime" : null,
  "updateTime" : 1777111395213,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/cpu/dimension/detail",
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
  "requestBody" : "{\r\n    \"start\":1757196800000,\"end\":1782380800000,\"community\":\"\",\"group_field\":\"region_name\",\"dimension_type\":\"cycle\",\"metric_field\":\"cpu_usage\",\"region\":\"\",\"pageNum\":1,\"pageSize\":1000,\"asc\":\"\",\"desc\":\"\"\r\n    }",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 20,\n        \"total_page\": 1,\n        \"list\": [{\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-20 16:00:00\",\n            \"cpu_useage_max\": 50.79,\n            \"cpu_useage_avg\": 50.79,\n            \"cpu_useage_p50\": 50.79,\n            \"cpu_useage_p90\": 50.79,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 1\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-21 16:00:00\",\n            \"cpu_useage_max\": 62.01,\n            \"cpu_useage_avg\": 40.35,\n            \"cpu_useage_p50\": 40.35,\n            \"cpu_useage_p90\": 57.68,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 2\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-22 16:00:00\",\n            \"cpu_useage_max\": 59.92,\n            \"cpu_useage_avg\": 16.37,\n            \"cpu_useage_p50\": 1.92,\n            \"cpu_useage_p90\": 42.57,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 4\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-23 16:00:00\",\n            \"cpu_useage_max\": 59.47,\n            \"cpu_useage_avg\": 35.15,\n            \"cpu_useage_p50\": 39.52,\n            \"cpu_useage_p90\": 56.88,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 4\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-24 16:00:00\",\n            \"cpu_useage_max\": 2.39,\n            \"cpu_useage_avg\": 2.39,\n            \"cpu_useage_p50\": 2.39,\n            \"cpu_useage_p90\": 2.39,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 1\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-24 17:00:00\",\n            \"cpu_useage_max\": 2.46,\n            \"cpu_useage_avg\": 2.46,\n            \"cpu_useage_p50\": 2.46,\n            \"cpu_useage_p90\": 2.46,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 1\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-24 18:00:00\",\n            \"cpu_useage_max\": 2.57,\n            \"cpu_useage_avg\": 2.57,\n            \"cpu_useage_p50\": 2.57,\n            \"cpu_useage_p90\": 2.57,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 1\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-24 19:00:00\",\n            \"cpu_useage_max\": 2.52,\n            \"cpu_useage_avg\": 2.52,\n            \"cpu_useage_p50\": 2.52,\n            \"cpu_useage_p90\": 2.52,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 1\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-24 20:00:00\",\n            \"cpu_useage_max\": 2.62,\n            \"cpu_useage_avg\": 2.62,\n            \"cpu_useage_p50\": 2.62,\n            \"cpu_useage_p90\": 2.62,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 1\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-24 21:00:00\",\n            \"cpu_useage_max\": 2.64,\n            \"cpu_useage_avg\": 2.64,\n            \"cpu_useage_p50\": 2.64,\n            \"cpu_useage_p90\": 2.64,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 1\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-24 22:00:00\",\n            \"cpu_useage_max\": 2.66,\n            \"cpu_useage_avg\": 2.66,\n            \"cpu_useage_p50\": 2.66,\n            \"cpu_useage_p90\": 2.66,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 1\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-24 23:00:00\",\n            \"cpu_useage_max\": 2.76,\n            \"cpu_useage_avg\": 2.76,\n            \"cpu_useage_p50\": 2.76,\n            \"cpu_useage_p90\": 2.76,\n            \"mem_useage_max\": null,\n            \"mem_useage_avg\": null,\n            \"mem_useage_p50\": null,\n            \"mem_useage_p90\": null,\n            \"record_count\": 1\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-25 00:00:00\",\n            \"cpu_useage_max\": 82.47,\n            \"cpu_useage_avg\": 52.44,\n            \"cpu_useage_p50\": 54.64,\n            \"cpu_useage_p90\": 76.40,\n            \"mem_useage_max\": 16.82,\n            \"mem_useage_avg\": 9.02,\n            \"mem_useage_p50\": 7.72,\n            \"mem_useage_p90\": 13.24,\n            \"record_count\": 8\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-25 01:00:00\",\n            \"cpu_useage_max\": 86.86,\n            \"cpu_useage_avg\": 57.42,\n            \"cpu_useage_p50\": 70.49,\n            \"cpu_useage_p90\": 85.63,\n            \"mem_useage_max\": 24.43,\n            \"mem_useage_avg\": 10.50,\n            \"mem_useage_p50\": 7.93,\n            \"mem_useage_p90\": 18.43,\n            \"record_count\": 6\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-25 02:00:00\",\n            \"cpu_useage_max\": 100.00,\n            \"cpu_useage_avg\": 38.36,\n            \"cpu_useage_p50\": 34.50,\n            \"cpu_useage_p90\": 74.82,\n            \"mem_useage_max\": 10.30,\n            \"mem_useage_avg\": 5.50,\n            \"mem_useage_p50\": 5.55,\n            \"mem_useage_p90\": 9.40,\n            \"record_count\": 8\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-25 03:00:00\",\n            \"cpu_useage_max\": 100.00,\n            \"cpu_useage_avg\": 44.29,\n            \"cpu_useage_p50\": 41.98,\n            \"cpu_useage_p90\": 66.64,\n            \"mem_useage_max\": 18.69,\n            \"mem_useage_avg\": 7.12,\n            \"mem_useage_p50\": 5.14,\n            \"mem_useage_p90\": 11.90,\n            \"record_count\": 8\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-25 04:00:00\",\n            \"cpu_useage_max\": 31.32,\n            \"cpu_useage_avg\": 19.04,\n            \"cpu_useage_p50\": 18.14,\n            \"cpu_useage_p90\": 30.27,\n            \"mem_useage_max\": 5.97,\n            \"mem_useage_avg\": 4.64,\n            \"mem_useage_p50\": 4.28,\n            \"mem_useage_p90\": 5.58,\n            \"record_count\": 8\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-25 05:00:00\",\n            \"cpu_useage_max\": 38.43,\n            \"cpu_useage_avg\": 13.86,\n            \"cpu_useage_p50\": 9.46,\n            \"cpu_useage_p90\": 30.02,\n            \"mem_useage_max\": 5.40,\n            \"mem_useage_avg\": 3.64,\n            \"mem_useage_p50\": 4.14,\n            \"mem_useage_p90\": 5.12,\n            \"record_count\": 8\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-25 06:00:00\",\n            \"cpu_useage_max\": 45.92,\n            \"cpu_useage_avg\": 16.98,\n            \"cpu_useage_p50\": 16.72,\n            \"cpu_useage_p90\": 33.24,\n            \"mem_useage_max\": 5.40,\n            \"mem_useage_avg\": 3.10,\n            \"mem_useage_p50\": 2.86,\n            \"mem_useage_p90\": 4.70,\n            \"record_count\": 8\n        }, {\n            \"group_field\": \"西南-贵阳\",\n            \"timestamp\": \"2026-04-25 07:00:00\",\n            \"cpu_useage_max\": 31.18,\n            \"cpu_useage_avg\": 4.79,\n            \"cpu_useage_p50\": 0.91,\n            \"cpu_useage_p90\": 10.82,\n            \"mem_useage_max\": 5.39,\n            \"mem_useage_avg\": 2.34,\n            \"mem_useage_p50\": 1.48,\n            \"mem_useage_p90\": 4.28,\n            \"record_count\": 8\n        }]\n    },\n    \"timestamp\": 1777108960701,\n    \"executeTime\": 19\n}",
  "description" : "获取CPU维度数据详情，支持按社区、地域分组统计，支持维度汇总和时间周期两种模式",
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
      "name" : "start",
      "value" : "1757196800000",
      "description" : "开始时间戳(毫秒)",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1782380800000",
      "description" : "结束时间戳(毫秒)",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "",
      "description" : "社区名称，可选",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "group_field",
      "value" : "community",
      "description" : "分组字段",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "group_field 参数格式非法",
      "expression" : "^(community|region_name|resource_name)$",
      "children" : [ ]
    }, {
      "name" : "dimension_type",
      "value" : "cycle",
      "description" : "维度类型：dimension-维度汇总，cycle-时间周期",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "dimension_type 参数格式非法",
      "expression" : "^(dimension|cycle)$",
      "children" : [ ]
    }, {
      "name" : "metric_field",
      "value" : "cpu_useage",
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
      "name" : "region",
      "value" : "",
      "description" : "地域，可选",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "1",
      "description" : "页码，从1开始",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "1000",
      "description" : "每页数量",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "asc",
      "value" : "",
      "description" : "升序排序字段",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "desc",
      "value" : "",
      "description" : "降序排序字段",
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
var community = body.community;
var region = body.region;
var resource_name = body.resource_name
var dimension_type = body.dimension_type;
var group_field = body.group_field;
var group_field_temp = body.group_field;
var sub_group_field = body.group_field;
var sub_group_field_temp = body.group_field;

if(null != body.group_field && !"".equals(body.group_field)){
    group_field = group_field+" as group_field,"
    if("cycle".equals(body.dimension_type)){
        group_field = group_field+"timestamp,"
    }
}
if(null == body.group_field || "".equals(body.group_field)){
    group_field = group_field+" 'All' as group_field,"
    if("cycle".equals(body.dimension_type)){
        group_field = group_field+"timestamp,"
    }
}
if(null != body.group_field && !"".equals(body.group_field)){
    sub_group_field = sub_group_field+","
    if("cycle".equals(body.dimension_type)){
        sub_group_field = sub_group_field+"timestamp,"
    }
}
if(null == body.group_field || "".equals(body.group_field)){
    sub_group_field = " 'All' as All,"
    if("cycle".equals(body.dimension_type)){
        sub_group_field = sub_group_field+"timestamp,"
    }
}
if("cycle".equals(body.dimension_type) && (null != body.group_field && !"".equals(body.group_field))){
        group_field_temp = group_field_temp+",timestamp"
}else if( "cycle".equals(body.dimension_type)  && (null == body.group_field || "".equals(body.group_field)) ){
        group_field_temp ="timestamp"
}
if("cycle".equals(body.dimension_type) && (null != body.group_field && !"".equals(body.group_field))){
        sub_group_field_temp = sub_group_field_temp+",timestamp"
}else if( "cycle".equals(body.dimension_type)  && (null == body.group_field || "".equals(body.group_field)) ){
        sub_group_field_temp ="timestamp"
}

var page_num = 1;
if (body.pageNum != null and body.pageNum != ""){
    page_num = body.pageNum;
}
if (body.page_num != null and body.page_num != ""){
    page_num = body.page_num;
}
var page_size = 10;
if (body.pageSize != null and body.pageSize != ""){
    page_size = body.pageSize;
}
if (body.page_size != null and body.page_size != ""){
    page_size = body.page_size;
}
var offset_num = page_size * (page_num - 1)

var order_by_set = new HashSet()
var order_asc = "";
if (body.asc != null and body.asc != "") {
    var asc_arr = body.asc.split(",");
    for(index,item in asc_arr){
        order_by_set.add(item + " asc");
    }
}
var order_desc = "";
if (body.desc != null and body.desc != "") {
    var desc_arr = body.desc.split(",");
    for(index,item in desc_arr){
        order_by_set.add(item + " desc");
    }
}
var order_by = "";
if (order_by_set.size() > 0){
    order_by = "ORDER BY " + order_by_set.join(",");
}

if("dimension".equals(body.dimension_type) && (null == body.group_field || "".equals(body.group_field))){
    var all_sql = """
            SELECT 
               'All' as group_field,
                ROUND(AVG(cpu_usage)::numeric,2) as cpu_useage,
                ROUND(MAX(cpu_usage)::numeric,2) as cpu_useage_max,
                ROUND(AVG(cpu_usage)::numeric,2) as cpu_useage_avg,
                ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cpu_usage)::numeric,2) as cpu_useage_p50,
                ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY cpu_usage)::numeric,2) as cpu_useage_p90,
                ROUND(MAX(mem_usage)::numeric,2) as mem_useage_max,
                ROUND(AVG(mem_usage)::numeric,2) as mem_useage_avg,
                ROUND(AVG(mem_usage)::numeric,2) as mem_useage,

                ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mem_usage)::numeric,2) as mem_useage_p50,
                ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY mem_usage)::numeric,2) as mem_useage_p90,
                COUNT(*) as record_count
            FROM dws_cloud_cpu_details_hour b INNER JOIN dim_day c ON CAST(b.timestamp AS DATE) = c.date_id
                where
                    timestamp>=#{start} and timestamp <=#{end}
                    and c.is_holiday = false and c.is_weekend = false
                <if test="community != null and community != ''">
                    and b.community= #{community}
                </if>    
                <if test="region != null and region != ''">
                    and b.region= #{region}
                </if>    
                <if test="resource_name != null and resource_name != ''">
                    and b.resource_name= #{resource_name}
                </if>   
    """
    if (order_by != ""){
        all_sql = all_sql + order_by
    }
    HashMap all_ll_result = new HashMap();
    all_ll_result.put("list", db.select(all_sql));
    all_ll_result.put("total_count", 1);
    all_ll_result.put("total_page", 1);
    return all_ll_result;
}

var sql = """ 
            SELECT 
                ${group_field}
                ROUND(MAX(cpu_usage)::numeric,2) as cpu_useage_max,
                                ROUND(AVG(cpu_usage)::numeric,2) as cpu_useage,

                ROUND(AVG(cpu_usage)::numeric,2) as cpu_useage_avg,
                ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cpu_usage)::numeric,2) as cpu_useage_p50,
                ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY cpu_usage)::numeric,2) as cpu_useage_p90,
                ROUND(MAX(mem_usage)::numeric,2) as mem_useage_max,
                ROUND(AVG(mem_usage)::numeric,2) as mem_useage_avg,
                                ROUND(AVG(mem_usage)::numeric,2) as mem_useage,

                ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mem_usage)::numeric,2) as mem_useage_p50,
                ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY mem_usage)::numeric,2) as mem_useage_p90,
                COUNT(*) as record_count
            FROM dws_cloud_cpu_details_hour b INNER JOIN dim_day c ON CAST(b.timestamp AS DATE) = c.date_id
                where
                    timestamp>=#{start} and timestamp <=#{end}
                    and c.is_holiday = false and c.is_weekend = false
                <if test="community != null and community != ''">
                    and b.community= #{community}
                </if>    
                <if test="region != null and region != ''">
                    and b.region= #{region}
                </if>    
                                <if test="resource_name != null and resource_name != ''">
                    and b.resource_name= #{resource_name}
                </if>   
                GROUP BY ${group_field_temp} LIMIT #{page_size} OFFSET #{offset_num}       
            """;
var total_sql = """select count(*) as count from ( SELECT 
                ${group_field}
                COUNT(*) as record_count
            FROM dws_cloud_cpu_details_hour b INNER JOIN dim_day c ON CAST(b.timestamp AS DATE) = c.date_id
                where
                    timestamp>=#{start} and timestamp <=#{end}
                    and c.is_holiday = false and c.is_weekend = false
                <if test="community != null and community != ''">
                    and b.community= #{community}
                </if>    
                <if test="region != null and region != ''">
                    and b.region= #{region}
                </if>    
                <if test="resource_name != null and resource_name != ''">
                    and b.resource_name= #{resource_name}
                </if>   
                GROUP BY ${group_field_temp})
             """;
var query_data =  db.select(sql)
HashMap result = new HashMap();
var total_count = db.selectOne(total_sql).get("count");
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_count/page_size+1);
return  result
{
  "properties" : { },
  "id" : "8171e30da7984d52a7645e30fa8b6041",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "npupr",
  "createTime" : null,
  "updateTime" : 1776922714397,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/npu/dimension/detail",
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
  "requestBody" : "{\r\n    \"start\":1767196800000,\"end\":1772380800000,\"community\":\"\",\"group_field\":\"community\",\"dimension_type\":\"cycle\",\"metric_field\":\"total_node_npu\",\"functions\":\"Ascend统一资源池-贵阳-A2(910B1)\",\"service_name\":\"\",\"product_spec_desc\":\"\",\"domain\":\"\",\"pageNum\":1,\"pageSize\":1000,\"asc\":\"\",\"desc\":\"\"}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"body[metric_field]不满足正则表达式\",\n    \"data\": null,\n    \"timestamp\": 1773886226584,\n    \"executeTime\": 1\n}",
  "description" : null,
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
      "name" : "start",
      "value" : "1767196800000",
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
      "name" : "end",
      "value" : "1772380800000",
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
      "name" : "community",
      "value" : "",
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
      "name" : "group_field",
      "value" : "community",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(community|functions|serviece_name|cluster_name|product_spec_desc)$",
      "children" : [ ]
    }, {
      "name" : "dimension_type",
      "value" : "dimension",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(dimension|cycle)$",
      "children" : [ ]
    }, {
      "name" : "metric_field",
      "value" : "total_node_npu",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(?!.*\\b(\\w+)\\b.*\\b\\1\\b)(?:\\s*(pr_count|total_node_npu|max_node_npu_used|npu_useage|wait_time|run_time)\\s*)(?:,\\s*(?:pr_count|total_node_npu|max_node_npu_used|npu_useage|wait_time|run_time)\\s*)*$",
      "children" : [ ]
    }, {
      "name" : "functions",
      "value" : "vLLM-贵阳-A3",
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
      "name" : "service_name",
      "value" : "",
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
      "name" : "product_spec_desc",
      "value" : "",
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
      "name" : "domain",
      "value" : "",
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
      "name" : "pageNum",
      "value" : "1",
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
      "name" : "pageSize",
      "value" : "1000",
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
      "name" : "asc",
      "value" : "",
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
      "name" : "desc",
      "value" : "",
      "description" : "",
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
var service_name = body.service_name;
var functions = body.functions ;
var product_spec_desc = body.product_spec_desc ;
var domain = body.domain ;
var dimension_type = body.dimension_type;
var group_field = body.group_field;
var group_field_temp = body.group_field;
var sub_group_field = body.group_field;
var sub_group_field_temp = body.group_field;
if("product_spec_desc".equals(body.group_field)){
    group_field_temp = "resource_name";
    sub_group_field_temp = "resource_name"
    group_field = "resource_name"
    sub_group_field = "resource_name"
}
if("functions".equals(body.group_field)){
    group_field_temp = "cluster_name";
    sub_group_field_temp = "cluster_name"
    group_field = "cluster_name"
    sub_group_field = "cluster_name"
}
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
var start_time =date_format(start,'yyyy-MM-dd');
var end_time =date_format(end,'yyyy-MM-dd');
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
    order_by = order_by_set.join(",");
}
if("dimension".equals(body.dimension_type)  && (null == body.group_field || "".equals(body.group_field))){
    var all_sql = """
            SELECT 
               'All' as group_field,
                SUM(node_npu_total) AS total_node_npu,
                round(SUM(avg_node_npu_used)::numeric,2) as avg_node_npu_used,
                SUM(max_node_npu_used) as max_node_npu_used,
                round(SUM(midle_max_node_npu_used)::numeric,2) as midle_node_npu_used,
                sum(pr_count) as pr_count,
                round(SUM(avg_node_npu_used)::numeric/SUM(node_npu_total),2 ) as npu_useage,
                round(SUM(avg_node_npu_used)::numeric/SUM(node_npu_total),2 ) as avg_npu_useage,
                round(SUM(midle_max_node_npu_used)::numeric/SUM(node_npu_total),2 ) as midle_npu_useage,
                round(SUM(max_node_npu_used)::numeric/SUM(node_npu_total),2 ) as max_npu_useage,
                            round(avg(avg_run_time::numeric),2) AS run_time, 
                    round(avg(avg_wait_time::numeric),2) AS wait_time
            FROM (
                SELECT 
                    b.node, 
                    sum(  b.pr_count) as pr_count,
                    MAX(b.node_npu_total) AS node_npu_total,
                    avg(b.node_npu_used::numeric) AS avg_node_npu_used, 
                    MAX(b.node_npu_used::numeric) AS max_node_npu_used, 
                    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY b.node_npu_used::numeric) as midle_max_node_npu_used,
                    avg(b.run_time::numeric) AS avg_run_time, 
                    avg(b.wait_time::numeric) AS avg_wait_time
                FROM dws_cloud_npu_details_hour b  INNER JOIN dim_day c ON CAST(b.timestamp AS DATE) = c.date_id
                    where
                        timestamp>=#{start} and timestamp <=#{end}
                        and c.is_holiday = false and c.is_weekend = false
                        and b.cluster_name is not null
                    <if test="community != null and community != ''">
                        and b.community= #{community}
                    </if>    
                    <if test="service_name != null and service_name != ''">
                        and b.service_name= #{service_name}
                    </if>    
                    <if test="functions != null and functions != ''">
                        and b.cluster_name= #{functions}
                    </if>    
                    <if test="product_spec_desc != null and product_spec_desc != ''">
                        and b.node= #{product_spec_desc}
                    </if>  
                     <if test="domain != null and domain!=''">
                        and  domain=#{domain}
                    </if>
                        GROUP BY b.node
                    ) AS deduplicated
    """
    HashMap all_ll_result = new HashMap();
    all_ll_result.put("list", db.select(all_sql));
    all_ll_result.put("total_count", 1);
    all_ll_result.put("total_page", 1);
    return all_ll_result;
}
var sql = """ 
            SELECT 
                ${group_field}
                SUM(node_npu_total) AS total_node_npu,
                round(SUM(avg_node_npu_used)::numeric,2) as avg_node_npu_used,
                SUM(max_node_npu_used) as max_node_npu_used,
                round(SUM(midle_max_node_npu_used)::numeric,2) as midle_node_npu_used,
                sum(pr_count) as pr_count,
                round(SUM(avg_node_npu_used)::numeric/SUM(node_npu_total),2 ) as npu_useage,
                round(SUM(avg_node_npu_used)::numeric/SUM(node_npu_total),2 ) as avg_npu_useage,
                round(SUM(midle_max_node_npu_used)::numeric/SUM(node_npu_total),2 ) as midle_npu_useage,
                round(SUM(max_node_npu_used)::numeric/SUM(node_npu_total),2 ) as max_npu_useage,
                            round(avg(avg_run_time::numeric),2) AS run_time, 
                    round(avg(avg_wait_time::numeric),2) AS wait_time
            FROM (
                SELECT 
                    ${sub_group_field}
                    b.node, 
                    sum(  b.pr_count) as pr_count,
                    MAX(b.node_npu_total) AS node_npu_total,
                    avg(b.node_npu_used::numeric) AS avg_node_npu_used, 
                    MAX(b.node_npu_used::numeric) AS max_node_npu_used, 
                    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY b.node_npu_used::numeric) as midle_max_node_npu_used,
                    avg(b.run_time::numeric) AS avg_run_time, 
                    avg(b.wait_time::numeric) AS avg_wait_time
                FROM dws_cloud_npu_details_hour b  INNER JOIN dim_day c ON CAST(b.timestamp AS DATE) = c.date_id
                    where
                        timestamp>=#{start} and timestamp <=#{end}
                        and c.is_holiday = false and c.is_weekend = false                        and b.cluster_name is not null
                    <if test="community != null and community != ''">
                        and b.community= #{community}
                    </if>    
                    <if test="service_name != null and service_name != ''">
                        and b.service_name= #{service_name}
                    </if>    
                    <if test="functions != null and functions != ''">
                        and b.cluster_name= #{functions}
                    </if>    
                    <if test="product_spec_desc != null and product_spec_desc != ''">
                        and b.node= #{product_spec_desc}
                    </if>  
                                         <if test="domain != null and domain!=''">
                        and  domain=#{domain}
                    </if>
                        GROUP BY ${sub_group_field_temp}, b.node
                    ) AS deduplicated
            GROUP BY ${group_field_temp} LIMIT #{page_size} OFFSET #{offset_num}       
            """;
var total_sql = """select count(*) as count from ( SELECT 
                ${group_field}
                SUM(node_npu_total) AS total_node_npu,
                round(SUM(avg_node_npu_used)::numeric,2) as avg_node_npu_used,
                SUM(max_node_npu_used) as max_node_npu_used,
                round(SUM(midle_max_node_npu_used)::numeric,2) as midle_node_npu_used,
                sum(pr_count) as pr_count,
                round(SUM(avg_node_npu_used)::numeric/SUM(node_npu_total),2 ) as avg_npu_useage,
                round(SUM(midle_max_node_npu_used)::numeric/SUM(node_npu_total),2 ) as midle_npu_useage,
                round(SUM(max_node_npu_used)::numeric/SUM(node_npu_total),2 ) as max_npu_useage,
                            round(avg(avg_run_time::numeric),2) AS run_time, 
                    round(avg(avg_wait_time::numeric),2) AS wait_time
            FROM (
                SELECT 
                    ${sub_group_field}
                    b.node, 
                    sum(  b.pr_count) as pr_count,
                    MAX(b.node_npu_total) AS node_npu_total,
                    avg(b.node_npu_used::numeric) AS avg_node_npu_used, 
                    MAX(b.node_npu_used::numeric) AS max_node_npu_used, 
                    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY b.node_npu_used::numeric) as midle_max_node_npu_used,
                    avg(b.run_time::numeric) AS avg_run_time, 
                    avg(b.wait_time::numeric) AS avg_wait_time
                FROM dws_cloud_npu_details_hour b  INNER JOIN dim_day c ON CAST(b.timestamp AS DATE) = c.date_id
                    where
                        timestamp>=#{start} and timestamp <=#{end}
                        and c.is_holiday = false and c.is_weekend = false
                                                and b.cluster_name is not null
                    <if test="community != null and community != ''">
                        and b.community= #{community}
                    </if>    
                    <if test="service_name != null and service_name != ''">
                        and b.service_name= #{service_name}
                    </if>    
                    <if test="functions != null and functions != ''">
                        and b.cluster_name= #{functions}
                    </if>    
                    <if test="product_spec_desc != null and product_spec_desc != ''">
                        and b.node= #{product_spec_desc}
                    </if>  
                     <if test="domain != null and domain!=''">
                        and  domain=#{domain}
                    </if>
                        GROUP BY ${group_field_temp}, b.node
                    ) AS deduplicated
            GROUP BY ${group_field_temp})
             """;
var query_data =  db.select(sql)
HashMap result = new HashMap();
var total_count = db.selectOne(total_sql).get("count");
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_count/page_size+1);
return  result
return db.select(sql)

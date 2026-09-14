{
  "properties" : { },
  "id" : "copy1770343476779d82443",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "资源使用",
  "createTime" : null,
  "updateTime" : 1774511770226,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/usage/dimension/detail",
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
  }, {
    "name" : "permission",
    "value" : "datastatInfra_View",
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
  "requestBody" : "{\r\n\"start\":1744518400000,\r\n    \"end\":1792771200000,\r\n    \"community\":\"\",\r\n    \"group_field\":\"community\",\r\n    \"dimension_type\":\"dimension\",\r\n    \"metric_field\": \"consume_amount,useage\",\r\n    \"service_name\":\"\",\r\n    \"asc\":\"\",\r\n    \"desc\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 9,\n        \"total_page\": 1,\n        \"list\": [{\n            \"group_field\": \"openUBMC\",\n            \"consume_amount\": 249075.3236,\n            \"useage\": 0.33045128205128205128\n        }, {\n            \"group_field\": \"Mind系列\",\n            \"consume_amount\": 823996.2495,\n            \"useage\": null\n        }, {\n            \"group_field\": \"CANN\",\n            \"consume_amount\": 236072.4405,\n            \"useage\": null\n        }, {\n            \"group_field\": \"昇腾第三方社区CI\",\n            \"consume_amount\": 7219520.4866,\n            \"useage\": 0.33283205128205128205\n        }, {\n            \"group_field\": \"鲲鹏第三方社区CI\",\n            \"consume_amount\": 7870.4116,\n            \"useage\": null\n        }, {\n            \"group_field\": \"统一资源\",\n            \"consume_amount\": 1157112.7083,\n            \"useage\": 0.36828888888888888889\n        }, {\n            \"group_field\": \"openGuass\",\n            \"consume_amount\": 495061.0904,\n            \"useage\": 0.39833214285714285714\n        }, {\n            \"group_field\": \"灵衢社区\",\n            \"consume_amount\": 55104.7910,\n            \"useage\": 0.41580000000000000000\n        }, {\n            \"group_field\": \"MindSpore\",\n            \"consume_amount\": 4921466.8884,\n            \"useage\": 0.45596574585635359116\n        }]\n    },\n    \"timestamp\": 1773885700784,\n    \"executeTime\": 154\n}",
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
      "value" : "1744518400000",
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
      "value" : "1792771200000",
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
      "validateType" : "",
      "error" : "",
      "expression" : "^(community|functions|serviece_name|product_spec_desc)$",
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
      "value" : "consume_amount,useage",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(consume_amount|useage|consume_amount,useage|useage,consume_amount)$",
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
var funcations = body.funcations ;
var product_spec_desc = body.product_spec_desc ;
var domain = body.domain ;
var dimension_type = body.dimension_type;
var metric_field = body.metric_field;
var metric_fields = body.metric_field.split(",")
var metric_str = "";
for( ite in metric_fields ){
    if("consume_amount".equals(ite)){
        metric_str= metric_str+ " sum(consume_amount) as consume_amount,"
    }
    if("useage".equals(ite)){
        metric_str= metric_str+ " AVG(useage) FILTER (WHERE useage <= 1) as useage,"
    }
}
if (metric_str.endsWith(",")) {
    metric_str =  metric_str.substring(0, metric_str.length() - 1);
}
var group_field = body.group_field;
var group_field_temp = body.group_field;
if(null != body.group_field && !"".equals(body.group_field)){
    group_field = group_field+" as group_field,"
    if("cycle".equals(body.dimension_type)){
        group_field = group_field+body.dimension_type+","
    }
}
if(null == body.group_field || "".equals(body.group_field)){
    group_field = group_field+" 'All' as group_field,"
    if("cycle".equals(body.dimension_type)){
        group_field = group_field+body.dimension_type+","
    }
}
if("cycle".equals(body.dimension_type)  && (null != body.group_field && !"".equals(body.group_field)) ){
        group_field_temp = group_field_temp+","+body.dimension_type
}else if( "cycle".equals(body.dimension_type)  && (null == body.group_field || "".equals(body.group_field)) ){
        group_field_temp = body.dimension_type
}
group_field = group_field.replace("community","community_display_name ")
group_field = group_field.replace("product_spec_desc","cloud_service_type_name ")
group_field_temp = group_field_temp.replace("community","community_display_name")
group_field_temp = group_field_temp.replace("product_spec_desc","cloud_service_type_name")
var start_time =date_format(start,'yyyy-MM');
var end_time =date_format(end,'yyyy-MM');
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
if("cycle".equals(body.dimension_type)){
    order_by_set.add(  "cycle asc");
}
var order_by = "";
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
if("dimension".equals(body.dimension_type)  && (null == body.group_field || "".equals(body.group_field))){
    var all_sql = """
            select 'All' as group_field,sum(consume_amount) as consume_amount,AVG(useage) FILTER (WHERE useage <= 1) as useage    from  dwm_cloud_resource_details 
                    where
                    is_match='true' and
            cycle>=#{start_time} and cycle <=#{end_time}
            <if test="community != null and community != ''">
                and community_display_name= #{community}
            </if>    
              <if test="service_name != null and service_name != ''">
                and service_name= #{service_name}
            </if>    
            <if test="funcations != null and funcations != ''">
                and funcations= #{funcations}
            </if>    
            <if test="product_spec_desc != null and product_spec_desc != ''">
                and cloud_service_type_name= #{product_spec_desc}
            </if> 
            <if test="domain != null and domain!=''">
              and  domain=#{domain}
            </if>
    """
    HashMap all_ll_result = new HashMap();
    all_ll_result.put("list", db.select(all_sql));
    all_ll_result.put("total_count", 1);
    all_ll_result.put("total_page", 1);
    return all_ll_result;
}
var sql = """select ${group_field} ${metric_str}    from  dwm_cloud_resource_details
        where
          is_match='true' and
            cycle>=#{start_time} and cycle <=#{end_time}
            <if test="community != null and community != ''">
                and community_display_name= #{community}
            </if>    
              <if test="service_name != null and service_name != ''">
                and service_name= #{service_name}
            </if>    
            <if test="funcations != null and funcations != ''">
                and funcations= #{funcations}
            </if>    
            <if test="product_spec_desc != null and product_spec_desc != ''">
                and cloud_service_type_name= #{product_spec_desc}
            </if> 
                                                     <if test="domain != null and domain!=''">
              and  domain=#{domain}
            </if>
            <if test="group_field_temp != null and group_field_temp != ''">
                group BY ${group_field_temp}
            </if>      
            <if test="order_by != null and order_by != ''">
                ORDER BY ${order_by}
            </if>
            LIMIT #{page_size} OFFSET #{offset_num}
            """;
var total_sql = """select count(*) as count from ( select ${group_field} ${metric_str}   from  dwm_cloud_resource_details
            where
              is_match='true' and
            cycle>=#{start_time} and cycle <=#{end_time}
            <if test="community != null and community != ''">
                and community= #{community}
            </if>    
              <if test="service_name != null and service_name != ''">
                and service_name= #{service_name}
            </if>    
            <if test="funcations != null and funcations != ''">
                and funcations= #{funcations}
            </if>    
            <if test="product_spec_desc != null and product_spec_desc != ''">
                and cloud_service_type_name= #{product_spec_desc}
            </if>  
                                                     <if test="domain != null and domain!=''">
              and  domain=#{domain}
             </if>
            <if test="group_field_temp != null and group_field_temp != ''">
                group BY ${group_field_temp}
            </if>  
            )
             """;
var query_data =  db.select(sql)
HashMap result = new HashMap();
var total_count = db.selectOne(total_sql).get("count");
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_count/page_size+1);
return  result

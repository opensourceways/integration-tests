{
  "properties" : { },
  "id" : "6da8b3317087464991b95d99c97fd46c",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "资源使用情况",
  "createTime" : null,
  "updateTime" : 1774511778839,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/usage/detail",
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
  "requestBody" : "{\r\n\"start\":1577808000000,\r\n    \"end\":1898526240605,\r\n    \"community\":\"\",\r\n    \"group_field\":\"\",\r\n    \"service_name\":\"\",\r\n    \"asc\":\"\",\r\n    \"desc\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 1,\n        \"total_page\": 1,\n        \"list\": [{\n            \"consume_amount\": 15165280.3899,\n            \"useage_rate\": 15.3293\n        }]\n    },\n    \"timestamp\": 1773887054230,\n    \"executeTime\": 68\n}",
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
      "value" : "1577808000000",
      "description" : "开始时间，时间戳",
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
      "value" : "1898526240605",
      "description" : "结束时间，时间戳",
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
      "description" : "社区",
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
      "value" : "community,product_spec_desc",
      "description" : "维度（分组字段）",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(?!.*\\b(\\w+)\\b.*\\b\\1\\b)(?:\\s*(community|functions|service_name|product_spec_desc)\\s*)(?:,\\s*(?:community|functions|service_name|product_spec_desc)\\s*)*$",
      "children" : [ ]
    }, {
      "name" : "service_name",
      "value" : "",
      "description" : "服务名称",
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
      "description" : "升序字段",
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
      "description" : "降序字段",
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
var domain = body.domain;
var group_field = body.group_field;
var group_field_temp = body.group_field;
if(null != body.group_field && !"".equals(body.group_field)){
    group_field = group_field.replace("community","community_display_name as community")
    group_field_temp = group_field_temp.replace("community","community_display_name")
    group_field = group_field.replace("product_spec_desc","cloud_service_type_name as product_spec_desc")
    group_field_temp = group_field_temp.replace("product_spec_desc","cloud_service_type_name")
    group_field = group_field+","
}
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
var order_by = "";
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
var sql = """select ${group_field} sum(consume_amount) as consume_amount,round(AVG(CASE WHEN useage <= 100 THEN useage END),4) AS useage_rate  from  dwm_cloud_resource_details
        where
          is_match='true' and
            cycle>=#{start_time} and cycle <=#{end_time}
            <if test="community != null and community != ''">
                and community_display_name= #{community}
            </if>    
              <if test="service_name != null and service_name != ''">
                and service_name= #{service_name}
            </if>    
            <if test="functions != null and functions != ''">
                and functions= #{functions}
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
var total_sql = """select count(*) as count from ( select ${group_field} sum(consume_amount) as consume_amount,'-' as useage_rate  from  dwm_cloud_resource_details
            where
              is_match='true' and
            cycle>=#{start_time} and cycle <=#{end_time}
            <if test="community != null and community != ''">
                and community_display_name= #{community}
            </if>    
              <if test="service_name != null and service_name != ''">
                and service_name= #{service_name}
            </if>    
            <if test="functions != null and functions != ''">
                and functions= #{functions}
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

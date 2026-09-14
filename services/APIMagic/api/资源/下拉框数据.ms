{
  "properties" : { },
  "id" : "f4f872f0937d45458f2533ac10bdc090",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "下拉框数据",
  "createTime" : null,
  "updateTime" : 1774511751845,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/dict",
  "method" : "GET",
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"key\": \"功能\",\n        \"value\": \"functions\",\n        \"label\": \"功能\"\n    }, {\n        \"key\": \"社区\",\n        \"value\": \"community\",\n        \"label\": \"社区\"\n    }, {\n        \"key\": \"服务\",\n        \"value\": \"service_name\",\n        \"label\": \"服务\"\n    }, {\n        \"key\": \"资源\",\n        \"value\": \"product_spec_desc\",\n        \"label\": \"资源\"\n    }],\n    \"timestamp\": 1770781824770,\n    \"executeTime\": 3\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
community = community
functions = functions
service_name = service_name
product_spec_desc = product_spec_desc
domain = domain
if("community".equals(type)){
    return db.select("select distinct community_display_name as key,community_display_name as value,community_display_name as label,community_display_name as id from dwm_cloud_resource_details where community_display_name is not null  and is_match='true'")
}else if("functions".equals(type)){
    var sql = """
    select distinct functions as key,functions as value ,functions as label,functions as id from dwm_cloud_resource_details where is_match='true'
           <if test="community != null and community!=''">
              and  community=#{community}
            </if>
                   <if test="service_name != null and service_name!=''">
              and  service_name=#{service_name}
            </if>
                <if test="product_spec_desc != null and product_spec_desc!=''">
              and  product_spec_desc=#{product_spec_desc}
            </if>
                            <if test="domain != null and domain!=''">
              and  domain=#{domain}
            </if>
    """
    return db.select(sql)
}else if("service_name".equals(type)){
    var sql = """
     select distinct service_name as key,service_name as value,service_name as label,service_name as id from dwm_cloud_resource_details  where is_match='true'
            <if test="community != null and community!=''">
              and  community=#{community}
            </if>
           <if test="functions != null and functions!=''">
              and  functions=#{functions}
            </if>
                <if test="product_spec_desc != null and product_spec_desc!=''">
              and  product_spec_desc=#{product_spec_desc}
            </if>
                                        <if test="domain != null and domain!=''">
              and  domain=#{domain}
            </if>
    """
    return db.select(sql)
}else if("product_spec_desc".equals(type)){
    var sql = """
     select distinct cloud_service_type_name as key,cloud_service_type_name as value,cloud_service_type_name as label,cloud_service_type_name as id from dwm_cloud_resource_details  where is_match='true'
                 <if test="community != null and community!=''">
              and  community=#{community}
            </if>
           <if test="functions != null and functions!=''">
              and  functions=#{functions}
            </if>
                   <if test="service_name != null and service_name!=''">
              and  service_name=#{service_name}
            </if>
                                          <if test="domain != null and domain!=''">
              and  domain=#{domain}
            </if>
    """
    return db.select(sql)
}else{
    js = [
        {"key": "功能", "value": "functions","label":"功能"},
        {"key": "社区", "value": "community","label":"社区"},
        {"key": "服务", "value": "service_name","label":"服务"},
        {"key": "资源", "value": "product_spec_desc","label":"资源"}
        ]
    return js;
}

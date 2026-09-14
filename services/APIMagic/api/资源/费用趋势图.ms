{
  "properties" : { },
  "id" : "e6cd9ac583544f28a0cd64aa6ebcf915",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "费用趋势图",
  "createTime" : null,
  "updateTime" : 1774511743309,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/month/trend",
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
  "requestBody" : "{\r\n    \"community\":\"\",\r\n    \"start\":1730390400000,\r\n    \"end\":1993177600000\r\n\r\n\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1768985209640,\n    \"executeTime\": 12\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
var community = body.community;
var start_time =date_format(start,'yyyy-MM');
var end_time =date_format(end,'yyyy-MM');
var sql = """
select cycle,sum(consume_amount) from dwm_cloud_resource_details where 
    cycle>=#{start_time} and cycle <=#{end_time}
       <if test="community != null and community!=''">
              and  community=#{community}
            </if>
  GROUP BY cycle 
"""
return db.select(sql)

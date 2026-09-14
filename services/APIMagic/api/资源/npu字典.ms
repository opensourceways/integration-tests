{
  "properties" : { },
  "id" : "d466cdd193544fa7a85bf70f583c5c53",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "npu字典",
  "createTime" : null,
  "updateTime" : 1785728546908,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "npu/dict",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"key\": \"功能\",\n        \"value\": \"functions\",\n        \"label\": \"功能\"\n    }, {\n        \"key\": \"社区\",\n        \"value\": \"community\",\n        \"label\": \"社区\"\n    }, {\n        \"key\": \"服务\",\n        \"value\": \"service_name\",\n        \"label\": \"服务\"\n    }, {\n        \"key\": \"资源\",\n        \"value\": \"product_spec_desc\",\n        \"label\": \"资源\"\n    }],\n    \"timestamp\": 1770342768812,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
community = community
functions = functions
service_name = service_name
product_spec_desc = product_spec_desc
// 服务端白名单：type -> 主列名（沿用各分支原有列，返回语义不变；${col} 不来自用户输入）
var colMap = {
    "cluster": "cluster",
    "cluster_name": "cluster_name",
    "node": "node",
    "functions": "cluster_name",
    "service_name": "service_name",
    "product_spec_desc": "node"
}
if (type != null && colMap[type] != null) {
    var col = colMap[type]
    // functions/service_name/product_spec_desc 分支原含 id 字段，保持不变
    var idCol = ("functions".equals(type) || "service_name".equals(type) || "product_spec_desc".equals(type)) ? (", " + col + " as id") : ""
    var sql = """
        select distinct ${col} as key, ${col} as value, ${col} as label${idCol}
        from dws_cloud_npu_details_hour
        where 1=1
        <if test="type == 'cluster_name' or type == 'functions'"> and cluster_name is not null and timestamp >= '2026-04-30'</if>
        <if test="type == 'node' and cluster != null and cluster != ''"> and cluster = #{cluster} </if>
        <if test="type == 'node' and cluster_name != null and cluster_name != ''"> and cluster_name = #{cluster_name} </if>
        <if test="(type == 'functions' or type == 'service_name' or type == 'product_spec_desc') and community != null and community != ''"> and community = #{community} </if>
        <if test="type == 'functions' and service_name != null and service_name != ''"> and service_name = #{service_name} </if>
        <if test="type == 'functions' and product_spec_desc != null and product_spec_desc != ''"> and product_spec_desc = #{product_spec_desc} </if>
        <if test="type == 'service_name' and functions != null and functions != ''"> and functions = #{functions} </if>
        <if test="type == 'service_name' and product_spec_desc != null and product_spec_desc != ''"> and product_spec_desc = #{product_spec_desc} </if>
        <if test="type == 'product_spec_desc' and functions != null and functions != ''"> and functions = #{functions} </if>
        <if test="type == 'product_spec_desc' and service_name != null and service_name != ''"> and service_name = #{service_name} </if>
    """
    return db.select(sql)
} else if ("community".equals(type)) {
    return db.select("select distinct community as key,community as value,community as label,community as id from dws_cloud_npu_details_hour")
} else {
    return [
        {"key": "功能", "value": "functions", "label": "功能"},
        {"key": "社区", "value": "community", "label": "社区"},
        {"key": "服务", "value": "service_name", "label": "服务"},
        {"key": "资源", "value": "product_spec_desc", "label": "资源"}
    ]
}

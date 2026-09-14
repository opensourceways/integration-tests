{
  "properties" : { },
  "id" : "b77e46e9b776494f814a5ceb7d2e2318",
  "script" : null,
  "groupId" : "709908d8728741d19dd2d28b98d0e23a",
  "name" : "Dict",
  "createTime" : null,
  "updateTime" : 1774577133345,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/metric",
  "method" : "GET",
  "parameters" : [ {
    "name" : "metric",
    "value" : "d0",
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
  }, {
    "name" : "permission",
    "value" : "datastatadmin_View",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"name\": \"d1\",\n        \"name_zh\": \"D1\",\n        \"definition\": \"周期内提交PR/Issue/Comment的人数\",\n        \"scope\": \"衡量仓库的受欢迎程度或者活跃度\",\n        \"areasofuse_zh\": \"社区,创建时间,SIG名称,状态码,通用唯一标识符\"\n    }],\n    \"timestamp\": 1770031624876,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
SELECT
    name,
    name_zh,
    definition,
    scope,
    areasofuse_zh
FROM dws_metrics_dims_define_detail
WHERE 1 = 1
    <if test="metric != '' and metric != null">
        AND name = #{metric}
    </if>  
LIMIT 10000;
"""
return db.select(sqlstr)

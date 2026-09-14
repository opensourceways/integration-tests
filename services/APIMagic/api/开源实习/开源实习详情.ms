{
  "properties" : { },
  "id" : "984fec9c7bde49eab04e9ce5474526a1",
  "script" : null,
  "groupId" : "9b8fc487d76946a88319e081fa47f446",
  "name" : "开源实习详情",
  "createTime" : null,
  "updateTime" : 1775026431138,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/detail/page",
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
  "requestBody" : "{\"community\":\"vllm\",\"page\":1,\"pageSize\":10,\"fliter_arr\":[{\"field\":\"title\",\"operator\":\"leftLike\",\"value\":\"ggg\",\"combine\":\"title like 'ggg%' \"}],\"fliter_str\":{\"title_like\":\"ggg%\"}}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 0,\n        \"list\": []\n    },\n    \"timestamp\": 1773021405244,\n    \"executeTime\": 12\n}",
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
      "name" : "community",
      "value" : "vllm",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "page",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "1",
      "validateType" : "pass",
      "error" : null,
      "expression" : "page > 0 && page <= 1000",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "10",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "10",
      "validateType" : "pass",
      "error" : null,
      "expression" : "pageSize > 0 && pageSize <= 100",
      "children" : [ ]
    }, {
      "name" : "sort",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(created_at|updated_at|html_url|status)?$",
      "children" : [ ]
    }, {
      "name" : "order",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(asc|desc|ASC|DESC)?$",
      "children" : [ ]
    }, {
      "name" : "fliter_arr",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
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
          "name" : "field",
          "value" : "",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pattern",
          "error" : null,
          "expression" : "^(title|status|assign_user|tutor_login)$",
          "children" : [ ]
        }, {
          "name" : "operator",
          "value" : "",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pattern",
          "error" : null,
          "expression" : "^(leftLike|rightLike|eq|ne|gt|lt)$",
          "children" : [ ]
        } ]
      } ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var community_tem = body.community;
var page_tem = body.page || 1;          // 默认第 1 页，防止 undefined
var pageSize_tem = body.pageSize || 10; // 默认每页 10 条，防止 undefined
var fliter_arr = body.fliter_arr
var sort = body.sort
var order_temp = body.order
// 计算偏移量：(页码 - 1) * 每页数量
// 例如：第 1 页 offset=0, 第 2 页 offset=10
var offset = (page_tem - 1) * pageSize_tem;
// 拼接 SQL
// 注意：表名通常不能直接加参数化占位符，需要字符串拼接，但要注意防注入
var sql = """SELECT * FROM fact_${community_tem}_practice 
                    <if test="fliter_arr != null and fliter_arr.size() >0 ">
                        where 
                        <foreach item='item' index='index' collection='body.fliter_arr'
                             separator=" and " >
                            ${item.combine}
                        </foreach>
                    </if> 
                    <if test="body.sort != null and body.sort != '' ">
                        order by ${sort} ${order_temp}
                     </if> 
LIMIT #{pageSize_tem} OFFSET #{offset}""";
var totalsql = """select count(*) as total from (SELECT * FROM fact_${community_tem}_practice 
                    <if test="fliter_arr != null and fliter_arr.size() >0 ">
                        where 
                        <foreach item='item' index='index' collection='body.fliter_arr'
                             separator=" and " >
                            ${item.combine}
                        </foreach>
                    </if> 
)
""";
var data = db.select(sql);
var total = db.select(totalsql);
HashMap res = new HashMap();
res.put("list",data)
res.put("total",total.get(0).get("total"))
return res

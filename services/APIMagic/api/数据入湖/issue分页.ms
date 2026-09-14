{
  "properties" : { },
  "id" : "copy1772802194790d11947",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "issue分页",
  "createTime" : null,
  "updateTime" : 1778656003096,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/issue/page",
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
    "value" : "whitebox",
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
  "requestBody" : "{\r\n    \"pageNum\":1,\r\n    \"pageSize\":100,\r\n    \"startTime\":\"2026-01-01 00:00:00\",\r\n    \"endTime\":\"\"\r\n}",
  "headers" : [ {
    "name" : "token",
    "value" : null,
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 0,\n    \"message\": \"token校验失败\",\n    \"data\": null,\n    \"timestamp\": 1774578023815,\n    \"executeTime\": 1\n}",
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
      "name" : "pageNum",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "1",
      "validateType" : "pass",
      "error" : null,
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "100",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "100",
      "validateType" : "pass",
      "error" : null,
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "startTime",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
      "children" : [ ]
    }, {
      "name" : "endTime",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var page_tem = body.pageNum || 1;          // 默认第 1 页，防止 undefined
var pageSize_tem = body.pageSize || 1000; // 默认每页 10 条，防止 undefined
var startTime_tem = body.startTime
var endTime_tem = body.endTime
// 计算偏移量：(页码 - 1) * 每页数量
// 例如：第 1 页 offset=0, 第 2 页 offset=10
var offset = (page_tem - 1) * pageSize_tem;
// 拼接 SQL
// 注意：表名通常不能直接加参数化占位符，需要字符串拼接，但要注意防注入
var sql = """SELECT * FROM fact_all_issue
                    where is_removed is null   and repo_id is not null
                    <if test="startTime_tem != null and startTime_tem!='' ">
                         and   created_at >=#{startTime_tem}::timestamp
                    </if> 
                       <if test="endTime_tem != null and endTime_tem!='' ">
                          and  created_at <=#{endTime_tem}::timestamp
                    </if>      
LIMIT #{pageSize_tem} OFFSET #{offset}""";
var totalsql = """select count(*) as total from (SELECT * FROM fact_all_issue
                    where is_removed is null   and repo_id is not null
                    <if test="startTime_tem != null and startTime_tem!='' ">
                         and   created_at >=#{startTime_tem}::timestamp
                    </if> 
                       <if test="endTime_tem != null and endTime_tem!='' ">
                          and  created_at <=#{endTime_tem}::timestamp
                    </if>                
)
""";
var data = db.backup.select(sql);
var total = db.backup.select(totalsql);
HashMap res = new HashMap();
res.put("list",data)
res.put("total",total.get(0).get("total"))
return res

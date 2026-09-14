{
  "properties" : { },
  "id" : "58312f4d4be140e086f8db0129f5f970",
  "script" : null,
  "groupId" : "3d75a6c492184d51afba938d34338c98",
  "name" : "cloc",
  "createTime" : null,
  "updateTime" : 1774576315063,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/cloc",
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
  "requestBody" : "{\r\n    \"start\":1577808000000,\r\n    \"end\":1898526240605,\r\n    \"community\":\"openubmc\",\r\n    \"asc\":\"repo\",\r\n    \"desc\":\"asc\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 87,\n        \"total_page\": 9,\n        \"list\": [{\n            \"repo\": \"openUBMC/infrastructure\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"infrastructure\",\n            \"branch\": \"main\",\n            \"code\": 10528,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }, {\n            \"repo\": \"openUBMC/bcal\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"bcal\",\n            \"branch\": \"main\",\n            \"code\": 2,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }, {\n            \"repo\": \"openUBMC/devmon\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"devmon\",\n            \"branch\": \"main\",\n            \"code\": 42102,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }, {\n            \"repo\": \"openUBMC/software-center\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"software-center\",\n            \"branch\": \"main\",\n            \"code\": 1177,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }, {\n            \"repo\": \"openUBMC/conan-auth-proxy\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"conan-auth-proxy\",\n            \"branch\": \"main\",\n            \"code\": 2075,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }, {\n            \"repo\": \"openUBMC/conan_index\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"conan_index\",\n            \"branch\": \"main\",\n            \"code\": 5124,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }, {\n            \"repo\": \"openUBMC/skills-marketplace\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"skills-marketplace\",\n            \"branch\": \"main\",\n            \"code\": 7314,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }, {\n            \"repo\": \"openUBMC/certificate_mgmt\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"certificate_mgmt\",\n            \"branch\": \"main\",\n            \"code\": 12381,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }, {\n            \"repo\": \"openUBMC/Tencent\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"Tencent\",\n            \"branch\": \"main\",\n            \"code\": 17161,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }, {\n            \"repo\": \"openUBMC/ccf_openubmc\",\n            \"namespace\": \"openUBMC\",\n            \"repo_path\": \"ccf_openubmc\",\n            \"branch\": \"main\",\n            \"code\": 2,\n            \"created_at\": \"2026-03-24 08:00:00\"\n        }]\n    },\n    \"timestamp\": 1774316862175,\n    \"executeTime\": 9\n}",
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
      "value" : "",
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
      "value" : "",
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
      "validateType" : "pattern",
      "error" : "community 参数非法",
      "expression" : "^[a-zA-Z]{1,32}$",
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
// 顶部筛选（issue#1295 缺陷1）：数据源(code_platform)/组织(namespace)/公私仓(private)，与开发者/PR 统计表联动
// 内外部(internalList)不接入：fact_{c}_repo.internal 列存在但采集器（om-dataarts repo.py）从不写值、恒为 NULL，
// 且 cloc 为仓库级代码行数、无人员维度；强接会导致选“内部/外部”时表格直接空掉。故后端忽略 internalList。
var source = body.source;
var orgList = body.orgList;
var private = body.private;
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
var allowed_columns = ['code', 'created_at', 'repo', 'namespace', 'repo_path', 'branch'];
if (order_by_set.size() > 0){
    var validated_order = [];
    for (item in order_by_set.join(",").split(",")) {
        var col = item.trim().split(" ")[0];
        if (allowed_columns.contains(col)) {
            validated_order.add(item.trim());
        }
    }
    order_by = validated_order.join(",");
}
var sql = """select concat(a.namespace,'/',a.repo_path) as repo, a.namespace,a.repo_path,b.branch,b.code,b.created_at from  
            fact_${community}_repo a left join fact_${community}_cloc_detail b on Lower(a.namespace)=Lower(b.namespace) and  Lower(a.repo_path)=Lower(b.repo_path)
            where (b.branch='master' or  b.branch='main' or b.branch='ascendc_pto') and b.language='SUM'  and a.is_hide is null
            <if test="source != null and source != ''"> and a.code_platform = #{source} </if>
            <if test="private != null and private != ''"> and a.private = #{private} </if>
            <if test="orgList != null and orgList.size() > 0"> and a.namespace in <foreach collection="orgList" item="item" open="(" separator="," close=")"> #{item} </foreach> </if>
            and b.created_at in
            (select DISTINCT created_at  from fact_${community}_cloc_detail
            where created_at <=#{end_time}::date ORDER BY created_at desc  limit 1)
            <if test="order_by != null and order_by != ''">
ORDER BY #{order_by}
            </if>
            LIMIT #{page_size} OFFSET #{offset_num}
            """;
var total_sql = """ select count(*) from  
            fact_${community}_repo a left join fact_${community}_cloc_detail b on Lower(a.namespace)=Lower(b.namespace) and  Lower(a.repo_path)=Lower(b.repo_path)
            where (b.branch='master' or  b.branch='main' or b.branch='ascendc_pto') and b.language='SUM'  and a.is_hide is null
            <if test="source != null and source != ''"> and a.code_platform = #{source} </if>
            <if test="private != null and private != ''"> and a.private = #{private} </if>
            <if test="orgList != null and orgList.size() > 0"> and a.namespace in <foreach collection="orgList" item="item" open="(" separator="," close=")"> #{item} </foreach> </if>
            and b.created_at in
            (select DISTINCT created_at  from fact_${community}_cloc_detail
            where created_at <=#{end_time}::date ORDER BY created_at desc  limit 1)  """;
var query_data =  db.select(sql)
HashMap result = new HashMap();
var total_count = db.selectOne(total_sql).get("count");
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_count/page_size+1);
return  result

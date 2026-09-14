{
  "properties" : { },
  "id" : "copy1757754114556d37259",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "版本数据详情",
  "createTime" : null,
  "updateTime" : 1773911073944,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/version/detail",
  "method" : "POST",
  "parameters" : [ {
    "name" : "community",
    "value" : "unifiedbus",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openubmc",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "source",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "start_time",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "end_time",
    "value" : null,
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
  } ],
  "requestBody" : "{\r\n    \"community\":\"unifiedbus\",\r\n    \"group_field\":\"title\",\r\n    \"start\":1730390400000,\r\n    \"end\":1993177600000,\r\n    \"source\":\"\",\r\n    \"is_domestic\":\"1\",\r\n    \"pageSize\":10,\r\n    \"pageNum\":1\r\n\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 9,\n        \"total_page\": 1,\n        \"list\": [{\n            \"title\": \"灵衢®基础规范\",\n            \"download_count\": 9214,\n            \"company_count\": 510,\n            \"user_count\": 2503,\n            \"country_count\": 26,\n            \"city_count\": 99\n        }, {\n            \"title\": \"灵衢®固件规范\",\n            \"download_count\": 3198,\n            \"company_count\": 371,\n            \"user_count\": 1221,\n            \"country_count\": 20,\n            \"city_count\": 67\n        }, {\n            \"title\": \"灵衢®使能操作系统参考设计\",\n            \"download_count\": 6189,\n            \"company_count\": 329,\n            \"user_count\": 1070,\n            \"country_count\": 24,\n            \"city_count\": 105\n        }, {\n            \"title\": \"基于灵衢®的超节点参考架构白皮书\",\n            \"download_count\": 8760,\n            \"company_count\": 354,\n            \"user_count\": 1192,\n            \"country_count\": 27,\n            \"city_count\": 123\n        }, {\n            \"title\": \"UnifiedBus™ (UB) SuperPoD Reference Architecture White Paper\",\n            \"download_count\": 286,\n            \"company_count\": 29,\n            \"user_count\": 56,\n            \"country_count\": 19,\n            \"city_count\": 41\n        }, {\n            \"title\": \"UnifiedBus™ (UB) Software Reference Design for Operating Systems\",\n            \"download_count\": 304,\n            \"company_count\": 25,\n            \"user_count\": 51,\n            \"country_count\": 15,\n            \"city_count\": 26\n        }, {\n            \"title\": \"UnifiedBus™ (UB) Management and O&M Software Architecture and Interface Reference Design\",\n            \"download_count\": 205,\n            \"company_count\": 24,\n            \"user_count\": 44,\n            \"country_count\": 14,\n            \"city_count\": 19\n        }, {\n            \"title\": \"UnifiedBus™ (UB) Firmware Specification\",\n            \"download_count\": 153,\n            \"company_count\": 30,\n            \"user_count\": 52,\n            \"country_count\": 11,\n            \"city_count\": 17\n        }, {\n            \"title\": \"UnifiedBus™ (UB) Base Specification\",\n            \"download_count\": 699,\n            \"company_count\": 68,\n            \"user_count\": 140,\n            \"country_count\": 24,\n            \"city_count\": 63\n        }]\n    },\n    \"timestamp\": 1773911042562,\n    \"executeTime\": 172\n}",
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
      "value" : "",
      "description" : "社区名称",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "group_field",
      "value" : "",
      "description" : "分组字段",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "group_field 只能为 title 或 company",
      "expression" : "^(title|company|title,company|company,title)?$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "",
      "description" : "开始时间戳",
      "required" : true,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "结束时间戳",
      "required" : true,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "",
      "description" : "下载源",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "is_domestic",
      "value" : "",
      "description" : "是否国内",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "is_domestic 只能为 0 或 1",
      "expression" : "^(0|1)?$",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "",
      "description" : "每页数量",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过100",
      "expression" : "pageSize > 0 && pageSize <= 100",
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "",
      "description" : "页码",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageNum 必须为正整数",
      "expression" : "pageNum > 0",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
var source = body.source;
var community = body.community;
var group_field = body.group_field;
var start_time =date_format(start,'yyyy-MM-dd');
var end_time =date_format(end,'yyyy-MM-dd');
var is_domestic =body.is_domestic;
var page_num = body.pageNum;
var page_size = body.pageSize;
var offset_num = page_size * (page_num - 1)
var fields = body.group_field.split(",")
var len = fields.length
var sql="""
       select  ${group_field},count(*) AS download_count,
         <if test="group_field =='title'">
             count(distinct company) as company_count,
        </if>
        <if test="group_field == 'company'">
             count(distinct title) as title_count,
        </if>
       count(distinct username) as user_count,
       count(distinct country) as country_count,
       count(distinct city) as city_count
    FROM dwm_${community}_detail_download_daily
    WHERE created_at >= #{start_time}::date and created_at <= #{end_time}::date  and title is not null
     <if test="source != null and source!=''">
            and source = #{source}
        </if>
         <if test="is_domestic != null and source!=''">
            and is_domestic = #{is_domestic}
        </if>
    group by ${group_field}  order by 
            <if test="group_field == 'title'">
            title desc,download_count desc
        </if>
        <if test="group_field == 'company'">
           download_count desc
        </if>
        <if test="len > 1 ">
            title desc,download_count desc,company desc
        </if>
    LIMIT #{page_size} OFFSET #{offset_num}
""";
var total_sql = """
    SELECT 
            COUNT(*) 
        FROM (
            SELECT 
                1
            FROM 
                dwm_${community}_detail_download_daily
            WHERE 
                created_at >= #{start_time}::date
                AND created_at <= #{end_time}::date   and title is not null
            <if test="source != null and source != ''">
                AND source = #{source}
            </if>
         <if test="is_domestic != null and source!=''">
            and is_domestic = #{is_domestic}
        </if>
            GROUP BY 
                ${group_field}
        ) t;
"""
HashMap result = new HashMap();
var query_data = db.select(sql);
if(null!= query_data && query_data.size()>0){
    for (item in query_data){
        if(item.containsKey("company") && item.get("company") == null){
            item.put("company","-")
        }
    }
}
var total_count = db.selectOne(total_sql).get("count");
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_count/page_size+1);
return result

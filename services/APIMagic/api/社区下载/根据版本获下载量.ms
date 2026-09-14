{
  "properties" : { },
  "id" : "2664c751eb174a48b9e1e23aecf37ba1",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "根据版本获下载量",
  "createTime" : null,
  "updateTime" : 1774592431428,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/version",
  "method" : "POST",
  "parameters" : [ {
    "name" : "community",
    "value" : "openubmc",
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
  "requestBody" : "{\r\n    \"community\":\"openeuler\",\r\n    \"group_field\":\"version\",\r\n    \"start\":1730390400000,\r\n    \"end\":1993177600000,\r\n    \"source\":\"\",\r\n    \"is_domestic\":\"1\",\r\n    \"pageSize\":10,\r\n    \"pageNum\":2\r\n\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 122,\n        \"total_page\": 13,\n        \"list\": [{\n            \"version\": \"openEuler-25.09\",\n            \"total_count\": 28300\n        }, {\n            \"version\": \"openEuler-22.03-LTS-SP3\",\n            \"total_count\": 16079\n        }, {\n            \"version\": \"openEuler-20.03-LTS\",\n            \"total_count\": 13278\n        }, {\n            \"version\": \"openEuler-22.03-LTS-SP1\",\n            \"total_count\": 13203\n        }, {\n            \"version\": \"openEuler-20.03-LTS-SP4\",\n            \"total_count\": 12618\n        }, {\n            \"version\": \"openEuler-20.03-LTS-SP3\",\n            \"total_count\": 11472\n        }, {\n            \"version\": \"openEuler-23.03\",\n            \"total_count\": 11154\n        }, {\n            \"version\": \"openEuler-24.03-LTS-SP3\",\n            \"total_count\": 10922\n        }, {\n            \"version\": \"openEuler-20.03-LTS-SP1\",\n            \"total_count\": 10050\n        }, {\n            \"version\": \"openEuler-22.03-LTS-64kb\",\n            \"total_count\": 9738\n        }]\n    },\n    \"timestamp\": 1773883518459,\n    \"executeTime\": 158\n}",
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
      "error" : "group_field 只能为 version",
      "expression" : "^(version|version,package_name|package_name|version,package_name)?$",
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
      "error" : "pageSize 必须为正整数且不超过10000",
      "expression" : "pageSize > 0 && pageSize <= 10000",
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
if ("openeuler".equals(community)){
    community = "openeuler_iso"  
}
var sum_field = "day_count"
if (is_domestic!=null && is_domestic!=""){
    sum_field = "1".equals(is_domestic)?"inner_count":"outer_count";
}
var sql="""
       select  ${group_field},SUM(${sum_field}) AS total_count
    FROM dws_${community}_version_download_daily
    WHERE created_at >= #{start_time}::date and  created_at <= #{end_time}::date
     <if test="source != null and source!=''">
            and source = #{source}
        </if>
    group by ${group_field}  order by total_count desc
    LIMIT #{page_size} OFFSET #{page_size} * (#{page_num} - 1)
""";
var total_sql = """
    SELECT 
            COUNT(*) 
        FROM (
            SELECT 
                1
            FROM 
                dws_${community}_version_download_daily
            WHERE 
                created_at >= #{start_time}::date
                AND created_at <= #{end_time}::date
            <if test="source != null and source != ''">
                AND source = #{source}
            </if>
            GROUP BY 
                ${group_field}
        ) t;
"""
HashMap result = new HashMap();
var query_data = db.select(sql);
var total_count = db.selectOne(total_sql).get("count");
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_count/page_size+1);
return result

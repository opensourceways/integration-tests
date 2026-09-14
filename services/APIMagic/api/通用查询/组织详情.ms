{
  "properties" : { },
  "id" : "83111332dfff4f6eb5386e69b7c58ae0",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "组织详情",
  "createTime" : null,
  "updateTime" : 1767093869676,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/company/detail",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastat",
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
  "requestBody" : "{\r\n    \"start\":1757260800000,\r\n    \"end\":1757606400000,\r\n    \"community\":\"unifiedbus\",\r\n    \"source\":\"\",\r\n    \"internal\":\"内部\",\r\n    \"pageNum\":1,\r\n    \"pageSize\": 10\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 1,\n        \"total_page\": 1,\n        \"list\": [{\n            \"company\": \"华为技术有限公司\",\n            \"domain\": \"huawei-partners.com,huawei.com,hisilicon.com\",\n            \"first_register_time\": \"2025-09-17\",\n            \"regist_count\": 0,\n            \"subscribe_count\": 0,\n            \"thread_count\": 0,\n            \"email_count\": 0,\n            \"reply_count\": 0,\n            \"industry\": \"其他\",\n            \"note\": \"计算机通信/计算机、通信和其他电子设备制造业\",\n            \"total_download_count\": 0,\n            \"灵衢®固件规范\": 0,\n            \"灵衢®使能操作系统参考设计\": 0,\n            \"基于灵衢®的超节点参考架构白皮书\": 0,\n            \"灵衢®基础规范\": 0\n        }]\n    },\n    \"timestamp\": 1767093863521,\n    \"executeTime\": 61\n}",
  "description" : null,
  "requestBodyDefinition" : {
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
      "name" : "start",
      "value" : "1757260800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1757606400000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "unifiedbus",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "source 格式非法",
      "expression" : "^[a-zA-Z0-9_]*$",
      "children" : [ ]
    }, {
      "name" : "internal",
      "value" : "内部",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "internal 只能为 内部 或 外部",
      "expression" : "^(内部|外部)?$",
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageNum 必须为正整数且不超过1000",
      "expression" : "pageNum > 0 && pageNum <= 1000",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "10",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过100",
      "expression" : "pageSize > 0 && pageSize <= 100",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : {
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
      "name" : "code",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "message",
      "value" : "success",
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
      "name" : "data",
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
        "name" : "total_count",
        "value" : "1",
        "description" : "",
        "required" : false,
        "dataType" : "Integer",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      }, {
        "name" : "total_page",
        "value" : "1",
        "description" : "",
        "required" : false,
        "dataType" : "Integer",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      }, {
        "name" : "list",
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
            "name" : "company",
            "value" : "华为技术有限公司",
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
            "name" : "domain",
            "value" : "huawei-partners.com,huawei.com,hisilicon.com",
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
            "name" : "first_register_time",
            "value" : "2025-09-17",
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
            "name" : "regist_count",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "subscribe_count",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "thread_count",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "email_count",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "reply_count",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "industry",
            "value" : "其他",
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
            "name" : "note",
            "value" : "计算机通信/计算机、通信和其他电子设备制造业",
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
            "name" : "total_download_count",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "灵衢®固件规范",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "灵衢®使能操作系统参考设计",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "基于灵衢®的超节点参考架构白皮书",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "灵衢®基础规范",
            "value" : "0",
            "description" : "",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          } ]
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1767093863521",
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
      "name" : "executeTime",
      "value" : "61",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  }
}

================================
import '@/util/timestamp2Date' as timestamp2Date;
import magic;
import com.fasterxml.jackson.databind.ObjectMapper;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 社区
var community = body.community;
// 服务平台
var source = body.source;
// 组织
var company = body.company;
// 内外部
var internal = body.internal;
// page
var page_num = body.pageNum;
var page_size = body.pageSize;
var offset = (page_num - 1) * page_size;
var company_domain_table = "dwm_" + community + "_domain_company";
var download_table = "dws_" + community + "_download_day";
var contribute_table = "dws_" + community + "_contribute_company_daily"
var query_sql = """
    with dim_company_data as (
        select 
            company, string_agg(domain, ',') as domain, string_agg(DISTINCT industry, ',') as industry, string_agg(DISTINCT note, ',') as note, TO_CHAR(min(first_register_time) AT TIME ZONE 'Asia/Shanghai', 'YYYY-MM-DD') as first_register_time
        FROM ${company_domain_table}
        <where>
            <if test="internal != null and internal != ''">
                and internal = #{internal}
            </if>
        </where>
        group by company
    ),
    contribute_data as (
        select 
            company,
            sum(regist_count) as regist_count, sum(subscribe_count) as subscribe_count,
            sum(pr_incre) as thread_count, sum(issue_incre) as email_count, sum(comment_incre) as reply_count
        from ${contribute_table}
        where date::DATE BETWEEN #{start} AND #{end} and company is not null
        <if test="internal != null and internal != ''">
            and internal = #{internal}
        </if>
        group by company
    ),
    download_data as (
        select 
            company, title,
            sum(download_count) as download_count
        from ${download_table}
        where date::DATE BETWEEN #{start} AND #{end} and company is not null and title is not null and title <> ''
        <if test="internal != null and internal != ''">
            and internal = #{internal}
        </if>
        group by company, title
    ),
    group_download_data as (
        SELECT company, sum(download_count) as total_download_count, jsonb_object_agg(title, download_count) as download_json
        from download_data
        GROUP BY company
    ),
    final as (
        select 
            dc.company, dc.domain, dc.first_register_time, c.regist_count, c.subscribe_count, 
            c.thread_count, c.email_count, c.reply_count, dc.industry, dc.note, 
            COALESCE(d.total_download_count, 0) as total_download_count,
            d.download_json::text as download_json
        from dim_company_data dc
        left join contribute_data c on dc.company = c.company
        left join group_download_data d on dc.company = d.company
    )
    select 
        * ,    
        (select count(1) from final) as total_page_count, 
        CEIL((select count(1) from final)::numeric/#{page_size}) as total_page
    from final 
    order by regist_count desc 
    LIMIT #{page_size} OFFSET #{offset}
"""
var query_data = db.select(query_sql);
var title_sql = """
    select 
        distinct title
    from ${download_table}
    where title is not null
""";
var title_dim = db.select(title_sql);
var title_map = new HashMap();
title_dim.forEach(item -> {
    title_map.put(item.get("title"), 0)
})
var total_page_count = query_data.size() > 0 ? query_data[0].get("total_page_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
var mapper = new ObjectMapper(); // 将 JSON 字符串转成 Map 
query_data.forEach(item -> {
    item.putAll(title_map);
    item.remove("total_page_count");
    item.remove("total_page");
    var download_json = item.remove("download_json");
    if (download_json != null){
        var download_map = mapper.readValue(download_json, Map.class);
        item.putAll(download_map);
    }
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_page_count);
result.put("total_page", total_page);
return result

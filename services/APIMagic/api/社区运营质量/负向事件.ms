{
  "properties" : { },
  "id" : "2e557b3c1c9944a599b43fea8dce939c",
  "script" : null,
  "groupId" : "2e2220ca1c424052ba4fa20a1e7370f8",
  "name" : "负向事件",
  "createTime" : null,
  "updateTime" : 1776236256443,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/negative_event",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "cannopen",
    "description" : "社区名称",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "start",
    "value" : null,
    "description" : "查询范围开始时间，格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : null,
    "description" : "查询范围结束时间，格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "pageNum",
    "value" : null,
    "description" : "查询页码",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "pageSize",
    "value" : null,
    "description" : "每页数量",
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 4,\n        \"total_page\": 1,\n        \"list\": [{\n            \"uuid\": \"02143208714054729217\",\n            \"url\": \"https://www.hiascend.com/forum/thread-02143208714054729217-1-1.html\",\n            \"title\": \"msprof执行报错  无法生成采集文件\",\n            \"author\": \"hid_9esu1chmwo_lbl3\",\n            \"category_name\": \"问题求助\",\n            \"status\": \"resolved\",\n            \"created_at\": \"2026-03-13 00:07:35\",\n            \"has_accepted_answer\": \"true\",\n            \"closed\": null,\n            \"score\": 73,\n            \"risk_level\": \"P1\",\n            \"negative_type_name\": \"问题求助\",\n            \"matched_keywords\": {\n                \"title\": [\"无法\", \"报错\"],\n                \"post\": [\"无法\", \"失败\", \"报错\"]\n            },\n            \"eval_criteria\": \"关键词匹配\"\n        }, {\n            \"uuid\": \"0297203613575480217\",\n            \"url\": \"https://www.hiascend.com/forum/thread-0297203613575480217-1-1.html\",\n            \"title\": \"[310P1][ARM64] 宿主机无法创建 vNPU，报错 create vnpu failed，Hugepages 始终显示 0/0\",\n            \"author\": \"rory\",\n            \"category_name\": \"应用开发\",\n            \"status\": \"resolved\",\n            \"created_at\": \"2026-01-12 23:19:36\",\n            \"has_accepted_answer\": \"true\",\n            \"closed\": null,\n            \"score\": 73,\n            \"risk_level\": \"P1\",\n            \"negative_type_name\": \"问题求助\",\n            \"matched_keywords\": {\n                \"title\": [\"无法\", \"报错\"],\n                \"post\": [\"无法\", \"失败\", \"报错\"]\n            },\n            \"eval_criteria\": \"询问性质帖子; 包含确认性关键词\"\n        }, {\n            \"uuid\": \"0296203309540710084\",\n            \"url\": \"https://www.hiascend.com/forum/thread-0296203309540710084-1-1.html\",\n            \"title\": \"求助CUBE核上DATACOPY失效的问题\",\n            \"author\": \"zxyaang\",\n            \"category_name\": \"问题求助\",\n            \"status\": \"resolved\",\n            \"created_at\": \"2026-01-09 10:52:21\",\n            \"has_accepted_answer\": \"true\",\n            \"closed\": null,\n            \"score\": 81,\n            \"risk_level\": \"P1\",\n            \"negative_type_name\": \"问题求助\",\n            \"matched_keywords\": {\n                \"title\": [\"求助\", \"问题\"],\n                \"post\": [\"求助\", \"无法\", \"失败\"]\n            },\n            \"eval_criteria\": \"询问性质帖子; 包含确认性关键词\"\n        }, {\n            \"uuid\": \"0296203253731686070\",\n            \"url\": \"https://www.hiascend.com/forum/thread-0296203253731686070-1-1.html\",\n            \"title\": \"求助：项目从310P迁移到910B上出现507015问题。经过调试总结问题如下\",\n            \"author\": \"hid_aihtdury_cp2w-g\",\n            \"category_name\": \"问题求助\",\n            \"status\": \"resolved\",\n            \"created_at\": \"2026-01-08 19:22:12\",\n            \"has_accepted_answer\": \"true\",\n            \"closed\": null,\n            \"score\": 71,\n            \"risk_level\": \"P1\",\n            \"negative_type_name\": \"问题求助\",\n            \"matched_keywords\": {\n                \"title\": [\"求助\", \"问题\"],\n                \"post\": [\"求助\", \"失败\"]\n            },\n            \"eval_criteria\": \"询问性质帖子; 包含确认性关键词\"\n        }],\n        \"page_size\": 10\n    },\n    \"timestamp\": 1775734735797,\n    \"executeTime\": 7\n}",
  "description" : null,
  "requestBodyDefinition" : null,
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
        "value" : "4",
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
            "name" : "uuid",
            "value" : "02143208714054729217",
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
            "name" : "url",
            "value" : "https://www.hiascend.com/forum/thread-02143208714054729217-1-1.html",
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
            "name" : "title",
            "value" : "msprof执行报错  无法生成采集文件",
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
            "name" : "author",
            "value" : "hid_9esu1chmwo_lbl3",
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
            "name" : "category_name",
            "value" : "问题求助",
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
            "name" : "status",
            "value" : "resolved",
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
            "name" : "created_at",
            "value" : "2026-03-13 00:07:35",
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
            "name" : "has_accepted_answer",
            "value" : "true",
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
            "name" : "closed",
            "value" : "null",
            "description" : "",
            "required" : false,
            "dataType" : "Object",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "score",
            "value" : "73",
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
            "name" : "risk_level",
            "value" : "P1",
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
            "name" : "negative_type_name",
            "value" : "问题求助",
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
            "name" : "matched_keywords",
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
              "name" : "type",
              "value" : "json",
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
              "name" : "value",
              "value" : "{\\\"title\\\": [\\\"无法\\\", \\\"报错\\\"], \\\"post\\\": [\\\"无法\\\", \\\"失败\\\", \\\"报错\\\"]}",
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
              "name" : "null",
              "value" : "false",
              "description" : "",
              "required" : false,
              "dataType" : "Boolean",
              "type" : null,
              "defaultValue" : null,
              "validateType" : "",
              "error" : "",
              "expression" : "",
              "children" : [ ]
            } ]
          }, {
            "name" : "eval_criteria",
            "value" : "关键词匹配",
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
        } ]
      }, {
        "name" : "page_size",
        "value" : "10",
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
    }, {
      "name" : "timestamp",
      "value" : "1775734676449",
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
      "value" : "4",
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
community = community.toLowerCase()
if ("cannopen" == community){
    community = 'cann'
}
// page param
var page_num = 1;
if (pageNum != null and pageNum != ""){
    page_num = pageNum;
}
var page_size = 10;
if (pageSize != null and pageSize != ""){
    page_size = pageSize;
}
var offset = (page_num - 1) * page_size
var sql = """
with data as (
    SELECT f.uuid,f.url ,f.title,f.author,f.category_name,f.status,f.created_at,f.has_accepted_answer,f.closed,d.score,d.risk_level,d.negative_type_name,d.matched_keywords,d.eval_criteria  
    FROM fact_${community}_forum_topic f, dwm_${community}_forum_negative_event d 
    <where>
        f.uuid = d.topic_id and f.is_removed = 'false' and d.score >= 70
        <if test="start != null and start != ''">
            AND f.created_at >= to_timestamp(#{start}/1000)
        </if>
        <if test="end != null and end != ''">
            AND f.created_at <= to_timestamp(#{end}/1000)
        </if>
    </where>
)
SELECT 
    *, 
    (select count(1) from data) as total_count, 
    CEIL((select count(1) from data)::numeric/#{page_size}) as total_page
FROM 
    data
LIMIT #{page_size} OFFSET #{offset} 

"""
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    item["matched_keywords"] = item["matched_keywords"]::json
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
result.put("page_size", page_size);
return result


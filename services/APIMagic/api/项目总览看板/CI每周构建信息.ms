{
  "properties" : { },
  "id" : "74d489451a924f54b73af62b128a3ac4",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "CI每周构建信息",
  "createTime" : null,
  "updateTime" : 1777290754634,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/ci/build/info",
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
  "requestBody" : "{\r\n    \"start\":1753129600000,\r\n    \"end\":1776153600000,\r\n    \"community\":\"mindall\",\r\n    \"sort_field\": \"all_count\",\r\n\t\"sort_order\": \"desc\",\r\n    \"pageSize\":10,\r\n    \"pageNum\":2\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 70,\n        \"total_page\": 7,\n        \"list\": [{\n            \"repo_path\": \"torchair\",\n            \"all_count\": 1744,\n            \"weekly_all_count\": 59,\n            \"weekly_success_count\": 44,\n            \"weekly_success_rate\": 0.75,\n            \"weekly_avg_access_time\": 8.90,\n            \"weekly_p50_run_time\": 8.53,\n            \"weekly_p90_run_time\": 10.49,\n            \"weekly_avg_pending_time\": 0.46,\n            \"weekly_p50_pending_time\": 0.35,\n            \"weekly_p90_pending_time\": 2.03\n        }, {\n            \"repo_path\": \"memfabric_hybrid\",\n            \"all_count\": 1457,\n            \"weekly_all_count\": 67,\n            \"weekly_success_count\": 24,\n            \"weekly_success_rate\": 0.36,\n            \"weekly_avg_access_time\": 14.76,\n            \"weekly_p50_run_time\": 12.90,\n            \"weekly_p90_run_time\": 16.52,\n            \"weekly_avg_pending_time\": 1.42,\n            \"weekly_p50_pending_time\": 0.02,\n            \"weekly_p90_pending_time\": 1.94\n        }, {\n            \"repo_path\": \"MindSpeed\",\n            \"all_count\": 1306,\n            \"weekly_all_count\": 23,\n            \"weekly_success_count\": 12,\n            \"weekly_success_rate\": 0.52,\n            \"weekly_avg_access_time\": 21.83,\n            \"weekly_p50_run_time\": 19.93,\n            \"weekly_p90_run_time\": 26.68,\n            \"weekly_avg_pending_time\": 0.02,\n            \"weekly_p50_pending_time\": 0.02,\n            \"weekly_p90_pending_time\": 0.02\n        }, {\n            \"repo_path\": \"msprobe\",\n            \"all_count\": 1180,\n            \"weekly_all_count\": 22,\n            \"weekly_success_count\": 19,\n            \"weekly_success_rate\": 0.86,\n            \"weekly_avg_access_time\": 10.08,\n            \"weekly_p50_run_time\": 9.85,\n            \"weekly_p90_run_time\": 10.67,\n            \"weekly_avg_pending_time\": 0.02,\n            \"weekly_p50_pending_time\": 0.02,\n            \"weekly_p90_pending_time\": 0.02\n        }, {\n            \"repo_path\": \"mstt\",\n            \"all_count\": 928,\n            \"weekly_all_count\": 24,\n            \"weekly_success_count\": 24,\n            \"weekly_success_rate\": 1.00,\n            \"weekly_avg_access_time\": 6.74,\n            \"weekly_p50_run_time\": 6.72,\n            \"weekly_p90_run_time\": 11.93,\n            \"weekly_avg_pending_time\": 0.00,\n            \"weekly_p50_pending_time\": 0.00,\n            \"weekly_p90_pending_time\": 0.00\n        }, {\n            \"repo_path\": \"MindIE-Motor\",\n            \"all_count\": 791,\n            \"weekly_all_count\": 27,\n            \"weekly_success_count\": 13,\n            \"weekly_success_rate\": 0.48,\n            \"weekly_avg_access_time\": 14.41,\n            \"weekly_p50_run_time\": 11.88,\n            \"weekly_p90_run_time\": 32.80,\n            \"weekly_avg_pending_time\": 0.03,\n            \"weekly_p50_pending_time\": 0.03,\n            \"weekly_p90_pending_time\": 0.03\n        }, {\n            \"repo_path\": \"DrivingSDK\",\n            \"all_count\": 668,\n            \"weekly_all_count\": 14,\n            \"weekly_success_count\": 11,\n            \"weekly_success_rate\": 0.79,\n            \"weekly_avg_access_time\": 12.11,\n            \"weekly_p50_run_time\": 11.97,\n            \"weekly_p90_run_time\": 26.93,\n            \"weekly_avg_pending_time\": 0.65,\n            \"weekly_p50_pending_time\": 0.03,\n            \"weekly_p90_pending_time\": 1.56\n        }, {\n            \"repo_path\": \"MindIE-SD\",\n            \"all_count\": 649,\n            \"weekly_all_count\": 39,\n            \"weekly_success_count\": 19,\n            \"weekly_success_rate\": 0.49,\n            \"weekly_avg_access_time\": 13.49,\n            \"weekly_p50_run_time\": 13.58,\n            \"weekly_p90_run_time\": 17.54,\n            \"weekly_avg_pending_time\": 0.02,\n            \"weekly_p50_pending_time\": 0.02,\n            \"weekly_p90_pending_time\": 0.03\n        }, {\n            \"repo_path\": \"msserviceprofiler\",\n            \"all_count\": 641,\n            \"weekly_all_count\": 27,\n            \"weekly_success_count\": 18,\n            \"weekly_success_rate\": 0.67,\n            \"weekly_avg_access_time\": 10.41,\n            \"weekly_p50_run_time\": 9.13,\n            \"weekly_p90_run_time\": 11.89,\n            \"weekly_avg_pending_time\": 0.02,\n            \"weekly_p50_pending_time\": 0.02,\n            \"weekly_p90_pending_time\": 0.03\n        }, {\n            \"repo_path\": \"MindSpeed-RL\",\n            \"all_count\": 630,\n            \"weekly_all_count\": 6,\n            \"weekly_success_count\": 0,\n            \"weekly_success_rate\": 0.00,\n            \"weekly_avg_access_time\": 8.58,\n            \"weekly_p50_run_time\": 8.58,\n            \"weekly_p90_run_time\": 8.58,\n            \"weekly_avg_pending_time\": 0.00,\n            \"weekly_p50_pending_time\": 0.00,\n            \"weekly_p90_pending_time\": 0.00\n        }],\n        \"current_page\": 2\n    },\n    \"timestamp\": 1777290753513,\n    \"executeTime\": 8\n}",
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
      "value" : "1753129600000",
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
      "value" : "1776153600000",
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
      "value" : "cannopen",
      "description" : "",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "sort_field",
      "value" : "all_count",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "all_count",
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^(all_count|weekly_all_count|weekly_success_count|weekly_success_rate|weekly_avg_access_time|weekly_p50_run_time|weekly_p90_run_time|weekly_avg_pending_time|weekly_p50_pending_time|weekly_p90_pending_time)$",
      "children" : [ ]
    }, {
      "name" : "sort_order",
      "value" : "desc",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "desc",
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(desc|DESC|asc|ASC)$",
      "children" : [ ]
    }, {
      "name" : "pageSize",
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
    }, {
      "name" : "pageNum",
      "value" : "2",
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
        "value" : "37",
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
            "name" : "repo_path",
            "value" : "pypto",
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
            "name" : "all_count",
            "value" : "1557",
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
            "name" : "weekly_all_count",
            "value" : "730",
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
            "name" : "weekly_success_count",
            "value" : "196",
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
            "name" : "weekly_success_rate",
            "value" : "0.27",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "weekly_avg_access_time",
            "value" : "24.47",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "weekly_p50_run_time",
            "value" : "22.10",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "weekly_p90_run_time",
            "value" : "31.43",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "weekly_avg_pending_time",
            "value" : "0.17",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "weekly_p50_pending_time",
            "value" : "0.18",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "weekly_p90_pending_time",
            "value" : "0.54",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          } ]
        } ]
      }, {
        "name" : "current_page",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1776909407172",
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
      "value" : "8",
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
// 社区
var community = body.community.toLowerCase();
//请求开始时间与结束时间
var start = body.start
var end = body.end;
// 分页信息
var page_num = 1;
if (body.pageNum != null and body.pageNum != ""){
    page_num = body.pageNum;
}
var page_size = 10;
if (body.pageSize != null and body.pageSize != ""){
    page_size = body.pageSize;
}
var page_offset = (page_num - 1) * page_size;
// ci构建信息数据表
var ci_build_table = `dwm_${community}_ci_info`;

var sql = """
    WITH weekly_data as(
        SELECT
           repo_path,
           COALESCE(sum(count), 0) as weekly_all_count,
           COALESCE(sum(success_count),0) as weekly_success_count,
           ROUND(
               CASE 
                   WHEN COALESCE(sum(count), 0) = 0 THEN 0
                   ELSE COALESCE(sum(success_count), 0)::NUMERIC / sum(count)
               END::NUMERIC, 2) as weekly_success_rate,
           /* building time */
           ROUND(
               CASE 
                   WHEN COALESCE(sum(count), 0) = 0 THEN 0
                   ELSE COALESCE(sum(access_time), 0)::NUMERIC / sum(count) / 60
               END::NUMERIC, 2) as weekly_avg_access_time,
           ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY COALESCE(avg_access_time, 0))::NUMERIC / 60, 2) as weekly_p50_run_time,
           ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY COALESCE(avg_access_time, 0))::NUMERIC / 60, 2) as weekly_p90_run_time,
           /* waiting time */
           ROUND(
               CASE 
                   WHEN COALESCE(sum(count), 0) = 0 THEN 0
                   ELSE COALESCE(sum(build_pending_time), 0)::NUMERIC / sum(count) / 60
               END::NUMERIC, 2) as weekly_avg_pending_time,
           ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY COALESCE(avg_build_pending_time, 0))::NUMERIC / 60, 2) as weekly_p50_pending_time,
           ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY COALESCE(avg_build_pending_time, 0))::NUMERIC / 60, 2) as weekly_p90_pending_time
        FROM ${ci_build_table}
        WHERE 1=1
            <if test="end != null and end != '' and start != null and start != ''">
               AND "date" >= GREATEST(to_timestamp(#{start}/1000), to_timestamp(#{end}/1000) - INTERVAL '7 days')
               AND "date" <= to_timestamp(#{end}/1000)
            </if>
            <if test="repo_path != null and repo_path != ''">
               AND repo_path LIKE CONCAT('%', #{repo_path}, '%')
            </if>  
        GROUP BY repo_path
    ),
    all_data as(
        SELECT
            repo_path,
            sum(count) as all_count
        FROM ${ci_build_table}
        WHERE 1=1
            <if test="repo_path != null and repo_path != ''">
               AND repo_path LIKE CONCAT('%', #{repo_path}, '%')
            </if>
            <if test="start != null and start != ''">
               AND "date" >= to_timestamp(#{start}/1000)
            </if>
            <if test="end != null and end != ''">
               AND "date" < to_timestamp(#{end}/1000)
            </if>
        GROUP BY repo_path
    )
    SELECT 
        t.*,
        wt.*,
        (select count(*) from all_data) as total_count,
        CEIL((select count(*) from all_data)::numeric/#{page_size}) as total_page
    FROM all_data t
    LEFT JOIN  weekly_data wt ON t.repo_path = wt.repo_path
    ORDER BY ${body.sort_field} ${body.sort_order}
    LIMIT #{page_size} OFFSET #{page_offset}
""";

var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    return item;
})
HashMap result = new HashMap();
result.put("current_page", page_num);
result.put("total_count", total_count);
result.put("total_page", total_page);
result.put("list", query_data);

return result
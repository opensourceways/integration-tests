{
  "properties" : { },
  "id" : "copy1770635690857d46461",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "issue汇总分页(sig维度)",
  "createTime" : null,
  "updateTime" : 1774691239483,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/issues/agg/sig",
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
  "requestBody" : "{\r\n    \"start\":1577836800000,\r\n    \"end\":1772790693004,\r\n    \"pageNum\": 1,\r\n    \"pageSize\": 10,\r\n    \"group_dim\": \"sig\",\r\n    \"community\":\"opengauss\",\r\n    \"issue_type\": \"\",\r\n    \"issue_type_list\": [],\r\n    \"namespace\":\"\",\r\n    \"sig_name\":\"\",\r\n    \"sig_name_list\": [\r\n        \"SQLEngine\",\r\n        \"StorageEngine\",\r\n        \"Tools\",\r\n        \"QA\",\r\n        \"Security\",\r\n        \"AI\",\r\n        \"Plugin\",\r\n        \"OPS\"\r\n    ],\r\n    \"source\": \"\",\r\n    \"internalList\": [],\r\n    \"private\": \"\",\r\n    \"asc\":\"\",\r\n    \"desc\":\"count\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"sort_field\": \"count,open_count,unresponse_open_count\",\n        \"total_count\": 8,\n        \"total_page\": 1,\n        \"list\": [{\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"Tools\",\n            \"issue_type\": \"All\",\n            \"count\": 2532,\n            \"open_count\": 345,\n            \"total_open_count\": 351,\n            \"unresponse_open_count\": 229,\n            \"closed_count\": 2151,\n            \"unclosed_count\": 345,\n            \"closed_ratio\": 0.8637,\n            \"avg_first_reply_time\": 73.82,\n            \"avg_closed_time\": 102.14,\n            \"avg_overdue_first_reply_time\": 73.55,\n            \"avg_overdue_closed_time\": 106.25,\n            \"one_day_response_ratio\": 0.09,\n            \"eight_hour_response_ratio\": 0.05,\n            \"five_day_closed_ratio\": 0.43,\n            \"seven_day_closed_ratio\": 0.50,\n            \"comment_num\": 1.45\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"Plugin\",\n            \"issue_type\": \"All\",\n            \"count\": 1601,\n            \"open_count\": 132,\n            \"total_open_count\": 134,\n            \"unresponse_open_count\": 82,\n            \"closed_count\": 1464,\n            \"unclosed_count\": 132,\n            \"closed_ratio\": 0.9176,\n            \"avg_first_reply_time\": 51.45,\n            \"avg_closed_time\": 69.24,\n            \"avg_overdue_first_reply_time\": 50.57,\n            \"avg_overdue_closed_time\": 67.91,\n            \"one_day_response_ratio\": 0.11,\n            \"eight_hour_response_ratio\": 0.07,\n            \"five_day_closed_ratio\": 0.41,\n            \"seven_day_closed_ratio\": 0.50,\n            \"comment_num\": 1.80\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"Security\",\n            \"issue_type\": \"All\",\n            \"count\": 357,\n            \"open_count\": 6,\n            \"total_open_count\": 6,\n            \"unresponse_open_count\": 4,\n            \"closed_count\": 351,\n            \"unclosed_count\": 6,\n            \"closed_ratio\": 0.9832,\n            \"avg_first_reply_time\": 17.36,\n            \"avg_closed_time\": 99.33,\n            \"avg_overdue_first_reply_time\": 16.40,\n            \"avg_overdue_closed_time\": 139.56,\n            \"one_day_response_ratio\": 0.03,\n            \"eight_hour_response_ratio\": 0.01,\n            \"five_day_closed_ratio\": 0.26,\n            \"seven_day_closed_ratio\": 0.34,\n            \"comment_num\": 1.51\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"AI\",\n            \"issue_type\": \"All\",\n            \"count\": 213,\n            \"open_count\": 82,\n            \"total_open_count\": 82,\n            \"unresponse_open_count\": 55,\n            \"closed_count\": 131,\n            \"unclosed_count\": 82,\n            \"closed_ratio\": 0.6150,\n            \"avg_first_reply_time\": 201.82,\n            \"avg_closed_time\": 269.81,\n            \"avg_overdue_first_reply_time\": 201.02,\n            \"avg_overdue_closed_time\": 292.40,\n            \"one_day_response_ratio\": 0.12,\n            \"eight_hour_response_ratio\": 0.06,\n            \"five_day_closed_ratio\": 0.31,\n            \"seven_day_closed_ratio\": 0.34,\n            \"comment_num\": 0.92\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"QA\",\n            \"issue_type\": \"All\",\n            \"count\": 112,\n            \"open_count\": 54,\n            \"total_open_count\": 55,\n            \"unresponse_open_count\": 35,\n            \"closed_count\": 58,\n            \"unclosed_count\": 54,\n            \"closed_ratio\": 0.5179,\n            \"avg_first_reply_time\": 174.44,\n            \"avg_closed_time\": 314.56,\n            \"avg_overdue_first_reply_time\": 173.59,\n            \"avg_overdue_closed_time\": 353.52,\n            \"one_day_response_ratio\": 0.10,\n            \"eight_hour_response_ratio\": 0.04,\n            \"five_day_closed_ratio\": 0.23,\n            \"seven_day_closed_ratio\": 0.23,\n            \"comment_num\": 1.26\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"StorageEngine\",\n            \"issue_type\": \"All\",\n            \"count\": 87,\n            \"open_count\": 25,\n            \"total_open_count\": 39,\n            \"unresponse_open_count\": 15,\n            \"closed_count\": 55,\n            \"unclosed_count\": 25,\n            \"closed_ratio\": 0.7126,\n            \"avg_first_reply_time\": 33.45,\n            \"avg_closed_time\": 41.56,\n            \"avg_overdue_first_reply_time\": 32.46,\n            \"avg_overdue_closed_time\": 40.24,\n            \"one_day_response_ratio\": 0.02,\n            \"eight_hour_response_ratio\": 0.00,\n            \"five_day_closed_ratio\": 0.10,\n            \"seven_day_closed_ratio\": 0.15,\n            \"comment_num\": 1.44\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"SQLEngine\",\n            \"issue_type\": \"All\",\n            \"count\": 7,\n            \"open_count\": 6,\n            \"total_open_count\": 6,\n            \"unresponse_open_count\": 2,\n            \"closed_count\": 1,\n            \"unclosed_count\": 6,\n            \"closed_ratio\": 0.1429,\n            \"avg_first_reply_time\": 355.12,\n            \"avg_closed_time\": 997.58,\n            \"avg_overdue_first_reply_time\": 354.12,\n            \"avg_overdue_closed_time\": 1054.45,\n            \"one_day_response_ratio\": 0.00,\n            \"eight_hour_response_ratio\": 0.00,\n            \"five_day_closed_ratio\": 0.00,\n            \"seven_day_closed_ratio\": 0.00,\n            \"comment_num\": 1.86\n        }, {\n            \"namespace\": \"opengauss\",\n            \"sig_name\": \"OPS\",\n            \"issue_type\": \"All\",\n            \"count\": 0,\n            \"open_count\": 0,\n            \"total_open_count\": 0,\n            \"unresponse_open_count\": 0,\n            \"closed_count\": 0,\n            \"unclosed_count\": 0,\n            \"closed_ratio\": 0,\n            \"avg_first_reply_time\": 0,\n            \"avg_closed_time\": 0,\n            \"avg_overdue_first_reply_time\": 0,\n            \"avg_overdue_closed_time\": 0,\n            \"one_day_response_ratio\": 0,\n            \"eight_hour_response_ratio\": 0,\n            \"five_day_closed_ratio\": 0,\n            \"seven_day_closed_ratio\": 0,\n            \"comment_num\": 0\n        }],\n        \"super_issue_type\": \"咨询,需求,缺陷,公告,特殊\"\n    },\n    \"timestamp\": 1774689710292,\n    \"executeTime\": 25\n}",
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
      "value" : "1577836800000",
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
      "value" : "1772790549528",
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
      "name" : "group_dim",
      "value" : "sig",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "group_dim 只能为 sub_community 或 sig",
      "expression" : "^(sub_community|sig)?$",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "opengauss",
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
      "name" : "issue_type",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "issue_type 格式非法",
      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5,]*$",
      "children" : [ ]
    }, {
      "name" : "issue_type_list",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "namespace",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "namespace 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-]*$",
      "children" : [ ]
    }, {
      "name" : "sig_name",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "sig_name 格式非法",
      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5]*$",
      "children" : [ ]
    }, {
      "name" : "sig_name_list",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
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
      "name" : "internalList",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "private",
      "value" : "false",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "private 只能为 true 或 false",
      "expression" : "^(true|false)?$",
      "children" : [ ]
    }, {
      "name" : "asc",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "asc 字段非法",
      "expression" : "^(count|open_count|unresponse_open_count|closed_count|unclosed_count|closed_ratio|avg_first_reply_time|avg_closed_time|avg_overdue_first_reply_time|avg_overdue_closed_time|eight_hour_response_ratio|one_day_response_ratio|five_day_closed_ratio|seven_day_closed_ratio|comment_num|total_open_count)?$",
      "children" : [ ]
    }, {
      "name" : "desc",
      "value" : "open_count",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "desc 字段非法",
      "expression" : "^(count|open_count|unresponse_open_count|closed_count|unclosed_count|closed_ratio|avg_first_reply_time|avg_closed_time|avg_overdue_first_reply_time|avg_overdue_closed_time|eight_hour_response_ratio|one_day_response_ratio|five_day_closed_ratio|seven_day_closed_ratio|comment_num|total_open_count)?$",
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
        "name" : "sort_field",
        "value" : "count,open_count,unresponse_open_count",
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
        "name" : "total_count",
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
            "name" : "namespace",
            "value" : "opengauss",
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
            "name" : "sig_name",
            "value" : "Tools",
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
            "name" : "issue_type",
            "value" : "All",
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
            "name" : "count",
            "value" : "2628",
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
            "name" : "open_count",
            "value" : "394",
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
            "name" : "total_open_count",
            "value" : "400",
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
            "name" : "unresponse_open_count",
            "value" : "245",
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
            "name" : "closed_count",
            "value" : "1238",
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
            "name" : "unclosed_count",
            "value" : "394",
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
            "name" : "closed_ratio",
            "value" : "0.8501",
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
            "name" : "avg_first_reply_time",
            "value" : "79.16",
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
            "name" : "avg_closed_time",
            "value" : "121.56",
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
            "name" : "avg_overdue_first_reply_time",
            "value" : "78.87",
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
            "name" : "avg_overdue_closed_time",
            "value" : "125.89",
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
            "name" : "one_day_response_ratio",
            "value" : "0.10",
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
            "name" : "eight_hour_response_ratio",
            "value" : "0.06",
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
            "name" : "five_day_closed_ratio",
            "value" : "0.29",
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
            "name" : "seven_day_closed_ratio",
            "value" : "0.32",
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
            "name" : "comment_num",
            "value" : "1.44",
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
        "name" : "super_issue_type",
        "value" : "咨询,需求,缺陷,公告,特殊",
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
    }, {
      "name" : "timestamp",
      "value" : "1774665160902",
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
    } ]
  }
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
import  magic;
Date start = null;
if (body.start != null and body.start != '') {
    start = timestamp2Date(body.start);
}
Date end = null;
if (body.end != null and body.end != '') {
    end = timestamp2Date(body.end);
}
Date today = end
// 最近7天
LocalDate last7Start = today.minusDays(6);
LocalDate last7End = today;
// 聚合维度
var group_dim = body.group_dim;
// 社区
var community = body.community;
// 子社区
var no_sub_community = body.no_sub_community;
// 组织
var namespace = body.namespace;
// 服务平台
var source = body.source;
// 内外部
var internalList = body.internalList;
// 是否私仓
var private = body.private;
// Issue类型
var issue_type = body.issue_type;
// Issue类型数组
var issueTypeList = body.issue_type_list;
var issueTypes = null;
if (issueTypeList != null and issueTypeList.size() > 0){
    issueTypes = String.join(",", issueTypeList);
}
// SIG n名称
var sig_name = body.sig_name;
var sigNameList = body.sig_name_list;
// 责任人
var assginee = body.assginee;
// page param
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
var offset = (page_num - 1) * page_size
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
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
var contributeTable = "dws_" + community + "_issue_contribute_sig_daily";
var sigTable = "fact_" + community + "_sig_user";
var communityTable = "fact_community_structure";
var sql = """
WITH last_week_data AS (
    SELECT
        COALESCE(sum(open_issue_incre), 0) as total_open_count
    FROM ${contributeTable}
    <where>
        <if test="no_sub_community != null and no_sub_community != ''">
            and sub_community != #{no_sub_community}
        </if>
        <if test="namespace != null and namespace != ''">
            and namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="sig_name != null and sig_name != ''">
            and sig_name LIKE CONCAT('%', #{sig_name}, '%')
        </if>
        <if test="sigNameList != null and sigNameList.size() > 0">
            and sig_name in
            <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="issue_type != null and issue_type != ''">
            and super_issue_type = #{issue_type}
        </if>
        <if test="issueTypeList != null and issueTypeList.size() > 0">
            and super_issue_type in
            <foreach collection="issueTypeList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="source != null and source != ''">
            and source = #{source}
        </if>
        <if test="private != null and private != ''">
            and private = #{private}
        </if>
        <if test="internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
),
contribute_data AS (
    SELECT
        COALESCE(sum(issue_incre), 0) as count, COALESCE(sum(open_issue_incre), 0) as open_count,
        COALESCE(sum(unresponse_open_issue_incre), 0) as unresponse_open_count, 
        COALESCE(sum(issue_incre), 0) - COALESCE(sum(open_issue_incre), 0) - COALESCE(sum(progressing_issue_incre), 0) as closed_count, 
        COALESCE(sum(open_issue_incre), 0) + COALESCE(sum(progressing_issue_incre), 0) as unclosed_count, 
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE (sum(issue_incre) - sum(open_issue_incre) - sum(progressing_issue_incre))::NUMERIC / sum(issue_incre)
            END::NUMERIC , 4
        ) as closed_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(first_reply_time)::NUMERIC / sum(issue_incre) / 86400
            END::NUMERIC , 2
        ) as avg_first_reply_time,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(closed_time)::NUMERIC / sum(issue_incre) / 86400
            END::NUMERIC , 2
        ) as avg_closed_time,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(overdue_first_reply_time)::NUMERIC / sum(issue_incre) / 86400
            END::NUMERIC , 2
        ) as avg_overdue_first_reply_time,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(overdue_closed_time)::NUMERIC / sum(issue_incre) / 86400
            END::NUMERIC , 2
        ) as avg_overdue_closed_time,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(eight_hour_response_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as eight_hour_response_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(one_day_response_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as one_day_response_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(five_day_created_closed_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as five_day_closed_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(seven_day_created_closed_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as seven_day_closed_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(comment_num)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as comment_num
    FROM ${contributeTable}
    <where>
        <if test="start != null ">
            and date >= #{start}
        </if>
        <if test="end != null ">
            and date <= #{end}
        </if>
        <if test="no_sub_community != null and no_sub_community != ''">
            and sub_community != #{no_sub_community}
        </if>
        <if test="namespace != null and namespace != ''">
            and namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="sig_name != null and sig_name != ''">
            and sig_name LIKE CONCAT('%', #{sig_name}, '%')
        </if>
        <if test="sigNameList != null and sigNameList.size() > 0">
            and sig_name in
            <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="issue_type != null and issue_type != ''">
            and super_issue_type = #{issue_type}
        </if>
        <if test="issueTypeList != null and issueTypeList.size() > 0">
            and super_issue_type in
            <foreach collection="issueTypeList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="source != null and source != ''">
            and source = #{source}
        </if>
        <if test="private != null and private != ''">
            and private = #{private}
        </if>
        <if test="internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
)
SELECT 
    *, 
    (select count(1) from contribute_data) as total_count, 
    CEIL((select count(1) from contribute_data)::numeric/#{page_size}) as total_page
FROM 
    contribute_data, last_week_data
<if test="order_by != null and order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset}
""";
if (group_dim != null and group_dim != ''){
    sql = """
        WITH dim_sig as (
            SELECT distinct platform, namespace, sig_name from ${sigTable} where is_hide is null
            union all
            select 'gitcode' as platform, 'opengauss' as namespace, 'openGauss-server' as sig_name
        ),dim as (
            <if test="group_dim == 'sub_community'">
                SELECT name as sub_community FROM ${communityTable} where parent_name = #{community} and status = 'active'
            </if>
            <if test="group_dim == 'sig'">
                SELECT platform, namespace, sig_name from dim_sig where 1=1
                <if test="source != null and source != ''">
                    and platform = #{source}
                </if>
                <if test="sig_name != null and sig_name != ''">
                    and sig_name LIKE CONCAT('%', #{sig_name}, '%')
                </if>
                <if test="sigNameList != null and sigNameList.size() > 0">
                    and sig_name in
                    <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
            </if>
        ),
        last_week_data AS (
            SELECT
                <if test="group_dim == 'sub_community'">
                    sub_community,   
                </if>     
                <if test="group_dim == 'sig'">
                    namespace, sig_name,
                </if>       
                <if test="issue_type != null and issue_type != ''">
                    super_issue_type as issue_type,
                </if>
                COALESCE(sum(open_issue_incre), 0) as total_open_count
            FROM ${contributeTable}
            <where>
                <if test="namespace != null and namespace != ''">
                    and namespace LIKE CONCAT('%', #{namespace}, '%')
                </if>
                <if test="sig_name != null and sig_name != ''">
                    and sig_name LIKE CONCAT('%', #{sig_name}, '%')
                </if>
                <if test="sigNameList != null and sigNameList.size() > 0">
                    and sig_name in
                    <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
                <if test="issue_type != null and issue_type != ''">
                    and super_issue_type = #{issue_type}
                </if>
                <if test="issueTypeList != null and issueTypeList.size() > 0">
                    and super_issue_type in
                    <foreach collection="issueTypeList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
                <if test="source != null and source != ''">
                    and source = #{source}
                </if>
                <if test="private != null and private != ''">
                    and private = #{private}
                </if>
                <if test="internalList != null and internalList.size() > 0">
                    and internal in
                    <foreach collection="internalList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
            </where>
            <if test="group_dim == 'sub_community'">
                group by sub_community
                <if test="issue_type != null and issue_type != ''">
                    ,super_issue_type
                </if>
            </if>
            <if test="group_dim == 'sig'">
                group by namespace, sig_name
                <if test="issue_type != null and issue_type != ''">
                    ,super_issue_type
                </if>
            </if>
        ),
        contribute_data AS (
            SELECT
                <if test="group_dim == 'sub_community'">
                    sub_community,   
                </if>     
                <if test="group_dim == 'sig'">
                    namespace, sig_name,
                </if>       
                <if test="issue_type != null and issue_type != ''">
                    super_issue_type as issue_type,
                </if>
                COALESCE(sum(issue_incre), 0) as count, COALESCE(sum(open_issue_incre), 0) as open_count,
                COALESCE(sum(unresponse_open_issue_incre), 0) as unresponse_open_count, 
                COALESCE(sum(issue_incre), 0) - COALESCE(sum(open_issue_incre), 0) - COALESCE(sum(progressing_issue_incre), 0) as closed_count, 
                COALESCE(sum(open_issue_incre), 0) + COALESCE(sum(progressing_issue_incre), 0) as unclosed_count,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE (sum(issue_incre) - sum(open_issue_incre) - sum(progressing_issue_incre))::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 4
                ) as closed_ratio,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(first_reply_time)::NUMERIC / sum(issue_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_first_reply_time,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(closed_time)::NUMERIC / sum(issue_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_closed_time,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(overdue_first_reply_time)::NUMERIC / sum(issue_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_overdue_first_reply_time,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(overdue_closed_time)::NUMERIC / sum(issue_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_overdue_closed_time,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(eight_hour_response_issue_incre)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as eight_hour_response_ratio,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(one_day_response_issue_incre)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as one_day_response_ratio,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(five_day_created_closed_issue_incre)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as five_day_closed_ratio,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(seven_day_created_closed_issue_incre)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as seven_day_closed_ratio,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(comment_num)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as comment_num
            FROM ${contributeTable}
            <where>
                <if test="start != null ">
                    and date >= #{start}
                </if>
                <if test="end != null ">
                    and date <= #{end}
                </if>
                <if test="namespace != null and namespace != ''">
                    and namespace LIKE CONCAT('%', #{namespace}, '%')
                </if>
                <if test="sig_name != null and sig_name != ''">
                    and sig_name LIKE CONCAT('%', #{sig_name}, '%')
                </if>
                <if test="sigNameList != null and sigNameList.size() > 0">
                    and sig_name in
                    <foreach collection="sigNameList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
                <if test="issue_type != null and issue_type != ''">
                    and super_issue_type = #{issue_type}
                </if>
                <if test="issueTypeList != null and issueTypeList.size() > 0">
                    and super_issue_type in
                    <foreach collection="issueTypeList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
                <if test="source != null and source != ''">
                    and source = #{source}
                </if>
                <if test="private != null and private != ''">
                    and private = #{private}
                </if>
                <if test="internalList != null and internalList.size() > 0">
                    and internal in
                    <foreach collection="internalList" item="item" open="(" separator="," close=")">
                        #{item}
                    </foreach>
                </if>
            </where>
            <if test="group_dim == 'sub_community'">
                group by sub_community
                <if test="issue_type != null and issue_type != ''">
                    ,super_issue_type
                </if>
            </if>
            <if test="group_dim == 'sig'">
                group by namespace, sig_name
                <if test="issue_type != null and issue_type != ''">
                    ,super_issue_type
                </if>
            </if>
        ),
        group_data as (
            select
                <if test="group_dim == 'sub_community'">
                    d.sub_community,   
                </if>     
                <if test="group_dim == 'sig'">
                    d.namespace, d.sig_name,
                </if>                
                <if test="(issue_type == null or issue_type == '') and (issueTypeList == null or issueTypeList.size() == 0)">
                    'All' as issue_type,
                </if> 
                <if test="issue_type != null and issue_type != ''">
                    #{issue_type} as issue_type,
                </if>
                <if test="issueTypeList != null and issueTypeList.size() > 0">
                    #{issueTypes} as issue_type,
                </if>
                COALESCE(count, 0) as count, COALESCE(open_count, 0) as open_count,
                COALESCE(total_open_count, 0) as total_open_count,
                COALESCE(unresponse_open_count, 0) as unresponse_open_count, 
                COALESCE(closed_count, 0) as closed_count, 
                COALESCE(unclosed_count, 0) as unclosed_count, 
                COALESCE(closed_ratio, 0) as closed_ratio, 
                COALESCE(avg_first_reply_time, 0) as avg_first_reply_time, 
                COALESCE(avg_closed_time, 0) as avg_closed_time, 
                COALESCE(avg_overdue_first_reply_time, 0) as avg_overdue_first_reply_time, 
                COALESCE(avg_overdue_closed_time, 0) as avg_overdue_closed_time,
                COALESCE(one_day_response_ratio, 0) as one_day_response_ratio, 
                COALESCE(eight_hour_response_ratio, 0) as eight_hour_response_ratio, 
                COALESCE(five_day_closed_ratio, 0) as five_day_closed_ratio, 
                COALESCE(seven_day_closed_ratio, 0) as seven_day_closed_ratio, 
                COALESCE(comment_num, 0) as comment_num
            FROM dim d
            LEFT JOIN contribute_data c 
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = c.sub_community
            </if>     
            <if test="group_dim == 'sig'">
                ON d.namespace = c.namespace and d.sig_name = c.sig_name
            </if>
            LEFT JOIN last_week_data lwd
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = lwd.sub_community
                ORDER BY d.sub_community
            </if>     
            <if test="group_dim == 'sig'">
                ON d.namespace = lwd.namespace and d.sig_name = lwd.sig_name
                ORDER BY d.sig_name
            </if>
        )
        SELECT 
            *, 
            (select count(1) from group_data) as total_count, 
            CEIL((select count(1) from group_data)::numeric/#{page_size}) as total_page
        FROM 
            group_data
        <if test="order_by != null and order_by != ''">
            ORDER BY ${order_by}
        </if>
        LIMIT #{page_size} OFFSET #{offset}
        """;
}
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
result.put("sort_field","count,open_count,unresponse_open_count");
result.put("super_issue_type", "咨询,需求,缺陷,公告,特殊");
return result

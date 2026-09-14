{
  "properties" : { },
  "id" : "7f5acd5237b6416593244cfc496e7cef",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "贡献汇总分页",
  "createTime" : null,
  "updateTime" : 1774516635298,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/contributes/page",
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
  "requestBody" : "{\r\n    \"start\":1577836800000,\r\n    \"end\":1763433027585,\r\n    \"community\":\"mindspore\",\r\n    \"orgList\":[],\r\n    \"internalList\":[],\r\n    \"source\": \"github\",\r\n    \"private\":\"false\",\r\n    \"metric\":\"user\",\r\n    \"pageNum\":1,\r\n    \"pageSize\":20,\r\n    \"asc\":\"pr_ratio\",\r\n    \"desc\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 1271,\n        \"total_page\": 64,\n        \"list\": [{\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"983183947\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 7,\n            \"comment_total\": 2,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0010,\n            \"comment_perc\": 0.0005,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.8571,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 5.7998,\n            \"issue_avg_closed_time\": 92.8865\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"949144093\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 0,\n            \"comment_total\": 4,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0000,\n            \"comment_perc\": 0.0010,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 0.0000,\n            \"issue_avg_closed_time\": 0.0000\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"641217688tly\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 1,\n            \"comment_total\": 0,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0001,\n            \"comment_perc\": 0.0000,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 434.8181,\n            \"issue_avg_closed_time\": 434.8181\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"6098669\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 0,\n            \"comment_total\": 1,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0000,\n            \"comment_perc\": 0.0002,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 0.0000,\n            \"issue_avg_closed_time\": 0.0000\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"787918582\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 49,\n            \"comment_total\": 31,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0071,\n            \"comment_perc\": 0.0076,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.9796,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 114.1861,\n            \"issue_avg_closed_time\": 151.5183\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"7125messi\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 1,\n            \"comment_total\": 2,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0001,\n            \"comment_perc\": 0.0005,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 421.8630,\n            \"issue_avg_closed_time\": 421.8630\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"1071034024\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 0,\n            \"comment_total\": 2,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0000,\n            \"comment_perc\": 0.0005,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 0.0000,\n            \"issue_avg_closed_time\": 0.0000\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"20201111208\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 1,\n            \"comment_total\": 0,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0001,\n            \"comment_perc\": 0.0000,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 1.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 0.2129,\n            \"issue_avg_closed_time\": 0.2129\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"123wuxin123\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 1,\n            \"comment_total\": 1,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0001,\n            \"comment_perc\": 0.0002,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 7.2458,\n            \"issue_avg_closed_time\": 216.0569\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"2044145178\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 0,\n            \"comment_total\": 0,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0000,\n            \"comment_perc\": 0.0000,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 0.0000,\n            \"issue_avg_closed_time\": 0.0000\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"1257597709\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 1,\n            \"comment_total\": 1,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0001,\n            \"comment_perc\": 0.0002,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 1.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 0.6480,\n            \"issue_avg_closed_time\": 0.9061\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"22dimensions\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 0,\n            \"comment_total\": 5,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0000,\n            \"comment_perc\": 0.0012,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 0.0000,\n            \"issue_avg_closed_time\": 0.0000\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"22-Pig\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 0,\n            \"comment_total\": 0,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0000,\n            \"comment_perc\": 0.0000,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 0.0000,\n            \"issue_avg_closed_time\": 0.0000\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"01lin\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 2,\n            \"comment_total\": 0,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0003,\n            \"comment_perc\": 0.0000,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.5000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 503.3318,\n            \"issue_avg_closed_time\": 503.3318\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"291336599\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 1,\n            \"comment_total\": 1,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0001,\n            \"comment_perc\": 0.0002,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 3.0445,\n            \"issue_avg_closed_time\": 435.8719\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"3353463971\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 1,\n            \"comment_total\": 0,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0001,\n            \"comment_perc\": 0.0000,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 1.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 1.4945,\n            \"issue_avg_closed_time\": 6.5223\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"420xincheng\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 0,\n            \"comment_total\": 1,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0000,\n            \"comment_perc\": 0.0002,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 0.0000,\n            \"pr_avg_reply_time\": 432.8356,\n            \"pr_avg_closed_time\": 432.8356,\n            \"issue_avg_reply_time\": 0.0000,\n            \"issue_avg_closed_time\": 0.0000\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"453875726\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 1,\n            \"comment_total\": 0,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0001,\n            \"comment_perc\": 0.0000,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 1.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 8.0257,\n            \"issue_avg_closed_time\": 230.9569\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"4everImmortality\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 7,\n            \"comment_total\": 2,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0010,\n            \"comment_perc\": 0.0005,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 1.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 3.4805,\n            \"issue_avg_closed_time\": 3.9294\n        }, {\n            \"company\": \"个人贡献者\",\n            \"user_login\": \"Aayingk\",\n            \"pr_total\": 0,\n            \"pr_perc\": 0.0000,\n            \"issue_total\": 1,\n            \"comment_total\": 0,\n            \"addcode_total\": 0,\n            \"issue_perc\": 0.0001,\n            \"comment_perc\": 0.0000,\n            \"addcode_perc\": 0.0000,\n            \"pr_ratio\": 0.0000,\n            \"issue_ratio\": 1.0000,\n            \"pr_avg_reply_time\": 0.0000,\n            \"pr_avg_closed_time\": 0.0000,\n            \"issue_avg_reply_time\": 3.4297,\n            \"issue_avg_closed_time\": 3.4297\n        }]\n    },\n    \"timestamp\": 1773904201859,\n    \"executeTime\": 332\n}",
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
      "value" : "1763433027585",
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
      "value" : "mindspore",
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
      "name" : "orgList",
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
      "name" : "source",
      "value" : "github",
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
      "name" : "metric",
      "value" : "user",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "metric 只能为 user、company 或 repo",
      "expression" : "^(user|company|repo|sig)?$",
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
      "value" : "20",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过100000",
      "expression" : "pageSize > 0 && pageSize <= 100000",
      "children" : [ ]
    }, {
      "name" : "asc",
      "value" : "pr_ratio",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "asc 字段非法",
      "expression" : "^(pr_total|issue_total|comment_total|addcode_total|pr_ratio|issue_ratio|comment_ratio|addcode_ratio|pr_avg_reply_time|pr_avg_closed_time|issue_avg_reply_time|issue_avg_closed_time|pr|issue|comment|addcode)?$",
            "children" : [ ]
          }, {
            "name" : "desc",
            "value" : "",
            "description" : "",
            "required" : false,
            "dataType" : "String",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "pattern",
            "error" : "desc 字段非法",
            "expression" : "^(pr_total|issue_total|comment_total|addcode_total|pr_ratio|issue_ratio|comment_ratio|addcode_ratio|pr_avg_reply_time|pr_avg_closed_time|issue_avg_reply_time|issue_avg_closed_time|pr|issue|comment|addcode)?$",
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
        "value" : "1283",
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
        "value" : "65",
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
            "value" : "个人贡献者",
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
            "name" : "user_login",
            "value" : "983183947",
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
            "name" : "pr_total",
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
            "name" : "pr_perc",
            "value" : "0.0000",
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
            "name" : "issue_total",
            "value" : "7",
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
            "name" : "comment_total",
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
          }, {
            "name" : "addcode_total",
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
            "name" : "issue_perc",
            "value" : "0.0010",
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
            "name" : "comment_perc",
            "value" : "0.0003",
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
            "name" : "addcode_perc",
            "value" : "0.0000",
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
            "name" : "pr_ratio",
            "value" : "0.0000",
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
            "name" : "issue_ratio",
            "value" : "0.8571",
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
            "name" : "pr_avg_reply_time",
            "value" : "0.0000",
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
            "name" : "pr_avg_closed_time",
            "value" : "0.0000",
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
            "name" : "issue_avg_reply_time",
            "value" : "5.7998",
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
            "name" : "issue_avg_closed_time",
            "value" : "90.0323",
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
            "name" : "resolved_ratio",
            "value" : "0.7143",
            "description" : "解决率",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "avg_resolved_time",
            "value" : "12.50",
            "description" : "平均解决时长，单位天",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1772177991006",
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
      "value" : "322",
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
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 服务平台
var source = body.source;
// 组织
var orgList = body.orgList;
// 内外部
var internalList = body.internalList;
// 是否私仓
var private = body.private;
// 贡献类型：pr,issue,comment,addcode
var event = body.event;
// 仓库
var repo_path = body.repo_path;
// 组织类型
var company_type = body.company_type;
// 组织
var company = body.company;
// sig
var sig_name = body.sig_name;
// 用户
var user_login = body.user_login;
// topn
var page_num = body.pageNum;
var page_size = body.pageSize;
// resolved_ratio / avg_resolved_time 仅作展示，不参与排序（见 #1424）
var sortList = ["pr_ratio","issue_ratio"]
var offset = (page_num - 1) * page_size
var order_by_set = new HashSet()
var order_asc = "";
if (body.asc != null and body.asc != "") {
    var asc_arr = body.asc.split(",");
    for(index,item in asc_arr){
        if (item == 'pr' or item == 'issue' or item == 'comment' or item == 'addcode'){
            item = item + "_total asc";
            order_by_set.add(item);
        } else {
            if (sortList.contains(item)){
                order_by_set.add(item + " asc");
            }
        }
    }
}
var order_desc = "";
if (body.desc != null and body.desc != "") {
    var desc_arr = body.desc.split(",");
    for(index,item in desc_arr){
        if (item == 'pr' or item == 'issue' or item == 'comment' or item == 'addcode'){
            item = item + "_total desc";
            order_by_set.add(item);
        } else {
            if (sortList.contains(item)){
                order_by_set.add(item + " desc");
            }
        }
    }
}
var order_by = "";
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
// company_type-组织 company-组织明细 sig-SIG repo-仓库 user-开发者
var metric = body.metric;
var columnStr = '';
var columnArr = [];
var table_sub = metric;
if (metric == 'company_type') {
    columnStr = 'company_type'
    table_sub = 'company'
    columnArr = ['company_type']
} else if (metric == 'company') {
    columnStr = 'company,company_type'
    columnArr = ['company', 'company_type']
} else if (metric == 'sig') {
    columnStr = 'sig_name'
    columnArr = ['sig_name']
} else if (metric == 'repo') {
    columnStr = 'repo_path,repo_url'
    columnArr = ['repo_path', 'repo_url']
} else if (metric == 'user') {
    columnStr = 'user_login'
    table_sub = 'user_detail'
    columnArr = ['user_login']
}
// resolved字段拼接（company维度才有真实数据）
var resolvedFieldInFilter = "";
if (metric == 'company') {
    resolvedFieldInFilter = "sum(resolved_issue_incre) as resolved_issue_total, sum(resolved_time) as resolved_time_total";
} else {
    resolvedFieldInFilter = "0 as resolved_issue_total, 0 as resolved_time_total";
}
// 社区
var community = body.community.toLowerCase();
// 贡献表
var contributeTable = "dws_" + community + "_contribute_" + table_sub + "_daily";
// 仅 user 指标按仓库筛选时切换到仓库维度贡献表（仅有 pr_incre/issue_incre/comment_incre）
var useRepoTable = (metric == 'user' && repo_path != null && repo_path != '');
if (useRepoTable) {
    contributeTable = "dws_" + community + "_contribute_repo_user_daily";
}
var repoTable = "fact_" + community + "_repo";
var sigTable = "fact_" + community + "_sig_user";
var companyTable = "dwm_" + community + "_company";
var userTable = "dwm_" + community + "_contribute_user_company";
var sql = """
WITH dim_table AS (
    <if test="metric == 'repo'">
        select 
        repo_path, html_url as repo_url
        from ${repoTable}
    </if>
    <if test="metric == 'sig'">
        select 
            distinct sig_name
        from ${sigTable}
    </if>
    <if test="metric == 'company_type'">
        select 
            distinct company_type
        from ${companyTable}
    </if>
    <if test="metric == 'company'">
        select 
            distinct company,company_type
        from ${companyTable}
    </if>
    <if test="metric == 'user'">
        select 
            distinct company, user_login
        from ${userTable}
    </if>
    <where>
        <if test="metric == 'repo' or metric == 'sig' or metric == 'company_type' or metric == 'company'">
            (is_removed is null and is_hide is null)
        </if>
        <if test="metric == 'user'">
            and d1_time is not null
        </if>
        <if test="metric == 'sig'">
            and sig_name is not null
        </if>
        <if test="source != null and source != ''">
            <if test="metric == 'repo'">
                and code_platform = #{source}
            </if>
            <if test="metric == 'user' or metric == 'company_type' or metric == 'company'">
                and source = #{source}
            </if>
            <if test="metric == 'sig'">
                and platform = #{source}
            </if>
        </if>
        <if test="metric != 'sig' and private != null and private != ''">
            and private = #{private}
        </if>
        <if test="orgList != null and orgList.size() > 0">
            and namespace in
            <foreach collection="orgList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="(metric == 'user' or metric == 'company' or metric == 'company_type') and internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="metric == 'user' and useRepoTable">
            and user_login in (
                select distinct user_login
                from ${contributeTable}
                where repo_path = #{repo_path}
                and date::DATE BETWEEN #{start} AND #{end}
            )
        </if>
    </where>
),
filter_data AS (
    SELECT
        ${columnStr},
        <if test="useRepoTable">
            sum(pr_incre) as pr_total,
            0 as open_pr_total,
            sum(merged_pr_incre) as merged_pr_total,
            sum(issue_incre) as issue_total,
            0 as open_issue_total,
            0 as progressing_issue_total,
            sum(comment_incre) as comment_total,
            0 as addcode_total,
            0 as pr_first_reply_time,
            0 as pr_closed_time,
            0 as issue_first_reply_time,
            0 as issue_closed_time,
            0 as resolved_issue_total,
            0 as resolved_time_total
        </if>
        <else>
            sum(pr_incre) as pr_total,
            sum(open_pr_incre) as open_pr_total,
            sum(merged_pr_incre) as merged_pr_total,
            sum(issue_incre) as issue_total,
            sum(open_issue_incre) as open_issue_total,
            sum(progressing_issue_incre) as progressing_issue_total,
            sum(comment_incre) as comment_total,
            sum(addcode_incre) as addcode_total,
            sum(pr_first_reply_time) as pr_first_reply_time,
            sum(pr_closed_time) as pr_closed_time,
            sum(issue_first_reply_time) as issue_first_reply_time,
            sum(issue_closed_time) as issue_closed_time,
            ${resolvedFieldInFilter}
        </else>
    FROM ${contributeTable}
    <where>
        date::DATE BETWEEN #{start} AND #{end}
        <if test="source != null and source != ''">
            and source = #{source}
        </if>
        <if test="private != null and private != ''">
            and private = #{private}
        </if>
        <if test="orgList != null and orgList.size() > 0">
            and namespace in
            <foreach collection="orgList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="useRepoTable">
            and repo_path = #{repo_path}
        </if>
    </where>
    GROUP BY ${columnStr}
),
total_filter_data AS (
    select  
    sum(pr_total) as pr_sum, sum(merged_pr_total) as merged_pr_sum, sum(issue_total) as issue_sum, sum(comment_total) as comment_sum, sum(addcode_total) as addcode_sum
    from filter_data
),
joined_data AS (
    SELECT 
        dt.*,
        COALESCE(fd.pr_total, 0) AS pr_total,
        COALESCE(fd.merged_pr_total, 0) AS merged_pr_total,
        (COALESCE(fd.pr_total, 0)  - COALESCE(fd.open_pr_total, 0)) AS closed_pr_total,
        COALESCE(fd.issue_total, 0) AS issue_total,
        (COALESCE(fd.issue_total, 0) - COALESCE(fd.open_issue_total, 0) - COALESCE(fd.progressing_issue_total, 0)) AS closed_issue_total,
        COALESCE(fd.comment_total, 0) AS comment_total,
        COALESCE(fd.addcode_total, 0) AS addcode_total,
        COALESCE(fd.pr_first_reply_time, 0) AS pr_first_reply_time,
        COALESCE(fd.pr_closed_time, 0) AS pr_closed_time,
        COALESCE(fd.issue_first_reply_time, 0) AS issue_first_reply_time,
        COALESCE(fd.issue_closed_time, 0) AS issue_closed_time,
        COALESCE(fd.resolved_issue_total, 0) AS resolved_issue_total,
        COALESCE(fd.resolved_time_total, 0) AS resolved_time_total
    FROM dim_table dt
    LEFT JOIN filter_data fd ON
    <if test="columnArr != null and columnArr.size() > 0">
        <foreach collection="columnArr" item="item"  separator=" AND ">
            dt.${item} = fd.${item}
        </foreach>
    </if>
)
SELECT 
    <if test="metric == 'user'">
        jd.company, jd.user_login,
    </if>
    <if test="metric != 'user'">
        <foreach collection="columnArr" item="item" separator=",">
            jd.${item}
        </foreach>,
    </if>
        jd.merged_pr_total as pr_total,
        ROUND(
            CASE
                WHEN tfd.merged_pr_sum = 0 THEN 0
                ELSE jd.merged_pr_total::NUMERIC / tfd.merged_pr_sum
            END::NUMERIC , 4
        ) as pr_perc,
    jd.issue_total, jd.comment_total, jd.addcode_total,
    ROUND(
        CASE
            WHEN tfd.issue_sum = 0 THEN 0
            ELSE jd.issue_total::NUMERIC / tfd.issue_sum
        END::NUMERIC , 4
    ) as issue_perc,
    ROUND(
        CASE
            WHEN tfd.comment_sum = 0 THEN 0
            ELSE jd.comment_total::NUMERIC / tfd.comment_sum
        END::NUMERIC , 4
    ) as comment_perc,
    ROUND(
        CASE
            WHEN tfd.addcode_sum = 0 THEN 0
            ELSE jd.addcode_total::NUMERIC / tfd.addcode_sum
        END::NUMERIC , 4
    ) as addcode_perc,
    ROUND(
        CASE
            WHEN jd.pr_total = 0 THEN 0
            ELSE jd.closed_pr_total::NUMERIC / jd.pr_total
        END::NUMERIC , 4
    ) as pr_ratio,
    ROUND(
        CASE
            WHEN jd.issue_total = 0 THEN 0
            ELSE jd.closed_issue_total::NUMERIC / jd.issue_total
        END::NUMERIC , 4
    ) as issue_ratio,
    ROUND(
        CASE
            WHEN jd.pr_total = 0 THEN 0
            ELSE jd.pr_first_reply_time::NUMERIC / jd.pr_total / 86400
        END::NUMERIC , 4
    ) as pr_avg_reply_time,
    ROUND(
        CASE
            WHEN jd.pr_total = 0 THEN 0
            ELSE jd.pr_closed_time::NUMERIC / jd.pr_total / 86400
        END::NUMERIC , 4
    ) as pr_avg_closed_time,
    ROUND(
        CASE
            WHEN jd.issue_total = 0 THEN 0
            ELSE jd.issue_first_reply_time::NUMERIC / jd.issue_total / 86400
        END::NUMERIC , 4
    ) as issue_avg_reply_time,
    ROUND(
        CASE
            WHEN jd.issue_total = 0 THEN 0
            ELSE jd.issue_closed_time::NUMERIC / jd.issue_total / 86400
        END::NUMERIC , 4
    ) as issue_avg_closed_time,
    <if test="metric == 'company'">
        ROUND(
            CASE
                WHEN jd.issue_total = 0 THEN 0
                ELSE jd.resolved_issue_total::NUMERIC / jd.issue_total
            END::NUMERIC , 4
        ) as resolved_ratio,
        ROUND(
            CASE
                WHEN jd.resolved_issue_total = 0 THEN 0
                ELSE jd.resolved_time_total::NUMERIC / jd.resolved_issue_total / 86400
            END::NUMERIC , 4
        ) as avg_resolved_time,
    </if>
(select count(1) from dim_table) as total_count,
CEIL(((select count(1) from dim_table)::numeric) / #{page_size}) as total_page
FROM 
    joined_data jd, total_filter_data tfd
<if test="order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset}
""";
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
// resolved_ratio / avg_resolved_time 已随其它指标在 SQL 中计算（真实 resolved 口径，见 #1424），此处只清理分页辅助字段
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
return result

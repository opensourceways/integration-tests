{
  "properties" : { },
  "id" : "copy1763688104444d95918",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "issue汇总分页",
  "createTime" : null,
  "updateTime" : 1774661251753,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/issues/agg",
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
  "requestBody" : "{\r\n    \"start\":1769875200000,\r\n    \"end\":1772294400000,\r\n    \"pageNum\": 1,\r\n    \"pageSize\": 2,\r\n    \"group_dim\": \"\",\r\n    \"community\":\"mindall\",\r\n    \"issue_type\": \"\",\r\n    \"issue_type_list\": [],\r\n    \"namespace\":\"\",\r\n    \"repo_path\":\"\",\r\n    \"repo_path_list\": [],\r\n    \"source\": \"\",\r\n    \"internalList\": [],\r\n    \"private\": \"false\",\r\n    \"asc\":\"\",\r\n    \"desc\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 10,\n        \"total_page\": 5,\n        \"list\": [{\n            \"sub_community\": \"ascendnpuir\",\n            \"issue_type\": \"All\",\n            \"count\": 53,\n            \"resolved_count\": 20,\n            \"resolved_ratio\": 37.74,\n            \"avg_resolved_time\": 15.32,\n            \"open_count\": 33,\n            \"week_new_count\": 9,\n            \"unresponse_open_count\": 7,\n            \"closed_count\": 40,\n            \"unclosed_count\": 33,\n            \"closed_ratio\": 0.3774,\n            \"avg_first_reply_time\": 6.34,\n            \"median_first_reply_time\": 0.40,\n            \"median_closed_time\": 23.20,\n            \"avg_closed_time\": 26.68,\n            \"avg_overdue_first_reply_time\": 5.55,\n            \"avg_overdue_closed_time\": 16.00,\n            \"one_day_response_ratio\": 0.40,\n            \"eight_hour_response_ratio\": 0.19,\n            \"five_day_closed_ratio\": 0.08,\n            \"seven_day_closed_ratio\": 0.09,\n            \"comment_num\": 1.43\n        }, {\n            \"sub_community\": \"mindcluster\",\n            \"issue_type\": \"All\",\n            \"count\": 77,\n            \"resolved_count\": 55,\n            \"resolved_ratio\": 70.77,\n            \"avg_resolved_time\": 12.45,\n            \"open_count\": 36,\n            \"week_new_count\": 4,\n            \"unresponse_open_count\": 1,\n            \"closed_count\": 43,\n            \"unclosed_count\": 36,\n            \"closed_ratio\": 0.5325,\n            \"avg_first_reply_time\": 9.21,\n            \"median_first_reply_time\": 0.04,\n            \"median_closed_time\": 11.11,\n            \"avg_closed_time\": 21.80,\n            \"avg_overdue_first_reply_time\": 8.49,\n            \"avg_overdue_closed_time\": 4.07,\n            \"one_day_response_ratio\": 0.52,\n            \"eight_hour_response_ratio\": 0.25,\n            \"five_day_closed_ratio\": 0.22,\n            \"seven_day_closed_ratio\": 0.26,\n            \"comment_num\": 1.10\n        }],\n        \"page_size\": 2\n    },\n    \"timestamp\": 1773647929301,\n    \"executeTime\": 22\n}",
  "description" : "issue贡献汇总信息分页查询接口（支持全社区/子社区/仓库维度）返回指标：issue总数、已解决issue总数、解决率、平均解决时长（天）、开启issue总数、本周新增issue总数、未响应issue总数、未关闭issue总数、关闭率、平均首次响应时间（天）、平均关闭时间（天）、平均首次响应超时时间（天）、平均关闭超时时间（天）、24小时响应率、8小时响应率、5天内关闭率、7天内关闭率、5天内解决率、7天内解决率、评论互动数量",
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
      "value" : "1769875200000",
      "description" : "开始时间，格式为毫秒时间戳",
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
      "value" : "1772294400000",
      "description" : "结束时间，格式为毫秒时间戳",
      "required" : true,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "1",
      "description" : "查询页码",
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
      "value" : "2",
      "description" : "每页数量",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过100000",
      "expression" : "pageSize > 0 && pageSize <= 100000",
      "children" : [ ]
    }, {
      "name" : "group_dim",
      "value" : "",
      "description" : "聚合维度，如果不填则是全社区汇总",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "group_dim 只能为 sub_community 或 repo",
      "expression" : "^(sub_community|repo)?$",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "openeuler",
      "description" : "社区，查询所属社区",
      "required" : true,
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
      "description" : "issue类型",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "issue_type 格式非法",
      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5]*$",
      "children" : [ ]
    }, {
      "name" : "issue_type_list",
      "value" : "",
      "description" : "issue类型数组",
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
      "description" : "namespace",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "namespace 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-]*$",
      "children" : [ ]
    }, {
      "name" : "repo_path",
      "value" : "",
      "description" : "仓库路径",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-/.]*$",
      "children" : [ ]
    }, {
      "name" : "repo_path_list",
      "value" : "",
      "description" : "仓库清单（精确过滤，非空则 repo_path IN (...)）",
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
      "description" : "资源平台：gitee\\gitcode\\github",
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
      "description" : "内外部数组",
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
      "description" : "公私仓：public-公仓，private-私仓",
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
      "value" : "one_day_response_ratio",
      "description" : "正序排列字段",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "asc 字段非法",
      "expression" : "^(count|open_count|unresponse_open_count|closed_count|unclosed_count|closed_ratio|avg_first_reply_time|median_first_reply_time|avg_closed_time|median_closed_time|avg_overdue_first_reply_time|avg_overdue_closed_time|eight_hour_response_ratio|one_day_response_ratio|five_day_closed_ratio|seven_day_closed_ratio|five_day_resolved_ratio|seven_day_resolved_ratio|comment_num|week_new_count|resolved_count|resolved_ratio|avg_resolved_time|total_open_count)?$",
      "children" : [ ]
    }, {
      "name" : "desc",
      "value" : "",
      "description" : "倒叙排列字段",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "desc 字段非法",
      "expression" : "^(count|open_count|unresponse_open_count|closed_count|unclosed_count|closed_ratio|avg_first_reply_time|median_first_reply_time|avg_closed_time|median_closed_time|avg_overdue_first_reply_time|avg_overdue_closed_time|eight_hour_response_ratio|one_day_response_ratio|five_day_closed_ratio|seven_day_closed_ratio|five_day_resolved_ratio|seven_day_resolved_ratio|comment_num|week_new_count|resolved_count|resolved_ratio|avg_resolved_time|total_open_count)?$",
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
      "description" : "响应码",
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
      "description" : "响应消息",
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
      "description" : "响应数据",
      "required" : false,
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "total_count",
        "value" : "10",
        "description" : "数据总数",
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
        "value" : "5",
        "description" : "数据总页数",
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
        "description" : "数据列表",
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
            "name" : "sub_community",
            "value" : "ascendnpuir",
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
            "value" : "53",
            "description" : "issue总数",
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
            "value" : "33",
            "description" : "开启issue总数",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "week_new_count",
            "value" : "9",
            "description" : "本周新增issue数",
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
            "value" : "7",
            "description" : "未响应issue总数",
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
            "value" : "40",
            "description" : "关闭issue总数",
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
            "value" : "33",
            "description" : "未关闭issue总数",
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
            "value" : "0.3774",
            "description" : "关闭率",
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
            "value" : "6.34",
            "description" : "平均首次响应时间，单位天",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "median_first_reply_time",
            "value" : "0.40",
            "description" : "首次响应时间中位数，单位天",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "median_closed_time",
            "value" : "23.20",
            "description" : "关闭时间中位数，单位天",
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
            "value" : "26.68",
            "description" : "平均关闭时间，单位天",
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
            "value" : "5.55",
            "description" : "平均首次响应超时时间，单位天",
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
            "value" : "16.00",
            "description" : "平均关闭超时时间，单位天",
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
            "value" : "0.40",
            "description" : "24小时响应率",
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
            "value" : "0.19",
            "description" : "8小时响应率",
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
            "value" : "0.08",
            "description" : "5天内关闭率",
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
            "value" : "0.09",
            "description" : "7天内关闭率",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "five_day_resolved_ratio",
            "value" : "0.19",
            "description" : "5天内解决率（口径同 Issue平均解决率 resolved_ratio：is_resolved=true 且解决时长<5天的 issue 数 / issue 总数）",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "seven_day_resolved_ratio",
            "value" : "0.23",
            "description" : "7天内解决率（口径同 Issue平均解决率 resolved_ratio：is_resolved=true 且解决时长<7天的 issue 数 / issue 总数）",
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
            "value" : "1.43",
            "description" : "评论互动数量",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "resolved_count",
            "value" : "20",
            "description" : "已解决issue总数（基于resolved标记）",
            "required" : false,
            "dataType" : "Integer",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "resolved_ratio",
            "value" : "0.3774",
            "description" : "解决率（0~1小数）",
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
            "value" : "15.32",
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
      }, {
        "name" : "page_size",
        "value" : "2",
        "description" : "每页数量",
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
      "value" : "1773647427363",
      "description" : "响应时间戳",
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
var sortList = ["count","open_count","week_new_count","unresponse_open_count","unclosed_count","closed_ratio","avg_closed_time","avg_first_reply_time","one_day_response_ratio","eight_hour_response_ratio","five_day_closed_ratio","seven_day_closed_ratio","five_day_resolved_ratio","seven_day_resolved_ratio","comment_num","resolved_count","resolved_ratio","avg_resolved_time","total_open_count"]
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
// 仓库
var repo_path = body.repo_path;
var repoPathList = body.repo_path_list;
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
        if (sortList.contains(item)){
            order_by_set.add(item + " asc");
        }
    }
}
var order_desc = "";
if (body.desc != null and body.desc != "") {
    var desc_arr = body.desc.split(",");
    for(index,item in desc_arr){
        if (sortList.contains(item)){
            order_by_set.add(item + " desc");
        }
    }
}
var order_by = "";
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
var contributeTable = "dws_" + community + "_issue_contribute_repo_daily";
var repoTable = "fact_" + community + "_repo";
var communityTable = "fact_community_structure";
var sql = """
WITH last_week_data AS (
    SELECT
        COALESCE(sum(open_issue_incre), 0) as week_new_count
    FROM ${contributeTable}
    <where>
        date >= #{last7Start} and date <= #{last7End} and internal is not null
        <if test="no_sub_community != null and no_sub_community != ''">
            and sub_community != #{no_sub_community}
        </if>
        <if test="namespace != null and namespace != ''">
            and namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="repo_path != null and repo_path != ''">
            and repo_path LIKE CONCAT('%', #{repo_path}, '%')
        </if>
        <if test="repoPathList != null and repoPathList.size() > 0">
            and repo_path in
            <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
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
        COALESCE(sum(closed_issue_incre), 0) as closed_count, 
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
                ELSE sum(five_day_closed_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as five_day_closed_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(seven_day_closed_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as seven_day_closed_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(five_day_resolved_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as five_day_resolved_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(seven_day_resolved_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as seven_day_resolved_ratio,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(comment_num)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 2
        ) as comment_num,
        COALESCE(sum(resolved_issue_incre), 0) as resolved_count,
        ROUND(
            CASE
                WHEN sum(issue_incre) = 0 THEN 0
                ELSE sum(resolved_issue_incre)::NUMERIC / sum(issue_incre)
            END::NUMERIC , 4
        ) as resolved_ratio,
        ROUND(
            CASE
                WHEN COALESCE(sum(resolved_issue_incre), 0) = 0 THEN 0
                ELSE sum(resolved_time)::NUMERIC / sum(resolved_issue_incre) / 86400
            END::NUMERIC , 2
        ) as avg_resolved_time,
        ROUND(
            CASE
                WHEN COALESCE(sum(resolved_issue_incre), 0) = 0 THEN 0
                ELSE sum(overdue_resolved_time)::NUMERIC / sum(resolved_issue_incre) / 86400
            END::NUMERIC , 2
        ) as avg_overdue_resolved_time
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
        <if test="repo_path != null and repo_path != ''">
            and repo_path LIKE CONCAT('%', #{repo_path}, '%')
        </if>
        <if test="repoPathList != null and repoPathList.size() > 0">
            and repo_path in
            <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
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
    *, 0 as median_first_reply_time, 0 as median_closed_time,
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
        WITH dim as (
            <if test="group_dim == 'sub_community'">
                SELECT name as sub_community FROM ${communityTable} where parent_name = #{community} and status = 'active'
                <if test="order_by == null or order_by == ''">
                    ORDER BY name
                    LIMIT #{page_size} OFFSET #{offset}
                </if>
            </if>
            <if test="group_dim == 'repo'">
                SELECT namespace, repo_path, html_url as repo_url from ${repoTable} where is_hide is null
                <if test="source != null and source != ''">
                    and code_platform = #{source}
                </if>
                <if test="private != null and private != ''">
                    and private = #{private}
                </if>
                <if test="repo_path != null and repo_path != ''">
                    and repo_path LIKE CONCAT('%', #{repo_path}, '%')
                </if>
        <if test="repoPathList != null and repoPathList.size() > 0">
            and repo_path in
            <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
                <if test="order_by == null or order_by == ''">
                    ORDER BY repo_path
                    LIMIT #{page_size} OFFSET #{offset}
                </if>
            </if>
        ),
        dim_total as (
            <if test="group_dim == 'sub_community'">
                SELECT count(1) as total_count FROM ${communityTable} where parent_name = #{community} and status = 'active'
            </if>
            <if test="group_dim == 'repo'">
                SELECT count(1) as total_count from ${repoTable} where is_hide is null
                <if test="source != null and source != ''">
                    and code_platform = #{source}
                </if>
                <if test="private != null and private != ''">
                    and private = #{private}
                </if>
                <if test="repo_path != null and repo_path != ''">
                    and repo_path LIKE CONCAT('%', #{repo_path}, '%')
                </if>
                <if test="repoPathList != null and repoPathList.size() > 0">
                    and repo_path in
                    <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
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
                <if test="group_dim == 'repo'">
                    namespace, repo_path, repo_url,
                </if>       
                <if test="issue_type != null and issue_type != ''">
                    super_issue_type as issue_type,
                </if>
                COALESCE(sum(open_issue_incre), 0) as week_new_count
            FROM ${contributeTable}
            <where>
                date >= #{last7Start} and date <= #{last7End}
                <if test="namespace != null and namespace != ''">
                    and namespace LIKE CONCAT('%', #{namespace}, '%')
                </if>
                <if test="repo_path != null and repo_path != ''">
                    and repo_path LIKE CONCAT('%', #{repo_path}, '%')
                </if>
        <if test="repoPathList != null and repoPathList.size() > 0">
            and repo_path in
            <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
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
            <if test="group_dim == 'repo'">
                group by namespace, repo_path, repo_url
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
                <if test="group_dim == 'repo'">
                    namespace, repo_path, repo_url,
                </if>       
                <if test="issue_type != null and issue_type != ''">
                    super_issue_type as issue_type,
                </if>
                COALESCE(sum(issue_incre), 0) as count, COALESCE(sum(open_issue_incre), 0) as open_count,
                COALESCE(sum(unresponse_open_issue_incre), 0) as unresponse_open_count, 
                COALESCE(sum(closed_issue_incre), 0) as closed_count, 
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
                ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY COALESCE(first_reply_time, 0)) / 86400.0)::NUMERIC, 2) as median_first_reply_time,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(closed_time)::NUMERIC / sum(issue_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_closed_time,
                ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY COALESCE(closed_time, 0)) / 86400.0)::NUMERIC, 2) as median_closed_time,
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
                        ELSE sum(five_day_closed_issue_incre)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as five_day_closed_ratio,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(seven_day_closed_issue_incre)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as seven_day_closed_ratio,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(five_day_resolved_issue_incre)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as five_day_resolved_ratio,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(seven_day_resolved_issue_incre)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as seven_day_resolved_ratio,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(comment_num)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 2
                ) as comment_num,
                COALESCE(sum(resolved_issue_incre), 0) as resolved_count,
                ROUND(
                    CASE
                        WHEN sum(issue_incre) = 0 THEN 0
                        ELSE sum(resolved_issue_incre)::NUMERIC / sum(issue_incre)
                    END::NUMERIC , 4
                ) as resolved_ratio,
                ROUND(
                    CASE
                        WHEN COALESCE(sum(resolved_issue_incre), 0) = 0 THEN 0
                        ELSE sum(resolved_time)::NUMERIC / sum(resolved_issue_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_resolved_time,
                ROUND(
                    CASE
                        WHEN COALESCE(sum(resolved_issue_incre), 0) = 0 THEN 0
                        ELSE sum(overdue_resolved_time)::NUMERIC / sum(resolved_issue_incre) / 86400
                    END::NUMERIC , 2
                ) as avg_overdue_resolved_time
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
                <if test="repo_path != null and repo_path != ''">
                    and repo_path LIKE CONCAT('%', #{repo_path}, '%')
                </if>
        <if test="repoPathList != null and repoPathList.size() > 0">
            and repo_path in
            <foreach collection="repoPathList" item="item" open="(" separator="," close=")">
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
            <if test="group_dim == 'repo'">
                group by namespace, repo_path, repo_url
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
                <if test="group_dim == 'repo'">
                    d.namespace, d.repo_path, d.repo_url,
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
                COALESCE(week_new_count, 0) as week_new_count,
                <if test="group_dim == 'repo'">
                    COALESCE(open_count, 0) as total_open_count,
                </if>
                COALESCE(unresponse_open_count, 0) as unresponse_open_count,
                COALESCE(closed_count, 0) as closed_count, 
                COALESCE(unclosed_count, 0) as unclosed_count, 
                COALESCE(closed_ratio, 0) as closed_ratio, 
                COALESCE(avg_first_reply_time, 0) as avg_first_reply_time, 
                COALESCE(median_first_reply_time, 0) as median_first_reply_time,
                COALESCE(median_closed_time, 0) as median_closed_time,
                COALESCE(avg_closed_time, 0) as avg_closed_time, 
                COALESCE(avg_overdue_first_reply_time, 0) as avg_overdue_first_reply_time, 
                COALESCE(avg_overdue_closed_time, 0) as avg_overdue_closed_time,
                COALESCE(one_day_response_ratio, 0) as one_day_response_ratio, 
                COALESCE(eight_hour_response_ratio, 0) as eight_hour_response_ratio, 
                COALESCE(five_day_closed_ratio, 0) as five_day_closed_ratio,
                COALESCE(seven_day_closed_ratio, 0) as seven_day_closed_ratio,
                COALESCE(five_day_resolved_ratio, 0) as five_day_resolved_ratio,
                COALESCE(seven_day_resolved_ratio, 0) as seven_day_resolved_ratio,
                COALESCE(comment_num, 0) as comment_num,
                COALESCE(resolved_count, 0) as resolved_count,
                COALESCE(resolved_ratio, 0) as resolved_ratio,
                COALESCE(avg_resolved_time, 0) as avg_resolved_time,
                COALESCE(avg_overdue_resolved_time, 0) as avg_overdue_resolved_time
            FROM dim d
            LEFT JOIN contribute_data c
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = c.sub_community
            </if>
            <if test="group_dim == 'repo'">
                ON d.namespace = c.namespace and d.repo_path = c.repo_path
            </if>
            LEFT JOIN last_week_data lwd
            <if test="group_dim == 'sub_community'">
                ON d.sub_community = lwd.sub_community
                ORDER BY d.sub_community
            </if>     
            <if test="group_dim == 'repo'">
                ON d.namespace = lwd.namespace and d.repo_path = lwd.repo_path
                ORDER BY d.repo_path
            </if>
        )
        SELECT
            *,
            <if test="order_by == null or order_by == ''">
                (select total_count from dim_total) as total_count,
                CEIL((select total_count from dim_total)::numeric/#{page_size}) as total_page
            </if>
            <if test="order_by != null and order_by != ''">
                (select count(1) from group_data) as total_count,
                CEIL((select count(1) from group_data)::numeric/#{page_size}) as total_page
            </if>
        FROM
            group_data
        <if test="order_by != null and order_by != ''">
            ORDER BY ${order_by}
            LIMIT #{page_size} OFFSET #{offset}
        </if>
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
result.put("page_size", page_size);
return result

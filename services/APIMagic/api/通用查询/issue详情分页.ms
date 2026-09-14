{
  "properties" : { },
  "id" : "13e991aa70a84786a572fdff8e391dfc",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "issue详情分页",
  "createTime" : null,
  "updateTime" : 1774603275211,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/issues/detail",
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
  "requestBody" : "{\r\n    \"community\":\"openeuler\",\r\n    \"namespace\":\"openeuler\",\r\n    \"repo_path\":\"kernel\",\r\n    \"title\": \"\",\r\n    \"label\": \"\",\r\n    \"response\": \"\",\r\n    \"assginee\":\"\",\r\n    \"issue_type\": \"\",\r\n    \"issue_type_list\": [\"缺陷\",\"需求\"],\r\n    \"state\": \"\",\r\n    \"priority\": \"\",\r\n    \"is_response\": \"\",\r\n    \"pageNum\": 1,\r\n    \"pageSize\": 10,\r\n    \"start\": 1565280000000,\r\n    \"end\": 1764325337863,\r\n    \"asc\": \"open_time\"\r\n \r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"sort_field\": \"created_at,closed_at,open_time,avg_first_reply_time,avg_closed_time\",\n        \"total_count\": 3657,\n        \"total_page\": 366,\n        \"filter_field\": \"title,creator,issue_type,state,priority\",\n        \"list\": [{\n            \"title\": \"[openEuler-1.0-LTS] 构造分布式存储故障，恢复后，guestOS 无法退出bypaas模式，文件系统损坏\",\n            \"issue_type\": \"缺陷\",\n            \"user_name\": \"yangyingliang\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/5317\",\n            \"assignees_user_names\": null,\n            \"label\": \"sig/Kernel\",\n            \"first_reply_at\": null,\n            \"resolved_at\": null,\n            \"created_at\": \"2022-02-10 14:55:07\",\n            \"updated_at\": \"2022-02-16 17:46:30\",\n            \"closed_at\": \"2022-02-10 15:00:42\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }, {\n            \"title\": \"olk-5.10 backport bpf selftest\",\n            \"issue_type\": \"缺陷\",\n            \"user_name\": \"pulehui\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/7181\",\n            \"assignees_user_names\": \"CTC-XiboWang\",\n            \"label\": \"sig/Kernel\",\n            \"first_reply_at\": \"2025-12-01 21:05:33\",\n            \"resolved_at\": null,\n            \"created_at\": \"2025-07-18 10:56:43\",\n            \"updated_at\": \"2025-07-18 10:57:10\",\n            \"closed_at\": \"2025-07-18 10:57:08\",\n            \"first_reply_url\": \"https://gitcode.com/openeuler/kernel/issues/7181#tid-154029645\",\n            \"body\": \"当前版本无法复现此问题\",\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }, {\n            \"title\": \"[openEuler 20.03] 支持内存分级扩展\",\n            \"issue_type\": \"需求\",\n            \"user_name\": \"gatieme11\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/6253\",\n            \"assignees_user_names\": null,\n            \"label\": \"sig/Kernel\",\n            \"first_reply_at\": null,\n            \"resolved_at\": null,\n            \"created_at\": \"2021-06-18 14:16:52\",\n            \"updated_at\": \"2021-06-18 14:18:20\",\n            \"closed_at\": \"2021-06-18 14:18:18\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }, {\n            \"title\": \"【openEuler-20.03-SP3】M客户应用协议解析场景cpu占用率高\",\n            \"issue_type\": \"缺陷\",\n            \"user_name\": \"stkid\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/2940\",\n            \"assignees_user_names\": null,\n            \"label\": \"help-wanted,issue_invalid,sig/Kernel\",\n            \"first_reply_at\": null,\n            \"resolved_at\": null,\n            \"created_at\": \"2023-08-26 13:05:56\",\n            \"updated_at\": \"2023-08-26 13:20:18\",\n            \"closed_at\": \"2023-08-26 13:11:21\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }, {\n            \"title\": \"test\",\n            \"issue_type\": \"需求\",\n            \"user_name\": \"oekernel\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/311\",\n            \"assignees_user_names\": null,\n            \"label\": \"sig/Kernel\",\n            \"first_reply_at\": null,\n            \"resolved_at\": null,\n            \"created_at\": \"2024-12-06 02:55:37\",\n            \"updated_at\": \"2025-11-25 22:57:39\",\n            \"closed_at\": \"2024-12-06 02:56:26\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }, {\n            \"title\": \"[openEuler-20.03] 开启SMMU时，Taishan 200系列服务器无法使用3408iMR/3416iMRraid卡\",\n            \"issue_type\": \"需求\",\n            \"user_name\": \"gatieme11\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/6233\",\n            \"assignees_user_names\": null,\n            \"label\": \"sig/Kernel\",\n            \"first_reply_at\": null,\n            \"resolved_at\": null,\n            \"created_at\": \"2021-06-30 17:11:30\",\n            \"updated_at\": \"2021-06-30 17:16:26\",\n            \"closed_at\": \"2021-06-30 17:15:34\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }, {\n            \"title\": \"[openEuler-1.0-LTS] 长稳环境中出现blkcg相关的use-after-free告警\",\n            \"issue_type\": \"缺陷\",\n            \"user_name\": \"yangyingliang\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/5836\",\n            \"assignees_user_names\": null,\n            \"label\": \"sig/Kernel\",\n            \"first_reply_at\": null,\n            \"resolved_at\": null,\n            \"created_at\": \"2021-09-17 15:48:38\",\n            \"updated_at\": \"2021-09-22 16:05:42\",\n            \"closed_at\": \"2021-09-17 15:54:01\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }, {\n            \"title\": \"[openEuler] HBA卡驱动\",\n            \"issue_type\": \"需求\",\n            \"user_name\": \"gatieme11\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/6276\",\n            \"assignees_user_names\": null,\n            \"label\": \"sig/Kernel\",\n            \"first_reply_at\": null,\n            \"resolved_at\": null,\n            \"created_at\": \"2021-06-02 10:48:37\",\n            \"updated_at\": \"2021-06-07 10:20:10\",\n            \"closed_at\": \"2021-06-02 10:51:11\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }, {\n            \"title\": \"[openEuler] ERRATA add options to tuning the prefetch prolicy for HIP08\",\n            \"issue_type\": \"需求\",\n            \"user_name\": \"gatieme11\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/6280\",\n            \"assignees_user_names\": \"gatieme11\",\n            \"label\": \"sig/Kernel\",\n            \"first_reply_at\": null,\n            \"resolved_at\": null,\n            \"created_at\": \"2021-05-31 17:01:14\",\n            \"updated_at\": \"2021-06-23 15:30:13\",\n            \"closed_at\": \"2021-05-31 17:02:04\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }, {\n            \"title\": \"[openEuler-1.0-LTS] 合入了thinpool优化补丁， 导致ramdsik场景下内存达到水线，出现告警\",\n            \"issue_type\": \"缺陷\",\n            \"user_name\": \"yangyingliang\",\n            \"state\": \"closed\",\n            \"priority\": \"1\",\n            \"html_url\": \"https://gitcode.com/openeuler/kernel/issues/5555\",\n            \"assignees_user_names\": null,\n            \"label\": \"sig/Kernel\",\n            \"first_reply_at\": null,\n            \"resolved_at\": null,\n            \"created_at\": \"2021-12-14 20:55:21\",\n            \"updated_at\": \"2021-12-21 22:08:41\",\n            \"closed_at\": \"2021-12-14 20:56:51\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00,\n            \"priority_text\": \"不重要\"\n        }]\n    },\n    \"timestamp\": 1772421845155,\n    \"executeTime\": 523\n}",
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
      "value" : "openeuler",
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
      "name" : "namespace",
      "value" : "openeuler",
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
      "name" : "repo_path",
      "value" : "kernel",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-/.]*$",
      "children" : [ ]
    }, {
      "name" : "title",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "title 格式非法",
      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5 \\-\\.]*$",
      "children" : [ ]
    }, {
      "name" : "label",
      "value" : "sig/Kernel",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "label 格式非法",
      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5 \\-\\./]*$",
      "children" : [ ]
    }, {
      "name" : "response",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "response 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-]*$",
      "children" : [ ]
    }, {
      "name" : "assginee",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "assginee 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-]*$",
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
      "expression" : "^[a-zA-Z0-9_\\u4e00-\\u9fa5]*$",
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
      "name" : "state",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "state 只能为 open、closed、resolved",
      "expression" : "^(open|closed|resolved)?$",
      "children" : [ ]
    }, {
      "name" : "priority",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "priority 格式非法",
      "expression" : "^[a-zA-Z0-9_]*$",
      "children" : [ ]
    }, {
      "name" : "is_response",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "is_response 只能为 y 或 n",
      "expression" : "^(y|n)?$",
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
      "error" : "pageSize 必须为正整数且不超过100000",
      "expression" : "pageSize > 0 && pageSize <= 100000",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "1565280000000",
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
      "value" : "1764325337863",
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
      "name" : "asc",
      "value" : "open_time",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "asc 字段非法",
      "expression" : "^(open_time|first_reply_time|created_at|updated_at|closed_at|avg_first_reply_time|avg_closed_time|avg_overdue_first_reply_time|avg_overdue_closed_time)?$",
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
        "value" : "created_at,closed_at,open_time,avg_first_reply_time,avg_closed_time",
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
        "name" : "total_page",
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
        "name" : "filter_field",
        "value" : "title,creator,issue_type,state,priority",
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
        "children" : [ ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1772421779551",
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
      "value" : "195",
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
import java.util.Arrays;
import  magic;
var start = null;
if (body.start != null and body.start != '') {
    start = body.start;
}
var end = null;
if (body.end != null and body.end != '') {
    end = body.end;
}
var filter_field = ["type", "state", "priority"];
var sort_field = ["open_time", "first_reply_time", "created_at", "updated_at","closed_at","avg_first_reply_time", "avg_closed_time", "avg_overdue_first_reply_time", "avg_overdue_closed_time"];
// 社区
var community = body.community;
// 组织
var namespace = body.namespace;
// 仓库
var repo_path = body.repo_path;
// 标题
var title = body.title;
// 责任人
var assginee = body.assginee;
// 提出人
var creator = body.creator;
// issue分类
var issue_type = body.issue_type;
// Issue类型数组
var issueTypeList = body.issue_type_list;
// issue状态
var state = body.state;
// 标签
var label = body.label;
// 首次回复内容
var response = body.response;
// 优先级
var priority = body.priority;
// 是否有响应
var is_response = body.is_response;
var asc_tem  = body.asc;
var desc_tem  = body.desc;
// 排序
var order_by_set = new HashSet()
var order_asc = "";
if (asc_tem != null and asc_tem != "") {
    var asc_arr = asc_tem.split(",");
    for(index,item in asc_arr){
        if (sort_field.contains(item)) {
            order_by_set.add(item + " asc");
        }
    }
}
var order_desc = "";
if (desc_tem != null and desc_tem != "") {
    var desc_arr = desc_tem.split(",");
    for(index,item in desc_arr){
        if (sort_field.contains(item)) {
            order_by_set.add(item + " desc");
        }
    }
}
var order_by = null;
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
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
var contributeTable = "dws_" + community + "_contribute";
var issueTable = "fact_" + community + "_issue";
var commentTable = "dwm_" + community + "_comment";
var sql = """
WITH contribute_data AS (
    SELECT
        ct.title, ct.super_issue_type as issue_type, it.user_login as user_name, ct.state, it.priority, ct.html_url,
        CASE
            WHEN it.assignees_user_names = '{}' THEN NULL
            ELSE regexp_replace(it.assignees_user_names, '^\{|\}$', '', 'g')
        END AS assignees_user_names,
        CASE
            WHEN it.labels_name = '{}' THEN NULL
            ELSE regexp_replace(it.labels_name, '^\{|\}$', '', 'g')
        END AS label,
        ct.first_reply_at, it.resolved_at,
        it.created_at, it.updated_at, it.closed_at, ct.first_reply_url, ict.body,
        CASE 
            WHEN it.resolved_at IS NOT NULL THEN it.resolved_at
            WHEN it.closed_at_label IS NOT NULL THEN it.closed_at_label
            ELSE NULL 
        END as resolved_at_display,
        CASE 
            WHEN it.closed_at IS NOT NULL THEN it.closed_at
            WHEN it.final_closed_at IS NOT NULL THEN it.final_closed_at
            ELSE NULL 
        END as closed_at_display,
        ROUND( ct.first_reply_time::numeric / 86400, 2 ) as avg_first_reply_time,
        ROUND( COALESCE(ct.closed_time, ct.open_time)::numeric / 86400, 2 ) as avg_closed_time,
        ROUND( COALESCE(ct.open_time, 0)::numeric / 86400, 2 ) as open_time,
        ROUND( COALESCE(ct.overdue_first_reply_time, 0)::numeric / 86400, 2 ) as avg_overdue_first_reply_time,
        ROUND( COALESCE(ct.overdue_closed_time, 0)::numeric / 86400, 2 ) as avg_overdue_closed_time 
    FROM ${contributeTable} ct
    left join ${issueTable} it on ct.uuid = 'issue-' || it.uuid
    left join ${commentTable} ict on ict.ref_uuid = it.uuid
    <where>
        ct.contrib_type = 'issue' and ct.is_hide is null
        <if test="start != null ">
            and ct.created_at >= to_timestamp(#{start} / 1000)
        </if>
        <if test="end != null ">
            and ct.created_at <= to_timestamp(#{end} / 1000)
        </if>
        <if test="namespace != null and namespace != ''">
            and ct.namespace = #{namespace}
        </if>
        <if test="repo_path != null and repo_path != ''">
            and ct.repo_path = #{repo_path}
        </if>
        <if test="issue_type != null and issue_type != ''">
            and ct.super_issue_type = #{issue_type}
        </if>
        <if test="issueTypeList != null and issueTypeList.size() > 0">
            and ct.super_issue_type in
            <foreach collection="issueTypeList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="title != null and title != ''">
            and ct.title LIKE CONCAT('%', #{title}, '%')
        </if>
        <if test="response != null and response != ''">
            and ict.body LIKE CONCAT('%', #{response}, '%')
        </if>
        <if test="creator != null and creator != ''">
            and it.user_login LIKE CONCAT('%', #{creator}, '%')
        </if>
        <if test="priority != null and priority != ''">
            and it.priority = #{priority}
        </if>
        <if test="label != null and label != ''">
            and it.labels_name LIKE CONCAT('%', #{label}, '%')
        </if>
        <if test="state != null and state != '' and state != 'resolved'">
            and ct.state = #{state}
        </if>
        <if test="state == 'resolved'">
            and it.is_resolved::boolean = true
        </if>
        <if test="is_response == 'n'">
            and ct.first_reply_url is  null
        </if>
        <if test="assginee != null and assginee != ''">
            and it.assignees_user_names LIKE CONCAT('%', #{assginee}, '%')
        </if>
    </where>
),
count_ori as (
    select count(1) as total_count from contribute_data
)
SELECT 
    cd.*,
    co.total_count, 
    CEIL(co.total_count::numeric/#{page_size}) as total_page
FROM 
    contribute_data cd, count_ori co
<if test="order_by != null and order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset}
""";
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    var priority = item.get("priority");
    var priority_text = "-"
    if ("0" == priority){
        priority_text = '无优先级'
    } else if ("1" == priority){
        priority_text = '不重要'
    } else if ("2" == priority){
        priority_text = '次要'
    } else if ("3" == priority){
        priority_text = '主要'
    } else if ("4" == priority){
        priority_text = '严重'
    }
    item.put('priority_text', priority_text);
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
result.put("filter_field","title,creator,issue_type,state,priority");
result.put("sort_field","created_at,closed_at,open_time,avg_first_reply_time,avg_closed_time");
return result

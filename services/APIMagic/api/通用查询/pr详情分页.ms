{
  "properties" : { },
  "id" : "copy1765352830565d64567",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "pr详情分页",
  "createTime" : null,
  "updateTime" : 1766568045438,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/prs/detail",
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
  "requestBody" : "{\r\n    \"community\":\"openeuler\",\r\n    \"namespace\":\"\",\r\n    \"repo_path\":\"\",\r\n    \"title\": \"\",\r\n    \"response\": \"\",\r\n    \"assginee\":\"\",\r\n    \"issue_type\": \"\",\r\n    \"state\": \"\",\r\n    \"priority\": \"\",\r\n    \"is_response\": \"\",\r\n    \"pageNum\": 1,\r\n    \"pageSize\": 10,\r\n    \"start\": 1759276800000,\r\n    \"end\": 1764325337863,\r\n    \"asc\": \"open_time\"\r\n \r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"sort_field\": \"created_at,closed_at,open_time,avg_first_reply_time,avg_closed_time\",\n        \"total_count\": 12966,\n        \"total_page\": 1297,\n        \"filter_field\": \"title,creator,pr_type,state\",\n        \"list\": [{\n            \"title\": \"revise and append kernels\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"hao-mingzhe\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/openeuler/GVirt/pulls/27\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-11-03 11:40:33\",\n            \"updated_at\": \"2025-11-03 11:47:05\",\n            \"closed_at\": \"2025-11-03 11:47:05\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }, {\n            \"title\": \"Update package to version 49.0\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"kylinosZlw\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/src-openeuler/gnome-text-editor/pulls/7\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-10-29 11:30:21\",\n            \"updated_at\": \"2025-10-29 11:36:56\",\n            \"closed_at\": \"2025-10-29 11:36:56\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }, {\n            \"title\": \"add some expressions\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"CHEN_YUHAN_HELEN\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/openeuler/OmniOperator/pulls/11\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-10-09 20:47:51\",\n            \"updated_at\": \"2025-10-09 20:55:05\",\n            \"closed_at\": \"2025-10-09 20:51:06\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }, {\n            \"title\": \"【轻量级 PR】：Update README.md\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"gitee-agent\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/openeuler/uos-libvirtd-exporter/pulls/4\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-10-09 16:55:12\",\n            \"updated_at\": \"2025-10-09 16:56:20\",\n            \"closed_at\": \"2025-10-09 16:56:20\",\n            \"first_reply_url\": \"https://gitee.com/openeuler/uos-libvirtd-exporter/pulls/4#note_46972588_conversation_168894407\",\n            \"body\": \"/close\",\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }, {\n            \"title\": \"mm: shmem: drop the unnecessary folio_nr_pages()\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"lianux\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/openeuler/kernel/pulls/18281\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-10-09 09:51:55\",\n            \"updated_at\": \"2025-10-09 10:45:06\",\n            \"closed_at\": \"2025-10-09 09:52:59\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }, {\n            \"title\": \"回退 'Pull Request !479 : feat(input\\\\textarea): 增加length插槽;增加showLength参…\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"devin-cwd\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/openeuler/opendesign-components/pulls/481\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-11-19 10:49:09\",\n            \"updated_at\": \"2025-11-19 10:49:36\",\n            \"closed_at\": \"2025-11-19 10:49:36\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }, {\n            \"title\": \"Update to 6.2.1\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"wangkui35\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/src-openeuler/ctags/pulls/19\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-11-25 19:19:33\",\n            \"updated_at\": \"2025-11-25 19:34:40\",\n            \"closed_at\": \"2025-11-25 19:19:46\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }, {\n            \"title\": \"更新架构图\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"zxstty\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/openeuler/euler-copilot-framework/pulls/880\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-11-07 16:00:18\",\n            \"updated_at\": \"2025-11-07 16:00:42\",\n            \"closed_at\": \"2025-11-07 16:00:42\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }, {\n            \"title\": \"reason:修改yr为yuanrong\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"kilikkk\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/openeuler/yuanrong/pulls/118\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-11-20 11:02:35\",\n            \"updated_at\": \"2025-11-20 11:15:21\",\n            \"closed_at\": \"2025-11-20 11:03:09\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }, {\n            \"title\": \"feat: 更新ministe议程\",\n            \"pr_type\": \"需求\",\n            \"user_name\": \"xiaoshiziya\",\n            \"state\": \"closed\",\n            \"html_url\": \"https://gitee.com/openeuler/openEuler-portal/pulls/2898\",\n            \"assignees_user_names\": null,\n            \"created_at\": \"2025-10-27 19:47:04\",\n            \"updated_at\": \"2025-10-27 19:55:28\",\n            \"closed_at\": \"2025-10-27 19:54:11\",\n            \"first_reply_url\": null,\n            \"body\": null,\n            \"avg_first_reply_time\": 0.00,\n            \"avg_closed_time\": 0.00,\n            \"open_time\": 0.00,\n            \"avg_overdue_first_reply_time\": 0.00,\n            \"avg_overdue_closed_time\": 0.00\n        }]\n    },\n    \"timestamp\": 1766568034831,\n    \"executeTime\": 913\n}",
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
      "name" : "community",
      "value" : "mindie",
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
      "name" : "repo_path",
      "value" : "",
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
      "name" : "state",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "state 只能为 open、closed、merged",
      "expression" : "^(open|closed|merged)?$",
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
      "error" : "pageSize 必须为正整数且不超过2000",
      "expression" : "pageSize > 0 && pageSize <= 2000",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "1759276800000",
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
        "value" : "12923",
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
        "value" : "1293",
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
        "value" : "title,creator,pr_type,state",
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
            "name" : "title",
            "value" : "Update package to version 49.0",
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
            "name" : "pr_type",
            "value" : "需求",
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
            "name" : "user_name",
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
            "name" : "state",
            "value" : "closed",
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
            "name" : "html_url",
            "value" : "https://gitee.com/src-openeuler/gnome-contacts/pulls/9",
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
            "name" : "assignees_user_names",
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
            "name" : "created_at",
            "value" : "2025-10-29 10:40:37",
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
            "name" : "updated_at",
            "value" : "2025-10-29 10:47:46",
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
            "name" : "closed_at",
            "value" : "2025-10-29 10:46:36",
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
            "name" : "first_reply_url",
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
            "name" : "body",
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
            "name" : "avg_first_reply_time",
            "value" : "0.00",
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
            "value" : "0.00",
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
            "name" : "open_time",
            "value" : "0.00",
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
            "value" : "0.00",
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
            "value" : "0.00",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1766568011368",
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
      "value" : "659",
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
var pr_type = body.pr_type;
// 状态
var state = body.state;
// 首次回复内容
var response = body.response;
// 优先级
var priority = body.priority;
// 是否有响应
var is_response = body.is_response;
// #1348: 是否剔除私有 PR (与排行榜 private='false' 口径对齐)
var exclude_private = body.exclude_private;
// #1348: 跳过慢的全量 count (抽屉总数改由 daily 聚合接口给), 只取当前页明细, openeuler 大数据量 <1s
var skip_count = body.skip_count;
// #1348: 日期口径字段。合并PR(state=merged)下钻传 date_field='merged_at' 按合并日过滤+展示,
//   与排行榜 merged_pr_incre / 趋势(daily-trend event=pr)同源(生产实测 misaka00251 合并PR: merged_at=64=榜,
//   逐天与榜 0 不一致; created_at 只 59, 漏跨年创建当年合并的 PR)。其它调用方不传=默认 created_at, 行为不变。
var date_field = "created_at";
if (body.date_field == 'merged_at') {
    date_field = "merged_at";
}
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
var prTable = "fact_" + community + "_pr";
var commentTable = "dwm_" + community + "_comment";
var sql = """
WITH base AS (
<if test="skip_count == true or skip_count == 'true'">
    /* #1348 抽屉快速路径: 只查 dws_contribute(ct), 不 JOIN fact_pr。
       生产实测 openeuler 大用户 fundawang: 带 fact_pr JOIN 1135ms(超1s) -> 免JOIN 1.66ms(683x)。
       抽屉仅展示 title/state/日期/html_url, 均在 ct; fact_pr 派生列(updated_at/closed_at/assignees)置 NULL。
       assginee/response 过滤依赖 fact_pr/comment, 抽屉不传这两参, 故快速路径不含。 */
    SELECT
        ct.title, ct.super_issue_type as pr_type, ct.user_login as user_name, ct.state, ct.html_url,
        NULL::text as _it_uuid,
        NULL AS assignees_user_names,
        ct.${date_field} as created_at, NULL as updated_at, NULL as closed_at, ct.first_reply_url,
        ROUND( ct.first_reply_time::numeric / 86400, 2 ) as avg_first_reply_time,
        ROUND( COALESCE(ct.closed_time, ct.open_time)::numeric / 86400, 2 ) as avg_closed_time,
        ROUND( COALESCE(ct.open_time, 0)::numeric / 86400, 2 ) as open_time,
        ROUND( COALESCE(ct.overdue_first_reply_time, 0)::numeric / 86400, 2 ) as avg_overdue_first_reply_time,
        ROUND( COALESCE(ct.overdue_closed_time, 0)::numeric / 86400, 2 ) as avg_overdue_closed_time
    FROM ${contributeTable} ct
    <where>
        ct.contrib_type = 'pr' and ct.is_hide is null
        <if test="start != null "> and ct.${date_field} >= to_timestamp(#{start} / 1000) </if>
        <if test="end != null "> and ct.${date_field} <= to_timestamp(#{end} / 1000) </if>
        <if test="namespace != null and namespace != ''"> and ct.namespace = #{namespace} </if>
        <if test="repo_path != null and repo_path != ''"> and ct.repo_path = #{repo_path} </if>
        <if test="pr_type != null and pr_type != ''"> and ct.super_issue_type = #{pr_type} </if>
        <if test="title != null and title != ''"> and ct.title LIKE CONCAT('%', #{title}, '%') </if>
        <if test="creator != null and creator != ''"> and ct.user_login LIKE CONCAT('%', #{creator}, '%') </if>
        <if test="state != null and state != ''"> and ct.state = #{state} </if>
        <if test="exclude_private == true or exclude_private == 'true'"> and ct.private = 'false' </if>
        <if test="is_response == 'n'"> and ct.first_reply_url is null </if>
    </where>
</if>
<if test="skip_count != true and skip_count != 'true'">
    SELECT
        ct.title, ct.super_issue_type as pr_type, ct.user_login as user_name, ct.state, ct.html_url,
        it.uuid as _it_uuid,
        CASE
            WHEN it.assignees_user_names = '{}' THEN NULL
            ELSE regexp_replace(it.assignees_user_names, '^\{|\}$', '', 'g')
        END AS assignees_user_names,
        ct.${date_field} as created_at, it.updated_at, it.closed_at, ct.first_reply_url,
        ROUND( ct.first_reply_time::numeric / 86400, 2 ) as avg_first_reply_time,
        ROUND( COALESCE(ct.closed_time, ct.open_time)::numeric / 86400, 2 ) as avg_closed_time,
        ROUND( COALESCE(ct.open_time, 0)::numeric / 86400, 2 ) as open_time,
        ROUND( COALESCE(ct.overdue_first_reply_time, 0)::numeric / 86400, 2 ) as avg_overdue_first_reply_time,
        ROUND( COALESCE(ct.overdue_closed_time, 0)::numeric / 86400, 2 ) as avg_overdue_closed_time
    FROM ${contributeTable} ct
    left join ${prTable} it on ct.html_url = it.html_url and ct.uuid = 'pr-' || it.uuid
    <where>
        ct.contrib_type = 'pr' and ct.is_hide is null
        <if test="start != null "> and ct.${date_field} >= to_timestamp(#{start} / 1000) </if>
        <if test="end != null "> and ct.${date_field} <= to_timestamp(#{end} / 1000) </if>
        <if test="namespace != null and namespace != ''"> and ct.namespace = #{namespace} </if>
        <if test="repo_path != null and repo_path != ''"> and ct.repo_path = #{repo_path} </if>
        <if test="pr_type != null and pr_type != ''"> and ct.super_issue_type = #{pr_type} </if>
        <if test="title != null and title != ''"> and ct.title LIKE CONCAT('%', #{title}, '%') </if>
        <if test="response != null and response != ''"> and EXISTS (SELECT 1 FROM ${commentTable} ic WHERE ic.ref_uuid = it.uuid AND ic.body LIKE CONCAT('%', #{response}, '%')) </if>
        <!-- #1348: creator/user_name 用 ct.user_login(dws_contribute)与排行榜/趋势同源(生产实测 misaka00251 提交PR ct=67=榜, it(fact_pr)=51) -->
        <if test="creator != null and creator != ''"> and ct.user_login LIKE CONCAT('%', #{creator}, '%') </if>
        <if test="state != null and state != ''"> and ct.state = #{state} </if>
        <!-- #1348: 与贡献者排行榜口径对齐(榜只统计 private='false'), 私有标记在 ct.private(fact_pr.private 恒NULL) -->
        <if test="exclude_private == true or exclude_private == 'true'"> and ct.private = 'false' </if>
        <if test="is_response == 'n'"> and ct.first_reply_url is null </if>
        <if test="assginee != null and assginee != ''"> and it.assignees_user_names LIKE CONCAT('%', #{assginee}, '%') </if>
    </where>
</if>
),
<if test="skip_count != true and skip_count != 'true'">
count_ori as (
    select count(1) as total_count from base
),
</if>
paged as (
    SELECT * FROM base
    <if test="order_by != null and order_by != ''">
        ORDER BY ${order_by}
    </if>
    LIMIT #{page_size} OFFSET #{offset}
)
<if test="skip_count != true and skip_count != 'true'">
SELECT
    p.title, p.pr_type, p.user_name, p.state, p.html_url, p.assignees_user_names,
    p.created_at, p.updated_at, p.closed_at, p.first_reply_url,
    (SELECT ic.body FROM ${commentTable} ic WHERE ic.ref_uuid = p._it_uuid LIMIT 1) as body,
    p.avg_first_reply_time, p.avg_closed_time, p.open_time, p.avg_overdue_first_reply_time, p.avg_overdue_closed_time,
    co.total_count,
    CEIL(co.total_count::numeric/#{page_size}) as total_page
FROM paged p, count_ori co
</if>
<if test="skip_count == true or skip_count == 'true'">
SELECT
    p.title, p.pr_type, p.user_name, p.state, p.html_url, p.assignees_user_names,
    p.created_at, p.updated_at, p.closed_at, p.first_reply_url,
    NULL as body,
    p.avg_first_reply_time, p.avg_closed_time, p.open_time, p.avg_overdue_first_reply_time, p.avg_overdue_closed_time,
    -1 as total_count,
    0 as total_page
FROM paged p
</if>
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
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
result.put("filter_field","title,creator,pr_type,state");
result.put("sort_field","created_at,closed_at,open_time,avg_first_reply_time,avg_closed_time");
return result

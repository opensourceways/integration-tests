{
  "properties" : { },
  "id" : "7a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d",
  "script" : null,
  "groupId" : "9af308d96b55470faeda3c9b3357f836",
  "name" : "社区会议预定查询",
  "createTime" : null,
  "updateTime" : 1774929090929,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "page",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page > 0",
    "children" : null
  }, {
    "name" : "page_size",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "10",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page_size <= 100 && page_size > 0",
    "children" : null
  }, {
    "name" : "sig_name",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : null
  }, {
    "name" : "topic",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : null
  }, {
    "name" : "sponsor",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : null
  }, {
    "name" : "created_after",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "created_after 格式应为 yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
    "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
    "children" : null
  }, {
    "name" : "created_before",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "created_before 格式应为 yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
    "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
    "children" : null
  }, {
    "name" : "sort",
    "value" : "created_at",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "created_at",
    "validateType" : "pattern",
    "error" : "sort 只能为 created_at、sig_name、topic",
    "expression" : "^(created_at|sig_name|topic)?$",
    "children" : null
  }, {
    "name" : "direction",
    "value" : "desc",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "desc",
    "validateType" : "pattern",
    "error" : "direction 只能为 asc 或 desc",
    "expression" : "^(asc|desc|ASC|DESC)?$",
    "children" : null
  }, {
    "name" : "meeting_id",
    "value" : "",
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
  "requestBody" : "",
  "headers" : [ {
    "name" : "token",
    "value" : "",
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
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 1,\n        \"list\": [{\n            \"meeting_id\": \"3214\",\n            \"sponsor\": \"hfutsdd\",\n            \"sig_name\": \"sig-QA\",\n            \"community\": \"openeuler\",\n            \"topic\": \"QA SIG例会\",\n            \"created_at\": \"2026-02-04 00:00:00\",\n            \"start\": \"14:15\",\n            \"end\": \"16:15\",\n            \"etherpad\": \"https://etherpad.openeuler.org/p/sig-QA-meetings\",\n            \"email_list\": \"qa@openeuler.org;\",\n            \"mid\": \"966359845\",\n            \"join_url\": \"https://meeting.huaweicloud.com:36443/#/j/966359845\",\n            \"agenda\": \"\",\n            \"m_id\": null,\n            \"platform\": \"welink\"\n        }]\n    },\n    \"timestamp\": 1774928196653,\n    \"executeTime\": 10\n}",
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
        "name" : "total",
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
            "name" : "meeting_id",
            "value" : "3214",
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
            "name" : "sponsor",
            "value" : "hfutsdd",
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
            "value" : "sig-QA",
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
            "name" : "community",
            "value" : "openeuler",
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
            "name" : "topic",
            "value" : "QA SIG例会",
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
            "value" : "2026-02-04 00:00:00",
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
            "name" : "start",
            "value" : "14:15",
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
            "name" : "end",
            "value" : "16:15",
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
            "name" : "etherpad",
            "value" : "https://etherpad.openeuler.org/p/sig-QA-meetings",
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
            "name" : "email_list",
            "value" : "qa@openeuler.org;",
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
            "name" : "mid",
            "value" : "966359845",
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
            "name" : "join_url",
            "value" : "https://meeting.huaweicloud.com:36443/#/j/966359845",
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
            "name" : "agenda",
            "value" : "",
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
            "name" : "m_id",
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
            "name" : "platform",
            "value" : "welink",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1774928196653",
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
var off = (page - 1) * page_size

var table_name = `fact_${community}_meeting_info`

var sort_field = not_blank(sort) ? '"' + sort + '"' : '"created_at"'
var sort_dir = not_blank(direction) ? direction.toLowerCase() : 'desc'

var sqlstr = """
SELECT
    "meeting_id",
    "sponsor",
    "sig_name",
    "community",
    "topic",
    "created_at",
    "start",
    "end",
    "etherpad",
    "email_list",
    "mid",
    "join_url",
    "agenda",
    "m_id",
    "platform"
FROM
    ${table_name} t
WHERE
    1 = 1
    <if test="not_blank(sig_name)">
        AND "sig_name" = #{sig_name}
    </if>
    <if test="not_blank(topic)">
        AND "topic" = #{topic}
    </if>
    <if test="not_blank(sponsor)">
        AND "sponsor" = #{sponsor}
    </if>
    <if test="not_blank(meeting_id)">
        AND "meeting_id" = #{meeting_id}
    </if>
    <if test="not_blank(created_after)">
        AND "created_at" >= #{created_after}::timestamptz
    </if>
    <if test="not_blank(created_before)">
        AND "created_at" < #{created_before}::timestamptz
    </if>
    AND "is_removed" IS NULL
ORDER BY ${sort_field} ${sort_dir}
"""

var resp = db.page(sqlstr, page_size, off)

return resp

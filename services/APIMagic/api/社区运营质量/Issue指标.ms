{
  "properties" : { },
  "id" : "copy1773747165020d55157",
  "script" : null,
  "groupId" : "2e2220ca1c424052ba4fa20a1e7370f8",
  "name" : "Issue指标",
  "createTime" : null,
  "updateTime" : 1775099526924,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/issue",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openubmc",
    "description" : "社区名称",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "1757196800000",
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
    "value" : "1779875200000",
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
    "name" : "private",
    "value" : "false",
    "description" : "是否私仓，默认 false 表示仅统计公仓数据，true 表示统计所有数据（包括私仓）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "false",
    "validateType" : "pattern",
    "error" : "private 只能为 true 或 false",
    "expression" : "^(true|false)?$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"count\": 0,\n        \"avg_first_reply_time\": null,\n        \"avg_closed_time\": null,\n        \"median_first_reply_time\": null,\n        \"median_closed_time\": null\n    }],\n    \"timestamp\": 1774577847612,\n    \"executeTime\": 248\n}",
  "description" : "统计社区Issue汇总指标（平均首次响应时间、平均闭环时间、首次响应时间中位数、闭环时间中位数）",
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
      "value" : "1577836800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1772790693004",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "pageNum",
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
      "value" : "count",
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
          "name" : "count",
          "value" : "2600",
          "description" : "Issue帖子总数",
          "required" : false,
          "dataType" : "Integer",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "avg_first_reply_time",
          "value" : "21.29",
          "description" : "首次响应时间平均值",
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
          "value" : "21.29",
          "description" : "关闭时间平均值",
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
          "value" : "29.21",
          "description" : "首次响应时间中位数",
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
          "value" : "588.67",
          "description" : "关闭时间中位数",
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
      "name" : "timestamp",
      "value" : "1773367432276",
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
    } ]
  }
}
================================
community = community.toLowerCase()
if (community == 'cann'){
    community == 'cannopen'
}
var sql = """
SELECT
      count(*) as count, 
      ROUND((AVG(COALESCE(first_reply_time, 0)) / 86400.0)::NUMERIC, 2) AS avg_first_reply_time,
      ROUND((AVG(COALESCE(closed_time, open_time, 0)) / 86400.0)::NUMERIC, 2) AS avg_closed_time,
      ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY COALESCE(first_reply_time, 0)) / 86400.0)::NUMERIC, 2) AS median_first_reply_time,
      ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY COALESCE(closed_time, open_time, 0)) / 86400.0)::NUMERIC, 2) AS median_closed_time
FROM dws_${community}_contribute
<where>
    contrib_type = 'issue' and is_hide is null and is_removed is null
    <if test="start != null and start != ''">
        AND created_at >= to_timestamp(#{start}/1000)
    </if>
    <if test="end != null and end != ''">
        AND created_at <= to_timestamp(#{end}/1000)
    </if>
    <if test="namespace != null and namespace != ''">
        and namespace LIKE CONCAT('%', #{namespace}, '%')
    </if>
    <if test="repo_path != null and repo_path != ''">
        and repo_path LIKE CONCAT('%', #{repo_path}, '%')
    </if>
    <if test="source != null and source != ''">
        and source = #{source}
    </if>
    <if test="private == 'false'">
        and private = #{private}
    </if>
    <if test="internalList != null and internalList.size() > 0">
        and internal in
        <foreach collection="internalList" item="item" open="(" separator="," close=")">
            #{item}
        </foreach>
    </if>
</where>     
"""
var resp = db.select(sql)
return resp

{
  "properties" : { },
  "id" : "5e8b0664a1964794bdc39132953a4efc",
  "script" : null,
  "groupId" : "12d952eea410421d80e54b1a53bcd3cf",
  "name" : "筛选器查询",
  "createTime" : null,
  "updateTime" : 1775619614192,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/issues/filter",
  "method" : "POST",
  "parameters" : [ {
    "name" : "community",
    "value" : "openubmc",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(mindspore|openubmc)$",
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
  }, {
    "name" : "permission",
    "value" : "query_filter,mcp",
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
  "requestBody" : "{\r\n\t\"filters\": [\r\n\t\t{\r\n\t\t\t\"field\": \"milestone\",\r\n\t\t\t\"value\": null\r\n\t\t},\r\n\t\t{\r\n\t\t\t\"field\": \"assignee\",\r\n\t\t\t\"value\": null\r\n\t\t},\r\n        {\r\n\t\t\t\"field\": \"labels\",\r\n\t\t\t\"value\": \"\"\r\n\t\t},\r\n\t\t{\r\n\t\t\t\"field\": \"repo_path\",\r\n\t\t\t\"value\": \"mindspore\"\r\n\t\t}\r\n\t],\r\n    \"created_at\": \"2026-01-26 19:35:20\",\r\n\t\"created_after\": \"2025-03-02 11:00:00\",\r\n    \"created_before\": \"\",\r\n    \"updated_after\": \"\",\r\n    \"updated_before\": \"\",\r\n\t\"sort\": \"created_at\",\r\n\t\"direction\": \"desc\"\r\n}",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1775619600225,\n    \"executeTime\": 38\n}",
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
      "name" : "filters",
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
          "name" : "field",
          "value" : "milestone",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pattern",
          "error" : "filter.field 只能为 milestone、assignee、labels、repo_path、state、type、priority、code_platform、severity、number",
          "expression" : "^(milestone|assignee|labels|repo_path|state|type|priority|code_platform|severity|number)?$",
          "children" : [ ]
        }, {
          "name" : "value",
          "value" : "null",
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
      "name" : "created_at",
      "value" : "2026-01-26 19:35:20",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "created_at 格式应为 yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
      "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
      "children" : [ ]
    }, {
      "name" : "created_after",
      "value" : "2025-03-02 11:00:00",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "created_after 格式应为 yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
      "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
      "children" : [ ]
    }, {
      "name" : "created_before",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "created_before 格式应为 yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
      "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
      "children" : [ ]
    }, {
      "name" : "updated_after",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "updated_after 格式应为 yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
      "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
      "children" : [ ]
    }, {
      "name" : "updated_before",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "updated_before 格式应为 yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
      "expression" : "^(\\d{4}-\\d{2}-\\d{2}( \\d{2}:\\d{2}:\\d{2})?)?$",
      "children" : [ ]
    }, {
      "name" : "sort",
      "value" : "created_at",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "created_at",
      "validateType" : "pattern",
      "error" : "sort 只能为 created_at、updated_at",
      "expression" : "^(created_at|updated_at)$",
      "children" : [ ]
    }, {
      "name" : "direction",
      "value" : "desc",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "desc",
      "validateType" : "pattern",
      "error" : "direction 只能为 asc 或 desc",
      "expression" : "^(asc|desc|ASC|DESC)$",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var off = (page - 1) * page_size
var filters = body.filters
var table_name = `fact_${community}_issue`
// 查询数据表列名（用于 SELECT 子句）
var col_query = """
    SELECT string_agg(column_name, ', ' ORDER BY ordinal_position) FILTER (
        WHERE column_name NOT IN ('uuid', 'url', 'assignees_user_ids', 'assignees_user_names', 'labels_id', 'labels_name', 'comment_ids', 'comment_logins', 'refresh_comment', 'is_hide', 'is_removed')
        ) AS columns
    FROM information_schema.columns
    WHERE table_name = #{table_name}
"""
var columns = db.select(col_query)[0]['columns']
//  created_at 的完整时间戳在服务端拼接，避免用户控制 SQL 片段（格式校验已在 requestBodyDefinition 完成）
var created_at_full = not_blank(body.created_at) ? (body.created_at + ".000 +0800") : null
// Issue自定义字段名筛选（custom_field 已通过 #{} 参数化，安全）
var custom_query = ""
var custom_condition = ""
if (not_blank(body.custom_field)) {
    custom_query = """
        CROSS JOIN LATERAL (
            SELECT jsonb_agg(field_data) as field_list
            FROM jsonb_array_elements(t.custom_fields::jsonb) as field_data
            WHERE field_data->>'field_name' = #{body.custom_field}
        ) as matched_fields
    """
    custom_condition = """matched_fields.field_list IS NOT NULL AND """
}
var sqlstr = """
SELECT
    ${columns},
    TRIM(BOTH '{}' FROM labels_name) as labels_name
FROM
    ${table_name} t
${custom_query}
WHERE
    <if test="filters != null and filters.size() > 0">
        <foreach collection="filters" item="item" separator="AND " open="" close="">
            <if test="item.field == 'milestone' and not_blank(item.value)">
                milestone_json::json->>'title' = #{item.value}
            </if>
            <elseif test="item.field == 'assignee' and not_blank(item.value)">
                assignee_json::json->>'login' = #{item.value}
            </elseif>
            <elseif test="item.field == 'labels' and not_blank(item.value)">
                #{item.value} = ANY(string_to_array(trim('{}' FROM labels_name), ','))
            </elseif>
            <elseif test="not_blank(item.value)">
                ${item.field} = #{item.value}
            </elseif>
            <else>
                1 = 1
            </else>
        </foreach>
        AND
    </if>
    <if test="not_blank(body.created_after)">
        created_at >= #{body.created_after}::timestamptz AND
    </if>
    <if test="not_blank(body.created_before)">
        created_at < #{body.created_before}::timestamptz AND
    </if>
    <if test="not_blank(body.updated_after)">
        updated_at >= #{body.updated_after}::timestamptz AND
    </if>
    <if test="not_blank(body.updated_before)">
        updated_at < #{body.updated_before}::timestamptz AND
    </if>
    <if test="not_blank(created_at_full)">
        created_at = #{created_at_full}::timestamptz AND
    </if>
    <if test="not_blank(body.kanban_name)">
        kanban_values_json @> jsonb_build_array(jsonb_build_object('name', #{body.kanban_name}::text)) AND
    </if>
    ${custom_condition}
    is_hide is null and is_removed is null
ORDER BY ${body.sort} ${body.direction}
LIMIT #{page_size} OFFSET #{off}
"""
var resp = db.select(sqlstr)
// Json格式转换
for (it in resp) {
    for (key, value in it) {
        if (key.contains("_json") || key == "custom_fields") {
            it[key] = key == 'kanban_values_json' && value != null ? value.value::json : value::json
        }
    }
}
return resp

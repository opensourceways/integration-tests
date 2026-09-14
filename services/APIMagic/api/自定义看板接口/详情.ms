{
  "properties" : { },
  "id" : "c62aa06761394844b4cb2932d524541e",
  "script" : null,
  "groupId" : "12d952eea410421d80e54b1a53bcd3cf",
  "name" : "详情",
  "createTime" : null,
  "updateTime" : 1775618760157,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{community}/detail",
  "method" : "POST",
  "parameters" : [ {
    "name" : "page",
    "value" : "1",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page > 0 && page <= 1000",
    "children" : null
  }, {
    "name" : "page_size",
    "value" : "10",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "10",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page_size > 0 && page_size <= 1000",
    "children" : null
  } ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatadmin,mcp",
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
  "requestBody" : "{\r\n\t\"community\": \"mindspore\",\r\n    \"dim\": [\"uuid\",\"title\",\"url\",\"status\"],\r\n\t\"name\": \"fact_openubmc_forum_topic\",\r\n\t\"page\": 1,\r\n\t\"page_size\": 20,\r\n\t\"filters\": [\r\n\t\t{\r\n\t\t\t\"column\": \"uuid\",\r\n\t\t\t\"operator\": \">\",\r\n\t\t\t\"value\": \"3627\"\r\n\t\t}\r\n\t],\r\n\t\"conditonsLogic\": \"AND\",\r\n\t\"order_field\": \"uuid\",\r\n\t\"order_dir\": \"ASC\",\r\n\t\"start\": 1577836800000,\r\n\t\"end\": 1750823224005\r\n}",
  "headers" : [ ],
  "paths" : [ {
    "name" : "community",
    "value" : "opengauss",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 401,\n    \"message\": \"用户未登录\",\n    \"data\": null,\n    \"timestamp\": 1774593680227,\n    \"executeTime\": null\n}",
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
      "value" : "mindspore",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "dim",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z_][a-zA-Z0-9_]*$",
      "children" : [ {
        "name" : "",
        "value" : "uuid",
        "description" : "",
        "required" : false,
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "pattern",
        "error" : "",
        "expression" : "^[a-zA-Z_][a-zA-Z0-9_]*$",
        "children" : [ ]
      } ]
    }, {
      "name" : "name",
      "value" : "fact_opengauss_email",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z_]{1,64}$",
      "children" : [ ]
    }, {
      "name" : "page",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "page > 0 && page <= 1000",
      "children" : [ ]
    }, {
      "name" : "page_size",
      "value" : "20",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "page_size > 0 && page_size <= 1000",
      "children" : [ ]
    }, {
      "name" : "filters",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z_][a-zA-Z0-9_]*$",
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
          "name" : "column",
          "value" : "created_at",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pattern",
          "error" : "",
          "expression" : "^[a-zA-Z_][a-zA-Z0-9_]*$",
          "children" : [ ]
        }, {
          "name" : "operator",
          "value" : ">",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pattern",
          "error" : "",
          "expression" : "^(=|>|<|>=|<=|<>|like|left_like|right_like|in|is)$",
          "children" : [ ]
        }, {
          "name" : "value",
          "value" : "2025-01-01 00:00:00",
          "description" : "",
          "required" : false,
          "dataType" : "Any",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pattern",
          "error" : "",
          "expression" : "^.{0,500}$",
          "children" : [ ]
        } ]
      } ]
    }, {
      "name" : "conditonsLogic",
      "value" : "AND",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(AND|OR)$",
      "children" : [ ]
    }, {
      "name" : "order_field",
      "value" : "uuid",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z_][a-zA-Z0-9_]*$",
      "children" : [ ]
    }, {
      "name" : "order_dir",
      "value" : "ASC",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(ASC|DESC)$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "1577836800000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1750823224005",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "",
      "expression" : null,
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
          "value" : "ai.opengauss.org_3755",
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
      "name" : "timestamp",
      "value" : "1751246871139",
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
      "value" : "26",
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
var dim = body.dim
var name = body.name
var filters = body.filters
var field = body.order_field
var order = body.order_dir
var start= body.start
var end = body.end
const pattern = /^dws_[a-z]+_contribute$/;
var is_dws = pattern.test(name)? true : false
var query = """SELECT string_agg(column_name, ', ' ORDER BY ordinal_position) FILTER (WHERE column_name not IN ('uuid')) AS columns FROM information_schema.columns WHERE table_name = #{name}"""
if (is_dws) {
    query = """SELECT string_agg(column_name, ', ' ORDER BY ordinal_position) FILTER (WHERE column_name not IN ('sig_name','ai_code_type', 'is_pr', 'is_issue', 'is_comment', 'uuid')) AS columns FROM information_schema.columns WHERE table_name = #{name}"""
}
var columns = db.select(query)[0]['columns']
var sqlstr = """
SELECT
    <if test="dim != null and dim.size() > 0">
        <foreach collection="dim" item="item" separator="," open="" close="">
            <if test="item == 'sig_name' and is_dws == true">
                to_json(sig_name) as sig_name
            </if>
            <if test="item != 'sig_name'">
                ${item}
            </if>
        </foreach>
    </if>
    <if test="dim == null or dim.size() == 0">
        ${columns}
        <if test="is_dws == true">
           , to_json(sig_name) as sig_name
        </if>
    </if>
FROM 
    ${name}
WHERE
    <if test="filters != null and filters.size() > 0">
        <foreach collection="filters" item="item" separator="AND " open="" close="">
            <if test="item.column == 'sig_name' and is_dws == true and item.operator == '='">
                #{item.value} = ANY(${item.column})
            </if>
            <if test="item.column == 'sig_name' and is_dws == true and item.operator == '<>'">
                #{item.value} <> ALL(${item.column})
            </if>
            <else>
                <if test="item.operator == 'like'">
                    ${item.column} like '%' || #{item.value} || '%'
                </if>
                <if test="item.operator == 'left_like'">
                    ${item.column} like #{item.value} || '%'
                </if>
                <if test="item.operator == 'right_like'">
                    ${item.column} like '%' || #{item.value}
                </if>
                <if test="item.operator == '=' or item.operator == '<>' or item.operator == '>=' or item.operator == '<=' or item.operator == '>' or item.operator == '<'">
                    <if test="item.column == 'created_at' or item.column == 'merged_at' or item.column == 'updated_at' or item.column == 'closed_at' or item.column == 'date'">
                        ${item.column} ${item.operator} #{item.value}::timestamptz
                    </if>
                    <elseif test="item.value.matches('\\d+')">
                        ${item.column} ${item.operator} #{item.value}::int
                    </elseif>
                    <else>
                        ${item.column} ${item.operator} #{item.value}
                    </else>
                </if>
                <if test="item.operator == 'in' and item.value != null">
                    ${item.column} ${item.operator}
                    <foreach collection="item.value.split(',')" item="tmp" open="(" separator="," close=")">
                        #{tmp}
                    </foreach>
                </if>
                <if test="item.operator == 'is'">
                    ${item.column} is #{item.value}
                </if>
            </else>
        </foreach>
        AND
    </if>
    <if test="start != null and start != ''">
        created_at >= to_timestamp(#{start}/1000) AND 
    </if>
    <if test="end != null and end != ''">
        created_at < to_timestamp(#{end}/1000) AND 
    </if>
    <if test="name != null and is_dws == true">
        is_hide is null and is_removed is null and
    </if>
    1=1
ORDER BY ${field} ${order}
LIMIT #{page_size} OFFSET #{off};
"""
var resp = db.select(sqlstr)
for (it in resp) {
    if (it.containsKey("sig_name") and is_dws == true) {
        it['sig_name'] = it.sig_name.value::json
    }
}
return resp

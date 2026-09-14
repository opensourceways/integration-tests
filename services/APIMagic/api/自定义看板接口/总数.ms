{
  "properties" : { },
  "id" : "9556ea495bd84351b5c0a6c920bbf450",
  "script" : null,
  "groupId" : "12d952eea410421d80e54b1a53bcd3cf",
  "name" : "总数",
  "createTime" : null,
  "updateTime" : 1774603940714,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/total",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastatadmin_View",
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
  "requestBody" : "{\r\n    \"community\": \"openubmc\",\r\n    \"dim\": [],\r\n    \"name\": \"dws_openubmc_forum_week\",\r\n    \"page\": 1,\r\n    \"page_size\": 20,\r\n    \"filters\": [\r\n        {\r\n            \"column\": \"solved_count\",\r\n            \"operator\": \">\",\r\n            \"value\": \"10\"\r\n        }\r\n    ],\r\n    \"conditonsLogic\": \"AND\",\r\n    \"order_field\": \"uuid\",\r\n    \"order_dir\": \"ASC\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 401,\n    \"message\": \"用户未登录\",\n    \"data\": null,\n    \"timestamp\": 1774420601565,\n    \"executeTime\": null\n}",
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
      "name" : "name",
      "value" : "dws_openubmc_contribute",
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
          "value" : "is_issue",
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
          "value" : "=",
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
          "value" : "1",
          "description" : "",
          "required" : false,
          "dataType" : "Any",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pass",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        } ]
      } ]
    }, {
      "name" : "start",
      "value" : "",
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
      "value" : "",
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
  "responseBodyDefinition" : null
}
================================
var name = body.name
var filters = body.filters
var start= body.start
var end = body.end
const pattern = /^dws_[a-z]+_contribute$/;
var is_dws = pattern.test(name)? true : false
var sqlstr = """
SELECT count(1)
FROM ${name}
WHERE
    <if test="filters != null and filters.size() > 0">
        <foreach collection="filters" item="item" separator="AND " open="" close="">
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
        is_hide is null and is_removed is null AND
    </if>
    1 = 1
"""
var resp = db.select(sqlstr)[0]
return resp

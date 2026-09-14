{
  "properties" : { },
  "id" : "copy1745506310457d18777",
  "script" : null,
  "groupId" : "709908d8728741d19dd2d28b98d0e23a",
  "name" : "Dict总数",
  "createTime" : null,
  "updateTime" : 1774421289617,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/total",
  "method" : "POST",
  "parameters" : [ {
    "name" : "metric",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z0-9_]{0,32}$",
    "children" : null
  } ],
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
  "requestBody" : "{\r\n\r\n\"filters\": [{\"column\": \"user_login\", \"operator\": \"=\", \"value\": \"zck19950826\"}],\r\n    \"name\": \"dws_openubmc_contribute\",\r\n    \"order_field\": \"name\",\r\n    \"order_dir\": \"asc\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"count\": 211\n    },\n    \"timestamp\": 1745507651806,\n    \"executeTime\": null\n}",
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
          "name" : "column",
          "value" : "",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pattern",
          "error" : null,
          "expression" : "^(id|name|name_zh|definition|scope|areasofuse_zh|areasofuse_en|update_time)$",
          "children" : [ ]
        }, {
          "name" : "operator",
          "value" : "",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pattern",
          "error" : null,
          "expression" : "^(=|>=|<=|>|<|like|left_like|right_like|in)$",
          "children" : [ ]
        }, {
          "name" : "value",
          "value" : "",
          "description" : "",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "pattern",
          "error" : null,
          "expression" : "^[a-zA-Z0-9_@.-]{0,100}$",
          "children" : [ ]
        } ]
      } ]
    }, {
      "name" : "name",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^[a-zA-Z0-9_]{1,64}$",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var name = body.name
var filters = body.filters
var sqlstr = """
SELECT count(1)
FROM dws_metrics_dims_define_detail
    <if test="filters != null and filters.size() > 0">
    WHERE
        <foreach collection="filters" item="item" separator="AND " open="" close="">
            <if test="item.operator == 'like'">
                ${item.column} like '%' || #{item.value} || '%'
            </if>
            <elseif test="item.operator == 'left_like'">
                ${item.column} like #{item.value} || '%'
            </elseif>
            <elseif test="item.operator == 'right_like'">
                ${item.column} like '%' || #{item.value}
            </elseif>
            <elseif test="item.operator == 'in'">
                ${item.column} ${item.operator}
                <foreach collection="item.value" item="tmp" open="(" separator="," close=")">
                    #{tmp}
                </foreach>
            </elseif>
            <else>
                ${item.column} ${item.operator} #{item.value}
            </else>
        </foreach>
    </if>
"""
var resp = db.select(sqlstr)[0]
return resp

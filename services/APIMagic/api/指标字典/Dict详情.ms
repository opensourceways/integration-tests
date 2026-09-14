{
  "properties" : { },
  "id" : "copy1745506923208d49620",
  "script" : null,
  "groupId" : "709908d8728741d19dd2d28b98d0e23a",
  "name" : "Dict详情",
  "createTime" : null,
  "updateTime" : 1774577125359,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/detail",
  "method" : "POST",
  "parameters" : [ {
    "name" : "page",
    "value" : "1",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "expression",
    "error" : null,
    "expression" : "page > 0 && page <= 1000",
    "children" : null
  }, {
    "name" : "page_size",
    "value" : "20",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "expression",
    "error" : null,
    "expression" : "page_size > 0 && page_size <= 100",
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
  "requestBody" : "{\r\n    \"dim\": [],\r\n    \"filters\":[{\"column\": \"name\", \"operator\": \"=\", \"value\": \"emailsdimension\"}],\r\n    \"name\": \"dws_metrics_dims_define_detail\",\r\n    \"order_field\": \"name\",\r\n    \"order_dir\": \"asc\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [],\n    \"timestamp\": 1745507557745,\n    \"executeTime\": 6\n}",
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
      "name" : "dim",
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
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "pattern",
        "error" : null,
        "expression" : "^(id|name|name_zh|definition|scope|areasofuse_zh|areasofuse_en|update_time)$",
        "children" : [ ]
      } ]
    }, {
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
    }, {
      "name" : "order_field",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(id|name|name_zh|definition|scope|areasofuse_zh|areasofuse_en|update_time)?$",
      "children" : [ ]
    }, {
      "name" : "order_dir",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^(asc|desc|ASC|DESC)?$",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
var off = (page - 1) * page_size
var dim = body.dim
var name = body.name
var filters = body.filters
var field = body.order_field
var order = body.order_dir
var sqlstr = """
SELECT
    <if test="dim != null and dim.size() > 0">
        <foreach collection="dim" item="item" separator="," open="" close="">
            ${item}
        </foreach>
    </if>
    <if test="dim == null or dim.size() == 0">
        *
    </if>
FROM 
    dws_metrics_dims_define_detail
    <if test="filters != null and filters.size() > 0">
    WHERE
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
            <if test="item.operator == '=' or item.operator == '>=' or item.operator == '<=' or item.operator == '>' or item.operator == '<'">
                ${item.column} ${item.operator} #{item.value}
            </if>
            <if test="item.operator == 'in'">
                ${item.column} ${item.operator}
                <foreach collection="item.value" item="tmp" open="(" separator="," close=")">
                    #{tmp}
                </foreach>
            </if>
        </foreach>
    </if>
ORDER BY ${field} ${order}
LIMIT #{page_size} OFFSET #{off};
"""
var resp = db.select(sqlstr)
return resp

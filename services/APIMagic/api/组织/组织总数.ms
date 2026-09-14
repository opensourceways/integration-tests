{
  "properties" : { },
  "id" : "58f040d40b874864a78814b689bdcbc3",
  "script" : null,
  "groupId" : "52cb0a20ea9c4250922978c291cee58e",
  "name" : "组织总数",
  "createTime" : null,
  "updateTime" : 1747619606820,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/totalCount",
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
  "requestBody" : "{\r\n    \"start\":1659327200000,\r\n    \"end\":1741746039990,\r\n    \"orgList\":[\"opengauss\"],\r\n    \"internalList\":[],\r\n    \"community\":\"opengauss\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"total\": 5\n    }],\n    \"timestamp\": 1747619580889,\n    \"executeTime\": null\n}",
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
      "name" : "start",
      "value" : "1559327200000",
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
      "name" : "end",
      "value" : "1741746039990",
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
      "name" : "orgList",
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
      } ]
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
      "children" : [ {
        "name" : "",
        "value" : "内部",
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
    }, {
      "name" : "community",
      "value" : "openubmc",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}

================================
// 服务平台
var source = body.source;
// 是否私仓
var private = body.private;
// 组织
var orgList = body.orgList; 
// 贡献类型：pr,issue,comment
var eventList = body.eventList;
// 统计周期：daily-天，week-周，month-月
var interval = body.interval;
// 社区
var community = body.community.toLowerCase();
var contributeTable = "dwm_" + community + "_company";
var sql = """
select 
"count"(DISTINCT company_type) as total,
"count"(DISTINCT company) as company_total
from ${contributeTable}
<where>
    (is_hide is null)
    <if test="private != null and private != ''">
        and private = #{private}
    </if>
    <if test="orgList != null and orgList.size() > 0">
        and namespace in
        <foreach collection="orgList" item="item" open="(" separator="," close=")">
            #{item}
        </foreach>
    </if>
</where>
""";
return db.select(sql)

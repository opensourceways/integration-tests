{
  "properties" : { },
  "id" : "e36edf1a108b419cbc44a9215f590b4d",
  "script" : null,
  "groupId" : "a722ad28731b4662827d7142c054a3d7",
  "name" : "prissue贡献详情",
  "createTime" : null,
  "updateTime" : 1778550012905,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{contributeType}/detail",
  "method" : "GET",
  "parameters" : [ {
    "name" : "user",
    "value" : "fundawang",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "user 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]+$",
    "children" : null
  }, {
    "name" : "page",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : "page 必须大于 0",
    "expression" : "page > 0",
    "children" : null
  }, {
    "name" : "pageSize",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "10",
    "validateType" : "expression",
    "error" : "pageSize 必须在 1-100 之间",
    "expression" : "pageSize > 0 && pageSize <= 100",
    "children" : null
  }, {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^(openeuler|opengauss|mindspore|openubmc|openfuyao)$",
    "children" : null
  }, {
    "name" : "sig",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "sig 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "timeRange",
    "value" : "lastonemonth",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "all",
    "validateType" : "pattern",
    "error" : "timeRange 参数非法",
    "expression" : "^(all|lastonemonth|lasthalfyear|lastoneyear)?$",
    "children" : null
  }, {
    "name" : "filter",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "filter 格式非法",
    "expression" : "",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ {
    "name" : "contributeType",
    "value" : "issue",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "contributeType 参数非法",
    "expression" : "^(issue|pr)$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"info\": \"CVE-2026-6210\",\n        \"repo\": \"src-openeuler/qt6-qtsvg\",\n        \"time\": \"2026-05-07 00:17:43\",\n        \"url\": \"https://gitcode.com/src-openeuler/qt6-qtsvg/issues/8\",\n        \"no\": \"8\"\n    }],\n    \"timestamp\": 1778550001496,\n    \"executeTime\": 46\n}",
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
      "value" : "-1",
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
      "value" : "系统内部出现错误",
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
      "name" : "timestamp",
      "value" : "1778549940876",
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
filter = filter != null ? filter.toLowerCase() : filter
var off = (page - 1) * pageSize
if (timeRange == 'lastonemonth') {
    timeRange = '1 months'
} else if (timeRange == 'lastoneyear') {
    timeRange = '1 years'
} else if (timeRange == 'lasthalfyear') {
    timeRange = '6 months'
}
var time_field = contributeType == 'pr' ? 'merged_at' : 'created_at'
var sqlstr = """
SELECT title as info,
       CONCAT(namespace,'/',repo_path) as repo,
       ${time_field} as time,
       html_url as url,
       split_part(html_url , '/', -1) as no
FROM dws_${community}_contribute
WHERE
    user_login = #{user} AND contrib_type=#{contributeType}
        <if test="contributeType == 'pr'">
            AND state = 'merged'
        </if>
        <if test="sig != null and sig != ''">
            AND #{sig} = ANY(sig_name)
        </if>
        <if test="timeRange != 'all' and timeRange != null">
            AND ${time_field} >= (CURRENT_DATE - #{timeRange}::interval) AT TIME ZONE 'Asia/Shanghai'
        </if>
        <if test="filter != '' and filter != null">
            AND lower(title) like concat('%',#{filter},'%')
        </if>
        AND is_removed IS NULL
ORDER BY ${time_field} desc
LIMIT #{pageSize} OFFSET #{off};
"""
var resp = db.select(sqlstr)
return resp

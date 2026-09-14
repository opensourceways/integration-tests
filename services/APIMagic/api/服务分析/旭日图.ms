{
  "properties" : { },
  "id" : "436a7e1ac3bb41b1aef3e6474dd7d307",
  "script" : null,
  "groupId" : "88106ac6415b4414a1298660a1768d34",
  "name" : "旭日图",
  "createTime" : null,
  "updateTime" : 1774579092059,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/sunburst",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"community\": \"openubmc\",\r\n    \"service\": \"\",\r\n    \"metric\": \"visit_time\",\r\n    \"start\": 1729017600000,\r\n    \"end\": 1759017600000\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1774579058679,\n    \"executeTime\": 4\n}",
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
      "value" : "openeuler",
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
      "name" : "metric",
      "value" : "visit_time",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^(stay_time|visit_time)$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "1739017600000",
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
      "value" : "1759017600000",
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
var coefficient = body.metric == "stay_time" ? 3600.0 : 1
var position = body.metric == "stay_time" ? 2 : 0
var sql = """
SELECT 
    service,
    module,
    ROUND(coalesce(sum(${body.metric}), 0) / ${coefficient}, ${position}) AS value
FROM dws_${body.community}_module_time_day
WHERE 1 = 1
        <if test="type == 'module' and body.service != null and body.service != ''">
            AND service = #{body.service}
        </if>
        <if test="body.start != null">
            AND date >= date_trunc('day', to_timestamp(#{body.start}/1000)::DATE)::DATE
        </if>
        <if test="body.end != null">
            AND date <= date_trunc('day', to_timestamp(#{body.end}/1000)::DATE)::DATE
        </if>
GROUP BY service, module
ORDER BY service, value desc;
"""
data = db.select(sql).group(it => it.service,list => list.each(it => it.remove("service")))
return data

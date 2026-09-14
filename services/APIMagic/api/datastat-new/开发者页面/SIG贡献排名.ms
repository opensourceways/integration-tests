{
  "properties" : { },
  "id" : "d3ce3e6347fe4a9ead21058a8234f551",
  "script" : null,
  "groupId" : "3a27e930d2934b3e99edef7ee1dee30a",
  "name" : "SIG贡献排名",
  "createTime" : null,
  "updateTime" : 1774947244515,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/sigcontribute",
  "method" : "GET",
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
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "contributeType",
    "value" : "pr",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(pr|issue|comment)$",
    "children" : null
  }, {
    "name" : "user",
    "value" : "mao_0v0",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "start",
    "value" : "1756656000000",
    "description" : null,
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
    "value" : "1758211200000",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"sig_name\": \"sig-hardware\",\n        \"contribute\": 6,\n        \"rank\": 1,\n        \"percent\": 0.6000\n    }, {\n        \"sig_name\": \"sig-component-drivers\",\n        \"contribute\": 3,\n        \"rank\": 2,\n        \"percent\": 0.3000\n    }, {\n        \"sig_name\": \"sig-interface\",\n        \"contribute\": 1,\n        \"rank\": 3,\n        \"percent\": 0.1000\n    }],\n    \"timestamp\": 1759109360601,\n    \"executeTime\": 95\n}",
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
          "name" : "sig_name",
          "value" : "AI",
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
          "name" : "contribute",
          "value" : "43",
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
          "name" : "rank",
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
          "name" : "percent",
          "value" : "0.8269",
          "description" : "",
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
      "value" : "1745304224520",
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
      "value" : "15",
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
contributeType = contributeType.toLowerCase()
sum_field = contributeType == 'pr' ? `merged_pr_incre` : `${contributeType}_incre`
var sql = """
select
    sig_name, 
    sum(${sum_field}) as contribute ,
    ROW_NUMBER() OVER (ORDER BY sum(${sum_field}) DESC) AS rank,
    ROUND(sum(${sum_field}) / sum(sum(${sum_field})) OVER (), 4) AS percent
from dws_${community}_contribute_sig_user_daily 
where 1 = 1
    <if test="user != null and user != ''">
        AND user_login = #{user}
    </if>
    <if test="start != null and start != ''">
        AND date >= to_timestamp(#{start}/1000)
    </if>
    <if test="end != null and end != ''">
        AND date <= to_timestamp(#{end}/1000)
    </if>
group by sig_name
having sum(${sum_field}) > 0
order by contribute desc;
"""
var resp = db.select(sql)
return resp    

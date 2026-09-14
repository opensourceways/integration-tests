{
  "properties" : { },
  "id" : "a839f1df859f4a3580640121c3338f35",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "审核时间",
  "createTime" : null,
  "updateTime" : 1773818104875,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/review",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "start 必须为合法的毫秒级时间戳",
    "expression" : "",
    "children" : null
  }, {
    "name" : "end",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "end 必须为合法的毫秒级时间戳",
    "expression" : "",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"code\": \"0-9行\",\n        \"pr_num\": 21402,\n        \"review_time\": 0.7388657407407407\n    }, {\n        \"code\": \"10-59行\",\n        \"pr_num\": 2410,\n        \"review_time\": 1.1616724537037038\n    }, {\n        \"code\": \"60-99行\",\n        \"pr_num\": 684,\n        \"review_time\": 1.6333449074074073\n    }, {\n        \"code\": \"100-499行\",\n        \"pr_num\": 2038,\n        \"review_time\": 2.0451099537037036\n    }, {\n        \"code\": \"500+行\",\n        \"pr_num\": 2504,\n        \"review_time\": 46.505949074074074\n    }],\n    \"timestamp\": 1750819101506,\n    \"executeTime\": 7940\n}",
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
          "name" : "code",
          "value" : "0-9行",
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
          "name" : "pr_num",
          "value" : "45",
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
          "name" : "review_time",
          "value" : "22.82",
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
      "value" : "1750237264688",
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
      "value" : "27",
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
var level = {
    '0': '0-9行',
    '1': '10-59行',
    '2': '60-99行',
    '3': '100-499行',
    '4': '500+行'
}
if (start != null) {
    start = start / 1000
}
if (end != null) {
    end = end / 1000
}
var sqlstr = """
SELECT
    CASE
        WHEN (add + remove) BETWEEN 0 AND 9 THEN '0'
        WHEN (add + remove) BETWEEN 10 AND 59 THEN '1'
        WHEN (add + remove) BETWEEN 60 AND 99 THEN '2'
        WHEN (add + remove) BETWEEN 100 AND 499 THEN '3'
        ELSE '4'
    END AS code,
    COUNT(1) AS pr_num,
    percentile_cont(0.5) 
                   WITHIN GROUP (ORDER BY first_reply_time) AS review_time
FROM dws_${community}_contribute
WHERE 
    contrib_type = 'pr' 
    AND state = 'merged'
    AND is_removed is null
    AND is_hide is null
        <if test="start != null and start != ''">
            AND created_at >= to_timestamp(#{start})
        </if>
        <if test="end != null and end != ''">
            AND created_at < to_timestamp(#{end})
        </if>
GROUP BY code
ORDER BY code;
"""
var result = db.select(sqlstr)
// result.each(it => it['code'] = level[it.code])
for(it in result){
    it['code'] = level[it.code]
    it['review_time']=round(it.review_time/3600/24, 2)
}
return result

{
  "properties" : { },
  "id" : "3df8aa3e9946426c91732783c8ca48b2",
  "script" : null,
  "groupId" : "905e0bee16764ec9be1e96b78cae9466",
  "name" : "批量查询用户邮箱",
  "createTime" : 1787215621936,
  "updateTime" : 1787215621936,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/emails",
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
  }, {
    "name" : "permission",
    "value" : "email_token",
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
  "requestBody" : "{\n    \"user_logins\": [\"dev-01\", \"dev-02\"],\n    \"platform\": \"github\"\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 2,\n        \"results\": [{\n            \"user_login\": \"dev-01\",\n            \"matched\": false,\n            \"emails\": null\n        }, {\n            \"user_login\": \"dev-02\",\n            \"matched\": false,\n            \"emails\": null\n        }]\n    },\n    \"timestamp\": 1787225715408,\n    \"executeTime\": 3\n}",
  "description" : "按 user_login 批量查询贡献者邮箱（白名单接口，permission=email_token）。数据来源 fact_email_login（git commit / gitcode webhook 采集），自动剔除 noreply 代邮箱；单次最多 200 个 login，未命中的返回 matched=false。",
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
      "name" : "user_logins",
      "value" : "",
      "description" : "user_login 列表，1~200 个，脚本内自动去重",
      "required" : true,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "",
        "value" : "dev-01",
        "description" : "github/gitcode 账号名",
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
      "name" : "platform",
      "value" : "github",
      "description" : "",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : {
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
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "total",
        "value" : "2",
        "description" : "去重后查询的 user_login 总数",
        "required" : false,
        "dataType" : "Integer",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      }, {
        "name" : "results",
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
            "name" : "user_login",
            "value" : "dev-01",
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
            "name" : "matched",
            "value" : "true",
            "description" : "是否匹配到有效邮箱",
            "required" : false,
            "dataType" : "Boolean",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "emails",
            "value" : "[\"dev01@example.com\"]",
            "description" : "有效邮箱列表；未匹配时为 null",
            "required" : false,
            "dataType" : "Array",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ {
              "name" : "",
              "value" : "dev01@example.com",
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
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1787215621936",
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
      "value" : null,
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
import response;
var MAX_BATCH = 200;
var user_logins = body.user_logins;

if (user_logins.size() > MAX_BATCH) {
    return response.json({code: -1, message: 'user_logins 单次最多 ' + MAX_BATCH + ' 个'});
}

var sqlstr = """
SELECT user_login, array_agg(DISTINCT email ORDER BY email) AS emails
FROM fact_email_login
WHERE user_login IN
    <foreach collection="user_logins" item="item" open="(" close=")" separator=",">
        #{item}
    </foreach>
    AND code_platform = #{body.platform}
    AND email IS NOT NULL
    AND email <> ''
    AND email NOT LIKE '%noreply.%'
GROUP BY user_login
"""
var rows = db.select(sqlstr);

var emailMap = new HashMap();
for (index, row in rows) {
    emailMap.put(row.get("user_login"), row.get("emails").getArray());
}
var results = [];
for (index, login in user_logins) {
    var emails = emailMap.get(login);
    if (emails != null) {
        results.add({user_login: login, matched: true, emails: emails});
    } else {
        results.add({user_login: login, matched: false, emails: null});
    }
}
return {total: results.size(), results: results}
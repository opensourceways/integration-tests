{
  "properties" : { },
  "id" : "685995ee256d4ce3aeb57111cb5d1c4d",
  "script" : null,
  "groupId" : "3d75a6c492184d51afba938d34338c98",
  "name" : "分支详情",
  "createTime" : null,
  "updateTime" : 1778726983478,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/versions",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^openeuler$",
    "children" : null
  }, {
    "name" : "pageSize",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "10",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "page",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "repo",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"src-openeuler/a52dec\": [{\n            \"brname\": \"openEuler-25.03\",\n            \"summary\": \"Small test program for liba52\",\n            \"version\": \"0.7.4\",\n            \"description\": null,\n            \"package_name\": \"a52dec\"\n        }, {\n            \"brname\": \"openEuler-25.09\",\n            \"summary\": \"Small test program for liba52\",\n            \"version\": \"0.7.4\",\n            \"description\": null,\n            \"package_name\": \"a52dec\"\n        }, {\n            \"brname\": \"master\",\n            \"summary\": \"Small test program for liba52\",\n            \"version\": \"0.7.4\",\n            \"description\": null,\n            \"package_name\": \"a52dec\"\n        }]\n    }],\n    \"timestamp\": 1778726966474,\n    \"executeTime\": 1250\n}",
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
          "name" : "src-openeuler/a52dec",
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
              "name" : "brname",
              "value" : "openEuler-25.03",
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
              "name" : "summary",
              "value" : "Small test program for liba52",
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
              "name" : "version",
              "value" : "0.7.4",
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
              "name" : "description",
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
              "name" : "package_name",
              "value" : "a52dec",
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
      "value" : "1778726966474",
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
      "value" : "1250",
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
var off = (page - 1) * pageSize

var repo_path = if repo == null ? null : repo.split("/")[1]
var sqlstr = """
SELECT
    repo_path,
    jsonb_agg(
	        jsonb_build_object(
	            'package_name', package_name,
	            'brname', branch,
                'version', version,
	            'summary', summary,
	            'description', description
	        )
    ) AS branch_detail
FROM
    fact_${community}_package_version
WHERE 1 = 1
        <if test="repo != null and repo != ''">
            AND repo_path = #{repo_path}
        </if>
GROUP BY repo_path
ORDER BY repo_path asc
LIMIT #{pageSize} OFFSET #{off};
"""
var result = db.select(sqlstr)
var resp = []
for (re in result){
    var item = {}
    var key = 'src-openeuler/' + re['repo_path']
    item[key] = re['branch_detail'].getValue()::json
    resp.add(item)
}
return resp

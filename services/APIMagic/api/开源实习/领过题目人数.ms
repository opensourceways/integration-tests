{
  "properties" : { },
  "id" : "ef05dad0e89a44c7a0fcf4c58d4ba95e",
  "script" : null,
  "groupId" : "9b8fc487d76946a88319e081fa47f446",
  "name" : "领过题目人数",
  "createTime" : null,
  "updateTime" : 1773022557665,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/got/issue",
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
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"assign_user\": \"xubiang2024\",\n        \"count\": 5\n    }, {\n        \"assign_user\": \"haohan2\",\n        \"count\": 4\n    }, {\n        \"assign_user\": \"phyknife\",\n        \"count\": 4\n    }, {\n        \"assign_user\": \"hongyao2\",\n        \"count\": 3\n    }, {\n        \"assign_user\": \"jaleshaw\",\n        \"count\": 3\n    }, {\n        \"assign_user\": \"liuhaopeng2024\",\n        \"count\": 3\n    }, {\n        \"assign_user\": \"muchangqing2025\",\n        \"count\": 3\n    }, {\n        \"assign_user\": \"zhilei2023\",\n        \"count\": 2\n    }, {\n        \"assign_user\": \"yangwentong2024\",\n        \"count\": 2\n    }, {\n        \"assign_user\": \"yansixu2025\",\n        \"count\": 2\n    }, {\n        \"assign_user\": \"guocheng2025\",\n        \"count\": 2\n    }, {\n        \"assign_user\": \"zhanghongpeng2025\",\n        \"count\": 2\n    }, {\n        \"assign_user\": \"zhangjunbin2024\",\n        \"count\": 2\n    }, {\n        \"assign_user\": \"huaiyi2024\",\n        \"count\": 2\n    }, {\n        \"assign_user\": \"heenhui2025\",\n        \"count\": 2\n    }, {\n        \"assign_user\": \"linguantao2024\",\n        \"count\": 2\n    }, {\n        \"assign_user\": \"yuyichen2025\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"zhaorunqi\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"caixiaojie2024\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"zhuhanbing1\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"chenkuncan2025\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"chensiwei2025\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"fangchenhao2024\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"gaoxinglei\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"hengji2023\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"lijinsong2025\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"linwei2025\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"liujiacheng_2026\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"nieyipeng2025\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"sunyuhang2025\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"weichunzhen2024\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"weiyifan2024\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"wurunpei\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"xieda2025\",\n        \"count\": 1\n    }, {\n        \"assign_user\": \"xubo3006\",\n        \"count\": 1\n    }],\n    \"timestamp\": 1773022542575,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var community_tem = community
var sql = """select assign_user,count(distinct html_url) as count  from  fact_${community_tem}_practice
 where assign_user is not null group by assign_user ORDER BY count  """
return db.select(sql)

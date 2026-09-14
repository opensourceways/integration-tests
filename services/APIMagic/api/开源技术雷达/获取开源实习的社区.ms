{
  "properties" : { },
  "id" : "5b6902487ea94d44b5817d685e3e2e2f",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "获取开源实习的社区",
  "createTime" : null,
  "updateTime" : 1775025100608,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/community/dict",
  "method" : "GET",
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"key\": \"openEuler\",\n        \"value\": \"openeuler\",\n        \"label\": \"openEuler\"\n    }, {\n        \"key\": \"MindSpore\",\n        \"value\": \"mindspore\",\n        \"label\": \"MindSpore\"\n    }, {\n        \"key\": \"vllm\",\n        \"value\": \"vllm\",\n        \"label\": \"vllm\"\n    }],\n    \"timestamp\": 1773021245083,\n    \"executeTime\": 3\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
    js = [
        {"key": "openEuler", "value": "openeuler","label":"openEuler"},
        {"key": "MindSpore", "value": "mindspore","label":"MindSpore"},
        {"key": "vllm", "value": "vllm","label":"vllm"},
        {"key": "PyTorch", "value": "pytorch","label":"PyTorch"},
        {"key": "AscendNPU-IR", "value": "ascendnpuir","label":"AscendNPU-IR"},
        {"key": "openUBMC", "value": "openubmc","label":"openUBMC"},
        ]
    return js;

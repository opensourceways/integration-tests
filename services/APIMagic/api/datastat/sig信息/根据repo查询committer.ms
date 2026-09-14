{
  "properties" : { },
  "id" : "78bf254587cd483b8a25ea5c41ad298c",
  "script" : null,
  "groupId" : "b5afacecc6d04e3799ee923b67f74047",
  "name" : "根据repo查询committer",
  "createTime" : null,
  "updateTime" : 1774342293965,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/sig/user",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "Ascend",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openeuler",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "ascend|Ascend|CANN|openeuler|openubmc|openfuayo|opengauss|openUBMC|openGauss|openEuler|cann|openFuyao|openfuyao|mindspore|MindSpore|BoostKit|boostkit|openLiBing|openlibing",
    "children" : null
  }, {
    "name" : "repo",
    "value" : "Ascend/Triton-distributed-ascend",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openeuler/virtCCA_driver",
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "branch",
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
  }, {
    "name" : "role",
    "value" : "committer",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "committer",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "committer|maintainer|reviewer|",
    "children" : null
  }, {
    "name" : "level",
    "value" : "repo",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "repo",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "repo_entry|branch_entry|branch|repo|sig",
    "children" : null
  }, {
    "name" : "project_name",
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
  }, {
    "name" : "sig_name",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"repo_detail\": {\n            \"repo\": [\"Ascend/pytorch\"],\n            \"committers\": [{\n                \"gitcode_id\": \"li_jing_hw\"\n            }, {\n                \"gitcode_id\": \"liwei386\"\n            }, {\n                \"gitcode_id\": \"shaoyf\"\n            }, {\n                \"gitcode_id\": \"zqwenn\"\n            }, {\n                \"gitcode_id\": \"dilililiwhy\"\n            }, {\n                \"gitcode_id\": \"guoqi1024\"\n            }, {\n                \"gitcode_id\": \"htchu\"\n            }, {\n                \"gitcode_id\": \"wangmin0104\"\n            }, {\n                \"gitcode_id\": \"wasd1111222\"\n            }, {\n                \"gitcode_id\": \"wangqiang160\"\n            }, {\n                \"gitcode_id\": \"medivh-x\"\n            }, {\n                \"gitcode_id\": \"chujinjin\"\n            }, {\n                \"gitcode_id\": \"liujunzhu\"\n            }, {\n                \"gitcode_id\": \"zichun_ye\"\n            }, {\n                \"gitcode_id\": \"anyrenwei\"\n            }, {\n                \"gitcode_id\": \"adrian07110\"\n            }, {\n                \"gitcode_id\": \"chuboning\"\n            }],\n            \"reviewers\": [{\n                \"gitcode_id\": \"li_jing_hw\"\n            }, {\n                \"gitcode_id\": \"liwei386\"\n            }, {\n                \"gitcode_id\": \"shaoyf\"\n            }, {\n                \"gitcode_id\": \"zqwenn\"\n            }, {\n                \"gitcode_id\": \"dilililiwhy\"\n            }, {\n                \"gitcode_id\": \"guoqi1024\"\n            }, {\n                \"gitcode_id\": \"htchu\"\n            }, {\n                \"gitcode_id\": \"wangmin0104\"\n            }, {\n                \"gitcode_id\": \"wasd1111222\"\n            }, {\n                \"gitcode_id\": \"wangqiang160\"\n            }, {\n                \"gitcode_id\": \"medivh-x\"\n            }, {\n                \"gitcode_id\": \"chuboning\"\n            }, {\n                \"gitcode_id\": \"chujinjin\"\n            }, {\n                \"gitcode_id\": \"liujunzhu\"\n            }, {\n                \"gitcode_id\": \"zichun_ye\"\n            }, {\n                \"gitcode_id\": \"anyrenwei\"\n            }, {\n                \"gitcode_id\": \"hbhu_bin\"\n            }, {\n                \"gitcode_id\": \"luochao60\"\n            }, {\n                \"gitcode_id\": \"ffmh\"\n            }, {\n                \"gitcode_id\": \"huangyunlong2022\"\n            }, {\n                \"gitcode_id\": \"chengpeng25\"\n            }, {\n                \"gitcode_id\": \"daifu1234567\"\n            }, {\n                \"gitcode_id\": \"liangsongwei\"\n            }],\n            \"entry_configs\": [{\n                \"path\": [\"torch_npu/_inductor\", \"torch_npu/dynamo\", \"third_party/torch-mlir\", \"torch_npu/utils\", \"torch_npu/csrc/inductor\"],\n                \"committers\": [{\n                    \"gitcode_id\": \"anyrenwei\"\n                }, {\n                    \"gitcode_id\": \"zichun_ye\"\n                }, {\n                    \"gitcode_id\": \"suhaibo\"\n                }, {\n                    \"gitcode_id\": \"adrian07110\"\n                }, {\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"crazyDannyBoy\"\n                }, {\n                    \"gitcode_id\": \"weizhan4\"\n                }],\n                \"reviewers\": [{\n                    \"gitcode_id\": \"yangkaixin\"\n                }, {\n                    \"gitcode_id\": \"rain-666\"\n                }, {\n                    \"gitcode_id\": \"weizhan4\"\n                }, {\n                    \"gitcode_id\": \"yang-binrong\"\n                }, {\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"chuboning\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"hbhu_bin\"\n                }, {\n                    \"gitcode_id\": \"luochao60\"\n                }, {\n                    \"gitcode_id\": \"ffmh\"\n                }, {\n                    \"gitcode_id\": \"huangyunlong2022\"\n                }, {\n                    \"gitcode_id\": \"crazyDannyBoy\"\n                }, {\n                    \"gitcode_id\": \"chengpeng25\"\n                }, {\n                    \"gitcode_id\": \"daifu1234567\"\n                }, {\n                    \"gitcode_id\": \"liangsongwei\"\n                }]\n            }, {\n                \"path\": [\"torch_npu/distributed\", \"torch_npu/csrc/distributed\"],\n                \"committers\": [{\n                    \"gitcode_id\": \"renyujin\"\n                }, {\n                    \"gitcode_id\": \"wjlflyer\"\n                }, {\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"chuboning\"\n                }],\n                \"reviewers\": [{\n                    \"gitcode_id\": \"kisnwang\"\n                }, {\n                    \"gitcode_id\": \"zhenyu10\"\n                }, {\n                    \"gitcode_id\": \"senzhen-town\"\n                }, {\n                    \"gitcode_id\": \"pengjingyou\"\n                }, {\n                    \"gitcode_id\": \"huangjingwei\"\n                }, {\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"chuboning\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"hbhu_bin\"\n                }, {\n                    \"gitcode_id\": \"luochao60\"\n                }, {\n                    \"gitcode_id\": \"ffmh\"\n                }, {\n                    \"gitcode_id\": \"huangyunlong2022\"\n                }, {\n                    \"gitcode_id\": \"chengpeng25\"\n                }, {\n                    \"gitcode_id\": \"daifu1234567\"\n                }, {\n                    \"gitcode_id\": \"liangsongwei\"\n                }]\n            }, {\n                \"path\": [\"torch_npu/npu\"],\n                \"committers\": [{\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"chuboning\"\n                }],\n                \"reviewers\": [{\n                    \"gitcode_id\": \"daifu1234567\"\n                }, {\n                    \"gitcode_id\": \"liangsongwei\"\n                }, {\n                    \"gitcode_id\": \"liangchenghui\"\n                }, {\n                    \"gitcode_id\": \"probiotics_53\"\n                }, {\n                    \"gitcode_id\": \"ffmh\"\n                }, {\n                    \"gitcode_id\": \"wanglijun55\"\n                }, {\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"chuboning\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"hbhu_bin\"\n                }, {\n                    \"gitcode_id\": \"luochao60\"\n                }, {\n                    \"gitcode_id\": \"ffmh\"\n                }, {\n                    \"gitcode_id\": \"huangyunlong2022\"\n                }, {\n                    \"gitcode_id\": \"chengpeng25\"\n                }]\n            }, {\n                \"path\": [\"torch_npu/profiler\"],\n                \"committers\": [{\n                    \"gitcode_id\": \"chenhao_1209\"\n                }, {\n                    \"gitcode_id\": \"wangchao285\"\n                }, {\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }],\n                \"reviewers\": [{\n                    \"gitcode_id\": \"chenhao_1209\"\n                }, {\n                    \"gitcode_id\": \"wangchao285\"\n                }, {\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"chuboning\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"hbhu_bin\"\n                }, {\n                    \"gitcode_id\": \"luochao60\"\n                }, {\n                    \"gitcode_id\": \"ffmh\"\n                }, {\n                    \"gitcode_id\": \"huangyunlong2022\"\n                }, {\n                    \"gitcode_id\": \"chengpeng25\"\n                }, {\n                    \"gitcode_id\": \"daifu1234567\"\n                }, {\n                    \"gitcode_id\": \"liangsongwei\"\n                }]\n            }, {\n                \"path\": [\"docs\"],\n                \"committers\": [{\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"anyrenwei\"\n                }, {\n                    \"gitcode_id\": \"zichun_ye\"\n                }, {\n                    \"gitcode_id\": \"suhaibo\"\n                }, {\n                    \"gitcode_id\": \"adrian07110\"\n                }, {\n                    \"gitcode_id\": \"renyujin\"\n                }, {\n                    \"gitcode_id\": \"wjlflyer\"\n                }, {\n                    \"gitcode_id\": \"chenhao_1209\"\n                }, {\n                    \"gitcode_id\": \"wangchao285\"\n                }, {\n                    \"gitcode_id\": \"wjlflyer\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"chuboning\"\n                }],\n                \"reviewers\": [{\n                    \"gitcode_id\": \"lee_jihae\"\n                }, {\n                    \"gitcode_id\": \"LQ1206\"\n                }, {\n                    \"gitcode_id\": \"molly123321\"\n                }, {\n                    \"gitcode_id\": \"lyx324521\"\n                }, {\n                    \"gitcode_id\": \"gitcode-chenjiao\"\n                }]\n            }, {\n                \"path\": [\"test\"],\n                \"committers\": [{\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"anyrenwei\"\n                }, {\n                    \"gitcode_id\": \"zichun_ye\"\n                }, {\n                    \"gitcode_id\": \"suhaibo\"\n                }, {\n                    \"gitcode_id\": \"adrian07110\"\n                }, {\n                    \"gitcode_id\": \"renyujin\"\n                }, {\n                    \"gitcode_id\": \"wjlflyer\"\n                }, {\n                    \"gitcode_id\": \"chenhao_1209\"\n                }, {\n                    \"gitcode_id\": \"wangchao285\"\n                }, {\n                    \"gitcode_id\": \"wjlflyer\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"crazyDannyBoy\"\n                }, {\n                    \"gitcode_id\": \"chuboning\"\n                }],\n                \"reviewers\": [{\n                    \"gitcode_id\": \"li_jing_hw\"\n                }, {\n                    \"gitcode_id\": \"liwei386\"\n                }, {\n                    \"gitcode_id\": \"shaoyf\"\n                }, {\n                    \"gitcode_id\": \"zqwenn\"\n                }, {\n                    \"gitcode_id\": \"dilililiwhy\"\n                }, {\n                    \"gitcode_id\": \"guoqi1024\"\n                }, {\n                    \"gitcode_id\": \"htchu\"\n                }, {\n                    \"gitcode_id\": \"wangmin0104\"\n                }, {\n                    \"gitcode_id\": \"wasd1111222\"\n                }, {\n                    \"gitcode_id\": \"wangqiang160\"\n                }, {\n                    \"gitcode_id\": \"medivh-x\"\n                }, {\n                    \"gitcode_id\": \"chuboning\"\n                }, {\n                    \"gitcode_id\": \"yangkaixin\"\n                }, {\n                    \"gitcode_id\": \"rain-666\"\n                }, {\n                    \"gitcode_id\": \"weizhan4\"\n                }, {\n                    \"gitcode_id\": \"yang-binrong\"\n                }, {\n                    \"gitcode_id\": \"kisnwang\"\n                }, {\n                    \"gitcode_id\": \"zhenyu10\"\n                }, {\n                    \"gitcode_id\": \"senzhen-town\"\n                }, {\n                    \"gitcode_id\": \"pengjingyou\"\n                }, {\n                    \"gitcode_id\": \"huangjingwei\"\n                }, {\n                    \"gitcode_id\": \"daifu1234567\"\n                }, {\n                    \"gitcode_id\": \"liangsongwei\"\n                }, {\n                    \"gitcode_id\": \"liangchenghui\"\n                }, {\n                    \"gitcode_id\": \"probiotics_53\"\n                }, {\n                    \"gitcode_id\": \"ffmh\"\n                }, {\n                    \"gitcode_id\": \"wanglijun55\"\n                }, {\n                    \"gitcode_id\": \"chenhao_1209\"\n                }, {\n                    \"gitcode_id\": \"wangchao285\"\n                }, {\n                    \"gitcode_id\": \"shi-jiaxin9\"\n                }, {\n                    \"gitcode_id\": \"culechan\"\n                }, {\n                    \"gitcode_id\": \"chujinjin\"\n                }, {\n                    \"gitcode_id\": \"liujunzhu\"\n                }, {\n                    \"gitcode_id\": \"hbhu_bin\"\n                }, {\n                    \"gitcode_id\": \"luochao60\"\n                }, {\n                    \"gitcode_id\": \"huangyunlong2022\"\n                }, {\n                    \"gitcode_id\": \"crazyDannyBoy\"\n                }, {\n                    \"gitcode_id\": \"chengpeng25\"\n                }, {\n                    \"gitcode_id\": \"daifu1234567\"\n                }, {\n                    \"gitcode_id\": \"liangsongwei\"\n                }, {\n                    \"gitcode_id\": \"yuhaiyan\"\n                }, {\n                    \"gitcode_id\": \"AACAES\"\n                }]\n            }]\n        },\n        \"data\": [\"adrian07110\", \"anyrenwei\", \"chuboning\", \"chujinjin\", \"dilililiwhy\", \"guoqi1024\", \"htchu\", \"li_jing_hw\", \"liujunzhu\", \"liwei386\", \"medivh-x\", \"shaoyf\", \"wangmin0104\", \"wangqiang160\", \"wasd1111222\", \"zichun_ye\", \"zqwenn\"],\n        \"type\": \"gitcode\"\n    },\n    \"timestamp\": 1774337904355,\n    \"executeTime\": 12\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import ch.qos.logback.classic.Level


var sig_name_temp = sig_name;
var community_temp = community;
var repo_temp = repo;
var branch_temp = branch;
var role_temp = role;
var level_temp = level;
var res = new ArrayList();
var resList = null;

var set =new HashSet();
set.push("Ascend")
set.push("ascend")
set.push("CANN")
set.push("cann")



if("openeuler".equals(community_temp)){
    community_temp = "openeulerrobot"
}
if("opengauss".equals(community_temp)){
    community_temp = "opengaussrobot"
}
var otherset =new HashSet();
otherset.push("openubmc")
otherset.push("openUBMC")
otherset.push("openeulerrobot")
otherset.push("openeuler")
otherset.push("openEuler")
otherset.push("openFuyao")
otherset.push("openfuyao")
otherset.push("openGauss")
otherset.push("opengauss")
otherset.push("opengaussrobot")
otherset.push("Mindspore")
otherset.push("mindspore")
otherset.push("BoostKit")
otherset.push("boostkit")
otherset.push("openlibing")
otherset.push("OpenLibing")

var result_map = new HashMap();
result_map.put("data",res)
result_map.put("type",null)
if("CANN".equals(community_temp) ||"cann".equals(community_temp) || "mindspore".equals(community_temp) ||"MindSpore".equals(community_temp) ){
    return result_map;
}

if(set.contains(community_temp)){
    var levels =["branch_entry","repo_entry","branch","repo","sig"]
    var start_flag = false;
    for(item_level in levels){
        if(item_level.equals(level_temp)){
            start_flag = true;
        }
        if(!start_flag){
            continue;
        }
        var sql = """
            select distinct user_login,platform from fact_${community_temp}_sig_user where
            <if test="item_level != null and item_level != 'sig'">
                  LOWER(repo) = LOWER(#{repo_temp})
            </if>
            <if test="item_level != null and item_level == 'sig'">
                    1=1
            </if>     
                AND  sig_name in (select distinct sig_name from fact_${community_temp}_sig_user where LOWER(repo) = LOWER(#{repo_temp}) and  role is null)
            <if test="role_temp != null and role_temp != ''">
                AND permission_role = '${item_level}_${role_temp}'
            </if>
            <if test="branch_temp != null and branch_temp != ''">
                AND branch = #{branch_temp}
            </if>
            AND user_login is not null
        """
        resList = db.select(sql);
        if(resList!=null&&resList.size()>0){
            for(item in resList){
                res.add(item.get("user_login"))
            }
            result_map.put("data",res)
            var platform3 = resList.get(0).get("platform")
            if("atomgit".equals(platform3)){
                platform3 = "gitcode"
            }
            result_map.put("type",platform3)
            break;
        }
        

    }
    
}else if(otherset.contains(community_temp)){
     var repo_name = repo.split("/");
     var np=repo_name[0]
     var rp_path = repo_name[1]
     var sql = """
            select distinct user_login,platform from fact_${community_temp}_sig_user where
              1=1 
            <if test="role_temp != null and role_temp != ''">
                AND (role = #{role_temp} or role = 'maintainer')
            </if>
            AND LOWER(namespace) = LOWER(#{np})
            AND LOWER(repo_path) = LOWER(#{rp_path})
            AND user_login is not null
        """
 
    resList = db.select(sql);
    if(resList!=null&&resList.size()>0){
        for(item in resList){
            res.add(item.get("user_login"))
        }
        var platform3 = resList.get(0).get("platform")
        if("atomgit".equals(platform3)){
            platform3 = "gitcode"
        }
        result_map.put("type",platform3)
    }
   
}else{
     var repo_name = repo.split("/");
     var np=repo_name[0]
     var rp_path = repo_name[1]
     var sql = """
            select distinct user_login,platform from fact_${community_temp}_sig_user where
              1=1 
            <if test="role_temp != null and role_temp != ''">
                AND role = #{role_temp}
            </if>
            AND LOWER(namespace) = LOWER(#{np})
            AND LOWER(repo_path) = LOWER(#{rp_path})
            AND user_login is not null
        """
 
    resList = db.select(sql);
    if(resList!=null&&resList.size()>0){
        for(item in resList){
            res.add(item.get("user_login"))
        }
        var platform3 = resList.get(0).get("platform")
        if("atomgit".equals(platform3)){
            platform3 = "gitcode"
        }
        result_map.put("type",platform3)
    }
}

var repo_name = repo.split("/");
var np=repo_name[0]
var rp_path = repo_name[1]

var sqlstr = """
select sig_json from fact_${community_temp}_sig_detail_info where

sig_name in (select distinct sig_name from fact_${community_temp}_sig_user where  LOWER(namespace) = LOWER(#{np})
    AND LOWER(repo_path) = LOWER(#{rp_path}))

"""
var res = db.select(sqlstr)

for (it in res) {
    var sig_info = it['sig_json']::json

    if (sig_info.containsKey('repositories')) {
        for (key in sig_info.get('repositories')) {

            if (key['repo'].contains(repo_temp)) {
                result_map.put("repo_detail",key)
                break;
            }
        }
    }

}


return result_map
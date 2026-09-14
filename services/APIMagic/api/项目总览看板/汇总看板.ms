{
  "properties" : { },
  "id" : "1bc22a80605f465cb19157579d72254e",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "汇总看板",
  "createTime" : null,
  "updateTime" : 1773922961592,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/summary",
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
  "requestBody" : "{\r\n    \"start\":1730390400000,\r\n    \"end\":1747449490120,\r\n    \"community\":\"cann\",\r\n    \"topn\": 10\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"repo_path\": \"metadef\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 188,\n            \"total_issue_count\": 3,\n            \"other_user_merged_pr_count\": 369,\n            \"open_pr_count\": 177,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 10,\n            \"merged_pr_count\": 557,\n            \"total_pr_count\": 734,\n            \"other_user_count\": 59,\n            \"closed_issue_count\": 3\n        },\n        \"company\": [{\n            \"repo_path\": \"metadef\",\n            \"company\": \"华为技术有限公司\",\n            \"merged_pr_incre\": 1584,\n            \"company_rank\": 1\n        }],\n        \"sort\": 0,\n        \"user\": [{\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"ni100die\",\n            \"html_url\": \"https://gitee.com/ni100die\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 55,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"zhangfan_hq\",\n            \"html_url\": \"https://gitee.com/zhangfan_hq\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 37,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"wangxiaotian22\",\n            \"html_url\": \"https://gitee.com/wangxiaotian22\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 35,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"wqtshg\",\n            \"html_url\": \"https://gitee.com/wqtshg\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 35,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"zhan-jun\",\n            \"html_url\": \"https://gitee.com/zhan-jun\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 31,\n            \"user_rank\": 5\n        }, {\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"hugo1\",\n            \"html_url\": \"https://gitee.com/hugo1\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 28,\n            \"user_rank\": 6\n        }, {\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"zhangdepeng2\",\n            \"html_url\": \"https://gitee.com/zhangdepeng2\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 25,\n            \"user_rank\": 7\n        }, {\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"guopeian\",\n            \"html_url\": \"https://gitee.com/guopeian\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 24,\n            \"user_rank\": 8\n        }, {\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"tang-haojie\",\n            \"html_url\": \"https://gitee.com/tang-haojie\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 20,\n            \"user_rank\": 9\n        }, {\n            \"repo_path\": \"metadef\",\n            \"user_login\": \"zhang_shengjie\",\n            \"html_url\": \"https://gitee.com/zhang_shengjie\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 17,\n            \"user_rank\": 10\n        }]\n    }, {\n        \"repo_path\": \"tensorflow\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 18,\n            \"total_issue_count\": 1,\n            \"other_user_merged_pr_count\": 64,\n            \"open_pr_count\": 44,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 5,\n            \"merged_pr_count\": 82,\n            \"total_pr_count\": 126,\n            \"other_user_count\": 18,\n            \"closed_issue_count\": 1\n        },\n        \"company\": [{\n            \"repo_path\": \"tensorflow\",\n            \"company\": \"华为技术有限公司\",\n            \"merged_pr_incre\": 306,\n            \"company_rank\": 1\n        }],\n        \"sort\": 1,\n        \"user\": [{\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"wqtshg\",\n            \"html_url\": \"https://gitee.com/wqtshg\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 9,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"liuqiangdagongzai\",\n            \"html_url\": \"https://gitee.com/liuqiangdagongzai\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 8,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"zhangdepeng2\",\n            \"html_url\": \"https://gitee.com/zhangdepeng2\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 8,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"kennchow\",\n            \"html_url\": \"https://gitee.com/kennchow\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 7,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"yangyongqiang5033\",\n            \"html_url\": \"https://gitee.com/yangyongqiang5033\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 7,\n            \"user_rank\": 5\n        }, {\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"zhangfan_hq\",\n            \"html_url\": \"https://gitee.com/zhangfan_hq\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 7,\n            \"user_rank\": 6\n        }, {\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"wangxiaotian22\",\n            \"html_url\": \"https://gitee.com/wangxiaotian22\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 6,\n            \"user_rank\": 7\n        }, {\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"guopeian\",\n            \"html_url\": \"https://gitee.com/guopeian\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 5,\n            \"user_rank\": 8\n        }, {\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"stevenaw\",\n            \"html_url\": \"https://gitee.com/stevenaw\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 4,\n            \"user_rank\": 9\n        }, {\n            \"repo_path\": \"tensorflow\",\n            \"user_login\": \"huanruizhi\",\n            \"html_url\": \"https://gitee.com/huanruizhi\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 3,\n            \"user_rank\": 10\n        }]\n    }, {\n        \"repo_path\": \"samples\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 5,\n            \"total_issue_count\": 272,\n            \"other_user_merged_pr_count\": 187,\n            \"open_pr_count\": 50,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 3,\n            \"merged_pr_count\": 192,\n            \"total_pr_count\": 242,\n            \"other_user_count\": 53,\n            \"closed_issue_count\": 272\n        },\n        \"company\": [{\n            \"repo_path\": \"samples\",\n            \"company\": \"华为技术有限公司\",\n            \"merged_pr_incre\": 37,\n            \"company_rank\": 1\n        }, {\n            \"repo_path\": \"samples\",\n            \"company\": \"华为合作方\",\n            \"merged_pr_incre\": 2,\n            \"company_rank\": 2\n        }],\n        \"sort\": 2,\n        \"user\": [{\n            \"repo_path\": \"samples\",\n            \"user_login\": \"chyu1996\",\n            \"html_url\": \"https://gitee.com/chyu1996\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 28,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"samples\",\n            \"user_login\": \"hujiawenkaven\",\n            \"html_url\": \"https://gitee.com/hujiawenkaven\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 12,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"samples\",\n            \"user_login\": \"anzoola\",\n            \"html_url\": \"https://gitee.com/anzoola\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 10,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"samples\",\n            \"user_login\": \"cong-fei-jiang\",\n            \"html_url\": \"https://gitee.com/cong-fei-jiang\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 9,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"samples\",\n            \"user_login\": \"lining23666\",\n            \"html_url\": \"https://gitee.com/lining23666\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 8,\n            \"user_rank\": 5\n        }, {\n            \"repo_path\": \"samples\",\n            \"user_login\": \"ruanyy\",\n            \"html_url\": \"https://gitee.com/ruanyy\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 8,\n            \"user_rank\": 6\n        }, {\n            \"repo_path\": \"samples\",\n            \"user_login\": \"vergilxh\",\n            \"html_url\": \"https://gitee.com/vergilxh\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 6,\n            \"user_rank\": 7\n        }, {\n            \"repo_path\": \"samples\",\n            \"user_login\": \"HuaWeiBelief\",\n            \"html_url\": \"https://gitee.com/HuaWeiBelief\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 6,\n            \"user_rank\": 8\n        }, {\n            \"repo_path\": \"samples\",\n            \"user_login\": \"tanlonghui\",\n            \"html_url\": \"https://gitee.com/tanlonghui\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 6,\n            \"user_rank\": 9\n        }, {\n            \"repo_path\": \"samples\",\n            \"user_login\": \"zhangxin536\",\n            \"html_url\": \"https://gitee.com/zhangxin536\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 6,\n            \"user_rank\": 10\n        }]\n    }, {\n        \"repo_path\": \"torchair\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 26,\n            \"other_user_merged_pr_count\": 293,\n            \"open_pr_count\": 112,\n            \"open_issue_count\": 22,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 293,\n            \"total_pr_count\": 405,\n            \"other_user_count\": 59,\n            \"closed_issue_count\": 4\n        },\n        \"company\": [{\n            \"repo_path\": \"torchair\",\n            \"company\": \"华为技术有限公司\",\n            \"merged_pr_incre\": 7,\n            \"company_rank\": 1\n        }],\n        \"sort\": 3,\n        \"user\": [{\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"guan-longfeng\",\n            \"html_url\": \"https://gitee.com/guan-longfeng\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 41,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"xuepenginnanjing\",\n            \"html_url\": \"https://gitee.com/xuepenginnanjing\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 36,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"xudaohong\",\n            \"html_url\": \"https://gitee.com/xudaohong\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 29,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"chenweiheng3\",\n            \"html_url\": \"https://gitee.com/chenweiheng3\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 17,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"wbigat\",\n            \"html_url\": \"https://gitee.com/wbigat\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 16,\n            \"user_rank\": 5\n        }, {\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"luboyang\",\n            \"html_url\": \"https://gitee.com/luboyang\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 15,\n            \"user_rank\": 6\n        }, {\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"photoker\",\n            \"html_url\": \"https://gitee.com/photoker\",\n            \"avatar_url\": \"https://foruda.gitee.com/avatar/1693382313765017229/13185789_photoker_1693382313.png\",\n            \"merged_pr_incre\": 15,\n            \"user_rank\": 7\n        }, {\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"wangqian108\",\n            \"html_url\": \"https://gitee.com/wangqian108\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 13,\n            \"user_rank\": 8\n        }, {\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"wang-pierre-jiacheng\",\n            \"html_url\": \"https://gitee.com/wang-pierre-jiacheng\",\n            \"avatar_url\": \"https://foruda.gitee.com/avatar/1680625947422268294/12731429_wang-pierre-jiacheng_1680625947.png\",\n            \"merged_pr_incre\": 8,\n            \"user_rank\": 9\n        }, {\n            \"repo_path\": \"torchair\",\n            \"user_login\": \"duck7216\",\n            \"html_url\": \"https://gitee.com/duck7216\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 7,\n            \"user_rank\": 10\n        }]\n    }, {\n        \"repo_path\": \"tools\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 2,\n            \"total_issue_count\": 22,\n            \"other_user_merged_pr_count\": 161,\n            \"open_pr_count\": 14,\n            \"open_issue_count\": 22,\n            \"huawei_user_count\": 1,\n            \"merged_pr_count\": 163,\n            \"total_pr_count\": 177,\n            \"other_user_count\": 12,\n            \"closed_issue_count\": 0\n        },\n        \"company\": [{\n            \"repo_path\": \"tools\",\n            \"company\": \"华为技术有限公司\",\n            \"merged_pr_incre\": 218,\n            \"company_rank\": 1\n        }, {\n            \"repo_path\": \"tools\",\n            \"company\": \"华为合作方\",\n            \"merged_pr_incre\": 135,\n            \"company_rank\": 2\n        }],\n        \"sort\": 4,\n        \"user\": [{\n            \"repo_path\": \"tools\",\n            \"user_login\": \"y30044005\",\n            \"html_url\": \"https://gitee.com/y30044005\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 79,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"tools\",\n            \"user_login\": \"zjks98\",\n            \"html_url\": \"https://gitee.com/zjks98\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 34,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"tools\",\n            \"user_login\": \"zhang-gaohua_admin\",\n            \"html_url\": \"https://gitee.com/zhang-gaohua_admin\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 16,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"tools\",\n            \"user_login\": \"zhang-xun-asher\",\n            \"html_url\": \"https://gitee.com/zhang-xun-asher\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 10,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"tools\",\n            \"user_login\": \"acarpw\",\n            \"html_url\": \"https://gitee.com/acarpw\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 8,\n            \"user_rank\": 5\n        }, {\n            \"repo_path\": \"tools\",\n            \"user_login\": \"keith_wwa\",\n            \"html_url\": \"https://gitee.com/keith_wwa\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 5,\n            \"user_rank\": 6\n        }, {\n            \"repo_path\": \"tools\",\n            \"user_login\": \"jiangchangting1\",\n            \"html_url\": \"https://gitee.com/jiangchangting1\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 3,\n            \"user_rank\": 7\n        }, {\n            \"repo_path\": \"tools\",\n            \"user_login\": \"cai-weiwei1989\",\n            \"html_url\": \"https://gitee.com/cai-weiwei1989\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 2,\n            \"user_rank\": 8\n        }, {\n            \"repo_path\": \"tools\",\n            \"user_login\": \"yang_chen_2001_02_14\",\n            \"html_url\": \"https://gitee.com/yang_chen_2001_02_14\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 2,\n            \"user_rank\": 9\n        }, {\n            \"repo_path\": \"tools\",\n            \"user_login\": \"su-yueming\",\n            \"html_url\": \"https://gitee.com/su-yueming\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 1,\n            \"user_rank\": 10\n        }]\n    }, {\n        \"repo_path\": \"ModelZoo-TensorFlow\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 1,\n            \"total_issue_count\": 0,\n            \"other_user_merged_pr_count\": 1,\n            \"open_pr_count\": 2,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 1,\n            \"merged_pr_count\": 2,\n            \"total_pr_count\": 4,\n            \"other_user_count\": 1,\n            \"closed_issue_count\": 0\n        },\n        \"company\": [{\n            \"repo_path\": \"ModelZoo-TensorFlow\",\n            \"company\": \"华为技术有限公司\",\n            \"merged_pr_incre\": 5,\n            \"company_rank\": 1\n        }],\n        \"sort\": 5,\n        \"user\": [{\n            \"repo_path\": \"ModelZoo-TensorFlow\",\n            \"user_login\": \"l_88888\",\n            \"html_url\": \"https://gitee.com/l_88888\",\n            \"avatar_url\": \"https://foruda.gitee.com/avatar/1677028981094528781/4961001_l_88888_1578977727.png\",\n            \"merged_pr_incre\": 1,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"ModelZoo-TensorFlow\",\n            \"user_login\": \"turing_project\",\n            \"html_url\": \"https://gitee.com/turing_project\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 1,\n            \"user_rank\": 2\n        }]\n    }, {\n        \"repo_path\": \"ascendc-api-adv\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 3,\n            \"other_user_merged_pr_count\": 301,\n            \"open_pr_count\": 27,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 301,\n            \"total_pr_count\": 328,\n            \"other_user_count\": 42,\n            \"closed_issue_count\": 3\n        },\n        \"company\": [{\n            \"repo_path\": \"ascendc-api-adv\",\n            \"company\": \"华为技术有限公司\",\n            \"merged_pr_incre\": 3,\n            \"company_rank\": 1\n        }],\n        \"sort\": 6,\n        \"user\": [{\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"king1600307376\",\n            \"html_url\": \"https://gitee.com/king1600307376\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 20,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"ruanyy\",\n            \"html_url\": \"https://gitee.com/ruanyy\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 20,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"chyu1996\",\n            \"html_url\": \"https://gitee.com/chyu1996\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 18,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"HuaWeiBelief\",\n            \"html_url\": \"https://gitee.com/HuaWeiBelief\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 18,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"dengjing_aoe\",\n            \"html_url\": \"https://gitee.com/dengjing_aoe\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 14,\n            \"user_rank\": 5\n        }, {\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"bluesky90\",\n            \"html_url\": \"https://gitee.com/bluesky90\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 13,\n            \"user_rank\": 6\n        }, {\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"kong0808\",\n            \"html_url\": \"https://gitee.com/kong0808\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 13,\n            \"user_rank\": 7\n        }, {\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"li-yuanjie-da\",\n            \"html_url\": \"https://gitee.com/li-yuanjie-da\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 12,\n            \"user_rank\": 8\n        }, {\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"pick3t\",\n            \"html_url\": \"https://gitee.com/pick3t\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 12,\n            \"user_rank\": 9\n        }, {\n            \"repo_path\": \"ascendc-api-adv\",\n            \"user_login\": \"yxf-dev-ops\",\n            \"html_url\": \"https://gitee.com/yxf-dev-ops\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 12,\n            \"user_rank\": 10\n        }]\n    }, {\n        \"repo_path\": \"cann-ops\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 5,\n            \"total_issue_count\": 23,\n            \"other_user_merged_pr_count\": 202,\n            \"open_pr_count\": 93,\n            \"open_issue_count\": 22,\n            \"huawei_user_count\": 2,\n            \"merged_pr_count\": 207,\n            \"total_pr_count\": 300,\n            \"other_user_count\": 66,\n            \"closed_issue_count\": 1\n        },\n        \"company\": [{\n            \"repo_path\": \"cann-ops\",\n            \"company\": \"华为技术有限公司\",\n            \"merged_pr_incre\": 5,\n            \"company_rank\": 1\n        }],\n        \"sort\": 7,\n        \"user\": [{\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"photoker\",\n            \"html_url\": \"https://gitee.com/photoker\",\n            \"avatar_url\": \"https://foruda.gitee.com/avatar/1693382313765017229/13185789_photoker_1693382313.png\",\n            \"merged_pr_incre\": 20,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"sxsyzpf\",\n            \"html_url\": \"https://gitee.com/sxsyzpf\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 12,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"xie-lili\",\n            \"html_url\": \"https://gitee.com/xie-lili\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 10,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"enkilee\",\n            \"html_url\": \"https://gitee.com/enkilee\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 9,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"rueenov\",\n            \"html_url\": \"https://gitee.com/rueenov\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 8,\n            \"user_rank\": 5\n        }, {\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"ji-songyuan\",\n            \"html_url\": \"https://gitee.com/ji-songyuan\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 7,\n            \"user_rank\": 6\n        }, {\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"chenlina10\",\n            \"html_url\": \"https://gitee.com/chenlina10\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 6,\n            \"user_rank\": 7\n        }, {\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"luwang06\",\n            \"html_url\": \"https://gitee.com/luwang06\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 6,\n            \"user_rank\": 8\n        }, {\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"mi-xianlin\",\n            \"html_url\": \"https://gitee.com/mi-xianlin\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 6,\n            \"user_rank\": 9\n        }, {\n            \"repo_path\": \"cann-ops\",\n            \"user_login\": \"Nicet\",\n            \"html_url\": \"https://gitee.com/Nicet\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 5,\n            \"user_rank\": 10\n        }]\n    }, {\n        \"repo_path\": \"vision\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 17,\n            \"other_user_merged_pr_count\": 25,\n            \"open_pr_count\": 0,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 25,\n            \"total_pr_count\": 25,\n            \"other_user_count\": 5,\n            \"closed_issue_count\": 17\n        },\n        \"company\": null,\n        \"sort\": 8,\n        \"user\": [{\n            \"repo_path\": \"vision\",\n            \"user_login\": \"wang-guangbin\",\n            \"html_url\": \"https://gitee.com/wang-guangbin\",\n            \"avatar_url\": \"https://foruda.gitee.com/avatar/1698418065848663693/12663114_wang-guangbin_1698418065.png\",\n            \"merged_pr_incre\": 18,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"vision\",\n            \"user_login\": \"aahehe\",\n            \"html_url\": \"https://gitee.com/aahehe\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 3,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"vision\",\n            \"user_login\": \"zhou-dongming\",\n            \"html_url\": \"https://gitee.com/zhou-dongming\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 2,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"vision\",\n            \"user_login\": \"shaoyf\",\n            \"html_url\": \"https://gitee.com/shaoyf\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 1,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"vision\",\n            \"user_login\": \"yicheng_gong\",\n            \"html_url\": \"https://gitee.com/yicheng_gong\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 1,\n            \"user_rank\": 5\n        }]\n    }, {\n        \"repo_path\": \"cann-ops-adv\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 32,\n            \"other_user_merged_pr_count\": 58,\n            \"open_pr_count\": 89,\n            \"open_issue_count\": 9,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 58,\n            \"total_pr_count\": 147,\n            \"other_user_count\": 29,\n            \"closed_issue_count\": 23\n        },\n        \"company\": null,\n        \"sort\": 9,\n        \"user\": [{\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"wmr2020\",\n            \"html_url\": \"https://gitee.com/wmr2020\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 6,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"kong-deyuan\",\n            \"html_url\": \"https://gitee.com/kong-deyuan\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 5,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"realmadrid1016\",\n            \"html_url\": \"https://gitee.com/realmadrid1016\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 4,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"qianwen-ye\",\n            \"html_url\": \"https://gitee.com/qianwen-ye\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 4,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"newanew\",\n            \"html_url\": \"https://gitee.com/newanew\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 3,\n            \"user_rank\": 5\n        }, {\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"yangxu19921206\",\n            \"html_url\": \"https://gitee.com/yangxu19921206\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 3,\n            \"user_rank\": 6\n        }, {\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"yuhao_zju\",\n            \"html_url\": \"https://gitee.com/yuhao_zju\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 3,\n            \"user_rank\": 7\n        }, {\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"zyhhuige\",\n            \"html_url\": \"https://gitee.com/zyhhuige\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 2,\n            \"user_rank\": 8\n        }, {\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"yangyidiao\",\n            \"html_url\": \"https://gitee.com/yangyidiao\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 2,\n            \"user_rank\": 9\n        }, {\n            \"repo_path\": \"cann-ops-adv\",\n            \"user_login\": \"gitee-chenjiao\",\n            \"html_url\": \"https://gitee.com/gitee-chenjiao\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 2,\n            \"user_rank\": 10\n        }]\n    }, {\n        \"repo_path\": \"catlass\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 9,\n            \"other_user_merged_pr_count\": 49,\n            \"open_pr_count\": 0,\n            \"open_issue_count\": 8,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 49,\n            \"total_pr_count\": 49,\n            \"other_user_count\": 9,\n            \"closed_issue_count\": 1\n        },\n        \"company\": null,\n        \"sort\": 10,\n        \"user\": [{\n            \"repo_path\": \"catlass\",\n            \"user_login\": \"huangxin36\",\n            \"html_url\": \"https://gitee.com/huangxin36\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 14,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"catlass\",\n            \"user_login\": \"yuantao_hw\",\n            \"html_url\": \"https://gitee.com/yuantao_hw\",\n            \"avatar_url\": \"https://foruda.gitee.com/avatar/1724695761916894042/14669328_yuantao_hw_1724695761.png\",\n            \"merged_pr_incre\": 10,\n            \"user_rank\": 2\n        }, {\n            \"repo_path\": \"catlass\",\n            \"user_login\": \"zjw666888\",\n            \"html_url\": \"https://gitee.com/zjw666888\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 8,\n            \"user_rank\": 3\n        }, {\n            \"repo_path\": \"catlass\",\n            \"user_login\": \"owqowq\",\n            \"html_url\": \"https://gitee.com/owqowq\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 5,\n            \"user_rank\": 4\n        }, {\n            \"repo_path\": \"catlass\",\n            \"user_login\": \"dongpeng29\",\n            \"html_url\": \"https://gitee.com/dongpeng29\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 4,\n            \"user_rank\": 5\n        }, {\n            \"repo_path\": \"catlass\",\n            \"user_login\": \"longjihui\",\n            \"html_url\": \"https://gitee.com/longjihui\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 3,\n            \"user_rank\": 6\n        }, {\n            \"repo_path\": \"catlass\",\n            \"user_login\": \"redtorm\",\n            \"html_url\": \"https://gitee.com/redtorm\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 3,\n            \"user_rank\": 7\n        }, {\n            \"repo_path\": \"catlass\",\n            \"user_login\": \"lx_0816\",\n            \"html_url\": \"https://gitee.com/lx_0816\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 1,\n            \"user_rank\": 8\n        }, {\n            \"repo_path\": \"catlass\",\n            \"user_login\": \"dong-ziwei\",\n            \"html_url\": \"https://gitee.com/dong-ziwei\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 1,\n            \"user_rank\": 9\n        }]\n    }, {\n        \"repo_path\": \"cann_op_contrib\",\n        \"active\": null,\n        \"company\": [{\n            \"repo_path\": \"cann_op_contrib\",\n            \"company\": \"华为技术有限公司\",\n            \"merged_pr_incre\": 4,\n            \"company_rank\": 1\n        }],\n        \"sort\": 11,\n        \"user\": null\n    }, {\n        \"repo_path\": \"EdgeAndRobotics\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 11,\n            \"other_user_merged_pr_count\": 0,\n            \"open_pr_count\": 4,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 0,\n            \"total_pr_count\": 4,\n            \"other_user_count\": 0,\n            \"closed_issue_count\": 11\n        },\n        \"company\": null,\n        \"sort\": 12,\n        \"user\": null\n    }, {\n        \"repo_path\": \"cann-hccl\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 23,\n            \"other_user_merged_pr_count\": 11,\n            \"open_pr_count\": 8,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 11,\n            \"total_pr_count\": 19,\n            \"other_user_count\": 2,\n            \"closed_issue_count\": 23\n        },\n        \"company\": null,\n        \"sort\": 13,\n        \"user\": [{\n            \"repo_path\": \"cann-hccl\",\n            \"user_login\": \"philo_yan\",\n            \"html_url\": \"https://gitee.com/philo_yan\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 10,\n            \"user_rank\": 1\n        }, {\n            \"repo_path\": \"cann-hccl\",\n            \"user_login\": \"flyswa\",\n            \"html_url\": \"https://gitee.com/flyswa\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 1,\n            \"user_rank\": 2\n        }]\n    }, {\n        \"repo_path\": \"ACLLite\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 6,\n            \"other_user_merged_pr_count\": 0,\n            \"open_pr_count\": 10,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 0,\n            \"total_pr_count\": 10,\n            \"other_user_count\": 0,\n            \"closed_issue_count\": 6\n        },\n        \"company\": null,\n        \"sort\": 14,\n        \"user\": null\n    }, {\n        \"repo_path\": \"cann-community\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 2,\n            \"other_user_merged_pr_count\": 2,\n            \"open_pr_count\": 1,\n            \"open_issue_count\": 2,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 2,\n            \"total_pr_count\": 3,\n            \"other_user_count\": 1,\n            \"closed_issue_count\": 0\n        },\n        \"company\": null,\n        \"sort\": 15,\n        \"user\": [{\n            \"repo_path\": \"cann-community\",\n            \"user_login\": \"a-young-journey\",\n            \"html_url\": \"https://gitee.com/a-young-journey\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 2,\n            \"user_rank\": 1\n        }]\n    }, {\n        \"repo_path\": \"cann-var-sequence-gemm\",\n        \"active\": {\n            \"huawei_user_merged_pr_count\": 0,\n            \"total_issue_count\": 0,\n            \"other_user_merged_pr_count\": 2,\n            \"open_pr_count\": 2,\n            \"open_issue_count\": 0,\n            \"huawei_user_count\": 0,\n            \"merged_pr_count\": 2,\n            \"total_pr_count\": 4,\n            \"other_user_count\": 1,\n            \"closed_issue_count\": 0\n        },\n        \"company\": null,\n        \"sort\": 16,\n        \"user\": [{\n            \"repo_path\": \"cann-var-sequence-gemm\",\n            \"user_login\": \"sxsyzpf\",\n            \"html_url\": \"https://gitee.com/sxsyzpf\",\n            \"avatar_url\": \"https://gitee.com/assets/no_portrait.png\",\n            \"merged_pr_incre\": 2,\n            \"user_rank\": 1\n        }]\n    }],\n    \"timestamp\": 1747965518405,\n    \"executeTime\": 47\n}",
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
      "name" : "start",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "topn",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "topn 必须为正整数且不超过 100",
      "expression" : "topn != null || (topn > 0 && topn <= 100)",
      "children" : [ ]
    } ]
  },
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
          "name" : "repo_path",
          "value" : "cann-var-sequence-gemm",
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
          "name" : "active",
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
            "name" : "huawei_user_merged_pr_count",
            "value" : "0",
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
            "name" : "total_issue_count",
            "value" : "0",
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
            "name" : "other_user_merged_pr_count",
            "value" : "2",
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
            "name" : "open_pr_count",
            "value" : "2",
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
            "name" : "open_issue_count",
            "value" : "0",
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
            "name" : "huawei_user_count",
            "value" : "0",
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
            "name" : "merged_pr_count",
            "value" : "2",
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
            "name" : "total_pr_count",
            "value" : "4",
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
            "name" : "other_user_count",
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
            "name" : "closed_issue_count",
            "value" : "0",
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
        }, {
          "name" : "company",
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
          "name" : "sort",
          "value" : "0",
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
          "name" : "user",
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
              "name" : "repo_path",
              "value" : "cann-var-sequence-gemm",
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
              "name" : "user_login",
              "value" : "sxsyzpf",
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
              "name" : "html_url",
              "value" : "https://gitee.com/sxsyzpf",
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
              "name" : "avatar_url",
              "value" : "https://gitee.com/assets/no_portrait.png",
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
              "name" : "merged_pr_incre",
              "value" : "2",
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
              "name" : "user_rank",
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
            } ]
          } ]
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1747879696754",
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
    } ]
  }
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 社区
var community = body.community.toLowerCase();
// topn
var topn = 10;
if (body.topn != null and body.topn != ""){
    topn = body.topn;
}
// 贡献表
var repoUserTable = "dws_" + community + "_contribute_repo_user_daily";
var repoCompanyTable = "dws_" + community + "_contribute_repo_company_daily";
var userTable = "fact_"+community+"_user";
var robotUserTable = "fact_community_robot_user";
var foridCompany = ['robot','个人贡献者'];
var repo_sql = """
    SELECT 
        repo_path
    FROM repository_configs
    where community = #{community} and display_status = 'visible';
""";
var repo_data = db.select(repo_sql);
ArrayList repoList = new ArrayList();
for(repo in repo_data){
    repoList.add(repo.get("repo_path"));
}
var active_sql = """
    SELECT 
        repo_path, internal,
        count(DISTINCT user_login) as user_count,
        sum(open_pr_incre) as open_pr_count,
        count(DISTINCT CASE WHEN open_pr_incre > 0 THEN user_login END) as open_pr_user_count,
        sum(merged_pr_incre) as merged_pr_count,
        count(DISTINCT CASE WHEN merged_pr_incre > 0 THEN user_login END) as merged_pr_user_count,
        sum(open_issue_incre) as open_issue_count,
        count(DISTINCT CASE WHEN open_issue_incre > 0 THEN user_login END) as open_issue_user_count,
        sum(closed_issue_incre) as closed_issue_count,
        count(DISTINCT CASE WHEN closed_issue_incre > 0 THEN user_login END) as closed_issue_user_count
    FROM ${repoUserTable} 
    where date::DATE BETWEEN #{start} AND #{end} and private = 'false' and repo_path in 
        <foreach item="repoItem" collection="repoList" separator="," open="(" close=")">
            #{repoItem}
        </foreach>
    GROUP BY repo_path, internal;
""";
var active_data = db.select(active_sql);
var user_sql = """
    WITH repo_user_stats AS (
        SELECT 
            ru.repo_path, ru.user_login,fu.html_url,fu.avatar_url,
            sum(ru.merged_pr_incre) as merged_pr_incre
        FROM 
            ${repoUserTable} ru
        left join ${userTable} fu on ru.user_login  = fu.user_login
        WHERE ru.date::DATE BETWEEN #{start} AND #{end} and ru.merged_pr_incre > 0 and ru.private = 'false' and ru.user_login not like '%.del'
            and ru.user_login not in (
                select user_login from ${robotUserTable}
            )
            and ru.repo_path in 
            <foreach item="repoItem" collection="repoList" separator="," open="(" close=")">
                #{repoItem}
            </foreach>
        GROUP BY ru.repo_path,ru.user_login,fu.html_url,fu.avatar_url
    ),
    ranked_users AS (
        SELECT 
            repo_path,
            user_login,
            html_url,
            avatar_url,
            merged_pr_incre,
            ROW_NUMBER() OVER (
                PARTITION BY repo_path 
                ORDER BY merged_pr_incre DESC
            ) AS user_rank
        FROM 
            repo_user_stats
    )
    SELECT 
        repo_path,
        user_login,
        html_url,
        avatar_url,
        merged_pr_incre,
        user_rank
    FROM 
        ranked_users
    WHERE 
        user_rank <= #{topn}
    ORDER BY 
        repo_path,
        user_rank;    
""";
var user_data = db.select(user_sql);
var company_sql = """
    WITH repo_company_stats AS (
        SELECT 
            repo_path, 
            company,
            SUM(merged_pr_incre) AS merged_pr_incre
        FROM 
            ${repoCompanyTable}
        WHERE 
            merged_pr_incre > 0 and private = 'false' and
            repo_path in 
            <foreach item="repoItem" collection="repoList" separator="," open="(" close=")">
                #{repoItem}
            </foreach> 
            and company not in 
            <foreach item="company" collection="foridCompany" separator="," open="(" close=")">
                #{company}
            </foreach>
        GROUP BY 
            repo_path, company
    ),
    ranked_companies AS (
        SELECT 
            repo_path,
            company,
            merged_pr_incre,
            ROW_NUMBER() OVER (
                PARTITION BY repo_path 
                ORDER BY merged_pr_incre DESC
            ) AS company_rank
        FROM 
            repo_company_stats
    )
    SELECT 
        repo_path,
        company,
        merged_pr_incre,
        company_rank
    FROM 
        ranked_companies
    WHERE 
        company_rank <= #{topn}
    ORDER BY 
        repo_path,
        company_rank;
""";
var company_data = db.select(company_sql);
HashMap activeMap = new HashMap();
for(active in active_data){
    var repo_path = active.get("repo_path");
    var huawei_user_count = 0;
    var huawei_user_merged_pr_count = 0;
    var other_user_count = 0;
    var other_user_merged_pr_count = 0;
    var open_pr_count = 0;
    var merged_pr_count = 0;
    var total_pr_count = 0;
    var open_issue_count = 0;
    var closed_issue_count = 0;
    var total_issue_count = 0;
    if (activeMap.containsKey(repo_path)){
        HashMap data = activeMap.get(repo_path);
        huawei_user_count = data.get("huawei_user_count");
        huawei_user_merged_pr_count = data.get("huawei_user_merged_pr_count");
        other_user_count = data.get("other_user_count");
        other_user_merged_pr_count = data.get("other_user_merged_pr_count");
        open_pr_count = data.get("open_pr_count");
        merged_pr_count = data.get("merged_pr_count");
        total_pr_count = data.get("total_pr_count");
        open_issue_count = data.get("open_issue_count");
        closed_issue_count = data.get("closed_issue_count");
        total_issue_count = data.get("total_issue_count");
    }
    if ("内部" == active.get("internal")){
        huawei_user_count += active.get("merged_pr_user_count");
        huawei_user_merged_pr_count += active.get("merged_pr_count");
        open_pr_count += active.get("open_pr_count");
        merged_pr_count += huawei_user_merged_pr_count;
        open_issue_count += active.get("open_issue_count");
        closed_issue_count += active.get("closed_issue_count");
    } else if ("外部" == active.get("internal")){
        other_user_count += active.get("merged_pr_user_count");
        other_user_merged_pr_count += active.get("merged_pr_count");
        open_pr_count += active.get("open_pr_count");
        merged_pr_count += other_user_merged_pr_count;
        open_issue_count += active.get("open_issue_count");
        closed_issue_count += active.get("closed_issue_count");
    }
    total_pr_count = open_pr_count + merged_pr_count;
    total_issue_count = open_issue_count + closed_issue_count;
    HashMap result = new HashMap();
    result.put("huawei_user_count", huawei_user_count);
    result.put("huawei_user_merged_pr_count", huawei_user_merged_pr_count);
    result.put("other_user_count", other_user_count);
    result.put("other_user_merged_pr_count", other_user_merged_pr_count);
    result.put("open_pr_count", open_pr_count);
    result.put("merged_pr_count", merged_pr_count);
    result.put("total_pr_count", total_pr_count);
    result.put("open_issue_count", open_issue_count);
    result.put("closed_issue_count", closed_issue_count);
    result.put("total_issue_count", total_issue_count);
    activeMap.put(active.get("repo_path"), result);
}
HashMap userMap = new HashMap();
for(user in user_data){
    var repo_path = user.get("repo_path");
    ArrayList userList = new ArrayList();
    if (userMap.containsKey(repo_path)){
        userList = userMap.get(repo_path);
    }
    userList.add(user);
    userMap.put(repo_path, userList);
}
HashMap companyMap = new HashMap();
for(company in company_data){
    var repo_path = company.get("repo_path");
    ArrayList companyList = new ArrayList();
    if (companyMap.containsKey(repo_path)){
        companyList = companyMap.get(repo_path);
    }
    companyList.add(company);
    companyMap.put(repo_path, companyList);
}
HashMap repoMap = new HashMap();
for(repo_path in repoList){
    HashMap dataMap = new HashMap();
    dataMap.put("repo_path",repo_path);
    dataMap.put("sort",repoList.indexOf(repo_path));
    dataMap.put("active",activeMap.get(repo_path));
    dataMap.put("user",userMap.get(repo_path));
    dataMap.put("company",companyMap.get(repo_path));
    repoMap.put(repo_path,dataMap)
}
return repoMap.values().sort((obj1,obj2) => obj1.sort - obj2.sort);

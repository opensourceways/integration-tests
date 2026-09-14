{
  "properties" : { },
  "id" : "copy1776671018439d70582",
  "script" : null,
  "groupId" : "ab0479c8f13442aeaeaec1caa410d2d2",
  "name" : "siginfo(复制)",
  "createTime" : null,
  "updateTime" : 1776672373925,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/one/{community}_copy",
  "method" : "GET",
  "parameters" : [ {
    "name" : "sigName",
    "value" : "MindSpore Core",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "sigName 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
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
  "paths" : [ {
    "name" : "community",
    "value" : "mindspore",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"repos\": [{\n            \"repo_name\": \"mindspore/mindspore\",\n            \"sig_name\": \"MindSpore Core\",\n            \"directory\": \"mindspore/ccsrc/backend,mindspore/ccsrc/cluster,mindspore/ccsrc/cmake,mindspore/ccsrc/frontend,mindspore/ccsrc/include,mindspore/ccsrc/minddata,mindspore/ccsrc/plugin,mindspore/ccsrc/pybind_api,mindspore/ccsrc/pynative,mindspore/ccsrc/runtime,mindspore/ccsrc/utils,mindspore/core,mindspore/include,mindspore/ops,mindspore/python/mindspore\",\n            \"namespace\": \"mindspore\",\n            \"repo_path\": \"mindspore\",\n            \"maintainers\": [{\n                \"user_login\": \"baochong1\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"baochong1\",\n                \"name\": \"baochong\",\n                \"email\": \"baochong@huawei.com\",\n                \"role\": \"maintainer\",\n                \"user_homepage_url\": \"https://atomgit.com/baochong1\"\n            }, {\n                \"user_login\": \"chujinjin\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"chujinjin\",\n                \"name\": \"chujinjin\",\n                \"email\": \"chujinjin52@huawei.com\",\n                \"role\": \"maintainer\",\n                \"user_homepage_url\": \"https://atomgit.com/chujinjin\"\n            }, {\n                \"user_login\": \"limingqi107\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"limingqi107\",\n                \"name\": \"limingqi\",\n                \"email\": \"limingqi@huawei.com\",\n                \"role\": \"maintainer\",\n                \"user_homepage_url\": \"https://atomgit.com/limingqi107\"\n            }, {\n                \"user_login\": \"ginFung\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"ginFung\",\n                \"name\": \"yujianfeng\",\n                \"email\": \"yujianfeng5@huawei.com\",\n                \"role\": \"maintainer\",\n                \"user_homepage_url\": \"https://atomgit.com/ginFung\"\n            }],\n            \"committers\": [{\n                \"user_login\": \"hwcaifubi\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"hwcaifubi\",\n                \"name\": \"caifubi\",\n                \"email\": \"caifubi1@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/hwcaifubi\"\n            }, {\n                \"user_login\": \"luochao60\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"luochao60\",\n                \"name\": \"luochao\",\n                \"email\": \"luochao60@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/luochao60\"\n            }, {\n                \"user_login\": \"zyli2020\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"zyli2020\",\n                \"name\": \"lizhenyu\",\n                \"email\": \"lizhenyu13@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/zyli2020\"\n            }, {\n                \"user_login\": \"zhangyinxia\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"zhangyinxia\",\n                \"name\": \"zhangyinxia\",\n                \"email\": \"zhangyinxia@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/zhangyinxia\"\n            }, {\n                \"user_login\": \"hbhb_bin\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"hbhb_bin\",\n                \"name\": \"hubin\",\n                \"email\": \"hubin79@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/hbhb_bin\"\n            }, {\n                \"user_login\": \"Margaret_wangrui\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"Margaret_wangrui\",\n                \"name\": \"wangrui\",\n                \"email\": \"wangrui178@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/Margaret_wangrui\"\n            }, {\n                \"user_login\": \"huangbingjian1\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"huangbingjian1\",\n                \"name\": \"huangbingjian\",\n                \"email\": \"huangbingjian1@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/huangbingjian1\"\n            }],\n            \"herf_link\": \"https://atomgit.com/mindspore/mindspore/tree/master/\"\n        }],\n        \"sigInfo\": {\n            \"name\": \"MindSpore Core\",\n            \"description\": \"MindSpore Core SIG（MindSpore基础框架开发SIG）专注于推动MindSpore基础能力完善稳定, 构建Mindpore的底层基础能力和基础表达，提供nn、数学等计算算子，自动微分，设备管理等功能，提供张量、模型等基础表达，以及动态图执行、静态图加速能力。\",\n            \"description_en\": \"The MindSpore Core SIG focuses on improving and stabilizing MindSpore's fundamental capabilities, building the underlying capabilities and basic representations of MindSpore, providing computational operators such as nn and  mathematical functions, providing automatic differentiation, device management and other functions, providing basic repesentations such as tensor and models, as well as dynamic graph execution and basic graph acceleration capabilities.\",\n            \"created_on\": \"2025-11-17\",\n            \"mailing_list\": \"dev@mindspore.cn\",\n            \"meeting_url\": \"NA\",\n            \"mature_level\": \"startup\",\n            \"mentors\": [{\n                \"atomgit_id\": \"baochong1\",\n                \"name\": \"baochong\",\n                \"organization\": \"Huawei\",\n                \"email\": \"baochong@huawei.com\"\n            }],\n            \"maintainers\": [{\n                \"user_login\": \"ginFung\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"ginFung\",\n                \"name\": \"yujianfeng\",\n                \"email\": \"yujianfeng5@huawei.com\",\n                \"role\": \"maintainer\",\n                \"user_homepage_url\": \"https://atomgit.com/ginFung\"\n            }, {\n                \"user_login\": \"limingqi107\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"limingqi107\",\n                \"name\": \"limingqi\",\n                \"email\": \"limingqi@huawei.com\",\n                \"role\": \"maintainer\",\n                \"user_homepage_url\": \"https://atomgit.com/limingqi107\"\n            }, {\n                \"user_login\": \"chujinjin\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"chujinjin\",\n                \"name\": \"chujinjin\",\n                \"email\": \"chujinjin52@huawei.com\",\n                \"role\": \"maintainer\",\n                \"user_homepage_url\": \"https://atomgit.com/chujinjin\"\n            }, {\n                \"user_login\": \"baochong1\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"baochong1\",\n                \"name\": \"baochong\",\n                \"email\": \"baochong@huawei.com\",\n                \"role\": \"maintainer\",\n                \"user_homepage_url\": \"https://atomgit.com/baochong1\"\n            }],\n            \"repositories\": [{\n                \"repo\": [\"mindspore/mindspore\"],\n                \"directory\": [\"mindspore/ccsrc/backend\", \"mindspore/ccsrc/cluster\", \"mindspore/ccsrc/cmake\", \"mindspore/ccsrc/frontend\", \"mindspore/ccsrc/include\", \"mindspore/ccsrc/minddata\", \"mindspore/ccsrc/plugin\", \"mindspore/ccsrc/pybind_api\", \"mindspore/ccsrc/pynative\", \"mindspore/ccsrc/runtime\", \"mindspore/ccsrc/utils\", \"mindspore/core\", \"mindspore/include\", \"mindspore/ops\", \"mindspore/python/mindspore\"],\n                \"repo_admin\": [{\n                    \"atomgit_id\": \"chujinjin\",\n                    \"name\": \"chujinjin\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"chujinjin52@huawei.com\",\n                    \"user_login\": \"chujinjin\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/chujinjin\"\n                }, {\n                    \"atomgit_id\": \"limingqi107\",\n                    \"name\": \"limingqi\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"limingqi@huawei.com\",\n                    \"user_login\": \"limingqi107\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/limingqi107\"\n                }, {\n                    \"atomgit_id\": \"ginFung\",\n                    \"name\": \"yujianfeng\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"yujianfeng5@huawei.com\",\n                    \"user_login\": \"ginFung\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/ginFung\"\n                }],\n                \"committers\": [{\n                    \"atomgit_id\": \"hwcaifubi\",\n                    \"name\": \"caifubi\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"caifubi1@huawei.com\",\n                    \"user_login\": \"hwcaifubi\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/hwcaifubi\"\n                }, {\n                    \"atomgit_id\": \"luochao60\",\n                    \"name\": \"luochao\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"luochao60@huawei.com\",\n                    \"user_login\": \"luochao60\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/luochao60\"\n                }, {\n                    \"atomgit_id\": \"zyli2020\",\n                    \"name\": \"lizhenyu\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"lizhenyu13@huawei.com\",\n                    \"user_login\": \"zyli2020\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/zyli2020\"\n                }, {\n                    \"atomgit_id\": \"zhangyinxia\",\n                    \"name\": \"zhangyinxia\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"zhangyinxia@huawei.com\",\n                    \"user_login\": \"zhangyinxia\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/zhangyinxia\"\n                }, {\n                    \"atomgit_id\": \"hbhb_bin\",\n                    \"name\": \"hubin\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"hubin79@huawei.com\",\n                    \"user_login\": \"hbhb_bin\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/hbhb_bin\"\n                }, {\n                    \"atomgit_id\": \"Margaret_wangrui\",\n                    \"name\": \"wangrui\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"wangrui178@huawei.com\",\n                    \"user_login\": \"Margaret_wangrui\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/Margaret_wangrui\"\n                }, {\n                    \"atomgit_id\": \"huangbingjian1\",\n                    \"name\": \"huangbingjian\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"huangbingjian1@huawei.com\",\n                    \"user_login\": \"huangbingjian1\",\n                    \"id_platform\": \"atomgit_id\",\n                    \"user_homepage_url\": \"https://atomgit.com/huangbingjian1\"\n                }],\n                \"contributors\": [{\n                    \"atomgit_id\": \"pengqihw\",\n                    \"name\": \"pengqi\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"pengqi33@huawei.com\"\n                }, {\n                    \"atomgit_id\": \"maoyuanpeng1\",\n                    \"name\": \"maoyuanpeng\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"maoyuanpeng@huawei.com\"\n                }, {\n                    \"atomgit_id\": \"gaoyong10\",\n                    \"name\": \"gaoyong\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"gaoyong10@huawei.com\"\n                }]\n            }],\n            \"committers\": [{\n                \"user_login\": \"Margaret_wangrui\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"Margaret_wangrui\",\n                \"name\": \"wangrui\",\n                \"email\": \"wangrui178@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/Margaret_wangrui\"\n            }, {\n                \"user_login\": \"zyli2020\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"zyli2020\",\n                \"name\": \"lizhenyu\",\n                \"email\": \"lizhenyu13@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/zyli2020\"\n            }, {\n                \"user_login\": \"hwcaifubi\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"hwcaifubi\",\n                \"name\": \"caifubi\",\n                \"email\": \"caifubi1@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/hwcaifubi\"\n            }, {\n                \"user_login\": \"hbhb_bin\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"hbhb_bin\",\n                \"name\": \"hubin\",\n                \"email\": \"hubin79@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/hbhb_bin\"\n            }, {\n                \"user_login\": \"zhangyinxia\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"zhangyinxia\",\n                \"name\": \"zhangyinxia\",\n                \"email\": \"zhangyinxia@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/zhangyinxia\"\n            }, {\n                \"user_login\": \"huangbingjian1\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"huangbingjian1\",\n                \"name\": \"huangbingjian\",\n                \"email\": \"huangbingjian1@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/huangbingjian1\"\n            }, {\n                \"user_login\": \"luochao60\",\n                \"gitee_id\": null,\n                \"atomgit_id\": \"luochao60\",\n                \"name\": \"luochao\",\n                \"email\": \"luochao60@huawei.com\",\n                \"role\": \"committer\",\n                \"user_homepage_url\": \"https://atomgit.com/luochao60\"\n            }]\n        }\n    },\n    \"timestamp\": 1776672360631,\n    \"executeTime\": 10\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import java.lang.reflect.Array
var community_temp = community
var sigName = sigName
if("mindspore".equals(community_temp)){
  community_temp = "mindsporeatomgit";
}
// var sigSql = """select * from fact_${community}_siginfo_sigs""";
var sigSql = """select * from fact_${community_temp}_sig_detail_info where sig_name=#{sigName} and is_removed is null""";
var sigs = db.selectOne(sigSql);
var sig_name = sigs.get("sig_name");
var sig_content = sigs.get("sig_json")::json;
var  sigUsers = db.select("""select distinct user_login,gitee_id,atomgit_id,user_name as name,email,role,user_homepage_url from fact_${community_temp}_sig_user where sig_name=#{sig_name}  and is_removed is null """);
if (sigUsers!=null && sigUsers.size()>0){
    var userListMap = sigUsers.group(item=>item.role);
    sig_content.put("maintainers",userListMap.getOrDefault("maintainer",new ArrayList()));
    sig_content.put("committers",userListMap.getOrDefault("committer",new ArrayList()));
}
var repoSql = """ select a.repo_name,a.sig_name,b.directory,a.namespace,a.repo_path from (
select distinct concat(namespace,'/',repo_path) as repo_name,sig_name,namespace,repo_path from fact_${community_temp}_sig_user)
a LEFT JOIN fact_${community_temp}_sig_repo_dirctory b on a.repo_name=b.repo_name and a.sig_name=b.sig_name where a.sig_name=#{sig_name}
""";
var repos = db.select(repoSql);
for(repo in repos){
    var repsName = repo.get("repo_name");
    var namespace = repo.get("namespace");
    var repo_path = repo.get("repo_path");
    var users = db.select("""select user_login,gitee_id,atomgit_id,user_name as name,email,role,user_homepage_url from fact_${community_temp}_sig_user where repo_path=#{repo_path} and namespace=#{namespace} and sig_name=#{sigName}""")
    var usermap = users.group((item)=>item.role);
    repo.put("maintainers",usermap.getOrDefault("maintainer",new ArrayList()));
    repo.put("committers",usermap.getOrDefault("committer",new ArrayList()));
    String link = "";
    if(repsName.startsWith("/mindspore/mindspore")){
        link = "https://atomgit.com/mindspore/mindspore/tree/master/"+repsName.replaceFirst("/mindspore/mindspore","");
    }else if (repsName.startsWith("mindspore/mindspore")){
        link = "https://atomgit.com/mindspore/mindspore/tree/master/"+repsName.replaceFirst("mindspore/mindspore","");
    }else{
        link = "https://atomgit.com/"+repsName;    
    } 
    repo.put("herf_link",link)
}
HashMap res = new HashMap();
res.put("sigInfo",sig_content);
res.put("repos",repos);
return res

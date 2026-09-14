{
  "properties" : { },
  "id" : "eed30567c9c44122918d1a0686624d07",
  "script" : null,
  "groupId" : "ab0479c8f13442aeaeaec1caa410d2d2",
  "name" : "siginfo",
  "createTime" : null,
  "updateTime" : 1776774013585,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/one/{community}",
  "method" : "GET",
  "parameters" : [ {
    "name" : "sigName",
    "value" : "MindSpore Transformers",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"repos\": [{\n            \"repo_name\": \"mindspore/mindformers\",\n            \"sig_name\": \"MindSpore Transformers\",\n            \"directory\": null,\n            \"namespace\": \"mindspore\",\n            \"repo_path\": \"mindformers\",\n            \"maintainers\": [{\n                \"gitee_id\": \"Lin-Bert\",\n                \"name\": \"He Qinglin\",\n                \"email\": \"heqinglin4@huawei.com\",\n                \"role\": \"maintainer\"\n            }, {\n                \"gitee_id\": \"suhaibo\",\n                \"name\": \"Su Haibo\",\n                \"email\": \"suhaibo1@huawei.com\",\n                \"role\": \"maintainer\"\n            }],\n            \"committers\": [{\n                \"gitee_id\": \"hss-shuai\",\n                \"name\": \"Huang Shengshuai\",\n                \"email\": \"huangshengshuai@huawei.com\",\n                \"role\": \"committer\"\n            }, {\n                \"gitee_id\": \"renyujin\",\n                \"name\": \"Ren Yujin\",\n                \"email\": \"renyujin1@huawei.com\",\n                \"role\": \"committer\"\n            }, {\n                \"gitee_id\": \"chenrayray\",\n                \"name\": \"Chen Xinrui\",\n                \"email\": \"chenxinrui11@huawei.com\",\n                \"role\": \"committer\"\n            }, {\n                \"gitee_id\": \"zyw-hw\",\n                \"name\": \"zhang Youwen\",\n                \"email\": \"zhangyouwen7@huawei.com\",\n                \"role\": \"committer\"\n            }],\n            \"herf_link\": \"https://gitee.com/mindspore/mindformers\"\n        }],\n        \"sigInfo\": {\n            \"name\": \"MindSpore Transformers\",\n            \"description\": \"MindSpore Transformers SIG（Special Interest Group）是 MindSpore 开源社区下聚焦 Transformer 类大模型全流程开发与优化的技术团队，涵盖大模型的预训练、微调、推理与部署等关键环节。SIG 团队致力于提升 Transformer类大模型在性能与易用性方面的表现，推动其在实际场景中的高效应用与落地。\",\n            \"description_en\": \"The MindSpore Transformers SIG (Special Interest Group) is a technical team under the MindSpore open-source community that focuses on the end-to-end development and optimization of Transformer-based large models, covering key stages such as pre-training, fine-tuning, inference, and deployment. The SIG team is dedicated to enhancing the performance and usability of Transformer-based large models, promoting their efficient application and implementation in real-world scenarios.\",\n            \"mailing_list\": \"dev@mindspore.cn\",\n            \"maintainers\": [{\n                \"gitee_id\": \"Lin-Bert\",\n                \"name\": \"He Qinglin\",\n                \"email\": \"heqinglin4@huawei.com\",\n                \"role\": \"maintainer\"\n            }, {\n                \"gitee_id\": \"suhaibo\",\n                \"name\": \"Su Haibo\",\n                \"email\": \"suhaibo1@huawei.com\",\n                \"role\": \"maintainer\"\n            }],\n            \"repositories\": [{\n                \"repo\": [\"mindspore/mindformers\"],\n                \"repo-admin\": [{\n                    \"gitee_id\": \"Lin-Bert\",\n                    \"name\": \"He Qinglin\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"heqinglin4@huawei.com\"\n                }, {\n                    \"gitee_id\": \"suhaibo\",\n                    \"name\": \"Su Haibo\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"suhaibo1@huawei.com\"\n                }],\n                \"committers\": [{\n                    \"gitee_id\": \"hss-shuai\",\n                    \"name\": \"Huang Shengshuai\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"huangshengshuai@huawei.com\"\n                }, {\n                    \"gitee_id\": \"renyujin\",\n                    \"name\": \"Ren Yujin\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"renyujin1@huawei.com\"\n                }, {\n                    \"gitee_id\": \"chenrayray\",\n                    \"name\": \"Chen Xinrui\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"chenxinrui11@huawei.com\"\n                }, {\n                    \"gitee_id\": \"zyw-hw\",\n                    \"name\": \"zhang Youwen\",\n                    \"organization\": \"Huawei\",\n                    \"email\": \"zhangyouwen7@huawei.com\"\n                }]\n            }],\n            \"committers\": [{\n                \"gitee_id\": \"chenrayray\",\n                \"name\": \"Chen Xinrui\",\n                \"email\": \"chenxinrui11@huawei.com\",\n                \"role\": \"committer\"\n            }, {\n                \"gitee_id\": \"hss-shuai\",\n                \"name\": \"Huang Shengshuai\",\n                \"email\": \"huangshengshuai@huawei.com\",\n                \"role\": \"committer\"\n            }, {\n                \"gitee_id\": \"renyujin\",\n                \"name\": \"Ren Yujin\",\n                \"email\": \"renyujin1@huawei.com\",\n                \"role\": \"committer\"\n            }, {\n                \"gitee_id\": \"zyw-hw\",\n                \"name\": \"zhang Youwen\",\n                \"email\": \"zhangyouwen7@huawei.com\",\n                \"role\": \"committer\"\n            }]\n        }\n    },\n    \"timestamp\": 1776672619289,\n    \"executeTime\": 12\n}",
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

{
  "properties" : { },
  "id" : "copy1778470277382d16476",
  "script" : null,
  "groupId" : "1a7a4bd8439c447daf274fc1b6f280f1",
  "name" : "查看检查数据",
  "createTime" : null,
  "updateTime" : 1778572448209,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/query/check",
  "method" : "GET",
  "parameters" : [ {
    "name" : "platform",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
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
  }, {
    "name" : "permission",
    "value" : "datastatwhitebox_view",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"id\": \"8956546900cfea5677fb8a577939f0aa3f314b1d\",\n        \"repo\": \"opensourceways/om-dataarts\",\n        \"type\": \"commit\",\n        \"msg\": \"数据已经采集，请耐心等待，约1天左右或自动同步到塔台\",\n        \"user_login\": null,\n        \"created_at\": \"2025-11-04 15:13:36\"\n    }, {\n        \"id\": \"1e355811800d2e574c4fe1d3f1e601d77bc1f8aa\",\n        \"repo\": \"opensourceways/om-dataart\",\n        \"type\": \"commit\",\n        \"msg\": \"未采集到数据，请确认代码分支是否再采集范围\",\n        \"user_login\": null,\n        \"created_at\": \"2025-11-04 14:51:25\"\n    }, {\n        \"id\": \"0c02f8f9937cfc0bc547dc40ac81b4145bdbe6ab\",\n        \"repo\": \"UBSCore/DistFileCache\",\n        \"type\": \"commit\",\n        \"msg\": \"未采集到数据，请确认代码分支是否再采集范围\",\n        \"user_login\": null,\n        \"created_at\": \"2025-11-04 14:45:43\"\n    }, {\n        \"id\": \"eab28f62ee60070542a73797eb0ce2c08e71750e\",\n        \"repo\": \"ascend/MindIE-LLM\",\n        \"type\": \"commit\",\n        \"msg\": \"该commit的提交邮箱为zhongyuanke@huawei.com，该邮箱未在塔台上配置，请在塔台页面 https://tatai.rnd.huawei.com/index.html#/mcCenter/mcCodeTips/blueZone/blueZoneCodeConfig 配置, 配置文档详见：https://wiki.huawei.com/domains/6240/wiki/16631/WIKI202312262626776\",\n        \"user_login\": null,\n        \"created_at\": \"2025-09-12 09:47:23\"\n    }, {\n        \"id\": \"eab28f62ee60070542a73797eb0ce2c08e71750e\",\n        \"repo\": \"ascend/MindIE-LLM\",\n        \"type\": \"commit\",\n        \"msg\": \"该commit的提交邮箱为zhongyuanke@huawei.com，该邮箱未在塔台上配置，请在塔台页面 https://tatai.rnd.huawei.com/index.html#/mcCenter/mcCodeTips/blueZone/blueZoneCodeConfig 配置, 配置文档详见：https://wiki.huawei.com/domains/6240/wiki/16631/WIKI202312262626776\",\n        \"user_login\": null,\n        \"created_at\": \"2025-09-11 22:19:09\"\n    }, {\n        \"id\": \"eab28f62ee6007054a73797eb0ce2c08e71750e\",\n        \"repo\": \"ascend/MindIE-LLM\",\n        \"type\": \"commit\",\n        \"msg\": \"未查询到数据，请检查仓库或commit_id是否正确\",\n        \"user_login\": null,\n        \"created_at\": \"2025-09-11 22:00:26\"\n    }, {\n        \"id\": \"eab28f62ee6007054a73797eb0ce2c08e71750e\",\n        \"repo\": \"aisbench/benchmark\",\n        \"type\": \"commit\",\n        \"msg\": \"未查询到数据，请检查仓库或commit_id是否正确\",\n        \"user_login\": null,\n        \"created_at\": \"2025-09-11 21:58:46\"\n    }, {\n        \"id\": \"46314389\",\n        \"repo\": \"aisbench/benchmark\",\n        \"type\": \"comment\",\n        \"msg\": \"仓库aisbench/benchmark中的comment数据:46314389数据已经采集，请在塔台确认数据是否已经同步\",\n        \"user_login\": null,\n        \"created_at\": \"2025-09-11 19:55:35\"\n    }, {\n        \"id\": \"48\",\n        \"repo\": \"opensourceway/om-data\",\n        \"type\": \"pr\",\n        \"msg\": \"该pr:48数据已经采集，请在塔台确认数据是否已经同步\",\n        \"user_login\": null,\n        \"created_at\": \"2025-09-11 19:51:31\"\n    }, {\n        \"id\": \"3204006107\",\n        \"repo\": \"opensourceways/app-cla-server\",\n        \"type\": \"comment\",\n        \"msg\": \"该comment:3204006107数据已经采集，请在塔台确认数据是否已经同步\",\n        \"user_login\": null,\n        \"created_at\": \"2025-09-11 19:34:49\"\n    }],\n    \"timestamp\": 1778470608246,\n    \"executeTime\": 3\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import org.ssssssss.script.parsing.ast.statement.Return


var platform_tem = platform
var repo_tem = repo


var sql = """ 

select id,repo,type,msg,user_login,created_at from fact_whitebox_check 

where 
    1=1
                    <if test="platform_tem != null and platform_tem!='' ">
                         and   platform = #{platform_tem}
                    </if> 
                     <if test="repo_tem != null and repo_tem!='' ">
                          and  lower(repo) =lower(#{repo_tem})
                    </if>  
                 

  order by created_at desc limit 10 """

return db.select(sql)
{
  "properties" : { },
  "id" : "6209072d64e7427d833fe19a83b1b0a4",
  "script" : null,
  "groupId" : "fee87ad3dfde4e33b4dd4bc0eb95ce14",
  "name" : "服务列表",
  "createTime" : null,
  "updateTime" : 1743234175995,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/list",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"community\":\"openUBMC\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"uuid\": \"2\",\n        \"community\": \"openUBMC\",\n        \"source\": \"meeting\",\n        \"describe\": \"线上会议\"\n    }, {\n        \"uuid\": \"1\",\n        \"community\": \"openUBMC\",\n        \"source\": \"email\",\n        \"describe\": \"邮件\"\n    }],\n    \"timestamp\": 1743234038010,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var community = body.community;
var sql = """
select 
    source, describe
from fact_source
where community = #{community}
"""
return db.select(sql)

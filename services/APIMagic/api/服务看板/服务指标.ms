{
  "properties" : { },
  "id" : "b9d57af3e3764f1483df663a422b1066",
  "script" : null,
  "groupId" : "fee87ad3dfde4e33b4dd4bc0eb95ce14",
  "name" : "服务指标",
  "createTime" : null,
  "updateTime" : 1773827643367,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/metirc",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n    \"community\":\"openUBMC\",\r\n    \"sourceList\":[]\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"source\": \"meeting\",\n        \"describe\": \"线上会议\",\n        \"metric\": \"email_count\",\n        \"metric_desc\": \"邮件个数\"\n    }, {\n        \"source\": \"meeting\",\n        \"describe\": \"线上会议\",\n        \"metric\": \"email_subject_count\",\n        \"metric_desc\": \"邮件Topic个数\"\n    }, {\n        \"source\": \"meeting\",\n        \"describe\": \"线上会议\",\n        \"metric\": \"list_count\",\n        \"metric_desc\": \"邮件列表个数\"\n    }, {\n        \"source\": \"meeting\",\n        \"describe\": \"线上会议\",\n        \"metric\": \"subscribe_count\",\n        \"metric_desc\": \"订阅人数\"\n    }, {\n        \"source\": \"email\",\n        \"describe\": \"邮件\",\n        \"metric\": \"meeting_count\",\n        \"metric_desc\": \"会议个数\"\n    }, {\n        \"source\": \"email\",\n        \"describe\": \"邮件\",\n        \"metric\": \"meeting_duration\",\n        \"metric_desc\": \"会议时长\"\n    }, {\n        \"source\": \"email\",\n        \"describe\": \"邮件\",\n        \"metric\": \"participant_count\",\n        \"metric_desc\": \"参会人数\"\n    }, {\n        \"source\": \"email\",\n        \"describe\": \"邮件\",\n        \"metric\": \"sig_count\",\n        \"metric_desc\": \"开会SIG数\"\n    }],\n    \"timestamp\": 1743234364638,\n    \"executeTime\": 4\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// 社区
var community = body.community;
// 服务列表: email / meeting
var sourceList = body.sourceList;
var sql = """
select 
    fs.source, fs.describe, fsm.metric, fsm.metric_desc
from fact_source fs
left join fact_source_metric fsm on fs.uuid = fsm.source_id
where community = #{community}
<if test="sourceList != null and sourceList.size() > 0">
    and fs.source in
    <foreach collection="sourceList" item="item" open="(" separator="," close=")">
        #{item}
    </foreach>
</if>
"""
return db.select(sql)

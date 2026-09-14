{
  "properties" : { },
  "id" : "copy1744273190946d97950",
  "script" : null,
  "groupId" : "a722ad28731b4662827d7142c054a3d7",
  "name" : "comment贡献详情",
  "createTime" : null,
  "updateTime" : 1774580117209,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/comment/detail",
  "method" : "GET",
  "parameters" : [ {
    "name" : "user",
    "value" : "georgecao",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "user 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]+$",
    "children" : null
  }, {
    "name" : "page",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : "page 必须大于 0",
    "expression" : "page > 0",
    "children" : null
  }, {
    "name" : "pageSize",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "10",
    "validateType" : "expression",
    "error" : "pageSize 必须在 1-100 之间",
    "expression" : "pageSize > 0 && pageSize <= 100",
    "children" : null
  }, {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^(openeuler|opengauss|mindspore|openubmc|openfuyao)$",
    "children" : null
  }, {
    "name" : "sig",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "sig 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "comment_type",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "comment_type 参数非法",
    "expression" : "^(command|normal)?$",
    "children" : null
  }, {
    "name" : "timeRange",
    "value" : "lasthalfyear",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "all",
    "validateType" : "pattern",
    "error" : "timeRange 参数非法",
    "expression" : "^(all|lastonemonth|lasthalfyear|lastoneyear)?$",
    "children" : null
  }, {
    "name" : "filter",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : "",
    "expression" : "",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/community\",\n        \"time\": \"2026-03-25 15:01:23\",\n        \"url\": \"https://gitcode.com/openeuler/community/merge_requests/7184#tid-166348119\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"7184\"\n    }, {\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/agent-skills\",\n        \"time\": \"2026-03-25 11:04:15\",\n        \"url\": \"https://gitcode.com/openeuler/agent-skills/merge_requests/14#tid-166318464\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"14\"\n    }, {\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/community\",\n        \"time\": \"2026-03-23 15:26:50\",\n        \"url\": \"https://gitcode.com/openeuler/community/merge_requests/7185#tid-166086525\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"7185\"\n    }, {\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/community\",\n        \"time\": \"2026-03-20 10:05:41\",\n        \"url\": \"https://gitcode.com/openeuler/community/merge_requests/7180#tid-165840392\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"7180\"\n    }, {\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/agent-skills\",\n        \"time\": \"2026-03-17 16:34:40\",\n        \"url\": \"https://gitcode.com/openeuler/agent-skills/merge_requests/13#tid-165517693\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"13\"\n    }, {\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/cve-manager\",\n        \"time\": \"2026-03-17 16:27:39\",\n        \"url\": \"https://gitcode.com/openeuler/cve-manager/merge_requests/481#tid-165516042\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"481\"\n    }, {\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/agent-skills\",\n        \"time\": \"2026-03-17 15:05:11\",\n        \"url\": \"https://gitcode.com/openeuler/agent-skills/merge_requests/12#tid-165497787\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"12\"\n    }, {\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/agent-skills\",\n        \"time\": \"2026-03-12 20:21:32\",\n        \"url\": \"https://gitcode.com/openeuler/agent-skills/merge_requests/9#tid-165104036\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"9\"\n    }, {\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/agent-skills\",\n        \"time\": \"2026-03-12 20:08:16\",\n        \"url\": \"https://gitcode.com/openeuler/agent-skills/merge_requests/8#tid-165101327\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"8\"\n    }, {\n        \"info\": \"/lgtm\\n/approve\",\n        \"repo\": \"openeuler/agent-skills\",\n        \"time\": \"2026-03-12 17:35:23\",\n        \"url\": \"https://gitcode.com/openeuler/agent-skills/merge_requests/7#tid-165081011\",\n        \"is_invalid_comment\": 1,\n        \"no\": \"7\"\n    }],\n    \"timestamp\": 1774579229362,\n    \"executeTime\": 10\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
filter = filter != null ? filter.toLowerCase() : filter
var off = (page - 1) * pageSize
if (timeRange == 'lastonemonth') {
    timeRange = '1 months'
} else if (timeRange == 'lastoneyear') {
    timeRange = '1 years'
} else if (timeRange == 'lasthalfyear') {
    timeRange = '6 months'
}
var sqlstr = """
SELECT body as info,
       CONCAT(namespace,'/',repo_path) as repo,
       created_at as time,
       html_url as url,
       is_invalid_comment,
       split_part(tag_url, '/',-1) as no
FROM dws_${community}_contribute
WHERE
    user_login = #{user} AND contrib_type='comment' AND is_removed IS NULL 
        <if test="sig != null and sig != ''">
            AND #{sig} = ANY(sig_name)
        </if>
        <if test="comment_type == 'command'">
            AND is_invalid_comment = 1
        </if>
        <if test="comment_type == 'normal'">
            AND is_invalid_comment = 0
        </if>
        <if test="timeRange != 'all' and timeRange != null">
            AND created_at >= (CURRENT_DATE - #{timeRange}::interval) AT TIME ZONE 'Asia/Shanghai'
        </if>
        <if test="filter != '' and filter != null">
            AND lower(body) like concat('%',#{filter},'%')
        </if>
ORDER BY time desc
LIMIT #{pageSize} OFFSET #{off};
"""
var resp = db.select(sqlstr)
return resp

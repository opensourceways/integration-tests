{
  "properties" : { },
  "id" : "d8d0a92f968e4f4cb07bc26eb8efae3a",
  "script" : null,
  "groupId" : "10e2710a382e42ef81f33c984351995e",
  "name" : "开源项目数据",
  "createTime" : null,
  "updateTime" : 1775026636518,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "starfork",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\"projects\":[\"openharmony\",\"openeuler\",\"cann\",\"cantian\",\"mindspore\",\"openfuyao\",\"openjiuwen\",\"volcano\",\"a-tune\",\"opengauss\",\"cangjie\",\"isulad\"]}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"commits\": 1124,\n        \"stars\": 400,\n        \"fork\": 261,\n        \"project\": \"A-Tune\"\n    }, {\n        \"commits\": 6134,\n        \"stars\": 189,\n        \"fork\": 352,\n        \"project\": \"Cantian\"\n    }, {\n        \"commits\": 435707,\n        \"stars\": 3483,\n        \"fork\": 21625,\n        \"project\": \"Cangjie\"\n    }, {\n        \"commits\": 7022001,\n        \"stars\": 2119,\n        \"fork\": 30529,\n        \"project\": \"openharmony\"\n    }, {\n        \"commits\": 2455,\n        \"stars\": 6352,\n        \"fork\": 1742,\n        \"project\": \"openJiuwen\"\n    }, {\n        \"commits\": 402271,\n        \"stars\": 30892,\n        \"fork\": 16926,\n        \"project\": \"mindspore\"\n    }, {\n        \"commits\": 435707,\n        \"stars\": 3483,\n        \"fork\": 21625,\n        \"project\": \"cangjie\"\n    }, {\n        \"commits\": 13947,\n        \"stars\": 551,\n        \"fork\": 430,\n        \"project\": \"iSulad\"\n    }, {\n        \"commits\": 6399,\n        \"stars\": 5408,\n        \"fork\": 1314,\n        \"project\": \"volcano\"\n    }, {\n        \"commits\": 10948154,\n        \"stars\": 16703,\n        \"fork\": 111030,\n        \"project\": \"openeuler\"\n    }, {\n        \"commits\": 231703,\n        \"stars\": 194,\n        \"fork\": 843,\n        \"project\": \"openFuyao\"\n    }, {\n        \"commits\": 106651,\n        \"stars\": 444,\n        \"fork\": 1555,\n        \"project\": \"openGauss\"\n    }],\n    \"timestamp\": 1775026635498,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
projects = body.projects
projects = projects.map(it => it.toLowerCase())
var sqlstr = """
SELECT sum(commits_count) as commits,
       sum(stargazers_count) as stars,
       sum(forks_count) as fork,
       project
FROM fact_project_swf
WHERE
    lower(project) IN(#{projects})
GROUP BY project;
"""
var resp = db.select(sqlstr)
return resp

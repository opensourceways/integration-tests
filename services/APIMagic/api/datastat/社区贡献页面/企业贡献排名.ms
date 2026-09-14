{
  "properties" : { },
  "id" : "cdb10fb1f05f4b16aa6836a15cec7ff4",
  "script" : null,
  "groupId" : "255c725fcfdc48e79d405687c1e61f10",
  "name" : "企业贡献排名",
  "createTime" : null,
  "updateTime" : 1773908045919,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/company/contribute",
  "method" : "GET",
  "parameters" : [ {
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
    "name" : "repo",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "repo 格式非法",
    "expression" : "^[a-zA-Z0-9_/-]*$",
    "children" : null
  }, {
    "name" : "contributeType",
    "value" : "pr",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "contributeType 参数非法",
    "expression" : "^(pr|issue|comment)$",
    "children" : null
  }, {
    "name" : "timeRange",
    "value" : "all",
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
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1773907893730,\n    \"executeTime\": 5\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
contributeType = contributeType.toLowerCase()
var coreRepo = ['openGauss-server','CBB','DCF','DCC','DMS','openGauss-OM','CM','DSS']
sum_field = contributeType == 'pr' ? `merged_pr_count_${timeRange}` : `${contributeType}_count_${timeRange}`
var independent = '个人贡献者'
var internal = '内部'
var internal_company = '华为技术有限公司'
var sqlstr = """
with company_info AS(
    SELECT 
        focc.company, COALESCE(dci.company_zh, focc.company) AS company_zh, COALESCE(dci.company_en, focc.company) AS company_en, dci.alias_name 
    FROM 
        fact_${community}_cla_company focc
    LEFT JOIN 
        dim_company_info dci 
    ON (focc.company = dci.company_zh OR focc.company = dci.company_en or focc.company = dci.alias_name)
    UNION ALL
    SELECT '${independent}', '${independent}', 'independent', '${independent}'
),
filtered_contributions AS (
    SELECT 
        CASE 
            WHEN internal = '${internal}' THEN '${internal_company}'
            ELSE company 
        END AS company,
        sum(${sum_field}) as contribute
    FROM 
        ads_${community}_repo_user_stat  
    WHERE 
        company <> 'robot'
            <if test="community == 'opengauss'">
                AND repo_path <> 'practice-course'
            </if>
            <if test="repo == 'coreRepo' and coreRepo.size() > 0">
                AND repo_path IN
                <foreach collection="coreRepo" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
            <elseif test="repo != null and repo != ''">
                AND repo_path = #{repo}
            </elseif>
    GROUP BY CASE WHEN internal = '${internal}' THEN '${internal_company}' ELSE company END
)
SELECT 
    c.company_zh AS company_zh,
    c.company_en AS company_en,
    a.contribute
FROM 
    company_info c
LEFT JOIN 
    filtered_contributions a
    ON (a.company = c.company OR a.company = c.company_zh OR a.company = c.company_en or a.company = c.alias_name)
WHERE a.company is not null
GROUP BY 
    c.company_zh, c.company_en, a.contribute
ORDER BY 
    a.contribute DESC;"""
var resp = db.select(sqlstr)
return resp

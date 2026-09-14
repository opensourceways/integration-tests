{
  "properties" : { },
  "id" : "d165df1ce41f4d0c897ee03542cfa2d1",
  "script" : null,
  "groupId" : "255c725fcfdc48e79d405687c1e61f10",
  "name" : "企业版本贡献",
  "createTime" : null,
  "updateTime" : 1769390744065,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/version/company/contribute",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
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
    "name" : "contributeType",
    "value" : "",
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
    "name" : "version",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "version 格式非法",
    "expression" : "^[a-zA-Z0-9_.-]*$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"company_zh\": \"华为技术有限公司\",\n        \"company_en\": \"Huawei Technologies Co., Ltd.\",\n        \"contribute\": 1603\n    }, {\n        \"company_zh\": \"个人贡献者\",\n        \"company_en\": \"independent\",\n        \"contribute\": 691\n    }, {\n        \"company_zh\": \"麒麟软件有限公司\",\n        \"company_en\": \"Kylinsoft Co., Ltd.\",\n        \"contribute\": 600\n    }, {\n        \"company_zh\": \"粤港澳大湾区（广东）国创中心\",\n        \"company_en\": \"粤港澳大湾区（广东）国创中心\",\n        \"contribute\": 434\n    }, {\n        \"company_zh\": \"统信软件技术有限公司\",\n        \"company_en\": \"UnionTech Software Technology Co., Ltd.\",\n        \"contribute\": 389\n    }, {\n        \"company_zh\": \"中国科学院软件研究所\",\n        \"company_en\": \"Institute of Software, Chinese Academy of Sciences\",\n        \"contribute\": 104\n    }, {\n        \"company_zh\": \"北京奥思维科技有限公司\",\n        \"company_en\": \"北京奥思维科技有限公司\",\n        \"contribute\": 40\n    }, {\n        \"company_zh\": \"湖南麒麟信安科技股份有限公司\",\n        \"company_en\": \"Hunan Kylinsec Technology Co., Ltd.\",\n        \"contribute\": 34\n    }, {\n        \"company_zh\": \"中国兵器装备集团兵器装备研究所\",\n        \"company_en\": \"中国兵器装备集团兵器装备研究所\",\n        \"contribute\": 31\n    }, {\n        \"company_zh\": \"江苏润和软件股份有限公司\",\n        \"company_en\": \"Jiangsu HopeRun Software Co., Ltd.\",\n        \"contribute\": 30\n    }, {\n        \"company_zh\": \"超聚变数字技术有限公司\",\n        \"company_en\": \"xFusion Digital Technologies Co., Ltd.\",\n        \"contribute\": 26\n    }, {\n        \"company_zh\": \"中移（苏州）软件技术有限公司\",\n        \"company_en\": \"China Mobile (Suzhou) Software Technology Co., Ltd\",\n        \"contribute\": 24\n    }, {\n        \"company_zh\": \"中科方德软件有限公司\",\n        \"company_en\": \"Zhongke Fangde Software Co., Ltd.\",\n        \"contribute\": 21\n    }, {\n        \"company_zh\": \"北京长擎软件有限公司\",\n        \"company_en\": \"北京长擎软件有限公司\",\n        \"contribute\": 17\n    }, {\n        \"company_zh\": \"天翼云科技有限公司\",\n        \"company_en\": \"天翼云科技有限公司\",\n        \"contribute\": 12\n    }, {\n        \"company_zh\": \"英特尔亚太研发有限公司\",\n        \"company_en\": \"Intel Asia-Pacific Research And Development Ltd.\",\n        \"contribute\": 11\n    }, {\n        \"company_zh\": \"北京万里开源软件有限公司\",\n        \"company_en\": \"北京万里开源软件有限公司\",\n        \"contribute\": 10\n    }, {\n        \"company_zh\": \"WIND RIVER SYSTEMS, INC\",\n        \"company_en\": \"WIND RIVER SYSTEMS, INC\",\n        \"contribute\": 9\n    }, {\n        \"company_zh\": \"北京凝思软件股份有限公司\",\n        \"company_en\": \"北京凝思软件股份有限公司\",\n        \"contribute\": 7\n    }, {\n        \"company_zh\": \"Arm Limited\",\n        \"company_en\": \"Arm Ltd.\",\n        \"contribute\": 6\n    }, {\n        \"company_zh\": \"广州汇智通信技术有限公司\",\n        \"company_en\": \"广州汇智通信技术有限公司\",\n        \"contribute\": 5\n    }, {\n        \"company_zh\": \"新华三技术有限公司\",\n        \"company_en\": \"New H3C Technologies Co., Ltd.\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"无锡先进技术研究院\",\n        \"company_en\": \"Wuxi Advanced Technology Research Institute\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"软通动力信息技术（集团）股份有限公司\",\n        \"company_en\": \"iSoftStone Information Technology (Group) Co., Ltd.\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"北京中关村实验室\",\n        \"company_en\": \"北京中关村实验室\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"北京青云科技股份有限公司\",\n        \"company_en\": \"QingCloud Technologies Corp.\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"联通数字科技有限公司\",\n        \"company_en\": \"China Unicom (Incl. System Integration and Software Research Institute)\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"龙芯中科技术股份有限公司\",\n        \"company_en\": \"Loongson Technology Co., Ltd.\",\n        \"contribute\": 1\n    }],\n    \"timestamp\": 1766983919692,\n    \"executeTime\": 105\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
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
    SELECT '#{independent}', '#{independent}', 'independent', '#{independent}'
),
filtered_contributions AS (
    SELECT 
        CASE 
            WHEN internal = '${internal}' THEN '${internal_company}'
            ELSE company 
        END AS company,
        count(1) as contribute
    FROM 
        dws_${community}_version_contribute
    WHERE 
        contrib_type = #{contributeType}
            <if test="contributeType == 'pr'">
                AND state = 'merged'
            </if>
            <if test="version != null and version != '' and version != 'all'">
                AND version = #{version}
            </if>
        AND company <> 'robot'    
        AND is_removed IS NULL
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

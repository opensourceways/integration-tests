{
  "properties" : { },
  "id" : "26c592f36d374ca3921bb47ae8f7d11c",
  "script" : null,
  "groupId" : "bb5eadd619a64e1b8c7a29f0108c78c0",
  "name" : "企业版本贡献",
  "createTime" : null,
  "updateTime" : 1769390512705,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/version/company/contribute",
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
    "error" : null,
    "expression" : "^(openeuler|opengauss|mindspore|openubmc|openfuyao)$",
    "children" : null
  }, {
    "name" : "contributeType",
    "value" : "comment",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(pr|issue|comment)$",
    "children" : null
  }, {
    "name" : "version",
    "value" : "openEuler-25.03",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"company_zh\": \"华为技术有限公司\",\n        \"company_en\": \"Huawei Technologies Co., Ltd.\",\n        \"contribute\": 29111\n    }, {\n        \"company_zh\": \"华为合作方\",\n        \"company_en\": \"华为合作方\",\n        \"contribute\": 7859\n    }, {\n        \"company_zh\": \"个人贡献者\",\n        \"company_en\": \"independent\",\n        \"contribute\": 6409\n    }, {\n        \"company_zh\": \"麒麟软件有限公司\",\n        \"company_en\": \"Kylinsoft Co., Ltd.\",\n        \"contribute\": 5946\n    }, {\n        \"company_zh\": \"粤港澳大湾区（广东）国创中心\",\n        \"company_en\": \"粤港澳大湾区（广东）国创中心\",\n        \"contribute\": 4725\n    }, {\n        \"company_zh\": \"统信软件技术有限公司\",\n        \"company_en\": \"UnionTech Software Technology Co., Ltd.\",\n        \"contribute\": 3422\n    }, {\n        \"company_zh\": \"超聚变数字技术有限公司\",\n        \"company_en\": \"xFusion Digital Technologies Co., Ltd.\",\n        \"contribute\": 2598\n    }, {\n        \"company_zh\": \"江苏润和软件股份有限公司\",\n        \"company_en\": \"Jiangsu HopeRun Software Co., Ltd.\",\n        \"contribute\": 1508\n    }, {\n        \"company_zh\": \"湖南麒麟信安科技股份有限公司\",\n        \"company_en\": \"Hunan Kylinsec Technology Co., Ltd.\",\n        \"contribute\": 1095\n    }, {\n        \"company_zh\": \"龙芯中科技术股份有限公司\",\n        \"company_en\": \"Loongson Technology Co., Ltd.\",\n        \"contribute\": 719\n    }, {\n        \"company_zh\": \"中国科学院软件研究所\",\n        \"company_en\": \"Institute of Software, Chinese Academy of Sciences\",\n        \"contribute\": 713\n    }, {\n        \"company_zh\": \"中软国际科技服务有限公司\",\n        \"company_en\": \"Chinasoft International Technology Services Co., Ltd.\",\n        \"contribute\": 686\n    }, {\n        \"company_zh\": \"北京拓林思软件有限公司\",\n        \"company_en\": \"TurboLinux Inc.\",\n        \"contribute\": 248\n    }, {\n        \"company_zh\": \"中科方德软件有限公司\",\n        \"company_en\": \"Zhongke Fangde Software Co., Ltd.\",\n        \"contribute\": 226\n    }, {\n        \"company_zh\": \"北京长擎软件有限公司\",\n        \"company_en\": \"北京长擎软件有限公司\",\n        \"contribute\": 178\n    }, {\n        \"company_zh\": \"SUSE\",\n        \"company_en\": \"SUSE\",\n        \"contribute\": 177\n    }, {\n        \"company_zh\": \"中国兵器装备集团兵器装备研究所\",\n        \"company_en\": \"中国兵器装备集团兵器装备研究所\",\n        \"contribute\": 174\n    }, {\n        \"company_zh\": \"合芯科技有限公司\",\n        \"company_en\": \"Core Technology Co., Ltd.\",\n        \"contribute\": 155\n    }, {\n        \"company_zh\": \"软通动力信息技术（集团）股份有限公司\",\n        \"company_en\": \"iSoftStone Information Technology (Group) Co., Ltd.\",\n        \"contribute\": 120\n    }, {\n        \"company_zh\": \"中国联通（含联通数科、联通软研院）\",\n        \"company_en\": \"China Unicom (Incl. System Integration and Software Research Institute)\",\n        \"contribute\": 118\n    }, {\n        \"company_zh\": \"中移（苏州）软件技术有限公司\",\n        \"company_en\": \"China Mobile (Suzhou) Software Technology Co., Ltd\",\n        \"contribute\": 98\n    }, {\n        \"company_zh\": \"北京凝思软件股份有限公司\",\n        \"company_en\": \"北京凝思软件股份有限公司\",\n        \"contribute\": 88\n    }, {\n        \"company_zh\": \"浪潮云信息技术股份公司\",\n        \"company_en\": \"浪潮云信息技术股份公司\",\n        \"contribute\": 82\n    }, {\n        \"company_zh\": \"英特尔亚太研发有限公司\",\n        \"company_en\": \"Intel Asia-Pacific Research And Development Ltd.\",\n        \"contribute\": 80\n    }, {\n        \"company_zh\": \"华为技术有限公司\",\n        \"company_en\": \"Huawei Technologies Co., Ltd.\",\n        \"contribute\": 77\n    }, {\n        \"company_zh\": \"北京奥思维科技有限公司\",\n        \"company_en\": \"北京奥思维科技有限公司\",\n        \"contribute\": 60\n    }, {\n        \"company_zh\": \"无锡先进技术研究院\",\n        \"company_en\": \"Wuxi Advanced Technology Research Institute\",\n        \"contribute\": 36\n    }, {\n        \"company_zh\": \"海光信息技术股份有限公司\",\n        \"company_en\": \"海光信息技术股份有限公司\",\n        \"contribute\": 31\n    }, {\n        \"company_zh\": \"北京汇钧科技有限公司\",\n        \"company_en\": \"Beijing Huijun Technology Co., Ltd.\",\n        \"contribute\": 30\n    }, {\n        \"company_zh\": \"普华基础软件股份有限公司\",\n        \"company_en\": \"iSOFT Infrastructure Software Co. Ltd.\",\n        \"contribute\": 30\n    }, {\n        \"company_zh\": \"天翼云科技有限公司\",\n        \"company_en\": \"天翼云科技有限公司\",\n        \"contribute\": 29\n    }, {\n        \"company_zh\": \"中兴通讯股份有限公司\",\n        \"company_en\": \"ZTE Corporation\",\n        \"contribute\": 27\n    }, {\n        \"company_zh\": \"Linaro Limited\",\n        \"company_en\": \"Linaro Ltd.\",\n        \"contribute\": 22\n    }, {\n        \"company_zh\": \"北京中关村实验室\",\n        \"company_en\": \"北京中关村实验室\",\n        \"contribute\": 20\n    }, {\n        \"company_zh\": \"星辰天合（北京）数据科技有限公司\",\n        \"company_en\": \"Xingchen Tianhe (Beijing) Data Technology Co., Ltd.\",\n        \"contribute\": 19\n    }, {\n        \"company_zh\": \"上海云脉芯联科技有限公司\",\n        \"company_en\": \"上海云脉芯联科技有限公司\",\n        \"contribute\": 18\n    }, {\n        \"company_zh\": \"WIND RIVER SYSTEMS, INC\",\n        \"company_en\": \"WIND RIVER SYSTEMS, INC\",\n        \"contribute\": 15\n    }, {\n        \"company_zh\": \"华中科技大学网络空间安全学院\",\n        \"company_en\": \"华中科技大学网络空间安全学院\",\n        \"contribute\": 15\n    }, {\n        \"company_zh\": \"北京网迅科技有限公司\",\n        \"company_en\": \"Beijing Netswift Technology Co.,Ltd.\",\n        \"contribute\": 9\n    }, {\n        \"company_zh\": \"飞腾信息技术有限公司\",\n        \"company_en\": \"Phytium Technology Co., Ltd.\",\n        \"contribute\": 9\n    }, {\n        \"company_zh\": \"新华三技术有限公司\",\n        \"company_en\": \"New H3C Technologies Co., Ltd.\",\n        \"contribute\": 7\n    }, {\n        \"company_zh\": \"北京万里开源软件有限公司\",\n        \"company_en\": \"北京万里开源软件有限公司\",\n        \"contribute\": 6\n    }, {\n        \"company_zh\": \"北京青云科技股份有限公司\",\n        \"company_en\": \"QingCloud Technologies Corp.\",\n        \"contribute\": 6\n    }, {\n        \"company_zh\": \"上海兆芯集成电路有限公司\",\n        \"company_en\": \"Shanghai Zhaoxin Semiconductor Co., Ltd.\",\n        \"contribute\": 5\n    }, {\n        \"company_zh\": \"北京长扬软件有限公司\",\n        \"company_en\": \"北京长扬软件有限公司\",\n        \"contribute\": 5\n    }, {\n        \"company_zh\": \"中科红旗（北京）信息科技有限公司\",\n        \"company_en\": \"中科红旗（北京）信息科技有限公司\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"北京奥星贝斯科技有限公司\",\n        \"company_en\": \"北京奥星贝斯科技有限公司\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"广州汇智通信技术有限公司\",\n        \"company_en\": \"广州汇智通信技术有限公司\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"成都鼎桥通信技术有限公司\",\n        \"company_en\": \"成都鼎桥通信技术有限公司\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"深信服科技股份有限公司\",\n        \"company_en\": \"Sangfor Technologies Inc.,\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"个人贡献者\",\n        \"company_en\": \"independent\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"航天科工网络信息发展有限公司\",\n        \"company_en\": \"CASIC Network Information Development Co., Ltd.\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"陕西弓今网络科技有限公司\",\n        \"company_en\": \"Shaanxi Gongjin Network Technology Co., Ltd.\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"上海苦芽科技有限公司\",\n        \"company_en\": \"上海苦芽科技有限公司\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"成都菁蓉联创科技有限公司\",\n        \"company_en\": \"Chengdu Jingrong Lianchuang Technology Co., Ltd.\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"杭州安恒信息技术股份有限公司\",\n        \"company_en\": \"Hangzhou Anheng Information Technology Co., Ltd.\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"浙江熵量科技有限公司\",\n        \"company_en\": \"浙江熵量科技有限公司\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"澜起科技股份有限公司\",\n        \"company_en\": \"澜起科技股份有限公司\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"网宿科技股份有限公司\",\n        \"company_en\": \"网宿科技股份有限公司\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"郑州大学网络空间安全学院\",\n        \"company_en\": \"郑州大学网络空间安全学院\",\n        \"contribute\": 1\n    }],\n    \"timestamp\": 1754394024377,\n    \"executeTime\": 84\n}",
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
    SELECT '${independent}', '${independent}', 'independent', '${independent}'
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

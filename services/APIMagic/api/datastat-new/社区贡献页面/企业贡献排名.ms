{
  "properties" : { },
  "id" : "26f758adf5d54bcfa78633ed25c02b3f",
  "script" : null,
  "groupId" : "bb5eadd619a64e1b8c7a29f0108c78c0",
  "name" : "企业贡献排名",
  "createTime" : null,
  "updateTime" : 1774947262688,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/company/contribute",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "opengauss",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "repo",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
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
    "error" : null,
    "expression" : "^(pr|issue|comment)$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"company_zh\": \"华为技术有限公司\",\n        \"company_en\": \"Huawei Technologies Co., Ltd.\",\n        \"contribute\": 111977\n    }, {\n        \"company_zh\": \"个人贡献者\",\n        \"company_en\": \"independent\",\n        \"contribute\": 33565\n    }, {\n        \"company_zh\": \"麒麟软件有限公司\",\n        \"company_en\": \"Kylinsoft Co., Ltd.\",\n        \"contribute\": 27134\n    }, {\n        \"company_zh\": \"统信软件技术有限公司\",\n        \"company_en\": \"UnionTech Software Technology Co., Ltd.\",\n        \"contribute\": 17514\n    }, {\n        \"company_zh\": \"粤港澳大湾区（广东）国创中心\",\n        \"company_en\": \"粤港澳大湾区（广东）国创中心\",\n        \"contribute\": 9479\n    }, {\n        \"company_zh\": \"超聚变数字技术有限公司\",\n        \"company_en\": \"xFusion Digital Technologies Co., Ltd.\",\n        \"contribute\": 6776\n    }, {\n        \"company_zh\": \"中移（苏州）软件技术有限公司\",\n        \"company_en\": \"China Mobile (Suzhou) Software Technology Co., Ltd\",\n        \"contribute\": 6615\n    }, {\n        \"company_zh\": \"湖南麒麟信安科技股份有限公司\",\n        \"company_en\": \"Hunan Kylinsec Technology Co., Ltd.\",\n        \"contribute\": 5948\n    }, {\n        \"company_zh\": \"天翼云科技有限公司\",\n        \"company_en\": \"天翼云科技有限公司\",\n        \"contribute\": 5153\n    }, {\n        \"company_zh\": \"中国科学院软件研究所\",\n        \"company_en\": \"Institute of Software, Chinese Academy of Sciences\",\n        \"contribute\": 4968\n    }, {\n        \"company_zh\": \"北京凝思软件股份有限公司\",\n        \"company_en\": \"北京凝思软件股份有限公司\",\n        \"contribute\": 4469\n    }, {\n        \"company_zh\": \"软通动力信息技术（集团）股份有限公司\",\n        \"company_en\": \"iSoftStone Information Technology (Group) Co., Ltd.\",\n        \"contribute\": 3678\n    }, {\n        \"company_zh\": \"江苏润和软件股份有限公司\",\n        \"company_en\": \"Jiangsu HopeRun Software Co., Ltd.\",\n        \"contribute\": 2817\n    }, {\n        \"company_zh\": \"北京拓林思软件有限公司\",\n        \"company_en\": \"TurboLinux Inc.\",\n        \"contribute\": 1340\n    }, {\n        \"company_zh\": \"龙芯中科技术股份有限公司\",\n        \"company_en\": \"Loongson Technology Co., Ltd.\",\n        \"contribute\": 1316\n    }, {\n        \"company_zh\": \"联通数字科技有限公司\",\n        \"company_en\": \"China Unicom (Incl. System Integration and Software Research Institute)\",\n        \"contribute\": 1256\n    }, {\n        \"company_zh\": \"北京奥思维科技有限公司\",\n        \"company_en\": \"北京奥思维科技有限公司\",\n        \"contribute\": 990\n    }, {\n        \"company_zh\": \"中软国际科技服务有限公司\",\n        \"company_en\": \"Chinasoft International Technology Services Co., Ltd.\",\n        \"contribute\": 964\n    }, {\n        \"company_zh\": \"北京东方通科技股份有限公司\",\n        \"company_en\": \"北京东方通科技股份有限公司\",\n        \"contribute\": 509\n    }, {\n        \"company_zh\": \"中科方德软件有限公司\",\n        \"company_en\": \"Zhongke Fangde Software Co., Ltd.\",\n        \"contribute\": 372\n    }, {\n        \"company_zh\": \"英特尔亚太研发有限公司\",\n        \"company_en\": \"Intel Asia-Pacific Research And Development Ltd.\",\n        \"contribute\": 370\n    }, {\n        \"company_zh\": \"SUSE\",\n        \"company_en\": \"SUSE\",\n        \"contribute\": 279\n    }, {\n        \"company_zh\": \"北京长擎软件有限公司\",\n        \"company_en\": \"北京长擎软件有限公司\",\n        \"contribute\": 271\n    }, {\n        \"company_zh\": \"合芯科技有限公司\",\n        \"company_en\": \"Core Technology Co., Ltd.\",\n        \"contribute\": 257\n    }, {\n        \"company_zh\": \"浪潮云信息技术股份公司\",\n        \"company_en\": \"浪潮云信息技术股份公司\",\n        \"contribute\": 254\n    }, {\n        \"company_zh\": \"海光信息技术股份有限公司\",\n        \"company_en\": \"海光信息技术股份有限公司\",\n        \"contribute\": 205\n    }, {\n        \"company_zh\": \"中国兵器装备集团兵器装备研究所\",\n        \"company_en\": \"中国兵器装备集团兵器装备研究所\",\n        \"contribute\": 199\n    }, {\n        \"company_zh\": \"上海兆芯集成电路有限公司\",\n        \"company_en\": \"Shanghai Zhaoxin Semiconductor Co., Ltd.\",\n        \"contribute\": 154\n    }, {\n        \"company_zh\": \"北京汇钧科技有限公司\",\n        \"company_en\": \"Beijing Huijun Technology Co., Ltd.\",\n        \"contribute\": 151\n    }, {\n        \"company_zh\": \"西安智讯数据网络有限公司\",\n        \"company_en\": \"西安智讯数据网络有限公司\",\n        \"contribute\": 142\n    }, {\n        \"company_zh\": \"无锡先进技术研究院\",\n        \"company_en\": \"Wuxi Advanced Technology Research Institute\",\n        \"contribute\": 141\n    }, {\n        \"company_zh\": \"中兴通讯股份有限公司\",\n        \"company_en\": \"ZTE Corporation\",\n        \"contribute\": 130\n    }, {\n        \"company_zh\": \"普华基础软件股份有限公司\",\n        \"company_en\": \"iSOFT Infrastructure Software Co. Ltd.\",\n        \"contribute\": 114\n    }, {\n        \"company_zh\": \"航天科工网络信息发展有限公司\",\n        \"company_en\": \"CASIC Network Information Development Co., Ltd.\",\n        \"contribute\": 107\n    }, {\n        \"company_zh\": \"Linaro Limited\",\n        \"company_en\": \"Linaro Ltd.\",\n        \"contribute\": 102\n    }, {\n        \"company_zh\": \"中国兵器工业计算机应用技术研究所\",\n        \"company_en\": \"中国兵器工业计算机应用技术研究所\",\n        \"contribute\": 79\n    }, {\n        \"company_zh\": \"北京百度网讯科技有限公司\",\n        \"company_en\": \"北京百度网讯科技有限公司\",\n        \"contribute\": 73\n    }, {\n        \"company_zh\": \"新华三技术有限公司\",\n        \"company_en\": \"New H3C Technologies Co., Ltd.\",\n        \"contribute\": 72\n    }, {\n        \"company_zh\": \"WIND RIVER SYSTEMS, INC\",\n        \"company_en\": \"WIND RIVER SYSTEMS, INC\",\n        \"contribute\": 70\n    }, {\n        \"company_zh\": \"广州汇智通信技术有限公司\",\n        \"company_en\": \"广州汇智通信技术有限公司\",\n        \"contribute\": 70\n    }, {\n        \"company_zh\": \"华中科技大学网络空间安全学院\",\n        \"company_en\": \"华中科技大学网络空间安全学院\",\n        \"contribute\": 64\n    }, {\n        \"company_zh\": \"飞腾信息技术有限公司\",\n        \"company_en\": \"Phytium Technology Co., Ltd.\",\n        \"contribute\": 57\n    }, {\n        \"company_zh\": \"中科创达软件股份有限公司\",\n        \"company_en\": \"Thunder Software Technology Co., Ltd.\",\n        \"contribute\": 56\n    }, {\n        \"company_zh\": \"成都菁蓉联创科技有限公司\",\n        \"company_en\": \"Chengdu Jingrong Lianchuang Technology Co., Ltd.\",\n        \"contribute\": 54\n    }, {\n        \"company_zh\": \"宝兰德软件\",\n        \"company_en\": \"Baolande Software Corp.\",\n        \"contribute\": 41\n    }, {\n        \"company_zh\": \"上海云脉芯联科技有限公司\",\n        \"company_en\": \"上海云脉芯联科技有限公司\",\n        \"contribute\": 36\n    }, {\n        \"company_zh\": \"北京青云科技股份有限公司\",\n        \"company_en\": \"QingCloud Technologies Corp.\",\n        \"contribute\": 36\n    }, {\n        \"company_zh\": \"北京中关村实验室\",\n        \"company_en\": \"北京中关村实验室\",\n        \"contribute\": 31\n    }, {\n        \"company_zh\": \"星辰天合（北京）数据科技有限公司\",\n        \"company_en\": \"Xingchen Tianhe (Beijing) Data Technology Co., Ltd.\",\n        \"contribute\": 31\n    }, {\n        \"company_zh\": \"Advanced Micro Devices Products (China) Co., Ltd.\",\n        \"company_en\": \"Advanced Micro Devices Products (China) Co., Ltd.\",\n        \"contribute\": 26\n    }, {\n        \"company_zh\": \"北京万里开源软件有限公司\",\n        \"company_en\": \"北京万里开源软件有限公司\",\n        \"contribute\": 24\n    }, {\n        \"company_zh\": \"北京网迅科技有限公司\",\n        \"company_en\": \"Beijing Netswift Technology Co.,Ltd.\",\n        \"contribute\": 24\n    }, {\n        \"company_zh\": \"无锡沐创集成电路设计有限公司\",\n        \"company_en\": \"无锡沐创集成电路设计有限公司\",\n        \"contribute\": 21\n    }, {\n        \"company_zh\": \"深信服科技股份有限公司\",\n        \"company_en\": \"Sangfor Technologies Inc.,\",\n        \"contribute\": 18\n    }, {\n        \"company_zh\": \"珠海星云智联科技有限公司\",\n        \"company_en\": \"珠海星云智联科技有限公司\",\n        \"contribute\": 18\n    }, {\n        \"company_zh\": \"北京航空航天大学杭州创新研究院\",\n        \"company_en\": \"北京航空航天大学杭州创新研究院\",\n        \"contribute\": 13\n    }, {\n        \"company_zh\": \"北京奥星贝斯科技有限公司\",\n        \"company_en\": \"北京奥星贝斯科技有限公司\",\n        \"contribute\": 12\n    }, {\n        \"company_zh\": \"澜起科技股份有限公司\",\n        \"company_en\": \"澜起科技股份有限公司\",\n        \"contribute\": 12\n    }, {\n        \"company_zh\": \"上海交通大学\",\n        \"company_en\": \"上海交通大学\",\n        \"contribute\": 11\n    }, {\n        \"company_zh\": \"成都鼎桥通信技术有限公司\",\n        \"company_en\": \"成都鼎桥通信技术有限公司\",\n        \"contribute\": 11\n    }, {\n        \"company_zh\": \"浙江熵量科技有限公司\",\n        \"company_en\": \"浙江熵量科技有限公司\",\n        \"contribute\": 11\n    }, {\n        \"company_zh\": \"北京华胜天成科技股份有限公司\",\n        \"company_en\": \"Beijing Huasheng Tiancheng Technology Co., Ltd.\",\n        \"contribute\": 9\n    }, {\n        \"company_zh\": \"拓维信息系统股份有限公司\",\n        \"company_en\": \"Talkweb Information System Co., Ltd.\",\n        \"contribute\": 9\n    }, {\n        \"company_zh\": \"陕西弓今网络科技有限公司\",\n        \"company_en\": \"Shaanxi Gongjin Network Technology Co., Ltd.\",\n        \"contribute\": 9\n    }, {\n        \"company_zh\": \"北京长扬软件有限公司\",\n        \"company_en\": \"北京长扬软件有限公司\",\n        \"contribute\": 8\n    }, {\n        \"company_zh\": \"成都北中网芯科技有限公司\",\n        \"company_en\": \"成都北中网芯科技有限公司\",\n        \"contribute\": 8\n    }, {\n        \"company_zh\": \"北京可信华泰信息技术有限公司\",\n        \"company_en\": \"北京可信华泰信息技术有限公司\",\n        \"contribute\": 7\n    }, {\n        \"company_zh\": \"重庆汉图科技有限公司\",\n        \"company_en\": \"重庆汉图科技有限公司\",\n        \"contribute\": 7\n    }, {\n        \"company_zh\": \"奇安信科技集团股份有限公司\",\n        \"company_en\": \"奇安信科技集团股份有限公司\",\n        \"contribute\": 6\n    }, {\n        \"company_zh\": \"灵达科技（天津）有限公司\",\n        \"company_en\": \"灵达科技（天津）有限公司\",\n        \"contribute\": 6\n    }, {\n        \"company_zh\": \"普元信息技术股份有限公司\",\n        \"company_en\": \"Primeton Software, Inc.\",\n        \"contribute\": 5\n    }, {\n        \"company_zh\": \"杭州安恒信息技术股份有限公司\",\n        \"company_en\": \"Hangzhou Anheng Information Technology Co., Ltd.\",\n        \"contribute\": 5\n    }, {\n        \"company_zh\": \"深圳市金蝶天燕云计算股份有限公司\",\n        \"company_en\": \"Shenzhen Kingdee Apusic Cloud Computing Co.,Ltd.\",\n        \"contribute\": 5\n    }, {\n        \"company_zh\": \"上海苦芽科技有限公司\",\n        \"company_en\": \"上海苦芽科技有限公司\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"中科红旗（北京）信息科技有限公司\",\n        \"company_en\": \"中科红旗（北京）信息科技有限公司\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"深圳比特萌信息技术有限公司\",\n        \"company_en\": \"Shenzhen BitMOE Information Technology Co., Ltd.\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"超睿科技（上海）有限公司\",\n        \"company_en\": \"超睿科技（上海）有限公司\",\n        \"contribute\": 4\n    }, {\n        \"company_zh\": \"Arm Limited\",\n        \"company_en\": \"Arm Ltd.\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"北京名洋数字科技股份有限公司\",\n        \"company_en\": \"北京名洋数字科技股份有限公司\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"北京航空航天大学网络空间安全学院\",\n        \"company_en\": \"北京航空航天大学网络空间安全学院\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"北京麟卓信息科技有限公司\",\n        \"company_en\": \"北京麟卓信息科技有限公司\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"通明智云（北京）科技有限公司\",\n        \"company_en\": \"通明智云（北京）科技有限公司\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"郑州大学网络空间安全学院\",\n        \"company_en\": \"郑州大学网络空间安全学院\",\n        \"contribute\": 3\n    }, {\n        \"company_zh\": \"WuHan University of Technology\",\n        \"company_en\": \"WuHan University of Technology\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"中科驭数（北京）科技有限公司\",\n        \"company_en\": \"中科驭数（北京）科技有限公司\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"南京鹏云网络科技有限公司\",\n        \"company_en\": \"南京鹏云网络科技有限公司\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"同济大学\",\n        \"company_en\": \"同济大学\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"深圳云豹智能有限公司\",\n        \"company_en\": \"深圳云豹智能有限公司\",\n        \"contribute\": 2\n    }, {\n        \"company_zh\": \"SmartX\",\n        \"company_en\": \"SmartX\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"上海天数智芯半导体有限公司\",\n        \"company_en\": \"上海天数智芯半导体有限公司\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"北京中科微澜科技有限公司\",\n        \"company_en\": \"Beijing Zhongke Weilan Technology Co., Ltd.\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"北京大学长沙计算与数字经济研究院\",\n        \"company_en\": \"北京大学长沙计算与数字经济研究院\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"北京天融信网络安全技术有限公司\",\n        \"company_en\": \"北京天融信网络安全技术有限公司\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"北京奕斯伟计算技术股份有限公司\",\n        \"company_en\": \"北京奕斯伟计算技术股份有限公司\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"北京纵存科技有限公司\",\n        \"company_en\": \"北京纵存科技有限公司\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"华云数据控股集团有限公司\",\n        \"company_en\": \"Huayun Data Holding Group Co., Ltd.\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"安超云软件有限公司\",\n        \"company_en\": \"安超云软件有限公司\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"益思芯科技（上海）有限公司\",\n        \"company_en\": \"益思芯科技（上海）有限公司\",\n        \"contribute\": 1\n    }, {\n        \"company_zh\": \"网宿科技股份有限公司\",\n        \"company_en\": \"网宿科技股份有限公司\",\n        \"contribute\": 1\n    }],\n    \"timestamp\": 1773906608759,\n    \"executeTime\": 481\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
contributeType = contributeType.toLowerCase()
var coreRepo = ['openGauss-server','CBB','DCF','DCC','DMS','openGauss-OM','CM','DSS']
if (contributeType == 'comment') {
    sum_field = comment_type == 'normal' ? `valid_comment_incre` : comment_type == 'command' ? `comment_incre - valid_comment_incre` : `comment_incre`
}
else {
    sum_field = contributeType == 'pr' ? `merged_pr_incre` : `${contributeType}_incre`
}
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
        dws_${community}_contribute_repo_company_daily
    WHERE 
        1 = 1
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
            <if test="start != null and start != ''">
                AND date >= to_timestamp(#{start}/1000)
            </if>
            <if test="end != null and end != ''">
                AND date <= to_timestamp(#{end}/1000)
            </if>
            <if test="community == 'openubmc'">
                AND private = 'false'
            </if>
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
HAVING a.contribute > 0
ORDER BY 
    a.contribute DESC;"""
var resp = db.select(sqlstr)
return resp

{
  "properties" : { },
  "id" : "e2ac426ad3cf4fe380f394076a48a406",
  "script" : null,
  "groupId" : "b6ef059c61f74bcebbea73fe9ad6f241",
  "name" : "评价详情",
  "createTime" : null,
  "updateTime" : 1774578724503,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/point/detail",
  "method" : "GET",
  "parameters" : [ {
    "name" : "project",
    "value" : "mindstudio",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "repo",
    "value" : "msit",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "kep_name",
    "value" : null,
    "description" : "一级指标名",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "date",
    "value" : null,
    "description" : "描述文档评价日期，时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
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
  } ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 99,\n        \"score\": 36.0,\n        \"required_score\": 33.0,\n        \"required\": [{\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"10. 硬件兼容性\",\n            \"info_point_definition\": \"软件所支持的硬件类型列表，包括架构、型号等\",\n            \"info_point_rates\": 1.5,\n            \"info_point_summary\": \"支持x86_64架构，硬件包括Atlas 800I A2/A3、G8600、Atlas 300I Duo；驱动需≥24.1/25.0。\",\n            \"suggestion\": \"建议补充ARM64/RISC-V支持情况，明确是否支持容器部署的硬件要求。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"11. 安装二进制\",\n            \"info_point_definition\": \"如何直接在主流OS、平台上安装软件二进制包\",\n            \"info_point_rates\": 1.5,\n            \"info_point_summary\": \"支持Linux，通过pip install msprechecker安装，含PyPI源和离线安装流程，验证命令为msprechecker。\",\n            \"suggestion\": \"缺少macOS和Windows支持说明，仅Linux。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"12. 从源码构建\",\n            \"info_point_definition\": \"如何获取源码并构建项目软件，可包含多架构、多后端，含构建常见问题的定位和修复方法、构建参数和配置对所生成二进制的影响等\",\n            \"info_point_rates\": 1.5,\n            \"info_point_summary\": \"提供git clone https://gitcode.com/Ascend/msit.git，设置PYTHONPATH，pip install -e方式构建；未提多架构构建参数。\",\n            \"suggestion\": \"建议补充多架构（arm64）编译参数、构建依赖（如CMake版本）、常见错误修复（如缺少libatb.so）。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"15. 快速开始\",\n            \"info_point_definition\": \"项目软件的“Hello World”使用方法，快速拉起应用并展示核心功能的用法\",\n            \"info_point_rates\": 1.5,\n            \"info_point_summary\": \"提供msit llm dump、msprechecker precheck等命令示例，说明环境依赖和运行方式；msmodelslim提供一键量化快速入门。\",\n            \"suggestion\": \"建议合并为“Hello World”单节，明确最小可运行示例（如1行命令跑通dump）。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"16. 使用教程\",\n            \"info_point_definition\": \"项目软件的全量使用指导，各组件的各类启动参数所使能的功能，相关配置项和参数的定义和使用方法，将软件与其他上下游软件的集成方法等\",\n            \"info_point_rates\": 2.0,\n            \"info_point_summary\": \"每个组件有详细使用指南（如debug、convert、profile），含参数示例、子任务说明、配置文件结构、集成MindIE/vLLM。\",\n            \"suggestion\": \"无，教程覆盖全面，文档链接完整。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"17. 集成案例\",\n            \"info_point_definition\": \"场景应用场景中的实际使用案例，如何用项目软件解决典型实际业务问题的示例\",\n            \"info_point_rates\": 1.5,\n            \"info_point_summary\": \"提供Qwen3-235B、DeepSeek-V3.2等模型量化案例，含操作步骤（如一键量化、配置路径）；提供部署指导链接。\",\n            \"suggestion\": \"建议增加“端到端业务案例”如“如何用msit+msmodelslim将LLM部署到昇腾云服务”。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"18. API指导\",\n            \"info_point_definition\": \"项目对外提供API访问方式(如有)的具体使用方法，包括参数、接口、返回值等\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"提及Python API接口，但未列出函数列表、参数、返回值或请求示例；仅链接至文档。\",\n            \"suggestion\": \"建议补充API参考章节，如`msmodelslim.quantize(model, quant_config)`参数说明和返回值示例。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"19. 设计文档\",\n            \"info_point_definition\": \"软件主要模块的设计思路和细节，方便开发者理解代码和设计逻辑\",\n            \"info_point_rates\": 0.0,\n            \"info_point_summary\": \"未包含模块设计思路、算法原理、数据流图、控制流图等。\",\n            \"suggestion\": \"建议补充“设计文档”章节，说明量化算法流程、组件交互时序图、性能优化策略设计。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"1. 基本描述\",\n            \"info_point_definition\": \"简明扼要介绍项目的定位、愿景、所解决的技术问题\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"昇腾推理工具链，提供模型迁移、调试调优的一体化工具，服务AI开发者。\",\n            \"suggestion\": \"建议补充项目愿景，如“推动昇腾生态推理效率标准化”。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"20. 样例代码\",\n            \"info_point_definition\": \"对于重点特性和常见二次开发点的二次开发样例代码，方便用户和开发者进行参考\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"提供Qwen3、DeepSeek等模型的量化配置示例代码（链接至README.md），含命令行参数和路径。\",\n            \"suggestion\": \"建议增加Python脚本样例（如调用API的完整脚本），并添加注释说明扩展点。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"21. 函数列表\",\n            \"info_point_definition\": \"软件中函数的列表和输入、输出解释，方便进行二次开发\",\n            \"info_point_rates\": 0.0,\n            \"info_point_summary\": \"未提供任何函数、类、方法列表及其输入输出说明。\",\n            \"suggestion\": \"建议补充“API函数参考”章节，列出quantize()、analyze_model()等函数及参数类型说明。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"22. 编译&构建指南\",\n            \"info_point_definition\": \"代码各个模块的编译和构建指南，包括所支持的编译构建参数和具体的解释\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"提供git clone + PYTHONPATH设置方式，但未说明编译依赖（如CMake、GCC）、构建参数（如--enable-profiling）及其影响。\",\n            \"suggestion\": \"建议补充完整构建流程（编译C++模块、生成.so、链接库）、支持参数说明。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"23. 交流渠道\",\n            \"info_point_definition\": \"项目开发团队所提供的交流渠道(Maillist、IRC、WeChat等)，用于深度交流和沟通\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"提供昇腾论坛链接和Issue提交入口，未提供邮件列表、WeChat群、IRC。\",\n            \"suggestion\": \"建议补充邮件列表（如msit-dev@huawei.com）和响应时间承诺（如24h内响应）。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"24. 贡献指导\",\n            \"info_point_definition\": \"项目的贡献指导，可供参与贡献的类型、参与渠道、文档、待解决问题的标记解释等\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"提供“欢迎贡献”，链接至Issue模板（Bug/Feature），未说明贡献流程（分支策略、PR审核）。\",\n            \"suggestion\": \"建议添加“CONTRIBUTING.md”文档，说明Fork流程、分支命名、Code Review标准。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"25. CLA指导\",\n            \"info_point_definition\": \"项目的CLA签署要求和指导\",\n            \"info_point_rates\": 0.0,\n            \"info_point_summary\": \"未提及任何CLA（贡献者许可协议）签署要求、平台或流程。\",\n            \"suggestion\": \"建议添加CLA说明，链接CLA Assistant或EasyCLA入口，说明为何需签署。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"26. 编码规范\",\n            \"info_point_definition\": \"项目的软件编码规范，帮助开发者写出满足社区质量和规范要求的高质量代码\",\n            \"info_point_rates\": 0.5,\n            \"info_point_summary\": \"无编码风格、命名、注释规范文档，仅在README中提及权限与安全。\",\n            \"suggestion\": \"建议补充“代码规范”章节，引用PEP8、华为C++规范等，并说明注释要求。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"27. RoadMap\",\n            \"info_point_definition\": \"项目的整体发展路标，帮助开发者了解社区发展方向，更容易参与到社区对应的开发工作中\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"有2025年版本更新计划（Qwen3、DeepSeek支持），但无明确时间线或技术演进方向。\",\n            \"suggestion\": \"建议增加Roadmap章节，列出Q1-2026支持RISC-V、v2.0重构架构等计划。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"29. 维护团队\",\n            \"info_point_definition\": \"项目和各模块的主要维护者和联系方式，方便用户和开发者直接进行求助\",\n            \"info_point_rates\": 0.5,\n            \"info_point_summary\": \"列出华为计算产品线、2012实验室为贡献者，但未提供具体维护者ID或联系方式。\",\n            \"suggestion\": \"建议列出Maintainer姓名/邮箱（如zhangsan@huawei.com）并说明紧急联系流程。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"2. 功能介绍\",\n            \"info_point_definition\": \"项目的基本功能介绍\",\n            \"info_point_rates\": 2.0,\n            \"info_point_summary\": \"包含msit、msmodelslim、msserviceprofiler、msprechecker四大组件，分别支持推理调试、模型压缩、服务调优、环境预检。\",\n            \"suggestion\": \"无，已充分覆盖核心功能与技术价值。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"30. Wiki、Glossary、FAQ\",\n            \"info_point_definition\": \"对软件使用中的其他琐碎内容的解释，如概念、常见问题等\",\n            \"info_point_rates\": 1.5,\n            \"info_point_summary\": \"有FAQ链接、术语表（如torchair定义）、独立FAQ文档，内容系统化。\",\n            \"suggestion\": \"无，覆盖全面，术语定义清晰。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"31. 求助渠道\",\n            \"info_point_definition\": \"项目的各类求助渠道和建议的路径，如Bug类建议Issue跟踪，咨询类建议Maillist等\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"区分Issue（Bug/Feature）和昇腾论坛，但未明确建议哪种问题用哪种渠道。\",\n            \"suggestion\": \"建议明确：Bug→Issue，咨询→论坛，新功能→Feature模板。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"33. 漏洞&补丁发布渠道\",\n            \"info_point_definition\": \"漏洞和补丁的发布渠道和发布方式，帮助用户和开发者解决已知问题\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"提供安全版本依赖列表（torch 2.7.1rc1），建议升级，但未说明漏洞报告渠道和补丁发布方式。\",\n            \"suggestion\": \"建议增加“安全响应”页面，说明CVE报告邮箱和补丁下载地址。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"3. 技术特点\",\n            \"info_point_definition\": \"介绍项目的主要特点，设计理念，重点特性、上下游生态的发展情况等\",\n            \"info_point_rates\": 2.0,\n            \"info_point_summary\": \"支持量化（W4A8/W8A8）、稀疏训练、算子精度预检、vLLM/MindIE集成，依赖CANN、昇腾驱动，生态涵盖MindStudio、Grafana。\",\n            \"suggestion\": \"建议补充“上下游生态”图示或链接说明CANN集成方式。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"4. 组件架构\",\n            \"info_point_definition\": \"项目所包含的组件的整体介绍，各组件功能、相互之间的调用关系等\",\n            \"info_point_rates\": 2.0,\n            \"info_point_summary\": \"msit含llm/debug/analyze/convert等8组件，msmodelslim为量化模块，msserviceprofiler含比对/寻优/专家建议等6工具，组件间通过命令行/API调用。\",\n            \"suggestion\": \"建议补充架构图或组件间数据流图（如msprechecker→msit→msserviceprofiler）。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"6. License\",\n            \"info_point_definition\": \"项目所使用的开源License及对应的可接受的License的列表和指导\",\n            \"info_point_rates\": 2.0,\n            \"info_point_summary\": \"项目整体使用Apache 2.0；msmodelslim模型若无单独License则默认Apache 2.0；提及依赖包安全版本。\",\n            \"suggestion\": \"建议补充依赖许可证兼容性说明（如PyTorch是否兼容Apache 2.0）。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"7. 下载工具\",\n            \"info_point_definition\": \"使用何种工具对软件进行下载(wget、Pypi、apt-get等)\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"使用pip（PyPI）、git clone、离线wheel安装。\",\n            \"suggestion\": \"缺少apt-get、yum等系统包管理器支持说明。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"8. 下载地址\",\n            \"info_point_definition\": \"获取不同下载方式的软件包的具体地址\",\n            \"info_point_rates\": 1.5,\n            \"info_point_summary\": \"GitCode仓库地址、PyPI包地址、各组件文档链接（如https://gitcode.com/Ascend/msit/tree/master/msit）。\",\n            \"suggestion\": \"建议统一汇总“官方下载入口”章节，避免分散。\"\n        }, {\n            \"requirements\": \"必选\",\n            \"info_point_name\": \"9. 版本信息\",\n            \"info_point_definition\": \"有关软件版本信息的介绍，包括源码、制品以及对应的版本、架构等信息\",\n            \"info_point_rates\": 1.5,\n            \"info_point_summary\": \"源码在GitCode，版本v0.9.1（msprechecker），支持MindIE ≥2.2.RC1，文档提及2025年版本更新。\",\n            \"suggestion\": \"建议补充发布版本号（如msit v1.0）、构建产物命名规范。\"\n        }],\n        \"charming_score\": 3.0,\n        \"charming\": [{\n            \"requirements\": \"魅力\",\n            \"info_point_name\": \"13. 容器镜像\",\n            \"info_point_definition\": \"如何获取和使用含项目软件的容器镜像，并快速拉起示例应用\",\n            \"info_point_rates\": 0.0,\n            \"info_point_summary\": \"未提及任何Docker镜像、OCI镜像或镜像仓库（如Docker Hub、Huawei Cloud SWR）。\",\n            \"suggestion\": \"建议补充官方镜像地址（如swr.cn-north-4.myhuaweicloud.com/ascend/msit:latest）和docker run命令。\"\n        }, {\n            \"requirements\": \"魅力\",\n            \"info_point_name\": \"14. 构建文档\",\n            \"info_point_definition\": \"如何构建和发布项目的文档或网页，并对外提供服务\",\n            \"info_point_rates\": 0.0,\n            \"info_point_summary\": \"未说明如何构建或发布项目文档网页（如Sphinx、MkDocs构建流程）。\",\n            \"suggestion\": \"建议补充“文档构建指南”章节，说明如何用mkdocs build生成静态网站并部署至GitHub Pages。\"\n        }, {\n            \"requirements\": \"魅力\",\n            \"info_point_name\": \"28. Code of Conduct\",\n            \"info_point_definition\": \"项目的参与人员的行为准则，包括受欢迎和不受欢迎的行为和方式\",\n            \"info_point_rates\": 0.0,\n            \"info_point_summary\": \"无行为准则，未提及多样性、包容性、禁止骚扰等内容。\",\n            \"suggestion\": \"建议添加CODE_OF_CONDUCT.md，引用CNCF CoC或Apache CoC模板。\"\n        }, {\n            \"requirements\": \"魅力\",\n            \"info_point_name\": \"32. 问题反馈模板\",\n            \"info_point_definition\": \"不同类型问题的反馈模板，帮助开发者高质量描述问题，帮助Maintainer快速了解问题背景和现象\",\n            \"info_point_rates\": 1.0,\n            \"info_point_summary\": \"提供Bug报告和新功能诉求的专属Issue模板，含默认字段结构。\",\n            \"suggestion\": \"建议补充文档模板样例（如环境、步骤、预期结果字段），提升填写质量。\"\n        }, {\n            \"requirements\": \"魅力\",\n            \"info_point_name\": \"5. 周边软件生态\",\n            \"info_point_definition\": \"项目在整个业务软件栈中的生态定位，与周边软件的协同关系等\",\n            \"info_point_rates\": 2.0,\n            \"info_point_summary\": \"位于昇腾AI软件栈推理层，集成CANN、MindIE、vLLM、PyTorch、Transformers，输出OM模型给昇腾推理引擎。\",\n            \"suggestion\": \"无，已明确层次定位与交互协议（API、命令行、文件格式）。\"\n        }]\n    },\n    \"timestamp\": 1763111837311,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var target = 3
var project_name = project.toLowerCase()
var sqlstr = """
SELECT requirements, info_point_name, info_point_definition, info_point_rates, info_point_summary, suggestion
FROM readme_info_checks
WHERE lower(project) = #{project_name} AND repo = #{repo} 
        <if test="date != null and date != ''">
            AND check_id = (
                SELECT max(check_id) 
                FROM readme_info_checks 
                WHERE lower(project) = #{project_name} AND repo = #{repo} AND date_trunc('day', updated_at) <= to_timestamp(#{date}/1000)
            )
        </if>
        <else>
            AND check_id = (SELECT max(check_id) FROM readme_info_checks WHERE lower(project) = #{project_name} AND repo = #{repo})
        </else>
        <if test="kep_name != null and kep_name != ''">
            AND kep_name = #{kep_name}
        </if>
GROUP BY requirements, info_point_name, info_point_definition, info_point_rates, info_point_summary, suggestion
"""
var result = db.select(sqlstr)
var ans = {}
var score = 0.0
result.each(it => score += it.info_point_rates)
var total = result.getLength() * target
ans['total'] = total
ans['score'] = score
const type_map = {'必选': 'required', '魅力': 'charming'}
var group_map = result.group(it=>it.requirements)
group_map.each((key,value) => {
    var temp = 0;
    value.each(it => temp += it.info_point_rates);
    key = type_map.get(key)
    ans[`${key}_score`] = temp
    ans[key] = value
})
return ans

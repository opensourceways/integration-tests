{
  "properties" : { },
  "id" : "7c84c67d14854d3488efc4735f1a0d6c",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "开源技术月度信息",
  "createTime" : null,
  "updateTime" : 1778153213102,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "radar/detail/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "algorithm",
    "value" : "max-min",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "max-min",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(log|max-min|not)$",
    "children" : null
  }, {
    "name" : "type",
    "value" : "inference",
    "description" : "象限；支持 AIAgent-Runtime/-Framework/-Platform/-Memory 细分，传 AIAgent 时匹配整个 AIAgent-* 族",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "inference",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(AD|AIAgent(-Runtime|-Framework|-Platform|-Memory)?|EmbodiedAI|Kernels|Pretraining|Recommendation|RL|finetune|inference)$",
    "children" : null
  }, {
    "name" : "month",
    "value" : "2026-03",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "2026-04",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(\\d{4}-\\d{2})?$",
    "children" : null
  }, {
    "name" : "file_project",
    "value" : "ollama",
    "description" : "项目名（name 或 file_project 参数名均可，模糊匹配；同一月多批次时取最新 batch_date）",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "ollama",
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z0-9_/-]{1,100}$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": null,\n    \"timestamp\": 1777108169392,\n    \"executeTime\": 6\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : {
    "name" : "",
    "value" : "",
    "description" : "",
    "required" : false,
    "dataType" : "Object",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : [ {
      "name" : "code",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "message",
      "value" : "success",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "data",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "report",
        "value" : "=====本期 GitHub 活动总结（仓库：ollama/ollama，截止：2026-04-15，近30天）=====\\n最新重大进展：\\n- 发布 v0.20.8-rc0 预发布版本，重点修复 ROCm 7.2.1 兼容性及 Metal 编译错误，标志着 v0.20.8 版本开发进入关键收尾阶段。  \\n- 针对 Gemma4 模型关键问题开展多项修复，包括维持 Router 投影源精度、修正工具响应后提示生成错误，显著提升模型推理质量。  \\n- 社区强烈呼吁推出原生 Android 应用，反映出项目在移动端拓展方向的明确趋势，虽为功能请求，但已构成未来 roadmap 的核心线索。\\n\\n重要新特性（Features）：\\n- PR #15569：在 `ollama launch` 命令中新增 Hermes Agent 集成，提升高效智能体交互体验。  \\n- PR #15593：统一将云模型推荐优先展示于 launch 界面，优化用户获取云端资源的路径。\\n\\n关键 Bug 修复（Fixes）：\\n- PR #15613 及其提交 5d920cc：修复 Gemma4 Router 投影精度问题，直接改善模型路由准确性。  \\n- PR #15611：修复 Gemma4 在工具调用后生成提示的渲染错误。  \\n- Commit ec29ce4：修复 Metal 平台上的编译错误，保障 Apple GPU 用户使用稳定性。  \\n- Commit 798fd09：完成 ROCm 7.2.1 的升级，提升 AMD GPU 性能表现。\\n\\n重要 PR 与 Issue：\\nPR #15613：  \\n> 修复 Gemma4 路由投影精度问题，提升模型推理质量，已合并并进入 v0.20.8-rc0 版本。  \\n> [链接](https://github.com/ollama/ollama/pull/15613)\\n\\nIssue #15614：  \\n> 社区发起原生 Android 应用开发需求，强调移动设备的隐私访问与无缝体验。  \\n> [链接](https://github.com/ollama/ollama/issues/15614)\\n\\nRelease / Tag 摘要（近30天）：\\n版本号：v0.20.8-rc0  \\n主要变化：  \\n- 支持 ROCm 7.2.1 on Linux，提升 AMD GPU 性能表现。  \\n- 修复 Gemma4 模型的渲染与编译错误，优化 Metal 平台兼容性。  \\n- 修复多个关键模型行为问题，涉及 prompt 生成、JSON 输出格式与精度控制。  \\n> [发布页](https://github.com/ollama/ollama/releases/tag/v0.20.8-rc0)\\n\\n会议 / 博客 / 新闻 / 外部动态（近30天）：\\n重要会议：暂无相关内容  \\n博客与技术文章：暂无相关内容  \\n行业或社区新闻：暂无相关内容  \\n\\nRoadmap / 未来趋势：\\n- 显著向移动端扩展迈进，原生 Android 应用需求成为明确趋势，或在 2026 年下半年落地。  \\n- 持续强化多后端支持，包括 ROCm、Metal、Vulkan 与 MLX，针对性能瓶颈如阀值延迟、CPU 资源浪费持续优化。  \\n- 云与本地模型融合策略清晰，`launch` 命令中优先推荐云端模型，体现平台化布局意图。\\n\\n综合总结：\\nOllama 在近期（2026-03-16 至 4-15）展现强劲的版本迭代能力与开发者响应效率。v0.20.8-rc0 的发布标志着核心兼容性修复和性能优化的集中落地，尤其在 AMD（ROCm 7.2.1）、Apple Metal 及 Gemma4 模型稳定性方面取得实质性进展。多项 PR 与 commit 集中解决 Gemma4 精度与渲染问题，体现对模型质量的深度打磨，对推动 LLM 可靠性至关重要。与此同时，社区强烈呼吁原生 Android 应用，为项目未来发展方向注入明确信号。尽管部分旧问题（如 Vulkan 性能差距、MLX CPU 占用高）仍待突破，但项目对核心后端的持续维护与优化展现出成熟生态的技术治理能力。结合云推荐优先等用户体验优化，Ollama 正从本地部署工具向“跨平台、全栈式”AI 模型运行平台演进。整体发展路径清晰，技术前瞻性与社区驱动力并重，预计在 2026 年下半年实现移动端与多硬件效率的进一步突破。",
        "description" : "",
        "required" : false,
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1777023069997",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "executeTime",
      "value" : "5",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  }
}
================================

var file_project = name || file_project;
var sql = """
    SELECT DISTINCT ON (name)
        "description",
        "community_update",
        "report"
    FROM fact_insight_radar
    WHERE (quadrant = #{type}
           OR (#{type} = 'AIAgent' AND quadrant LIKE 'AIAgent-%'))
          and month = #{month}
          and name LIKE CONCAT('%', #{file_project}, '%')
    ORDER BY name, batch_date DESC NULLS LAST
"""

var res = db.select(sql)[0];
return res;
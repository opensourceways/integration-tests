{
  "properties" : { },
  "id" : "copy1773132978149d57638",
  "script" : null,
  "groupId" : "2e2220ca1c424052ba4fa20a1e7370f8",
  "name" : "严重缺陷数",
  "createTime" : null,
  "updateTime" : 1776310542073,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/cve",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "mindspeed",
    "description" : "社区名称",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openubmc",
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "1772294400000",
    "description" : "查询范围开始时间，格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : "1772294400000",
    "validateType" : "pass",
    "error" : "start 必须为合法的毫秒级时间戳",
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : "1774972800000",
    "description" : "查询范围结束时间，格式为毫秒时间戳",
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : "1774972800000",
    "validateType" : "pass",
    "error" : "end 必须为合法的毫秒级时间戳",
    "expression" : null,
    "children" : null
  }, {
    "name" : "pageNum",
    "value" : "",
    "description" : "查询页码",
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "pageSize",
    "value" : null,
    "description" : "每页数量",
    "required" : false,
    "dataType" : "Integer",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 0,\n        \"total_page\": 0,\n        \"list\": [],\n        \"page_size\": 10\n    },\n    \"timestamp\": 1776310381559,\n    \"executeTime\": 4\n}",
  "description" : "统计社区严重缺陷数指标",
  "requestBodyDefinition" : {
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
    "children" : [ ]
  },
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
      "description" : "响应码",
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
      "description" : "响应消息",
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
      "description" : "响应数据",
      "required" : false,
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "total_count",
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
      }, {
        "name" : "total_page",
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
        "name" : "list",
        "value" : "",
        "description" : "",
        "required" : false,
        "dataType" : "Array",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ {
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
            "name" : "id",
            "value" : "3801867",
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
            "name" : "html_url",
            "value" : "https://gitcode.com/openUBMC/webui/issues/303",
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
            "name" : "repo_path",
            "value" : "webui",
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
            "name" : "title",
            "value" : "[缺陷]: 本地用户管理页面存在内存泄漏",
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
            "name" : "body",
            "value" : "\\n\\n感谢您为社区报告缺陷！请按照以下提示提供详细信息，以便我们更好地理解并跟进。\\n\\n### 环境信息\\n            \\n\\n### 问题详细描述\\n            \\n#### 预置条件\\n<!-- 请描述环境操作前的预置操作或者预置数据信息 -->\\nopenUBMC系统正常\\n#### 操作步骤\\n<!-- 清晰描述每个步骤需要做的具体操作，如果涉及到接口使用的，请附上详细的接口信息 -->\\n从其他页面切换到本地用户管理页面，再切换到其他页面\\n#### 结果描述\\n<!-- 通过图文结合的方式清晰说明该步骤的操作对应出现的结果现象 -->\\n本地用户管理页面的DOM未被清除，存在内存泄漏问题\\n#### 预期结果\\n<!-- 描述该操作步骤对应的预期结果现象 -->\\nDOM被正确清除，无泄漏产生\\n### 问题定位情况\\n            \\nel-table内部渲染逻辑存在销毁后未释放的资源，导致使用scope.row内部的成员方法或以参数传入闭包渲染时产生泄漏。\\n规避方法：传递给el-table渲染前先手动计算最终渲染结果\\n",
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
            "name" : "labels_name",
            "value" : "{sig/sig-interface}",
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
            "name" : "priority",
            "value" : "0",
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
            "name" : "priority_title",
            "value" : "严重",
            "description" : "issue优先级标题，Gitee来源为issue_priority_detail.title（如严重/主要/次要/不重要），GitHub为空字符串",
            "required" : false,
            "dataType" : "String",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "issue_type",
            "value" : "缺陷",
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
            "name" : "state",
            "value" : "closed",
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
            "name" : "created_at",
            "value" : "2026-03-13 15:07:57",
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
            "name" : "severity_score",
            "value" : "72",
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
            "name" : "severity_level",
            "value" : "极严重",
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
            "name" : "is_severe",
            "value" : "是",
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
            "name" : "defect_category",
            "value" : "内存问题",
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
            "name" : "score_reasons",
            "value" : "标题关键词: 28分; 正文关键词: 20分; Issue类型: 8分; 确认性关键词加分",
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
        } ]
      }, {
        "name" : "page_size",
        "value" : "10",
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
    }, {
      "name" : "timestamp",
      "value" : "1776224315592",
      "description" : "响应时间戳",
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
      "value" : "16",
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
community = community.toLowerCase()
// page param
var page_num = 1;
if (pageNum != null and pageNum != ""){
    page_num = pageNum;
}
var page_size = 10;
if (pageSize != null and pageSize != ""){
    page_size = pageSize;
}
var offset = (page_num - 1) * page_size
var sql = """
with data as (
    SELECT f.id,f.html_url,f.repo_path,f.title,f.body,f.labels_name,f.priority,COALESCE(f.priority_title, '') AS priority_title,f.issue_type,f.state,f.created_at,d.severity_score,d.severity_level,d.is_severe,d.defect_category,d.score_reasons
    FROM fact_${community}_issue f, dwm_${community}_issue_defect d
    <where>
        f.id = d.issue_id and f.code_platform = d.code_platform and f.is_removed is null and f.is_hide is null and d.severity_score >= 60
        <if test="start != null and start != ''">
            AND f.created_at >= to_timestamp(#{start}/1000)
        </if>
        <if test="end != null and end != ''">
            AND f.created_at <= to_timestamp(#{end}/1000)
        </if>
    </where>
)
SELECT 
    *, 
    (select count(1) from data) as total_count, 
    CEIL((select count(1) from data)::numeric/#{page_size}) as total_page
FROM 
    data
LIMIT #{page_size} OFFSET #{offset} 

"""
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    item.remove("total_page");
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
result.put("page_size", page_size);
return result

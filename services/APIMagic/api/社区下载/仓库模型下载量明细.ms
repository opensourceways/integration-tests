{
  "properties" : { },
  "id" : "repodownload1137pagedetail0001",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "仓库模型下载量明细",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repo/page",
  "method" : "POST",
  "parameters" : [ ],
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
  "requestBody" : "{\r\n    \"community\":\"openpangu\",\r\n    \"repo_type\":\"\",\r\n    \"source\":\"\",\r\n    \"start\":\"\",\r\n    \"end\":\"\",\r\n    \"keyword\":\"\",\r\n    \"sortField\":\"range_increase\",\r\n    \"sortOrder\":\"desc\",\r\n    \"pageNum\":1,\r\n    \"pageSize\":10\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 23,\n        \"list\": [\n            {\n                \"namespace\": \"openpangu\",\n                \"repo_path\": \"pangu-7b\",\n                \"repo_type\": \"model\",\n                \"source\": \"huggingface\",\n                \"total_count\": 15820,\n                \"range_increase\": 320,\n                \"data_date\": \"2026-06-26\"\n            }\n        ]\n    },\n    \"timestamp\": 1773145066699,\n    \"executeTime\": 12\n}",
  "description" : "接口功能:逐仓/逐模型下载量明细分页查询（#1137 下载量看板）\n请求方式: POST\n完整 URL: /community/download/repo/page\n示例请求参数：\n{\n    \"community\":\"openpangu\", //社区名，正则校验防注入\n    \"repo_type\":\"\",         //code/model，空=全部\n    \"source\":\"\",            //gitcode/huggingface/modelscope，空=全部，支持逗号分隔多选\n    \"start\":\"2026-06-01\",   //起始日期 yyyy-MM-dd，可空\n    \"end\":\"2026-06-26\",     //结束日期 yyyy-MM-dd，空=最新快照日\n    \"keyword\":\"\",           //仓库/模型名模糊搜索\n    \"sortField\":\"total_count\", //total_count(默认)/range_increase/updated_at\n    \"sortOrder\":\"desc\",     //desc(默认)/asc\n    \"pageNum\":1,\n    \"pageSize\":10\n}\n返回 data.list 每行：namespace/repo_path/repo_type/source/total_count(累计)/range_increase(区间新增)/data_date(数据日期)，data.total 为去重后仓库/模型总数。",
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
    "children" : [ {
      "name" : "community",
      "value" : "",
      "description" : "社区名称",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "repo_type",
      "value" : "",
      "description" : "仓库类型 code/model，空=全部",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_type 只能为 code 或 model",
      "expression" : "^(code|model)?$",
      "children" : [ ]
    }, {
      "name" : "source",
      "value" : "",
      "description" : "来源平台，空=全部，支持逗号分隔多选",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "source 只能为 gitcode/huggingface/modelscope 的逗号组合",
      "expression" : "^((gitcode|huggingface|modelscope)(,(gitcode|huggingface|modelscope))*)?$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "",
      "description" : "起始日期 yyyy-MM-dd，可空",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "start 必须为 yyyy-MM-dd 格式",
      "expression" : "^(\\d{4}-\\d{2}-\\d{2})?$",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "结束日期 yyyy-MM-dd，空=最新快照日",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "end 必须为 yyyy-MM-dd 格式",
      "expression" : "^(\\d{4}-\\d{2}-\\d{2})?$",
      "children" : [ ]
    }, {
      "name" : "keyword",
      "value" : "",
      "description" : "仓库/模型名模糊搜索",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "sortField",
      "value" : "",
      "description" : "排序字段 repo_path/range_increase",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "range_increase",
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "sortOrder",
      "value" : "",
      "description" : "排序方向 desc/asc",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : "desc",
      "validateType" : "pattern",
      "error" : "sortOrder 只能为 asc 或 desc",
      "expression" : "^(asc|desc)?$",
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "",
      "description" : "页码，默认 1",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "1",
      "validateType" : "expression",
      "error" : "",
      "expression" : "pageNum > 0 && pageNum < 10000",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "",
      "description" : "每页条数，默认 10",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : "10",
      "validateType" : "expression",
      "error" : "",
      "expression" : "pageSize > 0 && pageSize < 10000",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}
================================
// #1137 仓库/模型下载量明细分页查询
// 完整 URL: /community/download/repo/page (POST)
// community 已由 requestBodyDefinition 正则白名单校验 ^[a-zA-Z]{1,32}$，可安全用于 ${} 表名拼接
var community = body.community;
var repo_type = body.repo_type;
var source = body.source;
var start = body.start;
var end = body.end;
var keyword = body.keyword;
var sortDir = body.sortOrder;
var sortColumn = body.sortField

var offset = (body.pageNum - 1) * body.pageSize;

var sqlstr = """
SELECT namespace, repo_path, repo_type, source,
       COALESCE(SUM(day_count), 0) AS range_increase
FROM dws_${community}_repo_download_daily
WHERE 1 = 1
    <if test="repo_type != null and repo_type != ''">
        AND repo_type = #{repo_type}
    </if>
    <if test="source != null and source != ''">
        AND source = ANY(string_to_array(#{source}, ','))
    </if>
    <if test="keyword != null and keyword != ''">
        AND repo_path ILIKE '%' || #{keyword} || '%'
    </if>
    <if test="start != null and start != ''">
        AND created_at >= #{start}::date
    </if>
    <if test="end != null and end != ''">
        AND created_at <= #{end}::date
    </if>
GROUP BY namespace, repo_path, repo_type, source
ORDER BY ${sortColumn} ${sortDir}
""";

var resp = db.page(sqlstr, body.pageSize, offset)
return resp

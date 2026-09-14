{
  "properties" : { },
  "id" : "b7c1e2a4d9f04c3ab1049gitcodedl03",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "GitCode仓库下载明细记录",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repo/records",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\n    \"community\": \"hpckit\",\n    \"namespace\": \"hpckit\",\n    \"repo_path\": \"demo\",\n    \"start\": \"2026-06-23\",\n    \"end\": \"2026-06-23\",\n    \"category\": \"logged\",\n    \"page_num\": 1,\n    \"page_size\": 10\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 20,\n        \"total_page\": 2,\n        \"list\": [{\n            \"user_login\": \"test\",\n            \"download_at\": \"2026-06-23 14:33:00\",\n            \"action_name\": \"git_download\",\n            \"is_login\": \"true\",\n            \"is_bot\": \"false\"\n        }]\n    }\n}",
  "description" : "GitCode 单仓库某类下载的逐条明细记录（二级抽屉下钻）：下载用户/下载时间/下载方式。category=logged(已登录)/bot(机器人)/real(真实用户)/unlogged(未登录)/all(全部)。传 page_num+page_size 分页返回 {list,total_count,total_page}，不传则全量数组（供导出）",
  "requestBodyDefinition" : {
    "name" : "root",
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
      "value" : "hpckit",
      "description" : "社区",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 必须为 hpckit",
      "expression" : "^hpckit$",
      "children" : [ ]
    }, {
      "name" : "namespace",
      "value" : "hpckit",
      "description" : "组织 namespace",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "namespace 参数格式非法",
      "expression" : "^[\\w.\\-]{1,255}$",
      "children" : [ ]
    }, {
      "name" : "repo_path",
      "value" : "demo",
      "description" : "仓库名",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 参数格式非法",
      "expression" : "^[\\w.\\-]{1,255}$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "2026-06-23",
      "description" : "起始日期",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "start 日期格式必须为 YYYY-MM-DD",
      "expression" : "^\\d{4}-\\d{2}-\\d{2}$",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "2026-06-23",
      "description" : "结束日期",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "end 日期格式必须为 YYYY-MM-DD",
      "expression" : "^\\d{4}-\\d{2}-\\d{2}$",
      "children" : [ ]
    }, {
      "name" : "category",
      "value" : "logged",
      "description" : "下载分类：logged/bot/real/unlogged/all",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "category 取值非法",
      "expression" : "^(logged|bot|real|unlogged|all)$",
      "children" : [ ]
    }, {
      "name" : "page_num",
      "value" : "1",
      "description" : "页码（可选，从1开始；与 page_size 同时传才分页，否则全量返回）",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "page_size",
      "value" : "10",
      "description" : "每页条数（可选；与 page_num 同时传才分页）",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  },
  "responseBodyDefinition" : null
}

================================
// GitCode 单仓库逐条下载明细记录（二级抽屉下钻：下载用户/下载时间/下载方式）
// 入参校验由框架声明式 pattern（requestBodyDefinition）完成：community 严格限定 ^hpckit$、
// namespace/repo_path 限定 ^[\w.\-]{1,255}$、start/end 限定日期格式、category 限定枚举，
// 脚本内不再重复校验。community 必为 hpckit，拼进表名安全；其余走 #{} 绑定。
// category 只用于在脚本内 if 分支里选取固定 SQL 片段（不拼接用户原文），无注入风险。
// 分页：传 page_num + page_size 才分页，返回 {list,total_count,total_page}；不传则全量数组（供导出）。
var community = body.community;
var namespace = body.namespace;
var repo_path = body.repo_path;
var start = body.start;
var end = body.end;
var category = body.category;
var page_num = body.page_num;
var page_size = body.page_size;
var paged = page_num != null && page_size != null;
// 分类过滤片段：仅在固定白名单分支里取，绝不拼接 category 原文
var catFilter = '';
if (category == 'logged') {
    catFilter = " AND is_login = 'true'";
} else if (category == 'bot') {
    catFilter = " AND is_bot = 'true'";
} else if (category == 'real') {
    catFilter = " AND is_login = 'true' AND is_bot <> 'true'";
} else if (category == 'unlogged') {
    catFilter = " AND is_login = 'false'";
}
var table = 'fact_' + community + '_user_download';
// 预览/新社区环境该原始明细表可能尚未被 om-dataarts 建出：表不存在时返回空而非 500，
// 避免二级抽屉整页崩溃（community 已白名单校验，拼进 information_schema 查询安全）
var tableCheck = db.select("SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='" + table + "') AS ok");
if (tableCheck.size() == 0 || tableCheck[0].get("ok") != true) {
    if (paged) {
        return {list: [], total_count: 0, total_page: 0};
    }
    return [];
}
// 公共 FROM/WHERE（catFilter 仅取自固定白名单分支，无注入；start/end/namespace/repo_path 走 #{} 绑定）
var fromWhere = " FROM ${table}"
    + " WHERE code_platform = 'gitcode'"
    + "   AND stat_date >= #{start}::date AND stat_date <= #{end}::date"
    + "   AND namespace = #{namespace}"
    + "   AND repo_path = #{repo_path}" + catFilter;
var selectCols = "SELECT user_login,"
    + " COALESCE(raw_data->>'download_at', raw_data->>'created_time', stat_date::text) AS download_at,"
    + " action_name, is_login, is_bot";
var orderBy = " ORDER BY download_at DESC";

// 未传分页参数 → 全量返回（导出用；给一个高上限防御超大结果）
if (!paged) {
    return db.select(selectCols + fromWhere + orderBy + " LIMIT 100000");
}
var total = db.selectOne("SELECT COUNT(*) AS cnt" + fromWhere).cnt;
var ps = page_size;
var pn = page_num;
if (ps <= 0) { ps = 10; }
if (pn <= 0) { pn = 1; }
var offset = (pn - 1) * ps;
var list = db.select(selectCols + fromWhere + orderBy + " LIMIT #{ps} OFFSET #{offset}");
var total_page = (total + ps - 1) / ps;
return {list: list, total_count: total, total_page: total_page};

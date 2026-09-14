{
  "properties" : { },
  "id" : "b7c1e2a4d9f04c3ab1049gitcodedl01",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "GitCode仓库下载量明细",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repo/detail",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\n    \"community\": \"hpckit\",\n    \"start\": \"2026-06-01\",\n    \"end\": \"2026-06-30\",\n    \"page_num\": 1,\n    \"page_size\": 10\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 200,\n        \"total_page\": 20,\n        \"list\": [{\n            \"namespace\": \"hpckit\",\n            \"repo_path\": \"demo\",\n            \"unlogged_count\": 120,\n            \"logged_count\": 80,\n            \"bot_count\": 30,\n            \"real_user_count\": 50,\n            \"total_count\": 200\n        }]\n    }\n}",
  "description" : "GitCode 仓库下载量明细（以 fact_{community}_repo 为仓库维度 LEFT JOIN 下载聚合，无下载量的仓库也返回）；传 page_num+page_size 分页返回 {list,total_count,total_page}，不传则全量数组（供导出）",
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
      "name" : "start",
      "value" : "2026-06-01",
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
      "value" : "2026-06-30",
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
// GitCode 仓库下载量明细（仓库维度 = fact_{community}_repo，LEFT JOIN 下载聚合）
// issue #1049 用户反馈：原实现只从 dws 聚合表 GROUP BY，会漏掉"该时间段无下载量的仓库"。
// 改为以仓库维度表 fact_${community}_repo（gitcode + is_removed IS NULL + is_hide IS NULL）
// 驱动，LEFT JOIN 下载聚合表，保证所有有效仓库都出现（无下载则计数为 0）。
// 分页：传 page_num + page_size 才分页，返回 {list,total_count,total_page}；不传则全量数组（供导出）。
// 入参校验由框架声明式 pattern 完成：community 严格限定 ^hpckit$（拼进表名安全）、start/end 日期格式；
// start/end 走 #{} 绑定；表名由已校验的 community 拼出，直接拼接安全。
var community = body.community;
var start = body.start;
var end = body.end;
var page_num = body.page_num;
var page_size = body.page_size;
var repoTable = 'fact_' + community + '_repo';
var dwsTable = 'dws_' + community + '_gitcode_repo_download_daily';
var paged = page_num != null && page_size != null;

// 仓库维度表不存在（新社区/预览未建）→ 返回空，避免 relation 不存在 500
var repoCheck = db.select("SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='" + repoTable + "') AS ok");
if (repoCheck.size() == 0 || repoCheck[0].get("ok") != true) {
    if (paged) {
        return {list: [], total_count: 0, total_page: 0};
    }
    return [];
}
// 下载聚合表可能尚未建出：不存在时以纯仓库列表 + 全 0 计数返回（仍保证仓库不漏）
var dwsCheck = db.select("SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='" + dwsTable + "') AS ok");
var dwsExists = dwsCheck.size() > 0 && dwsCheck[0].get("ok") == true;

// 有效仓库过滤口径（issue #1049）：gitcode + is_removed IS NULL + is_hide IS NULL
var repoWhere = " WHERE r.code_platform = 'gitcode' AND r.is_removed IS NULL AND r.is_hide IS NULL ";

var selectBody;
if (dwsExists) {
    selectBody = "SELECT r.namespace, r.repo_path,"
        + " COALESCE(SUM(d.unlogged_count),0) AS unlogged_count,"
        + " COALESCE(SUM(d.logged_count),0) AS logged_count,"
        + " COALESCE(SUM(d.bot_count),0) AS bot_count,"
        + " COALESCE(SUM(d.real_user_count),0) AS real_user_count,"
        + " COALESCE(SUM(d.total_count),0) AS total_count"
        + " FROM " + repoTable + " r"
        + " LEFT JOIN " + dwsTable + " d"
        + "   ON d.namespace = r.namespace AND d.repo_path = r.repo_path"
        + "  AND d.stat_date >= #{start}::date AND d.stat_date <= #{end}::date"
        + repoWhere
        + " GROUP BY r.namespace, r.repo_path"
        + " ORDER BY total_count DESC, r.repo_path ASC";
} else {
    selectBody = "SELECT r.namespace, r.repo_path,"
        + " 0 AS unlogged_count, 0 AS logged_count, 0 AS bot_count,"
        + " 0 AS real_user_count, 0 AS total_count"
        + " FROM " + repoTable + " r"
        + repoWhere
        + " ORDER BY r.repo_path ASC";
}

// 未传分页参数 → 全量返回（兼容导出全部仓库）
if (!paged) {
    return db.select(selectBody);
}

// 分页：total = 有效仓库数（与列表 GROUP BY namespace,repo_path 的行数一致，去重计数）
var total = db.selectOne("SELECT COUNT(*) AS cnt FROM (SELECT 1 FROM " + repoTable + " r" + repoWhere + " GROUP BY r.namespace, r.repo_path) t").cnt;
var ps = page_size;
var pn = page_num;
if (ps <= 0) { ps = 10; }
if (pn <= 0) { pn = 1; }
var offset = (pn - 1) * ps;
var list = db.select(selectBody + " LIMIT #{ps} OFFSET #{offset}");
var total_page = (total + ps - 1) / ps;
return {list: list, total_count: total, total_page: total_page};

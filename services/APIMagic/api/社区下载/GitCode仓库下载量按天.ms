{
  "properties" : { },
  "id" : "b7c1e2a4d9f04c3ab1049gitcodedl02",
  "script" : null,
  "groupId" : "a1f4ebc89bf8425eaf857ea785af1015",
  "name" : "GitCode仓库下载量按天",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repo/daily",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\n    \"community\": \"hpckit\",\n    \"namespace\": \"hpckit\",\n    \"repo_path\": \"demo\",\n    \"start\": \"2026-06-01\",\n    \"end\": \"2026-06-30\"\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"stat_date\": \"2026-06-23\",\n        \"unlogged_count\": 12,\n        \"logged_count\": 8,\n        \"bot_count\": 3,\n        \"real_user_count\": 5,\n        \"total_count\": 20\n    }]\n}",
  "description" : "GitCode 单仓库下载量按天明细（抽屉下钻）",
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
    } ]
  },
  "responseBodyDefinition" : null
}

================================
// GitCode 单仓库下载量按天明细（抽屉下钻）
// 入参校验由框架声明式 pattern（requestBodyDefinition）完成：community 严格限定 ^hpckit$、
// namespace/repo_path 限定 ^[\w.\-]{1,255}$、start/end 限定日期格式，脚本内不再重复校验。
// community 必为 hpckit，拼进表名安全；namespace/repo_path/start/end 走 #{} 绑定。
var community = body.community;
var namespace = body.namespace;
var repo_path = body.repo_path;
var start = body.start;
var end = body.end;
var table = 'dws_' + community + '_gitcode_repo_download_daily';
// 预览/新社区环境该聚合表可能尚未被 om-dataarts 建出：表不存在时返回空数组而非 500，
// 避免抽屉下钻整页崩溃（community 已白名单校验，拼进 information_schema 查询安全）
var tableCheck = db.select("SELECT EXISTS(SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='" + table + "')");
if (tableCheck.size() == 0 || tableCheck[0].get("exists") != true) {
    return [];
}
var sql = """
SELECT stat_date,
       unlogged_count,
       logged_count,
       bot_count,
       real_user_count,
       total_count
FROM ${table}
WHERE stat_date >= #{start}::date AND stat_date <= #{end}::date
  AND namespace = #{namespace}
  AND repo_path = #{repo_path}
ORDER BY stat_date ASC
""";
return db.select(sql);

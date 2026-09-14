{
  "properties" : { },
  "id" : "a7c1e9d24f8b46f0a1b2c3d4e5f60711",
  "script" : null,
  "groupId" : "fee87ad3dfde4e33b4dd4bc0eb95ce14",
  "name" : "账号服务明细分页",
  "createTime" : null,
  "updateTime" : 1775640000000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/account/detail/page",
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
  }, {
    "name" : "permission",
    "value" : "datastatadmin_View",
    "description" : "允许拥有该权限的访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "requestBody" : "{\n    \"community\": \"openubmc\",\n    \"start\": 1748707200000,\n    \"end\": 1751385600000,\n    \"pageNum\": 1,\n    \"pageSize\": 10,\n    \"app_id\": \"\",\n    \"user_name\": \"\",\n    \"redirect_url\": \"\"\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"list\": [{\n            \"user_name\": \"alice\",\n            \"event\": \"login\",\n            \"account_type\": \"password\",\n            \"login_type\": \"web\",\n            \"created_at\": \"2026-07-01 10:00:00\",\n            \"updated_at\": \"2026-07-01 10:00:00\",\n            \"app_name\": \"openUBMC Studio\",\n            \"redirect_url\": \"https://sso.openubmc.cn/oauth2/authorize?client_id=694bab197dd332233c960f7e\"\n        }],\n        \"total_count\": 1\n    },\n    \"timestamp\": 1775640000000,\n    \"executeTime\": null\n}",
  "description" : "openUBMC 账号服务用户登录/注册明细分页查询。仅返回脱敏字段（无 email/phone/client_ip/detail），应用名称由 redirect_url 里的应用 ID 经 fact_community_authing_application 翻译；支持 redirect_url 模糊筛选。",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
// openUBMC 账号服务：用户登录/注册明细分页
// 仅返回脱敏字段白名单，绝不 select email/phone/client_ip/detail 等敏感或无关列。
// app_name 由 redirect_url 中的应用 ID 经 fact_community_authing_application 翻译（#{} 绑定，防注入）。
var community = body.community;
if (community == null || community == '') {
    HashMap empty = new HashMap();
    empty.put("list", []);
    empty.put("total_count", 0);
    return empty;
}
community = community.toLowerCase();
// 白名单校验：community 会拼入表名（${logTable}），必须限制为安全字符集，防 SQL 注入
if (!community.matches("^[a-z0-9_-]+$")) {
    HashMap empty = new HashMap();
    empty.put("list", []);
    empty.put("total_count", 0);
    return empty;
}

// 分页参数
var page_num = 1;
if (body.pageNum != null and body.pageNum != "") { page_num = body.pageNum; }
var page_size = 10;
if (body.pageSize != null and body.pageSize != "") { page_size = body.pageSize; }
var offset = (page_num - 1) * page_size;

var start = body.start;
var end = body.end;
var app_id = body.app_id;
var user_name = body.user_name;
var redirect_url = body.redirect_url;

var logTable = "fact_" + community + "_login_logs";

// 表不存在（该社区未采集登录日志）时返回空表，不抛 500
var tblExists = db.selectInt("""
    select count(1) from information_schema.tables
    where table_schema = 'public' and table_name = #{logTable}
""");
if (tblExists == 0) {
    HashMap empty = new HashMap();
    empty.put("list", []);
    empty.put("total_count", 0);
    return empty;
}

// app_name 由采集层 redirect_app_recognizer 识别后直接写入 login_logs 表，
// 不再通过 JOIN fact_community_authing_application 关联。
var sql = """
with logs as (
  select
    l.user_name,
    l.log_type as event,
    l.account_type,
    l.login_type,
    to_char(l.created_at at time zone 'UTC', 'YYYY-MM-DD HH24:MI:SS') as created_at,
    to_char(l.created_at at time zone 'UTC', 'YYYY-MM-DD HH24:MI:SS') as updated_at,
    l.redirect_url,
    coalesce(l.app_name, '-') as app_name,
    l.app_id
  from ${logTable} l
  <where>
        and l.user_name is not null and l.user_name != ''
    <if test="start != null and start != ''">
        and l.created_at >= to_timestamp(#{start}::double precision / 1000)
    </if>
    <if test="end != null and end != ''">
        and l.created_at <= to_timestamp(#{end}::double precision / 1000)
    </if>
    <if test="app_id != null and app_id != ''">
        and l.app_id = #{app_id}
    </if>
    <if test="user_name != null and user_name != ''">
        and l.user_name like '%' || #{user_name} || '%'
    </if>
    <if test="redirect_url != null and redirect_url != ''">
        and l.redirect_url like '%' || #{redirect_url} || '%'
    </if>
  </where>
)
select
    *,
    (select count(1) from logs) as total_count
from logs
order by created_at desc
limit #{page_size} offset #{offset}
"""
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
query_data.forEach(item -> {
    item.remove("total_count");
    return item;
})
HashMap result = new HashMap();
result.put("list", query_data);
result.put("total_count", total_count);
return result;

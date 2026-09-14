{
  "properties" : { },
  "id" : "daily-trend-1348-a1b2c3d4e5f6",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "贡献者每日趋势",
  "createTime" : null,
  "updateTime" : 1784400000000,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/user/daily-trend",
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
  "requestBody" : "{\r\n    \"community\": \"openeuler\",\r\n    \"user_login\": \"fundawang\",\r\n    \"event\": \"open-pr\",\r\n    \"start\": 1735689600000,\r\n    \"end\": 1784419199000\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : "#1348 贡献者下钻趋势图数据源：某用户在时间范围内、按天聚合的贡献数（合并PR/提交PR/Review），取自 dws_<community>_contribute_repo_user_daily（单用户+date 索引，openeuler 实测 ~112ms）。private='false' 与排行榜口径一致；总数=各天之和=榜数。前端按完整日期轴对 0 补齐。",
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
      "description" : "社区",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "user_login",
      "value" : "",
      "description" : "用户名",
      "required" : true,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "event",
      "value" : "",
      "description" : "pr=合并PR / open-pr=提交PR / review=Review",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "",
      "description" : "起始毫秒时间戳",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "",
      "description" : "结束毫秒时间戳",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pass",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  }
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
var community = body.community.toLowerCase();
var user_login = body.user_login;
var event = body.event;
// 日期边界按东八区转换，与明细表、排行榜口径保持一致
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 日期口径：合并PR 按 merged_at，提交PR/Review 按 created_at
var contributeTable = "dws_" + community + "_contribute";
var dateCol = 'created_at';
if (event == 'pr') {
    dateCol = 'merged_at';
}
var sql = """
SELECT to_char(ct.${dateCol}::DATE, 'YYYY-MM-DD') as date, count(*) as cnt
FROM ${contributeTable} ct
where ct.${dateCol}::date BETWEEN #{start} AND #{end}
    and ct.user_login = #{user_login}
    and ct.private = 'false'
    and ct.is_hide is null
    <if test="event == 'review'">
        and ct.contrib_type = 'comment' and ct.is_removed is null
        and ct.comment_type = 'pr_comment' and ct.is_invalid_comment = 0
    </if>
    <if test="event != 'review'">
        and ct.contrib_type = 'pr'
        <if test="event == 'pr'">
            and ct.state = 'merged'
        </if>
    </if>
group by ct.${dateCol}::DATE
order by ct.${dateCol}::DATE
""";
return db.select(sql);

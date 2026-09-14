{
  "properties" : { },
  "id" : "e338e16f17444363b0650f5ccaa60c92",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "开发者汇总分页",
  "createTime" : null,
  "updateTime" : 1774314772019,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/users/page",
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
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1758787187867,\r\n    \"community\":\"cannopen\",\r\n    \"orgList\":[],\r\n    \"internalList\":[],\r\n    \"metric\":\"company\",\r\n    \"pageNum\":1,\r\n    \"pageSize\":20,\r\n    \"asc\":\"\",\r\n    \"desc\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 3,\n        \"total_page\": 1,\n        \"list\": [{\n            \"company\": \"h-partners\",\n            \"company_type\": \"华为\",\n            \"d0\": 0,\n            \"d1\": 0,\n            \"d2\": 0,\n            \"d0_perc\": 0.0000,\n            \"d1_perc\": 0.0000,\n            \"d2_perc\": 0.0000\n        }, {\n            \"company\": \"个人贡献者\",\n            \"company_type\": \"个人贡献者\",\n            \"d0\": 23,\n            \"d1\": 14,\n            \"d2\": 2,\n            \"d0_perc\": 0.6389,\n            \"d1_perc\": 0.5185,\n            \"d2_perc\": 0.4000\n        }, {\n            \"company\": \"华为技术有限公司\",\n            \"company_type\": \"华为\",\n            \"d0\": 13,\n            \"d1\": 13,\n            \"d2\": 3,\n            \"d0_perc\": 0.3611,\n            \"d1_perc\": 0.4815,\n            \"d2_perc\": 0.6000\n        }]\n    },\n    \"timestamp\": 1758787770990,\n    \"executeTime\": 8\n}",
  "description" : null,
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
      "name" : "start",
      "value" : "1735689600000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1758785441144",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "end 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "community",
      "value" : "cannopen",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "community 参数格式非法",
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "orgList",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "internalList",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "metric",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "metric 只能为 company、sig 或 repo",
      "expression" : "^(company|sig|repo)?$",
      "children" : [ ]
    }, {
      "name" : "pageNum",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageNum 必须为正整数且不超过1000",
      "expression" : "pageNum > 0 && pageNum <= 1000",
      "children" : [ ]
    }, {
      "name" : "pageSize",
      "value" : "20",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "pageSize 必须为正整数且不超过100",
      "expression" : "pageSize > 0 && pageSize <= 100",
      "children" : [ ]
    }, {
      "name" : "asc",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "asc 字段非法",
      "expression" : "^(D0|D1|D2|d0_perc|d1_perc|d2_perc)?$",
      "children" : [ ]
    }, {
      "name" : "desc",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "desc 字段非法",
      "expression" : "^(D0|D1|D2|d0_perc|d1_perc|d2_perc)?$",
      "children" : [ ]
    } ]
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
            "name" : "company_type",
            "value" : "个人贡献者",
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
            "name" : "d0",
            "value" : "1999",
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
            "name" : "d1",
            "value" : "1999",
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
            "name" : "d2",
            "value" : "1999",
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
            "name" : "d0_perc",
            "value" : "0.8070",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "d1_perc",
            "value" : "0.8070",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          }, {
            "name" : "d2_perc",
            "value" : "0.8070",
            "description" : "",
            "required" : false,
            "dataType" : "Double",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          } ]
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1745199404673",
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
      "value" : "51",
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
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 服务平台
var source = body.source;
// 组织
var orgList = body.orgList;
// 内外部
var internalList = body.internalList;
// 是否私仓
var private = body.private;
// 贡献类型：pr,issue,comment
var event = body.event;
// topn
var page_num = body.pageNum;
var page_size = body.pageSize;
var offset = (page_num - 1) * page_size
var order_asc = "";
if (body.asc != null and body.asc != ""){
    if (body.asc == "D0"){
        order_asc = "d0 asc"
    }
    if (body.asc == "D1"){
        order_asc = "d1 asc"
    }
    if (body.asc == "D2"){
        order_asc = "d2 asc"
    }
}
var order_desc = "";
if (body.desc != null and body.desc != ""){
    if (body.desc == "D0"){
        order_desc = "d0 desc"
    }
    if (body.desc == "D1"){
        order_desc = "d1 desc"
    }
    if (body.desc == "D2"){
        order_desc = "d2 desc"
    }
}
var order_by = "";
if (order_asc != "" and order_desc != ""){
    order_by = order_asc + "," + order_desc;
} else {
    if (order_asc != "" ){
        order_by = order_asc;
    }
    if (order_desc != ""){
        order_by = order_desc;
    }
}
// company_type-组织 company-组织明细 sig-SIG repo-仓库 user-开发者
var metric = body.metric;
var columnStr = '';
var columnArr = [];
var table_sub = metric;
if (metric == 'company_type'){
    columnStr = 'company_type'
    table_sub = 'company'
    columnArr = ['company_type']
} else if (metric == 'company'){
    columnStr = 'company,company_type'
    columnArr = ['company','company_type']
} else if(metric == 'sig'){
    columnStr = 'sig_name'
    columnArr = ['sig_name']
} else if(metric == 'repo'){
    columnStr = 'repo_path,repo_url'
    columnArr = ['repo_path','repo_url']
} else if(metric == 'user'){
    columnStr = 'user_level'
    columnArr = ['user_level']
}
// 社区
var community = body.community.toLowerCase();
// 贡献表
var contributeTable = "dwm_"+community+"_contribute_user_" + table_sub;
var repoTable = "fact_" + community + "_repo";
var sigTable = "fact_"+community+"_sig_user";
var companyTable = "dwm_"+community+"_company";
var sql = """
WITH dim_table AS (
    <if test="metric == 'repo'">
        select 
        repo_path, html_url as repo_url
        from ${repoTable}
    </if>
    <if test="metric == 'sig'">
        select 
            distinct sig_name
        from ${sigTable}
    </if>
    <if test="metric == 'company_type'">
        select 
            distinct company_type
        from ${companyTable}
    </if>
    <if test="metric == 'company'">
        select 
            distinct company,company_type
        from ${companyTable}
    </if>
    <where>
        (is_hide is null)
        <if test="metric == 'sig'">
            and sig_name is not null
        </if>
        <if test="metric == 'repo' and source != null and source != ''">
            and code_platform = #{source}
        </if>
        <if test="metric == 'repo' and private != null and private != ''">
            and private = #{private}
        </if>
        <if test="orgList != null and orgList.size() > 0">
            and namespace in
            <foreach collection="orgList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="(metric == 'company' or metric == 'company_type') and internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="metric_value_arr != null and metric_value_arr.size() > 0">
            and ${coreColumn} in
            <foreach collection="metric_value_arr" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
),
fixed_levels AS (
    SELECT unnest(array['D0', 'D1', 'D2'])::text AS user_level
),
full_combinations AS (
    SELECT ds.*, fl.user_level
    FROM dim_table ds
    CROSS JOIN fixed_levels fl
),
filter_table AS (
    SELECT
        ${columnStr}, user_login, d0_time, d1_time, d2_time
    FROM ${contributeTable}
    <where>
        <if test="source != null and source != ''">
            and source = #{source}
        </if>
        <if test="private != null and private != ''">
            and private = #{private}
        </if>
        <if test="orgList != null and orgList.size() > 0">
            and namespace in
            <foreach collection="orgList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
        <if test="internalList != null and internalList.size() > 0">
            and internal in
            <foreach collection="internalList" item="item" open="(" separator="," close=")">
                #{item}
            </foreach>
        </if>
    </where>
),
data AS (
    select
        ${columnStr}, 'D0' as user_level, count(1) as total
    from filter_table
    where d0_time::date BETWEEN #{start} AND #{end}
    group by ${columnStr}
    union all
    select
        ${columnStr}, 'D1' as user_level, count(1) as total
    from filter_table
    where d1_time is not null and (d1_time::date BETWEEN #{start} AND #{end})
    group by ${columnStr}
    union all
    select
        ${columnStr}, 'D2' as user_level, count(1) as total
    from filter_table
     where d2_time is not null and (d2_time::date BETWEEN #{start} AND #{end})
    group by ${columnStr}
),
joined_data AS (
    SELECT 
        fc.*,
        COALESCE(d.total, 0) AS total
    FROM full_combinations fc
    LEFT JOIN data d ON fc.user_level =  d.user_level and
    <if test="columnArr != null and columnArr.size() > 0">
        <foreach collection="columnArr" item="item"  separator=" AND ">
            d.${item} = fc.${item}
        </foreach>
    </if>
),
group_data AS (
    select
        ${columnStr},
        COALESCE(SUM(CASE WHEN user_level = 'D0' THEN total ELSE 0 END), 0) AS D0,
        COALESCE(SUM(CASE WHEN user_level = 'D1' THEN total ELSE 0 END), 0) AS D1,
        COALESCE(SUM(CASE WHEN user_level = 'D2' THEN total ELSE 0 END), 0) AS D2
    from joined_data
    group by ${columnStr}
),
total_data AS (
    select
        sum(D0) as d0_sum,
        sum(D1) as d1_sum,
        sum(D2) as d2_sum
    from group_data
)
SELECT 
    group_data.*,
    ROUND(
        CASE
            WHEN td.d0_sum = 0 THEN 0
            ELSE D0::NUMERIC / td.d0_sum
        END::NUMERIC , 4
    ) as d0_perc,
    ROUND(
        CASE
            WHEN td.d1_sum = 0 THEN 0
            ELSE D1::NUMERIC / td.d1_sum
        END::NUMERIC , 4
    ) as d1_perc,
    ROUND(
        CASE
            WHEN td.d2_sum = 0 THEN 0
            ELSE D2::NUMERIC / td.d2_sum
        END::NUMERIC , 4
    ) as d2_perc,
    (select count(1) from group_data) as total_count,
    CEIL((select count(1) from group_data)::numeric/#{page_size}) as total_page
FROM 
    group_data, total_data td
<if test="order_by != ''">
    ORDER BY ${order_by}
</if>
LIMIT #{page_size} OFFSET #{offset}
""";
var query_data = db.select(sql);
var total_count = query_data.size() > 0 ? query_data[0].get("total_count") : 0;
var total_page = query_data.size() > 0 ? query_data[0].get("total_page") : 0;
query_data.forEach(item -> {
   item.remove("total_count");
   item.remove("total_page");
   return item;
})
HashMap result = new HashMap();
result.put("list",query_data);
result.put("total_count",total_count);
result.put("total_page",total_page);
return result

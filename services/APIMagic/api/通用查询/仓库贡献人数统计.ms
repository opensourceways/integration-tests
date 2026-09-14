{
  "properties" : { },
  "id" : "83f6ccebc5444935a785c91b71d8659b",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "仓库贡献人数统计",
  "createTime" : null,
  "updateTime" : 1773907034051,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/repo/user/page",
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
  "requestBody" : "{\r\n    \"start\":1730419200000,\r\n    \"end\":1764215445119,\r\n    \"community\":\"cannopen\",\r\n    \"namespace\":\"\",\r\n    \"repo_path\":\"\",\r\n    \"private\": \"false\",\r\n    \"asc\":\"\",\r\n    \"desc\":\"in_user_count\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"sort_field\": \"total_user_count,in_user_count,out_user_count\",\n        \"total_count\": 37,\n        \"total_page\": 4,\n        \"filter_field\": \"repo_path\",\n        \"list\": [{\n            \"repo_path\": \"ops-transformer\",\n            \"download_count\": 15580,\n            \"total_user_count\": 216,\n            \"in_user_count\": 175,\n            \"out_user_count\": 41,\n            \"top_users\": \"turing_project1,cann-robot,ascend-robot,openLiBing-bot,yyoean\"\n        }, {\n            \"repo_path\": \"ops-nn\",\n            \"download_count\": 18266,\n            \"total_user_count\": 201,\n            \"in_user_count\": 149,\n            \"out_user_count\": 52,\n            \"top_users\": \"turing_project1,cann-robot,ascend-robot,openLiBing-bot,yu-fachen\"\n        }, {\n            \"repo_path\": \"ascend-transformer-boost\",\n            \"download_count\": 70368,\n            \"total_user_count\": 163,\n            \"in_user_count\": 121,\n            \"out_user_count\": 42,\n            \"top_users\": \"AtlasAccount,cann-robot,turing_project1,I-am-a-robot,ascend-robot\"\n        }, {\n            \"repo_path\": \"ops-math\",\n            \"download_count\": 11223,\n            \"total_user_count\": 176,\n            \"in_user_count\": 103,\n            \"out_user_count\": 73,\n            \"top_users\": \"turing_project1,cann-robot,ascend-robot,liuxiqiang,openLiBing-bot\"\n        }, {\n            \"repo_path\": \"cann-recipes-infer\",\n            \"download_count\": 13923,\n            \"total_user_count\": 121,\n            \"in_user_count\": 81,\n            \"out_user_count\": 40,\n            \"top_users\": \"turing_project1,cann-robot,ascend-robot,openLiBing-bot,linqiang21\"\n        }, {\n            \"repo_path\": \"community\",\n            \"download_count\": 2902,\n            \"total_user_count\": 87,\n            \"in_user_count\": 63,\n            \"out_user_count\": 24,\n            \"top_users\": \"turing_project1,ascend-robot,cann-robot,shentukangjun,gubaocheng\"\n        }, {\n            \"repo_path\": \"catlass\",\n            \"download_count\": 25185,\n            \"total_user_count\": 89,\n            \"in_user_count\": 53,\n            \"out_user_count\": 36,\n            \"top_users\": \"AtlasAccount,turing_project1,cann-robot,I-am-a-robot,ascend-robot\"\n        }, {\n            \"repo_path\": \"ops-cv\",\n            \"download_count\": 2854,\n            \"total_user_count\": 55,\n            \"in_user_count\": 43,\n            \"out_user_count\": 12,\n            \"top_users\": \"turing_project1,cann-robot,ascend-robot,openLiBing-bot,wangyunxiang1\"\n        }, {\n            \"repo_path\": \"ascend-boost-comm\",\n            \"download_count\": 35102,\n            \"total_user_count\": 36,\n            \"in_user_count\": 30,\n            \"out_user_count\": 6,\n            \"top_users\": \"AtlasAccount,I-am-a-robot,turing_project1,cann-robot,ascend-robot\"\n        }, {\n            \"repo_path\": \"opbase\",\n            \"download_count\": 2232,\n            \"total_user_count\": 37,\n            \"in_user_count\": 25,\n            \"out_user_count\": 12,\n            \"top_users\": \"turing_project1,ascend-robot,cann-robot,openLiBing-bot,liuks\"\n        }]\n    },\n    \"timestamp\": 1767865099085,\n    \"executeTime\": 43\n}",
  "description" : null,
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
      "name" : "start",
      "value" : "1730419200000",
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
      "value" : "1764215445119",
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
      "name" : "namespace",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "namespace 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-]*$",
      "children" : [ ]
    }, {
      "name" : "repo_path",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "repo_path 格式非法",
      "expression" : "^[a-zA-Z0-9_\\-/.]*$",
      "children" : [ ]
    }, {
      "name" : "private",
      "value" : "false",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "private 只能为 true 或 false",
      "expression" : "^(true|false)?$",
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
      "expression" : "^(total_user_count|in_user_count|out_user_count|download_count)?$",
      "children" : [ ]
    }, {
      "name" : "desc",
      "value" : "in_user_count",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "desc 字段非法",
      "expression" : "^(total_user_count|in_user_count|out_user_count|download_count)?$",
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
        "name" : "sort_field",
        "value" : "total_user_count,in_user_count,out_user_count",
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
        "name" : "total_count",
        "value" : "36",
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
        "value" : "4",
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
        "name" : "filter_field",
        "value" : "repo_path",
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
            "name" : "repo_path",
            "value" : "ops-transformer",
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
            "name" : "download_count",
            "value" : "15580",
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
            "name" : "total_user_count",
            "value" : "216",
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
            "name" : "in_user_count",
            "value" : "174",
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
            "name" : "out_user_count",
            "value" : "42",
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
            "name" : "top_users",
            "value" : "turing_project1,yyoean",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1767171240564",
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
      "value" : "29",
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
import java.util.Arrays;
import '@/util/timestamp2Date' as timestamp2Date;
import  magic;
Date start = null;
if (body.start != null and body.start != '') {
    start = timestamp2Date(body.start);
}
Date end = null;
if (body.end != null and body.end != '') {
    end = timestamp2Date(body.end);
}
var filter_field = ["repo_path"];
var sort_field = ["download_count", "total_user_count", "in_user_count", "out_user_count"];
// 社区
var community = body.community;
// 组织
var namespace = body.namespace;
// 仓库
var repo_path = body.repo_path;
var asc_tem  = body.asc;
var desc_tem  = body.desc;
// 排序
var order_by_set = new HashSet()
var order_asc = "";
if (asc_tem != null and asc_tem != "") {
    var asc_arr = asc_tem.split(",");
    for(index,item in asc_arr){
        if (sort_field.contains(item)) {
            order_by_set.add(item + " asc");
        }
    }
}
var order_desc = "";
if (desc_tem != null and desc_tem != "") {
    var desc_arr = desc_tem.split(",");
    for(index,item in desc_arr){
        if (sort_field.contains(item)) {
            order_by_set.add(item + " desc");
        }
    }
}
var order_by = null;
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
// page param
var page_num = 1;
if (body.pageNum != null and body.pageNum != ""){
    page_num = body.pageNum;
}
if (body.page_num != null and body.page_num != ""){
    page_num = body.page_num;
}
var page_size = 10;
if (body.pageSize != null and body.pageSize != ""){
    page_size = body.pageSize;
}
if (body.page_size != null and body.page_size != ""){
    page_size = body.page_size;
}
var offset = (page_num - 1) * page_size
var internal_in_value ='内部'
var internal_out_value ='外部'
var dwm_contribute_user_repo = "dwm_" + community + "_contribute_user_repo";
var contributeTable = "dws_" + community + "_contribute_repo_user_daily";
var repoTable = "fact_" + community + "_repo";
var downloadTable = "fact_" + community + "_download";
var sql = """
    WITH repo_dim as (
        select 
            distinct namespace, repo_path
        from ${repoTable}
        where is_hide is null and is_removed is null
    ),
    repo_download as (
        select namespace, repo_path, sum(day_count) as download_count
        from ${downloadTable}
        <where>
            <if test="start != null ">
                and created_at::date >= #{start}
            </if>
            <if test="end != null ">
                and created_at::date <= #{end}
            </if>
            <if test="namespace != null and namespace != ''">
                and ct.namespace = #{namespace}
            </if>
            <if test="repo_path != null and repo_path != ''">
                and ct.repo_path = #{repo_path}
            </if>
        </where>
        group by namespace, repo_path
    ),
    repo_user_in as (
        select namespace, repo_path, count(1) as user_count
        from ${dwm_contribute_user_repo}
        <where>
            internal = #{internal_in_value}
            and user_login not in (select user_login from fact_community_robot_user)
            <if test="start != null ">
                and d1_time::date >= #{start}
            </if>
            <if test="end != null ">
                and d1_time::date <= #{end}
            </if>
            <if test="namespace != null and namespace != ''">
                and ct.namespace = #{namespace}
            </if>
            <if test="repo_path != null and repo_path != ''">
                and ct.repo_path = #{repo_path}
            </if>
        </where>
        group by namespace, repo_path
    ),
    repo_user_out as (
        select namespace, repo_path, count(1) as user_count
        from ${dwm_contribute_user_repo}
        <where>
            internal = #{internal_out_value}
            and user_login not in (select user_login from fact_community_robot_user)
            <if test="start != null ">
                and d1_time::date >= #{start}
            </if>
            <if test="end != null ">
                and d1_time::date <= #{end}
            </if>
            <if test="namespace != null and namespace != ''">
                and ct.namespace = #{namespace}
            </if>
            <if test="repo_path != null and repo_path != ''">
                and ct.repo_path = #{repo_path}
            </if>
        </where>
        group by namespace, repo_path
    ),
    repo_user_data AS (
        SELECT
            namespace, repo_path, user_login, sum(pr_incre * 10 + issue_incre + comment_incre) as d1_count,
            ROW_NUMBER() OVER (PARTITION BY namespace, repo_path ORDER BY SUM(pr_incre * 10 + issue_incre + comment_incre) DESC) AS rn
        FROM ${contributeTable} 
        <where>
            internal = #{internal_out_value} and (pr_incre > 0 or issue_incre > 0 or comment_incre > 0)
            and user_login not in (select user_login from fact_community_robot_user)
            <if test="start != null ">
                and date >= #{start}
            </if>
            <if test="end != null ">
                and date <= #{end}
            </if>
            <if test="namespace != null and namespace != ''">
                and ct.namespace = #{namespace}
            </if>
            <if test="repo_path != null and repo_path != ''">
                and ct.repo_path = #{repo_path}
            </if>
        </where>
        group by namespace, repo_path, user_login
    ),
    top_repo_user as (
        SELECT namespace, repo_path, STRING_AGG(user_login, ',' ORDER BY d1_count DESC) AS top_users 
        FROM repo_user_data where rn <= 5
        group by namespace, repo_path
    ),
    combined_data as (
        select 
            rd.repo_path,
            COALESCE(rdd.download_count, 0) as download_count,
            COALESCE(rui.user_count, 0) + COALESCE(ruo.user_count, 0) as total_user_count,
            COALESCE(rui.user_count, 0) as in_user_count, 
            COALESCE(ruo.user_count, 0) as out_user_count, 
            tru.top_users
        from repo_dim rd 
        left join repo_download rdd on rd.namespace = rdd.namespace and rd.repo_path = rdd.repo_path
        left join repo_user_in rui on rd.namespace = rui.namespace and rd.repo_path = rui.repo_path
        left join repo_user_out ruo on rd.namespace = ruo.namespace and rd.repo_path = ruo.repo_path
        left join top_repo_user tru on rd.namespace = tru.namespace and rd.repo_path = tru.repo_path
    ),
    count_ori as (
        select count(1) as total_count from combined_data
    )
    SELECT 
        cd.*,
        co.total_count, 
        CEIL(co.total_count::numeric/#{page_size}) as total_page
    FROM 
        combined_data cd, count_ori co
    <if test="order_by != null and order_by != ''">
        ORDER BY ${order_by}
    </if>
    LIMIT #{page_size} OFFSET #{offset}
""";
// #1312 判定「超级社区」（昇腾系列总/主导开源/参与开源聚合看板）：
// 用集合判定（与前端 MIND_SERIES 对齐），不查 fact_community_structure，
// 避免预览环境该表未种子化时 isSuper 查询抛错导致接口 code=-1。
// 子社区列表仍从 fact_community_structure 读取（仅 isSuper 命中后才查）。
var isSuper = ["mindall","mindlead","mindjoin"].contains(community);
if (isSuper){
    // issue#1295 缺陷2：只取有效子社区（status='active'），失效子社区（如 mindseriessdk）status 非 active，会被自动剔除
    var sub_community_sql = "select name from fact_community_structure where parent_name = #{community} and status = 'active'"
    var sub_community_data = db.select(sub_community_sql);
    var sub_community_list = []
    sub_community_data.forEach(item -> {
        sub_community_list.add(item.get("name"))
    })
    sql = """
        WITH community_dim as (
            select name as sub_community from fact_community_structure where parent_name = #{community} and status = 'active'
        ),
        repo_download as (
            <foreach collection="sub_community_list" item="item" separator=" union all ">
                select #{item} as sub_community, sum(day_count) as download_count
                from fact_${item}_download
                <where>
                    <if test="start != null ">
                        and created_at::date >= #{start}
                    </if>
                    <if test="end != null ">
                        and created_at::date <= #{end}
                    </if>
                </where>
            </foreach>
        ),
        repo_user_in as (
            <foreach collection="sub_community_list" item="item" separator=" union all ">
                select #{item} as sub_community, count(1) as user_count
                from dwm_${item}_contribute_user_repo
                <where>
                    internal = #{internal_in_value}
                    and user_login not in (select user_login from fact_community_robot_user)
                    <if test="start != null ">
                        and d1_time::date >= #{start}
                    </if>
                    <if test="end != null ">
                        and d1_time::date <= #{end}
                    </if>
                </where>
            </foreach>
        ),
        repo_user_out as (
            <foreach collection="sub_community_list" item="item" separator=" union all ">
                select #{item} as sub_community, count(1) as user_count
                from dwm_${item}_contribute_user_repo
                <where>
                    internal = #{internal_out_value}
                    and user_login not in (select user_login from fact_community_robot_user)
                    <if test="start != null ">
                        and d1_time::date >= #{start}
                    </if>
                    <if test="end != null ">
                        and d1_time::date <= #{end}
                    </if>
                </where>
            </foreach>
        ),
        repo_user_data AS (
            <foreach collection="sub_community_list" item="item" separator=" union all ">
                SELECT
                    #{item} as sub_community, user_login, sum(pr_incre * 10 + issue_incre + comment_incre) as d1_count,
                    ROW_NUMBER() OVER (ORDER BY SUM(pr_incre * 10 + issue_incre + comment_incre) DESC) AS rn
                FROM dws_${item}_contribute_repo_user_daily
                <where>
                    internal = #{internal_out_value} and (pr_incre > 0 or issue_incre > 0 or comment_incre > 0)
                    and user_login not in (select user_login from fact_community_robot_user)
                    <if test="start != null ">
                        and date >= #{start}
                    </if>
                    <if test="end != null ">
                        and date <= #{end}
                    </if>
                </where>
                group by user_login
            </foreach>
        ),
        top_repo_user as (
            SELECT sub_community, STRING_AGG(user_login, ',' ORDER BY d1_count DESC) AS top_users 
            FROM repo_user_data where rn <= 5
            group by sub_community
        ),
        combined_data as (
            select 
                rd.sub_community,
                COALESCE(rdd.download_count, 0) as download_count,
                COALESCE(rui.user_count, 0) + COALESCE(ruo.user_count, 0) as total_user_count,
                COALESCE(rui.user_count, 0) as in_user_count, 
                COALESCE(ruo.user_count, 0) as out_user_count, 
                tru.top_users
            from community_dim rd 
            left join repo_download rdd on rd.sub_community = rdd.sub_community
            left join repo_user_in rui on rd.sub_community = rui.sub_community
            left join repo_user_out ruo on rd.sub_community = ruo.sub_community
            left join top_repo_user tru on rd.sub_community = tru.sub_community
        ),
        count_ori as (
            select count(1) as total_count from combined_data
        )
        SELECT 
            cd.*,
            co.total_count, 
            CEIL(co.total_count::numeric/#{page_size}) as total_page
        FROM 
            combined_data cd, count_ori co
        <if test="order_by != null and order_by != ''">
            ORDER BY ${order_by}
        </if>
        LIMIT #{page_size} OFFSET #{offset}
    """
}
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
result.put("filter_field","repo_path");
result.put("sort_field", "total_user_count,in_user_count,out_user_count");
return result

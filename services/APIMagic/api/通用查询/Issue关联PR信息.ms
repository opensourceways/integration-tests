{
  "properties" : { },
  "id" : "1111824f845f45d392cc81919c281e83",
  "script" : null,
  "groupId" : "39c33765c93e4af089275fbe9ae18d07",
  "name" : "Issue关联PR信息",
  "createTime" : null,
  "updateTime" : 1768372934774,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/issue/ref/pr",
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
  "requestBody" : "{\r\n    \"start\":1759276800000,\r\n    \"end\":1767168725887,\r\n    \"community\":\"cannopen\",\r\n    \"namespace\":\"\",\r\n    \"repo_path\":\"\",\r\n    \"sig_group\":\"tools\",\r\n    \"pr_number\": \"\",\r\n    \"pr_user\": \"\",\r\n    \"commiter\": \"\",\r\n    \"pr_state\": \"\",\r\n    \"issue_number\": \"\",\r\n    \"issue_state\": \"\",\r\n    \"asc\":\"\",\r\n    \"desc\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total_count\": 2139,\n        \"total_page\": 214,\n        \"filter_field\": \"title,creator,pr_type,state\",\n        \"list\": [{\n            \"namespace\": \"cann\",\n            \"repo_path\": \"amct\",\n            \"repo_url\": \"https://gitcode.com/cann/amct\",\n            \"sig_group\": \"tools\",\n            \"pr_number\": \"10\",\n            \"pr_url\": \"https://gitcode.com/cann/amct/merge_requests/10\",\n            \"pr_state\": \"open\",\n            \"pr_user\": \"wangyuan_5a4c\",\n            \"commiter\": \"wulinyu,fujun19\",\n            \"issue_number\": \"9\",\n            \"issue_url\": \"https://gitcode.com/cann/amct/issues/9\",\n            \"issue_state\": \"open\"\n        }, {\n            \"namespace\": \"cann\",\n            \"repo_path\": \"amct\",\n            \"repo_url\": \"https://gitcode.com/cann/amct\",\n            \"sig_group\": \"tools\",\n            \"pr_number\": \"11\",\n            \"pr_url\": \"https://gitcode.com/cann/amct/merge_requests/11\",\n            \"pr_state\": \"merged\",\n            \"pr_user\": \"yaoguangxiu\",\n            \"commiter\": null,\n            \"issue_number\": \"10\",\n            \"issue_url\": \"https://gitcode.com/cann/amct/issues/10\",\n            \"issue_state\": \"closed\"\n        }, {\n            \"namespace\": \"cann\",\n            \"repo_path\": \"amct\",\n            \"repo_url\": \"https://gitcode.com/cann/amct\",\n            \"sig_group\": \"tools\",\n            \"pr_number\": \"2\",\n            \"pr_url\": \"https://gitcode.com/cann/amct/merge_requests/2\",\n            \"pr_state\": \"merged\",\n            \"pr_user\": \"RQL7\",\n            \"commiter\": null,\n            \"issue_number\": \"3\",\n            \"issue_url\": \"https://gitcode.com/cann/amct/issues/3\",\n            \"issue_state\": \"closed\"\n        }, {\n            \"namespace\": \"cann\",\n            \"repo_path\": \"amct\",\n            \"repo_url\": \"https://gitcode.com/cann/amct\",\n            \"sig_group\": \"tools\",\n            \"pr_number\": \"3\",\n            \"pr_url\": \"https://gitcode.com/cann/amct/merge_requests/3\",\n            \"pr_state\": \"merged\",\n            \"pr_user\": \"SwaggyAlex\",\n            \"commiter\": null,\n            \"issue_number\": \"2\",\n            \"issue_url\": \"https://gitcode.com/cann/amct/issues/2\",\n            \"issue_state\": \"closed\"\n        }, {\n            \"namespace\": \"cann\",\n            \"repo_path\": \"amct\",\n            \"repo_url\": \"https://gitcode.com/cann/amct\",\n            \"sig_group\": \"tools\",\n            \"pr_number\": \"4\",\n            \"pr_url\": \"https://gitcode.com/cann/amct/merge_requests/4\",\n            \"pr_state\": \"merged\",\n            \"pr_user\": \"RQL7\",\n            \"commiter\": null,\n            \"issue_number\": \"4\",\n            \"issue_url\": \"https://gitcode.com/cann/amct/issues/4\",\n            \"issue_state\": \"closed\"\n        }, {\n            \"namespace\": \"cann\",\n            \"repo_path\": \"amct\",\n            \"repo_url\": \"https://gitcode.com/cann/amct\",\n            \"sig_group\": \"tools\",\n            \"pr_number\": \"6\",\n            \"pr_url\": \"https://gitcode.com/cann/amct/merge_requests/6\",\n            \"pr_state\": \"merged\",\n            \"pr_user\": \"sophia1213\",\n            \"commiter\": null,\n            \"issue_number\": \"5\",\n            \"issue_url\": \"https://gitcode.com/cann/amct/issues/5\",\n            \"issue_state\": \"closed\"\n        }, {\n            \"namespace\": \"cann\",\n            \"repo_path\": \"amct\",\n            \"repo_url\": \"https://gitcode.com/cann/amct\",\n            \"sig_group\": \"tools\",\n            \"pr_number\": \"7\",\n            \"pr_url\": \"https://gitcode.com/cann/amct/merge_requests/7\",\n            \"pr_state\": \"merged\",\n            \"pr_user\": \"RQL7\",\n            \"commiter\": \"yaoguangxiu\",\n            \"issue_number\": \"6\",\n            \"issue_url\": \"https://gitcode.com/cann/amct/issues/6\",\n            \"issue_state\": \"closed\"\n        }, {\n            \"namespace\": \"cann\",\n            \"repo_path\": \"amct\",\n            \"repo_url\": \"https://gitcode.com/cann/amct\",\n            \"sig_group\": \"tools\",\n            \"pr_number\": \"8\",\n            \"pr_url\": \"https://gitcode.com/cann/amct/merge_requests/8\",\n            \"pr_state\": \"open\",\n            \"pr_user\": \"SwaggyAlex\",\n            \"commiter\": null,\n            \"issue_number\": \"7\",\n            \"issue_url\": \"https://gitcode.com/cann/amct/issues/7\",\n            \"issue_state\": \"open\"\n        }, {\n            \"namespace\": \"cann\",\n            \"repo_path\": \"amct\",\n            \"repo_url\": \"https://gitcode.com/cann/amct\",\n            \"sig_group\": \"tools\",\n            \"pr_number\": \"9\",\n            \"pr_url\": \"https://gitcode.com/cann/amct/merge_requests/9\",\n            \"pr_state\": \"merged\",\n            \"pr_user\": \"RQL7\",\n            \"commiter\": \"yaoguangxiu\",\n            \"issue_number\": \"8\",\n            \"issue_url\": \"https://gitcode.com/cann/amct/issues/8\",\n            \"issue_state\": \"closed\"\n        }, {\n            \"namespace\": \"cann\",\n            \"repo_path\": \"asc-devkit\",\n            \"repo_url\": \"https://gitcode.com/cann/asc-devkit\",\n            \"sig_group\": \"ascendc\",\n            \"pr_number\": \"123\",\n            \"pr_url\": \"https://gitcode.com/cann/asc-devkit/merge_requests/123\",\n            \"pr_state\": \"closed\",\n            \"pr_user\": \"lzh5665661111\",\n            \"commiter\": \"DragonBornHD84,yangbinhua,chenyiyuan,wqtshg_wt,gao_dafa,xun_zhuge\",\n            \"issue_number\": \"37\",\n            \"issue_url\": \"https://gitcode.com/cann/asc-devkit/issues/37\",\n            \"issue_state\": \"open\"\n        }]\n    },\n    \"timestamp\": 1768372895418,\n    \"executeTime\": 241\n}",
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
      "value" : "1759276800000",
      "description" : "开始时间，格式为毫秒时间戳",
      "required" : true,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : "start 必须为合法的毫秒级时间戳",
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1767168725887",
      "description" : "结束时间，格式为毫秒时间戳",
      "required" : true,
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
      "description" : "社区，查询所属社区",
      "required" : true,
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
      "description" : "namespace",
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
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "sig_group",
      "value" : "",
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
      "name" : "pr_number",
      "value" : "",
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
      "name" : "pr_user",
      "value" : "",
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
      "name" : "commiter",
      "value" : "",
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
      "name" : "pr_state",
      "value" : "",
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
      "name" : "issue_number",
      "value" : "",
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
      "name" : "issue_state",
      "value" : "",
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
      "name" : "asc",
      "value" : "",
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
      "name" : "desc",
      "value" : "",
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
        "value" : "2173",
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
        "value" : "218",
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
        "value" : "title,creator,pr_type,state",
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
            "name" : "namespace",
            "value" : "cann",
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
            "value" : "amct",
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
            "name" : "repo_url",
            "value" : "https://gitcode.com/cann/amct",
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
            "name" : "sig_group",
            "value" : "tools",
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
            "name" : "pr_number",
            "value" : "10",
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
            "name" : "pr_url",
            "value" : "https://gitcode.com/cann/amct/merge_requests/10",
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
            "name" : "pr_state",
            "value" : "open",
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
            "name" : "pr_user",
            "value" : "wangyuan_5a4c",
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
            "name" : "commiter",
            "value" : "wulinyu,fujun19",
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
            "name" : "issue_number",
            "value" : "9",
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
            "name" : "issue_url",
            "value" : "https://gitcode.com/cann/amct/issues/9",
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
            "name" : "issue_state",
            "value" : "open",
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
      "value" : "1768372733230",
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
      "value" : "684",
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
var filter_field = ["namespace", "repo_path", "sig_group", "pr_number", "pr_user", "pr_state", "commiter", "issue_number", "issue_state"];
var sort_field = ["open_time", "first_reply_time", "created_at"];
// 社区
var community = body.community;
// 组织
var namespace = body.namespace;
// 仓库
var repo_path = body.repo_path;
// sig 组
var sig_group = body.sig_group;
// pr_number
var pr_number = body.pr_number;
// pr状态
var pr_state = body.pr_state;
// pr_user
var pr_user = body.pr_user;
// commiter
var commiter = body.commiter;
// issue分类
var issue_number = body.issue_number;
// issue状态
var issue_state = body.issue_state;
// 顶部筛选（issue#1295 缺陷1：与开发者/PR 统计一致联动）：数据源(code_platform)/组织(namespace)/公私仓(private)/时间
// 内外部(internalList)不接入：fact_{c}_pr.internal 采集器默认写 ""（gitee/gitcode 无 base.repo.internal）、
// fact_{c}_issue_associate 无 internal 列；人员内外部只在 DWS 贡献层可靠，本两表未接该层。故后端忽略 internalList。
var source = body.source;
var orgList = body.orgList;
var private = body.private;
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
var prTable = "fact_" + community + "_pr";
var issueTable = "fact_" + community + "_issue";
var sigTable = "fact_" + community + "_sig_user";
var refTable = "fact_" + community + "_issue_associate";
var repoTable = "fact_" + community + "_repo";
// 公私仓联动(issue#1295)：private 过滤先对 fact_{c}_repo 起作用得到合格仓集合，
// 再用 (namespace, repo_path) 约束主表 repo_path；筛出后不再重复加 private 条件。
// 注意：<if> 块内首个 token 必须是 and，不能在 and 前放 SQL 注释——否则 private 单独成条件时
// magic-api <where> 无法剥离前导 AND，会生成非法的 "WHERE /* */ and ..." 触发 syntax error。
var sql = """
    with ref_data as (
        select
            *, regexp_replace(html_url, '/[^/]+/[^/]+$', '') AS repo_url
        from ${refTable}
        <where>
            <if test="source != null and source != ''">
                and code_platform = #{source}
            </if>
            <if test="orgList != null and orgList.size() > 0">
                and namespace in
                <foreach collection="orgList" item="item" open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
            <if test="private != null and private != ''">
                and (namespace, repo_path) in (
                    select namespace, repo_path from ${repoTable}
                    where is_hide is null and private = #{private}
                )
            </if>
        </where>
    ),
    sig_data as (
        select 
            namespace, repo_path, string_agg(DISTINCT sig_name,',') as sig_group 
        from ${sigTable}  
        GROUP BY namespace, repo_path
    ),
    pr_data as (
        select uuid, number, html_url, state, user_login, 
        CASE
            WHEN assignees_user_names = '{}' THEN NULL
            ELSE regexp_replace(assignees_user_names, '^\{|\}$', '', 'g')
        END AS commiter
        from ${prTable}  
        where is_hide is null and is_removed is null and html_url in (
            select associate_url from ref_data
        )
        <if test="start != null">
            and created_at::date >= #{start}
        </if>
        <if test="end != null">
            and created_at::date <= #{end}
        </if>
    ),
    issue_data as (
        select id, number, html_url, state 
        from ${issueTable}   
        where is_removed is null and is_hide is null and id in (
            select issue_id from ref_data
        )
    ),
    combine as (
        select 
            rd.namespace, rd.repo_path, rd.repo_url, sd.sig_group, pd.number as pr_number, pd.html_url as pr_url, pd.state as pr_state, 
            pd.user_login as pr_user, pd.commiter, id.number as issue_number, id.html_url as issue_url, id.state as issue_state 
        from ref_data rd 
        left join sig_data sd on rd.namespace = sd.namespace and rd.repo_path = sd.repo_path 
        left join pr_data pd on rd.associate_url = pd.html_url 
        left join issue_data id on rd.issue_id = id.id
        where (pd.number is not null or id.number is not null)
        <if test="start != null">
            and pd.number is not null
        </if>
        <if test="end != null">
            and pd.number is not null
        </if>
        <if test="namespace != null and namespace != ''">
            and rd.namespace LIKE CONCAT('%', #{namespace}, '%')
        </if>
        <if test="repo_path != null and repo_path != ''">
            and rd.repo_path LIKE CONCAT('%', #{repo_path}, '%')
        </if>
        <if test="sig_group != null and sig_group != ''">
            and sd.sig_group LIKE CONCAT('%', #{sig_group}, '%')
        </if>
        <if test="pr_number != null and pr_number != ''">
            and pd.number = #{pr_number}
        </if>
        <if test="pr_state != null and pr_state != ''">
            and pd.state = #{pr_state}
        </if>
        <if test="pr_user != null and pr_user != ''">
            and pd.user_login LIKE CONCAT('%', #{pr_user}, '%')
        </if>
        <if test="commiter != null and commiter != ''">
            and pd.commiter LIKE CONCAT('%', #{commiter}, '%')
        </if>
        <if test="issue_number != null and issue_number != ''">
            and id.number = #{issue_number}
        </if>
        <if test="issue_state != null and issue_state != ''">
            and id.state = #{issue_state}
        </if>
    ),
    count_ori as (
        select count(1) as total_count from combine
    )
    SELECT 
        cd.*,
        co.total_count, 
        CEIL(co.total_count::numeric/#{page_size}) as total_page
    FROM 
        combine cd, count_ori co
    <if test="order_by != null and order_by != ''">
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
result.put("list", query_data);
result.put("total_count", total_count);
result.put("total_page", total_page);
result.put("filter_field","title,creator,pr_type,state");
return result

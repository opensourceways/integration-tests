{
  "properties" : { },
  "id" : "67b5d1867c5141909d1d291084a95859",
  "script" : null,
  "groupId" : "12d952eea410421d80e54b1a53bcd3cf",
  "name" : "角色贡献",
  "createTime" : null,
  "updateTime" : 1778211638097,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/role/contribute",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "start",
    "value" : "1732032000000",
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "expression",
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "end",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Long",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "expression",
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "sig",
    "value" : "ai",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z][a-zA-Z0-9_]{0,50}$",
    "children" : null
  } ],
  "options" : [ {
    "name" : "permission",
    "value" : "datastat",
    "description" : "允许拥有该权限的访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
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
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1767614288823,\n    \"executeTime\": 12\n}",
  "description" : null,
  "requestBodyDefinition" : null,
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
          "name" : "sig_name",
          "value" : "AI",
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
          "name" : "user_login",
          "value" : "greatji",
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
          "name" : "user_name",
          "value" : "孙佶",
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
          "name" : "role",
          "value" : "committer",
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
          "name" : "company",
          "value" : "华为技术有限公司",
          "description" : "用户当前/最近所属公司（取自 dws_{community}_user_company，缺表或无记录时为空串）",
          "required" : false,
          "dataType" : "String",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "pr",
          "value" : "0",
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
          "name" : "issue",
          "value" : "0",
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
          "name" : "comment",
          "value" : "0",
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
          "name" : "add_lines",
          "value" : "0",
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
          "name" : "remove_lines",
          "value" : "0",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1751351503398",
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
  }
}
================================
// 公司映射表是否存在（部分社区未采集），缺表时 company 返回空、不 join，避免整体报错导致「贡献情况」表格空
var companyTable = "dwm_" + community + "_contribute_user_company";
var hasCompany = db.selectOne("SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = #{companyTable} LIMIT 1") != null;
var query = """
with sig_user as (
    SELECT
        user_login,
        sig_name,
        user_name,
        role,
    ROW_NUMBER() OVER (PARTITION BY (user_login, sig_name) ORDER BY CASE role WHEN 'maintainer' THEN 1 WHEN 'committer' THEN 2 ELSE 3 END) AS rn
    FROM fact_${community}_sig_user
    WHERE is_removed is null AND user_login is not null
    GROUP BY user_login, sig_name, user_name, role
)
SELECT su.sig_name, su.user_login, COALESCE(dosc.user_name, su.user_name) as name_zh, su.role,
    <if test="hasCompany">COALESCE(uc.company, '')</if>
    <if test="!hasCompany">''</if>
    as company,
    COALESCE(sum(pr_count),0) AS pr,
    COALESCE(sum(issue_count),0) as issue,
    COALESCE(sum(comment_count),0) as comment,
    COALESCE(sum(valid_comment_count),0) as valid_comment,
    COALESCE(sum(added_lines),0) as add_lines,
    COALESCE(sum(removed_lines),0) as remove_lines
FROM sig_user su
<if test="hasCompany">
LEFT JOIN (
    SELECT user_login, MAX(company) AS company
    FROM dwm_${community}_contribute_user_company
    WHERE company IS NOT NULL AND company <> ''
    GROUP BY user_login
) uc ON su.user_login = uc.user_login
</if>
LEFT JOIN dws_${community}_sig_contribute dosc
ON su.sig_name = dosc.sig_name AND su.user_login = dosc.user_login
    <if test="start != null and start != ''">
        AND dosc.created_at >= to_timestamp(#{start}/1000)
    </if>
    <if test="end != null and end != ''">
        AND dosc.created_at < to_timestamp(#{end}/1000)
    </if>
WHERE rn = 1
    <if test="sig != null and sig != ''">
        AND su.sig_name = #{sig}
    </if>
GROUP BY su.sig_name, su.user_login,COALESCE(dosc.user_name, su.user_name), su.role<if test="hasCompany">, uc.company</if>
ORDER BY su.sig_name ASC, pr DESC
"""
return db.select(query)

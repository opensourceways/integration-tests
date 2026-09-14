{
  "properties" : { },
  "id" : "397e90a5857e4083b457468171f1c0b4",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "开源技术雷达",
  "createTime" : null,
  "updateTime" : 1777378680860,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/metric",
  "method" : "GET",
  "parameters" : [ {
    "name" : "algorithm",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^(log|max-min|not)$",
    "children" : null
  }, {
    "name" : "type",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^(PostTraining|inference|AIFrameworkAndAccelerator|compiler|Archive)$",
    "children" : null
  }, {
    "name" : "file_project",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^[a-zA-Z0-9_/-]{1,100}$",
    "children" : null
  }, {
    "name" : "date_str",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^(\\d{4}-\\d{2}-\\d{2})?$",
    "children" : null
  }, {
    "name" : "month",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pass",
    "error" : null,
    "expression" : "^(\\d{4}-\\d{2})?$",
    "children" : null
  } ],
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "[\n  {\n    \"file_project\": \"openeuler/kernel\",\n    \"star\": 0.81200,\n    \"rank\": 0.65500,\n    \"downloads\": 0.74800,\n    \"ossf_score\": 0.52100,\n    \"max_total\": 2.73600,\n    \"star_diff\": 0.01500,\n    \"rank_diff\": -0.00800,\n    \"downloads_diff\": 0.04200,\n    \"ossf_score_diff\": 0.00000,\n    \"max_total_diff\": 0.04900\n  }\n]",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var algorithm_tem = algorithm
var type_tem = type;
var file_project_tem = file_project;
var date_str_tem = date_str;
var month_tem = month;
var sql = null;
if("Archive".equals(type_tem)){
sql = """
select * from (
WITH ranked_rows AS (
  SELECT 
    file_project,
    star,
    rank,
    downloads,
    ossf_score,
    COALESCE(star, 0) + 
    COALESCE(rank, 0) + 
    COALESCE(downloads, 0) + 
    COALESCE(ossf_score, 0) AS row_total,
    ROW_NUMBER() OVER (
      PARTITION BY file_project 
      ORDER BY 
        (COALESCE(star, 0) + COALESCE(rank, 0) + COALESCE(downloads, 0) + COALESCE(ossf_score, 0)) DESC
    ) AS rn
  FROM fact_repo_insight_data
  WHERE file_project IS NOT NULL  and ring ='Archive'
  <if test="month_tem != null and month_tem != ''">
            and month=#{month_tem}
        </if>
          <if test="algorithm_tem != null and algorithm_tem != ''">
            and algorithm=#{algorithm_tem}
        </if>
            and (type='PostTraining' OR type='inference' OR type='AIFrameworkAndAccelerator' or Type='compiler' )
             and normal_type!='all'
          <if test="file_project_tem != null and file_project_tem != ''">
            and file_project=#{file_project_tem}
        </if>
          <if test="date_str_tem != null and date_str_tem != ''">
            and date_str::date >=#{date_str_tem}::date
        </if>
),
prev_month AS (
  SELECT MAX(month) AS pm FROM fact_repo_insight_data
  WHERE file_project IS NOT NULL and ring ='Archive'
    and (type='PostTraining' OR type='inference' OR type='AIFrameworkAndAccelerator' or Type='compiler' )
    and normal_type!='all'
        <if test="algorithm_tem != null and algorithm_tem != ''">
            and algorithm=#{algorithm_tem}
        </if>
        <if test="month_tem != null and month_tem != ''">
            and month < #{month_tem}
        </if>
),
prev_rows AS (
  SELECT
    file_project,
    star,
    rank,
    downloads,
    ossf_score,
    COALESCE(star, 0) +
    COALESCE(rank, 0) +
    COALESCE(downloads, 0) +
    COALESCE(ossf_score, 0) AS row_total,
    ROW_NUMBER() OVER (
      PARTITION BY file_project
      ORDER BY
        (COALESCE(star, 0) + COALESCE(rank, 0) + COALESCE(downloads, 0) + COALESCE(ossf_score, 0)) DESC
    ) AS rn
  FROM fact_repo_insight_data, prev_month
  WHERE file_project IS NOT NULL and ring ='Archive'
    and month = prev_month.pm
    and (type='PostTraining' OR type='inference' OR type='AIFrameworkAndAccelerator' or Type='compiler' )
    and normal_type!='all'
        <if test="algorithm_tem != null and algorithm_tem != ''">
            and algorithm=#{algorithm_tem}
        </if>
)
SELECT
  r.file_project,
  COALESCE(r.star, 0)::numeric(20,5)  star,
    COALESCE(r.rank, 0)::numeric(20,5) rank,
    COALESCE(r.downloads, 0)::numeric(20,5) downloads,
    COALESCE(r.ossf_score, 0)::numeric(20,5) ossf_score,
  r.row_total::numeric(20,5) AS max_total,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (COALESCE(r.star,0)       - COALESCE(p.star,0))::numeric(20,5)       END AS star_diff,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (COALESCE(r.rank,0)       - COALESCE(p.rank,0))::numeric(20,5)       END AS rank_diff,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (COALESCE(r.downloads,0)  - COALESCE(p.downloads,0))::numeric(20,5)  END AS downloads_diff,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (COALESCE(r.ossf_score,0) - COALESCE(p.ossf_score,0))::numeric(20,5) END AS ossf_score_diff,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (r.row_total - COALESCE(p.row_total,0))::numeric(20,5)               END AS max_total_diff
FROM ranked_rows r LEFT JOIN prev_rows p ON r.file_project = p.file_project AND p.rn = 1
WHERE r.rn = 1
ORDER BY r.row_total desc
) a ORDER BY max_total asc
"""
}else{
 sql = """
select * from (
WITH ranked_rows AS (
  SELECT 
    file_project,
    star,
    rank,
    downloads,
    ossf_score,
    COALESCE(star, 0) + 
    COALESCE(rank, 0) + 
    COALESCE(downloads, 0) + 
    COALESCE(ossf_score, 0) AS row_total,
    ROW_NUMBER() OVER (
      PARTITION BY file_project 
      ORDER BY 
        (COALESCE(star, 0) + COALESCE(rank, 0) + COALESCE(downloads, 0) + COALESCE(ossf_score, 0)) DESC
    ) AS rn
  FROM fact_repo_insight_data
  WHERE file_project IS NOT NULL  and ring !='Archive'
  <if test="month_tem != null and month_tem != ''">
            and month=#{month_tem}
        </if>
          <if test="algorithm_tem != null and algorithm_tem != ''">
            and algorithm=#{algorithm_tem}
        </if>
          <if test="type_tem != null and type_tem != ''">
            and type=#{type_tem}
             and normal_type=#{type_tem}
        </if>
          <if test="file_project_tem != null and file_project_tem != ''">
            and file_project=#{file_project_tem}
        </if>
          <if test="date_str_tem != null and date_str_tem != ''">
            and date_str::date >=#{date_str_tem}::date
        </if>
),
prev_month AS (
  SELECT MAX(month) AS pm FROM fact_repo_insight_data
  WHERE file_project IS NOT NULL and ring !='Archive'
        <if test="algorithm_tem != null and algorithm_tem != ''">
            and algorithm=#{algorithm_tem}
        </if>
        <if test="type_tem != null and type_tem != ''">
            and type=#{type_tem}
             and normal_type=#{type_tem}
        </if>
        <if test="month_tem != null and month_tem != ''">
            and month < #{month_tem}
        </if>
),
prev_rows AS (
  SELECT
    file_project,
    star,
    rank,
    downloads,
    ossf_score,
    COALESCE(star, 0) +
    COALESCE(rank, 0) +
    COALESCE(downloads, 0) +
    COALESCE(ossf_score, 0) AS row_total,
    ROW_NUMBER() OVER (
      PARTITION BY file_project
      ORDER BY
        (COALESCE(star, 0) + COALESCE(rank, 0) + COALESCE(downloads, 0) + COALESCE(ossf_score, 0)) DESC
    ) AS rn
  FROM fact_repo_insight_data, prev_month
  WHERE file_project IS NOT NULL and ring !='Archive'
    and month = prev_month.pm
        <if test="algorithm_tem != null and algorithm_tem != ''">
            and algorithm=#{algorithm_tem}
        </if>
        <if test="type_tem != null and type_tem != ''">
            and type=#{type_tem}
             and normal_type=#{type_tem}
        </if>
)
SELECT
  r.file_project,
  COALESCE(r.star, 0)::numeric(20,5)  star,
    COALESCE(r.rank, 0)::numeric(20,5) rank,
    COALESCE(r.downloads, 0)::numeric(20,5) downloads,
    COALESCE(r.ossf_score, 0)::numeric(20,5) ossf_score,
  r.row_total::numeric(20,5) AS max_total,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (COALESCE(r.star,0)       - COALESCE(p.star,0))::numeric(20,5)       END AS star_diff,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (COALESCE(r.rank,0)       - COALESCE(p.rank,0))::numeric(20,5)       END AS rank_diff,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (COALESCE(r.downloads,0)  - COALESCE(p.downloads,0))::numeric(20,5)  END AS downloads_diff,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (COALESCE(r.ossf_score,0) - COALESCE(p.ossf_score,0))::numeric(20,5) END AS ossf_score_diff,
  CASE WHEN p.file_project IS NULL THEN NULL ELSE (r.row_total - COALESCE(p.row_total,0))::numeric(20,5)               END AS max_total_diff
FROM ranked_rows r LEFT JOIN prev_rows p ON r.file_project = p.file_project AND p.rn = 1
WHERE r.rn = 1
ORDER BY r.row_total  desc
) a ORDER BY max_total asc
"""
}
var dd = db.select(sql)
return  dd;

{
  "properties" : { },
  "id" : "copy1770966599220d71055",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "workflow",
  "createTime" : null,
  "updateTime" : 1778490935973,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/workflow/detail",
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
  "requestBody" : "{\r\n    \"start\":1577808000000,\r\n    \"end\":1898526240605,\r\n    \"asc\":\"avg_wait_time\",\r\n    \"desc\":\"\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1778489604049,\n    \"executeTime\": 11\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
var start_time =date_format(start,'yyyy-MM-dd');
var end_time =date_format(end,'yyyy-MM-dd');
var order_by_set = new HashSet()
var order_asc = "";
if (body.asc != null and body.asc != "") {
    var asc_arr = body.asc.split(",");
    for(index,item in asc_arr){
        order_by_set.add(item + " asc");
    }
}
var order_desc = "";
if (body.desc != null and body.desc != "") {
    var desc_arr = body.desc.split(",");
    for(index,item in desc_arr){
        order_by_set.add(item + " desc");
    }
}
var order_by = "";
if (order_by_set.size() > 0){
    order_by = order_by_set.join(",");
}
var sql = """ 


SELECT 
        concat(org,'/',repo) as repo,
       
        COUNT(DISTINCT workflow_id) AS workflow_count,
        
        -- 1. Wait Time (无过滤)
        ROUND(AVG(total_wait_time)::NUMERIC/60, 2) AS avg_wait_time,  
        ROUND(MAX(total_wait_time)::NUMERIC/60, 2) AS max_wait_time,  
        ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_wait_time)::NUMERIC/60, 2) AS midle_wait_time,
        ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_wait_time)::NUMERIC/60, 2) AS p90_wait_time,

        -- 2. Run Time (原代码逻辑似乎有误，这里保留了 total_run_time 的统计)
        ROUND(AVG(total_run_time)::NUMERIC/60, 2) AS avg_run_time, 
        ROUND(MAX(total_run_time)::NUMERIC/60, 2) AS max_run_time,  
        ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_run_time)::NUMERIC/60, 2) AS midle_run_time,
        ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_run_time)::NUMERIC/60, 2) AS p90_run_time,

        -- 3. E2E Time (根据 device_type='NPU' 过滤) -> 修正了 FILTER 位置
        ROUND(AVG(e2e_time) FILTER (WHERE device_type='NPU')::NUMERIC/60, 2) AS avg_e2e_time,
        ROUND(MAX(e2e_time) FILTER (WHERE device_type='NPU')::NUMERIC/60, 2) AS max_e2e_time,  
        ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY e2e_time) FILTER (WHERE device_type='NPU')::NUMERIC/60, 2) AS midle_e2e_time,
        ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY e2e_time) FILTER (WHERE device_type='NPU')::NUMERIC/60, 2) AS p90_e2e_time,

        -- 4. Download Time (根据 device_type='NPU' 过滤) -> 修正了 FILTER 位置
        ROUND(AVG(total_download_time)::NUMERIC/60, 2) AS avg_download_time,
        ROUND(MAX(total_download_time)  ::NUMERIC/60, 2) AS max_download_time,  
        ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_download_time) FILTER (WHERE total_download_time>0)  ::NUMERIC/60, 2) AS midle_download_time,
        ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_download_time) FILTER (WHERE total_download_time>0) ::NUMERIC/60, 2) AS p90_download_time,

        ROUND(AVG(total_prepare_time) ::NUMERIC/60, 2) AS avg_prepare_time,
        ROUND(MAX(total_prepare_time) ::NUMERIC/60, 2) AS max_prepare_time,  
        ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_prepare_time) FILTER (WHERE total_prepare_time>0) ::NUMERIC/60, 2) AS midle_prepare_time,
        ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_prepare_time) FILTER (WHERE total_prepare_time>0)::NUMERIC/60, 2) AS p90_prepare_time

    FROM dws_opensource_ci  
     where
            created_at>=#{start_time}::timestamp and created_at <=#{end_time}::timestamp
                              GROUP BY repo, org
            <if test="order_by != null and order_by != ''">
                ORDER BY ${order_by}
            </if>
   
                                        
 """
var res = db.select(sql)
// return res;
HashMap all_ll_result = new HashMap();
all_ll_result.put("list", res);
all_ll_result.put("total_count", res.size());
all_ll_result.put("total_page", 1);
return all_ll_result;

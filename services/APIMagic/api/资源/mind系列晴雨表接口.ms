{
  "properties" : { },
  "id" : "copy1780388694636d87518",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "mind系列晴雨表接口",
  "createTime" : null,
  "updateTime" : 1780555875359,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/ci/mind-metrics",
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
  "requestBody" : "{\r\n        \"start\":1577808000000,\r\n    \"end\":1898526240605\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import http;
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
var start_time =date_format(start,'yyyy-MM-dd') +" 00:00:00";
var end_time =date_format(end,'yyyy-MM-dd')+" 23:59:59";

var configsql = "select * from fact_openlibing_api_header limit 1"
var config = db.select(configsql).get(0)
var map  = new HashMap()
var project = ["mindie","mindsdk","mindspeed","mindstudio","mindcluster","mindedge","pta","cann"]

var res_map = {
      "ttfhw": {
        "mindie": null, "mindspeed": null, "mindstudio": null,
        "mindsdk": null, "mindcluster": null, "mindedge": null, "pta": null, "cann": null
      },
      "ci_e2e_time": {
        
      },
      "ci_queue_time": {
      
      },
      "ci_prepare_time": {
      
      },
      "ci_execute_time": {
       
      }
    }



for(pro in project ){
    var reposql = """ SELECT ARRAY_AGG(html_url || '.git') AS repo_urls FROM fact_${pro}_repo;"""
    raw = db.select(reposql).get(0).get("repo_urls")
    arr_raw= raw!=null?raw.getArray():[]
    // 外部 CI 指标 API 在预览/异常时可能 403/超时；try 包住，失败不阻断整个接口，TTFHW 仍能返回
    var records = [];
    try {
        records = http.connect(config.get("endpoint"))
        .header({
            // 上游已切换为华为云 APIG 单一 X-Apig-AppCode 认证头
            "X-Apig-AppCode": config.get("x_apig_app_code")
        }).body({
                "startTime": start_time,
                "endTime": end_time,
                "repoUrlList": arr_raw
    }).post().getBody().data.records;
    } catch(e) {
        records = [];
    }
    if (records == null) {
        records = []
    }
    records = records.filter(e=>e.dtAvgDurationP50!=null && e.accessAvgTime!=null );
    records = records.sort((a,b)=>b.accessAvgTime-a.accessAvgTime);
    if(records.size()>0){
      res = records.get(0);
      res_map.get("ci_e2e_time").put(pro,res.get("accessAvgTime")==null?"/":res.get("accessAvgTime")/60.0)
      res_map.get("ci_queue_time").put(pro,res.get("buildAvgPendingDuration")==null?"/":(res.get("buildAvgPendingDuration")+res.getOrDefault("dtAvgPendingDuration",0))/60.0)
      res_map.get("ci_execute_time").put(pro,res.get("dtAvgDuration")==null?"/":res.get("dtAvgDuration")/60.0)
      res_map.get("ci_prepare_time").put(pro,res.get("buildAvgPendingTime")==null?"/":res.get("buildAvgPendingTime")/60.0)

    }else{
      res_map.get("ci_e2e_time").put(pro,"/")
      res_map.get("ci_queue_time").put(pro,"/")
      res_map.get("ci_execute_time").put(pro,"/")
      res_map.get("ci_prepare_time").put(pro,"/")
    }

}

var ttfhw_rows = db.select("SELECT t.project AS project, t.display AS display FROM (SELECT DISTINCT ON (project) project, display FROM dws_ci_ttfhw WHERE series = 'mind' ORDER BY project, report_month DESC) t")
for (row in ttfhw_rows) {
    res_map.get("ttfhw").put(row.project, row.display)
}

return res_map

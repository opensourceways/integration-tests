{
  "properties" : { },
  "id" : "a6579652f75d4157adfbfb3ca27dfa84",
  "script" : null,
  "groupId" : "13b9cf50bae14a1aa749b601de01170f",
  "name" : "社区热点",
  "createTime" : null,
  "updateTime" : 1774874584964,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/hotspot",
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
  "requestBody" : "{\r\n    \"start\":1772282366783,\r\n    \"end\":1774874366783,\r\n    \"community\":\"vllm\",\r\n    \"topn\": 10\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"heat\": 1.0,\n        \"updated_at\": \"2026-03-18 00:00:00\",\n        \"id\": \"uuid\",\n        \"title\": \"Qwen系列模型在vllm-ascend上多场景下出现NPU显存溢出\",\n        \"list\": [{\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7419\",\n            \"created_at\": \"2026-03-18 16:01:25\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3VL 8B LoRA（with ViT）Error\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/5139\",\n            \"created_at\": \"2025-12-17 20:46:50\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: OOM problem occurs when deploy Qwen3-8B on v0.11.0rc3 \",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/3368\",\n            \"created_at\": \"2025-10-10 16:52:46\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3-next: Out of Memory due to repeated allocation of shared hybrid cache\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/6478\",\n            \"created_at\": \"2026-02-02 11:24:37\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3-next-80B with FULL_DECODE_ONLY compilation mode shows gradual memory growth and OOM after long-running inference\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/3463\",\n            \"created_at\": \"2025-10-15 10:23:03\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3-32B TP4 使能VLLM_ASCEND_ENABLE_MLP_OPTIMIZE会导致OOM\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/3627\",\n            \"created_at\": \"2025-10-22 17:03:03\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3-Next on A3 tp8 reports out of memory, tp4 works normal.\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/3843\",\n            \"created_at\": \"2025-10-28 23:38:04\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: qwen3-next-80B-instruct无法启动在ascend910b4\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/4379\",\n            \"created_at\": \"2025-11-24 12:42:47\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: The Qwen3 - Next - 80B - A3B - Instruct model is deployed on 8 cards of the 910B with 64G memory, and out - of - memory (OOM) occurs.\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/3813\",\n            \"created_at\": \"2025-10-28 11:21:05\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3-Next-80B-A3B-Instruct模型8卡部署gpu-memory-utilization 0.7服务无法拉起\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/3308\",\n            \"created_at\": \"2025-10-02 14:33:18\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: 0.11.0rc0 OOM! Failed run Qwen/Qwen3-Next-80B-A3B-Instruct with RuntimeError: Worker with error 'NPU out of memory.\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/6572\",\n            \"created_at\": \"2026-02-05 19:50:57\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: A2 0.14.0rc1部署Qwen3-Coder-Next，其它参数相同，TP4能拉但TP8报OOM\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/4474\",\n            \"created_at\": \"2025-11-26 21:07:22\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: vllm-ascend:v0.11.0rc2  qwen3-next-80B OOM\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/6929\",\n            \"created_at\": \"2026-03-02 20:14:29\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3-VL-235B模型，压测时模型内存占用一直提升，压测完毕后，重新压测依旧会继续上涨\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/6647\",\n            \"created_at\": \"2026-02-10 09:27:45\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: A2单节点，VeRL使用vllm-ascend进行LoRA rollout时OOM\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7123\",\n            \"created_at\": \"2026-03-10 17:26:19\",\n            \"label\": null,\n            \"state\": \"closed\",\n            \"title\": \"[Bug]: kimi2.5部署，A2多机，报错NPU out of memory\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/5020\",\n            \"created_at\": \"2025-12-15 15:03:00\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Encounter an out of memory error with the tutorial of V0.12.0RC1 for Qwen3-Next\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/6611\",\n            \"created_at\": \"2026-02-07 18:24:41\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: 0.13.0 qwen3-next-80b oom\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }],\n        \"status\": \"new\"\n    }, {\n        \"heat\": 2.0,\n        \"updated_at\": \"2026-03-20 00:00:00\",\n        \"id\": \"uuid\",\n        \"title\": \"Qwen3.5双机A2部署加载权重卡死致超时\",\n        \"list\": [{\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7060\",\n            \"created_at\": \"2026-03-07 17:36:52\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Doc]: A2双机十六卡混部 Qwen3.5 可能存在服务启动超时\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7078\",\n            \"created_at\": \"2026-03-09 16:48:43\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3.5双机A2部署时加载一半权重后卡死造成超时\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }],\n        \"status\": \"appended\"\n    }, {\n        \"heat\": 3.0,\n        \"updated_at\": \"2026-03-13 00:00:00\",\n        \"id\": \"uuid\",\n        \"title\": \"Qwen3.5-0Day版本在vLLM-Ascend中流式输出缺失reasoning_content且思考模式关闭时触发精度异常\",\n        \"list\": [{\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7061\",\n            \"created_at\": \"2026-03-07 18:02:28\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: qwen3.5 0day版本 的think标签无法正常被解析\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7220\",\n            \"created_at\": \"2026-03-13 11:26:51\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3.5 0Day版本流式输出中没有reasoning_content字段，无法区分思考内容。\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7094\",\n            \"created_at\": \"2026-03-10 09:18:08\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: qwen3.5 0day版本 请求中关闭思考模式存在精度异常\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }],\n        \"status\": \"new\"\n    }, {\n        \"heat\": 4.0,\n        \"updated_at\": \"2026-03-17 00:00:00\",\n        \"id\": \"uuid\",\n        \"title\": \"Qwen3.5-27B在A2/A3单机8卡调用aclnnCausalConv1d算子失败\",\n        \"list\": [{\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7310\",\n            \"created_at\": \"2026-03-16 17:03:41\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: Qwen3.5-27B，A2单机8卡v0.17.0rc1镜像部署失败\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7360\",\n            \"created_at\": \"2026-03-17 11:34:06\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: qwen3.5-27B A2单机8卡 使用v0.17.0rc1出现错误\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }],\n        \"status\": \"new\"\n    }, {\n        \"heat\": 5.0,\n        \"updated_at\": \"2026-02-28 00:00:00\",\n        \"id\": \"uuid\",\n        \"title\": \"Qwen3.5部署后推理速度慢且输出思考过程为英文\",\n        \"list\": [{\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/6848\",\n            \"created_at\": \"2026-02-27 15:35:07\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: qwen3.5 A2 双机回答的思考模式为英文\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/6879\",\n            \"created_at\": \"2026-02-28 17:42:21\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: qwen3.5单机部署，回复很慢，思考很啰嗦\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }],\n        \"status\": \"new\"\n    }, {\n        \"heat\": 6.0,\n        \"updated_at\": \"2026-03-27 00:00:00\",\n        \"id\": \"uuid\",\n        \"title\": \"Mooncake KV传输失败及MTE DDR地址越界导致PD分离部署不稳定\",\n        \"list\": [{\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/5635\",\n            \"created_at\": \"2026-01-06 15:03:44\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: PD分离 mooncake tansfer bug\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/4103\",\n            \"created_at\": \"2025-11-10 20:42:58\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: PD seperate (MoonCake) doesn't take effect because of IPV6 host ip\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/5660\",\n            \"created_at\": \"2026-01-06 20:06:43\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"Failed to transfer KV cache for request chatcmpl-7817d6df-206c-4aca-bfac-c43df205506f: Mooncake transfer failed, ret: -1\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/4269\",\n            \"created_at\": \"2025-11-19 14:09:29\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: GLM4.6 PD分离 使用mooncake池化 八机部署无法稳定启动\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/4244\",\n            \"created_at\": \"2025-11-18 14:16:37\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: PD分离分布式DP场景MooncakeConnector没有考虑PP并行，kv传输端口分配会冲突\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7352\",\n            \"created_at\": \"2026-03-17 10:00:08\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: PD-disaggregation-mooncake on Deepseek-R1-Distill-Qwen-1.5B failed\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }, {\n            \"html_url\": \"https://github.com/vllm-project/vllm-ascend/issues/7401\",\n            \"created_at\": \"2026-03-18 10:38:40\",\n            \"label\": null,\n            \"state\": \"open\",\n            \"title\": \"[Bug]: mooncake related error when running GLM5 W4A8 with PD disaggregation\",\n            \"type\": \"issue\",\n            \"status\": \"new\"\n        }],\n        \"status\": \"appended\"\n    }],\n    \"timestamp\": 1774874514047,\n    \"executeTime\": 3525\n}",
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
      "value" : "1772282366783",
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
      "name" : "end",
      "value" : "1774874366783",
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
      "name" : "community",
      "value" : "vllm",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : "",
      "expression" : "^[a-z-A-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "topn",
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
  },
  "responseBodyDefinition" : null
}
================================
import '@/util/timestamp2Date' as timestamp2Date;
Date start = timestamp2Date(body.start);
Date end = timestamp2Date(body.end);
// 社区
var community = body.community.toLowerCase();
// topn
var topn = 10;
if (body.topn != null and body.topn != ""){
    topn = body.topn;
}
var issue_table = "fact_"+community+"_issue"
var forum_table = "fact_"+community+"_forum_topic"
hotspot_value = community
if ("vllm-ascend" == community){
    community = "vllm"
}
if ("vllm" == community){
  hotspot_value = 'vllm-ascend'
}
if ("cann" == community || "canopen" == community){
  forum_table = "fact_cann_forum_contribute"
}
var internal_sql = """
  with hotspot_data AS (
    SELECT uuid,title,heat,status,created_at as updated_at from community_hotspot
    where community = #{hotspot_value} and visible = 'true'
    order by heat
    limit #{topn} offset 0
  ),
  event_data AS (
    SELECT 
      ch.uuid, ch.title as hostspot_title, ch.status as hotspot_status, ch.heat, ch.updated_at, ce.created_at, ce.title, ce.status, ce.type, ce.label, ce.html_url, 'open' AS state
    FROM community_event ce
    INNER join hotspot_data ch on ch.uuid = ce.hotspot_id
  )
  SELECT * from event_data
""";
var db_data = db.select(internal_sql);
var issue_table_check_sql = """
  SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = #{issue_table}
  ) as issue_table_exists
"""
var check_issue_result_data = db.select(issue_table_check_sql);
var check_issue_result = check_issue_result_data[0]["issue_table_exists"]
var issue_state_map = new HashMap()
if (check_issue_result){
  var issue_url_arr = new ArrayList();
  db_data.forEach(item -> {
    if ("issue" == item.get("type")) {
      issue_url_arr.add(item.get("html_url"))
    }
  })
  if (issue_url_arr.size() > 0){
    var issue_sql = """
      select html_url, state as status
      from ${issue_table} where html_url in 
      <foreach collection="issue_url_arr" item="item" open="(" separator="," close=")">
          #{item}
      </foreach>
    """;
    issue_state_data = db.select(issue_sql);
    if (issue_state_data.size > 1) {
      issue_state_data.forEach(item -> {
        issue_state_map.put(item.get("html_url"), item.get("status"))
      })
    }
  }
}
var forum_table_check_sql = """
  SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = #{forum_table}
  ) as forum_table_exists
"""
var check_forum_result_data = db.select(forum_table_check_sql);
var check_forum_result = check_forum_result_data[0]["forum_table_exists"]
var forum_state_map = new HashMap()
if (check_forum_result){
  var forum_url_arr = new ArrayList();
  db_data.forEach(item -> {
    if ("forum" == item.get("type")) {
      forum_url_arr.add(item.get("html_url"))
    }
  })
  if (forum_url_arr.size() > 0){
    var forum_sql = """
      select url, status
      from ${forum_table} where url in 
      <foreach collection="forum_url_arr" item="item" open="(" separator="," close=")">
          #{item}, #{item} || '/1'
      </foreach>
    """;
    forum_state_data = db.select(forum_sql);
    if (forum_state_data.size > 1) {
      forum_state_data.forEach(item -> {
        forum_state_map.put(item.get("url"), item.get("status"));
        forum_state_map.put((item.get("url")+"/1"), item.get("status"));
      })
    }
  }
}
HashMap hotspot = new HashMap();
if (db_data.size > 1){
    db_data.forEach(item -> {
        HashMap event = new HashMap();
        var type = item.get("type");
        var html_url = item.get("html_url");
        event.put("title", item.get("title"));
        event.put("type", type);
        event.put("status", item.get("status"));
        event.put("label", item.get("label"));
        event.put("html_url", html_url);
        event.put("created_at", item.get("created_at"));
        var state = item.get("state");
        if ("issue" == type){
            state = issue_state_map.get(html_url);
        } else if ("forum" == type){
          state = forum_state_map.get(html_url);
        }
        event.put("state", state);
       var key = item.get("uuid");
       if(hotspot.containsKey(key)){
            HashMap hotspotObj = hotspot.get(key);
            ArrayList eventList = hotspotObj.get("list");
            eventList.add(event);
            hotspotObj.put("list",eventList);
            hotspot.put(key, hotspotObj)
       } else {
            HashMap hotspotObj = new HashMap();
            hotspotObj.put("id","uuid");
            hotspotObj.put("title",item.get("hostspot_title"));
            hotspotObj.put("heat",item.get("heat"));
            hotspotObj.put("updated_at",item.get("updated_at"));
            hotspotObj.put("status",item.get("hotspot_status"));
            ArrayList eventList = new ArrayList();
            eventList.add(event);
            hotspotObj.put("list",eventList);
            hotspot.put(key, hotspotObj)
       }
       return item;
    })
}
return hotspot.values().sort((obj1,obj2) => obj1.heat - obj2.heat);

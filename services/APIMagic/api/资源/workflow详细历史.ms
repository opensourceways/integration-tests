{
  "properties" : { },
  "id" : "copy1776677172644d91714",
  "script" : null,
  "groupId" : "ffa7b23c36ed410d90d86d84e814a3ad",
  "name" : "workflow详细历史",
  "createTime" : null,
  "updateTime" : 1778307934235,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/workflow/history",
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
  "requestBody" : "{\r\n    \"wait_time\":30,\r\n    \"run_time\":30,\r\n    \"owner\": \"sgl-project\",\r\n    \"repo\": \"sglang\",\r\n    \"created_at\":\"2026-05-01\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"workflow_id\": \"25257553436\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74059411403\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-424pp-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2232,\n        \"wait_time\": 4582,\n        \"created_at\": \"2026-05-03 01:25:43\",\n        \"started_at\": \"2026-05-03 02:42:05\",\n        \"completed_at\": \"2026-05-03 03:19:17\"\n    }, {\n        \"workflow_id\": \"25245246307\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74028323201\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-v9j5x-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2282,\n        \"wait_time\": 3607,\n        \"created_at\": \"2026-05-02 13:56:04\",\n        \"started_at\": \"2026-05-02 14:56:11\",\n        \"completed_at\": \"2026-05-02 15:34:13\"\n    }, {\n        \"workflow_id\": \"25377851670\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74417769525\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-kgdk9-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2240,\n        \"wait_time\": 12749,\n        \"created_at\": \"2026-05-05 21:00:18\",\n        \"started_at\": \"2026-05-06 00:32:47\",\n        \"completed_at\": \"2026-05-06 01:10:07\"\n    }, {\n        \"workflow_id\": \"25284492142\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74126732015\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-jcj9r-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1838,\n        \"wait_time\": 1969,\n        \"created_at\": \"2026-05-04 00:26:27\",\n        \"started_at\": \"2026-05-04 00:59:16\",\n        \"completed_at\": \"2026-05-04 01:29:54\"\n    }, {\n        \"workflow_id\": \"25283171951\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74123496023\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-5kgc9-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1892,\n        \"wait_time\": 3342,\n        \"created_at\": \"2026-05-03 23:28:45\",\n        \"started_at\": \"2026-05-04 00:24:27\",\n        \"completed_at\": \"2026-05-04 00:55:59\"\n    }, {\n        \"workflow_id\": \"25282212913\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74121143175\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-66l5r-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2262,\n        \"wait_time\": 2555,\n        \"created_at\": \"2026-05-03 22:46:33\",\n        \"started_at\": \"2026-05-03 23:29:08\",\n        \"completed_at\": \"2026-05-04 00:06:50\"\n    }, {\n        \"workflow_id\": \"25274750838\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74102794298\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-sdj4l-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2416,\n        \"wait_time\": 2763,\n        \"created_at\": \"2026-05-03 16:52:46\",\n        \"started_at\": \"2026-05-03 17:38:49\",\n        \"completed_at\": \"2026-05-03 18:19:05\"\n    }, {\n        \"workflow_id\": \"25273065700\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74105098233\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-szbjr-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2233,\n        \"wait_time\": 3465,\n        \"created_at\": \"2026-05-03 17:38:19\",\n        \"started_at\": \"2026-05-03 18:36:04\",\n        \"completed_at\": \"2026-05-03 19:13:17\"\n    }, {\n        \"workflow_id\": \"25448154401\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74657989199\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-hvzmg-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1863,\n        \"wait_time\": 2551,\n        \"created_at\": \"2026-05-07 00:35:52\",\n        \"started_at\": \"2026-05-07 01:18:23\",\n        \"completed_at\": \"2026-05-07 01:49:26\"\n    }, {\n        \"workflow_id\": \"25524519960\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74916846640\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-c7rlc-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1865,\n        \"wait_time\": 2882,\n        \"created_at\": \"2026-05-08 06:02:37\",\n        \"started_at\": \"2026-05-08 06:50:39\",\n        \"completed_at\": \"2026-05-08 07:21:44\"\n    }, {\n        \"workflow_id\": \"25524519960\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74916846644\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-lqqpr-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2270,\n        \"wait_time\": 2889,\n        \"created_at\": \"2026-05-08 06:02:37\",\n        \"started_at\": \"2026-05-08 06:50:46\",\n        \"completed_at\": \"2026-05-08 07:28:36\"\n    }, {\n        \"workflow_id\": \"25522596415\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75059792208\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-68sbh-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1943,\n        \"wait_time\": 2633,\n        \"created_at\": \"2026-05-09 01:13:40\",\n        \"started_at\": \"2026-05-09 01:57:33\",\n        \"completed_at\": \"2026-05-09 02:29:56\"\n    }, {\n        \"workflow_id\": \"25223497710\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"73961300280\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-zmpxj-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2265,\n        \"wait_time\": 2103,\n        \"created_at\": \"2026-05-02 00:51:10\",\n        \"started_at\": \"2026-05-02 01:26:13\",\n        \"completed_at\": \"2026-05-02 02:03:58\"\n    }, {\n        \"workflow_id\": \"25220051162\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"73949797219\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-8qxnl-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1878,\n        \"wait_time\": 2305,\n        \"created_at\": \"2026-05-01 23:21:05\",\n        \"started_at\": \"2026-05-01 23:59:30\",\n        \"completed_at\": \"2026-05-02 00:30:48\"\n    }, {\n        \"workflow_id\": \"25214624984\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"73932249164\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-lrjtm-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2287,\n        \"wait_time\": 3492,\n        \"created_at\": \"2026-05-01 20:41:46\",\n        \"started_at\": \"2026-05-01 21:39:58\",\n        \"completed_at\": \"2026-05-01 22:18:05\"\n    }, {\n        \"workflow_id\": \"25260862501\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74067815014\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-b48mv-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2239,\n        \"wait_time\": 2006,\n        \"created_at\": \"2026-05-03 04:14:47\",\n        \"started_at\": \"2026-05-03 04:48:13\",\n        \"completed_at\": \"2026-05-03 05:25:32\"\n    }, {\n        \"workflow_id\": \"25252718596\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74047190762\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-wq9gw-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2227,\n        \"wait_time\": 4191,\n        \"created_at\": \"2026-05-02 21:13:59\",\n        \"started_at\": \"2026-05-02 22:23:50\",\n        \"completed_at\": \"2026-05-02 23:00:57\"\n    }, {\n        \"workflow_id\": \"25582364550\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75103970850\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-mg9w6-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1884,\n        \"wait_time\": 2356,\n        \"created_at\": \"2026-05-09 06:21:29\",\n        \"started_at\": \"2026-05-09 07:00:45\",\n        \"completed_at\": \"2026-05-09 07:32:09\"\n    }, {\n        \"workflow_id\": \"25582364550\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75103970859\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-58l76-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2249,\n        \"wait_time\": 2360,\n        \"created_at\": \"2026-05-09 06:21:29\",\n        \"started_at\": \"2026-05-09 07:00:49\",\n        \"completed_at\": \"2026-05-09 07:38:18\"\n    }, {\n        \"workflow_id\": \"25567224697\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75054081831\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-xnlhm-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2584,\n        \"wait_time\": 2240,\n        \"created_at\": \"2026-05-09 00:36:42\",\n        \"started_at\": \"2026-05-09 01:14:02\",\n        \"completed_at\": \"2026-05-09 01:57:06\"\n    }, {\n        \"workflow_id\": \"25567224697\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75054081876\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-tdxqx-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1881,\n        \"wait_time\": 2249,\n        \"created_at\": \"2026-05-09 00:36:42\",\n        \"started_at\": \"2026-05-09 01:14:11\",\n        \"completed_at\": \"2026-05-09 01:45:32\"\n    }, {\n        \"workflow_id\": \"25565498755\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75047815551\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-bblv4-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1871,\n        \"wait_time\": 2402,\n        \"created_at\": \"2026-05-08 23:57:06\",\n        \"started_at\": \"2026-05-09 00:37:08\",\n        \"completed_at\": \"2026-05-09 01:08:19\"\n    }, {\n        \"workflow_id\": \"25561090981\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75032657095\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-fbvdd-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2180,\n        \"wait_time\": 3936,\n        \"created_at\": \"2026-05-08 22:27:42\",\n        \"started_at\": \"2026-05-08 23:33:18\",\n        \"completed_at\": \"2026-05-09 00:09:38\"\n    }, {\n        \"workflow_id\": \"25561090981\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75032657115\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-h4g8j-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2577,\n        \"wait_time\": 3942,\n        \"created_at\": \"2026-05-08 22:27:42\",\n        \"started_at\": \"2026-05-08 23:33:24\",\n        \"completed_at\": \"2026-05-09 00:16:21\"\n    }, {\n        \"workflow_id\": \"25555929411\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75014887192\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-xbw97-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1858,\n        \"wait_time\": 1916,\n        \"created_at\": \"2026-05-08 20:37:42\",\n        \"started_at\": \"2026-05-08 21:09:38\",\n        \"completed_at\": \"2026-05-08 21:40:36\"\n    }, {\n        \"workflow_id\": \"25555929411\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75014887198\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-hzjtj-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2244,\n        \"wait_time\": 1919,\n        \"created_at\": \"2026-05-08 20:37:42\",\n        \"started_at\": \"2026-05-08 21:09:41\",\n        \"completed_at\": \"2026-05-08 21:47:05\"\n    }, {\n        \"workflow_id\": \"25553140071\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"75005673973\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-cwqh9-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2226,\n        \"wait_time\": 2320,\n        \"created_at\": \"2026-05-08 19:30:20\",\n        \"started_at\": \"2026-05-08 20:09:00\",\n        \"completed_at\": \"2026-05-08 20:46:06\"\n    }, {\n        \"workflow_id\": \"25345945660\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74314869162\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-xrp8p-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1906,\n        \"wait_time\": 3312,\n        \"created_at\": \"2026-05-05 06:03:16\",\n        \"started_at\": \"2026-05-05 06:58:28\",\n        \"completed_at\": \"2026-05-05 07:30:14\"\n    }, {\n        \"workflow_id\": \"25335805656\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74280873863\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-9tdkv-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 1888,\n        \"wait_time\": 3932,\n        \"created_at\": \"2026-05-05 02:24:21\",\n        \"started_at\": \"2026-05-05 03:29:53\",\n        \"completed_at\": \"2026-05-05 04:01:21\"\n    }, {\n        \"workflow_id\": \"25332973221\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74469539436\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (1)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-4mbxq-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2009,\n        \"wait_time\": 2284,\n        \"created_at\": \"2026-05-06 01:37:31\",\n        \"started_at\": \"2026-05-06 02:15:35\",\n        \"completed_at\": \"2026-05-06 02:49:04\"\n    }, {\n        \"workflow_id\": \"25466176307\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74719959033\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-mbfgw-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2162,\n        \"wait_time\": 1873,\n        \"created_at\": \"2026-05-07 07:09:11\",\n        \"started_at\": \"2026-05-07 07:40:24\",\n        \"completed_at\": \"2026-05-07 08:16:26\"\n    }, {\n        \"workflow_id\": \"25463709844\",\n        \"workflow_name\": \"PR Test (NPU)\",\n        \"job_id\": \"74712111727\",\n        \"job_name\": \"stage-b-test-1-npu-a2 (0)\",\n        \"runner_name\": \"linux-aarch64-a2-1-hl5lq-runner-bpldh-workflow\",\n        \"org\": \"sgl-project\",\n        \"repo\": \"sglang\",\n        \"run_time\": 2267,\n        \"wait_time\": 2385,\n        \"created_at\": \"2026-05-07 06:05:40\",\n        \"started_at\": \"2026-05-07 06:45:25\",\n        \"completed_at\": \"2026-05-07 07:23:12\"\n    }],\n    \"timestamp\": 1778307900601,\n    \"executeTime\": 98\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================


var run_time = body.run_time
var wait_time = body.wait_time
var created_at = body.created_at
var repo = body.repo
var org = body.owner

var page_size = body.page_size||2000
var page = body.page||1
var index = (page-1)*page_size


var sql = """

SELECT  workflow_id,workflow_name,job_id,job_name,runner_name,org,repo, job_run_time as run_time ,job_wait_time as wait_time,job_created_at,job_started_at,job_completed_at from fact_ci_workflow_step
where device_type='NPU'
<if test="run_time != null and run_time != ''">
            and  job_run_time>=#{run_time}*60
</if>
<if test="wait_time != null and wait_time != ''">
            and   job_wait_time>=#{wait_time}*60
</if>
<if test="repo != null and repo != ''">
            and   repo=#{repo}
</if>

<if test="org != null and org != ''">
            and   org=#{org}
</if>
<if test="created_at != null and created_at != ''">
            and   workflow_created_at>=#{created_at}::date
</if>
 offset #{index}   limit #{page_size}
 """
var res = db.select(sql)


var page_sql = """


SELECT  count(*) as total from fact_ci_workflow_step
where device_type='NPU'
<if test="run_time != null and run_time != ''">
            and  job_run_time>=#{run_time}*60
</if>
<if test="wait_time != null and wait_time != ''">
            and   job_wait_time>=#{wait_time}*60
</if>
<if test="repo != null and repo != ''">
            and   repo=#{repo}
</if>

<if test="org != null and org != ''">
            and   org=#{org}
</if>
<if test="created_at != null and created_at != ''">
            and   workflow_created_at>=#{created_at}::date
</if>

 """
var total_res = db.select(page_sql)
var total = total_res.get(0).get('total')
var pages = total/page_size+1
var res_map = new HashMap();
res_map.put("total",total)
res_map.put("pages",pages)
res_map.put("data",res)

return res_map;


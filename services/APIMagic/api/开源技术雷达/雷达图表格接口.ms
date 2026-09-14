{
  "properties" : { },
  "id" : "copy1768469251649d39193",
  "script" : null,
  "groupId" : "3a231f0454e249a2bc9f8b073e1ee8ab",
  "name" : "雷达图表格接口",
  "createTime" : null,
  "updateTime" : 1777378541321,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/radar/table/metric",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"file_project\": \"accelerate\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.0180,\n        \"diff\": 0.0273\n    }, {\n        \"file_project\": \"agentica-project/rllm\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4373,\n        \"diff\": 0.2713\n    }, {\n        \"file_project\": \"AI4Finance-Foundation/ElegantRL\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6390,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"ai-dynamo/dynamo\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.9263,\n        \"diff\": 0.0562\n    }, {\n        \"file_project\": \"alibaba/ChatLearn\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2705,\n        \"diff\": 0.2681\n    }, {\n        \"file_project\": \"alibaba/EasyReinforcementLearning\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.0095,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"alibaba/MNN\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7596,\n        \"diff\": 0.0051\n    }, {\n        \"file_project\": \"alibaba/RecIS\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2211,\n        \"diff\": 0.0618\n    }, {\n        \"file_project\": \"alibaba/ROLL\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6110,\n        \"diff\": 0.3752\n    }, {\n        \"file_project\": \"alibaba/ROLL\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.5978,\n        \"diff\": -0.0132\n    }, {\n        \"file_project\": \"alibaba/rtp-llm\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5656,\n        \"diff\": 1.4990\n    }, {\n        \"file_project\": \"ao\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7648,\n        \"diff\": 0.1101\n    }, {\n        \"file_project\": \"apache/tvm\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.6804,\n        \"diff\": 0.0463\n    }, {\n        \"file_project\": \"apache/tvm-ffi\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7473,\n        \"diff\": 0.0900\n    }, {\n        \"file_project\": \"AReaL\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2075,\n        \"diff\": 0.1957\n    }, {\n        \"file_project\": \"axolotl\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.6497,\n        \"diff\": 0.2231\n    }, {\n        \"file_project\": \"axolotl-ai-cloud/axolotl\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7522,\n        \"diff\": 0.0826\n    }, {\n        \"file_project\": \"bitsandbytes\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.6890,\n        \"diff\": 0.0598\n    }, {\n        \"file_project\": \"bitsandbytes-foundation/bitsandbytes\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7000,\n        \"diff\": 0.0612\n    }, {\n        \"file_project\": \"ByteDance-Seed/Triton-distributed\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2990,\n        \"diff\": 0.1234\n    }, {\n        \"file_project\": \"ChatLearn\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.0000,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"containers/ramalama\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7722,\n        \"diff\": 0.0179\n    }, {\n        \"file_project\": \"coze-dev/coze-loop\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.8090,\n        \"diff\": 0.1849\n    }, {\n        \"file_project\": \"coze-dev/coze-studio\",\n        \"ring_ch\": \"评估\",\n        \"score\": 3.0000,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"coze-loop\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2496,\n        \"diff\": 0.0539\n    }, {\n        \"file_project\": \"coze-studio\",\n        \"ring_ch\": \"评估\",\n        \"score\": 2.0000,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"Dao-AILab/flash-attention\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7600,\n        \"diff\": 0.0304\n    }, {\n        \"file_project\": \"data-juicer\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.0146,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"DeepSpeed\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 0.8576,\n        \"diff\": 0.0659\n    }, {\n        \"file_project\": \"DiffSynth-Studio\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4910,\n        \"diff\": 0.3961\n    }, {\n        \"file_project\": \"DLR-RM/stable-baselines3\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.9609,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"dynamo\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7207,\n        \"diff\": 0.2721\n    }, {\n        \"file_project\": \"executorch\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.2669,\n        \"diff\": 0.1425\n    }, {\n        \"file_project\": \"facebookexperimental/triton\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.8824,\n        \"diff\": 0.1409\n    }, {\n        \"file_project\": \"facebookresearch/CUTracer\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.1622,\n        \"diff\": 1.0529\n    }, {\n        \"file_project\": \"facebookresearch/faiss\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.1319,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"fit-framework\",\n        \"ring_ch\": \"评估\",\n        \"score\": 12.2800,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"FlagGems\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5092,\n        \"diff\": 0.4687\n    }, {\n        \"file_project\": \"FlagOpen/FlagGems\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4593,\n        \"diff\": 0.0239\n    }, {\n        \"file_project\": \"flagos-ai/FlagGems\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.8830,\n        \"diff\": 1.4503\n    }, {\n        \"file_project\": \"flagtree\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5944,\n        \"diff\": 0.5746\n    }, {\n        \"file_project\": \"FlagTree/flagtree\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5295,\n        \"diff\": 0.1964\n    }, {\n        \"file_project\": \"flash-attention\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7494,\n        \"diff\": 0.0817\n    }, {\n        \"file_project\": \"ggml-org/llama.cpp\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 1.9351,\n        \"diff\": 0.0394\n    }, {\n        \"file_project\": \"helion\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.1815,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"hiyouga/EasyR1\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7763,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"hiyouga/LLaMA-Factory\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 1.1201,\n        \"diff\": 0.0347\n    }, {\n        \"file_project\": \"huggingface/accelerate\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.0261,\n        \"diff\": 0.0715\n    }, {\n        \"file_project\": \"huggingface/open-r1\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.3045,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"huggingface/peft\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 1.0032,\n        \"diff\": 0.0554\n    }, {\n        \"file_project\": \"huggingface/text-generation-inference\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.6553,\n        \"diff\": 0.0051\n    }, {\n        \"file_project\": \"huggingface/transformers\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 4.0000,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"huggingface/trl\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.9260,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"inclusionAI/AReaL\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.0507,\n        \"diff\": 0.5129\n    }, {\n        \"file_project\": \"inclusionAI/AReaL\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.0412,\n        \"diff\": -0.0095\n    }, {\n        \"file_project\": \"inclusionAI/dInfer\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2902,\n        \"diff\": 0.1168\n    }, {\n        \"file_project\": \"infinity\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5879,\n        \"diff\": 0.0530\n    }, {\n        \"file_project\": \"InternLM/InternEvo\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2392,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"InternLM/lmdeploy\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.6814,\n        \"diff\": 0.0054\n    }, {\n        \"file_project\": \"InternLM/xtuner\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5473,\n        \"diff\": 0.1139\n    }, {\n        \"file_project\": \"jax\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.2252,\n        \"diff\": 0.0324\n    }, {\n        \"file_project\": \"jax-ml/jax\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.2242,\n        \"diff\": 0.1899\n    }, {\n        \"file_project\": \"jd-opensource/xllm\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4831,\n        \"diff\": 0.0499\n    }, {\n        \"file_project\": \"kserve/kserve\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7446,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"ktransformers\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.8912,\n        \"diff\": 0.1545\n    }, {\n        \"file_project\": \"kvcache-ai/ktransformers\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7355,\n        \"diff\": 0.0405\n    }, {\n        \"file_project\": \"kvcache-ai/Mooncake\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7467,\n        \"diff\": 0.0346\n    }, {\n        \"file_project\": \"langchain\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 1.0260,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"leibniz-csi/mm_grpo\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.1210,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"linkedin/Liger-Kernel\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.9525,\n        \"diff\": 0.3532\n    }, {\n        \"file_project\": \"llama.cpp\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.6955,\n        \"diff\": 0.0144\n    }, {\n        \"file_project\": \"LLaMA-Factory\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 1.3391,\n        \"diff\": 0.1998\n    }, {\n        \"file_project\": \"llm-d\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5085,\n        \"diff\": 0.4991\n    }, {\n        \"file_project\": \"llm-d/llm-d\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6486,\n        \"diff\": 0.0389\n    }, {\n        \"file_project\": \"LMCache/LMCache\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.8382,\n        \"diff\": 0.0123\n    }, {\n        \"file_project\": \"lmdeploy\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7903,\n        \"diff\": 0.1223\n    }, {\n        \"file_project\": \"Megatron-LM\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7329,\n        \"diff\": 0.0665\n    }, {\n        \"file_project\": \"meta-pytorch/monarch\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6883,\n        \"diff\": 0.0552\n    }, {\n        \"file_project\": \"meta-pytorch/OpenEnv\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6851,\n        \"diff\": 0.4719\n    }, {\n        \"file_project\": \"meta-pytorch/torchcomms\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4916,\n        \"diff\": 0.1383\n    }, {\n        \"file_project\": \"meta-pytorch/torchforge\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6005,\n        \"diff\": 0.4024\n    }, {\n        \"file_project\": \"meta-pytorch/torchstore\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.3069,\n        \"diff\": 0.0457\n    }, {\n        \"file_project\": \"meta-pytorch/tritonbench\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6309,\n        \"diff\": 1.6309\n    }, {\n        \"file_project\": \"meta-pytorch/tritonparse\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.3880,\n        \"diff\": 1.3745\n    }, {\n        \"file_project\": \"michaelfeil/infinity\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5201,\n        \"diff\": 0.0367\n    }, {\n        \"file_project\": \"microsoft/agent-lightning\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.9341,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"microsoft/agent-lightning\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.9629,\n        \"diff\": 0.0288\n    }, {\n        \"file_project\": \"microsoft/DeepSpeed\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 0.8877,\n        \"diff\": 0.0535\n    }, {\n        \"file_project\": \"microsoft/onnxruntime\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.1608,\n        \"diff\": 0.0117\n    }, {\n        \"file_project\": \"microsoft/triton-shared\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4571,\n        \"diff\": 0.3865\n    }, {\n        \"file_project\": \"mlc-ai/mlc-llm\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7256,\n        \"diff\": 0.0029\n    }, {\n        \"file_project\": \"mlc-llm\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.8433,\n        \"diff\": 0.0481\n    }, {\n        \"file_project\": \"ModelEngine-Group/fit-framework\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.0601,\n        \"diff\": 0.3268\n    }, {\n        \"file_project\": \"modelscope\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.6282,\n        \"diff\": 0.1285\n    }, {\n        \"file_project\": \"modelscope/data-juicer\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4484,\n        \"diff\": 0.0527\n    }, {\n        \"file_project\": \"modelscope/DiffSynth-Studio\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6193,\n        \"diff\": 0.0121\n    }, {\n        \"file_project\": \"modelscope/modelscope\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.6745,\n        \"diff\": 0.0984\n    }, {\n        \"file_project\": \"modelscope/ms-swift\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.1362,\n        \"diff\": 0.1259\n    }, {\n        \"file_project\": \"modularml/mojo\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.8554,\n        \"diff\": 0.0124\n    }, {\n        \"file_project\": \"modular/modular\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.0555,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"mojo\",\n        \"ring_ch\": \"评估\",\n        \"score\": 2.0529,\n        \"diff\": 0.0575\n    }, {\n        \"file_project\": \"ms-swift\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.8225,\n        \"diff\": 0.4474\n    }, {\n        \"file_project\": \"NovaSky-AI/SkyRL\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.8111,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"NVIDIA/cutile-python\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2341,\n        \"diff\": 0.1236\n    }, {\n        \"file_project\": \"NVIDIA/Megatron-LM\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.9224,\n        \"diff\": 0.1052\n    }, {\n        \"file_project\": \"NVIDIA-NeMo/RL\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.9178,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"NVIDIA/TensorRT-LLM\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.3899,\n        \"diff\": 0.0397\n    }, {\n        \"file_project\": \"NVlabs/Fast-dLLM\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2949,\n        \"diff\": 0.0304\n    }, {\n        \"file_project\": \"ollama\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.4539,\n        \"diff\": 0.0106\n    }, {\n        \"file_project\": \"ollama/ollama\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.3454,\n        \"diff\": 0.0153\n    }, {\n        \"file_project\": \"onnxruntime\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.2717,\n        \"diff\": 0.1250\n    }, {\n        \"file_project\": \"OpenBMB/BMTrain\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2690,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"OpenPipe/ART\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.9151,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"OpenRLHF\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.6862,\n        \"diff\": 0.1387\n    }, {\n        \"file_project\": \"OpenRLHF/OpenRLHF\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.0890,\n        \"diff\": 0.5764\n    }, {\n        \"file_project\": \"openvinotoolkit/openvino\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.2102,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"openxla/xla\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.6362,\n        \"diff\": 0.0648\n    }, {\n        \"file_project\": \"PaddleNLP\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.0603,\n        \"diff\": 0.2042\n    }, {\n        \"file_project\": \"PaddlePaddle/Paddle\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.2400,\n        \"diff\": 0.0542\n    }, {\n        \"file_project\": \"PaddlePaddle/PaddleNLP\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.8023,\n        \"diff\": 0.0343\n    }, {\n        \"file_project\": \"peft\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 0.9075,\n        \"diff\": 0.1969\n    }, {\n        \"file_project\": \"PeterGriffinJin/Search-R1\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.2851,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"PrimeIntellect-ai/verifiers\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7402,\n        \"diff\": 0.4412\n    }, {\n        \"file_project\": \"pytorch\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 3.4835,\n        \"diff\": 0.0703\n    }, {\n        \"file_project\": \"pytorch/ao\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.8037,\n        \"diff\": 0.0694\n    }, {\n        \"file_project\": \"pytorch/executorch\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.1803,\n        \"diff\": -0.0113\n    }, {\n        \"file_project\": \"pytorch/helion\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.8735,\n        \"diff\": 0.3347\n    }, {\n        \"file_project\": \"pytorch/pytorch\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 3.4994,\n        \"diff\": 0.0046\n    }, {\n        \"file_project\": \"pytorch/rl\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.1617,\n        \"diff\": 0.5143\n    }, {\n        \"file_project\": \"pytorch/torchchat\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.3597,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"pytorch/torchft\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4007,\n        \"diff\": 0.0550\n    }, {\n        \"file_project\": \"pytorch/torchtitan\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7355,\n        \"diff\": 0.0570\n    }, {\n        \"file_project\": \"pytorch/torchtune\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.4121,\n        \"diff\": 0.1073\n    }, {\n        \"file_project\": \"ramalama\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.8033,\n        \"diff\": 0.1787\n    }, {\n        \"file_project\": \"ray\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 1.6332,\n        \"diff\": 0.1716\n    }, {\n        \"file_project\": \"ray-project/ray\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.2041,\n        \"diff\": 0.2445\n    }, {\n        \"file_project\": \"redhat-et/MCU\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.0257,\n        \"diff\": 1.0257\n    }, {\n        \"file_project\": \"rl\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7396,\n        \"diff\": 0.1775\n    }, {\n        \"file_project\": \"RLinf/RLinf\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6414,\n        \"diff\": 0.4997\n    }, {\n        \"file_project\": \"rllm\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.0198,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"ROLL\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.0331,\n        \"diff\": 0.0238\n    }, {\n        \"file_project\": \"scrapy\",\n        \"ring_ch\": \"试验\",\n        \"score\": 3.0000,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"sglang\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.5194,\n        \"diff\": 0.1938\n    }, {\n        \"file_project\": \"sgl-project/ome\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4106,\n        \"diff\": 0.0533\n    }, {\n        \"file_project\": \"sgl-project/sglang\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.2131,\n        \"diff\": 0.3992\n    }, {\n        \"file_project\": \"Tencent/KsanaLLM\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.1603,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"TensorRT-LLM\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.2458,\n        \"diff\": 0.3345\n    }, {\n        \"file_project\": \"text-generation-inference\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.8321,\n        \"diff\": 0.0568\n    }, {\n        \"file_project\": \"THUDM/slime\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.0423,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"THUDM/slime\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.0026,\n        \"diff\": -0.0397\n    }, {\n        \"file_project\": \"thu-ml/tianshou\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.0324,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"thunlp/OpenDelta\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.1586,\n        \"diff\": 0.1573\n    }, {\n        \"file_project\": \"thu-pacman/chitu\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.3318,\n        \"diff\": 0.0058\n    }, {\n        \"file_project\": \"tile-ai/tilelang\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.2426,\n        \"diff\": 0.1886\n    }, {\n        \"file_project\": \"torchft\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.3942,\n        \"diff\": 0.1174\n    }, {\n        \"file_project\": \"torchtitan\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.6825,\n        \"diff\": 0.1162\n    }, {\n        \"file_project\": \"torchtune\",\n        \"ring_ch\": \"试验\",\n        \"score\": 0.7421,\n        \"diff\": 0.2041\n    }, {\n        \"file_project\": \"transformers\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 4.0000,\n        \"diff\": 0.3070\n    }, {\n        \"file_project\": \"triton\",\n        \"ring_ch\": \"试验\",\n        \"score\": 3.5655,\n        \"diff\": 0.2528\n    }, {\n        \"file_project\": \"Triton-distributed\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.0823,\n        \"diff\": 0.0298\n    }, {\n        \"file_project\": \"triton-lang/triton\",\n        \"ring_ch\": \"试验\",\n        \"score\": 3.6595,\n        \"diff\": 0.0413\n    }, {\n        \"file_project\": \"trl\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 1.0605,\n        \"diff\": 0.1929\n    }, {\n        \"file_project\": \"tvm\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.8276,\n        \"diff\": 0.2536\n    }, {\n        \"file_project\": \"unsloth\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.1082,\n        \"diff\": 0.1972\n    }, {\n        \"file_project\": \"unslothai/unsloth\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.2290,\n        \"diff\": 0.1422\n    }, {\n        \"file_project\": \"verifiers\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.0001,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"verl\",\n        \"ring_ch\": \"试验\",\n        \"score\": 1.3248,\n        \"diff\": 0.3645\n    }, {\n        \"file_project\": \"vipshop/cache-dit\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4849,\n        \"diff\": 0.0958\n    }, {\n        \"file_project\": \"vllm\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.6665,\n        \"diff\": 0.1768\n    }, {\n        \"file_project\": \"vllm-project/aibrix\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5869,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"vllm-project/production-stack\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.5320,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"vllm-project/vllm\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.5968,\n        \"diff\": 0.0177\n    }, {\n        \"file_project\": \"volcengine/verl\",\n        \"ring_ch\": \"采纳\",\n        \"score\": 2.7333,\n        \"diff\": 1.4141\n    }, {\n        \"file_project\": \"vwxyzjn/cleanrl\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.8861,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"xDiT\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.3136,\n        \"diff\": 0.2954\n    }, {\n        \"file_project\": \"xdit-project/xDiT\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4565,\n        \"diff\": 0.0283\n    }, {\n        \"file_project\": \"xla\",\n        \"ring_ch\": \"评估\",\n        \"score\": 1.6124,\n        \"diff\": 0.1218\n    }, {\n        \"file_project\": \"xorbitsai/inference\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.7045,\n        \"diff\": 0.0000\n    }, {\n        \"file_project\": \"yifan123/flow_grpo\",\n        \"ring_ch\": \"评估\",\n        \"score\": 0.4076,\n        \"diff\": 0.0000\n    }],\n    \"timestamp\": 1773826383383,\n    \"executeTime\": 4\n}",
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
      SELECT 
          file_project,
          ring_ch,
          MAX(score) AS score,
          Max(diff) as diff
      FROM fact_opensource_radar_data
      WHERE  score IS NOT NULL  and ring !='Archive'
                  and (type='PostTraining' OR type='inference' OR type='AIFrameworkAndAccelerator' or Type='compiler' )
                <if test="algorithm_tem != null and algorithm_tem != ''">
                  and algorithm=#{algorithm_tem}
              </if>
                <if test="date_str_tem != null and date_str_tem != ''">
                  and date_str::date >=#{date_str_tem}::date
              </if>
                <if test="month_tem != null and month_tem != ''">
            and month=#{month_tem}
        </if>
      GROUP BY file_project,ring_ch
      """
}else{
   sql = """
      SELECT 
          file_project,
          ring_ch,
          MAX(score) AS score,
          Max(diff) as diff
      FROM fact_opensource_radar_data 
      WHERE  score IS NOT NULL  and ring !='Archive'
                <if test="algorithm_tem != null and algorithm_tem != ''">
                  and algorithm=#{algorithm_tem}
              </if>
                <if test="type_tem != null and type_tem != ''">
                  and type=#{type_tem}
              </if>
                <if test="date_str_tem != null and date_str_tem != ''">
                  and date_str::date >=#{date_str_tem}::date
              </if>
  <if test="month_tem != null and month_tem != ''">
            and month=#{month_tem}
        </if>
      GROUP BY file_project,ring_ch
      """
}
var dd = db.select(sql)
return  dd;

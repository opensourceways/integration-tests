{
  "properties" : { },
  "id" : "a6c80b155f924bebadf1f552f237a952",
  "script" : null,
  "groupId" : "88106ac6415b4414a1298660a1768d34",
  "name" : "矩阵图",
  "createTime" : null,
  "updateTime" : 1774579045856,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/{type}/graph",
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
  "requestBody" : "{\r\n    \"community\": \"openeuler\",\r\n    \"service\": \"sig\",\r\n    \"start\": 0,\r\n    \"end\": 1759017600000\r\n}",
  "headers" : [ ],
  "paths" : [ {
    "name" : "type",
    "value" : "module",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^(module|service)$",
    "children" : null
  } ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"module\": \"Kernel\",\n        \"stay_time\": 4.1519,\n        \"visit_time\": 225\n    }, {\n        \"module\": \"Others\",\n        \"stay_time\": 219.2064,\n        \"visit_time\": 18\n    }, {\n        \"module\": \"Infrastructure\",\n        \"stay_time\": 3.1075,\n        \"visit_time\": 145\n    }, {\n        \"module\": \"DB\",\n        \"stay_time\": 2.2697,\n        \"visit_time\": 62\n    }, {\n        \"module\": \"sig-compat-winapp\",\n        \"stay_time\": 0.0261,\n        \"visit_time\": 8\n    }, {\n        \"module\": \"sig-Ostree-Assembly\",\n        \"stay_time\": 0.0067,\n        \"visit_time\": 5\n    }, {\n        \"module\": \"user-committee\",\n        \"stay_time\": 0.2661,\n        \"visit_time\": 14\n    }, {\n        \"module\": \"Desktop\",\n        \"stay_time\": 1.7994,\n        \"visit_time\": 66\n    }, {\n        \"module\": \"sig-haskell\",\n        \"stay_time\": 0.0036,\n        \"visit_time\": 4\n    }, {\n        \"module\": \"sig-UKUI\",\n        \"stay_time\": 0.0617,\n        \"visit_time\": 34\n    }, {\n        \"module\": \"security-committee\",\n        \"stay_time\": 0.6767,\n        \"visit_time\": 90\n    }, {\n        \"module\": \"sig-list\",\n        \"stay_time\": 1129.1297,\n        \"visit_time\": 7523\n    }, {\n        \"module\": \"Networking\",\n        \"stay_time\": 0.3322,\n        \"visit_time\": 24\n    }, {\n        \"module\": \"sig-golang\",\n        \"stay_time\": 0.0978,\n        \"visit_time\": 8\n    }, {\n        \"module\": \"Programming-language\",\n        \"stay_time\": 1.5469,\n        \"visit_time\": 41\n    }, {\n        \"module\": \"sig-rfo\",\n        \"stay_time\": 0.0342,\n        \"visit_time\": 12\n    }, {\n        \"module\": \"sig-Yocto\",\n        \"stay_time\": 0.0436,\n        \"visit_time\": 2\n    }, {\n        \"module\": \"sig-MCP-Tools-Ecosystem\",\n        \"stay_time\": 0.0000,\n        \"visit_time\": 0\n    }, {\n        \"module\": \"sig-compliance\",\n        \"stay_time\": 0.8981,\n        \"visit_time\": 23\n    }, {\n        \"module\": \"System-tool\",\n        \"stay_time\": 0.0514,\n        \"visit_time\": 12\n    }, {\n        \"module\": \"sig-porting-platform-winapp\",\n        \"stay_time\": 0.0144,\n        \"visit_time\": 6\n    }, {\n        \"module\": \"sig-UB-ServiceCore\",\n        \"stay_time\": 0.0000,\n        \"visit_time\": 0\n    }, {\n        \"module\": \"sig-ops\",\n        \"stay_time\": 0.5950,\n        \"visit_time\": 49\n    }, {\n        \"module\": \"sig-epkg\",\n        \"stay_time\": 0.0492,\n        \"visit_time\": 21\n    }, {\n        \"module\": \"sig-Hygon\",\n        \"stay_time\": 0.6600,\n        \"visit_time\": 20\n    }, {\n        \"module\": \"sig-LoongArch\",\n        \"stay_time\": 0.3461,\n        \"visit_time\": 8\n    }, {\n        \"module\": \"xfce\",\n        \"stay_time\": 0.0894,\n        \"visit_time\": 10\n    }, {\n        \"module\": \"sig-memsafety\",\n        \"stay_time\": 0.0917,\n        \"visit_time\": 21\n    }, {\n        \"module\": \"Storage\",\n        \"stay_time\": 507.9706,\n        \"visit_time\": 54\n    }, {\n        \"module\": \"sig-openstack\",\n        \"stay_time\": 1.2553,\n        \"visit_time\": 80\n    }, {\n        \"module\": \"Private\",\n        \"stay_time\": 0.2600,\n        \"visit_time\": 3\n    }, {\n        \"module\": \"sig-perl-modules\",\n        \"stay_time\": 0.4100,\n        \"visit_time\": 14\n    }, {\n        \"module\": \"sig-QT\",\n        \"stay_time\": 0.3675,\n        \"visit_time\": 5\n    }, {\n        \"module\": \"sig-OpenResty\",\n        \"stay_time\": 0.0656,\n        \"visit_time\": 4\n    }, {\n        \"module\": \"sig-SDS\",\n        \"stay_time\": 0.4828,\n        \"visit_time\": 48\n    }, {\n        \"module\": \"sig-industrial-control\",\n        \"stay_time\": 0.0406,\n        \"visit_time\": 11\n    }, {\n        \"module\": \"sig-minzuchess\",\n        \"stay_time\": 0.0264,\n        \"visit_time\": 7\n    }, {\n        \"module\": \"sig-distributed-middleware\",\n        \"stay_time\": 0.1775,\n        \"visit_time\": 6\n    }, {\n        \"module\": \"sig-KIRAN-DESKTOP\",\n        \"stay_time\": 0.1369,\n        \"visit_time\": 13\n    }, {\n        \"module\": \"sig-recycle\",\n        \"stay_time\": 0.2911,\n        \"visit_time\": 11\n    }, {\n        \"module\": \"sig-OSCourse\",\n        \"stay_time\": 0.0700,\n        \"visit_time\": 6\n    }, {\n        \"module\": \"oVirt.html\",\n        \"stay_time\": 0.0000,\n        \"visit_time\": 0\n    }, {\n        \"module\": \"sig-epol\",\n        \"stay_time\": 0.0469,\n        \"visit_time\": 8\n    }, {\n        \"module\": \"sig-Intel-Arch\",\n        \"stay_time\": 1.3806,\n        \"visit_time\": 16\n    }, {\n        \"module\": \"A-Tune.html\",\n        \"stay_time\": 0.1667,\n        \"visit_time\": 6\n    }, {\n        \"module\": \"TC\",\n        \"stay_time\": 7.6086,\n        \"visit_time\": 245\n    }, {\n        \"module\": \"sig-Long\",\n        \"stay_time\": 2.2125,\n        \"visit_time\": 44\n    }, {\n        \"module\": \"sig-CICD\",\n        \"stay_time\": 0.8639,\n        \"visit_time\": 38\n    }, {\n        \"module\": \"GNOME\",\n        \"stay_time\": 0.0544,\n        \"visit_time\": 11\n    }, {\n        \"module\": \"ecopkg\",\n        \"stay_time\": 2.6208,\n        \"visit_time\": 51\n    }, {\n        \"module\": \"sig-guidance\",\n        \"stay_time\": 344.8625,\n        \"visit_time\": 312\n    }, {\n        \"module\": \"sig-OpenDesign\",\n        \"stay_time\": 1.8047,\n        \"visit_time\": 45\n    }, {\n        \"module\": \"doc\",\n        \"stay_time\": 0.7900,\n        \"visit_time\": 73\n    }, {\n        \"module\": \"sig-security-facility\",\n        \"stay_time\": 2.3447,\n        \"visit_time\": 67\n    }, {\n        \"module\": \"sig-desktop-apps\",\n        \"stay_time\": 0.2558,\n        \"visit_time\": 2\n    }, {\n        \"module\": \"sig-KDE\",\n        \"stay_time\": 0.0206,\n        \"visit_time\": 7\n    }, {\n        \"module\": \"sig-YuanRong\",\n        \"stay_time\": 0.0000,\n        \"visit_time\": 0\n    }, {\n        \"module\": \"A-Tune\",\n        \"stay_time\": 84.7600,\n        \"visit_time\": 1001\n    }, {\n        \"module\": \"sig-sbom\",\n        \"stay_time\": 0.6308,\n        \"visit_time\": 22\n    }, {\n        \"module\": \"sig-EasyLife\",\n        \"stay_time\": 0.1700,\n        \"visit_time\": 15\n    }, {\n        \"module\": \"sig-python-modules\",\n        \"stay_time\": 0.3611,\n        \"visit_time\": 16\n    }, {\n        \"module\": \"sig-Zephyr\",\n        \"stay_time\": 0.4025,\n        \"visit_time\": 22\n    }, {\n        \"module\": \"Marketing\",\n        \"stay_time\": 0.4153,\n        \"visit_time\": 25\n    }, {\n        \"module\": \"role-description\",\n        \"stay_time\": 69.0089,\n        \"visit_time\": 668\n    }, {\n        \"module\": \"sig-FangTian\",\n        \"stay_time\": 1.0853,\n        \"visit_time\": 36\n    }, {\n        \"module\": \"sig-IDE\",\n        \"stay_time\": 0.0131,\n        \"visit_time\": 8\n    }, {\n        \"module\": \"G11N\",\n        \"stay_time\": 0.1344,\n        \"visit_time\": 41\n    }, {\n        \"module\": \"sig-confidential-computing\",\n        \"stay_time\": 1.5228,\n        \"visit_time\": 60\n    }, {\n        \"module\": \"sig-OSRefTools\",\n        \"stay_time\": 0.0228,\n        \"visit_time\": 3\n    }, {\n        \"module\": \"sig-DDE\",\n        \"stay_time\": 0.5053,\n        \"visit_time\": 11\n    }, {\n        \"module\": \"bigdata\",\n        \"stay_time\": 2521.2772,\n        \"visit_time\": 115\n    }, {\n        \"module\": \"Base-service\",\n        \"stay_time\": 2.6797,\n        \"visit_time\": 87\n    }, {\n        \"module\": \"sig-detail\",\n        \"stay_time\": 192.4947,\n        \"visit_time\": 1394\n    }, {\n        \"module\": \"Computing\",\n        \"stay_time\": 0.8444,\n        \"visit_time\": 54\n    }, {\n        \"module\": \"sig-RISC-V\",\n        \"stay_time\": 4.8911,\n        \"visit_time\": 145\n    }, {\n        \"module\": \"sig-AccLib\",\n        \"stay_time\": 0.5636,\n        \"visit_time\": 46\n    }, {\n        \"module\": \"ai\",\n        \"stay_time\": 1332.8497,\n        \"visit_time\": 308\n    }, {\n        \"module\": \"sig-Backup\",\n        \"stay_time\": 1.7258,\n        \"visit_time\": 24\n    }, {\n        \"module\": \"sig-ruby\",\n        \"stay_time\": 54.1722,\n        \"visit_time\": 6\n    }, {\n        \"module\": \"sig-sw-arch\",\n        \"stay_time\": 0.4019,\n        \"visit_time\": 7\n    }, {\n        \"module\": \"sig-UnifiedBus\",\n        \"stay_time\": 2.3925,\n        \"visit_time\": 63\n    }, {\n        \"module\": \"sig-BMC\",\n        \"stay_time\": 0.0153,\n        \"visit_time\": 19\n    }, {\n        \"module\": \"Packaging\",\n        \"stay_time\": 0.1944,\n        \"visit_time\": 11\n    }, {\n        \"module\": \"sig-nodejs\",\n        \"stay_time\": 0.0117,\n        \"visit_time\": 1\n    }, {\n        \"module\": \"sig-WayCa\",\n        \"stay_time\": 0.7772,\n        \"visit_time\": 9\n    }, {\n        \"module\": \"sig-CloudNative\",\n        \"stay_time\": 0.6183,\n        \"visit_time\": 65\n    }, {\n        \"module\": \"sig-QA\",\n        \"stay_time\": 20.1911,\n        \"visit_time\": 65\n    }, {\n        \"module\": \"sig-Compatibility-Infra\",\n        \"stay_time\": 1.1108,\n        \"visit_time\": 74\n    }, {\n        \"module\": \"sig-Gatekeeper\",\n        \"stay_time\": 0.1450,\n        \"visit_time\": 13\n    }, {\n        \"module\": \"sig-intelligence\",\n        \"stay_time\": 1.8733,\n        \"visit_time\": 102\n    }, {\n        \"module\": \"Application\",\n        \"stay_time\": 3.3292,\n        \"visit_time\": 114\n    }, {\n        \"module\": \"sig-Java\",\n        \"stay_time\": 1.9203,\n        \"visit_time\": 27\n    }, {\n        \"module\": \"sig-Arm\",\n        \"stay_time\": 3.9456,\n        \"visit_time\": 137\n    }, {\n        \"module\": \"sig-cinnamon\",\n        \"stay_time\": 0.0211,\n        \"visit_time\": 8\n    }, {\n        \"module\": \"sig-Migration\",\n        \"stay_time\": 0.2194,\n        \"visit_time\": 11\n    }, {\n        \"module\": \"meeting-guide\",\n        \"stay_time\": 7.8456,\n        \"visit_time\": 363\n    }, {\n        \"module\": \"sig-Ha\",\n        \"stay_time\": 0.3950,\n        \"visit_time\": 8\n    }, {\n        \"module\": \"sig-embedded\",\n        \"stay_time\": 1.9178,\n        \"visit_time\": 101\n    }, {\n        \"module\": \"sig-K8sDistro\",\n        \"stay_time\": 0.3806,\n        \"visit_time\": 14\n    }, {\n        \"module\": \"iSulad\",\n        \"stay_time\": 0.1111,\n        \"visit_time\": 17\n    }, {\n        \"module\": \"sig-release-management\",\n        \"stay_time\": 1.7244,\n        \"visit_time\": 74\n    }, {\n        \"module\": \"sig-DevStation\",\n        \"stay_time\": 0.0000,\n        \"visit_time\": 0\n    }, {\n        \"module\": \"sig-DPU\",\n        \"stay_time\": 0.0122,\n        \"visit_time\": 11\n    }, {\n        \"module\": \"sig-high-performance-network\",\n        \"stay_time\": 22.5642,\n        \"visit_time\": 30\n    }, {\n        \"module\": \"sig-Talent-and-Service\",\n        \"stay_time\": 0.6247,\n        \"visit_time\": 15\n    }, {\n        \"module\": \"oVirt\",\n        \"stay_time\": 0.0597,\n        \"visit_time\": 24\n    }, {\n        \"module\": \"ai.html\",\n        \"stay_time\": 0.0139,\n        \"visit_time\": 1\n    }, {\n        \"module\": \"sig-Edge\",\n        \"stay_time\": 0.1450,\n        \"visit_time\": 9\n    }, {\n        \"module\": \"Runtime\",\n        \"stay_time\": 0.3897,\n        \"visit_time\": 29\n    }, {\n        \"module\": \"sig-POWER\",\n        \"stay_time\": 0.3117,\n        \"visit_time\": 5\n    }, {\n        \"module\": \"sig-SBC\",\n        \"stay_time\": 0.3378,\n        \"visit_time\": 9\n    }, {\n        \"module\": \"Compiler\",\n        \"stay_time\": 19.1081,\n        \"visit_time\": 527\n    }, {\n        \"module\": \"sig-template\",\n        \"stay_time\": 0.0014,\n        \"visit_time\": 1\n    }, {\n        \"module\": \"sig-bio\",\n        \"stay_time\": 0.0556,\n        \"visit_time\": 3\n    }, {\n        \"module\": \"sig-message-middleware\",\n        \"stay_time\": 1.2572,\n        \"visit_time\": 25\n    }, {\n        \"module\": \"sig-mate-desktop\",\n        \"stay_time\": 0.0822,\n        \"visit_time\": 11\n    }, {\n        \"module\": \"dev-utils\",\n        \"stay_time\": 1.1600,\n        \"visit_time\": 30\n    }, {\n        \"module\": \"Virt\",\n        \"stay_time\": 0.3078,\n        \"visit_time\": 49\n    }, {\n        \"module\": \"sig-ebpf\",\n        \"stay_time\": 1.0719,\n        \"visit_time\": 38\n    }, {\n        \"module\": \"sig-OS-Builder\",\n        \"stay_time\": 0.6286,\n        \"visit_time\": 22\n    }, {\n        \"module\": \"sig-power-efficient\",\n        \"stay_time\": 0.0319,\n        \"visit_time\": 7\n    }, {\n        \"module\": \"sig-ROS\",\n        \"stay_time\": 0.2758,\n        \"visit_time\": 51\n    }, {\n        \"module\": \"sig-HPC\",\n        \"stay_time\": 0.6500,\n        \"visit_time\": 33\n    }, {\n        \"module\": \"sig-reproducible-builds\",\n        \"stay_time\": 0.0908,\n        \"visit_time\": 10\n    }],\n    \"timestamp\": 1774317157523,\n    \"executeTime\": 58\n}",
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
      "name" : "community",
      "value" : "openeuler",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^[a-zA-Z]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "service",
      "value" : "search_docs",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "pattern",
      "error" : null,
      "expression" : "^[a-zA-Z0-9_]{1,32}$",
      "children" : [ ]
    }, {
      "name" : "start",
      "value" : "1739017600000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : null,
      "expression" : null,
      "children" : [ ]
    }, {
      "name" : "end",
      "value" : "1759017600000",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "expression",
      "error" : null,
      "expression" : null,
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
          "name" : "module",
          "value" : "20.03_LTS",
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
          "name" : "stay_time",
          "value" : "1.20",
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
          "name" : "visit_time",
          "value" : "0.04",
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
    }, {
      "name" : "timestamp",
      "value" : "1760088575606",
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
      "value" : "24",
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
var sql = """
SELECT 
    ${type},
    ROUND(coalesce(sum(stay_time), 0) / 3600.0, 4) AS stay_time,
    coalesce(sum(visit_time), 0) AS visit_time
FROM dws_${body.community}_${type}_time_day
WHERE 1 = 1
        <if test="type == 'module' and body.service != null and body.service != ''">
            AND service = #{body.service}
        </if>
        <if test="body.start != null">
            AND date >= date_trunc('day', to_timestamp(#{body.start}/1000)::DATE)::DATE
        </if>
        <if test="body.end != null">
            AND date <= date_trunc('day', to_timestamp(#{body.end}/1000)::DATE)::DATE
        </if>
GROUP BY ${type}
ORDER BY ${type};
"""
return db.select(sql)

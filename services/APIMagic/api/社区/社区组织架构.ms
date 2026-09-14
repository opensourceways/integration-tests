{
  "properties" : { },
  "id" : "49b58106da5c4c068318673c0ef72407",
  "script" : null,
  "groupId" : "10e2710a382e42ef81f33c984351995e",
  "name" : "社区组织架构",
  "createTime" : null,
  "updateTime" : 1775784036695,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/org/type",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "opengauss",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : null,
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"sigs\": [\"ai\", \"Application\", \"A-Tune\", \"Base-service\", \"bigdata\", \"Compiler\", \"Computing\", \"DB\", \"Desktop\", \"dev-utils\", \"doc\", \"ecopkg\", \"G11N\", \"GNOME\", \"Infrastructure\", \"iSulad\", \"Kernel\", \"Marketing\", \"Networking\", \"Others\", \"oVirt\", \"Packaging\", \"Private\", \"Programming-language\", \"Runtime\", \"security-committee\", \"sig-AccLib\", \"sig-Arm\", \"sig-bio\", \"sig-BMC\", \"sig-CICD\", \"sig-cinnamon\", \"sig-CloudNative\", \"sig-Compatibility-Infra\", \"sig-compat-winapp\", \"sig-compliance\", \"sig-confidential-computing\", \"sig-DDE\", \"sig-desktop-apps\", \"sig-DevStation\", \"sig-distributed-middleware\", \"sig-DPU\", \"sig-EasyLife\", \"sig-ebpf\", \"sig-Edge\", \"sig-embedded\", \"sig-epkg\", \"sig-epol\", \"sig-FangTian\", \"sig-Gatekeeper\", \"sig-golang\", \"sig-Ha\", \"sig-haskell\", \"sig-high-performance-network\", \"sig-HPC\", \"sig-Hygon\", \"sig-IDE\", \"sig-industrial-control\", \"sig-Intel-Arch\", \"sig-intelligence\", \"sig-Java\", \"sig-K8sDistro\", \"sig-KDE\", \"sig-KIRAN-DESKTOP\", \"sig-Long\", \"sig-LoongArch\", \"sig-mate-desktop\", \"sig-MCP-Tools-Ecosystem\", \"sig-memsafety\", \"sig-message-middleware\", \"sig-Migration\", \"sig-minzuchess\", \"sig-nodejs\", \"sig-OceanBase\", \"sig-OpenDesign\", \"sig-openstack\", \"sig-ops\", \"sig-OS-Builder\", \"sig-OSCourse\", \"sig-perl-modules\", \"sig-porting-platform-winapp\", \"sig-power-efficient\", \"sig-python-modules\", \"sig-QA\", \"sig-QT\", \"sig-recycle\", \"sig-release-management\", \"sig-RISC-V\", \"sig-ROS\", \"sig-ruby\", \"sig-SBC\", \"sig-sbom\", \"sig-SDS\", \"sig-security-facility\", \"sig-Space\", \"sig-sw-arch\", \"sig-Talent-and-Service\", \"sig-UB-ServiceCore\", \"sig-UKUI\", \"sig-UnifiedBus\", \"sig-WayCa\", \"sig-YuanRong\", \"sig-Zephyr\", \"Storage\", \"System-tool\", \"TC\", \"user-committee\", \"Virt\", \"xfce\"],\n        \"sig_count\": 109,\n        \"orgs\": [\"openEuler AI联合工作组\", \"openEuler 业务发展工作组\", \"openEuler 全球化工作组\", \"openEuler 品牌委员会\", \"openEuler 委员会\", \"openEuler 委员会顾问专家委员会\", \"openEuler 技术委员会\", \"openEuler 教育工作组\", \"openEuler 法务工作组\", \"openEuler 用户委员会\", \"openEuler 社区运营工作组\"],\n        \"org_count\": 11\n    },\n    \"timestamp\": 1775784022361,\n    \"executeTime\": 72\n}",
  "description" : "获取社区所有组织类型列表，包括社区组织架构下的组织列表、SIG组列表",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sig_user_table = `fact_${community}_sig_user`
var org_member_table = `fact_${community}_organization_member`

var check_sig_table = db.select("""SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = #{sig_user_table})""")
var check_org_table = db.select("""SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = #{org_member_table})""")

var sig_table_exists = check_sig_table[0].exists
var org_table_exists = check_org_table[0].exists

var sigs = []
var orgs = []

if (sig_table_exists) {
    var sig_sql = """
    SELECT array_agg(DISTINCT "sig_name") as "sigs"
    FROM ${sig_user_table}
    WHERE "sig_name" IS NOT NULL
    """
    var sig_result = db.select(sig_sql)
    if (sig_result.length > 0 && sig_result[0].sigs) {
        sigs = sig_result[0].sigs.getArray()
    }
}

if (org_table_exists) {
    var org_sql = """
    SELECT array_agg(DISTINCT "group_name") as "orgs"
    FROM ${org_member_table}
    WHERE "group_name" IS NOT NULL
    """
    var org_result = db.select(org_sql)
    if (org_result.length > 0 && org_result[0].orgs) {
        orgs = org_result[0].orgs.getArray()
    }
}

return { "sigs": sigs, "sig_count": sigs.getLength(), "orgs": orgs, "org_count": orgs.getLength() }

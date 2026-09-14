{
  "properties" : { },
  "id" : "e91aee25cf20427b9088bebc78546bd8",
  "script" : null,
  "groupId" : "521ef640123a4ae79386e6a38b8df4ad",
  "name" : "TC成员",
  "createTime" : null,
  "updateTime" : 1773884365141,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "tc/sigs",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "openeuler",
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  } ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"user\": \"blue0613\",\n        \"html_url\": \"https://atomgit.com/blue0613\",\n        \"email\": \"gaoguijin@huawei.com\",\n        \"name\": \"高贵锦\",\n        \"sigs\": [\"sig-confidential-computing\", \"TC\"]\n    }, {\n        \"user\": \"bugflyfly\",\n        \"html_url\": \"https://atomgit.com/bugflyfly\",\n        \"email\": \"wei_jiangang@hoperun.com\",\n        \"name\": \"魏建刚\",\n        \"sigs\": [\"ecopkg\", \"sig-compliance\", \"sig-distributed-middleware\", \"sig-recycle\", \"System-tool\", \"TC\"]\n    }, {\n        \"user\": \"cellfaint\",\n        \"html_url\": \"https://atomgit.com/cellfaint\",\n        \"email\": \"wangzhigang17@huawei.com\",\n        \"name\": \"王志钢\",\n        \"sigs\": [\"ecopkg\", \"sig-recycle\", \"TC\"]\n    }, {\n        \"user\": \"cellfaint\",\n        \"html_url\": \"https://atomgit.com/cellfaint\",\n        \"email\": \"wangzhigang@huawei.com\",\n        \"name\": \"王志钢\",\n        \"sigs\": [\"Virt\"]\n    }, {\n        \"user\": \"cf-zhao\",\n        \"html_url\": \"https://atomgit.com/cf-zhao\",\n        \"email\": \"zhaochuanfeng@huawei.com\",\n        \"name\": \"赵川峰\",\n        \"sigs\": [\"Compiler\", \"ecopkg\", \"sig-recycle\", \"TC\"]\n    }, {\n        \"user\": \"chenmaodong\",\n        \"html_url\": \"https://atomgit.com/chenmaodong\",\n        \"email\": \"chenmaodong@xfusion.com\",\n        \"name\": \"陈茂冬\",\n        \"sigs\": [\"sig-confidential-computing\", \"TC\"]\n    }, {\n        \"user\": \"dillon_chen\",\n        \"html_url\": \"https://atomgit.com/dillon_chen\",\n        \"email\": \"dillon.chen@gmail.com\",\n        \"name\": \"陈棋德\",\n        \"sigs\": [\"Base-service\", \"DB\", \"ecopkg\", \"sig-recycle\", \"TC\"]\n    }, {\n        \"user\": \"geliangtang\",\n        \"html_url\": \"https://gitee.com/geliangtang\",\n        \"email\": \"geliang@kernel.org\",\n        \"name\": \"唐葛亮\",\n        \"sigs\": [\"TC\"]\n    }, {\n        \"user\": \"geliangtang\",\n        \"html_url\": \"https://gitee.com/geliangtang\",\n        \"email\": \"tanggeliang@kylinos.cn\",\n        \"name\": \"唐葛亮\",\n        \"sigs\": [\"Networking\", \"sig-Intel-Arch\"]\n    }, {\n        \"user\": \"genedna\",\n        \"html_url\": \"https://atomgit.com/genedna\",\n        \"email\": \"eli@patch.sh\",\n        \"name\": \"马全一\",\n        \"sigs\": [\"Infrastructure\", \"Marketing\", \"sig-Migration\", \"sig-OpenDesign\", \"TC\", \"user-committee\"]\n    }, {\n        \"user\": \"genedna\",\n        \"html_url\": \"https://atomgit.com/genedna\",\n        \"email\": \"genedna@gmail.com\",\n        \"name\": \"马全一\",\n        \"sigs\": [\"sig-golang\"]\n    }, {\n        \"user\": \"genedna\",\n        \"html_url\": \"https://atomgit.com/genedna\",\n        \"email\": \"maquanyi1@huawei.com\",\n        \"name\": \"马全一\",\n        \"sigs\": [\"sig-OSCourse\"]\n    }, {\n        \"user\": \"georgecao\",\n        \"html_url\": \"https://atomgit.com/georgecao\",\n        \"email\": \"caozhi1214@qq.com\",\n        \"name\": \"曹志\",\n        \"sigs\": [\"dev-utils\", \"Infrastructure\", \"sig-Gatekeeper\"]\n    }, {\n        \"user\": \"georgecao\",\n        \"html_url\": \"https://atomgit.com/georgecao\",\n        \"email\": \"george.cao@huawei.com\",\n        \"name\": \"曹志\",\n        \"sigs\": [\"ecopkg\", \"sig-recycle\", \"TC\"]\n    }, {\n        \"user\": \"HelloWorld_lvcongqing\",\n        \"html_url\": \"https://atomgit.com/HelloWorld_lvcongqing\",\n        \"email\": \"lvcongqing@uniontech.com\",\n        \"name\": \"吕从庆\",\n        \"sigs\": [\"ecopkg\", \"sig-DDE\", \"sig-recycle\", \"TC\"]\n    }, {\n        \"user\": \"hjimmy\",\n        \"html_url\": \"https://atomgit.com/hjimmy\",\n        \"email\": \"houjian@kylinos.cn\",\n        \"name\": \"侯健\",\n        \"sigs\": [\"ecopkg\", \"oVirt\", \"sig-Ha\", \"sig-KDE\", \"sig-recycle\", \"TC\"]\n    }, {\n        \"user\": \"jianminw\",\n        \"html_url\": \"https://atomgit.com/jianminw\",\n        \"email\": \"jianmin@iscas.ac.cn\",\n        \"name\": \"王建民\",\n        \"sigs\": [\"ecopkg\", \"sig-CloudNative\", \"sig-compat-winapp\", \"sig-porting-platform-winapp\", \"sig-recycle\", \"sig-SBC\", \"TC\"]\n    }, {\n        \"user\": \"Jingwiw\",\n        \"html_url\": \"https://atomgit.com/Jingwiw\",\n        \"email\": \"wangjingwei@iscas.ac.cn\",\n        \"name\": \"王经纬\",\n        \"sigs\": [\"Programming-language\", \"sig-epol\", \"sig-QT\", \"sig-release-management\", \"sig-RISC-V\", \"TC\"]\n    }, {\n        \"user\": \"juntianlinux\",\n        \"html_url\": \"https://gitee.com/juntianlinux\",\n        \"email\": \"jun.j.tan@intel.com\",\n        \"name\": \"田俊\",\n        \"sigs\": [\"ecopkg\"]\n    }, {\n        \"user\": \"juntianlinux\",\n        \"html_url\": \"https://gitee.com/juntianlinux\",\n        \"email\": \"jun.j.tian@intel.com\",\n        \"name\": \"田俊\",\n        \"sigs\": [\"Kernel\", \"sig-Intel-Arch\", \"sig-Long\", \"sig-release-management\", \"TC\"]\n    }, {\n        \"user\": \"kailiu42\",\n        \"html_url\": \"https://atomgit.com/kailiu42\",\n        \"email\": \"kai.liu@suse.com\",\n        \"name\": \"刘恺\",\n        \"sigs\": [\"Kernel\"]\n    }, {\n        \"user\": \"kailiu42\",\n        \"html_url\": \"https://atomgit.com/kailiu42\",\n        \"email\": \"kraml.liu@gmail.com\",\n        \"name\": \"刘恺\",\n        \"sigs\": [\"sig-epkg\", \"sig-haskell\", \"TC\"]\n    }, {\n        \"user\": \"kaitiandu\",\n        \"html_url\": \"https://atomgit.com/kaitiandu\",\n        \"email\": \"dukaitian@huawei.com\",\n        \"name\": \"杜开田\",\n        \"sigs\": [\"ai\", \"Application\", \"Kernel\", \"Others\", \"Packaging\", \"sig-CICD\", \"sig-Compatibility-Infra\", \"sig-intelligence\", \"TC\"]\n    }, {\n        \"user\": \"oekernel\",\n        \"html_url\": \"https://atomgit.com/oekernel\",\n        \"email\": \"xiexiuqi@huawei.com\",\n        \"name\": \"谢秀奇\",\n        \"sigs\": [\"ecopkg\", \"Kernel\", \"sig-recycle\", \"TC\"]\n    }, {\n        \"user\": \"shinwell_hu\",\n        \"html_url\": \"https://atomgit.com/shinwell_hu\",\n        \"email\": \"huxinwei@huawei.com\",\n        \"name\": \"胡欣蔚\",\n        \"sigs\": [\"ecopkg\", \"sig-EasyLife\", \"sig-recycle\", \"sig-ruby\"]\n    }, {\n        \"user\": \"shinwell_hu\",\n        \"html_url\": \"https://atomgit.com/shinwell_hu\",\n        \"email\": \"micromotive@qq.com\",\n        \"name\": \"胡欣蔚\",\n        \"sigs\": [\"sig-perl-modules\"]\n    }, {\n        \"user\": \"shinwell_hu\",\n        \"html_url\": \"https://atomgit.com/shinwell_hu\",\n        \"email\": \"shinwell_hu@openeuler.sh\",\n        \"name\": \"胡欣蔚\",\n        \"sigs\": [\"Compiler\", \"Private\", \"sig-bio\", \"sig-haskell\", \"sig-python-modules\", \"TC\"]\n    }, {\n        \"user\": \"solarhu\",\n        \"html_url\": \"https://atomgit.com/solarhu\",\n        \"email\": \"solar.hu@foxmail.com\",\n        \"name\": \"胡峰\",\n        \"sigs\": [\"Packaging\"]\n    }, {\n        \"user\": \"solarhu\",\n        \"html_url\": \"https://atomgit.com/solarhu\",\n        \"email\": \"solar.hu@huawei.com\",\n        \"name\": \"胡峰\",\n        \"sigs\": [\"ecopkg\", \"Private\", \"sig-EasyLife\", \"sig-epol\", \"sig-Gatekeeper\", \"sig-nodejs\", \"sig-ops\", \"sig-recycle\", \"sig-release-management\", \"TC\"]\n    }, {\n        \"user\": \"stonefly128\",\n        \"html_url\": \"https://gitee.com/stonefly128\",\n        \"email\": \"shiyong@kylinos.com.cn\",\n        \"name\": \"石勇\",\n        \"sigs\": [\"ecopkg\", \"sig-KIRAN-DESKTOP\", \"sig-Migration\", \"sig-recycle\", \"TC\"]\n    }, {\n        \"user\": \"vonhust\",\n        \"html_url\": \"https://atomgit.com/vonhust\",\n        \"email\": \"191362693@qq.com\",\n        \"name\": \"任慰\",\n        \"sigs\": [\"sig-embedded\", \"sig-epkg\", \"sig-SBC\", \"sig-Zephyr\", \"TC\"]\n    }, {\n        \"user\": \"vonhust\",\n        \"html_url\": \"https://atomgit.com/vonhust\",\n        \"email\": \"renwei41@huawei.com\",\n        \"name\": \"任慰\",\n        \"sigs\": [\"ecopkg\", \"sig-recycle\"]\n    }, {\n        \"user\": \"wu_fengguang\",\n        \"html_url\": \"https://atomgit.com/wu_fengguang\",\n        \"email\": \"wfg@mail.ustc.edu.cn\",\n        \"name\": \"吴峰光\",\n        \"sigs\": [\"ecopkg\", \"sig-CICD\", \"sig-epkg\", \"sig-haskell\", \"sig-QA\", \"sig-recycle\", \"TC\"]\n    }, {\n        \"user\": \"yalogr\",\n        \"html_url\": \"https://atomgit.com/yalogr\",\n        \"email\": \"yuelg@chinaunicom.cn\",\n        \"name\": \"岳龙广\",\n        \"sigs\": [\"sig-ebpf\", \"sig-intelligence\", \"TC\"]\n    }, {\n        \"user\": \"yaqiangchen\",\n        \"html_url\": \"https://atomgit.com/yaqiangchen\",\n        \"email\": \"chen_yaqiang@foxmail.com\",\n        \"name\": \"陈亚强\",\n        \"sigs\": [\"TC\"]\n    }, {\n        \"user\": \"yaqiangchen\",\n        \"html_url\": \"https://atomgit.com/yaqiangchen\",\n        \"email\": \"chenyaqiang@huawei.com\",\n        \"name\": \"陈亚强\",\n        \"sigs\": [\"Packaging\", \"sig-epkg\", \"sig-release-management\"]\n    }, {\n        \"user\": \"yeqinglong01\",\n        \"html_url\": \"https://gitee.com/yeqinglong01\",\n        \"email\": \"yeqinglong@kylinsec.com.cn\",\n        \"name\": \"叶青龙\",\n        \"sigs\": [\"sig-release-management\", \"TC\"]\n    }, {\n        \"user\": \"yeqinglong01\",\n        \"html_url\": \"https://gitee.com/yeqinglong01\",\n        \"email\": \"yeqinglong@uniontech.com\",\n        \"name\": \"叶青龙\",\n        \"sigs\": [\"sig-Migration\"]\n    }, {\n        \"user\": \"zhujianwei001\",\n        \"html_url\": \"https://atomgit.com/zhujianwei001\",\n        \"email\": \"zhujianwei7@huawei.com\",\n        \"name\": \"朱健伟\",\n        \"sigs\": [\"Base-service\", \"ecopkg\", \"Kernel\", \"security-committee\", \"sig-recycle\", \"sig-security-facility\", \"TC\"]\n    }],\n    \"timestamp\": 1767060759772,\n    \"executeTime\": 135\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var sqlstr = """
    SELECT 
        fcsu.user_login as user, 
        fur.real_name_zh as name,
        array_agg(DISTINCT fcsu.sig_name) as sigs
    FROM 
        fact_${community}_sig_user fcsu
    JOIN 
        fact_${community}_sig_user tc_users
        ON fcsu.user_login = tc_users.user_login
        AND tc_users.sig_name = 'TC'
        AND tc_users.is_removed IS NULL
    JOIN
        fact_user_readme fur
        ON fcsu.user_login = fur.user_login
    WHERE 
        fcsu.is_removed IS NULL
    GROUP BY 
        fcsu.user_login, fur.real_name_zh;
    """
if (community == 'openeuler') {
    sqlstr = """
        SELECT 
            fcsu.user_login as user, 
            fcsu.user_homepage_url as html_url,
            fur.real_name_zh as name,
            array_agg(DISTINCT fcsu.sig_name) as sigs
        FROM 
            fact_${community}_sig_user fcsu
        JOIN 
            fact_${community}_sig_user tc_users
            ON fcsu.user_login = tc_users.user_login
            AND tc_users.sig_name = 'TC'
            AND tc_users.is_removed IS NULL
        JOIN
            fact_user_readme fur
            ON fcsu.user_login = fur.user_login
        WHERE 
            fcsu.is_removed IS NULL
        GROUP BY 
            fcsu.user_login, fcsu.user_homepage_url, fur.real_name_zh;
        """
}
var resp = db.select(sqlstr)
resp.each(it => it['sigs'] = it.sigs.getArray())
return resp

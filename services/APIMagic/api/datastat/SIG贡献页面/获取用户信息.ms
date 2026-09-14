{
  "properties" : { },
  "id" : "8bb88ce1a80949abb812f6814ef2bde9",
  "script" : null,
  "groupId" : "a513b1f12b714736abc308a60d73a9e6",
  "name" : "获取用户信息",
  "createTime" : null,
  "updateTime" : 1760172068603,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/userinfo",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "opengauss",
    "validateType" : "pattern",
    "error" : "community 参数非法",
    "expression" : "^(ascend|Ascend|mindspore|Mindspore|openeuler|opengauss|openGauss|boostkit|BoostKit|openfuyao|openFuyao|openubmc|openUBMC|openlibing|OpenLibing)$",
    "children" : null
  }, {
    "name" : "page",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : "page 必须大于 0",
    "expression" : "page > 0",
    "children" : null
  }, {
    "name" : "pageSize",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "100",
    "validateType" : "expression",
    "error" : "pageSize 必须在 1-100 之间",
    "expression" : "pageSize > 0 && pageSize <= 100",
    "children" : null
  }, {
    "name" : "platform",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "gitee",
    "validateType" : "pattern",
    "error" : "platform 参数非法",
    "expression" : "^(gitee|gitcode|github)?$",
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
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": [{\n        \"user_login\": \"zxx_147\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zxy1187128998\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zxy653100\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"678688@qq.com\"\n    }, {\n        \"user_login\": \"zxyybb\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"2803771409@qq.com\"\n    }, {\n        \"user_login\": \"zxzeunit\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"15798861+zxzeunit@user.noreply.gitee.com\"\n    }, {\n        \"user_login\": \"zxzoey\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zxzou-xi\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zxzouxi\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zxzxzzz\",\n        \"company_type\": \"华为\",\n        \"email\": \"1071408489@qq.com\"\n    }, {\n        \"user_login\": \"zxzxzzz\",\n        \"company_type\": \"华为\",\n        \"email\": \"zhangxiao131@huawei.com\"\n    }, {\n        \"user_login\": \"zy1031516870\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1031516870@qq.com\"\n    }, {\n        \"user_login\": \"ZY1223\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zy1579534385\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1579534385@qq.com\"\n    }, {\n        \"user_login\": \"zy19941995\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zy1f4n\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zy20031014\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1831409113@qq.com\"\n    }, {\n        \"user_login\": \"zy_37_0\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zya123321\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyaikeylin\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyb314\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zybzclm\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zydjys\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyf1116\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"Zyf657\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1261593794@qq.com\"\n    }, {\n        \"user_login\": \"zyh_123_123\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"5339156+zyh_123_123@user.noreply.gitee.com\"\n    }, {\n        \"user_login\": \"zyh_git\",\n        \"company_type\": \"企业\",\n        \"email\": \"zhaoyuehui@cysoftware.com.cn\"\n    }, {\n        \"user_login\": \"zyh_topsec\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyimin\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"7943699+zyimin@user.noreply.gitee.com\"\n    }, {\n        \"user_login\": \"zyj2297349886\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"2297349886@qq.com\"\n    }, {\n        \"user_login\": \"zyj-alex\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"494809513@qq.com\"\n    }, {\n        \"user_login\": \"zyk23\",\n        \"company_type\": \"企业\",\n        \"email\": \"zhaoyuke@xfusion.com\"\n    }, {\n        \"user_login\": \"zyljy\",\n        \"company_type\": \"企业\",\n        \"email\": \"zhangying@xfusion.com\"\n    }, {\n        \"user_login\": \"zym787\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zymysite\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1132951535@qq.com\"\n    }, {\n        \"user_login\": \"zynfly\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"zynfly@9z.work\"\n    }, {\n        \"user_login\": \"zyove\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyp217\",\n        \"company_type\": \"华为\",\n        \"email\": \"zhaoyipeng5@huawei.com\"\n    }, {\n        \"user_login\": \"zyp-rock\",\n        \"company_type\": \"华为\",\n        \"email\": \"zhuyanpeng@huawei.com\"\n    }, {\n        \"user_login\": \"zyq-tw\",\n        \"company_type\": \"华为\",\n        \"email\": \"18215593773@163.com\"\n    }, {\n        \"user_login\": \"zyq-tw\",\n        \"company_type\": \"华为\",\n        \"email\": \"zhengyanqi@huawei.com\"\n    }, {\n        \"user_login\": \"zyuanchen\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyu_code\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyw008\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"15756850+zyw008@user.noreply.gitee.com\"\n    }, {\n        \"user_login\": \"zywang_dev\",\n        \"company_type\": \"企业\",\n        \"email\": \"dev12101@linx-info.com\"\n    }, {\n        \"user_login\": \"zyx5256\",\n        \"company_type\": \"华为\",\n        \"email\": \"zhuyuxiao@huawei.com\"\n    }, {\n        \"user_login\": \"zyx95\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"Zyx-A\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyx-hhnkh\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyxhmn\",\n        \"company_type\": \"企业\",\n        \"email\": \"zhouyu.ros@isrc.iscas.ac.cn\"\n    }, {\n        \"user_login\": \"zyy18380130021\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyyang123\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"zyyang@linx-info.com\"\n    }, {\n        \"user_login\": \"zyyang5\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zyyy9\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"3177749559@qq.com\"\n    }, {\n        \"user_login\": \"zyyYY123333\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1182588662@qq.com\"\n    }, {\n        \"user_login\": \"zyz0030\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zz0303\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1134380859@qq.com\"\n    }, {\n        \"user_login\": \"zz1401598719com\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"dky0zz@163.com\"\n    }, {\n        \"user_login\": \"zz153_admin\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zz_906\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zz9804\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zza12356\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1425562720@qq.com\"\n    }, {\n        \"user_login\": \"zzb20106\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1753896257@qq.com\"\n    }, {\n        \"user_login\": \"zzberg\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzc314\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"zhengzhch3@mail2.sysu.edu.cn\"\n    }, {\n        \"user_login\": \"zzdx713320\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzekai\",\n        \"company_type\": \"企业\",\n        \"email\": \"zhaozekai@cqsoftware.com.cn\"\n    }, {\n        \"user_login\": \"zzev\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"lxinyi@ruc.edu.cn\"\n    }, {\n        \"user_login\": \"zzh0905\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzh593245631\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzhint\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzh-ly\",\n        \"company_type\": \"华为\",\n        \"email\": \"zhangzhihao52@huawei.com\"\n    }, {\n        \"user_login\": \"zzhsz\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzipBob\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzixuan\",\n        \"company_type\": \"华为\",\n        \"email\": \"zhaozixuan2@huawei.com\"\n    }, {\n        \"user_login\": \"zzj1979\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzjshaok\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"373088022@qq.com\"\n    }, {\n        \"user_login\": \"zzk315\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzkk1231\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzl-1998\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzliapp\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzm_567\",\n        \"company_type\": \"华为\",\n        \"email\": \"7587189+zzm_567@user.noreply.gitee.com\"\n    }, {\n        \"user_login\": \"zzm_567\",\n        \"company_type\": \"华为\",\n        \"email\": \"zhanzhimin@h-partners.com\"\n    }, {\n        \"user_login\": \"zzm_567\",\n        \"company_type\": \"华为\",\n        \"email\": \"zhanzhimin@huawei.com\"\n    }, {\n        \"user_login\": \"zzmine\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"820460891@qq.com\"\n    }, {\n        \"user_login\": \"zzmjhzz\",\n        \"company_type\": \"企业\",\n        \"email\": \"zhang.zhengming@h3c.com\"\n    }, {\n        \"user_login\": \"zzmjhzz\",\n        \"company_type\": \"企业\",\n        \"email\": \"zzmjhzz@163.com\"\n    }, {\n        \"user_login\": \"zzonly777\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzp0106\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzq122813439\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzqen\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzqqwang2025\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1412293663@qq.com\"\n    }, {\n        \"user_login\": \"zzry\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"1245464216@qq.com\"\n    }, {\n        \"user_login\": \"zzsoft_699\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzsun_code\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"5735335+zzsun_code@user.noreply.gitee.com\"\n    }, {\n        \"user_login\": \"zzthezz\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"2385747226@qq.com\"\n    }, {\n        \"user_login\": \"zzthezz\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"9615943+zzthezz@user.noreply.gitee.com\"\n    }, {\n        \"user_login\": \"zzucx99\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzuqax\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"5400787+zzuqax@user.noreply.gitee.com\"\n    }, {\n        \"user_login\": \"zzw183\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzwwddd\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzwwzz666\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"582010476@qq.com\"\n    }, {\n        \"user_login\": \"zzx031227\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": \"11644061+zzx031227@user.noreply.gitee.com\"\n    }, {\n        \"user_login\": \"zzx17612221857\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzxwill\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"zzxxjjzxj\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }, {\n        \"user_login\": \"z_ZXY_y\",\n        \"company_type\": \"个人贡献者\",\n        \"email\": null\n    }],\n    \"timestamp\": 1760171319224,\n    \"executeTime\": null\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}

================================
var off = (page - 1) * pageSize
var sqlstr = """
WITH paginated_users AS (
    SELECT user_login
    FROM (
        SELECT DISTINCT user_login
        FROM dwm_${community}_contribute_user_company
        WHERE source = #{platform}
        ORDER BY user_login
        LIMIT #{pageSize} OFFSET #{off}
    ) users
)
SELECT 
    doc.user_login,
    doc.company_type,
    fe.email
FROM paginated_users pu
JOIN dwm_${community}_contribute_user_company doc ON pu.user_login = doc.user_login
LEFT JOIN fact_${platform}_email_login fe ON pu.user_login = fe.user_login
GROUP BY doc.user_login, doc.company_type, fe.email
ORDER BY doc.user_login;"""
var resp = db.select(sqlstr)
return resp

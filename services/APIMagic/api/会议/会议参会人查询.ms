{
  "properties" : { },
  "id" : "9f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c",
  "script" : null,
  "groupId" : "9af308d96b55470faeda3c9b3357f836",
  "name" : "会议参会人查询",
  "createTime" : null,
  "updateTime" : 1776394551733,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/participants/info",
  "method" : "GET",
  "parameters" : [ {
    "name" : "community",
    "value" : "openeuler",
    "description" : null,
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "pattern",
    "error" : "community 参数格式非法",
    "expression" : "^[a-zA-Z]{1,32}$",
    "children" : null
  }, {
    "name" : "meeting_id",
    "value" : "",
    "description" : "会议ID",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : null
  }, {
    "name" : "user_name",
    "value" : "",
    "description" : "参会人用户名",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : null
  }, {
    "name" : "page",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "1",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page > 0",
    "children" : null
  }, {
    "name" : "page_size",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "Integer",
    "type" : null,
    "defaultValue" : "100",
    "validateType" : "expression",
    "error" : null,
    "expression" : "page_size <= 100 && page_size > 0",
    "children" : null
  }, {
    "name" : "sort",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "",
    "validateType" : "pattern",
    "error" : "sort 只能为 meeting_id、user_name",
    "expression" : "^(meeting_id|user_name)?$",
    "children" : null
  }, {
    "name" : "direction",
    "value" : "desc",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : "desc",
    "validateType" : "pattern",
    "error" : "direction 只能为 asc 或 desc",
    "expression" : "^(asc|desc|ASC|DESC)?$",
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
  "headers" : [ {
    "name" : "token",
    "value" : "",
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 1,\n    \"message\": \"success\",\n    \"data\": {\n        \"total\": 10316,\n        \"list\": [{\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"jiangxinyu\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"Lijie l00498886\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"武碧洁\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"chenyx130\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"张天宇\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"李永强\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"lemon\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"zhuofeng z30027100\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"tangzhengliang t00886669\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"zhu_jinlong\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"wujie-iscas\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"Zhangziyang z00608440\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"刘婧婧\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"liangya lwx1276251\"\n        }, {\n            \"meeting_id\": \"3214\",\n            \"user_name\": \"shidongdong s00475742\"\n        }, {\n            \"meeting_id\": \"3212\",\n            \"user_name\": \"Yafen Fang\"\n        }, {\n            \"meeting_id\": \"3212\",\n            \"user_name\": \"Jianmin\"\n        }, {\n            \"meeting_id\": \"3212\",\n            \"user_name\": \"李沛文\"\n        }, {\n            \"meeting_id\": \"3212\",\n            \"user_name\": \"黄炎\"\n        }, {\n            \"meeting_id\": \"3211\",\n            \"user_name\": \"林倩\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"Shangjiguang s00488387\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"Zhangkaili z00567778\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"王宇超 w00562932\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"jichenglin j00649603\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"Luozhancheng l00534985\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"Songlicheng s00570596\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"史欣沅\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"xiahualiang x00464880\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"夏华梁 00464880\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"明沛\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"yebiaoxiang y00470486\"\n        }, {\n            \"meeting_id\": \"3210\",\n            \"user_name\": \"liangyi l00620609\"\n        }, {\n            \"meeting_id\": \"3209\",\n            \"user_name\": \"justinhe Arm\"\n        }, {\n            \"meeting_id\": \"3209\",\n            \"user_name\": \"xuraoqing x30033245\"\n        }, {\n            \"meeting_id\": \"3209\",\n            \"user_name\": \"zhouguangwei z00507110\"\n        }, {\n            \"meeting_id\": \"3209\",\n            \"user_name\": \"xiexiunian x30071648\"\n        }, {\n            \"meeting_id\": \"3209\",\n            \"user_name\": \"houmingyong\"\n        }, {\n            \"meeting_id\": \"3209\",\n            \"user_name\": \"chase\"\n        }, {\n            \"meeting_id\": \"3209\",\n            \"user_name\": \"xuce x30067397\"\n        }, {\n            \"meeting_id\": \"3209\",\n            \"user_name\": \"程琨\"\n        }, {\n            \"meeting_id\": \"3209\",\n            \"user_name\": \"chenjiayi c00790382\"\n        }, {\n            \"meeting_id\": \"3208\",\n            \"user_name\": \"陈浩然\"\n        }, {\n            \"meeting_id\": \"3208\",\n            \"user_name\": \"任思远\"\n        }, {\n            \"meeting_id\": \"3208\",\n            \"user_name\": \"秦勇\"\n        }, {\n            \"meeting_id\": \"3208\",\n            \"user_name\": \"hao\"\n        }, {\n            \"meeting_id\": \"3208\",\n            \"user_name\": \"刘敏\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"liweigang\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"谢志恒\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"kingb\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"Weixuan\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"华为 王鼎\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"华为-黄晓权\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"Intel-胡林\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"Jiacheng Zhou\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"wuying\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"华为-李云飞\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"华为-罗峰\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"陈正\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"huawei-douyiwang\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"王凯\"\n        }, {\n            \"meeting_id\": \"3207\",\n            \"user_name\": \"华为-李彦成\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"武碧洁\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"欧拉-周韦彤\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"麒麟-孙立刚\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"z00632486\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"麒麟软件-王千里\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"yangzhao_kl\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"z00858319\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"何守成\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"d00818609\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"LI, Mengxiao\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"39694432 Wang Ye\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"Hongyu Shi\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"赵家麒\"\n        }, {\n            \"meeting_id\": \"3206\",\n            \"user_name\": \"卫淼\"\n        }, {\n            \"meeting_id\": \"3205\",\n            \"user_name\": \"duanpengjie d00802824\"\n        }, {\n            \"meeting_id\": \"3205\",\n            \"user_name\": \"walkerwu\"\n        }, {\n            \"meeting_id\": \"3205\",\n            \"user_name\": \"ewang\"\n        }, {\n            \"meeting_id\": \"3205\",\n            \"user_name\": \"beta\"\n        }, {\n            \"meeting_id\": \"3205\",\n            \"user_name\": \"Dingxudong d00882396\"\n        }, {\n            \"meeting_id\": \"3205\",\n            \"user_name\": \"Zhunaipan z00584191\"\n        }, {\n            \"meeting_id\": \"3204\",\n            \"user_name\": \"w00604752\"\n        }, {\n            \"meeting_id\": \"3203\",\n            \"user_name\": \"张鹏瑞\"\n        }, {\n            \"meeting_id\": \"3203\",\n            \"user_name\": \"张毅峰\"\n        }, {\n            \"meeting_id\": \"3203\",\n            \"user_name\": \"陈仲煜\"\n        }, {\n            \"meeting_id\": \"3203\",\n            \"user_name\": \"倪志广\"\n        }, {\n            \"meeting_id\": \"3203\",\n            \"user_name\": \"beta\"\n        }, {\n            \"meeting_id\": \"3203\",\n            \"user_name\": \"曾昭荣\"\n        }, {\n            \"meeting_id\": \"3203\",\n            \"user_name\": \"远行者老巫\"\n        }, {\n            \"meeting_id\": \"3202\",\n            \"user_name\": \"openEuler-赵家麒\"\n        }, {\n            \"meeting_id\": \"3202\",\n            \"user_name\": \"Mark46\"\n        }, {\n            \"meeting_id\": \"3202\",\n            \"user_name\": \"wangtsingx\"\n        }, {\n            \"meeting_id\": \"3202\",\n            \"user_name\": \"x00803930\"\n        }, {\n            \"meeting_id\": \"3202\",\n            \"user_name\": \"Hongyu Shi\"\n        }, {\n            \"meeting_id\": \"3202\",\n            \"user_name\": \"欧拉-周韦彤\"\n        }, {\n            \"meeting_id\": \"3201\",\n            \"user_name\": \"ewang\"\n        }, {\n            \"meeting_id\": \"3200\",\n            \"user_name\": \"我的 Mate 40 RS\"\n        }, {\n            \"meeting_id\": \"3200\",\n            \"user_name\": \"shiyongbang s00452708\"\n        }, {\n            \"meeting_id\": \"3200\",\n            \"user_name\": \"Yang\"\n        }, {\n            \"meeting_id\": \"3200\",\n            \"user_name\": \"tanghui t00507290\"\n        }]\n    },\n    \"timestamp\": 1776394542837,\n    \"executeTime\": 22\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
var off = (page - 1) * page_size

var table_name = `fact_${community}_meeting_participants`

var sort_field = not_blank(sort) ? '"' + sort + '"' : '"meeting_id"'
var sort_dir = not_blank(direction) ? direction.toLowerCase() : 'desc'

var sqlstr = """
SELECT
    "meeting_id",
    "user_name"
FROM
    ${table_name} t
WHERE
    1 = 1
    <if test="not_blank(meeting_id)">
        AND "meeting_id" = #{meeting_id}
    </if>
    <if test="not_blank(user_name)">
        AND "user_name" = #{user_name}
    </if>
ORDER BY ${sort_field} ${sort_dir}
"""

var resp = db.page(sqlstr, page_size, off)
return resp

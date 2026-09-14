{
  "properties" : { },
  "id" : "595f703cec2240d5b0969fa60f12d114",
  "script" : null,
  "groupId" : "521ef640123a4ae79386e6a38b8df4ad",
  "name" : "authing注册信息webhook",
  "createTime" : null,
  "updateTime" : 1758276082663,
  "lock" : null,
  "createBy" : null,
  "updateBy" : "admin",
  "path" : "/authing/webhook/usercreated",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\r\n  \"eventName\": \"user:created\",\r\n  \"data\": {\r\n    \"thirdPartyIdentity\": {\r\n      \"provider\": null,\r\n      \"refreshToken\": null,\r\n      \"accessToken\": null,\r\n      \"scope\": null,\r\n      \"expiresIn\": null,\r\n      \"updatedAt\": null\r\n    },\r\n    \"userPoolId\": \"68a3179a9544e6059c205d4a\",\r\n    \"email\": \"pengyue21@h-partners.com\",\r\n    \"username\": \"unifiedbus_8yjs5kkj\",\r\n    \"nickname\": \"小彭\",\r\n    \"company\": \"其他\",\r\n    \"password\": \"d94fb5e42a143614c9191f242401fa50\",\r\n    \"salt\": \"g289eg77g68k\",\r\n    \"givenName\": \"{\\\"unifiedbus\\\":\\\"20250226\\\"}\",\r\n    \"registerSource\": [\r\n      \"basic:username-password\"\r\n    ],\r\n    \"emailVerified\": true,\r\n    \"encryptedPassword\": \"AWuaSe/eStjFNjpohDXM1BzDAQC/0uzQXPAmvs7EFSpXYeyqIsYXGAQPHctixxzMMWaXtoTR9cSQBcVuaQiAoEsKRHPDec5HL1Ec3aMM0SmZWTCDsX8SsCvOq587MpsaocYPHzjdit1D4GGa/9OTIDPlYl/JX23Wz/V5qeByYLY=\",\r\n    \"userSourceType\": \"register\",\r\n    \"userSourceId\": \"68c2252e01f46e19ed55b72f\",\r\n    \"passwordSecurityLevel\": 3,\r\n    \"createdAt\": \"2025-09-19T06:29:22.458Z\",\r\n    \"updatedAt\": \"2025-09-19T06:29:22.458Z\",\r\n    \"id\": \"68ccf842c71d898ba26f7986\",\r\n    \"workStatus\": null,\r\n    \"statusChangedAt\": null,\r\n    \"oauth\": null,\r\n    \"phone\": null,\r\n    \"unionid\": null,\r\n    \"openid\": null,\r\n    \"photo\": \"https://files.authing.co/authing-console/default-user-avatar.png\",\r\n    \"browser\": null,\r\n    \"device\": null,\r\n    \"passwordLastSetAt\": null,\r\n    \"lastIp\": null,\r\n    \"name\": null,\r\n    \"familyName\": null,\r\n    \"middleName\": null,\r\n    \"profile\": null,\r\n    \"preferredUsername\": null,\r\n    \"website\": null,\r\n    \"birthdate\": null,\r\n    \"zoneinfo\": null,\r\n    \"locale\": null,\r\n    \"address\": null,\r\n    \"formatted\": null,\r\n    \"streetAddress\": null,\r\n    \"locality\": null,\r\n    \"region\": null,\r\n    \"postalCode\": null,\r\n    \"city\": null,\r\n    \"province\": null,\r\n    \"country\": null,\r\n    \"secretInfo\": null,\r\n    \"lastLogin\": null,\r\n    \"lastLoginApp\": null,\r\n    \"signedUp\": null,\r\n    \"externalId\": null,\r\n    \"mainDepartmentId\": null,\r\n    \"mainDepartmentCode\": null,\r\n    \"lastMfaTime\": null,\r\n    \"syncExtInfo\": null,\r\n    \"phoneCountryCode\": null,\r\n    \"identityNumber\": null,\r\n    \"mfaTriggerData\": null,\r\n    \"lastLoginRegion\": null,\r\n    \"remoteLoginMfaConfig\": null,\r\n    \"expiredAt\": null,\r\n    \"directManagement\": null,\r\n    \"isRoot\": false,\r\n    \"status\": \"Activated\",\r\n    \"loginsCount\": 0,\r\n    \"gender\": \"U\",\r\n    \"phoneVerified\": false,\r\n    \"isDeleted\": false,\r\n    \"sendSmsCount\": 0,\r\n    \"sendSmsLimitCount\": 1000,\r\n    \"resetPasswordOnFirstLogin\": false,\r\n    \"resetPasswordOnNextLogin\": false,\r\n    \"resetedPassword\": false,\r\n    \"usertype\": \"1\",\r\n    \"_id\": \"68ccf842c71d898ba26f7986\",\r\n    \"registerMethod\": \"basic:username-password\",\r\n    \"registerInClient\": \"68a3179a9544e6059c205d4a\",\r\n    \"lastIP\": null,\r\n    \"identities\": []\r\n  }\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": -1,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1758276059625,\n    \"executeTime\": 13\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import java.time.OffsetDateTime;
var  email = body.data.get("email");
var  user_id = body.data.get("id");
var  username = body.data.get("username");
var  user_login = body.data.get("username");
var  createdAt = OffsetDateTime.parse(body.data.get("createdAt"));
var  updatedAt = OffsetDateTime.parse(body.data.get("updatedAt"));
var  company = body.data.get("company");
var  nickname = body.data.get("nickname");
var  phone = body.data.get("phone");
var  community = "unifiedbus";
var  platform = "unifiedbus";
var  source = "unifiedbus";
var  uuid = "unifiedbus_unifiedbus_"+user_id;
return db.table('fact_unifiedbus_authing_webhook_user').primary('uuid').save(
        {
        uuid: uuid,
        email: email,
        user_id: user_id,
        user_login: user_login,
        username: user_login,
        created_at: createdAt,
        updated_at: updatedAt,
        signed_up: createdAt,
        org: company,
        nickname: nickname,
        phone: phone,
        community: community,
        platform: platform,
        source: source
        },true
    );

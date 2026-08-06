"""compatibility-windows.jmx 自动化测试(自动生成)"""
import time
import login_modules as lm

def test_01_验证登录成功(ctx):
    """验证登录成功"""
    lm.login_伙伴用户登录(ctx)  # 登录模块
    # ----- 4-获取用户信息数据 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/user/getUserInfo', headers={'x-xsrf-token': '${xsrf_token}', 'cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}'})
    assert resp.status_code < 400, f"4-获取用户信息数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')

def test_02_技术测评流程走通_非INTEL(ctx):
    """技术测评流程走通_非INTEL"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 合作伙伴阅读并同意签署 《技术测评协议》 -----
    resp = ctx.request('PUT', 'https://${hostURL}', '/server/certification/user/signTechnicalAgreement', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'})
    assert resp.status_code < 400, f"合作伙伴阅读并同意签署 《技术测评协议》: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 合作伙伴提交技术测评申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "companyName":"安庆庆耀宜居装饰工程有限公司",\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productFunctionDesc":"Desc_test",\r\n    "productName":"gxz_${__RandomString(6,abcdefghijklmn,)}",\r\n    "productType":"硬件/DIMM",\r\n    "productVersion":"version_test",\r\n    "testOrganization":"openEuler社区",\r\n    "usageScenesDesc":"Desc_test"\r\n}')
    assert resp.status_code < 400, f"合作伙伴提交技术测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'software_id', '$.result')
    ctx.assert_contains(resp, '"message":"success"', '合作伙伴提交技术测评申请')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/programReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"pass",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴测试阶段上传测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '1'), ('fileType', 'testReport'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'software.pdf', 'mimetype': 'application/pdf'}])
    assert resp.status_code < 400, f"伙伴测试阶段上传测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴测试阶段上传测试报告')
    # ----- 伙伴测试阶段获取附件 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'testReport')])
    assert resp.status_code < 400, f"伙伴测试阶段获取附件: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/testingPhase', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交测试报告')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色报告初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告初审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色报告初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色报告初审')
    lm.login_SIG组_报告复审角色登录(ctx)  # SIG组-报告复审登录模块
    # ----- SIG组-报告复审角色报告复审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告复审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-报告复审角色报告复审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-报告复审角色报告复审')
    lm.login_旗舰店角色登录(ctx)  # 旗舰店角色登录模块
    # ----- 旗舰店角色证书初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "id":${software_id},\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productName":"gxz001",\r\n    "productVersion":"version_test"\r\n}')
    assert resp.status_code < 400, f"旗舰店角色证书初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '旗舰店角色证书初审')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴证书确认阶段上传签名 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/certificationDetails', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '2'), ('fileType', 'sign'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'sign.png', 'mimetype': 'image/png'}])
    assert resp.status_code < 400, f"伙伴证书确认阶段上传签名: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴证书确认阶段上传签名')
    # ----- 伙伴测试阶段获取签名图片 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'sign')])
    assert resp.status_code < 400, f"伙伴测试阶段获取签名图片: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交签名确认证书 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateConfirmation', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"证书确认通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交签名确认证书: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交签名确认证书')
    lm.login_SIG组_证书签发角色登录(ctx)  # SIG组-证书签发登录模块
    # ----- SIG组-证书签发角色通过证书签发 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateIssuance', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"证书签发通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-证书签发角色通过证书签发: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-证书签发角色通过证书签发')

def test_03_技术测评证书初审时_可修改证书的OS名称和版本_并增加_原始OS名称_和_原始OS版本_字段(ctx):
    """技术测评证书初审时，可修改证书的OS名称和版本，并增加“原始OS名称”和“原始OS版本”字段"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 合作伙伴阅读并同意签署 《技术测评协议》 -----
    resp = ctx.request('PUT', 'https://${hostURL}', '/server/certification/user/signTechnicalAgreement', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'})
    assert resp.status_code < 400, f"合作伙伴阅读并同意签署 《技术测评协议》: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 合作伙伴提交技术测评申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "companyName":"安庆庆耀宜居装饰工程有限公司",\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productFunctionDesc":"Desc_test",\r\n    "productName":"gxz_${__RandomString(6,abcdefghijklmn,)}",\r\n    "productType":"硬件/DIMM",\r\n    "productVersion":"version_test",\r\n    "testOrganization":"openEuler社区",\r\n    "usageScenesDesc":"Desc_test"\r\n}')
    assert resp.status_code < 400, f"合作伙伴提交技术测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'software_id', '$.result')
    ctx.assert_contains(resp, '"message":"success"', '合作伙伴提交技术测评申请')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/programReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"pass",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴测试阶段上传测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '1'), ('fileType', 'testReport'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'software.pdf', 'mimetype': 'application/pdf'}])
    assert resp.status_code < 400, f"伙伴测试阶段上传测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴测试阶段上传测试报告')
    # ----- 伙伴测试阶段获取附件 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'testReport')])
    assert resp.status_code < 400, f"伙伴测试阶段获取附件: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/testingPhase', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交测试报告')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色报告初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告初审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色报告初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色报告初审')
    lm.login_SIG组_报告复审角色登录(ctx)  # SIG组-报告复审登录模块
    # ----- SIG组-报告复审角色报告复审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告复审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-报告复审角色报告复审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-报告复审角色报告复审')
    lm.login_旗舰店角色登录(ctx)  # 旗舰店角色登录模块
    # ----- 旗舰店角色证书初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "id":${software_id},\r\n    "osName":"HopeEdge",\r\n    "osVersion":"1.0",\r\n    "productName":"gxz001",\r\n    "productVersion":"version_test"\r\n}')
    assert resp.status_code < 400, f"旗舰店角色证书初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '旗舰店角色证书初审')
    # ----- 测评申请增加“原始OS名称”和“原始OS版本”字段 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/findById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"测评申请增加“原始OS名称”和“原始OS版本”字段: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '测评申请增加“原始OS名称”和“原始OS版本”字段')
    ctx.assert_json(resp, '$.result.initOsName', 'openEuler', is_regex=True, invert=False, label='测评申请增加“原始OS名称”和“原始OS版本”字段')
    ctx.assert_json(resp, '$.result.initOsVersion', '21.09', is_regex=True, invert=False, label='测评申请增加“原始OS名称”和“原始OS版本”字段')
    ctx.assert_json(resp, '$.result.osName', 'HopeEdge', is_regex=True, invert=False, label='测评申请增加“原始OS名称”和“原始OS版本”字段')
    ctx.assert_json(resp, '$.result.osVersion', '1.0', is_regex=True, invert=False, label='测评申请增加“原始OS名称”和“原始OS版本”字段')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色对已完成的测评数据进行作废操作 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/void', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"伙伴角色对已完成的测评数据进行作废操作: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色对已完成的测评数据进行作废操作')
    # ----- 验证测评申请状态变为“已作废” -----
    time.sleep(1.0)
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/findById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"验证测评申请状态变为“已作废”: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '验证测评申请状态变为“已作废”')
    ctx.assert_json(resp, '$.result.statusName', '已作废', is_regex=True, invert=False, label='验证测评申请状态变为“已作废”')

def test_04_技术测评流程最后阶段撤回最终删除(ctx):
    """技术测评流程最后阶段撤回最终删除"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 合作伙伴阅读并同意签署 《技术测评协议》 -----
    resp = ctx.request('PUT', 'https://${hostURL}', '/server/certification/user/signTechnicalAgreement', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'})
    assert resp.status_code < 400, f"合作伙伴阅读并同意签署 《技术测评协议》: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 合作伙伴提交技术测评申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "companyName":"安庆庆耀宜居装饰工程有限公司",\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productFunctionDesc":"Desc_test",\r\n    "productName":"gxz_${__RandomString(6,abcdefghijklmn,)}",\r\n    "productType":"硬件/DIMM",\r\n    "productVersion":"version_test",\r\n    "testOrganization":"openEuler社区",\r\n    "usageScenesDesc":"Desc_test"\r\n}')
    assert resp.status_code < 400, f"合作伙伴提交技术测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'software_id', '$.result')
    ctx.assert_contains(resp, '"message":"success"', '合作伙伴提交技术测评申请')
    # ----- 伙伴获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/softwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"",\r\n    "selectMyApplication":[],\r\n    "statusId":[2],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"伙伴获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '伙伴获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'softwareName', '$.result.list[?(@.id==${software_id})].productName')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/programReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"pass",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴测试阶段上传测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '1'), ('fileType', 'testReport'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'software.pdf', 'mimetype': 'application/pdf'}])
    assert resp.status_code < 400, f"伙伴测试阶段上传测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴测试阶段上传测试报告')
    # ----- 伙伴测试阶段获取附件 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'testReport')])
    assert resp.status_code < 400, f"伙伴测试阶段获取附件: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/testingPhase', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交测试报告')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色报告初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告初审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色报告初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色报告初审')
    lm.login_SIG组_报告复审角色登录(ctx)  # SIG组-报告复审登录模块
    # ----- SIG组-报告复审角色报告复审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告复审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-报告复审角色报告复审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-报告复审角色报告复审')
    lm.login_旗舰店角色登录(ctx)  # 旗舰店角色登录模块
    # ----- 旗舰店角色证书初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "id":${software_id},\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productName":"${softwareName}",\r\n    "productVersion":"version_test"\r\n}')
    assert resp.status_code < 400, f"旗舰店角色证书初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '旗舰店角色证书初审')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴证书确认阶段上传签名 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/certificationDetails', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '2'), ('fileType', 'sign'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'sign.png', 'mimetype': 'image/png'}])
    assert resp.status_code < 400, f"伙伴证书确认阶段上传签名: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴证书确认阶段上传签名')
    # ----- 伙伴测试阶段获取签名图片 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'sign')])
    assert resp.status_code < 400, f"伙伴测试阶段获取签名图片: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交签名确认证书 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateConfirmation', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"证书确认通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交签名确认证书: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交签名确认证书')
    # ----- 证书确认撤回申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/withdraw-software', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":4,\r\n    "softwareId":${software_id},\r\n    "transferredComments":"撤回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"证书确认撤回申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '证书确认撤回申请')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/softwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"${softwareName}",\r\n    "selectMyApplication":[],\r\n    "statusId":[],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"伙伴获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '伙伴获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_json(resp, '$.result.list[0].status', '7', is_regex=True, invert=False, label='伙伴获取测评列表')
    lm.login_旗舰店角色登录(ctx)  # 旗舰店角色登录模块
    # ----- 证书初审撤回申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/withdraw-software', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":4,\r\n    "softwareId":${software_id},\r\n    "transferredComments":"撤回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"证书初审撤回申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '证书初审撤回申请')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 审核获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reviewSoftwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"${softwareName}",\r\n    "selectMyApplication":[],\r\n    "statusId":[],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"审核获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '审核获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_json(resp, '$.result.list[0].status', '6', is_regex=True, invert=False, label='审核获取测评列表')
    lm.login_SIG组_报告复审角色登录(ctx)  # SIG组-报告复审登录模块
    # ----- 报告复审撤回申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/withdraw-software', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":4,\r\n    "softwareId":${software_id},\r\n    "transferredComments":"撤回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"报告复审撤回申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '报告复审撤回申请')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 审核获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reviewSoftwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"${softwareName}",\r\n    "selectMyApplication":[],\r\n    "statusId":[],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"审核获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '审核获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_json(resp, '$.result.list[0].status', '5', is_regex=True, invert=False, label='审核获取测评列表')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 报告初审撤回申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/withdraw-software', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":4,\r\n    "softwareId":${software_id},\r\n    "transferredComments":"撤回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"报告初审撤回申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '报告初审撤回申请')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 审核获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reviewSoftwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"${softwareName}",\r\n    "selectMyApplication":[],\r\n    "statusId":[],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"审核获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '审核获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_json(resp, '$.result.list[0].status', '4', is_regex=True, invert=False, label='审核获取测评列表')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 测试报告撤回申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/withdraw-software', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":4,\r\n    "softwareId":${software_id},\r\n    "transferredComments":"撤回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"测试报告撤回申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '测试报告撤回申请')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/softwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"${softwareName}",\r\n    "selectMyApplication":[],\r\n    "statusId":[],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"伙伴获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '伙伴获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_json(resp, '$.result.list[0].status', '3', is_regex=True, invert=False, label='伙伴获取测评列表')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 方案审核撤回申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/withdraw-software', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":4,\r\n    "softwareId":${software_id},\r\n    "transferredComments":"撤回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"方案审核撤回申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '方案审核撤回申请')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 审核获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reviewSoftwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"${softwareName}",\r\n    "selectMyApplication":[],\r\n    "statusId":[],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"审核获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '审核获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_json(resp, '$.result.list[0].status', '2', is_regex=True, invert=False, label='审核获取测评列表')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 测评申请撤回申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/withdraw-software', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":4,\r\n    "softwareId":${software_id},\r\n    "transferredComments":"撤回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"测评申请撤回申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '测评申请撤回申请')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 删除测评申请 -----
    resp = ctx.request('DELETE', 'https://${hostURL}', '/server/certification/software/delete-register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"删除测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '删除测评申请')

def test_05_技术测评流程最后阶段驳回最终到证书初审阶段(ctx):
    """技术测评流程最后阶段驳回最终到证书初审阶段"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 合作伙伴阅读并同意签署 《技术测评协议》 -----
    resp = ctx.request('PUT', 'https://${hostURL}', '/server/certification/user/signTechnicalAgreement', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'})
    assert resp.status_code < 400, f"合作伙伴阅读并同意签署 《技术测评协议》: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 合作伙伴提交技术测评申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "companyName":"安庆庆耀宜居装饰工程有限公司",\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productFunctionDesc":"Desc_test",\r\n    "productName":"gxz_${__RandomString(6,abcdefghijklmn,)}",\r\n    "productType":"硬件/DIMM",\r\n    "productVersion":"version_test",\r\n    "testOrganization":"openEuler社区",\r\n    "usageScenesDesc":"Desc_test"\r\n}')
    assert resp.status_code < 400, f"合作伙伴提交技术测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'software_id', '$.result')
    ctx.assert_contains(resp, '"message":"success"', '合作伙伴提交技术测评申请')
    # ----- 伙伴获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/softwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"",\r\n    "selectMyApplication":[],\r\n    "statusId":[2],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"伙伴获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '伙伴获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'softwareName', '$.result.list[?(@.id==${software_id})].productName')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/programReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"pass",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴测试阶段上传测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '1'), ('fileType', 'testReport'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'software.pdf', 'mimetype': 'application/pdf'}])
    assert resp.status_code < 400, f"伙伴测试阶段上传测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴测试阶段上传测试报告')
    # ----- 伙伴测试阶段获取附件 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'testReport')])
    assert resp.status_code < 400, f"伙伴测试阶段获取附件: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/testingPhase', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交测试报告')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色报告初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告初审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色报告初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色报告初审')
    lm.login_SIG组_报告复审角色登录(ctx)  # SIG组-报告复审登录模块
    # ----- SIG组-报告复审角色报告复审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告复审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-报告复审角色报告复审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-报告复审角色报告复审')
    lm.login_旗舰店角色登录(ctx)  # 旗舰店角色登录模块
    # ----- 旗舰店角色证书初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "id":${software_id},\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productName":"${softwareName}",\r\n    "productVersion":"version_test"\r\n}')
    assert resp.status_code < 400, f"旗舰店角色证书初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '旗舰店角色证书初审')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴证书确认阶段上传签名 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/certificationDetails', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '2'), ('fileType', 'sign'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'sign.png', 'mimetype': 'image/png'}])
    assert resp.status_code < 400, f"伙伴证书确认阶段上传签名: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴证书确认阶段上传签名')
    # ----- 伙伴测试阶段获取签名图片 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'sign')])
    assert resp.status_code < 400, f"伙伴测试阶段获取签名图片: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交签名确认证书 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateConfirmation', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"证书确认通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交签名确认证书: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交签名确认证书')
    lm.login_SIG组_证书签发角色登录(ctx)  # SIG组-证书签发登录模块
    # ----- SIG组-证书签发角色证书签发驳回 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateIssuance', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":2,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"证书签发驳回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-证书签发角色证书签发驳回: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-证书签发角色证书签发驳回')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色证书确认驳回 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateConfirmation', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":2,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"证书确认驳回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色证书确认驳回: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色证书确认驳回')
    # ----- 伙伴获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/softwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"${softwareName}",\r\n    "selectMyApplication":[],\r\n    "statusId":[],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"伙伴获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '伙伴获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_json(resp, '$.result.list[0].status', '6', is_regex=True, invert=False, label='伙伴获取测评列表')

def test_06_技术测评流程_测试阶段可以驳回_最终到测评申请删除(ctx):
    """技术测评流程，测试阶段可以驳回，最终到测评申请删除"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 合作伙伴阅读并同意签署 《技术测评协议》 -----
    resp = ctx.request('PUT', 'https://${hostURL}', '/server/certification/user/signTechnicalAgreement', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'})
    assert resp.status_code < 400, f"合作伙伴阅读并同意签署 《技术测评协议》: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 合作伙伴提交技术测评申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "companyName":"安庆庆耀宜居装饰工程有限公司",\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productFunctionDesc":"Desc_test",\r\n    "productName":"gxz_${__RandomString(6,abcdefghijklmn,)}",\r\n    "productType":"硬件/DIMM",\r\n    "productVersion":"version_test",\r\n    "testOrganization":"openEuler社区",\r\n    "usageScenesDesc":"Desc_test"\r\n}')
    assert resp.status_code < 400, f"合作伙伴提交技术测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'software_id', '$.result')
    ctx.assert_contains(resp, '"message":"success"', '合作伙伴提交技术测评申请')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/programReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"pass",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴测试阶段上传测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '1'), ('fileType', 'testReport'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'software.pdf', 'mimetype': 'application/pdf'}])
    assert resp.status_code < 400, f"伙伴测试阶段上传测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴测试阶段上传测试报告')
    # ----- 伙伴测试阶段获取附件 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'testReport')])
    assert resp.status_code < 400, f"伙伴测试阶段获取附件: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/testingPhase', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交测试报告')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色报告初审驳回 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":2,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告初审驳回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色报告初审驳回: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色报告初审驳回')
    # ----- 方案审核撤回申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/withdraw-software', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":4,\r\n    "softwareId":${software_id},\r\n    "transferredComments":"撤回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"方案审核撤回申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '方案审核撤回申请')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 测评申请撤回申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/withdraw-software', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":4,\r\n    "softwareId":${software_id},\r\n    "transferredComments":"撤回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"测评申请撤回申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '测评申请撤回申请')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 删除测评申请 -----
    resp = ctx.request('DELETE', 'https://${hostURL}', '/server/certification/software/delete-register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"删除测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '删除测评申请')

def test_07_技术测评流程_报告初审阶段转审_转审通过后_报告复审驳回_报告初审负责人是转审后人员(ctx):
    """技术测评流程，报告初审阶段转审，转审通过后，报告复审驳回，报告初审负责人是转审后人员"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 合作伙伴阅读并同意签署 《技术测评协议》 -----
    resp = ctx.request('PUT', 'https://${hostURL}', '/server/certification/user/signTechnicalAgreement', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'})
    assert resp.status_code < 400, f"合作伙伴阅读并同意签署 《技术测评协议》: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 合作伙伴提交技术测评申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "companyName":"安庆庆耀宜居装饰工程有限公司",\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productFunctionDesc":"Desc_test",\r\n    "productName":"gxz_${__RandomString(6,abcdefghijklmn,)}",\r\n    "productType":"硬件/DIMM",\r\n    "productVersion":"version_test",\r\n    "testOrganization":"openEuler社区",\r\n    "usageScenesDesc":"Desc_test"\r\n}')
    assert resp.status_code < 400, f"合作伙伴提交技术测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'software_id', '$.result')
    ctx.assert_contains(resp, '"message":"success"', '合作伙伴提交技术测评申请')
    # ----- 伙伴获取测评列表 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/softwareList?curPage=1&pageSize=10', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "productName":"",\r\n    "selectMyApplication":[],\r\n    "statusId":[2],\r\n    "testOrgId":[]\r\n}')
    assert resp.status_code < 400, f"伙伴获取测评列表: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.assert_contains(resp, '"message":"success"', '伙伴获取测评列表')
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'softwareName', '$.result.list[?(@.id==${software_id})].productName')
    lm.login_创新中心用户B登录(ctx)  # 创新中心B登录模块
    # ----- 获取用户信息数据(uuid) -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/user/getUserInfo', headers={'x-xsrf-token': '${xsrf_token}', 'cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}'})
    assert resp.status_code < 400, f"获取用户信息数据(uuid): HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'uuid', '$.result.uuid')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核通过 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/programReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"pass",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核通过: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核通过')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴测试阶段上传测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '1'), ('fileType', 'testReport'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'software.pdf', 'mimetype': 'application/pdf'}])
    assert resp.status_code < 400, f"伙伴测试阶段上传测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴测试阶段上传测试报告')
    # ----- 伙伴测试阶段获取附件 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'testReport')])
    assert resp.status_code < 400, f"伙伴测试阶段获取附件: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/testingPhase', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交测试报告')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核转给角色B处理 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":3,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"转审",\r\n    "transferredUser":"${uuid}"\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核转给角色B处理: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核转给角色B处理')
    lm.login_创新中心用户B登录(ctx)  # 创新中心B登录模块
    # ----- 创新中心角色B报告初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告初审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色B报告初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色B报告初审')
    lm.login_SIG组_报告复审角色登录(ctx)  # SIG组-报告复审登录模块
    # ----- SIG组-报告复审角色登录并驳回报告复审，检查报告初审的负责人是B -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":2,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告复审驳回",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-报告复审角色登录并驳回报告复审，检查报告初审的负责人是B: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-报告复审角色登录并驳回报告复审，检查报告初审的负责人是B')
    # ----- 检查报告初审的负责人是B -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/node', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('softwareId', '${software_id}')])
    assert resp.status_code < 400, f"检查报告初审的负责人是B: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '检查报告初审的负责人是B')
    ctx.assert_json(resp, '$.result[?(@.nodeName== "报告初审")].handlerName', '["rosecoffee"]', is_regex=False, invert=False, label='检查报告初审的负责人是B')

def test_08_技术测评流程_伙伴用户可在已完成后对技术测评进行作废处理(ctx):
    """技术测评流程，伙伴用户可在已完成后对技术测评进行作废处理"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 合作伙伴阅读并同意签署 《技术测评协议》 -----
    resp = ctx.request('PUT', 'https://${hostURL}', '/server/certification/user/signTechnicalAgreement', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'})
    assert resp.status_code < 400, f"合作伙伴阅读并同意签署 《技术测评协议》: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 合作伙伴提交技术测评申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "companyName":"安庆庆耀宜居装饰工程有限公司",\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productFunctionDesc":"Desc_test",\r\n    "productName":"gxz_${__RandomString(6,abcdefghijklmn,)}",\r\n    "productType":"硬件/DIMM",\r\n    "productVersion":"version_test",\r\n    "testOrganization":"openEuler社区",\r\n    "usageScenesDesc":"Desc_test"\r\n}')
    assert resp.status_code < 400, f"合作伙伴提交技术测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'software_id', '$.result')
    ctx.assert_contains(resp, '"message":"success"', '合作伙伴提交技术测评申请')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/programReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"pass",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴测试阶段上传测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '1'), ('fileType', 'testReport'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'software.pdf', 'mimetype': 'application/pdf'}])
    assert resp.status_code < 400, f"伙伴测试阶段上传测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴测试阶段上传测试报告')
    # ----- 伙伴测试阶段获取附件 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'testReport')])
    assert resp.status_code < 400, f"伙伴测试阶段获取附件: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/testingPhase', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交测试报告')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色报告初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告初审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色报告初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色报告初审')
    lm.login_SIG组_报告复审角色登录(ctx)  # SIG组-报告复审登录模块
    # ----- SIG组-报告复审角色报告复审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告复审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-报告复审角色报告复审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-报告复审角色报告复审')
    lm.login_旗舰店角色登录(ctx)  # 旗舰店角色登录模块
    # ----- 旗舰店角色证书初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "id":${software_id},\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productName":"gxz001",\r\n    "productVersion":"version_test"\r\n}')
    assert resp.status_code < 400, f"旗舰店角色证书初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '旗舰店角色证书初审')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴证书确认阶段上传签名 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/certificationDetails', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '2'), ('fileType', 'sign'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'sign.png', 'mimetype': 'image/png'}])
    assert resp.status_code < 400, f"伙伴证书确认阶段上传签名: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴证书确认阶段上传签名')
    # ----- 伙伴测试阶段获取签名图片 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'sign')])
    assert resp.status_code < 400, f"伙伴测试阶段获取签名图片: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交签名确认证书 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateConfirmation', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"证书确认通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交签名确认证书: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交签名确认证书')
    lm.login_SIG组_证书签发角色登录(ctx)  # SIG组-证书签发登录模块
    # ----- SIG组-证书签发角色通过证书签发 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateIssuance', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"证书签发通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-证书签发角色通过证书签发: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-证书签发角色通过证书签发')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色对已完成的测评数据进行作废操作 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/void', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"伙伴角色对已完成的测评数据进行作废操作: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色对已完成的测评数据进行作废操作')
    # ----- 验证测评申请状态变为“已作废” -----
    time.sleep(1.0)
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/findById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"验证测评申请状态变为“已作废”: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '验证测评申请状态变为“已作废”')
    ctx.assert_json(resp, '$.result.statusName', '已作废', is_regex=True, invert=False, label='验证测评申请状态变为“已作废”')

def test_09_技术测评流程_伙伴用户可在证书确认阶段对技术测评进行作废处理(ctx):
    """技术测评流程，伙伴用户可在证书确认阶段对技术测评进行作废处理"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 合作伙伴阅读并同意签署 《技术测评协议》 -----
    resp = ctx.request('PUT', 'https://${hostURL}', '/server/certification/user/signTechnicalAgreement', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'})
    assert resp.status_code < 400, f"合作伙伴阅读并同意签署 《技术测评协议》: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 合作伙伴提交技术测评申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "companyName":"安庆庆耀宜居装饰工程有限公司",\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productFunctionDesc":"Desc_test",\r\n    "productName":"gxz_${__RandomString(6,abcdefghijklmn,)}",\r\n    "productType":"硬件/DIMM",\r\n    "productVersion":"version_test",\r\n    "testOrganization":"openEuler社区",\r\n    "usageScenesDesc":"Desc_test"\r\n}')
    assert resp.status_code < 400, f"合作伙伴提交技术测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'software_id', '$.result')
    ctx.assert_contains(resp, '"message":"success"', '合作伙伴提交技术测评申请')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/programReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"pass",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴测试阶段上传测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/upload', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileTypeCode', '1'), ('fileType', 'testReport'), ('file', '${file}')], files=[{'param': 'file', 'filename': 'software.pdf', 'mimetype': 'application/pdf'}])
    assert resp.status_code < 400, f"伙伴测试阶段上传测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴测试阶段上传测试报告')
    # ----- 伙伴测试阶段获取附件 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/getAttachments', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('softwareId', '${software_id}'), ('fileType', 'testReport')])
    assert resp.status_code < 400, f"伙伴测试阶段获取附件: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 伙伴角色提交测试报告 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/testingPhase', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交测试报告: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交测试报告')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色报告初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告初审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色报告初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色报告初审')
    lm.login_SIG组_报告复审角色登录(ctx)  # SIG组-报告复审登录模块
    # ----- SIG组-报告复审角色报告复审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/reportReReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"报告复审通过",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"SIG组-报告复审角色报告复审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', 'SIG组-报告复审角色报告复审')
    lm.login_旗舰店角色登录(ctx)  # 旗舰店角色登录模块
    # ----- 旗舰店角色证书初审 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/certificateReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "id":${software_id},\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productName":"gxz001",\r\n    "productVersion":"version_test"\r\n}')
    assert resp.status_code < 400, f"旗舰店角色证书初审: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '旗舰店角色证书初审')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色对已完成的测评数据进行作废操作 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/void', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"伙伴角色对已完成的测评数据进行作废操作: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色对已完成的测评数据进行作废操作')
    # ----- 验证测评申请状态变为“已作废” -----
    time.sleep(1.0)
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/findById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"验证测评申请状态变为“已作废”: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '验证测评申请状态变为“已作废”')
    ctx.assert_json(resp, '$.result.statusName', '已作废', is_regex=True, invert=False, label='验证测评申请状态变为“已作废”')

def test_10_技术测评流程_伙伴用户可在测试阶段对技术测评进行作废处理(ctx):
    """技术测评流程，伙伴用户可在测试阶段对技术测评进行作废处理"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 合作伙伴阅读并同意签署 《技术测评协议》 -----
    resp = ctx.request('PUT', 'https://${hostURL}', '/server/certification/user/signTechnicalAgreement', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'})
    assert resp.status_code < 400, f"合作伙伴阅读并同意签署 《技术测评协议》: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    # ----- 合作伙伴提交技术测评申请 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/register', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "companyName":"安庆庆耀宜居装饰工程有限公司",\r\n    "hashratePlatformList":[{"platformName":"兆芯","serverProvider":"清华同方","serverTypes":["超强Z520-M1"]}],\r\n    "osName":"openEuler",\r\n    "osVersion":"21.09",\r\n    "productFunctionDesc":"Desc_test",\r\n    "productName":"gxz_${__RandomString(6,abcdefghijklmn,)}",\r\n    "productType":"硬件/DIMM",\r\n    "productVersion":"version_test",\r\n    "testOrganization":"openEuler社区",\r\n    "usageScenesDesc":"Desc_test"\r\n}')
    assert resp.status_code < 400, f"合作伙伴提交技术测评申请: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'software_id', '$.result')
    ctx.assert_contains(resp, '"message":"success"', '合作伙伴提交技术测评申请')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/software/programReview', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "handlerResult":1,\r\n    "softwareId":"${software_id}",\r\n    "transferredComments":"pass",\r\n    "transferredUser":""\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色对已完成的测评数据进行作废操作 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/void', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"伙伴角色对已完成的测评数据进行作废操作: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色对已完成的测评数据进行作废操作')
    # ----- 验证测评申请状态变为“已作废” -----
    time.sleep(1.0)
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/software/findById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, args=[('id', '${software_id}')])
    assert resp.status_code < 400, f"验证测评申请状态变为“已作废”: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '验证测评申请状态变为“已作废”')
    ctx.assert_json(resp, '$.result.statusName', '已作废', is_regex=True, invert=False, label='验证测评申请状态变为“已作废”')

def test_11_新增板卡数据正项流程_审核通过(ctx):
    """新增板卡数据正项流程，审核通过"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色保存板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchInsert', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='[\r\n    {\r\n        "boardModel":"gxz_boardcard_${__RandomString(6,abcdefghijklmn,)}",\r\n        "vendorID":"NA","deviceID":"NA","svID":"NA","ssID":"NA",\r\n        "architecture":"archi",\r\n        "os":"os",\r\n        "driverName":"driverName",\r\n        "version":"version",\r\n        "type":"type",\r\n        "date":"2024-12-04",\r\n        "sha256":"sha256",\r\n        "driverSize":"driverSize",\r\n        "chipVendor":"chipVendor",\r\n        "chipModel":"chipModel",\r\n        "item":"item",\r\n        "downloadLink":"downloadLink",\r\n        "securityLevel":"1",\r\n        "id":0\r\n    }\r\n]')
    assert resp.status_code < 400, f"伙伴角色保存板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'boardcard_id', '$.result.results[0].unique')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色保存板卡数据')
    # ----- 获取板卡详情 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡详情: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡详情')
    # ----- 伙伴角色提交板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchApproval', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareIdList":["${boardcard_id}"],\r\n    "handlerComment":"提交",\r\n    "handlerResult":"1",\r\n    "handlerNode":"1"\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交板卡数据')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/pass', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareId":"${boardcard_id}",\r\n    "handlerResult":1,\r\n    "handlerComment":"boardcard pass"\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核')
    # ----- 获取板卡详情 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡详情: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡详情')
    ctx.assert_json(resp, '$.result.status', '3', is_regex=True, invert=False, label='获取板卡详情')

def test_12_新增板卡数据正项流程_审核驳回后重新申请_二次审核通过(ctx):
    """新增板卡数据正项流程，审核驳回后重新申请，二次审核通过"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色保存板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchInsert', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='[\r\n    {\r\n        "boardModel":"gxz_boardcard_${__RandomString(6,abcdefghijklmn,)}",\r\n        "vendorID":"NA","deviceID":"NA","svID":"NA","ssID":"NA",\r\n        "architecture":"archi",\r\n        "os":"os",\r\n        "driverName":"driverName",\r\n        "version":"version",\r\n        "type":"type",\r\n        "date":"2024-12-04",\r\n        "sha256":"sha256",\r\n        "driverSize":"driverSize",\r\n        "chipVendor":"chipVendor",\r\n        "chipModel":"chipModel",\r\n        "item":"item",\r\n        "downloadLink":"downloadLink",\r\n        "securityLevel":"1",\r\n        "id":0\r\n    }\r\n]')
    assert resp.status_code < 400, f"伙伴角色保存板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'boardcard_id', '$.result.results[0].unique')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色保存板卡数据')
    # ----- 获取板卡详情 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡详情: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡详情')
    # ----- 伙伴角色提交板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchApproval', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareIdList":["${boardcard_id}"],\r\n    "handlerComment":"提交",\r\n    "handlerResult":"1",\r\n    "handlerNode":"1"\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交板卡数据')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核不通过 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/reject', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareId":"${boardcard_id}",\r\n    "handlerResult":2,\r\n    "handlerComment":"boardcard reject"\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核不通过: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核不通过')
    # ----- 获取板卡详情 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡详情: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡详情')
    ctx.assert_json(resp, '$.result.status', '-3', is_regex=True, invert=False, label='获取板卡详情')
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色提交板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchApproval', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareIdList":["${boardcard_id}"],\r\n    "handlerComment":"提交",\r\n    "handlerResult":"1",\r\n    "handlerNode":"1"\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交板卡数据')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核通过 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/pass', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareId":"${boardcard_id}",\r\n    "handlerResult":1,\r\n    "handlerComment":"boardcard pass"\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核通过: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核通过')
    # ----- 获取板卡详情 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡详情: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡详情')
    ctx.assert_json(resp, '$.result.status', '3', is_regex=True, invert=False, label='获取板卡详情')

def test_13_新增板卡数据_审核驳回后关闭该数据(ctx):
    """新增板卡数据，审核驳回后关闭该数据"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色保存板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchInsert', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='[\r\n    {\r\n        "boardModel":"gxz_boardcard_${__RandomString(6,abcdefghijklmn,)}",\r\n        "vendorID":"NA","deviceID":"NA","svID":"NA","ssID":"NA",\r\n        "architecture":"archi",\r\n        "os":"os",\r\n        "driverName":"driverName",\r\n        "version":"version",\r\n        "type":"type",\r\n        "date":"2024-12-04",\r\n        "sha256":"sha256",\r\n        "driverSize":"driverSize",\r\n        "chipVendor":"chipVendor",\r\n        "chipModel":"chipModel",\r\n        "item":"item",\r\n        "downloadLink":"downloadLink",\r\n        "securityLevel":"1",\r\n        "id":0\r\n    }\r\n]')
    assert resp.status_code < 400, f"伙伴角色保存板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'boardcard_id', '$.result.results[0].unique')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色保存板卡数据')
    # ----- 获取板卡详情 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡详情: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡详情')
    # ----- 伙伴角色提交板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchApproval', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareIdList":["${boardcard_id}"],\r\n    "handlerComment":"提交",\r\n    "handlerResult":"1",\r\n    "handlerNode":"1"\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交板卡数据')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 创新中心角色方案审核不通过 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/reject', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareId":"${boardcard_id}",\r\n    "handlerResult":2,\r\n    "handlerComment":"boardcard reject"\r\n}')
    assert resp.status_code < 400, f"创新中心角色方案审核不通过: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '创新中心角色方案审核不通过')
    # ----- 审核角色关闭板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/close', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareId":"${boardcard_id}",\r\n    "handlerComment":"关闭"\r\n}')
    assert resp.status_code < 400, f"审核角色关闭板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '审核角色关闭板卡数据')
    # ----- 获取板卡数据列表验证板卡状态为“已关闭” -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡数据列表验证板卡状态为“已关闭”: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡数据列表验证板卡状态为“已关闭”')
    ctx.assert_json(resp, '$.result.status', '-2', is_regex=True, invert=False, label='获取板卡数据列表验证板卡状态为“已关闭”')

def test_14_新增板卡数据_提交后审核直接关闭(ctx):
    """新增板卡数据，提交后审核直接关闭"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色保存板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchInsert', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='[\r\n    {\r\n        "boardModel":"gxz_boardcard_${__RandomString(6,abcdefghijklmn,)}",\r\n        "vendorID":"NA","deviceID":"NA","svID":"NA","ssID":"NA",\r\n        "architecture":"archi",\r\n        "os":"os",\r\n        "driverName":"driverName",\r\n        "version":"version",\r\n        "type":"type",\r\n        "date":"2024-12-04",\r\n        "sha256":"sha256",\r\n        "driverSize":"driverSize",\r\n        "chipVendor":"chipVendor",\r\n        "chipModel":"chipModel",\r\n        "item":"item",\r\n        "downloadLink":"downloadLink",\r\n        "securityLevel":"1",\r\n        "id":0\r\n    }\r\n]')
    assert resp.status_code < 400, f"伙伴角色保存板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'boardcard_id', '$.result.results[0].unique')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色保存板卡数据')
    # ----- 获取板卡详情 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡详情: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡详情')
    # ----- 伙伴角色提交板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchApproval', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareIdList":["${boardcard_id}"],\r\n    "handlerComment":"提交",\r\n    "handlerResult":"1",\r\n    "handlerNode":"1"\r\n}')
    assert resp.status_code < 400, f"伙伴角色提交板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色提交板卡数据')
    lm.login_创新中心用户登录(ctx)  # 创新中心登录模块
    # ----- 审核角色关闭板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/close', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareId":"${boardcard_id}",\r\n    "handlerComment":"关闭"\r\n}')
    assert resp.status_code < 400, f"审核角色关闭板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '审核角色关闭板卡数据')
    # ----- 获取板卡数据列表验证板卡状态为“已关闭” -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡数据列表验证板卡状态为“已关闭”: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡数据列表验证板卡状态为“已关闭”')
    ctx.assert_json(resp, '$.result.status', '-2', is_regex=True, invert=False, label='获取板卡数据列表验证板卡状态为“已关闭”')

def test_15_新增板卡数据_保存后不提交直接删除(ctx):
    """新增板卡数据，保存后不提交直接删除"""
    lm.login_伙伴用户登录(ctx)  # 伙伴登录模块
    # ----- 伙伴角色保存板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/batchInsert', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='[\r\n    {\r\n        "boardModel":"gxz_boardcard_${__RandomString(6,abcdefghijklmn,)}",\r\n        "vendorID":"NA","deviceID":"NA","svID":"NA","ssID":"NA",\r\n        "architecture":"archi",\r\n        "os":"os",\r\n        "driverName":"driverName",\r\n        "version":"version",\r\n        "type":"type",\r\n        "date":"2024-12-04",\r\n        "sha256":"sha256",\r\n        "driverSize":"driverSize",\r\n        "chipVendor":"chipVendor",\r\n        "chipModel":"chipModel",\r\n        "item":"item",\r\n        "downloadLink":"downloadLink",\r\n        "securityLevel":"1",\r\n        "id":0\r\n    }\r\n]')
    assert resp.status_code < 400, f"伙伴角色保存板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.jextract(resp, 'boardcard_id', '$.result.results[0].unique')
    ctx.assert_contains(resp, '"message":"success"', '伙伴角色保存板卡数据')
    # ----- 获取板卡详情 -----
    resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/hardwareBoardCard/getById', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/', 'origin': 'https://openeuler-compatibility.test.osinfra.cn'}, args=[('id', '${boardcard_id}')])
    assert resp.status_code < 400, f"获取板卡详情: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '获取板卡详情')
    # ----- 删除待提交的板卡数据 -----
    resp = ctx.request('POST', 'https://${hostURL}', '/server/certification/hardwareBoardCard/delete', headers={'x-xsrf-token': '${xsrf_token}', 'referer': 'https://openeuler-compatibility.test.osinfra.cn/technicalCertification', 'origin': 'https://openeuler-compatibility.test.osinfra.cn', 'content-type': 'application/json;charset=UTF-8'}, body='{\r\n    "hardwareId":${boardcard_id},\r\n    "handlerComment":"删除"\r\n}')
    assert resp.status_code < 400, f"删除待提交的板卡数据: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    ctx.assert_contains(resp, '"message":"success"', '删除待提交的板卡数据')


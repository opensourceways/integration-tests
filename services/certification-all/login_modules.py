"""登录模块(由 TestFragmentController 自动生成)"""
import time

def login_伙伴用户登录(ctx):
    """伙伴用户登录"""
    # ----- 1-login -----
    resp = ctx.request('POST', 'https://${userURL}', '/oneid/login', headers={'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Content-Type': 'application/json;charset=UTF-8', 'Cookie': 'HWWAFSESTIME=1732152513844; HWWAFSESID=b809d76a0901869928', 'Origin': 'https://openeuler-usercenter.test.osinfra.cn', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=${state}', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'sec-ch-ua': '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'}, body='{\r\n  "permission": "sigRead",\r\n  "account": "${mate_account}",\r\n  "client_id": "623c3c2f1eca5ad5fca6c58a",\r\n  "password": "${mate_password}",\r\n  "need_captcha_verification":false,\r\n  "accept_term": 0,\r\n  "oneidPrivacyAccepted": "20250226"\r\n}')
    assert resp.status_code < 400, f"1-login: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
    ctx.jextract(resp, 'Privacy_version', '$.data.oneidPrivacyAccepted')
    # ----- version -----
    resp = ctx.request('GET', 'https://${userURL}', '/oneid/privacy/version', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'})
    assert resp.status_code < 400, f"version: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.jextract(resp, 'actual_version', '$.data.oneidPrivacyAccepted')
    if str(ctx.v('Privacy_version')) != str(ctx.v('actual_version')):  # IF 控制器_隐私政策有变
        # ----- baseInfo -----
        resp = ctx.request('POST', 'https://${userURL}', '/oneid/update/baseInfo', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"', 'Content-Type': 'application/json;charset=UTF-8'}, body='{"oneidPrivacyAccepted":"${actual_version}"}')
        assert resp.status_code < 400, f"baseInfo: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- permission -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/user/permission', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}', 'Referer': 'https://${userURL}/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=${state}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'})
        assert resp.status_code < 400, f"permission: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策有变 条件不成立')
    if str(ctx.v('Privacy_version')) == str(ctx.v('actual_version')):  # IF 控制器_隐私政策未变
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策未变 条件不成立')

def login_创新中心用户登录(ctx):
    """创新中心用户登录"""
    # ----- 1-login -----
    resp = ctx.request('POST', 'https://${userURL}', '/oneid/login', headers={'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Content-Type': 'application/json;charset=UTF-8', 'Cookie': 'HWWAFSESTIME=1732152513844; HWWAFSESID=b809d76a0901869928', 'Origin': 'https://openeuler-usercenter.test.osinfra.cn', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=7784cd4dbf284b85916c00618c18c48b', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'sec-ch-ua': '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'}, body='{\r\n  "permission": "sigRead",\r\n  "account": "${ic_account}",\r\n  "client_id": "623c3c2f1eca5ad5fca6c58a",\r\n  "password": "${ic_password}",\r\n  "need_captcha_verification":false,\r\n  "accept_term": 0,\r\n  "oneidPrivacyAccepted": "20250226"\r\n}')
    assert resp.status_code < 400, f"1-login: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
    ctx.jextract(resp, 'Privacy_version', '$.data.oneidPrivacyAccepted')
    # ----- version -----
    resp = ctx.request('GET', 'https://${userURL}', '/oneid/privacy/version', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'})
    assert resp.status_code < 400, f"version: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.jextract(resp, 'actual_version', '$.data.oneidPrivacyAccepted')
    if str(ctx.v('Privacy_version')) != str(ctx.v('actual_version')):  # IF 控制器_隐私政策有变
        # ----- baseInfo -----
        resp = ctx.request('POST', 'https://${userURL}', '/oneid/update/baseInfo', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"', 'Content-Type': 'application/json;charset=UTF-8'}, body='{"oneidPrivacyAccepted":"${actual_version}"}')
        assert resp.status_code < 400, f"baseInfo: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- permission -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/user/permission', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}', 'Referer': 'https://${userURL}/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=${state}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'})
        assert resp.status_code < 400, f"permission: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策有变 条件不成立')
    if str(ctx.v('Privacy_version')) == str(ctx.v('actual_version')):  # IF 控制器_隐私政策未变
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策未变 条件不成立')

def login_SIG组_报告复审角色登录(ctx):
    """SIG组-报告复审角色登录"""
    # ----- 1-login -----
    resp = ctx.request('POST', 'https://${userURL}', '/oneid/login', headers={'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Content-Type': 'application/json;charset=UTF-8', 'Cookie': 'HWWAFSESTIME=1732152513844; HWWAFSESID=b809d76a0901869928', 'Origin': 'https://openeuler-usercenter.test.osinfra.cn', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=7784cd4dbf284b85916c00618c18c48b', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'sec-ch-ua': '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'}, body='{\r\n  "permission": "sigRead",\r\n  "account": "${report_review_account}",\r\n  "client_id": "623c3c2f1eca5ad5fca6c58a",\r\n  "password": "${report_review_password}",\r\n  "need_captcha_verification":false,\r\n  "accept_term": 0,\r\n  "oneidPrivacyAccepted": "20250226"\r\n}')
    assert resp.status_code < 400, f"1-login: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
    ctx.jextract(resp, 'Privacy_version', '$.data.oneidPrivacyAccepted')
    # ----- version -----
    resp = ctx.request('GET', 'https://${userURL}', '/oneid/privacy/version', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'})
    assert resp.status_code < 400, f"version: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.jextract(resp, 'actual_version', '$.data.oneidPrivacyAccepted')
    if str(ctx.v('Privacy_version')) != str(ctx.v('actual_version')):  # IF 控制器_隐私政策有变
        # ----- baseInfo -----
        resp = ctx.request('POST', 'https://${userURL}', '/oneid/update/baseInfo', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"', 'Content-Type': 'application/json;charset=UTF-8'}, body='{"oneidPrivacyAccepted":"${actual_version}"}')
        assert resp.status_code < 400, f"baseInfo: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- permission -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/user/permission', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}', 'Referer': 'https://${userURL}/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=${state}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'})
        assert resp.status_code < 400, f"permission: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策有变 条件不成立')
    if str(ctx.v('Privacy_version')) == str(ctx.v('actual_version')):  # IF 控制器_隐私政策未变
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策未变 条件不成立')

def login_旗舰店角色登录(ctx):
    """旗舰店角色登录"""
    # ----- 1-login -----
    resp = ctx.request('POST', 'https://${userURL}', '/oneid/login', headers={'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Content-Type': 'application/json;charset=UTF-8', 'Cookie': 'HWWAFSESTIME=1732152513844; HWWAFSESID=b809d76a0901869928', 'Origin': 'https://openeuler-usercenter.test.osinfra.cn', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=7784cd4dbf284b85916c00618c18c48b', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'sec-ch-ua': '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'}, body='{\r\n  "permission": "sigRead",\r\n  "account": "${flag_store_account}",\r\n  "client_id": "623c3c2f1eca5ad5fca6c58a",\r\n  "password": "${flag_store_password}",\r\n  "need_captcha_verification":false,\r\n  "accept_term": 0,\r\n  "oneidPrivacyAccepted": "20250226"\r\n}')
    assert resp.status_code < 400, f"1-login: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
    ctx.jextract(resp, 'Privacy_version', '$.data.oneidPrivacyAccepted')
    # ----- version -----
    resp = ctx.request('GET', 'https://${userURL}', '/oneid/privacy/version', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'})
    assert resp.status_code < 400, f"version: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.jextract(resp, 'actual_version', '$.data.oneidPrivacyAccepted')
    if str(ctx.v('Privacy_version')) != str(ctx.v('actual_version')):  # IF 控制器_隐私政策有变
        # ----- baseInfo -----
        resp = ctx.request('POST', 'https://${userURL}', '/oneid/update/baseInfo', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"', 'Content-Type': 'application/json;charset=UTF-8'}, body='{"oneidPrivacyAccepted":"${actual_version}"}')
        assert resp.status_code < 400, f"baseInfo: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- permission -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/user/permission', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}', 'Referer': 'https://${userURL}/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=${state}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'})
        assert resp.status_code < 400, f"permission: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策有变 条件不成立')
    if str(ctx.v('Privacy_version')) == str(ctx.v('actual_version')):  # IF 控制器_隐私政策未变
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策未变 条件不成立')

def login_SIG组_证书签发角色登录(ctx):
    """SIG组-证书签发角色登录"""
    # ----- 1-login -----
    resp = ctx.request('POST', 'https://${userURL}', '/oneid/login', headers={'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Content-Type': 'application/json;charset=UTF-8', 'Cookie': 'HWWAFSESTIME=1732152513844; HWWAFSESID=b809d76a0901869928', 'Origin': 'https://openeuler-usercenter.test.osinfra.cn', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=7784cd4dbf284b85916c00618c18c48b', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'sec-ch-ua': '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'}, body='{\r\n  "permission": "sigRead",\r\n  "account": "${certificate_issuance_account}",\r\n  "client_id": "623c3c2f1eca5ad5fca6c58a",\r\n  "password": "${certificate_issuance_password}",\r\n  "need_captcha_verification":false,\r\n  "accept_term": 0,\r\n  "oneidPrivacyAccepted": "20250226"\r\n}')
    assert resp.status_code < 400, f"1-login: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
    ctx.jextract(resp, 'Privacy_version', '$.data.oneidPrivacyAccepted')
    # ----- version -----
    resp = ctx.request('GET', 'https://${userURL}', '/oneid/privacy/version', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'})
    assert resp.status_code < 400, f"version: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.jextract(resp, 'actual_version', '$.data.oneidPrivacyAccepted')
    if str(ctx.v('Privacy_version')) != str(ctx.v('actual_version')):  # IF 控制器_隐私政策有变
        # ----- baseInfo -----
        resp = ctx.request('POST', 'https://${userURL}', '/oneid/update/baseInfo', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"', 'Content-Type': 'application/json;charset=UTF-8'}, body='{"oneidPrivacyAccepted":"${actual_version}"}')
        assert resp.status_code < 400, f"baseInfo: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- permission -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/user/permission', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}', 'Referer': 'https://${userURL}/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=${state}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'})
        assert resp.status_code < 400, f"permission: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策有变 条件不成立')
    if str(ctx.v('Privacy_version')) == str(ctx.v('actual_version')):  # IF 控制器_隐私政策未变
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策未变 条件不成立')

def login_intel创新中心角色登录(ctx):
    """intel创新中心角色登录"""
    # ----- 1-login -----
    resp = ctx.request('POST', 'https://${userURL}', '/oneid/login', headers={'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Content-Type': 'application/json;charset=UTF-8', 'Cookie': 'HWWAFSESTIME=1732152513844; HWWAFSESID=b809d76a0901869928', 'Origin': 'https://openeuler-usercenter.test.osinfra.cn', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=7784cd4dbf284b85916c00618c18c48b', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'sec-ch-ua': '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'}, body='{\r\n  "permission": "sigRead",\r\n  "account": "${intel_ic_account}",\r\n  "client_id": "623c3c2f1eca5ad5fca6c58a",\r\n  "password": "${intel_ic_password}",\r\n  "need_captcha_verification":false,\r\n  "accept_term": 0,\r\n  "oneidPrivacyAccepted": "20250226"\r\n}')
    assert resp.status_code < 400, f"1-login: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
    ctx.jextract(resp, 'Privacy_version', '$.data.oneidPrivacyAccepted')
    # ----- version -----
    resp = ctx.request('GET', 'https://${userURL}', '/oneid/privacy/version', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'})
    assert resp.status_code < 400, f"version: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.jextract(resp, 'actual_version', '$.data.oneidPrivacyAccepted')
    if str(ctx.v('Privacy_version')) != str(ctx.v('actual_version')):  # IF 控制器_隐私政策有变
        # ----- baseInfo -----
        resp = ctx.request('POST', 'https://${userURL}', '/oneid/update/baseInfo', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"', 'Content-Type': 'application/json;charset=UTF-8'}, body='{"oneidPrivacyAccepted":"${actual_version}"}')
        assert resp.status_code < 400, f"baseInfo: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- permission -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/user/permission', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}', 'Referer': 'https://${userURL}/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=${state}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'})
        assert resp.status_code < 400, f"permission: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策有变 条件不成立')
    if str(ctx.v('Privacy_version')) == str(ctx.v('actual_version')):  # IF 控制器_隐私政策未变
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策未变 条件不成立')

def login_intelSIG组_证书签发角色登录(ctx):
    """intelSIG组-证书签发角色登录"""
    # ----- 1-login -----
    resp = ctx.request('POST', 'https://${userURL}', '/oneid/login', headers={'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Content-Type': 'application/json;charset=UTF-8', 'Cookie': 'HWWAFSESTIME=1732152513844; HWWAFSESID=b809d76a0901869928', 'Origin': 'https://openeuler-usercenter.test.osinfra.cn', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=7784cd4dbf284b85916c00618c18c48b', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'sec-ch-ua': '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'}, body='{\r\n  "permission": "sigRead",\r\n  "account": "${intel_certificate_issuance_account}",\r\n  "client_id": "623c3c2f1eca5ad5fca6c58a",\r\n  "password": "${intel_certificate_issuance_password}",\r\n  "need_captcha_verification":false,\r\n  "accept_term": 0,\r\n  "oneidPrivacyAccepted": "20250226"\r\n}')
    assert resp.status_code < 400, f"1-login: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
    ctx.jextract(resp, 'Privacy_version', '$.data.oneidPrivacyAccepted')
    # ----- version -----
    resp = ctx.request('GET', 'https://${userURL}', '/oneid/privacy/version', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'})
    assert resp.status_code < 400, f"version: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.jextract(resp, 'actual_version', '$.data.oneidPrivacyAccepted')
    if str(ctx.v('Privacy_version')) != str(ctx.v('actual_version')):  # IF 控制器_隐私政策有变
        # ----- baseInfo -----
        resp = ctx.request('POST', 'https://${userURL}', '/oneid/update/baseInfo', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"', 'Content-Type': 'application/json;charset=UTF-8'}, body='{"oneidPrivacyAccepted":"${actual_version}"}')
        assert resp.status_code < 400, f"baseInfo: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- permission -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/user/permission', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}', 'Referer': 'https://${userURL}/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=${state}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'})
        assert resp.status_code < 400, f"permission: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策有变 条件不成立')
    if str(ctx.v('Privacy_version')) == str(ctx.v('actual_version')):  # IF 控制器_隐私政策未变
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策未变 条件不成立')

def login_创新中心用户B登录(ctx):
    """创新中心用户B登录"""
    # ----- 1-login -----
    resp = ctx.request('POST', 'https://${userURL}', '/oneid/login', headers={'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Content-Type': 'application/json;charset=UTF-8', 'Cookie': 'HWWAFSESTIME=1732152513844; HWWAFSESID=b809d76a0901869928', 'Origin': 'https://openeuler-usercenter.test.osinfra.cn', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=7784cd4dbf284b85916c00618c18c48b', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'sec-ch-ua': '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'}, body='{\r\n  "permission": "sigRead",\r\n  "account": "${ic_account_2}",\r\n  "client_id": "623c3c2f1eca5ad5fca6c58a",\r\n  "password": "${ic_password_2}",\r\n  "need_captcha_verification":false,\r\n  "accept_term": 0,\r\n  "oneidPrivacyAccepted": "20250226"\r\n}')
    assert resp.status_code < 400, f"1-login: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
    ctx.jextract(resp, 'Privacy_version', '$.data.oneidPrivacyAccepted')
    # ----- version -----
    resp = ctx.request('GET', 'https://${userURL}', '/oneid/privacy/version', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'})
    assert resp.status_code < 400, f"version: HTTP {resp.status_code} {resp.text[:300]}"
    ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
    ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
    ctx.jextract(resp, 'actual_version', '$.data.oneidPrivacyAccepted')
    if str(ctx.v('Privacy_version')) != str(ctx.v('actual_version')):  # IF 控制器_隐私政策有变
        # ----- baseInfo -----
        resp = ctx.request('POST', 'https://${userURL}', '/oneid/update/baseInfo', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Referer': 'https://openeuler-usercenter.test.osinfra.cn/login', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"', 'Content-Type': 'application/json;charset=UTF-8'}, body='{"oneidPrivacyAccepted":"${actual_version}"}')
        assert resp.status_code < 400, f"baseInfo: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- permission -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/user/permission', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}', 'Referer': 'https://${userURL}/login?client_id=623c3c2f1eca5ad5fca6c58a&scope=openid%20profile%20email%20phone%20address%20offline_access&redirect_uri=https%3A%2F%2Fopeneuler-compatibility.test.osinfra.cn%2Fserver%2Fcertification%2Fauth%2Fcallback&response_mode=query&state=${state}', 'Accept': '*/*', 'Accept-Language': 'zh-CN,zh;q=0.9', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin', 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', 'sec-ch-ua': '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"', 'sec-ch-ua-mobile': '?0', 'sec-ch-ua-platform': '"Windows"'})
        assert resp.status_code < 400, f"permission: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'token_value', '"token":"', '","username', use_headers=False, default='')
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${cookie_UT}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策有变 条件不成立')
    if str(ctx.v('Privacy_version')) == str(ctx.v('actual_version')):  # IF 控制器_隐私政策未变
        # ----- 2-auth -----
        resp = ctx.request('GET', 'https://${userURL}', '/oneid/oidc/auth', headers={'Cookie': 'Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'Token': '${token_value}'}, args=[('client_id', '623c3c2f1eca5ad5fca6c58a'), ('response_type', 'code'), ('scope', 'openid+profile+email+phone+address+username+id_token'), ('state', '${state}'), ('redirect_uri', 'https://${hostURL}/auth/callback')])
        assert resp.status_code < 400, f"2-auth: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'cookie_YG', 'Set-Cookie: _Y_G_=', '; Domain=test.osinfra.cn; Path=/; Secure; HttpOnly; SameSite=Lax', use_headers=True, default='cookie_YG NOT FOUND！！！')
        ctx.boundary(resp, 'cookie_UT', 'Set-Cookie: _U_T_=', '; Max-Age', use_headers=True, default='cookie_UT NOT FOUND！！！')
        ctx.boundary(resp, 'code', 'code=', '&state=', use_headers=False, default='code NOT FOUND！！！')
        ctx.boundary(resp, 'state', 'state=', '","status"', use_headers=False, default='state NOT FOUND！！！')
        # ----- 3-callback -----
        resp = ctx.request('GET', 'https://${hostURL}', '/server/certification/auth/callback', headers={'Cookie': '_Y_G_=${cookie_YG};_U_T_=${cookie_UT}', 'referer': 'https://openeuler-usercenter.test.osinfra.cn/', 'user-agent:': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36'}, args=[('code', '${code}'), ('state', '${state}')])
        assert resp.status_code < 400, f"3-callback: HTTP {resp.status_code} {resp.text[:300]}"
        ctx.boundary(resp, 'xsrf_token', 'Set-Cookie: XSRF-TOKEN=', '; Path=/; Secure', use_headers=True, default='xsrf_token NOT FOUND！！！', match='last_nonempty')
    else:
        print('跳过: IF 控制器_隐私政策未变 条件不成立')


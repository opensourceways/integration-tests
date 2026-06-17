"""
Generated from JMeter test plan: discourse.jmx
"""

import pytest
import requests
import time
import random
import string
import json
import os
from urllib.parse import urljoin

# ==================== Global Variables ====================
userURL = "usercenter.openubmc.test.osinfra.cn"
account = os.environ.get("DISCOURSE_TEST_ACCOUNT")
password = os.environ.get("DISCOURSE_TEST_PASSWORD")
hostURL = "openubmc-discussion.test.osinfra.cn"
user_name = "gxz1234"
client_id = "67579b1372b4372cca66b29a"
noemail_account = "18781761229"
noemail_user_name = "caiwei"

# 由具体测试用例注入（上传文件相关）
file = None
time_now = None

BASE_URL = f"https://{hostURL}"
session = requests.Session()

# ==================== Helper Functions ====================
def random_string(length, chars=string.ascii_lowercase):
    return "".join(random.choice(chars) for _ in range(length))

def current_time_millis():
    return int(time.time() * 1000)

def make_request(method, path, base_url=None, **kwargs):
    base = base_url or BASE_URL
    if not base.endswith("/") and not path.startswith("/"):
        path = "/" + path
    url = f"{base}{path}"
    for attempt in range(3):
        response = session.request(method, url, **kwargs)
        if response.status_code == 429:
            retry_after = int(response.headers.get("Retry-After", 2))
            time.sleep(retry_after)
            continue
        return response
    return response

def extract_between(text, left, right):
    """Extract text between left and right boundaries."""
    idx = text.find(left)
    if idx == -1:
        return ""
    idx += len(left)
    if right:
        end = text.find(right, idx)
        if end == -1:
            return ""
        return text[idx:end]
    return text[idx:]


def get_cookie(response, name, default_msg="NOT FOUND!!!"):
    """从响应或会话中提取 cookie，若不存在则返回提示信息。"""
    val = response.cookies.get(name, "")
    print(f"[DEBUG get_cookie] response.cookies.get({name}): '{val[:30] if val else 'EMPTY'}'")
    if not val:
        val = session.cookies.get(name, "")
        print(f"[DEBUG get_cookie] session.cookies.get({name}): '{val[:30] if val else 'EMPTY'}'")
    result = val if val else f"{name} {default_msg}"
    print(f"[DEBUG get_cookie] result for {name}: '{result[:30] if result else 'EMPTY'}'")
    return result


def login_flow(account_to_use=None, double_auth=False, check_email_exist=False, fetch_user_info=False):
    """
    封装完整的 OAuth2 + OneID 登录流程，供各测试用例复用。

    参数:
        account_to_use: 登录账号，默认使用全局变量 account
        double_auth:    是否执行两轮 auth/callback/csrf-token（多数业务测试需要）
        check_email_exist: 是否断言 email_exist 为 False（仅无邮箱绑定测试需要）
        fetch_user_info:   是否在登录完成后请求 /u/{user_name}.json

    返回一个字典，包含后续请求常用的关键变量:
        csrf, csrf_token, forum_session, cookie_YG, cookie_UT, token_value, state, code
    """
    acc = account_to_use or account

    # 1-csrf
    headers = {
        "host": f"{hostURL}",
        "referer": f"https://{hostURL}",
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "Cookie": "HWWAFSESTIME=1746606259969; HWWAFSESID=d764f73f297a4fe16e; _cookies_accepted=all",
        "Discourse-Present": "true",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
        "X-CSRF-Token": "undefined",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
    }
    response = make_request("GET", "/session/csrf", headers=headers)
    csrf = response.json().get("csrf", {})
    forum_session = get_cookie(response, "_forum_session")

    # 2-oauth2_basic
    headers = {
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Cache-Control": "max-age=0",
        "Connection": "keep-alive",
        "Content-Length": "105",
        "Content-Type": "application/x-www-form-urlencoded",
        "Origin": "https://discourse.test.osinfra.cn",
        "Referer": "https://discourse.test.osinfra.cn/",
        "Sec-Fetch-Dest": "document",
        "Sec-Fetch-Mode": "navigate",
        "Sec-Fetch-Site": "same-origin",
        "Sec-Fetch-User": "?1",
        "Upgrade-Insecure-Requests": "1",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
        "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Windows"',
    }
    response = make_request("POST", "/auth/oauth2_basic", headers=headers, data=f"authenticity_token={csrf}")
    new_forum_session = get_cookie(response, "_forum_session")
    if new_forum_session and "NOT FOUND" not in new_forum_session:
        forum_session = new_forum_session
    state = extract_between(response.url, 'state=', '&')
    if not state:
        state = extract_between(response.url, 'state=', '')

    # 3-login
    headers = {
        "host": f"{userURL}",
        "Content-Type": "application/json;charset=UTF-8",
        "referer": f"https://{userURL}/login?client_id=678e12840a894118623d1f2c&scope=openid%20profile%20email%20phone%20address%20username%20id_token&redirect_uri=https%3A%2F%2Fxihe2.test.osinfra.cn%2F&response_mode=query&state=8caae9247a6b4942a0867bb9d614a3d9",
    }
    response = make_request(
        "POST",
        "/oneid/login",
        headers=headers,
        base_url=f"https://{userURL}",
        json={
            "permission": "sigRead",
            "account": f"{acc}",
            "client_id": f"{client_id}",
            "password": f"{password}",
            "need_captcha_verification": False,
            "accept_term": 0,
            "oneidPrivacyAccepted": "20240830",
        },
    )
    data = response.json()

    if check_email_exist:
        actual_value = data.get("data", {}).get("email_exist", {})
        assert actual_value == False, f"JSON path $.data.email_exist expected False, got {actual_value}"

    Privacy_version = data.get("data", {}).get("oneidPrivacyAccepted", {})
    cookie_YG = get_cookie(response, "_Y_G_")
    cookie_UT = get_cookie(response, "_U_T_")
    token_value = extract_between(response.text, '"token":"', '","username')

    # version
    headers = {
        "Host": f"{userURL}",
        "Token": f"{token_value}",
    }
    response = make_request("GET", "/oneid/privacy/version", headers=headers, base_url=f"https://{userURL}")
    actual_version = response.json().get("data", {}).get("oneidPrivacyAccepted", {})
    cookie_YG = get_cookie(response, "_Y_G_")
    cookie_UT = get_cookie(response, "_U_T_")

    # baseInfo
    headers = {
        "Host": f"{userURL}",
        "Token": f"{token_value}",
        "Connection": "keep-alive",
        "Referer": f"https://{userURL}/login?redirect_uri=https%3A%2F%2F{hostURL}%2F&lang=zh",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "sec-ch-ua": '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Windows"',
        "Content-Type": "application/json;charset=UTF-8",
        "Origin": f"https://{userURL}",
    }
    response = make_request("POST", "/oneid/update/baseInfo", headers=headers, base_url=f"https://{userURL}", json={"oneidPrivacyAccepted": f"{actual_version}"})
    cookie_YG = get_cookie(response, "_Y_G_")
    cookie_UT = get_cookie(response, "_U_T_")

    # permission
    headers = {
        "Host": f"{userURL}",
        "Token": f"{cookie_UT}",
        "Referer": f"https://{userURL}/login?redirect_uri=https%3A%2F%2F{hostURL}%2F&lang=zh",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0",
        "sec-ch-ua": '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Windows"',
    }
    response = make_request("GET", "/oneid/user/permission", headers=headers, base_url=f"https://{userURL}")
    print(f"[DEBUG] After permission request: status={response.status_code}")
    print(f"[DEBUG] session.cookies keys: {[c.name for c in session.cookies]}")
    for c in session.cookies:
        if c.name in ('_Y_G_', '_U_T_'):
            print(f"[DEBUG] Found {c.name}: domain={c.domain}, path={c.path}, value={c.value[:30]}")
    print(f"[DEBUG] session.cookies.get('_Y_G_'): {session.cookies.get('_Y_G_', 'DEFAULT')}")
    print(f"[DEBUG] session.cookies.get('_U_T_'): {session.cookies.get('_U_T_', 'DEFAULT')}")
    cookie_YG = get_cookie(response, "_Y_G_")
    cookie_UT = get_cookie(response, "_U_T_")

    # 预先初始化，供嵌套函数 nonlocal 使用
    code = ""
    csrf_token = ""

    def _auth_callback_csrf(cookie_token, is_second=False):
        nonlocal cookie_YG, cookie_UT, state, code, forum_session, csrf_token
        # 将 cookie 注入 session.cookies 以便自动发送（包含 WAF cookie 等）
        print(f"[DEBUG] Before set: session.cookies.get('_Y_G_'): {session.cookies.get('_Y_G_', 'EMPTY')[:30]}")
        if cookie_YG and "NOT FOUND" not in cookie_YG:
            session.cookies.set("Y_G_", cookie_YG, domain=".test.osinfra.cn", path="/")
            print(f"[DEBUG] After set Y_G_: {session.cookies.get('Y_G_', 'EMPTY')[:30]}")
        if cookie_UT and "NOT FOUND" not in cookie_UT:
            session.cookies.set("_U_T_", cookie_UT, domain=".test.osinfra.cn", path="/")
            print(f"[DEBUG] After set _U_T_: {session.cookies.get('_U_T_', 'EMPTY')[:30]}")
        print(f"[DEBUG] Before auth: session.cookies.get('Y_G_'): {session.cookies.get('Y_G_', 'EMPTY')[:30]}")
        print(f"[DEBUG] Before auth: session.cookies.get('_U_T_'): {session.cookies.get('_U_T_', 'EMPTY')[:30]}")
        # auth
        headers_auth = {
            "Host": f"{userURL}",
            "Token": f"{cookie_token}",
        }
        redirect_uri = f"https:%2F%2F{hostURL}%2Fauth%2Foauth2_basic%2Fcallback" if not is_second else "https:%2F%2Fopenubmc-discussion.test.osinfra.cn%2Fauth%2Foauth2_basic%2Fcallback"
        auth_url = f"/oneid/oidc/auth?client_id={client_id}&redirect_uri={redirect_uri}&response_type=code&scope=openid+profile+email+picture&state={state}"
        response = make_request(
            "GET",
            auth_url,
            headers=headers_auth,
            base_url=f"https://{userURL}",
        )
        print(f"[DEBUG] auth request headers: {dict(response.request.headers)}")
        print(f"[DEBUG] auth request cookies: {response.request.headers.get('Cookie', 'NO COOKIE')}")
        new_cookie_YG = get_cookie(response, "_Y_G_")
        new_cookie_UT = get_cookie(response, "_U_T_")
        if new_cookie_YG and "NOT FOUND" not in new_cookie_YG:
            cookie_YG = new_cookie_YG
        if new_cookie_UT and "NOT FOUND" not in new_cookie_UT:
            cookie_UT = new_cookie_UT
        new_code = ""
        new_state = ""
        if response.history:
            # 从重定向链中的 Location 头提取 code 和 state
            redirect_url = response.history[0].headers.get('Location', '')
            print(f"[DEBUG] auth redirect_url: {redirect_url[:200]}")
            new_code = extract_between(redirect_url, 'code=', '&')
            if not new_code:
                new_code = extract_between(redirect_url, 'code=', '')
            new_state = extract_between(redirect_url, 'state=', '&')
            if not new_state:
                new_state = extract_between(redirect_url, 'state=', '')
        print(f"[DEBUG] auth response.status_code: {response.status_code}")
        print(f"[DEBUG] auth response.url: {response.url}")
        safe_text = response.text[:500].encode('utf-8', errors='replace').decode('utf-8')
        print(f"[DEBUG] auth response.text: {safe_text}")
        try:
            safe_text = response.text[:500].encode('utf-8', errors='replace').decode('utf-8')
            print(f"[DEBUG] auth response.text: {safe_text}")
        except Exception as e:
            print(f"[DEBUG] auth response.text error: {e}")
        if not new_code:
            new_code = extract_between(response.url, 'code=', '&')
        if not new_code:
            new_code = extract_between(response.text, 'code=', '&')
        if not new_state:
            new_state = extract_between(response.url, 'state=', '&')
        if not new_state:
            new_state = extract_between(response.text, 'state=', '","status"')
        if new_code and "NOT FOUND" not in new_code:
            code = new_code
        if new_state and "NOT FOUND" not in new_state:
            state = new_state
        print(f"[DEBUG] extracted code: {code[:50] if code else 'EMPTY'}")
        print(f"[DEBUG] extracted state: {state[:50] if state else 'EMPTY'}")
        if response.status_code != 302:
            safe_text = response.text[:500].encode('utf-8', errors='replace').decode('utf-8')
            print(f"[DEBUG] auth response text: {safe_text}")

        # callback
        headers_cb = {
            "Host": f"{hostURL}",
            "referer": f"https://{userURL}/",
            "Accept-Encoding": "gzip, deflate, br, zstd",
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
            "Connection": "keep-alive",
            "Sec-Fetch-Dest": "document",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-Site": "same-site",
            "Sec-Fetch-User": "?1",
            "Upgrade-Insecure-Requests": "1",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
            "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": '"Windows"',
        }
        response = make_request("GET", "/auth/oauth2_basic/callback", headers=headers_cb, base_url=f"https://{hostURL}", params={"code": f"{code}", "state": f"{state}"})
        forum_session = get_cookie(response, "_forum_session")

        # 获取csrf-token
        headers_csrf = {
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "Accept-Encoding": "gzip, deflate, br, zstd",
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
            "Connection": "keep-alive",
            "Host": f"{hostURL}",
            "Referer": f"https://{userURL}/",
            "Sec-Fetch-Dest": "document",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-Site": "same-site",
            "Sec-Fetch-User": "?1",
            "Upgrade-Insecure-Requests": "1",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
            "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": '"Windows"',
        }
        response = make_request("GET", "", headers=headers_csrf)
        print(f"[DEBUG] csrf-token response status: {response.status_code}")
        print(f"[DEBUG] csrf-token response url: {response.url}")
        text = response.text
        idx = text.find('meta name="csrf-token"')
        print(f"[DEBUG] csrf-token meta index: {idx}")
        if idx != -1:
            snippet = text[idx:idx+100]
            print(f"[DEBUG] csrf-token snippet: {snippet.encode('utf-8', errors='replace').decode('utf-8')}")
        else:
            idx2 = text.find('csrf-token')
            print(f"[DEBUG] csrf-token any index: {idx2}")
            if idx2 != -1:
                snippet = text[idx2:idx2+100]
                print(f"[DEBUG] csrf-token snippet: {snippet.encode('utf-8', errors='replace').decode('utf-8')}")
        csrf_token = extract_between(response.text, 'meta name="csrf-token" content="', '" />')
        if not csrf_token:
            csrf_token = extract_between(response.text, 'name="csrf-token" content="', '"')
        if not csrf_token:
            csrf_token = "csrf-token  NOT FOUND"
        if csrf_token == "csrf-token  NOT FOUND":
            csrf_token = csrf  # fallback to the csrf from step 1
        print(f"[DEBUG] extracted csrf_token: {csrf_token[:50] if csrf_token else 'EMPTY'}")

    # 第一次 auth/callback/csrf-token
    _auth_callback_csrf(cookie_UT, is_second=False)

    # 部分测试需要执行两轮
    if double_auth:
        _auth_callback_csrf(token_value, is_second=True)

    result = {
        "csrf": csrf,
        "csrf_token": csrf_token,
        "forum_session": forum_session,
        "cookie_YG": cookie_YG,
        "cookie_UT": cookie_UT,
        "token_value": token_value,
        "state": state,
        "code": code,
    }

    if fetch_user_info:
        headers = {"Content-Type": "application/json"}
        make_request("GET", f"/u/{user_name}.json", headers=headers)

    return result


# ==================== Test Cases ====================


def test_访问论坛服务():
    """访问论坛服务"""
    headers = {"Content-Type": "application/json"}
    make_request("GET", "", headers=headers)


def test_验证登录成功():
    """验证登录成功"""
    login_flow(double_auth=False, fetch_user_info=True)


def test_验证登录没有绑定邮箱会报错提示():
    """验证登录没有绑定邮箱会报错提示"""
    login_flow(account_to_use=noemail_account, double_auth=False, check_email_exist=True)


def test_新建话题并删除成功():
    """新建话题并删除成功"""
    login_info = login_flow()
    csrf = login_info["csrf"]

    # 7-新建话题
    headers = {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8", "x-csrf-token": f"{csrf}"}
    response = make_request(
        "POST",
        "/posts",
        headers=headers,
        data=f"""raw=this+is+THE+content+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(10))}+of+THE+discourse+{int(time.time() * 1000)}&title=THE+title+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(5))}+of+THE+discourse+{int(time.time() * 1000)}&unlist_topic=false&category=5&is_warning=false&archetype=regular&typing_duration_msecs=12900&composer_open_duration_msecs=39133&composer_version=1&tags[]=test&featured_link=&shared_draft=false&draft_key=new_topic_{int(time.time() * 1000)}&nested_post=true""",
    )
    data = response.json()
    topic_id = data.get("post", {}).get("topic_id", {})

    # 8-查询我的帖子活动列表
    headers = {"x-csrf-token": f"{csrf}"}
    response = make_request("GET", f"/user_actions.json?offset=0&username={user_name}&filter=4,5", headers=headers)
    assert "this is THE content" in response.text, f"Response does not contain: this is THE content"

    # 9-删除话题
    headers = {
        "x-csrf-token": f"{csrf}",
        "referer": f"https://{hostURL}/t/topic/{topic_id}",
        "origin": f"https://{hostURL}",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Discourse-Logged-In": "true",
        "Discourse-Present": "true",
        "Host": f"{hostURL}",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Windows"',
    }
    response = make_request("DELETE", f"/t/{topic_id}", headers=headers, data=f"context=%2Ft%2Ftopic%2F{topic_id}")
    assert response.status_code == 200, f"Expected status code 200, got {response.status_code}"

    # 10-验证我的帖子活动列表中帖子被删除
    time.sleep(3)
    headers = {"x-csrf-token": f"{csrf}"}
    response = make_request("GET", f"/user_actions.json?offset=0&username={user_name}&filter=4,5", headers=headers)
    assert "this is THE content" not in response.text, f"Response does not contain: this is THE content"


def test_新建话题并编辑成功():
    """新建话题并编辑成功"""
    login_info = login_flow()
    csrf = login_info["csrf"]

    # 7-新建话题
    headers = {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8", "x-csrf-token": f"{csrf}"}
    response = make_request(
        "POST",
        "/posts",
        headers=headers,
        data=f"""raw=this+is+THE+content+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(10))}+of+THE+discourse+{int(time.time() * 1000)}&title=THE+title+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(5))}+of+THE+discourse+{int(time.time() * 1000)}&unlist_topic=false&category=5&is_warning=false&archetype=regular&typing_duration_msecs=12900&composer_open_duration_msecs=39133&composer_version=1&featured_link=&shared_draft=false&draft_key=new_topic_{int(time.time() * 1000)}&nested_post=true""",
    )
    data = response.json()
    topic_id = data.get("post", {}).get("topic_id", {})
    post_id = data.get("post", {}).get("id", {})

    # 8-修改贴子的标题、类别和标签
    headers = {
        "x-csrf-token": f"{csrf}",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "Content-Length": "91",
        "Content-Type": "application/json",
        "Discourse-Logged-In": "true",
        "Discourse-Present": "true",
        "Host": f"{hostURL}",
        "Origin": f"https://{hostURL}",
        "Referer": f"https://{hostURL}/t/topic/{topic_id}",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua": '"Micros',
    }
    response = make_request("PUT", f"/t/topic/{topic_id}", headers=headers, json={"title": "this is the new title", "tags": ["test"], "keep_existing_draft": True, "category_id": 3})

    # 9-修改贴子的正文
    headers = {"x-csrf-token": f"{csrf}", "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"}
    response = make_request("PUT", f"/posts/{post_id}", headers=headers, data=f"post%5Bedit_reason%5D=&post%5Braw%5D=this+is+the+new+content&post%5Btopic_id%5D={topic_id}&post%5Boriginal_text%5D=")

    # 10-查询我的帖子活动列表
    headers = {"x-csrf-token": f"{csrf}"}
    response = make_request("GET", f"/user_actions.json?offset=0&username={user_name}&filter=4,5", headers=headers)
    assert "new content" in response.text, f"Response does not contain: new content"
    assert "new title" in response.text, f"Response does not contain: new title"

    # 11-删除话题
    headers = {
        "x-csrf-token": f"{csrf}",
        "referer": f"https://{hostURL}/t/topic/{topic_id}",
        "origin": f"https://{hostURL}",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Discourse-Logged-In": "true",
        "Discourse-Present": "true",
        "Host": f"{hostURL}",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Windows"',
    }
    response = make_request("DELETE", f"/t/{topic_id}", headers=headers, data=f"context=%2Ft%2Ftopic%2F{topic_id}")
    assert response.status_code == 200, f"Expected status code 200, got {response.status_code}"


def test_新建话题并回复成功():
    """新建话题并回复成功"""
    login_info = login_flow()
    csrf = login_info["csrf"]

    # 7-新建话题
    headers = {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8", "x-csrf-token": f"{csrf}"}
    response = make_request(
        "POST",
        "/posts",
        headers=headers,
        data=f"""raw=this+is+THE+content+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(10))}+of+THE+discourse+{int(time.time() * 1000)}&title=THE+title+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(5))}+of+THE+discourse+{int(time.time() * 1000)}&unlist_topic=false&category=5&is_warning=false&archetype=regular&typing_duration_msecs=12900&composer_open_duration_msecs=39133&composer_version=1&featured_link=&shared_draft=false&draft_key=new_topic_{int(time.time() * 1000)}&nested_post=true""",
    )
    data = response.json()
    topic_id = data.get("post", {}).get("topic_id", {})

    # 8-回复话题
    headers = {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8", "x-csrf-token": f"{csrf}"}
    response = make_request(
        "POST",
        "/posts",
        headers=headers,
        data=f"raw=hello+world222222&unlist_topic=false&category=4&topic_id={topic_id}&is_warning=false&archetype=regular&typing_duration_msecs=2100&composer_open_duration_msecs=14781&composer_version=1&featured_link=&shared_draft=false&draft_key=topic_{topic_id}&nested_post=true",
    )
    data = response.json()
    post_id = data.get("post", {}).get("id", {})

    # 9-查询我的帖子活动的回复列表
    headers = {"x-csrf-token": f"{csrf}"}
    response = make_request("GET", f"/user_actions.json?offset=0&username={user_name}&filter=5", headers=headers)
    assert "hello world" in response.text, f"Response does not contain: hello world"

    # 10-删除回复
    headers = {
        "x-csrf-token": f"{csrf}",
        "referer": f"https://{hostURL}/t/topic/{topic_id}",
        "origin": f"https://{hostURL}",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Discourse-Logged-In": "true",
        "Discourse-Present": "true",
        "Host": f"{hostURL}",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Windows"',
    }
    response = make_request("DELETE", f"/posts/{post_id}", headers=headers, data=f"context=%2Ft%2Ftopic%2F{topic_id}")
    assert response.status_code == 200, f"Expected status code 200, got {response.status_code}"

    # 11-删除话题
    headers = {
        "x-csrf-token": f"{csrf}",
        "referer": f"https://{hostURL}/t/topic/{topic_id}",
        "origin": f"https://{hostURL}",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Discourse-Logged-In": "true",
        "Discourse-Present": "true",
        "Host": f"{hostURL}",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Windows"',
    }
    response = make_request("DELETE", f"/t/{topic_id}", headers=headers, data=f"context=%2Ft%2Ftopic%2F{topic_id}")
    assert response.status_code == 200, f"Expected status code 200, got {response.status_code}"


def test_新建上传压缩包的话题并删除成功():
    """新建上传压缩包的话题并删除成功"""
    login_info = login_flow()
    csrf = login_info["csrf"]

    # 上传压缩包文件
    headers = {
        "Content-Type": "multipart/form-data",
        "x-csrf-token": f"{csrf}",
        "Host": f"{hostURL}",
        "origin": f"https://{hostURL}",
        "referer": f"https://{hostURL}/",
    }
    response = make_request(
        "POST",
        f"uploads.json?client_id={client_id}",
        headers=headers,
        params={"upload_type": "composer", "pasted": "undefined", "name": "sign.png", "type": "image/png", "sha1_checksum": "8e1ddcd928565ca2d4285576e4ec3f9552668659", "file": f"{file}"},
    )
    data = response.json()
    topic_id = data.get("post", {}).get("topic_id", {})
    short_url = extract_between(response.text, 'upload://', '"')
    if not short_url:
        short_url = "short_url NOT FOUND!!"

    # drafts-1
    headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "x-csrf-token": f"{csrf}",
        "Host": f"{hostURL}",
        "origin": f"https://{hostURL}",
        "referer": f"https://{hostURL}/",
    }
    response = make_request(
        "POST",
        "/drafts.json",
        headers=headers,
        data=f"draft_key=new_topic_{time_now}&sequence=0&data=%7B%22reply%22%3A%22%5Bsign%7C393x193%5D(upload%3A%2F%2F{short_url})draft_key=new_topic_1752569701859&sequence=1&data=%7B%22reply%22%3A%22!%5Bsign%7C393x193%5D(upload%3A%2F%2Fgr3LOgUBMtXVf00FsL6ziz6AcGL.png)%5Cn%22%2C%22action%22%3A%22createTopic%22%2C%22title%22%3A%22%E7%BB%99%E5%AF%B9%E6%96%B9%22%2C%22categoryId%22%3A4%2C%22tags%22%3A%5B%5D%2C%22archetypeId%22%3A%22regular%22%2C%22metaData%22%3Anull%2C%22composerTime%22%3A23614%2C%22typingTime%22%3A1900%2C%22original_text%22%3A%22%22%2C%22locale%22%3A%22zh_CN%22%7D&owner={client_id}&force_save=false",
    )

    # 7-新建话题
    headers = {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "x-csrf-token": f"{csrf}",
        "Host": f"{hostURL}",
        "origin": f"https://{hostURL}",
        "referer": f"https://{hostURL}/",
    }
    response = make_request(
        "POST",
        "/posts",
        headers=headers,
        data=f"""raw=!%5B%E7%AD%BE%E5%90%8D%7C393x193%5D(upload%3A%2F%2F{short_url})%0Athis+is+the+main_post+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(10))}+of+THE+discourse+{int(time.time() * 1000)}&title=THE+title+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(5))}+of+THE+discourse+{int(time.time() * 1000)}&unlist_topic=false&category=5&is_warning=false&archetype=regular&typing_duration_msecs=700&composer_open_duration_msecs=24759&composer_version=1&shared_draft=false&draft_key=new_topic_{time_now}&locale=zh_CN&nested_post=true""",
    )
    data = response.json()
    topic_id = data.get("post", {}).get("topic_id", {})

    # 8-查询我的帖子活动列表
    headers = {"x-csrf-token": f"{csrf}"}
    response = make_request("GET", f"/user_actions.json?offset=0&username={user_name}&filter=4,5", headers=headers)
    assert "this is the main_post" in response.text, f"Response does not contain: this is the main_post"

    # 9-删除话题
    headers = {
        "x-csrf-token": f"{csrf}",
        "referer": f"https://{hostURL}/t/topic/{topic_id}",
        "origin": f"https://{hostURL}",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Discourse-Logged-In": "true",
        "Discourse-Present": "true",
        "Host": f"{hostURL}",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Windows"',
    }
    response = make_request("DELETE", f"/t/{topic_id}", headers=headers, data=f"context=%2Ft%2Ftopic%2F{topic_id}")
    assert response.status_code == 200, f"Expected status code 200, got {response.status_code}"

    # 10-验证我的帖子活动列表中帖子被删除
    headers = {"x-csrf-token": f"{csrf}"}
    response = make_request("GET", f"/user_actions.json?offset=0&username={user_name}&filter=4,5", headers=headers)
    assert "this is the main" not in response.text, f"Response should not contain deleted content: {response.text[:200]}"


def test_帖子搜索功能():
    """帖子搜索功能"""
    login_info = login_flow()
    csrf = login_info["csrf"]

    # 7-新建话题
    headers = {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8", "x-csrf-token": f"{csrf}"}
    response = make_request(
        "POST",
        "/posts",
        headers=headers,
        data=f"""raw=this+is+THE+content+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(10))}+of+THE+discourse+{int(time.time() * 1000)}&title=THE+title+{"".join(random.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(5))}+of+THE+discourse+{int(time.time() * 1000)}&unlist_topic=false&category=5&is_warning=false&archetype=regular&typing_duration_msecs=12900&composer_open_duration_msecs=39133&composer_version=1&tags[]=test&featured_link=&shared_draft=false&draft_key=new_topic_{int(time.time() * 1000)}&nested_post=true""",
    )
    data = response.json()
    topic_id = data.get("post", {}).get("topic_id", {})

    # 8-搜索帖子
    headers = {"x-csrf-token": f"{csrf}", "Accept": "application/json"}
    response = make_request("GET", "/search/query", headers=headers, params={"term": "this"})
    data = response.json()
    actual_value = data.get("topics", [])
    assert actual_value != [] and actual_value != {}, f"JSON path $.topics should not be empty, got {actual_value}"

    # 9-删除话题
    headers = {
        "x-csrf-token": f"{csrf}",
        "referer": f"https://{hostURL}/t/topic/{topic_id}",
        "origin": f"https://{hostURL}",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br, zstd",
        "Accept-Language": "zh-CN,zh;q=0.9",
        "Connection": "keep-alive",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Discourse-Logged-In": "true",
        "Discourse-Present": "true",
        "Host": f"{hostURL}",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua": '"Microsoft Edge";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Windows"',
    }
    response = make_request("DELETE", f"/t/{topic_id}", headers=headers, data=f"context=%2Ft%2Ftopic%2F{topic_id}")
    assert response.status_code == 200, f"Expected status code 200, got {response.status_code}"

    # 10-验证我的帖子活动列表中帖子被删除
    time.sleep(3)
    headers = {"x-csrf-token": f"{csrf}"}
    response = make_request("GET", f"/user_actions.json?offset=0&username={user_name}&filter=4,5", headers=headers)
    assert "this is THE content" in response.text, f"Response does not contain: this is THE content"


if __name__ == "__main__":
    pytest.main([__file__, "-v"])

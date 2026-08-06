# -*- coding: utf-8 -*-
"""pytest 运行时: 对应 JMX 测试计划层(Cookie 管理器 / 全局变量 / 提取器 / 断言)"""
import json
import random
import re
import time
from pathlib import Path
from urllib.parse import urlsplit

import pytest
import requests
import os

# 测试计划级固定定时器 500ms, 作用于每个采样器之前; 如需加速可调 0
PLAN_TIMER_DELAY = 0.5
FILES_DIR = Path(__file__).parent / "file"
VERIFY_TLS = True
TIMEOUT = 60


def _env(key):
    value = os.getenv(key)
    if value is None:
        raise ValueError(f"环境变量 {key} 未设置，请在系统环境变量或 .env 文件中配置")
    return value


GLOBAL_VARS = {
    'userURL': 'openeuler-usercenter.test.osinfra.cn',
    'hostURL': 'openeuler-compatibility.test.osinfra.cn',
    'mate_account': _env('TEST_MATE_ACCOUNT'),
    'mate_password': _env('TEST_MATE_PASSWORD'),
    'ic_account': _env('TEST_IC_ACCOUNT'),
    'ic_password': _env('TEST_IC_PASSWORD'),
    'report_review_account': _env('TEST_REPORT_REVIEW_ACCOUNT'),
    'report_review_password': _env('TEST_REPORT_REVIEW_PASSWORD'),
    'flag_store_account': _env('TEST_FLAG_STORE_ACCOUNT'),
    'flag_store_password': _env('TEST_FLAG_STORE_PASSWORD'),
    'certificate_issuance_account': _env('TEST_CERTIFICATE_ISSUANCE_ACCOUNT'),
    'certificate_issuance_password': _env('TEST_CERTIFICATE_ISSUANCE_PASSWORD'),
    'intel_ic_account': _env('TEST_INTEL_IC_ACCOUNT'),
    'intel_ic_password': _env('TEST_INTEL_IC_PASSWORD'),
    'intel_certificate_issuance_account': _env('TEST_INTEL_CERTIFICATE_ISSUANCE_ACCOUNT'),
    'intel_certificate_issuance_password': _env('TEST_INTEL_CERTIFICATE_ISSUANCE_PASSWORD'),
    'ic_account_2': _env('TEST_IC_ACCOUNT_2'),
    'ic_password_2': _env('TEST_IC_PASSWORD_2'),
    'state': _env('TEST_STATE'),
}


def jsonpath_all(data, path):
    """支持 $.a.b[0].c 与 $.a[?(@.k==v)].b 的最小 JSONPath 子集"""
    parts, buf, depth = [], "", 0
    for ch in path[2:] if path.startswith("$.") else path:
        if ch == "[":
            depth += 1
        elif ch == "]":
            depth -= 1
        if ch == "." and depth == 0:
            parts.append(buf)
            buf = ""
        else:
            buf += ch
    parts.append(buf)

    nodes = [data]
    for part in parts:
        if not part:
            continue
        m = re.match(r"^([^\[\]]*)(.*)$", part)
        name, rest = m.group(1), m.group(2) or ""
        brackets = re.findall(r"\[([^\]]*)\]", rest)
        if name:
            tmp = []
            for node in nodes:
                if isinstance(node, dict) and name in node:
                    tmp.append(node[name])
                elif isinstance(node, list):
                    tmp.extend(e[name] for e in node
                               if isinstance(e, dict) and name in e)
            nodes = tmp
        for b in brackets:
            b = b.strip()
            tmp = []
            for node in nodes:
                if b.startswith("?"):
                    fm = re.match(r"\?\(\s*@\.(\w+)\s*==\s*(.+?)\s*\)$", b)
                    key, want = fm.group(1), fm.group(2).strip().strip("\"\'")
                    if isinstance(node, list):
                        tmp.extend(e for e in node if isinstance(e, dict)
                                   and str(e.get(key)) == want)
                elif re.fullmatch(r"-?\d+", b):
                    idx = int(b)
                    if isinstance(node, list) and -len(node) <= idx < len(node):
                        tmp.append(node[idx])
            nodes = tmp
    return nodes


class Ctx:
    """模拟 JMeter 线程上下文: vars(线程变量) + globals(跨线程组 property)"""

    def __init__(self, session, globals_):
        self.session = session
        self.vars = dict(GLOBAL_VARS)
        self.globals = globals_

    # ---- 变量 ----
    def v(self, name, default=None):
        if name in self.vars:
            return self.vars[name]
        if name in self.globals:
            return self.globals[name]
        return default if default is not None else "${%s}" % name

    def set_global(self, name, value):
        self.globals[name] = value

    def resolve(self, text):
        if text is None:
            return None
        def _repl(m):
            expr = m.group(1)
            # JMeter 函数: ${__RandomString(长度,字符集,)}
            if expr.startswith("__RandomString("):
                args = [a.strip() for a in
                        expr[len("__RandomString("):].rstrip(")").split(",")
                        if a.strip()]
                n = int(args[0]) if args else 6
                chars = args[1] if len(args) > 1 else (
                    "abcdefghijklmnopqrstuvwxyz0123456789")
                return "".join(random.choice(chars) for _ in range(n))
            return str(self.v(expr))
        return re.sub(r"\$\{([^}]+)\}", _repl, str(text))

    # ---- 请求 ----
    def request(self, method, base, path, headers=None, body=None, args=None,
                files=None):
        if PLAN_TIMER_DELAY:
            time.sleep(PLAN_TIMER_DELAY)
        base = self.resolve(base)
        path = self.resolve(path) or ""
        url = base + path
        raw_headers = headers or {}
        headers = {}
        for k, v in raw_headers.items():
            # JMX 录制中存在 "user-agent:" 这类非法头名, 清洗之
            nk = k.strip().rstrip(":").strip()
            if nk:
                headers[nk] = self.resolve(v)
        # JMeter(HttpClient)对请求头字符宽容, requests 限 latin-1;
        # 提取失败的默认值(含中文)在此替换为 "?", 行为与 JMeter 一致(继续执行)
        for k, v in list(headers.items()):
            try:
                v.encode("latin-1")
            except UnicodeEncodeError:
                print(f"警告: 请求头 {k} 含非 latin-1 字符(变量可能未提取到), "
                      f"已替换: {v!r}")
                headers[k] = v.encode("latin-1", "replace").decode("latin-1")
        method = method.upper()

        # Cookie 处理: JMeter 中 CookieManager 始终生效(携带服务端真实 Set-Cookie),
        # 录制流量中的 Cookie 头仅作补充。此处将显式 Cookie 头与 session _cookie 罐合并:
        # 丢弃提取失败的(NOT FOUND/未解析变量), 其余覆盖同名 jar 值。
        cookie_hdr = None
        for k in list(headers):
            if k.lower() == "cookie":
                cookie_hdr = headers.pop(k)
        if cookie_hdr is not None:
            explicit = {}
            for pair in cookie_hdr.split(";"):
                pair = pair.strip()
                if "=" in pair:
                    ck, cv = pair.split("=", 1)
                    if cv.strip() and "NOT FOUND" not in cv and "${" not in cv:
                        explicit[ck.strip()] = cv.strip()
            host = (urlsplit(url).hostname or "")
            jar = {}
            for c in self.session.cookies:
                dom = (c.domain or "").lstrip(".")
                if host == dom or host.endswith("." + dom):
                    jar[c.name] = c.value
            jar.update(explicit)
            if jar:
                headers["Cookie"] = "; ".join(
                    f"{k}={v}" for k, v in jar.items())

        req_files = None
        if files:
            req_files = {}
            for f in files:
                fp = FILES_DIR / f["filename"]
                assert fp.exists(), f"上传文件不存在: {fp}"
                req_files[f["param"]] = (f["filename"], open(fp, "rb"),
                                         f["mimetype"])
        try:
            if method in ("GET", "DELETE") and args:
                # JMeter always_encode=false: 参数原样拼接, 不做 URL 编码
                # (如 scope=openid+profile 中的 + 表示空格)
                qs = "&".join(f"{k}={self.resolve(v)}" for k, v in args)
                sep = "&" if "?" in url else "?"
                return self._send(method, url + sep + qs,
                                  headers=headers)
            if body is not None:
                # requests 对 str body 按字符数计算 Content-Length 且编码不保证
                # UTF-8, 中文 JSON 体会被截断导致服务端"系统繁忙"; 显式编为 UTF-8
                # 字节流, 与 JMeter(contentEncoding=UTF-8)一致
                return self._send(method, url, headers=headers,
                                  data=self.resolve(body).encode("utf-8"))
            if files:
                data = {k: self.resolve(v) for k, v in (args or [])} or None
                return self._send(method, url, headers=headers,
                                  data=data, files=req_files)
            if args:
                # 表单提交: 同样不编码, 与 JMeter 一致
                raw = "&".join(f"{k}={self.resolve(v)}" for k, v in args)
                headers.setdefault("Content-Type",
                                   "application/x-www-form-urlencoded")
                return self._send(method, url, headers=headers,
                                  data=raw.encode("utf-8"))
            return self._send(method, url, headers=headers)
        finally:
            if req_files:
                for _, (fn, fh, mt) in req_files.items():
                    fh.close()

    def _send(self, method, url, **kw):
        return self.session.request(method, url, timeout=TIMEOUT,
                                    verify=VERIFY_TLS, **kw)

    # ---- 提取器 ----
    @staticmethod
    def _header_text(resp):
        chain = list(resp.history) + [resp]
        parts = []
        for r in chain:
            for k, v in r.raw.headers.items():
                parts.append(f"{k}: {v}")
        return "\n".join(parts)

    def boundary(self, resp, refname, left, right, use_headers=False,
                 default="", match="first"):
        text = self._header_text(resp) if use_headers else resp.text
        value = None
        if match == "last_nonempty":
            # 取最后一个非空匹配(XSRF-TOKEN 多次轮换场景)
            found, idx = [], 0
            while True:
                i = text.find(left, idx)
                if i < 0:
                    break
                j = text.find(right, i + len(left)) if right else len(text)
                if j < 0:
                    break
                found.append(text[i + len(left):j])
                idx = j + len(right)
            found = [f for f in found if f]
            if found:
                value = found[-1]
        else:
            i = text.find(left)
            if i >= 0:
                j = text.find(right, i + len(left)) if right else len(text)
                if j >= 0:
                    value = text[i + len(left):j]
        if value is None:
            value = default
        self.vars[refname] = value
        return value

    def regex(self, resp, refname, pattern, group=1, default=""):
        m = re.search(pattern, resp.text)
        self.vars[refname] = m.group(group) if m else default
        return self.vars[refname]

    def jextract(self, resp, refname, path):
        path = self.resolve(path)
        nodes = jsonpath_all(resp.json(), path)
        self.vars[refname] = nodes[0] if nodes else None
        return self.vars[refname]

    # ---- 断言 ----
    def assert_contains(self, resp, pattern, label=""):
        pattern = self.resolve(pattern)
        assert pattern in resp.text, \
            f"[{label}] 响应中未找到: {pattern!r} | {resp.text[:300]}"

    def assert_json(self, resp, path, expected, is_regex=False, invert=False,
                    label=""):
        path = self.resolve(path)
        expected = self.resolve(expected)
        nodes = jsonpath_all(resp.json(), path)
        assert nodes, f"[{label}] JSONPath 无匹配: {path} | {resp.text[:300]}"
        if "[?(" in path:
            # JMeter(jayway)对过滤表达式返回数组, 断言比较的是数组的 JSON 串
            value = json.dumps(nodes, ensure_ascii=False, separators=(",", ":"))
        else:
            value = str(nodes[0])
        if is_regex:
            ok = re.fullmatch(expected, value) is not None
        else:
            ok = value == expected
        if invert:
            ok = not ok
        assert ok, f"[{label}] JSON断言失败: {path}={value!r} 期望 {expected!r}"


@pytest.fixture(scope="session")
def jmeter_globals():
    """对应 JMeter properties(BeanShell __setProperty 跨线程组共享)"""
    return {}


@pytest.fixture()
def shared_session():
    """HTTP Cookie 管理器。每个用例独立会话(每个线程组都以完整登录开始,
    独立会话可避免跨用例 cookie 污染; 与 JMeter 串行线程组行为等价)。

    请求头基线模拟 JMeter(HttpClient): 仅带 Apache-HttpClient 的 UA,
    不带 requests 默认的 Accept/Accept-Encoding —— 实测该环境 WAF/后端
    对 requests 默认头部组合会返回"系统繁忙"。"""
    s = requests.Session()
    s.headers.clear()
    s.headers["User-Agent"] = "Apache-HttpClient/4.5.14 (Java/22)"
    yield s
    s.close()


@pytest.fixture()
def ctx(shared_session, jmeter_globals):
    return Ctx(shared_session, jmeter_globals)

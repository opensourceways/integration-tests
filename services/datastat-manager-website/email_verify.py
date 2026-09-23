#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
邮箱验证码抓取模块（IMAP）

用于 openGauss SSO 登录双重验证(MFA)场景：
页面点击「获取验证码」后，本模块轮询邮箱收件箱，抓取最新一封验证码邮件中的 6 位数字。

支持邮箱：163 / 126 / QQ / Gmail 等标准 IMAP 服务，默认针对 163 邮箱优化。

163 邮箱特别说明：
  1. 必须在「设置 - POP3/SMTP/IMAP」中开启 IMAP 服务；
  2. 登录使用的不是邮箱登录密码，而是开启服务时生成的【客户端授权码】；
  3. 163 服务端要求客户端先发送 IMAP ID 命令声明身份，否则会返回
     "Unsafe Login. Please contact kefu@188.com for help" 错误 —— 本模块已自动处理。

环境变量配置（写入 .env 即可）：
  MAIL_USER        邮箱地址，缺省时回落到 TEST_ACCOUNT
  MAIL_AUTH_CODE   IMAP 客户端授权码（必填，非邮箱登录密码）
  MAIL_IMAP_HOST   IMAP 服务器，缺省按邮箱后缀自动推断
  MAIL_IMAP_PORT   IMAP SSL 端口，缺省 993
  MAIL_FOLDERS     待搜索文件夹，逗号分隔，缺省 "INBOX,垃圾邮件"
  MAIL_SENDER      发件人过滤关键字（可选，留空则不过滤）
"""

import email
import imaplib
import os
import re
import time
from email.header import decode_header, make_header
from email.utils import parsedate_to_datetime

# =============================================================================
# 配置
# =============================================================================

# 常见邮箱服务商 IMAP 服务器映射
IMAP_HOST_MAP = {
    "163.com": "imap.163.com",
    "126.com": "imap.126.com",
    "yeah.net": "imap.yeah.net",
    "qq.com": "imap.qq.com",
    "foxmail.com": "imap.qq.com",
    "gmail.com": "imap.gmail.com",
    "outlook.com": "outlook.office365.com",
    "hotmail.com": "outlook.office365.com",
}

# 验证码正则：优先匹配"验证码"字样附近的 6 位数字，兜底匹配独立的 6 位数字
CODE_PATTERNS = [
    re.compile(r"验证码[^0-9]{0,20}(\d{6})"),
    re.compile(r"(\d{6})[^0-9]{0,20}验证码"),
    re.compile(r"(?:code|CODE|Code)[^0-9]{0,20}(\d{6})"),
    re.compile(r"(?<!\d)(\d{6})(?!\d)"),
]

# 6 位纯数字若落在这些上下文中，大概率不是验证码（年份、金额、电话片段等）
CODE_BLACKLIST = {"000000", "123456"}


class MailCodeError(RuntimeError):
    """邮箱取码失败异常"""


# =============================================================================
# 内部工具
# =============================================================================
def _guess_imap_host(mail_user: str) -> str:
    """根据邮箱后缀推断 IMAP 服务器地址"""
    domain = mail_user.split("@")[-1].strip().lower()
    host = IMAP_HOST_MAP.get(domain)
    if not host:
        raise MailCodeError(
            f"[MAIL] 无法自动推断 {domain} 的 IMAP 服务器，请在 .env 中显式配置 MAIL_IMAP_HOST"
        )
    return host


def _decode_mime(value) -> str:
    """解码 MIME 编码的邮件头（如 =?utf-8?B?xxx?=）"""
    if not value:
        return ""
    try:
        return str(make_header(decode_header(value)))
    except Exception:
        return str(value)


def _html_to_text(html: str) -> str:
    """把 HTML 正文压成纯文本，便于正则提取验证码"""
    text = re.sub(r"(?is)<(script|style).*?>.*?</\1>", " ", html)
    text = re.sub(r"(?s)<[^>]+>", " ", text)
    text = (text.replace("&nbsp;", " ").replace("&amp;", "&")
                .replace("&lt;", "<").replace("&gt;", ">").replace("&#160;", " "))
    return re.sub(r"\s+", " ", text)


def _extract_body(msg) -> str:
    """提取邮件正文（优先 text/plain，回落 text/html）"""
    plain_parts, html_parts = [], []

    def _payload(part):
        raw = part.get_payload(decode=True)
        if raw is None:
            return ""
        charset = part.get_content_charset() or "utf-8"
        try:
            return raw.decode(charset, errors="replace")
        except (LookupError, UnicodeDecodeError):
            return raw.decode("utf-8", errors="replace")

    if msg.is_multipart():
        for part in msg.walk():
            if part.get_content_maintype() == "multipart":
                continue
            ctype = part.get_content_type()
            if ctype == "text/plain":
                plain_parts.append(_payload(part))
            elif ctype == "text/html":
                html_parts.append(_html_to_text(_payload(part)))
    else:
        content = _payload(msg)
        if msg.get_content_type() == "text/html":
            html_parts.append(_html_to_text(content))
        else:
            plain_parts.append(content)

    return "\n".join(plain_parts + html_parts)


def _match_code(text: str):
    """从文本中提取 6 位验证码"""
    for pattern in CODE_PATTERNS:
        for candidate in pattern.findall(text):
            if candidate not in CODE_BLACKLIST:
                return candidate
    return None


def _connect(host: str, port: int, user: str, auth_code: str) -> imaplib.IMAP4_SSL:
    """建立 IMAP 连接。163/126 需要额外发送 ID 命令，否则报 Unsafe Login。"""
    conn = imaplib.IMAP4_SSL(host, port)
    try:
        conn.login(user, auth_code)
    except imaplib.IMAP4.error as exc:
        raise MailCodeError(
            f"[MAIL] IMAP 登录失败: {exc}\n"
            f"   邮箱: {user}  服务器: {host}:{port}\n"
            f"   请确认：(1) 已开启 IMAP 服务；(2) MAIL_AUTH_CODE 填的是【客户端授权码】而非邮箱登录密码。"
        ) from None

    # 网易系服务端强制要求客户端声明身份，否则后续 SELECT 会被拒
    if "163" in host or "126" in host or "yeah" in host:
        try:
            imaplib.Commands["ID"] = ("AUTH",)
            args = ("name", "autotest", "contact", user,
                    "version", "1.0.0", "vendor", "pytest-playwright")
            conn._simple_command("ID", '("' + '" "'.join(args) + '")')
        except Exception:
            pass  # ID 失败不阻断，部分服务端不强制

    return conn


#: LIST 响应解析：(\Flags) "分隔符" "文件夹名"
_LIST_RE = re.compile(r'\((?P<flags>[^)]*)\)\s+"(?P<delim>[^"]*)"\s+(?P<name>.+)$')


def _resolve_folders(conn: imaplib.IMAP4_SSL):
    """
    解析服务端真实文件夹名。

    163 等服务商的文件夹名以 IMAP modified UTF-7 编码返回（如「垃圾邮件」→ &V4NXPpCuTvY-），
    直接用中文名 SELECT 会失败。因此这里从 LIST 响应中取服务端原样名称：
      - 始终包含 INBOX
      - 通过 \\Junk 特殊标志自动识别垃圾邮件文件夹（验证码邮件常被误判进此处）
      - 若显式配置了 MAIL_FOLDERS，则以配置为准（INBOX 之外的名称需自行保证可 SELECT）
    """
    configured = os.environ.get("MAIL_FOLDERS", "").strip()
    if configured:
        return [f.strip() for f in configured.split(",") if f.strip()]

    folders = ["INBOX"]
    try:
        typ, data = conn.list()
        if typ == "OK":
            for line in data:
                if not line:
                    continue
                text = line.decode("utf-8", errors="replace") if isinstance(line, bytes) else str(line)
                m = _LIST_RE.match(text.strip())
                if not m:
                    continue
                flags = m.group("flags")
                name = m.group("name").strip().strip('"')
                # 垃圾邮件箱：验证码邮件常被投递到此
                if "\\Junk" in flags and name not in folders:
                    folders.append(name)
    except Exception:
        pass
    return folders


def _select_folder(conn: imaplib.IMAP4_SSL, folder: str) -> bool:
    """选中文件夹，兼容含空格/特殊字符需要加引号的情况"""
    candidates = [folder] if folder == "INBOX" else [folder, f'"{folder}"']
    for name in candidates:
        try:
            typ, _ = conn.select(name, readonly=True)
            if typ == "OK":
                return True
        except Exception:
            continue
    return False


def _scan_folder(conn, folder: str, since_ts: float, sender_filter: str, scan_limit: int):
    """在单个文件夹中扫描验证码，返回 (code, mail_time) 或 None"""
    if not _select_folder(conn, folder):
        return None

    typ, data = conn.search(None, "ALL")
    if typ != "OK" or not data or not data[0]:
        return None

    ids = data[0].split()
    best = None
    # 从最新一封往前扫
    for mail_id in reversed(ids[-scan_limit:]):
        typ, msg_data = conn.fetch(mail_id, "(RFC822)")
        if typ != "OK" or not msg_data or not isinstance(msg_data[0], tuple):
            continue

        msg = email.message_from_bytes(msg_data[0][1])

        # 时间过滤：只认「点击获取验证码」之后到达的邮件
        try:
            mail_dt = parsedate_to_datetime(msg.get("Date"))
            mail_ts = mail_dt.timestamp()
        except Exception:
            continue
        if mail_ts < since_ts:
            continue

        sender = _decode_mime(msg.get("From"))
        subject = _decode_mime(msg.get("Subject"))
        if sender_filter and sender_filter not in sender and sender_filter not in subject:
            continue

        code = _match_code(subject) or _match_code(_extract_body(msg))
        if code and (best is None or mail_ts > best[1]):
            best = (code, mail_ts)

    return best


# =============================================================================
# 对外接口
# =============================================================================
def fetch_verification_code(since_ts: float, timeout: int = 120,
                            poll_interval: int = 5, scan_limit: int = 15) -> str:
    """
    轮询邮箱，抓取 since_ts 之后收到的最新验证码。

    :param since_ts:      起始时间戳（通常传"点击获取验证码"前一刻的时间），只认此后的邮件
    :param timeout:       最长等待秒数
    :param poll_interval: 轮询间隔秒数
    :param scan_limit:    每个文件夹扫描最近多少封邮件
    :return:              6 位验证码字符串
    :raises MailCodeError: 超时未取到或配置错误
    """
    mail_user = os.environ.get("MAIL_USER") or os.environ.get("TEST_ACCOUNT", "")
    auth_code = os.environ.get("MAIL_AUTH_CODE", "")
    sender_filter = os.environ.get("MAIL_SENDER", "").strip()

    if not mail_user or "@" not in mail_user:
        raise MailCodeError(
            "[MAIL] 未配置邮箱地址。请在 .env 中设置 MAIL_USER=your_mail@163.com"
        )
    if not auth_code:
        raise MailCodeError(
            "[MAIL] 未配置邮箱授权码。\n"
            "   阿蓁，请在 .env 中补充：MAIL_AUTH_CODE=你的163客户端授权码\n"
            "   获取方式：登录 mail.163.com → 设置 → POP3/SMTP/IMAP → 开启 IMAP 服务 → 新增授权密码"
        )

    host = os.environ.get("MAIL_IMAP_HOST") or _guess_imap_host(mail_user)
    port = int(os.environ.get("MAIL_IMAP_PORT", "993"))
    # 容忍收件端与本机之间的时钟偏差
    since_ts -= 60

    deadline = time.time() + timeout
    attempt = 0
    last_error = None
    scanned_folders = []

    while time.time() < deadline:
        attempt += 1
        remaining = int(deadline - time.time())
        print(f"   [MAIL] 第 {attempt} 次轮询邮箱验证码（剩余 {remaining}s）...")

        conn = None
        try:
            conn = _connect(host, port, mail_user, auth_code)
            scanned_folders = _resolve_folders(conn)
            for folder in scanned_folders:
                hit = _scan_folder(conn, folder, since_ts, sender_filter, scan_limit)
                if hit:
                    code = hit[0]
                    print(f"   [MAIL] 已取到验证码: {code}（来自文件夹 {folder}）")
                    return code
        except MailCodeError:
            raise  # 配置/登录类错误无需重试，直接抛出
        except Exception as exc:
            last_error = exc
            print(f"   [MAIL] 本次轮询异常（将重试）: {exc}")
        finally:
            if conn is not None:
                try:
                    conn.close()
                except Exception:
                    pass
                try:
                    conn.logout()
                except Exception:
                    pass

        time.sleep(poll_interval)

    raise MailCodeError(
        f"[MAIL] {timeout}s 内未能取到验证码邮件。\n"
        f"   邮箱: {mail_user}  服务器: {host}:{port}  已扫描文件夹: {scanned_folders}\n"
        f"   最后一次异常: {last_error}\n"
        f"   排查建议：(1) 确认验证码邮件确实已送达；(2) 检查是否落入其它文件夹，"
        f"可通过 MAIL_FOLDERS 增加；(3) 确认 MAIL_SENDER 过滤词是否过严。"
    )


def selftest():
    """独立自测：直接读取最近一封验证码邮件，用于验证 IMAP 配置是否正确"""
    print("=" * 60)
    print("邮箱 IMAP 配置自测")
    print("=" * 60)
    mail_user = os.environ.get("MAIL_USER") or os.environ.get("TEST_ACCOUNT", "")
    host = os.environ.get("MAIL_IMAP_HOST") or _guess_imap_host(mail_user)
    port = int(os.environ.get("MAIL_IMAP_PORT", "993"))
    print(f"邮箱: {mail_user}")
    print(f"服务器: {host}:{port}")

    conn = _connect(host, port, mail_user, os.environ.get("MAIL_AUTH_CODE", ""))
    print("[PASS] IMAP 登录成功")

    typ, folders = conn.list()
    print(f"可用文件夹 {len(folders)} 个：")
    for f in folders[:20]:
        print("   ", f.decode("utf-8", errors="replace"))

    targets = _resolve_folders(conn)
    print(f"实际待扫描文件夹: {targets}")

    # 放宽时间窗口，扫最近 24 小时的验证码邮件
    hit = None
    for folder in targets:
        hit = _scan_folder(conn, folder, time.time() - 86400, "", 20)
        if hit:
            print(f"[PASS] 在 {folder} 中找到验证码: {hit[0]}")
            break
    if not hit:
        print("[WARN] 最近 24 小时内未找到验证码邮件（若尚未触发发送，属正常现象）")

    conn.logout()


if __name__ == "__main__":
    from dotenv import load_dotenv
    load_dotenv()
    selftest()

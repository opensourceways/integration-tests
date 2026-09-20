#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""config_loader.py — config.yaml 统一配置加载器（替代原 .env）

设计要点:
  1. 分节 YAML → 扁平环境变量。各执行器仍读 os.environ，无需改动读取逻辑。
  2. 优先级: 真实环境变量 > config.yaml。CI 里 `-e KEY=V` 始终能覆盖文件。
  3. import 即自动加载（幂等），因此只要在读取 env 的模块顶部 import 本模块，
     模块级常量（如 ui_runner.HEADLESS）就能拿到 config.yaml 的值。
  4. email 节**不注入环境变量** —— git_runner 会把 dict(os.environ) 整体传给
     子进程，SMTP 密码不应随之外泄。用 get("email.password") 结构化读取。

用法:
  import config_loader                      # 自动加载
  config_loader.get("email.sender")         # 结构化读取（点号路径）
  config_loader.set_value("gitcode", "cookie", "...")   # 原地回写，保留注释
"""
import os
import re

try:
    import yaml
except ImportError:  # pragma: no cover - 由 requirements.txt 保证
    yaml = None

CONFIG_FILENAME = "config.yaml"

# 节名 → 环境变量前缀。前缀为 "" 的节，键名直接大写即为变量名。
_SECTION_PREFIX = {
    "gitcode": "GITCODE_",
    "phase02": "PHASE02_",
    "api": "API_",
    "ui": "UI_",
    "git": "GIT_",
    "auth": "",      # pat_token  → PAT_TOKEN
    "gate": "",      # min_execution_coverage → MIN_EXECUTION_COVERAGE
    "runtime": "",   # tz → TZ / login_timeout → LOGIN_TIMEOUT
}

# 不注入环境变量的节（含敏感凭证，仅供结构化读取）
_NO_ENV_SECTIONS = {"email"}

_LOADED_FLAG = "_CONFIG_YAML_LOADED"
_cache = None
_cache_path = None


def find_config(start=None):
    """定位 config.yaml：当前工作目录 → 本文件所在目录向上 4 级。"""
    if os.environ.get("CONFIG_FILE"):
        return os.environ["CONFIG_FILE"]

    if os.path.exists(CONFIG_FILENAME):
        return os.path.abspath(CONFIG_FILENAME)

    here = start or os.path.dirname(os.path.abspath(__file__))
    for _ in range(4):
        candidate = os.path.join(here, CONFIG_FILENAME)
        if os.path.exists(candidate):
            return candidate
        parent = os.path.dirname(here)
        if parent == here:
            break
        here = parent
    return None


def _to_env_value(value):
    """YAML 标量 → 环境变量字符串。

    bool → "1"/"0"，使现有 `os.environ.get(k) != "0"` 判断继续生效。
    list → 逗号拼接。None → ""。
    """
    if value is None:
        return ""
    if isinstance(value, bool):
        return "1" if value else "0"
    if isinstance(value, (list, tuple)):
        return ",".join(str(v) for v in value if str(v).strip())
    return str(value)


def raw(reload=False):
    """返回解析后的完整配置 dict（未找到文件时返回 {}）。"""
    global _cache, _cache_path
    if _cache is not None and not reload:
        return _cache

    path = find_config()
    _cache_path = path
    if not path or yaml is None:
        _cache = {}
        return _cache

    with open(path, encoding="utf-8") as f:
        data = yaml.safe_load(f) or {}
    _cache = data if isinstance(data, dict) else {}
    return _cache


def config_path():
    """当前生效的 config.yaml 绝对路径（未找到时为 None）。"""
    if _cache is None:
        raw()
    return _cache_path


def env_mapping(data=None):
    """配置 dict → {环境变量名: 字符串值}。"""
    data = raw() if data is None else data
    mapping = {}
    for section, body in data.items():
        if section in _NO_ENV_SECTIONS or not isinstance(body, dict):
            continue
        prefix = _SECTION_PREFIX.get(section, section.upper() + "_")
        for key, value in body.items():
            if isinstance(value, dict):
                continue
            mapping[prefix + str(key).upper()] = _to_env_value(value)
    return mapping


def load(force=False):
    """把 config.yaml 注入 os.environ。已存在的环境变量不被覆盖。

    幂等：通过 os.environ 里的标记位保证同一进程树只注入一次
    （子进程继承标记，避免重复读盘）。
    """
    if not force and os.environ.get(_LOADED_FLAG) == "1":
        return {}

    injected = {}
    for name, value in env_mapping().items():
        if force or name not in os.environ:
            os.environ[name] = value
            injected[name] = value

    os.environ[_LOADED_FLAG] = "1"
    return injected


def get(dotted, default=None):
    """按点号路径读取配置，如 get("email.sender") / get("ui.headless")。"""
    node = raw()
    for part in str(dotted).split("."):
        if not isinstance(node, dict) or part not in node:
            return default
        node = node[part]
    return default if node is None else node


def set_value(section, key, value, path=None):
    """原地更新 config.yaml 的 section.key，保留注释与其余内容。

    section 不存在则追加新节；key 不存在则追加到该节末尾。
    值统一按 YAML 双引号标量写入，避免 cookie 串里的 `:` `#` 破坏解析。
    """
    path = path or find_config()
    if not path:
        raise FileNotFoundError(f"未找到 {CONFIG_FILENAME}")

    with open(path, encoding="utf-8") as f:
        lines = f.readlines()

    literal = _dump_scalar(value)
    sec_re = re.compile(rf"^{re.escape(section)}\s*:\s*$")
    key_re = re.compile(rf"^(\s+){re.escape(key)}\s*:")

    start = next((i for i, ln in enumerate(lines) if sec_re.match(ln)), None)
    if start is None:
        lines.append(f"\n{section}:\n  {key}: {literal}\n")
    else:
        # 节的范围：直到下一个顶格非注释行
        end = len(lines)
        for i in range(start + 1, len(lines)):
            if lines[i].strip() and not lines[i][:1].isspace() \
                    and not lines[i].lstrip().startswith("#"):
                end = i
                break

        for i in range(start + 1, end):
            if key_re.match(lines[i]):
                indent = key_re.match(lines[i]).group(1)
                lines[i] = f"{indent}{key}: {literal}\n"
                break
        else:
            insert_at = end
            while insert_at > start + 1 and not lines[insert_at - 1].strip():
                insert_at -= 1
            lines.insert(insert_at, f"  {key}: {literal}\n")

    with open(path, "w", encoding="utf-8") as f:
        f.writelines(lines)

    raw(reload=True)
    return path


def _dump_scalar(value):
    """标量 → YAML 字面量。字符串一律双引号包裹并转义。"""
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    if value is None:
        return '""'
    return '"' + str(value).replace("\\", "\\\\").replace('"', '\\"') + '"'


# import 即加载
load()

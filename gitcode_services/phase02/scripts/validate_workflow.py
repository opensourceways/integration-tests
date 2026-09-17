#!/usr/bin/env python3
"""GitCode/AtomGit 工作流语法校验脚本

通过 GitCode v2 API 校验 workflow YAML 格式。
关键差异：payload 使用 file_content（非 content），且 body 需包含 workflow_id + file_path。

认证方式（优先级从高到低）：
  1. --cookie  直接传 GITCODE_COOKIE（推荐，从浏览器 F12 抓包获取）
  2. --token   传 Bearer token
  3. 环境变量 GITCODE_COOKIE 或 GITCODE_ACCESS_TOKEN
  4. 自动从项目根目录 .env 文件读取

Usage:
    python3 validate_workflow.py <yaml-file> [--cookie COOKIE] [--workflow-id ID]
    python3 validate_workflow.py <yaml-file> --auto-wf   # 自动从 API 获取 workflow_id
"""

import argparse
import base64
import json
import os
import sys

import requests


def _load_env_file(env_path: str = None) -> dict:
    """从 .env 文件加载环境变量"""
    if env_path is None:
        # 从脚本位置向上找项目根目录
        script_dir = os.path.dirname(os.path.abspath(__file__))
        for _ in range(3):
            candidate = os.path.join(script_dir, ".env")
            if os.path.exists(candidate):
                env_path = candidate
                break
            script_dir = os.path.dirname(script_dir)

    if env_path is None or not os.path.exists(env_path):
        return {}

    env_vars = {}
    with open(env_path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" in line:
                key, _, val = line.partition("=")
                key = key.strip()
                val = val.strip().strip('"').strip("'")
                env_vars[key] = val
    return env_vars


def _get_workflow_list(project_path: str, cookie: str, host: str) -> list:
    """从 API 获取项目的 workflow 列表"""
    encoded_project = project_path.replace("/", "%2F")
    url = f"https://{host}/api/v2/projects/{encoded_project}/actions/workflows/list"

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {cookie}",
        "Origin": "https://gitcode.com",
        "Referer": "https://gitcode.com/",
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36",
        "X-App-Channel": "gitcode-fe",
        "X-App-Version": "0",
        "X-Device-ID": "unknown",
        "X-Device-Type": "Linux",
        "X-Platform": "web",
        "Cookie": f"GITCODE_ACCESS_TOKEN={cookie}; GitCodeUserName=ccijunk",
    }

    try:
        resp = requests.post(url, headers=headers, json={}, timeout=10)
        data = resp.json()
        return data.get("content", [])
    except Exception as e:
        print(f"[!] 获取 workflow 列表失败: {e}", file=sys.stderr)
        return []


def validate_workflow(
    file_content: str,
    cookie: str,
    workflow_id: str,
    project_path: str = "ComputingActionTest/foundational-tests",
    file_path: str = ".gitcode/workflows/main.yml",
    host: str = "web-api.gitcode.com",
) -> dict:
    """调用 GitCode/AtomGit 工作流语法校验接口

    :param file_content: 待校验的 YAML 文本内容
    :param cookie: GITCODE_ACCESS_TOKEN cookie 值
    :param workflow_id: 工作流 ID
    :param project_path: 项目路径 (如 ComputingActionTest/foundational-tests)
    :param file_path: 文件相对路径
    :param host: API 主机地址
    :return: 接口返回的 JSON 响应字典
    """
    encoded_project = project_path.replace("/", "%2F")
    url = f"https://{host}/api/v2/projects/{encoded_project}/actions/valid"

    params = {"workflow_id": workflow_id}

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {cookie}",
        "Origin": "https://gitcode.com",
        "Referer": "https://gitcode.com/",
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36",
        "X-App-Channel": "gitcode-fe",
        "X-App-Version": "0",
        "X-Device-ID": "unknown",
        "X-Device-Type": "Linux",
        "X-Platform": "web",
        "Cookie": f"GITCODE_ACCESS_TOKEN={cookie}; GitCodeUserName=ccijunk",
    }

    encoded_content = base64.b64encode(file_content.encode("utf-8")).decode("utf-8")

    payload = {
        "workflow_id": workflow_id,
        "file_path": file_path,
        "file_content": encoded_content,
    }

    try:
        response = requests.post(
            url, params=params, headers=headers, json=payload, timeout=10
        )
        print(f"[*] HTTP {response.status_code}", file=sys.stderr)

        if "application/json" in response.headers.get("Content-Type", ""):
            return response.json()
        else:
            return {"status_code": response.status_code, "text": response.text}

    except requests.exceptions.RequestException as e:
        print(f"[!] 请求发生错误: {e}", file=sys.stderr)
        return {"error": str(e)}


def main():
    parser = argparse.ArgumentParser(description="GitCode workflow YAML 校验")
    parser.add_argument("yaml_file", help="待校验的 YAML 文件路径")
    parser.add_argument("--cookie", help="GITCODE_COOKIE (从浏览器 F12 抓包获取)")
    parser.add_argument("--token", help="Bearer token (备选认证方式)")
    parser.add_argument("--workflow-id", default="b03a4b84cd784ddea00c5270eba62c7f", help="工作流 ID")
    parser.add_argument("--auto-wf", action="store_true", help="自动从 API 获取 workflow_id（按文件名匹配）")
    parser.add_argument("--project", default="ComputingActionTest/foundational-tests", help="项目路径")
    parser.add_argument("--file-path", default=None, help="文件相对路径 (默认从 yaml_file 推导)")
    parser.add_argument("--host", default="web-api.gitcode.com", help="API 主机地址")
    args = parser.parse_args()

    # ── Resolve cookie ──────────────────────────────────
    cookie = args.cookie or os.environ.get("GITCODE_COOKIE")
    if not cookie:
        env_vars = _load_env_file()
        cookie = env_vars.get("GITCODE_COOKIE")
    if not cookie:
        print("[!] 请提供 --cookie、--token、GITCODE_COOKIE 环境变量，或在项目根目录 .env 中设置", file=sys.stderr)
        sys.exit(1)

    # ── Read YAML ───────────────────────────────────────
    with open(args.yaml_file, "r") as f:
        yaml_content = f.read()

    file_path = args.file_path or f".gitcode/workflows/{os.path.basename(args.yaml_file)}"

    # ── Resolve workflow_id ─────────────────────────────
    workflow_id = args.workflow_id
    if not workflow_id and args.auto_wf:
        wf_list = _get_workflow_list(args.project, cookie, args.host)
        basename = os.path.basename(args.yaml_file)
        for wf in wf_list:
            fp = wf.get("file_path", "")
            if fp.endswith(basename) or basename in fp:
                workflow_id = wf["workflow_id"]
                print(f"[*] 自动匹配 workflow_id: {workflow_id} ({fp})", file=sys.stderr)
                break
        if not workflow_id:
            print("[!] 未找到匹配的 workflow_id，请用 --workflow-id 指定", file=sys.stderr)
            print(f"    可用 workflows: {[w['file_path'] for w in wf_list]}", file=sys.stderr)
            sys.exit(1)

    if not workflow_id:
        print("[!] 请提供 --workflow-id 或使用 --auto-wf", file=sys.stderr)
        sys.exit(1)

    # ── Validate ────────────────────────────────────────
    result = validate_workflow(
        file_content=yaml_content,
        cookie=cookie,
        workflow_id=workflow_id,
        project_path=args.project,
        file_path=file_path,
        host=args.host,
    )

    print(json.dumps(result, ensure_ascii=False, indent=2))

    # Exit code based on validity
    if result.get("valid") is True:
        print("\n✓ VALID", file=sys.stderr)
        sys.exit(0)
    elif result.get("valid") is False:
        diagnostics = result.get("diagnostics", [])
        print(f"\n✗ INVALID — {len(diagnostics)} diagnostic(s)", file=sys.stderr)
        for d in diagnostics:
            sev = d.get("severity", "?")
            msg = d.get("message") or "(no detail)"
            rng = d.get("range", {})
            s = rng.get("start", {})
            print(f"  [{sev}] L{s.get('line','?')}:C{s.get('column','?')} — {msg}", file=sys.stderr)
        sys.exit(1)
    else:
        sys.exit(2)


if __name__ == "__main__":
    main()

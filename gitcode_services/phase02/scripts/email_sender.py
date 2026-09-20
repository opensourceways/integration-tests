#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
email_sender.py — 测试报告邮件发送模块

用法: python email_sender.py <phase02-run-id>

功能:
  - 读取测试报告 (report.md)
  - 附加 summary.json 和 junit.xml
  - 发送到 config.yaml 的 email 节配置的收件人邮箱
"""
import os
import sys
import json
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from pathlib import Path
from datetime import datetime

# 路径设置
HERE = Path(__file__).parent
PHASE02 = HERE.parent
ROOT = PHASE02.parent

sys.path.insert(0, str(HERE))
import config_loader  # noqa: E402


def load_email_config():
    """从 config.yaml 的 email 节加载邮件配置。

    email 节不注入环境变量（避免 SMTP 密码随 dict(os.environ) 传入 git
    子进程），因此这里用 config_loader 结构化读取。
    """
    config_file = config_loader.config_path()
    if not config_file:
        raise FileNotFoundError(
            f"配置文件不存在: {ROOT / 'config.yaml'}（可从 config.yaml.example 复制）")

    sender = config_loader.get("email.sender")
    password = config_loader.get("email.password")

    receivers = config_loader.get("email.receivers", [])
    if isinstance(receivers, str):
        receivers = receivers.split(",")
    receivers = [str(r).strip() for r in (receivers or []) if str(r).strip()]

    if not sender or not password or not receivers:
        raise ValueError(
            f"邮件配置不完整，请检查 {config_file} 的 email 节："
            "sender / password / receivers")

    return {
        'sender': sender,
        'password': password,
        'receivers': receivers,
        'smtp_host': config_loader.get("email.smtp_host", "smtp.163.com"),
        'smtp_port': int(config_loader.get("email.smtp_port", 465)),
        'use_ssl': bool(config_loader.get("email.use_ssl", True)),
        'enabled': config_loader.get("email.enabled", True) is not False,
    }


def parse_gate_status(report_content):
    """从报告中解析门禁状态"""
    if "⛔ BLOCKED" in report_content:
        return "BLOCKED", "⛔"
    elif "⚪ INCONCLUSIVE" in report_content:
        return "INCONCLUSIVE", "⚪"
    elif "✅ GO" in report_content:
        return "GO", "✅"
    return "UNKNOWN", "❓"


def create_email_body(run_id, report_path, summary_path):
    """创建邮件正文（HTML格式）"""
    # 读取报告内容
    with open(report_path, 'r', encoding='utf-8') as f:
        report_content = f.read()

    # 解析门禁状态
    gate_status, gate_icon = parse_gate_status(report_content)

    # 读取 summary
    summary = {}
    if os.path.exists(summary_path):
        with open(summary_path, 'r', encoding='utf-8') as f:
            summary = json.load(f)

    # 提取关键信息
    total_cases = len(summary.get('records', []))
    pass_count = sum(1 for r in summary.get('records', []) if r.get('verdict') == 'PASS')
    fail_count = sum(1 for r in summary.get('records', []) if r.get('verdict') == 'FAIL')

    # 构建HTML邮件正文
    html = f"""
    <html>
    <head>
        <style>
            body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
            .header {{ background-color: #f4f4f4; padding: 20px; text-align: center; }}
            .status-go {{ color: #28a745; font-weight: bold; }}
            .status-blocked {{ color: #dc3545; font-weight: bold; }}
            .status-inconclusive {{ color: #ffc107; font-weight: bold; }}
            .summary {{ margin: 20px 0; padding: 15px; background-color: #f9f9f9; border-left: 4px solid #007bff; }}
            .summary-item {{ margin: 10px 0; }}
            .footer {{ margin-top: 30px; padding-top: 15px; border-top: 1px solid #ddd; font-size: 12px; color: #666; }}
        </style>
    </head>
    <body>
        <div class="header">
            <h1>GitCode Actions 测试报告</h1>
            <h2>{gate_icon} 门禁状态: <span class="status-{gate_status.lower()}">{gate_status}</span></h2>
        </div>

        <div class="summary">
            <h3>执行摘要</h3>
            <div class="summary-item"><strong>Run ID:</strong> {run_id}</div>
            <div class="summary-item"><strong>执行时间:</strong> {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</div>
            <div class="summary-item"><strong>总用例数:</strong> {total_cases}</div>
            <div class="summary-item"><strong>通过:</strong> <span style="color: #28a745;">{pass_count}</span></div>
            <div class="summary-item"><strong>失败:</strong> <span style="color: #dc3545;">{fail_count}</span></div>
        </div>

        <div>
            <h3>详细报告</h3>
            <p>完整的测试报告已作为附件发送，请查看附件中的以下文件：</p>
            <ul>
                <li><strong>report.md</strong> - Markdown格式测试报告</li>
                <li><strong>summary.json</strong> - JSON格式汇总数据</li>
                <li><strong>junit.xml</strong> - JUnit格式测试结果（如有）</li>
            </ul>
        </div>

        <div class="footer">
            <p>本邮件由 GitCode Integration Tests 自动生成</p>
            <p>报告路径: phase02/reports/{run_id}/</p>
        </div>
    </body>
    </html>
    """

    return html, gate_status


def send_email(config, run_id, report_path, summary_path, junit_path):
    """发送邮件"""
    sender = config['sender']
    password = config['password']
    receivers = config['receivers']

    # 创建邮件
    msg = MIMEMultipart()
    msg['From'] = sender
    msg['To'] = ', '.join(receivers)

    # 创建邮件正文
    html_body, gate_status = create_email_body(run_id, report_path, summary_path)

    # 设置邮件主题
    subject = f"[{gate_status}] GitCode 测试报告 - {run_id}"
    msg['Subject'] = subject

    # 添加HTML正文
    msg.attach(MIMEText(html_body, 'html', 'utf-8'))

    # 附加 report.md
    if os.path.exists(report_path):
        with open(report_path, 'rb') as f:
            part = MIMEBase('application', 'octet-stream')
            part.set_payload(f.read())
            encoders.encode_base64(part)
            part.add_header('Content-Disposition', f'attachment; filename=report.md')
            msg.attach(part)

    # 附加 summary.json
    if os.path.exists(summary_path):
        with open(summary_path, 'rb') as f:
            part = MIMEBase('application', 'json')
            part.set_payload(f.read())
            encoders.encode_base64(part)
            part.add_header('Content-Disposition', f'attachment; filename=summary.json')
            msg.attach(part)

    # 附加 junit.xml (如果存在)
    if junit_path and os.path.exists(junit_path):
        with open(junit_path, 'rb') as f:
            part = MIMEBase('application', 'xml')
            part.set_payload(f.read())
            encoders.encode_base64(part)
            part.add_header('Content-Disposition', f'attachment; filename=junit.xml')
            msg.attach(part)

    # 发送邮件
    try:
        # SMTP 服务器来自 config.yaml 的 email 节
        smtp_server = config.get('smtp_host', 'smtp.163.com')
        smtp_port = int(config.get('smtp_port', 465))

        print(f"正在连接到邮件服务器 {smtp_server}:{smtp_port}...")
        if config.get('use_ssl', True):
            server = smtplib.SMTP_SSL(smtp_server, smtp_port)
        else:
            server = smtplib.SMTP(smtp_server, smtp_port)
            server.starttls()
        server.login(sender, password)

        print(f"正在发送邮件到: {', '.join(receivers)}")
        server.sendmail(sender, receivers, msg.as_string())
        server.quit()

        print(f"✅ 邮件发送成功！")
        print(f"   收件人: {', '.join(receivers)}")
        print(f"   主题: {subject}")
        return True

    except Exception as e:
        print(f"❌ 邮件发送失败: {e}")
        return False


def main():
    if len(sys.argv) < 2:
        print("用法: python email_sender.py <phase02-run-id>")
        sys.exit(2)

    run_id = sys.argv[1]

    # 检查报告文件
    report_dir = PHASE02 / "reports" / run_id
    report_path = report_dir / "report.md"
    summary_path = report_dir / "summary.json"
    junit_path = PHASE02 / "runs" / run_id / "junit.xml"

    if not report_path.exists():
        print(f"❌ 报告文件不存在: {report_path}")
        sys.exit(1)

    print(f"=== GitCode 测试报告邮件发送 ===")
    print(f"Run ID: {run_id}")
    print(f"报告路径: {report_path}")

    try:
        # 加载邮件配置
        config = load_email_config()
        if not config['enabled']:
            print("ℹ️  email.enabled 为 false，跳过发送")
            sys.exit(0)
        print(f"发件人: {config['sender']}")
        print(f"收件人: {', '.join(config['receivers'])}")
        print()

        # 发送邮件
        success = send_email(config, run_id, report_path, summary_path, junit_path)

        if success:
            sys.exit(0)
        else:
            sys.exit(1)

    except Exception as e:
        print(f"❌ 错误: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()


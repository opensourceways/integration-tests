#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
调试工具：日志、快照、DOM 结构提取

从 phase1_probe.py 迁移的 log() / dump() 函数，保持原有接口不变。
"""

import json
import time
from common.constants import OUT_DIR


def log(msg: str) -> None:
    """输出带时间戳的日志"""
    print(f"[{time.strftime('%H:%M:%S')}] {msg}", flush=True)


# ============================================================================
# DOM 结构提取（在浏览器内执行）
# ============================================================================
JS_EXTRACT = r"""
() => {
  const vis = e => {
    const r = e.getBoundingClientRect();
    return r.width > 0 && r.height > 0 && getComputedStyle(e).visibility !== 'hidden';
  };
  const txt = e => (e.innerText || e.textContent || '').trim().replace(/\s+/g, ' ').slice(0, 120);

  // 输入框：重点记录 id 是否随机、placeholder、maxlength
  const inputs = [...document.querySelectorAll('input, textarea')].map(e => ({
    tag: e.tagName.toLowerCase(), type: e.type || '', id: e.id || '',
    name: e.name || '', cls: e.className || '', placeholder: e.placeholder || '',
    maxlength: e.getAttribute('maxlength') || '', readonly: e.readOnly,
    disabled: e.disabled, value: (e.value || '').slice(0, 40), visible: vis(e),
  }));

  // 按钮：文案 + 禁用态（断言 disabled 逻辑要用）
  const buttons = [...document.querySelectorAll('button, [role=button], .o-button')].map(e => ({
    text: txt(e), cls: e.className || '', disabled: e.disabled === true ||
      e.getAttribute('aria-disabled') === 'true' || /disabled/.test(e.className),
    visible: vis(e),
  })).filter(b => b.visible);

  // 表格：表头文案 + 前 3 行单元格
  const tables = [...document.querySelectorAll('table')].map(t => ({
    cls: t.className || '',
    headers: [...t.querySelectorAll('thead th, thead td')].map(txt),
    rows: [...t.querySelectorAll('tbody tr')].slice(0, 3).map(
      tr => [...tr.querySelectorAll('td')].map(txt)),
    rowCount: t.querySelectorAll('tbody tr').length,
  }));

  // 复选框 / 单选框
  const checks = [...document.querySelectorAll('.o-checkbox, [class*=checkbox]')]
    .filter(vis).map(e => ({ cls: e.className || '', text: txt(e) })).slice(0, 30);

  // 下拉选择器
  const selects = [...document.querySelectorAll('select, .o-select, [class*=select]')]
    .filter(vis).map(e => ({ tag: e.tagName.toLowerCase(), cls: e.className || '', text: txt(e) })).slice(0, 20);

  // 弹窗 / 遮罩
  const dialogs = [...document.querySelectorAll(
    '.o-dialog, [role=dialog], .verifybox, [class*=modal], [class*=dialog]')]
    .filter(vis).map(e => ({ cls: e.className || '', text: txt(e) }));

  // 链接
  const links = [...document.querySelectorAll('a')].filter(vis).map(e => ({
    text: txt(e), href: e.getAttribute('href') || '', target: e.target || '',
  })).filter(a => a.text).slice(0, 40);

  // 业务语义容器是否存在（校正阶段1文档的核心）
  const probe = {};
  for (const sel of ['.private-token-list', '.private-token-head', '.create-token-tip',
                     '.create-or-edit-token', '.form-checkboxgroup', '.custom-day',
                     '.purview-item', '.o-table', '.o-pagination', '.o-message',
                     '.form-input', '.token-auth', '.created-token-tip',
                     '.permission-name', '.permission-description', '.form-item-extra',
                     '.o-form-item', '.o-option', '.verifybox']) {
    const n = document.querySelectorAll(sel);
    probe[sel] = { count: n.length, visible: [...n].filter(vis).length };
  }

  return { url: location.href, title: document.title,
           inputs, buttons, tables, checks, selects, dialogs, links, probe,
           bodyText: (document.body.innerText || '').replace(/\n{2,}/g, '\n').slice(0, 3000) };
}
"""


def dump(page, tag: str) -> dict:
    """抓取当前页面结构快照：截图 + HTML + 结构化 JSON"""
    log(f"  抓取快照 [{tag}] ...")
    try:
        page.screenshot(path=str(OUT_DIR / f"{tag}.png"), full_page=True)
    except Exception as exc:
        log(f"  截图失败（忽略）: {exc}")
    data = page.evaluate(JS_EXTRACT)
    (OUT_DIR / f"{tag}.json").write_text(
        json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    (OUT_DIR / f"{tag}.html").write_text(page.content(), encoding="utf-8")
    log(f"  [{tag}] title={data['title']!r} url={data['url']}")
    return data

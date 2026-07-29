"""
阶段1：页面结构分析脚本
使用Playwright访问目标页面并输出完整结构信息
"""
from playwright.sync_api import sync_playwright, TimeoutError as PlaywrightTimeoutError
import json
import os
import sys
from datetime import datetime

# 解决Windows GBK编码问题
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)))
URL = "https://openeuler.test.osinfra.cn/zh/sig/meeting-guide"

def log(msg):
    print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}", flush=True)

def save_json(data, filename):
    path = os.path.join(OUTPUT_DIR, filename)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    log(f"[OK] 已保存: {path}")

def main():
    log("启动浏览器并访问页面...")
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(
                headless=False,  # 有头模式
                args=["--no-sandbox", "--disable-dev-shm-usage"]
            )
            context = browser.new_context(
                viewport={"width": 1920, "height": 1080},
                locale="zh-CN"
            )
            page = context.new_page()
            page.set_default_timeout(30000)  # 30s全局超时

            # 1. 访问页面并等待加载
            log(f"[INFO] 正在导航至: {URL}")
            try:
                response = page.goto(URL, wait_until="networkidle", timeout=30000)
                log(f"[OK] 页面加载完成，HTTP状态: {response.status if response else 'N/A'}")
            except PlaywrightTimeoutError:
                log("[WARN] 等待networkidle超时，尝试继续等待DOM加载...")
                page.goto(URL, wait_until="domcontentloaded", timeout=30000)

            # 等待几秒确保动态内容渲染
            page.wait_for_timeout(2000)

            # 2. 基础信息
            title = page.title()
            url = page.url
            log(f"[OK] 页面标题: {title}")
            log(f"[OK] 当前URL: {url}")

            # 3. 截图保存
            screenshot_path = os.path.join(OUTPUT_DIR, "page_screenshot.png")
            page.screenshot(path=screenshot_path, full_page=True)
            log(f"[OK] 截图已保存: {screenshot_path}")

            # 4. 提取页面可见元素（通过JS扫描）
            elements_info = page.evaluate("""
                () => {
                    const data = {
                        interactiveElements: [],
                        forms: [],
                        headings: [],
                        links: [],
                        tables: [],
                        modals: [],
                        textContents: []
                    };

                    // 交互元素：按钮、输入框、下拉框、文本域
                    document.querySelectorAll('button, input, select, textarea, a[href], [role="button"]').forEach((el, idx) => {
                        const tag = el.tagName.toLowerCase();
                        const type = el.type || '';
                        const text = (el.innerText || el.value || el.placeholder || el.getAttribute('aria-label') || '').substring(0, 100);
                        const id = el.id || '';
                        const cls = Array.from(el.classList).slice(0, 5).join(' ');
                        const name = el.name || '';

                        data.interactiveElements.push({
                            index: idx,
                            tag: tag,
                            type: type,
                            text: text,
                            id: id,
                            className: cls,
                            name: name,
                            visible: el.offsetParent !== null || el.getBoundingClientRect().width > 0
                        });
                    });

                    // 表单
                    document.querySelectorAll('form').forEach((form, idx) => {
                        const inputs = Array.from(form.querySelectorAll('input, select, textarea, button')).map(inp => ({
                            tag: inp.tagName.toLowerCase(),
                            type: inp.type || '',
                            name: inp.name || '',
                            id: inp.id || '',
                            className: Array.from(inp.classList).slice(0, 3).join(' '),
                            text: (inp.innerText || inp.value || inp.placeholder || '').substring(0, 50)
                        }));
                        data.forms.push({
                            index: idx,
                            action: form.action || '',
                            method: form.method || '',
                            id: form.id || '',
                            className: Array.from(form.classList).slice(0, 3).join(' '),
                            inputs: inputs
                        });
                    });

                    // 标题
                    document.querySelectorAll('h1, h2, h3, h4').forEach(el => {
                        data.headings.push({
                            tag: el.tagName.toLowerCase(),
                            text: el.innerText.substring(0, 100),
                            id: el.id || ''
                        });
                    });

                    // 表格
                    document.querySelectorAll('table').forEach((tbl, idx) => {
                        const rows = tbl.querySelectorAll('tr').length;
                        const cols = tbl.querySelectorAll('th, td').length;
                        data.tables.push({
                            index: idx,
                            rows: rows,
                            cols: cols,
                            id: tbl.id || '',
                            className: Array.from(tbl.classList).slice(0, 3).join(' '),
                            caption: tbl.querySelector('caption')?.innerText?.substring(0, 50) || ''
                        });
                    });

                    // 弹窗/模态框（常见class标识）
                    document.querySelectorAll('[class*="modal"], [class*="dialog"], [class*="popup"], [class*="overlay"], [role="dialog"]').forEach((el, idx) => {
                        data.modals.push({
                            index: idx,
                            tag: el.tagName.toLowerCase(),
                            className: Array.from(el.classList).slice(0, 5).join(' '),
                            id: el.id || '',
                            visible: window.getComputedStyle(el).display !== 'none' && window.getComputedStyle(el).visibility !== 'hidden',
                            text: el.innerText.substring(0, 100)
                        });
                    });

                    // 关键文本段落
                    document.querySelectorAll('p, div, section, article').forEach(el => {
                        const text = el.innerText?.trim().substring(0, 200);
                        if (text && text.length > 20 && text.length < 200) {
                            data.textContents.push({
                                tag: el.tagName.toLowerCase(),
                                text: text,
                                className: Array.from(el.classList).slice(0, 3).join(' ')
                            });
                        }
                    });

                    // 限制textContents数量
                    data.textContents = data.textContents.slice(0, 20);

                    return data;
                }
            """)

            # 为交互元素补充HTML片段
            for i, el in enumerate(elements_info.get('interactiveElements', [])):
                try:
                    locator = page.locator('button, input, select, textarea, a[href], [role="button"]').nth(i)
                    html = locator.evaluate("el => el.outerHTML.substring(0, 200)")
                    el['outerHTML'] = html
                except Exception as e:
                    el['outerHTML'] = f"[获取失败: {e}]"

            # 5. 保存JSON报告
            report = {
                "url": url,
                "title": title,
                "analysisTime": datetime.now().isoformat(),
                "elements": elements_info
            }
            save_json(report, "page_analysis.json")

            # 6. 在控制台输出精简分析
            log("\n========== 页面结构分析报告 ==========")
            log(f"[页面标题] {title}")
            log(f"[当前URL] {url}")
            log(f"\n[交互元素数量] {len(elements_info.get('interactiveElements', []))}")
            for e in elements_info.get('interactiveElements', [])[:20]:
                vis = "[可见]" if e.get('visible') else "[隐藏]"
                log(f"  [{e['index']}] <{e['tag']} type='{e['type']}'> text='{e['text']}' class='{e['className']}' id='{e['id']}' {vis}")

            log(f"\n[表单数量] {len(elements_info.get('forms', []))}")
            for f in elements_info.get('forms', []):
                log(f"  Form[{f['index']}] action={f['action']} method={f['method']} id={f['id']}")
                for inp in f['inputs']:
                    log(f"    L- <{inp['tag']} type='{inp['type']}' name='{inp['name']}' id='{inp['id']}'>")

            log(f"\n[表格数量] {len(elements_info.get('tables', []))}")
            for t in elements_info.get('tables', []):
                log(f"  Table[{t['index']}] {t['rows']}行 x {t['cols']}列 id={t['id']}")

            log(f"\n[弹窗/模态框数量] {len(elements_info.get('modals', []))}")
            for m in elements_info.get('modals', []):
                vis = "[可见]" if m.get('visible') else "[隐藏]"
                log(f"  Modal[{m['index']}] <{m['tag']}> class='{m['className']}' {vis} text='{m['text']}'")

            log(f"\n[标题层级]")
            for h in elements_info.get('headings', []):
                log(f"  <{h['tag']}> {h['text']}")

            log("\n========== 分析结束，浏览器关闭 ==========")
            browser.close()

    except PlaywrightTimeoutError as e:
        log(f"[FAIL] 浏览器操作超时: {e}")
    except Exception as e:
        log(f"[FAIL] 发生异常: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()

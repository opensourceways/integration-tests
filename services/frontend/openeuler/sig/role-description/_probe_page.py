import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.resolve()))

from playwright.sync_api import sync_playwright, TimeoutError as PlaywrightTimeout

TARGET_URL = "https://openeuler.test.osinfra.cn/zh/sig/role-description"
TIMEOUT_MS = 30000

result = {
    "success": False,
    "url": TARGET_URL,
    "title": None,
    "error": None,
    "elements": {
        "inputs": [],
        "buttons": [],
        "links": [],
        "selects": [],
        "textareas": [],
        "forms": [],
        "tables": [],
        "nav_items": [],
        "bread_crumbs": [],
        "modals": [],
        "checkboxes": [],
        "radios": [],
    },
    "page_sections": [],
    "screenshot_path": "test/screenshot_probe.png",
}

try:
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)
        context = browser.new_context(viewport={"width": 1920, "height": 1080})
        page = context.new_page()

        # 访问目标URL，等待网络空闲
        page.goto(TARGET_URL, wait_until="networkidle", timeout=TIMEOUT_MS)

        result["success"] = True
        result["title"] = page.title()
        result["current_url"] = page.url

        # 提取输入框
        inputs = page.query_selector_all("input")
        for i, el in enumerate(inputs):
            info = {
                "index": i,
                "type": el.get_attribute("type") or "text",
                "name": el.get_attribute("name"),
                "id": el.get_attribute("id"),
                "placeholder": el.get_attribute("placeholder"),
                "class": el.get_attribute("class"),
                "visible": el.is_visible(),
            }
            result["elements"]["inputs"].append(info)

        # 提取按钮
        buttons = page.query_selector_all("button, input[type='submit'], input[type='button']")
        for i, el in enumerate(buttons):
            result["elements"]["buttons"].append({
                "index": i,
                "tag": el.evaluate("el => el.tagName.toLowerCase()"),
                "type": el.get_attribute("type"),
                "text": el.inner_text().strip()[:100] if el.is_visible() else None,
                "id": el.get_attribute("id"),
                "class": el.get_attribute("class"),
                "visible": el.is_visible(),
            })

        # 提取链接
        links = page.query_selector_all("a")
        for i, el in enumerate(links):
            href = el.get_attribute("href")
            text = el.inner_text().strip()[:100]
            if text or href:
                result["elements"]["links"].append({
                    "index": i,
                    "text": text,
                    "href": href,
                    "id": el.get_attribute("id"),
                    "class": el.get_attribute("class"),
                    "visible": el.is_visible(),
                })

        # 提取下拉框
        selects = page.query_selector_all("select")
        for i, el in enumerate(selects):
            options = el.query_selector_all("option")
            result["elements"]["selects"].append({
                "index": i,
                "name": el.get_attribute("name"),
                "id": el.get_attribute("id"),
                "class": el.get_attribute("class"),
                "option_count": len(options),
                "visible": el.is_visible(),
            })

        # 提取文本域
        textareas = page.query_selector_all("textarea")
        for i, el in enumerate(textareas):
            result["elements"]["textareas"].append({
                "index": i,
                "name": el.get_attribute("name"),
                "id": el.get_attribute("id"),
                "placeholder": el.get_attribute("placeholder"),
                "class": el.get_attribute("class"),
                "visible": el.is_visible(),
            })

        # 提取表单
        forms = page.query_selector_all("form")
        for i, el in enumerate(forms):
            result["elements"]["forms"].append({
                "index": i,
                "action": el.get_attribute("action"),
                "method": el.get_attribute("method"),
                "id": el.get_attribute("id"),
                "class": el.get_attribute("class"),
                "visible": el.is_visible(),
            })

        # 提取表格
        tables = page.query_selector_all("table")
        for i, el in enumerate(tables):
            headers = el.query_selector_all("th")
            rows = el.query_selector_all("tr")
            result["elements"]["tables"].append({
                "index": i,
                "header_texts": [h.inner_text().strip() for h in headers],
                "row_count": len(rows),
                "visible": el.is_visible(),
            })

        # 提取导航
        navs = page.query_selector_all("nav, .nav, .navbar, [class*='nav']")
        for i, el in enumerate(navs):
            text = el.inner_text().strip()[:200]
            if text:
                result["elements"]["nav_items"].append({
                    "index": i,
                    "text_preview": text,
                    "class": el.get_attribute("class"),
                    "visible": el.is_visible(),
                })

        # 面包屑
        crumbs = page.query_selector_all("[class*='breadcrumb'], [class*='bread-crumb'], .breadcrumb, [aria-label*='breadcrumb']")
        for i, el in enumerate(crumbs):
            result["elements"]["bread_crumbs"].append({
                "index": i,
                "text": el.inner_text().strip()[:200],
                "class": el.get_attribute("class"),
                "visible": el.is_visible(),
            })

        # 模态框/弹窗检测
        modals = page.query_selector_all("[class*='modal'], [class*='dialog'], [class*='popup'], [role='dialog']")
        for i, el in enumerate(modals):
            result["elements"]["modals"].append({
                "index": i,
                "text_preview": el.inner_text().strip()[:200],
                "class": el.get_attribute("class"),
                "visible": el.is_visible(),
            })

        # 复选框和单选框
        checkboxes = page.query_selector_all("input[type='checkbox']")
        for i, el in enumerate(checkboxes):
            result["elements"]["checkboxes"].append({
                "index": i,
                "name": el.get_attribute("name"),
                "id": el.get_attribute("id"),
                "visible": el.is_visible(),
            })

        radios = page.query_selector_all("input[type='radio']")
        for i, el in enumerate(radios):
            result["elements"]["radios"].append({
                "index": i,
                "name": el.get_attribute("name"),
                "id": el.get_attribute("id"),
                "visible": el.is_visible(),
            })

        # 页面主要区域划分
        sections = page.query_selector_all("header, main, section, article, footer, aside, div[role='main']")
        for i, el in enumerate(sections):
            tag = el.evaluate("el => el.tagName.toLowerCase()")
            role = el.get_attribute("role")
            cls = el.get_attribute("class")
            id_attr = el.get_attribute("id")
            text_preview = el.inner_text().strip()[:150]
            result["page_sections"].append({
                "index": i,
                "tag": tag,
                "role": role,
                "id": id_attr,
                "class": cls,
                "text_preview": text_preview,
                "visible": el.is_visible(),
            })

        # 截图保存
        page.screenshot(path=result["screenshot_path"], full_page=True)

        browser.close()

except PlaywrightTimeout as e:
    result["error"] = f"页面加载超时: {str(e)}"
except Exception as e:
    result["error"] = f"异常: {type(e).__name__}: {str(e)}"

# 输出JSON
print(json.dumps(result, ensure_ascii=False, indent=2))

# Python 脚本输出规范

本文档定义 test-case-generator skill 在 **Python 模式**（用户消息含 pytest / py 文件 / 转 py 等触发词）下生成 `.py` 文件的强制规范。

**Python 模式与 Markdown 模式互斥**：
- 触发 Python 模式时，**只输出一个 .py 文件**，不再生成任何 .md 文件
- 用例的「8 字段 + agent-exec 等价语义」由 skill 在内部完成设计，但最终只写入 `.py` 的 docstring 与代码注释中（不另产 Markdown）
- 对话回复中可输出本轮用例统计与覆盖矩阵摘要，但不复制 Markdown 用例表

## 设计目标

1. **一文件交付**：单个 `.py` 文件覆盖全部用例，pytest 可直接发现执行
2. **形态共存**：可自动化用例 = pytest 函数；不可自动化用例 = Python 注释块。两类按用例 ID 顺序保留在同一文件
3. **从内部用例设计直接映射**：内部按 8 字段 + agent-exec 语义设计后，直接转译为 Python，不做主观重构
4. **可读 + 可改**：保留中文用例标题与维度标识；占位符用环境变量，便于团队接手
5. **信息无损**：原本会写入 Markdown 表格的字段（用例ID、维度、优先级、前置条件、操作步骤、预期结果），全部写入函数 docstring 或注释块

## 文件骨架

```python
"""
测试用例脚本：<项目/模块名>

来源：<输入文档，如 PRD 路径 / 接口文档 / jmx 脚本>
用例总数：N | 自动化：A | 手工：M
生成工具：test-case-generator skill（Python 模式，不产 Markdown）

依赖：
    pip install pytest requests pytest-dependency
    # UI 用例额外：pip install playwright && playwright install chromium

执行：
    pytest -v <本文件名>                       # 执行全部自动化用例
    pytest -v <本文件名> -k LOGIN              # 按模块执行
    pytest -v <本文件名> -m "not manual"      # 跳过手工标记

占位符（执行前由环境变量注入）：
    TOKEN          —— 登录后的 access token，由 conftest 的 login fixture 自动注入
    PASSWORD       —— 测试账号密码
    USER_INPUT_*   —— 依赖用例产物（如 meeting_id），由前序 fixture/上一条用例 capture

待人工执行：
    全文件中所有 # === [SKIP-MANUAL] === 注释块需人工执行后回写结果
"""

import os
import pytest
import requests

# ===== 模块级常量 =====
BASE_AUTH = "https://usercenter.openubmc.test.osinfra.cn"
BASE_API = "https://openubmc-website.test.osinfra.cn"

# ===== 占位符注入 =====
TOKEN = os.environ.get("TOKEN", "")           # 由 conftest 或 fixture 注入
PASSWORD = os.environ.get("PASSWORD", "")     # 用户必填


# ===== 共享 fixture =====

@pytest.fixture(scope="session")
def auth_token():
    """登录获取 token，作为大多数用例的前置依赖"""
    resp = requests.post(
        f"{BASE_AUTH}/oneid/login",
        json={"permission": "sigRead", "account": "levi3053",
              "client_id": "672b25d8b92861baa16ce1e3",
              "password": PASSWORD, "oneidPrivacyAccepted": "20240830"},
        headers={"Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200, f"login failed: {resp.status_code}"
    token = resp.json().get("token")
    assert token and len(token) >= 16, "token 缺失或长度异常"
    return token


# ===== 用例 ===============================================================

# --- 模块 A：登录 -----------------------------------------------------------

def test_tc_api_login_001_normal_flow():
    """
    TC-API-LOGIN-001 [正常流] 合法账号密码登录返回 token
    维度：正常流 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_AUTH}/oneid/login",
        json={
            "permission": "sigRead",
            "account": "levi3053",
            "client_id": "672b25d8b92861baa16ce1e3",
            "password": PASSWORD,
            "oneidPrivacyAccepted": "20240830",
        },
        headers={"Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("token"), "token 为空"
    assert isinstance(body["token"], str)
    assert len(body["token"]) >= 16


# === TC-UI-LOGIN-099 [SKIP-MANUAL] ===========================================
# 用例标题：[正常流] 登录页拖拽滑块验证码后可成功登录
# 维度：正常流 | 优先级：P1
# 不可自动化原因：依赖人工拖拽滑块（行为风控），自动化脚本无法稳定通过
# 人工执行步骤：
#   1. 浏览器打开 https://app.example.com/login
#   2. 输入账号 levi3053 / 密码 <PASSWORD>
#   3. 拖动滑块至缺口完全对齐
#   4. 点击【登录】
# 预期结果：
#   1. 接口 POST /oneid/login 返回 200，body.token 非空
#   2. 跳转至 /dashboard
#   3. 顶部显示账号头像
# ============================================================================


# --- 模块 B：会议 -----------------------------------------------------------

@pytest.mark.dependency(name="create_meeting")
def test_tc_api_meeting_004_create_normal(auth_token):
    """
    TC-API-MEETING-004 [正常流] 创建 T+2 单次会议返回 meeting_id
    维度：正常流 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_API}/api-meeting/v1/meeting/",
        json={
            "is_record": False, "agenda": "测试内容", "email_list": "",
            "platform": "WELINK", "topic": "测试会议",
            "group_name": "infrastructrue",
            "etherpad": "https://etherpad.openubmc.cn/p/infrastructrue",
            "date": "2026-05-25", "start": "08:00",
            "time": "08:00-08:15", "end": "08:15",
        },
        headers={"token": auth_token, "Content-Type": "application/json;charset=UTF-8"},
        timeout=10,
    )
    assert resp.status_code in (200, 201)
    body = resp.json()
    assert isinstance(body.get("data"), int) and body["data"] >= 0
    pytest.shared_meeting_id = body["data"]   # 跨用例传递


@pytest.mark.dependency(depends=["create_meeting"])
def test_tc_api_meeting_012_modify(auth_token):
    """
    TC-API-MEETING-012 [正常流] 修改已存在会议
    维度：正常流 | 优先级：P0
    """
    meeting_id = getattr(pytest, "shared_meeting_id", None)
    if not meeting_id:
        pytest.skip("依赖用例未产出 meeting_id")
    resp = requests.put(
        f"{BASE_API}/api-meeting/v1/meeting/{meeting_id}/",
        json={
            "topic": "测试会议",
            "etherpad": "https://etherpad.openubmc.cn/p/infrastructrue",
            "date": "2026-05-26", "start": "08:00", "end": "08:15",
            "agenda": "测试内容", "is_record": False,
        },
        headers={"token": auth_token, "Content-Type": "application/json;charset=UTF-8"},
        timeout=10,
    )
    assert resp.status_code == 200


if __name__ == "__main__":
    pytest.main(["-v", __file__])
```

## agent-exec → Python 映射规则（接口用例）

| agent-exec 字段 | Python 实现 |
|---|---|
| `type: api` | 用 `requests` 库 |
| `tool: curl` | `requests.<method>(...)` |
| `request.method` | requests.post / get / put / delete / patch |
| `request.url` | URL 字符串；含 `{{inputs.x}}` 时改用 f-string + 变量 |
| `request.headers` | dict 传入 `headers=` |
| `request.body` | dict 传入 `json=`（默认 application/json） |
| `request.query_params` | dict 传入 `params=` |
| `request.timeout_ms` | 转秒后传 `timeout=` |
| `assertions[].http_status: 200` | `assert resp.status_code == 200` |
| `assertions[].http_status: {in: [...]}` | `assert resp.status_code in [...]` |
| `assertions[].jsonpath: $.field, equals: x` | `assert resp.json()["field"] == x` |
| `assertions[].jsonpath: ..., not_empty: true` | `assert resp.json()["field"]` |
| `assertions[].jsonpath: ..., type: string` | `assert isinstance(resp.json()["field"], str)` |
| `assertions[].jsonpath: ..., min_length: N` | `assert len(resp.json()["field"]) >= N` |
| `assertions[].jsonpath: ..., contains: "x"` | `assert "x" in resp.json()["field"]` |
| `assertions[].jsonpath: ..., gte: 0` | `assert resp.json()["field"] >= 0` |
| `assertions[].jsonpath: $[?(...)]` 数组过滤 | 改写为 Python 列表推导 |
| `capture_as.key: $.path` | `pytest.shared_<key> = resp.json()["path"]` |
| `depends_on: [TC-X-001]` | `@pytest.mark.dependency(depends=["TC-X-001"])` |
| `inputs.x: '{{USER_INPUT_x}}'` | 函数参数或 fixture |
| `steps[]` 数组（多步用例） | 单个测试函数内多次 requests 调用，用本地变量传递 |
| `- action: wait, timeout_ms: 12000` | `time.sleep(12)` |

## agent-exec → Python 映射规则（UI 用例）

使用 `playwright.sync_api`：

```python
from playwright.sync_api import sync_playwright


@pytest.fixture(scope="function")
def page():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(viewport={"width": 1280, "height": 800})
        yield ctx.new_page()
        browser.close()


def test_tc_ui_login_001_normal_flow(page):
    """TC-UI-LOGIN-001 [正常流] 合法账号密码可登录成功"""
    page.goto("https://app.example.com/login")
    page.fill('input[name="account"]', "test001@example.com")
    page.fill('input[name="password"]', "Test@1234")
    page.click('button:has-text("登录")')
    page.wait_for_url("**/dashboard", timeout=5000)
    assert "dashboard" in page.url
    assert page.locator("header").inner_text().__contains__("test001")
```

| agent-exec action | playwright sync 调用 |
|---|---|
| `navigate, url: X` | `page.goto(X)` |
| `fill, selector, value` | `page.fill(selector, value)` |
| `click, selector` | `page.click(selector)` |
| `select, selector, value` | `page.select_option(selector, value)` |
| `check, selector` | `page.check(selector)` |
| `hover, selector` | `page.hover(selector)` |
| `press_key, key` | `page.keyboard.press(key)` |
| `upload, selector, file_path` | `page.set_input_files(selector, file_path)` |
| `wait_for_url, url_contains, timeout_ms` | `page.wait_for_url(f"**/{url_contains}**", timeout=...)` |
| `wait_for_selector, selector, state` | `page.wait_for_selector(selector, state=state)` |
| `screenshot, name` | `page.screenshot(path=f"{name}.png")` |
| `evaluate, script` | `page.evaluate(script)` |
| `wait, timeout_ms` | `page.wait_for_timeout(ms)` |

| agent-exec assertion.type | playwright 实现 |
|---|---|
| `url, equals/contains` | `assert page.url == X` / `assert "X" in page.url` |
| `text_visible, selector, contains` | `assert "X" in page.locator(selector).inner_text()` |
| `element_state, state: disabled` | `assert page.locator(selector).is_disabled()` |
| `element_state, state: visible` | `assert page.locator(selector).is_visible()` |
| `storage, key, not_empty` | `assert page.evaluate(f"localStorage.getItem('{key}')")` |
| `attribute, attribute, equals` | `assert page.locator(selector).get_attribute(attr) == X` |
| `count, equals` | `assert page.locator(selector).count() == N` |
| `network, url_contains, response_status` | 用 `page.expect_response(...)` 上下文管理器包裹点击动作 |

## 不可自动化用例的注释块格式

固定 4 段，对齐易读：

```
# === <用例ID> [SKIP-MANUAL] =================================================
# 用例标题：<原 markdown 中的标题>
# 维度：<维度标识> | 优先级：<P0-P3>
# 不可自动化原因：<具体原因>
# 人工执行步骤：
#   1. <步骤 1>
#   2. <步骤 2>
#   ...
# 预期结果：
#   1. <预期 1>
#   2. <预期 2>
#   ...
# ============================================================================
```

注释块**不**用 `def test_xxx()` 包裹（避免被 pytest 误执行），仅以 `# ===` 开闭标记块边界。

### 「不可自动化」的常见原因措辞

- 依赖人工感知（"页面美观" "操作流畅" "颜色和谐"）
- 依赖人工动作（拖拽滑块、人脸识别、指纹、扫码）
- 依赖外部真实触达（真实短信、真实邮件、真实支付回调；除非有 mock）
- 依赖运维操作（修改 ConfigMap、重启服务、切换灰度、修改配置文件）
- 依赖第三方系统（Prometheus 面板可读性、Grafana 视觉对比）
- 依赖物理设备（IoT 硬件信号、摄像头实拍）
- 信息不足（预期结果模糊，无可量化断言点）

## 占位符注入模式

### 模式 1：环境变量

适合所有用例共用的固定值：

```python
TOKEN = os.environ.get("TOKEN", "")
PASSWORD = os.environ.get("PASSWORD", "")
```

执行：`TOKEN=xxx PASSWORD=yyy pytest -v testCases.py`

### 模式 2：fixture（推荐用于 token）

适合需要先调一个接口才能得到的值：

```python
@pytest.fixture(scope="session")
def auth_token():
    resp = requests.post(...)
    return resp.json()["token"]


def test_xx(auth_token):
    requests.get(..., headers={"token": auth_token})
```

### 模式 3：模块级 shared 变量（跨用例传递 capture）

适合 `capture_as` 产物（如 meeting_id）：

```python
@pytest.mark.dependency(name="create_meeting")
def test_create(...):
    pytest.shared_meeting_id = resp.json()["data"]


@pytest.mark.dependency(depends=["create_meeting"])
def test_modify(...):
    meeting_id = getattr(pytest, "shared_meeting_id", None)
    if not meeting_id:
        pytest.skip("依赖用例未产出 meeting_id")
```

## 命名约定

| 元素 | 命名规则 |
|---|---|
| 测试函数 | `test_` + 用例ID 小写化（`-`→`_`） + 维度后缀。例：`test_tc_api_login_001_normal_flow` |
| Markdown 用例 ID | 保留原大写格式写在 docstring 第一行 |
| pytest 标记 | `@pytest.mark.<module>` 如 `@pytest.mark.login` `@pytest.mark.meeting` |
| 不可自动化注释块 ID | 与函数命名规则同源，但出现在 `# === <ID> ===` |

## 强制自检（生成后必查）

- [ ] 文件可被 `python -c "import ast; ast.parse(open('xxx.py').read())"` 解析通过（语法正确）
- [ ] 没有 `<placeholder>` / `TODO` 假占位
- [ ] 所有可自动化用例都有 `def test_` 函数
- [ ] 所有不可自动化用例都有 `# === ... [SKIP-MANUAL] ===` 注释块
- [ ] 数量与 Markdown 用例集一致（不漏不重）
- [ ] 依赖用例之间用 `@pytest.mark.dependency` 链接
- [ ] 模块级常量（base URL）与 Markdown 中一致
- [ ] 含 `if __name__ == "__main__": pytest.main(["-v", __file__])`，可直接 `python xxx.py` 运行

## 反模式（禁止）

- ❌ 把所有用例塞进一个超大函数
- ❌ 用 `requests` 调用却不传 timeout（容易卡死）
- ❌ 断言写 `assert resp.ok`（不够具体，应断言 status_code 与字段）
- ❌ 把鉴权 token 硬编码进文件（必须用环境变量或 fixture）
- ❌ 把不可自动化用例伪装成 `def test_xxx(): pytest.skip(...)` —— 必须用注释块，避免被误改为执行
- ❌ 用 `print` 代替 `assert`（会被 pytest 当作通过）
- ❌ 自动添加 try/except 吞掉异常（会掩盖真实失败）

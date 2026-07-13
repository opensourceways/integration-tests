# openEuler SIG 角色说明页 — Playwright Python UI 自动化测试项目

## 📁 项目结构

```
test/
├── config.py                 # 全局配置（URL、超时、路径、断言文案）
├── browser_utils.py          # 浏览器管理器 + 通用工具封装
├── test_role_description.py  # 核心自动化主脚本（8步骤完整流程）
├── test_cases.py             # pytest 多场景测试用例（16个 TC）
├── _probe_page.py            # 页面探测脚本（阶段1遗留，可复用）
├── requirements.txt          # Python 依赖清单
├── run.bat                   # Windows 一键运行脚本
├── run.sh                    # Linux/macOS 一键运行脚本
├── screenshots/              # 自动截图输出目录（运行时创建）
└── logs/                     # 日志输出目录（运行时创建）
```

---

## 🚀 快速开始（一键运行）

### Windows
```cmd
cd test
run.bat
```

### Linux / macOS
```bash
cd test
chmod +x run.sh
./run.sh
```

---

## 🛠 手动安装（如一键脚本失败）

### 1. 环境要求
- Python 3.10+
- pip 24+

### 2. 安装依赖
```bash
cd test
pip install -r requirements.txt
```

### 3. 安装 Playwright 浏览器（仅需一次）
```bash
python -m playwright install chromium
```

### 4. 运行全部用例
```bash
python -m pytest test_cases.py -v --tb=short
```

### 5. 运行核心主脚本（单流程）
```bash
python test_role_description.py
```

---

## 📋 测试用例执行命令速查

| 需求 | 命令 |
|------|------|
| **运行全部用例** | `pytest test_cases.py -v --tb=short` |
| **仅正常场景** | `pytest test_cases.py -v -m "normal"` |
| **仅异常场景** | `pytest test_cases.py -v -m "abnormal"` |
| **冒烟测试** | `pytest test_cases.py -v -m "smoke"` |
| **失败重试2次** | `pytest test_cases.py -v --reruns 2 --reruns-delay 1` |
| **生成 HTML 报告** | `pytest test_cases.py -v --html=report.html --self-contained-html` |
| **循环运行5次** | `for /L %i in (1,1,5) do @pytest test_cases.py -v --tb=short` (Win) |
| | `for i in {1..5}; do pytest test_cases.py -v --tb=short; done` (Bash) |
| **单用例调试** | `pytest test_cases.py::TestRoleDescriptionNormal::test_01_page_load_title_and_url -v -s` |

---

## ⚠️ 常见报错处理

### 1. `playwright._impl._errors.TimeoutError: page.goto: Timeout 30000ms exceeded`
**原因**：页面加载慢、网络不稳定、或目标服务暂时不可用；也可能页面存在持续后台请求导致 `networkidle` 难以满足。  
**处理**：
- 检查网络连通性：`ping openeuler.test.osinfra.cn`
- 在 `config.py` 中调大 `DEFAULT_TIMEOUT` 和 `NAVIGATION_TIMEOUT`（如 60_000）
- 脚本已内置 `goto` 重试机制（retry=1）并默认使用 `wait_until="load"`（比 `networkidle` 更稳定）

### 2. `Executable doesn't exist at .../.cache/ms-playwright/chromium-...`
**原因**：Playwright 浏览器未安装。  
**处理**：
```bash
python -m playwright install chromium
```

### 3. `pytest: error: unrecognized arguments: --reruns`
**原因**：未安装 `pytest-rerunfailures` 插件。  
**处理**：
```bash
pip install pytest-rerunfailures
```

### 4. `Error: browser has been closed` / 中途浏览器崩溃
**原因**：异常场景用例（如 TC-12 错误定位器）导致断言失败，但 fixture 在测试后正常关闭浏览器。这是预期行为。  
**处理**：检查 `screenshots/` 目录中的 `ERROR_*.png` 现场截图，结合 `logs/test_automation.log` 分析。

### 5. 有头模式在 Linux 服务器上报错 `Gtk-WARNING **: cannot open display`
**原因**：Linux 无图形界面环境，Chromium 无法启动有头窗口。  
**处理**：
- 安装 xvfb：`sudo apt-get install xvfb`
- 运行前加前缀：`xvfb-run pytest test_cases.py -v --tb=short`
- 或在 `config.py` 中将 `headless` 改为 `True`（无头模式，但调试时无法肉眼观察）

### 6. 元素定位失败（如 `assert_element_visible` 报错）
**原因**：页面改版、class 名变化、或元素为懒加载尚未渲染。  
**处理**：
- 重新运行 `_probe_page.py` 获取最新 DOM 结构
- 检查截图确认元素实际是否存在
- 在 `config.py` 中更新定位器（优先使用语义化锚点/稳定 class，避免随机 id）

### 7. 搜索/点击后页面跳转导致后续步骤找不到元素
**原因**：部分交互（如搜索、面包屑点击）会离开目标页面。  
**处理**：已在 `test_role_description.py` 中通过 `goto(config.TARGET_URL)` 主动返回，确保后续步骤独立。若用例单独运行，无需担心此问题。

### 8. Cookie 提示条遮挡点击
**原因**：底部蓝色横幅覆盖了目标元素。  
**处理**：`BrowserManager.dismiss_cookie_banner()` 已自动尝试关闭；若关闭失败，可在 `safe_click` 前手动调用 `page.evaluate("window.scrollBy(0, 100)")` 微调滚动位置。

---

## 🔧 脚本优化与扩展方案

### 1. 接入 Allure 可视化报告（推荐）
```bash
pip install allure-pytest
pytest test_cases.py -v --alluredir=./allure-results
allure serve ./allure-results
```
优势：失败步骤自动附截图、用例历史趋势、异常堆栈高亮。

### 2. 启用 Playwright 录屏与 Trace（复盘利器）
在 `BrowserManager.start()` 中追加：
```python
self.context = self.browser.new_context(
    viewport=...,
    record_video_dir="test/videos/",   # 自动录屏
)
self.page = self.context.new_page()
self.page.tracing.start(screenshots=True, snapshots=True, sources=True)
# 测试结束时：page.tracing.stop(path="trace.zip")
# 用 trace.playwright.dev 回放每一步 DOM+网络+控制台
```

### 3. 基线截图对比（UI 回归）
引入 `pixelmatch` 或 `opencv-python`：
```python
from PIL import Image
import cv2
# 对比当前截图与基线 screenshot_baseline.png，计算差异像素比例
```
当页面改版时自动标红差异区域，防止视觉回归。

### 4. 多浏览器并行兼容性测试
```python
# config.py 中增加 BROWSER_LIST = ["chromium", "firefox", "webkit"]
# pytest fixture 参数化：
@pytest.fixture(params=["chromium", "firefox"])
def bm(request):
    config.BROWSER_CONFIG["browser_type"] = request.param
    manager = BrowserManager(cfg=config)
    ...
```

### 5. 数据驱动（YAML/JSON 测试数据）
将搜索关键词、断言文案、锚点列表提取到 `test/data/testdata.yaml`：
```yaml
search_keywords: ["贡献者", "Committer", "Maintainer", "openEuler"]
role_cards:
  - key: contributor
    name: 贡献者
    anchor: "#contributor"
```
用例中通过 `pytest.mark.parametrize` 或 `@pytest.fixture` 读取，实现零代码增改用例。

### 6. CI/CD 集成（GitHub Actions / Jenkins）
**GitHub Actions 示例核心片段**：
```yaml
- name: Install dependencies
  run: |
    pip install -r test/requirements.txt
    python -m playwright install chromium
- name: Run tests
  run: pytest test/test_cases.py -v --tb=short
- name: Upload screenshots on failure
  if: failure()
  uses: actions/upload-artifact@v4
  with:
    name: failure-screenshots
    path: test/screenshots/
```

### 7. 登录态扩展（如后续需要测试需登录页面）
在 `config.py` 中配置 `LOGIN_URL`，新增 `LoginHelper` 类：
```python
class LoginHelper:
    def login(self, bm: BrowserManager, username: str, password: str):
        bm.goto(config.LOGIN_URL)
        bm.safe_input("input[name='username']", username)
        bm.safe_input("input[name='password']", password)
        bm.safe_click("button[type='submit']")
        bm.assert_url_contains("/dashboard")  # 登录后跳转断言
```
测试前调用 `login()` 写入 `storage_state` 保存 Cookie，后续用例复用登录态，避免重复登录。

### 8. 验证码/滑块处理提醒（如遇到）
根据项目指令，若页面出现**验证码输入**或**拖拉滑块**验证：
> ⚠️ 需要提醒操作人进行对应操作。
可在脚本中检测到验证码元素时，自动暂停并弹窗提醒：
```python
if bm.page.locator(".captcha-img").count() > 0:
    LOGGER.warning("检测到验证码，请手动完成后按回车继续...")
    input("请手动完成验证码/滑块，按回车继续...")
```

---

## 📌 阶段交付回顾

| 阶段 | 文件 | 说明 |
|------|------|------|
| 阶段1 | `_probe_page.py` + `screenshot_probe.png` | 页面结构探测与方案 |
| 阶段2 | `config.py` + `browser_utils.py` | 配置与公共工具封装 |
| 阶段3 | `test_role_description.py` | 核心主脚本（8步骤） |
| 阶段4 | `test_cases.py` | pytest 用例（16个 TC） |
| 阶段5 | `requirements.txt` + `run.bat` + `run.sh` + `README.md` | 依赖与运行文档 |

---

*Generated by Claude Code | Playwright Python UI Automation*

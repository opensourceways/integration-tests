# openEuler SIG 会议指南页面自动化测试项目

## 项目概述

本项目针对 `https://openeuler.test.osinfra.cn/zh/sig/meeting-guide/` 页面，使用 **Playwright Python + pytest** 构建 UI 自动化测试脚本。

**页面性质**：信息展示型/指南说明页（无表单、无登录、无弹窗交互）。所有测试围绕**页面加载、内容渲染、导航跳转、链接有效性**展开。

---

## 目录结构

```
test/
├── __init__.py                    # Python 包标识（支持 import）
├── config.py                      # 全局配置（URL、超时、期望文本、路径）
├── browser_utils.py               # 浏览器管理器 + 元素操作封装（阶段2）
├── main_script.py                 # 核心自动化主脚本（阶段3，可直接运行）
├── test_meeting_guide.py          # pytest 多场景测试用例（阶段4）
├── analyze_page.py                # 阶段1：页面结构分析脚本（辅助工具）
├── stage1_page_analysis.md        # 阶段1：页面结构分析文档
├── README.md                      # 本文件（阶段5：运行文档）
├── screenshots/                   # 自动截图输出目录（运行后生成）
│   ├── final_success_*.png
│   ├── fail_stepXX_*.png
│   └── responsive_*.png
└── logs/                          # 结构化日志输出目录（运行后生成）
    └── run_YYYYMMDD_HHMMSS.log
```

---

## 环境依赖

### 基础要求

- Python >= 3.9
- pip >= 21.0

### 安装依赖命令

```bash
# 1. 安装 pytest + playwright + pytest-playwright
pip install pytest playwright pytest-playwright

# 2. 安装 Playwright 浏览器二进制（Chromium）
playwright install chromium

# 验证安装
playwright --version
pytest --version
```

> **Windows 环境提示**：若安装 `playwright` 时遇到权限问题，请使用管理员权限终端运行 `playwright install chromium`。

---

## 一键运行指令

### 方式1：运行核心主脚本（快速单次执行）

```bash
# 从项目根目录执行
python -m test.main_script
```

或：

```bash
# 直接运行（已内置路径兼容处理）
python test/main_script.py
```

**输出**：
- 控制台实时打印步骤日志（`[操作]` / `[校验]` / `[通过]` / `[失败]`）
- 截图保存至 `test/screenshots/`（最终成功图 / 失败截图）
- 日志保存至 `test/logs/run_*.log`

**退出码说明**：
- `0`：全部通过
- `1`：断言失败（标题/URL/元素不存在）
- `2`：Playwright 超时（网络/元素未加载）
- `3`：未预期异常（代码/环境错误）

---

### 方式2：运行 pytest 测试用例（完整测试套件）

```bash
# 运行全部用例（12条，含参数化展开）
pytest test/test_meeting_guide.py -v

# 仅运行正常流程用例
pytest test/test_meeting_guide.py -v -k "TestNormalFlow"

# 仅运行异常场景用例
pytest test/test_meeting_guide.py -v -k "TestAbnormalScenarios"

# 仅运行参数化响应式测试（4组视口尺寸）
pytest test/test_meeting_guide.py -v -k "responsive"

# 仅运行稳定性循环测试（3轮重复）
pytest test/test_meeting_guide.py -v -k "stability"

# 指定失败时立即终止（快速反馈）
pytest test/test_meeting_guide.py -v -x

# 生成 HTML 测试报告（需安装 pytest-html）
pip install pytest-html
pytest test/test_meeting_guide.py -v --html=test/report.html --self-contained-html
```

---

## 常见报错处理

### 1. `playwright._impl._errors.TimeoutError`（超时）

**现象**：日志中出现 `[失败] Playwright 超时异常`。

**排查步骤**：
1. 检查网络是否能访问 `https://openeuler.test.osinfra.cn`（测试环境可能受限）
2. 打开 `test/screenshots/fail_step01_open_page.png` 查看浏览器实际渲染状态（白屏/加载中/错误页）
3. 若页面渲染慢，修改 `test/config.py` 中 `DEFAULT_TIMEOUT = 60000`（60秒）
4. 若元素定位失败，检查页面是否改版（class/文本变化），更新 `config.py` 中 `EXPECTED_SECTIONS` 等配置

### 2. `AssertionError: 面包屑中未找到预期文本: SIG中心`（断言失败）

**现象**：页面加载成功，但内容校验未通过。

**排查步骤**：
1. 检查 `test/screenshots/fail_step02_banner_breadcrumb.png` 确认实际页面内容
2. 若页面文本改版（如"SIG中心"改为"SIG专区"），更新 `test/config.py` 中 `EXPECTED_BREADCRUMB` 列表
3. 若面包屑结构变化（如新增/减少层级），修改 `test/test_meeting_guide.py` 中的定位器逻辑

### 3. `ModuleNotFoundError: No module named 'test.config'`（导入错误）

**现象**：直接运行 `python test/main_script.py` 报错。

**解决**：
- 推荐方式：`python -m test.main_script`（从项目根目录运行，确保 test 包在路径中）
- 或确保在项目根目录下运行，且 `test/` 目录存在 `__init__.py`

### 4. `UnicodeEncodeError: 'gbk' codec can't encode`（编码乱码）

**现象**：Windows 控制台输出中文日志时崩溃。

**解决**：
- 已修复：`browser_utils.py` 中 `sys.stdout.reconfigure(encoding='utf-8')` 和日志文件强制 `encoding='utf-8'`
- 若使用 Git Bash 仍有问题，建议换用 PowerShell 或 CMD（`chcp 65001` 设置 UTF-8）

### 5. `playwright._impl._errors.Error: Browser has been closed`（浏览器被关闭）

**现象**：测试中途浏览器窗口消失，后续步骤崩溃。

**排查**：
1. 检查是否触发了杀毒软件/Windows Defender 对 Chromium 的拦截
2. 检查内存是否充足（有头模式消耗较高）
3. 查看 `test/logs/` 中最新日志，确认上一次操作（如点击跳转后未正确返回）

### 6. 截图文件为空/0KB

**现象**：`screenshots/` 目录下 PNG 文件大小为 0。

**排查**：
- 截图失败通常伴随页面已崩溃或浏览器已关闭，需结合日志和退出码判断
- 若页面跳转后未正确返回原页，后续截图可能因 `page` 对象失效而失败

---

## 脚本优化与扩展方案

### 1. 接入 CI/CD（GitHub Actions / GitLab CI / Jenkins）

```yaml
# .github/workflows/ui-test.yml 示例片段
- name: Install dependencies
  run: |
    pip install pytest playwright pytest-playwright
    playwright install chromium
- name: Run tests
  run: pytest test/test_meeting_guide.py -v --html=report.html
- name: Upload screenshots on failure
  if: failure()
  uses: actions/upload-artifact@v4
  with:
    name: failure-screenshots
    path: test/screenshots/
```

> **注意**：CI 环境通常为无头 Linux 容器，需将 `config.py` 中 `headless` 改为 `True`，并添加 `--no-sandbox` 参数。

### 2. 接入 Allure 测试报告

```bash
pip install allure-pytest
pytest test/test_meeting_guide.py -v --alluredir=./allure-results
allure serve ./allure-results
```

优势：可视化展示失败步骤截图、日志、断言详情。

### 3. 扩展多页面测试（如 /zh/meeting/ 操作页）

当前会议指南页为纯展示页，若业务后续需要测试 `/zh/meeting/` 的**会议预约/创建表单**操作：

1. 新增 `test/test_meeting_form.py`
2. 新增 `test/config.py` 中 `MEETING_FORM_URL = "https://openeuler.test.osinfra.cn/zh/meeting/"`
3. 复用 `BrowserManager` 和 `ActionUtils` 封装，新增 `MeetingFormTest` 类
4. 表单场景：空表单提交、错误日期格式、会议室冲突、重复提交等边界用例

### 4. 动态ID变化自动化维护

若页面 Element Plus 版本升级导致 class 变化：
- 定位策略已统一使用 **class + 文本 + tag** 组合，避免依赖动态 ID
- 可引入 `pytest --update-snapshots` 风格，或每月运行 `analyze_page.py` 重新扫描 DOM 结构对比

### 5. 并发执行（pytest-xdist）

```bash
pip install pytest-xdist
pytest test/test_meeting_guide.py -v -n 2
```

> 注意：有头模式并发可能导致桌面冲突，CI 无头模式下更适用。

### 6. 接入通知（钉钉/飞书/企业微信）

在 pytest 的 `conftest.py` 中定义 `pytest_sessionfinish` 钩子，失败时发送消息 + 截图附件：

```python
def pytest_sessionfinish(session, exitstatus):
    if exitstatus != 0:
        send_dingtalk_alert("UI测试失败", attachments="test/screenshots/")
```

---

## 快速检查清单（运行前自查）

- [ ] 已安装 Python 3.9+ 和 pip
- [ ] 已执行 `pip install pytest playwright pytest-playwright`
- [ ] 已执行 `playwright install chromium`
- [ ] 确认网络可访问 `https://openeuler.test.osinfra.cn`
- [ ] 项目根目录下存在 `test/` 目录且包含 `__init__.py`
- [ ] 截图目录 `test/screenshots/` 和日志目录 `test/logs/` 可自动创建（无需手动创建）
- [ ] 若运行主脚本，使用命令 `python -m test.main_script` 或 `python test/main_script.py`
- [ ] 若运行 pytest，使用命令 `pytest test/test_meeting_guide.py -v`

---

## 阶段交付总结

| 阶段 | 交付文件 | 说明 |
|------|----------|------|
| 阶段1 | `analyze_page.py` + `stage1_page_analysis.md` | 页面结构分析、元素定位清单、风险标注 |
| 阶段2 | `config.py` + `browser_utils.py` | 全局配置、浏览器管理器、操作封装、日志截图 |
| 阶段3 | `main_script.py` | 9步核心主脚本，支持直接运行 |
| 阶段4 | `test_meeting_guide.py` | 12条 pytest 用例（正常/异常/参数化） |
| 阶段5 | `README.md` + `__init__.py` | 项目整合、依赖安装、运行指令、排错文档、扩展方案 |

---

*项目完成日期：2026-07-13*

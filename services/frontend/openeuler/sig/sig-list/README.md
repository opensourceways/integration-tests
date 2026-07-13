# openEuler SIG列表页面 Playwright 自动化测试

## 项目简介

基于 Playwright Python 的 openEuler SIG 中心页面自动化测试项目，覆盖页面浏览、元素校验、搜索筛选、跳转等核心场景。

## 环境要求

- Python >= 3.10
- Windows / Linux / macOS

## 快速开始

### 1. 安装依赖

```bash
pip install -r requirements.txt
playwright install chromium
```

### 2. 一键运行主脚本

```bash
python main_script.py
```

运行后自动打开 Chrome 浏览器，按步骤执行页面流程，截图保存至 `screenshots/20260713/`，日志保存至 `logs/automation.log`。

### 3. 运行 pytest 测试用例

```bash
# 运行全部用例（有头模式，带延迟便于观察）
pytest -v test_sig_list.py --headed --slowmo=100

# 仅运行正常流程
pytest -v test_sig_list.py::TestNormalFlow --headed

# 仅运行异常场景
pytest -v test_sig_list.py::TestAbnormalScenarios --headed

# 冒烟测试（快速）
pytest -v test_sig_list.py::TestSmokeAndRegression::test_smoke_quick --headed

# 生成HTML报告
pytest -v test_sig_list.py --html=report.html --self-contained-html
```

## 目录说明

| 文件/目录 | 说明 |
|-----------|------|
| `config.py` | 全局配置：URL、超时、浏览器、路径 |
| `logger.py` | 日志封装：控制台+文件双输出 |
| `browser_manager.py` | 浏览器生命周期管理 |
| `page_utils.py` | 通用操作：等待、点击、输入、截图、断言 |
| `retry_utils.py` | 重试装饰器 |
| `main_script.py` | 核心主脚本（11步流程） |
| `test_sig_list.py` | pytest 测试用例（正常+异常+批量+冒烟） |
| `screenshots/` | 截图输出目录 |
| `logs/` | 日志输出目录 |

## 常见报错与处理

### 1. `playwright._impl._errors.TimeoutError`
**原因**：元素定位失败或页面加载超时  
**处理**：
- 检查网络连通性：`curl https://openeuler.test.osinfra.cn`
- 在 `config.py` 中增大 `DEFAULT_TIMEOUT`
- 检查目标页面是否改版，元素选择器是否失效

### 2. `browser_context.launch: Executable doesn't exist`
**原因**：未安装 Playwright 浏览器二进制文件  
**处理**：
```bash
playwright install chromium
```

### 3. `page.goto: net::ERR_CONNECTION_TIMED_OUT`
**原因**：网络不通或目标站点不可达  
**处理**：
- 检查代理设置
- 确认目标URL可访问
- 切换 `BASE_URL` 为其他可用环境

### 4. 截图中文乱码
**原因**：Linux无中文字体  
**处理**：
```bash
# Ubuntu/Debian
sudo apt-get install fonts-wqy-zenhei

# CentOS
sudo yum install wqy-zenhei-fonts
```

### 5. 无头模式运行失败
**原因**：部分环境无GUI无法运行有头模式  
**处理**：
修改 `config.py`：
```python
HEADLESS = True  # 改为无头模式
```

### 6. 随机ID导致定位失败
**原因**：Vue动态生成的hash ID变化  
**处理**：
- 使用 `placeholder`、`class`、`text` 等稳定属性定位
- 避免依赖 `id="7d37dc13"` 这类随机ID

## 脚本优化扩展方案

### 1. 接入CI/CD（GitHub Actions / Jenkins）
```yaml
# .github/workflows/test.yml
- name: Run Playwright tests
  run: |
    pip install -r requirements.txt
    playwright install chromium
    pytest -v test_sig_list.py --html=report.html
```

### 2. 接入Allure报告
```bash
pip install allure-pytest
pytest --alluredir=./allure-results
allure serve ./allure-results
```

### 3. 多浏览器矩阵测试
修改 `config.py` 或测试参数化：
```python
@pytest.mark.parametrize("browser_type", ["chromium", "firefox", "webkit"])
```

### 4. 数据驱动（从Excel/YAML读取测试数据）
```python
import yaml
with open("test_data.yaml") as f:
    test_data = yaml.safe_load(f)
```

### 5. 并发执行（pytest-xdist）
```bash
pip install pytest-xdist
pytest -n auto test_sig_list.py  # 自动按CPU核心数并行
```

### 6. 接入截图对比（视觉回归）
使用 Playwright 的 `page.screenshot` + `pixelmatch` 进行UI diff：
```bash
pip install pixelmatch
```

### 7. 环境变量动态切换
```python
import os
BASE_URL = os.getenv("OPENEULER_BASE_URL", "https://openeuler.test.osinfra.cn")
```

### 8. 对接Jira/TestRail
通过 pytest 的 `pytest_runtest_makereport` hook 自动上报测试结果

# Linux 环境测试配置指南

## 问题背景

在Linux环境中执行测试时，登录流程可能会遇到验证码提交后仍停留在登录页的问题。这通常是由于以下原因：

1. **字符编码问题**：Linux默认编码与Windows不同
2. **浏览器输入事件**：某些UI框架需要显式触发input/change事件
3. **显示服务器**：无头模式配置不当
4. **网络延迟**：Linux服务器与测试站点之间的网络延迟

## 环境配置

### 1. 系统依赖安装

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y \
    python3 \
    python3-pip \
    xvfb \
    libglib2.0-0 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    ca-certificates

# CentOS/RHEL
sudo yum install -y \
    python3 \
    python3-pip \
    xorg-x11-server-Xvfb \
    ca-certificates \
    alsa-lib \
    atk \
    cups-libs \
    gtk3 \
    libXcomposite \
    libXcursor \
    libXdamage \
    libXext \
    libXi \
    libXrandr \
    libXScrnSaver \
    libXtst \
    pango \
    xorg-x11-fonts-100dpi \
    xorg-x11-fonts-75dpi \
    xorg-x11-fonts-cyrillic \
    xorg-x11-fonts-misc \
    xorg-x11-fonts-Type1
```

### 2. Python依赖安装

```bash
# 安装Python包
pip3 install -r requirements.txt

# 安装Playwright浏览器
python3 -m playwright install chromium
python3 -m playwright install-deps chromium
```

### 3. 环境变量配置

在 `.env` 文件中确保以下配置：

```bash
# 必须使用无头模式
HEADLESS=true

# 登录模式（推荐验证码登录）
LOGIN_MODE=code

# 邮箱配置（必填）
TEST_ACCOUNT=your_email@163.com
MAIL_AUTH_CODE=your_imap_auth_code

# Linux环境优化：增加超时时间
MAIL_CODE_TIMEOUT=180
PAGE_READY_TIMEOUT=15000

# 滑块配置
SLIDER_AUTO=1
SLIDER_AUTO_ATTEMPTS=3
SLIDER_WAIT=0  # CI环境设为0，人工环境可设为300

# 人工兜底（CI环境设为0）
MFA_MANUAL=0
```

### 4. 字符编码设置

```bash
# 在测试脚本开头或shell配置中添加
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PYTHONIOENCODING=utf-8
```

## 运行测试

### 方式1：直接运行（推荐）

```bash
#!/bin/bash
set -e

# 设置编码
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PYTHONIOENCODING=utf-8

# 无头模式
export HEADLESS=true

# 运行测试
python3 -m pytest test_cases.py -v \
    --html=report.html \
    --self-contained-html \
    --tb=short
```

### 方式2：使用虚拟显示器（调试用）

```bash
#!/bin/bash
set -e

# 启动虚拟显示器
export DISPLAY=:99
Xvfb :99 -screen 0 1920x1080x24 > /dev/null 2>&1 &
XVFB_PID=$!

# 清理函数
cleanup() {
    kill $XVFB_PID 2>/dev/null || true
}
trap cleanup EXIT

# 设置编码
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 有头模式（用于调试）
export HEADLESS=false

# 运行测试
python3 -m pytest test_cases.py -v \
    --html=report.html \
    --self-contained-html \
    --tb=short
```

### 方式3：Docker容器运行

```dockerfile
FROM mcr.microsoft.com/playwright/python:v1.40.0-jammy

WORKDIR /app

# 复制文件
COPY requirements.txt .
COPY test_cases.py .
COPY email_verify.py .
COPY slider_solver.py .
COPY .env .

# 安装依赖
RUN pip3 install -r requirements.txt

# 设置环境变量
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV PYTHONIOENCODING=utf-8
ENV HEADLESS=true

# 运行测试
CMD ["python3", "-m", "pytest", "test_cases.py", "-v", "--html=report.html", "--self-contained-html"]
```

```bash
# 构建并运行
docker build -t xihe-test .
docker run --rm -v $(pwd)/report.html:/app/report.html xihe-test
```

## 常见问题排查

### 问题1：登录后仍停留在登录页

**症状**：验证码获取成功，提交后刷新3次仍在登录页

**原因**：
- 验证码输入框填充未触发表单验证
- 网络延迟导致请求超时
- 登录请求被服务器拒绝

**解决**：
1. 代码已修改为使用 `type()` 方法逐字符输入，并显式触发 `input` 和 `change` 事件
2. 增加等待时间：`MAIL_CODE_TIMEOUT=180`
3. 检查网络连接：`curl -I https://mindspore-usercenter.test.osinfra.cn/login`

### 问题2：浏览器无法启动

**症状**：`Error: Browser closed` 或 `Error: Target closed`

**解决**：
```bash
# 重新安装浏览器依赖
python3 -m playwright install --with-deps chromium

# 检查是否缺少系统库
ldd $(python3 -c "import playwright; print(playwright.__path__[0])")/driver/chromium-*/chrome-linux/chrome

# 使用无头模式
export HEADLESS=true
```

### 问题3：IMAP连接失败

**症状**：`[MAIL] IMAP 登录失败`

**解决**：
```bash
# 测试IMAP连接
python3 -c "
from dotenv import load_dotenv
load_dotenv()
from email_verify import selftest
selftest()
"

# 检查防火墙
sudo iptables -L | grep 993
telnet imap.163.com 993

# 检查SSL证书
python3 -c "import ssl; print(ssl.OPENSSL_VERSION)"
```

### 问题4：字符编码乱码

**症状**：日志中出现乱码（`��¼` 而非 "登录"）

**解决**：
```bash
# 设置系统编码
sudo locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Python编码
export PYTHONIOENCODING=utf-8

# 检查当前编码
locale
python3 -c "import sys; print(sys.getdefaultencoding())"
```

### 问题5：元素定位超时

**症状**：`TimeoutError: Timeout 30000ms exceeded`

**解决**：
1. 增加超时配置：
```python
DEFAULT_TIMEOUT = 45000  # 从30秒增加到45秒
NAVIGATION_TIMEOUT = 60000  # 从45秒增加到60秒
```

2. 检查网络延迟：
```bash
ping mindspore-website.test.osinfra.cn
curl -w "@curl-format.txt" -o /dev/null -s https://mindspore-website.test.osinfra.cn/
```

## CI/CD 集成

### GitLab CI

```yaml
test:
  stage: test
  image: mcr.microsoft.com/playwright/python:v1.40.0-jammy
  before_script:
    - pip3 install -r requirements.txt
    - export LANG=en_US.UTF-8
    - export LC_ALL=en_US.UTF-8
    - export HEADLESS=true
  script:
    - python3 -m pytest test_cases.py -v --html=report.html --self-contained-html
  artifacts:
    when: always
    paths:
      - report.html
      - debug_*.png
    expire_in: 7 days
```

### Jenkins

```groovy
pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/playwright/python:v1.40.0-jammy'
        }
    }
    environment {
        LANG = 'en_US.UTF-8'
        LC_ALL = 'en_US.UTF-8'
        HEADLESS = 'true'
    }
    stages {
        stage('Install') {
            steps {
                sh 'pip3 install -r requirements.txt'
            }
        }
        stage('Test') {
            steps {
                sh 'python3 -m pytest test_cases.py -v --html=report.html --self-contained-html'
            }
        }
    }
    post {
        always {
            publishHTML([
                reportDir: '.',
                reportFiles: 'report.html',
                reportName: 'Test Report'
            ])
            archiveArtifacts artifacts: 'debug_*.png', allowEmptyArchive: true
        }
    }
}
```

## 性能优化建议

1. **使用本地缓存**：避免每次都重新下载浏览器
```bash
export PLAYWRIGHT_BROWSERS_PATH=$HOME/.cache/ms-playwright
```

2. **并行执行**：使用 pytest-xdist
```bash
pip3 install pytest-xdist
pytest test_cases.py -n auto
```

3. **减少等待时间**：调整超时配置
```python
DEFAULT_TIMEOUT = 20000  # 根据网络情况调整
```

4. **复用浏览器上下文**：在 conftest.py 中配置
```python
@pytest.fixture(scope="session")
def browser_context(browser):
    context = browser.new_context()
    yield context
    context.close()
```

## 总结

Linux环境运行测试的关键点：
1. ✅ 确保无头模式：`HEADLESS=true`
2. ✅ 设置正确编码：`UTF-8`
3. ✅ 安装完整依赖：`playwright install-deps`
4. ✅ 增加超时时间：应对网络延迟
5. ✅ 使用增强型输入：`type()` + 事件触发

如有问题，请查看生成的截图文件：
- `debug_login_failed.png` - 登录失败截图
- `debug_code_error.png` - 验证码错误截图
- `debug_slider_*.png` - 滑块相关截图

# GitCode Actions 自动化测试执行镜像
#
# 仓库地址: https://github.com/opensourceways/integration-tests/tree/main/gitcode_services
#
# 构建上下文 = 本包目录自身（自包含，不再要求以某个上级仓库根为 context）:
#   cd gitcode_services
#   docker build -t gitcode-test-harness:latest .
# 或用 compose（已配好 context）:
#   docker compose build
#
# 运行:
#   docker run --rm --shm-size=1gb \
#     -v "$(pwd)/config.yaml:/app/config.yaml:ro" \
#     -v "$(pwd)/phase02/runs:/app/phase02/runs" \
#     -v "$(pwd)/phase02/reports:/app/phase02/reports" \
#     gitcode-test-harness:latest
#
# 配置（含凭证）以只读 volume 挂载注入，不进镜像层；
# 单项可用 -e KEY=V 覆盖（环境变量优先级高于 config.yaml）。
#
# 镜像内布局: /app 即包根，/app/phase02/scripts 为执行引擎，
# run_daily.sh 按自身所在目录推导包根，与引擎 __file__ 推导天然一致。

# ---------- stage: base（基于 openEuler 装依赖 + Playwright 浏览器） ----------
FROM openeuler/openeuler:23.09 AS base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    TZ=Asia/Shanghai

# 安装系统依赖：Python3、pip、git、wget、ca-certificates
RUN yum update -y && \
    yum install -y python3 python3-pip git wget ca-certificates && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /app

RUN pip3 install --no-cache-dir -r /app/gitcode_services/requirements.txt


# Chromium 及其系统依赖由 playwright 自己声明
# 注意：openEuler 可能需要额外的依赖包配置
RUN python3 -m playwright install --with-deps chromium || \
    (yum install -y libX11 libXcomposite libXcursor libXdamage libXext libXi \
     libXtst cups-libs libXScrnSaver libXrandr GConf2 alsa-lib atk gtk3 \
     nss liberation-fonts xorg-x11-fonts-Type1 liberation-sans-fonts \
     liberation-serif-fonts liberation-mono-fonts && \
     python3 -m playwright install chromium)

# ---------- stage: runtime（精简执行镜像） ----------
FROM openeuler/openeuler:23.09 AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PLAYWRIGHT_BROWSERS_PATH=/home/testuser/.cache/ms-playwright \
    PYTHONPATH=/app:$PYTHONPATH \
    TZ=Asia/Shanghai

# git 是 GIT-* 用例的被测对象，也用于 clone 被测仓，必须留在运行镜像里
# 安装 Python3、pip、git、ca-certificates、tzdata
RUN yum update -y && \
    yum install -y python3 python3-pip git ca-certificates tzdata && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    useradd -m -u 1000 testuser

# 复用 base 已装好的 Python 包
COPY --from=base /usr/lib64/python3.11/site-packages /usr/lib64/python3.11/site-packages
COPY --from=base /usr/lib/python3.11/site-packages /usr/lib/python3.11/site-packages
COPY --from=base /usr/local/bin/playwright /usr/local/bin/playwright

# Chromium 系统依赖
RUN yum install -y libX11 libXcomposite libXcursor libXdamage libXext libXi \
     libXtst cups-libs libXScrnSaver libXrandr alsa-lib atk gtk3 nss && \
    yum clean all && \
    rm -rf /var/cache/yum

# 安装 playwright 依赖
RUN python3 -m playwright install-deps chromium || true

# 浏览器缓存迁到非 root 用户目录
COPY --from=base --chown=testuser:testuser /root/.cache/ms-playwright /home/testuser/.cache/ms-playwright

WORKDIR /app

# 复制项目文件（从 GitHub 仓库）
# 仓库: https://github.com/opensourceways/integration-tests/tree/main/gitcode_services
COPY --chown=testuser:testuser . .

# 设置正确的权限
RUN chown -R 1000:1000 /app/

USER testuser

# 运行产物目录（挂载点，未挂载时也能写）
RUN mkdir -p phase02/runs phase02/reports

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD python3 -c "import requests, yaml; from playwright.sync_api import sync_playwright" || exit 1

LABEL maintainer="guoxiaozhen0304" \
      description="GitCode Actions 基础能力自动化测试执行环境（136 条用例，自包含）" \
      repository="https://github.com/opensourceways/integration-tests/tree/main/gitcode_services"

ENTRYPOINT ["bash", "run_daily.sh"]
CMD ["cases/yaml", "daily"]

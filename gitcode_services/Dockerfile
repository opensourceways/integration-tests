# GitCode Actions 自动化测试执行镜像
#
# 构建上下文 = 本包目录自身（自包含，不再要求以某个上级仓库根为 context）:
#   cd gitcode_services
#   docker build -t gitcode-test-harness:latest .
# 或用 compose（已配好 context）:
#   docker compose build
#
# 运行:
#   docker run --rm --shm-size=1gb --env-file .env \
#     -v "$(pwd)/phase02/runs:/app/phase02/runs" \
#     -v "$(pwd)/phase02/reports:/app/phase02/reports" \
#     gitcode-test-harness:latest
#
# 镜像内布局: /app 即包根，/app/phase02/scripts 为执行引擎，
# run_daily.sh 按自身所在目录推导包根，与引擎 __file__ 推导天然一致。

# ---------- stage: base（装依赖 + Playwright 浏览器） ----------
FROM python:3.11-slim AS base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
        git wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Chromium 及其系统依赖由 playwright 自己声明，避免手写包名随 Debian 版本漂移
RUN playwright install --with-deps chromium

# ---------- stage: runtime（精简执行镜像） ----------
FROM python:3.11-slim AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PLAYWRIGHT_BROWSERS_PATH=/home/testuser/.cache/ms-playwright \
    TZ=Asia/Shanghai

# git 是 GIT-* 用例的被测对象，也用于 clone 被测仓，必须留在运行镜像里
RUN apt-get update && apt-get install -y --no-install-recommends \
        git ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -u 1000 testuser

# 复用 base 已装好的 Python 包
COPY --from=base /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=base /usr/local/bin/playwright /usr/local/bin/playwright

# Chromium 系统依赖：交给 playwright 声明，包名不随 Debian 版本手工漂移
RUN playwright install-deps chromium \
    && rm -rf /var/lib/apt/lists/*

# 浏览器缓存迁到非 root 用户目录
COPY --from=base --chown=testuser:testuser /root/.cache/ms-playwright /home/testuser/.cache/ms-playwright

WORKDIR /app
COPY --chown=testuser:testuser . .

USER testuser

# 运行产物目录（挂载点，未挂载时也能写）
RUN mkdir -p phase02/runs phase02/reports

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD python -c "import requests, yaml; from playwright.sync_api import sync_playwright" || exit 1

LABEL maintainer="guoxiaozhen0304" \
      description="GitCode Actions 基础能力自动化测试执行环境（249 条用例，自包含）"

ENTRYPOINT ["bash", "run_daily.sh"]
CMD ["cases/yaml", "daily"]

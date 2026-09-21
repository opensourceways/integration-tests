# GitCode Actions 自动化测试执行镜像
#
# 构建（上下文 = 本包目录自身）:
#   cd gitcode_services && docker build -t gitcode-test-harness:latest .
#
# 运行:
#   docker run --rm --shm-size=1gb \
#     -v "$(pwd)/config.yaml:/app/config.yaml:ro" \
#     -v "$(pwd)/phase02/runs:/app/phase02/runs" \
#     -v "$(pwd)/phase02/reports:/app/phase02/reports" \
#     gitcode-test-harness:latest
#
# --shm-size=1gb 不能省：UI 用例跑 Chromium，共享内存不足会崩。
# 配置（含凭证）以只读 volume 注入，不进镜像层；单项可用 -e KEY=V 覆盖。
# 镜像内 /app 即包根，run_daily.sh 按自身所在目录推导，与引擎 __file__ 一致。

FROM openeuler/openeuler:23.09

LABEL maintainer="guoxiaozhen0304" \
      description="GitCode 基础能力自动化测试执行环境"

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONPATH=/app \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright \
    TZ=Asia/Shanghai

# git 既是 GIT-* 用例的被测对象，也用于 clone 被测仓
RUN yum install -y python3 python3-pip git ca-certificates tzdata && \
    yum clean all && rm -rf /var/cache/yum

WORKDIR /app

# 依赖单独先装：源码变更不失效这层缓存
COPY gitcode_services /app/gitcode_services
RUN pip3 install --no-cache-dir -r /app/gitcode_services/requirements.txt

# Chromium + 系统依赖。openEuler 非 playwright 官方支持发行版，
# --with-deps 探测失败时回退到显式装库。
RUN python3 -m playwright install --with-deps chromium || \
    (yum install -y libX11 libXcomposite libXcursor libXdamage libXext libXi \
       libXtst libXScrnSaver libXrandr cups-libs alsa-lib atk gtk3 nss \
       liberation-fonts && \
     yum clean all && rm -rf /var/cache/yum && \
     python3 -m playwright install chromium)

RUN useradd -m -u 1000 testuser && chmod -R a+rX /app/gitcode_services/phase02

COPY --chown=testuser:testuser . .

USER testuser

# 挂载点，未挂载时也能写
RUN mkdir -p /app/gitcode_services/phase02/runs /app/gitcode_services/phase02/reports

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD python3 -c "import requests, yaml; from playwright.sync_api import sync_playwright" || exit 1


ENTRYPOINT ["/bin/bash", "/app/gitcode_services/run_daily.sh"]
CMD ["/app/gitcode_services/cases/yaml", "daily"]

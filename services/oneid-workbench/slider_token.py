#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
令牌页滑块适配层：等图加载完成后委托给 slider_solver

为什么需要这一层
----------------
令牌页滑块与 openGauss 那套是**同一个 AJ-Captcha 组件**，图片同样是
`<img src="data:image/png;base64,...">`，`slider_solver.py` 的算法可以直接用。

但直接调 `solve_slider()` 会失败，报「弹窗内只找到 0 张图，预期 2 张」——
原因是**时序**，不是结构：

    点击「获取验证码」
      → `.verifybox` 弹窗 DOM **立即**出现（此时 panel 内是空的 `<!---->`）
      → `POST captcha/get` 异步返回
      → 图片才被塞进 `.verify-img-panel` 与 `.verify-sub-block`（实测约 3s）

所以 `.verifybox` 可见 ≠ 可以开始分析。必须等 `<img>` 数量 ≥ 2 再动手。

实测数据（2026-09-21 17:52 诊断）：
  - `.verify-img-panel` 内 1 张 `<img>`（底图，原图 310×155，显示 360×180）
  - `.verify-sub-block` 内 1 张 `<img>`（拼图块），该块嵌在 `.verify-move-block` 内
  - `.verifybox` 内合计 2 张 `<img>`，正好满足 slider_solver 的取图假设
  - 三个元素的 CSS `background-image` 均为 `none` —— 图**不是**背景图
"""

import time

from slider_solver import VERIFY_BOX, solve_slider

# 等图加载的默认超时（秒）。实测约 3s 到位，给到 20s 足够宽裕。
IMG_WAIT_SECONDS = 20

# 统计 .verifybox 内已加载完成的图片数（naturalWidth > 0 才算真的解码完成）
JS_COUNT_IMGS = """
sel => {
  const box = document.querySelector(sel);
  if (!box) return -1;
  return [...box.querySelectorAll('img')]
    .filter(i => i.naturalWidth > 0).length;
}
"""


def wait_captcha_images(page, timeout: int = IMG_WAIT_SECONDS) -> int:
    """
    等滑块底图与拼图块都加载解码完成。

    :return: 最终探测到的已解码图片数（≥2 表示可以开始分析）
    """
    deadline = time.time() + timeout
    last = 0
    while time.time() < deadline:
        last = page.evaluate(JS_COUNT_IMGS, VERIFY_BOX)
        if last >= 2:
            waited = timeout - (deadline - time.time())
            print(f"   [滑块] 图片已就绪（{last} 张，等待 {waited:.1f}s）")
            return last
        page.wait_for_timeout(400)
    print(f"   [滑块] 等待 {timeout}s 后仅探测到 {last} 张图（需要 2 张）")
    return last


def solve_slider_token(page, max_attempts: int = 3) -> bool:
    """
    破解令牌页滑块：先等图就绪，再复用 slider_solver 的缺口定位与拟人化拖拽。

    :return: True 已通过；False 需回落人工
    """
    box = page.locator(VERIFY_BOX).first
    if box.count() == 0 or not box.is_visible():
        return False

    if wait_captcha_images(page) < 2:
        # 图没来，直接交给人工，不做无意义的拖拽
        return False

    return solve_slider(page, max_attempts=max_attempts)


def diagnose(page) -> dict:
    """打印滑块内图片的真实情况，用于排查（不做拖拽）"""
    info = page.evaluate("""sel => {
        const box = document.querySelector(sel);
        if (!box) return {error: 'verifybox 不存在'};
        const imgs = [...box.querySelectorAll('img')].map(i => ({
            natural: i.naturalWidth + 'x' + i.naturalHeight,
            display: Math.round(i.getBoundingClientRect().width) + 'x' +
                     Math.round(i.getBoundingClientRect().height),
            isDataUrl: (i.src || '').startsWith('data:image'),
            srcLen: (i.src || '').length,
            parent: i.parentElement ? i.parentElement.className : '',
        }));
        const g = s => { const e = box.querySelector(s);
            return e ? (getComputedStyle(e).backgroundImage || 'none') : 'NA'; };
        return {imgCount: imgs.length, imgs,
                panelBg: g('.verify-img-panel'), pieceBg: g('.verify-sub-block')};
    }""", VERIFY_BOX)

    if info.get("error"):
        print(f"   [诊断] {info['error']}")
        return info
    print(f"   [诊断] .verifybox 内图片 {info['imgCount']} 张")
    for i, im in enumerate(info["imgs"]):
        print(f"            #{i} 原图 {im['natural']} 显示 {im['display']}"
              f" dataURL={im['isDataUrl']} 长度={im['srcLen']}"
              f" 父级={im['parent']!r}")
    print(f"            panel background-image={info['panelBg'][:40]}")
    print(f"            piece background-image={info['pieceBg'][:40]}")
    return info

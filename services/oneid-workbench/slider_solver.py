#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
滑块验证自动破解模块（AJ-Captcha / anji-plus blockPuzzle 拼图滑块）

适用范围
--------
openGauss 统一认证在「获取验证码」等环节弹出的滑块，经实测为开源组件
**AJ-Captcha（anji-plus）** 的 Vue 版本，特征类名：

    .verifybox / .verify-img-panel / .verify-sub-block / .verify-move-block / .verify-refresh

该组件把底图与拼图块以 `data:image/png;base64` 内联在 DOM 中，后端只校验**落点横坐标**
（默认容差 ±5 原图像素），不做拖拽轨迹风控，因此可以稳定自动通过。

破解原理
--------
1. 从 DOM 直接读出两张内联图：底图（310×155 RGB）与拼图块（47×155 RGBA）；
2. 用拼图块的 alpha 通道得到拼图形状掩膜，在底图上逐列滑动，用两个独立判据打分：
   - 判据 A：掩膜覆盖处**平均亮度最低**（组件把缺口区域压暗）
   - 判据 B：掩膜覆盖处**近白像素最多**（缺口带白色描边）
   两个判据各自 z-score 归一化后相加，取峰值列作为缺口横坐标；
3. 按「显示宽度 / 原图宽度」换算成页面像素，得到拖拽距离；
4. 以拟人化轨迹（先加速后减速 + 纵向抖动 + 轻微过冲回拉）拖动滑块。

失败时不抛异常，返回 False，由调用方回落到人工处理。
"""

import base64
import io
import math
import random
import re
import time

try:
    import numpy as np
    from PIL import Image
    _CV_READY = True
    _CV_ERROR = ""
except ImportError as _exc:  # pragma: no cover - 依赖缺失时降级为人工处理
    _CV_READY = False
    _CV_ERROR = str(_exc)


# 滑块弹窗根节点（AJ-Captcha 固定类名）
VERIFY_BOX = ".verifybox"
MOVE_BLOCK = ".verify-move-block"
REFRESH_BTN = ".verify-refresh"

_DATA_URL_RE = re.compile(r"^data:image/\w+;base64,(.+)$", re.S)


class SliderSolveError(RuntimeError):
    """滑块破解失败（可回落人工）"""


# =============================================================================
# 图像分析
# =============================================================================
def _decode_data_url(src: str):
    """把 data:image/png;base64,... 解码为 PIL Image"""
    m = _DATA_URL_RE.match((src or "").strip())
    if not m:
        raise SliderSolveError("图片不是 base64 内联格式，无法离线分析")
    return Image.open(io.BytesIO(base64.b64decode(m.group(1))))


def locate_gap(bg_img, piece_img) -> int:
    """
    在底图中定位拼图缺口的**左边界横坐标**（原图像素）。

    :param bg_img:    底图 PIL.Image
    :param piece_img: 拼图块 PIL.Image（需含 alpha 通道）
    :return: 缺口左边界 x（原图坐标）
    """
    bg = np.asarray(bg_img.convert("RGB")).astype(np.int16)
    piece = np.asarray(piece_img.convert("RGBA"))

    mask = piece[:, :, 3] > 128
    if not mask.any():
        raise SliderSolveError("拼图块 alpha 通道为空，无法构造形状掩膜")

    mh, mw = mask.shape
    h, w = bg.shape[:2]
    if w <= mw or h < mh:
        raise SliderSolveError(f"底图尺寸 {w}x{h} 小于拼图块 {mw}x{mh}，无法滑动匹配")

    gray = bg.mean(axis=2)
    hi = bg.max(axis=2)
    lo = bg.min(axis=2)
    # 近白：三通道都亮且色差小 —— 缺口白色描边的特征
    white = (lo > 205) & ((hi - lo) < 35)

    span = w - mw + 1
    darkness = np.empty(span)
    whiteness = np.empty(span)
    for x in range(span):
        darkness[x] = gray[:mh, x:x + mw][mask].mean()
        whiteness[x] = white[:mh, x:x + mw][mask].sum()

    # 各自 z-score 归一化后相加：越暗越高分 + 白描边越多越高分
    score = ((darkness.mean() - darkness) / (darkness.std() + 1e-6)
             + (whiteness - whiteness.mean()) / (whiteness.std() + 1e-6))

    # 取 top-5 的加权质心，抵消单列噪声
    top = np.argsort(score)[::-1][:5]
    weights = score[top] - score[top].min() + 1e-6
    return int(round(float((top * weights).sum() / weights.sum())))


# =============================================================================
# 拟人化拖拽
# =============================================================================
def _build_track(distance: float):
    """
    生成拟人化拖拽轨迹（相对位移序列）。

    先加速后减速，末段轻微过冲再回拉，纵向带小幅抖动 —— 即便后端加了轨迹风控，
    这种形态也比匀速直线安全得多。
    """
    steps = random.randint(28, 42)
    overshoot = random.uniform(4, 9)
    peak = distance + overshoot

    track = []
    prev = 0.0
    for i in range(1, steps + 1):
        # ease-out-cubic：起步快、尾段慢，贴近真人拖拽
        ratio = 1 - (1 - i / steps) ** 3
        cur = peak * ratio
        track.append((cur - prev, random.uniform(-1.2, 1.2)))
        prev = cur

    # 回拉修正到目标位置，分 3~5 小步
    back_steps = random.randint(3, 5)
    for i in range(back_steps):
        remain = distance - prev
        step = remain / (back_steps - i)
        track.append((step, random.uniform(-0.6, 0.6)))
        prev += step

    return track


def _drag(page, handle, distance: float):
    """按拟人化轨迹拖动滑块手柄"""
    box = handle.bounding_box()
    if not box:
        raise SliderSolveError("滑块手柄不可见，无法拖动")

    start_x = box["x"] + box["width"] / 2
    start_y = box["y"] + box["height"] / 2

    page.mouse.move(start_x, start_y)
    page.wait_for_timeout(random.randint(120, 300))
    page.mouse.down()

    x, y = start_x, start_y
    for dx, dy in _build_track(distance):
        x += dx
        y += dy
        page.mouse.move(x, y)
        time.sleep(random.uniform(0.006, 0.022))

    page.wait_for_timeout(random.randint(150, 350))
    page.mouse.up()


# =============================================================================
# 对外接口
# =============================================================================
def solve_slider(page, max_attempts: int = 3) -> bool:
    """
    尝试自动完成滑块验证。

    :param page:         Playwright Page（弹窗须已可见）
    :param max_attempts: 最大尝试次数，失败会点刷新换一张图重试
    :return: True 表示滑块已通过；False 表示未能自动通过，需人工介入
    """
    if not _CV_READY:
        print(f"   [滑块] 缺少图像处理依赖（{_CV_ERROR}），跳过自动破解。"
              "可执行 pip install pillow numpy 后启用")
        return False

    box = page.locator(VERIFY_BOX).first
    if box.count() == 0 or not box.is_visible():
        return False

    for attempt in range(1, max_attempts + 1):
        try:
            # ---- 读取内联底图与拼图块（按原图宽度降序：底图在前）----
            srcs = box.evaluate("""e => [...e.querySelectorAll('img')]
                .map(i => ({src: i.src, w: i.naturalWidth}))
                .sort((a, b) => b.w - a.w)
                .map(i => i.src)""")
            if len(srcs) < 2:
                raise SliderSolveError(f"弹窗内只找到 {len(srcs)} 张图，预期 2 张（底图 + 拼图块）")

            bg_img = _decode_data_url(srcs[0])
            piece_img = _decode_data_url(srcs[1])

            gap_x = locate_gap(bg_img, piece_img)

            # ---- 原图坐标 → 页面显示坐标 ----
            panel = page.locator(f"{VERIFY_BOX} .verify-img-panel img").first
            if panel.count() == 0:
                panel = box.locator("img").first
            pbox = panel.bounding_box()
            if not pbox:
                raise SliderSolveError("底图元素不可见，无法换算显示坐标")

            scale = pbox["width"] / bg_img.width
            handle = page.locator(MOVE_BLOCK).first

            # 拼图块初始左边缘相对底图左边缘的偏移（通常 0~1px）
            sub = page.locator(".verify-sub-block").first
            sbox = sub.bounding_box() if sub.count() > 0 else None
            piece_offset = (sbox["x"] - pbox["x"]) if sbox else 0.0

            distance = gap_x * scale - piece_offset
            print(f"   [滑块] 第 {attempt}/{max_attempts} 次尝试："
                  f"缺口原图 x={gap_x}，缩放 {scale:.3f}，拖拽距离 {distance:.1f}px")

            if distance <= 5 or distance > pbox["width"]:
                raise SliderSolveError(f"计算出的拖拽距离 {distance:.1f}px 不合理")

            _drag(page, handle, distance)
            page.wait_for_timeout(2000)

            # ---- 判定是否通过：弹窗消失即成功 ----
            if box.count() == 0 or not box.is_visible():
                print("   [滑块] 自动破解成功，验证已通过")
                return True

            msg = ""
            try:
                tip = page.locator(f"{VERIFY_BOX} .verify-msg").first
                if tip.count() > 0:
                    msg = tip.inner_text().strip()
            except Exception:
                pass
            print(f"   [滑块] 第 {attempt} 次未通过{('（页面提示：' + msg + '）') if msg else ''}")

        except SliderSolveError as exc:
            print(f"   [滑块] 第 {attempt} 次分析失败：{exc}")
        except Exception as exc:  # 任何异常都不应中断测试，回落人工即可
            print(f"   [滑块] 第 {attempt} 次尝试异常：{type(exc).__name__}: {exc}")

        # 换一张图重试
        if attempt < max_attempts:
            try:
                refresh = page.locator(REFRESH_BTN).first
                if refresh.count() > 0 and refresh.is_visible():
                    refresh.click()
                    page.wait_for_timeout(1800)
            except Exception:
                pass

    print(f"   [滑块] {max_attempts} 次自动破解均未通过，回落人工处理")
    return False


if __name__ == "__main__":
    # 离线自测：对已落盘的样本图跑一遍缺口定位
    import sys
    bg_path = sys.argv[1] if len(sys.argv) > 1 else "diag_cap_0.png"
    pc_path = sys.argv[2] if len(sys.argv) > 2 else "diag_cap_1.png"
    print(f"底图: {bg_path}   拼图块: {pc_path}")
    bg = Image.open(bg_path)
    pc = Image.open(pc_path)
    print(f"尺寸: {bg.size} / {pc.size}")
    x = locate_gap(bg, pc)
    print(f"[PASS] 缺口左边界原图坐标 x = {x}")
    print(f"       换算到 360px 显示宽度 = {x * 360 / bg.width:.1f}px")

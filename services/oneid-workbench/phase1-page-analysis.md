# 阶段 1：页面结构分析与自动化方案

- **目标页面**：`https://openeuler.test.osinfra.cn/zh/my/tokens`
- **分析日期**：2026-09-21
- **分析方式**：Playwright 实际访问（匿名）+ Nuxt 构建产物静态分析
- **证据留存**：`out/01_anon_full.png`、`out/01_anon_dom.json`、`out/01_anon_html.html`

---

## 0. 分析手段说明（重要）

匿名访问该 URL 会被 302 到统一登录页，**未登录状态下拿不到 tokens 页的真实 DOM**。
为避免脑补页面功能，采用两条证据链交叉验证：

| 证据链 | 手段 | 覆盖内容 |
|--------|------|---------|
| A. 实际访问 | Playwright 打开 URL，抓取重定向链、DOM、网络请求 | 登录页元素、重定向地址、后端接口前缀 |
| B. 构建产物 | 下载 Nuxt chunk，反查路由 → 页面组件 → 渲染函数 | tokens 页组件树、class 名、i18n 文案、接口调用、校验规则 |

页面组件定位链：

```
路由 lang-my-tokens  →  v148PFuc.js（壳）  →  DOwrx8Yc.js（真实实现，228 KB）
i18n 文案            →  CeLR-hhP.js（主 chunk）
```

> ⚠️ 证据链 B 得到的是**组件源码级事实**（不是猜测），但**渲染后的最终 DOM 仍需登录后实测复核**。
> 下方定位器已按 OpenDesign 组件库的实际类名前缀推导，标注了置信度。

---

## 1. 页面完整交互链路

### 1.1 进入页面

```
GET https://openeuler.test.osinfra.cn/zh/my/tokens
  │
  ├─ 未登录 ──► 302 https://openeuler-usercenter.test.osinfra.cn/login
  │              ?redirect_uri=https%3A%2F%2Fopeneuler.test.osinfra.cn%2Fzh%2Fmy%2Ftokens&lang=zh
  │              标题：登录 | openEuler社区
  │              （实测确认，client_id=623c3c2f1eca5ad5fca6c58a）
  │
  └─ 已登录 ──► 渲染「个人中心」Tab 页
                 ├─ Tab: 个人中心（ACCOUNT）
                 └─ Tab: 设置/令牌（TOKEN）◄── 目标页
```

页面加载时并发发起：

| 接口 | 作用 |
|------|------|
| `GET /api-workspace/oneid-workbench/version/check` | 版本开关（实测抓到） |
| `GET /oneid/app/verify?client_id=...` | 登录态校验（实测抓到） |
| `GET /api-workspace/oneid-workbench/openapi/getToken` | 令牌列表 |
| `GET /api-workspace/oneid-workbench/openapi/getAllPermissions` | 权限复选项 |

### 1.2 页面三态

tokens 页是**单组件内的状态机**（`pageType`），不是路由跳转：

| pageType | 渲染内容 | 根容器 class |
|----------|---------|-------------|
| `""`（空） | 令牌列表 + 创建按钮 | `.private-token-list` |
| `"CREATE"` | 创建表单（**整页替换列表**） | `.create-or-edit-token` |
| `"EDIT"` | 编辑表单（同容器，标题不同） | `.create-or-edit-token` |

> 🔑 **关键事实**：创建/编辑**不是弹窗**，是同页内容替换。URL 始终是 `/zh/my/tokens`，
> 不会变化。断言"跳转"时必须断言**容器切换**，不能断言 URL。

### 1.3 四个核心操作的完整链路

所有写操作（创建/重新生成/修改/删除）都必须先过 **emailToken 二次验证**：

```
点击操作按钮
  │
  ├─ 内存中有 emailToken？
  │     ├─ 有 ──► 直接调业务接口
  │     └─ 无 ──► 弹出「用户身份验证」弹窗 ────┐
  │                                            │
  │   ┌────────────────────────────────────────┘
  │   ▼
  │  ① 点击验证码输入框右侧「获取验证码」
  │  ② 弹出滑块验证（AJ-Captcha blockPuzzle，api-type=TOKEN）
  │       POST /api-workspace/oneid-workbench/captcha/get
  │  ③ 拖动滑块通过
  │       POST /api-workspace/oneid-workbench/captcha/check → captchaVerification
  │  ④ 自动发送邮箱验证码
  │       POST /api-workspace/oneid-workbench/captcha/sendCode
  │       body: {account: 登录邮箱, captchaVerification, channel: "token_email_check"}
  │       提示：发送成功
  │  ⑤ IMAP 收码，填入 6 位验证码
  │  ⑥ 点击「确认」
  │       POST /api-workspace/oneid-workbench/captcha/verify
  │       body: {account, code} → data.emailToken（32 位 UUID，600s 有效）
  │  ⑦ 弹窗关闭，自动重放被挂起的原操作
  │
  └─► 业务接口（携带 emailToken）
        ├─ 创建：POST openapi/createToken   {name, permissionIds, dayNum, emailToken}
        ├─ 重新生成：POST openapi/refreshToken {id, emailToken}
        ├─ 修改：POST openapi/updateToken   {id, name, permissionIds, dayNum?, emailToken}
        └─ 删除：POST openapi/deleteToken   {id, emailToken}
              │
              └─► 成功后 clearEmailToken() ← ⚠️ emailToken 立即清空
```

> 🔴 **对测试设计影响最大的事实**：`emailToken` 存在 Pinia 内存 store（`ref("")`），
> **每次操作成功后立即清空**。因此「创建 → 重新生成 → 修改 → 删除」四步链路
> 需要 **4 次独立的邮箱验证**（4 次滑块 + 4 封验证码邮件）。
>
> 叠加后端限制「同一邮箱 1 分钟内仅可发送 1 次验证码」（API.md 5.5），
> 全流程用例最短耗时约 **5–6 分钟**，脚本超时必须按此放宽。

### 1.4 创建成功后的令牌展示弹窗

创建 / 重新生成成功后弹出**令牌明文弹窗**（同一组件，`operate-type` 区分）：

| operate-type | 弹窗标题 | 正文提示 |
|--------------|---------|---------|
| `CREATE` | 私人令牌已创建 | 您的私人令牌{token_name}已经生成 |
| `REFRESH` | 私人令牌已重新生成 | 您的私人令牌{token_name}已重新生成，以前的令牌已经失效 |

弹窗结构：
- 顶部提示：`本页面关闭后，网站将不再明文显示私人令牌，请妥善保存`
- 令牌明文输入框（只读展示），后缀「复制」按钮 → 点击提示`复制成功`
- 必勾复选框：`我已经了解私人令牌不再明文显示在平台上，并且已经复制保存好该令牌`
- 「确认」按钮 **勾选前 disabled**，勾选后可点击

> 🔑 令牌明文**仅此一次可见**（后端只存 SHA256），脚本必须在此处抓取并落盘。

---

## 2. 元素定位清单

### 2.1 登录页（实测 DOM，已确认）

| 元素 | 推荐定位器 | 风险 | 备选方案 |
|------|-----------|------|---------|
| 账号输入框 | `input[type="text"].o_input-input` | ✅ 实测 | `page.locator('input[type=text]').first` |
| 密码输入框 | `input[type="password"].o_input-input` | ✅ 实测 | `page.locator('input[type=password]')` |
| 登录按钮 | `button.login-btn` | ✅ 实测 | `page.get_by_role('button', name='登录')` |
| 「账号登录」Tab | `.tab:text-is('账号登录')`（选中态含 `selected`） | ✅ 实测 | `get_by_text('账号登录', exact=True)` |
| 「账号登录」Tab | `page.get_by_text('账号登录', exact=True)` | 🟢 低 | — |
| 「验证码登录」Tab | `page.get_by_text('验证码登录', exact=True)` | 🟢 低 | — |
| 忘记密码 | `page.get_by_role('link', name='忘记密码')` | 🟢 低 | — |

> 🔴 **高风险已确认**：登录页输入框的 `id` 是**每次加载随机生成**的
> （实测本次为 `j13hhhpu` / `1cukfe80`）。**严禁用 id 定位**，必须用
> `type` + class 或结构定位。这是本页面最大的定位陷阱。

### 2.2 令牌列表页（✅ 已登录实测复核）

| 元素 | 推荐定位器 | 置信度 | 备选方案 |
|------|-----------|--------|---------|
| 列表根容器 | `.private-token-list` | ✅ 实测 | — |
| 头部区 | `.private-token-head` | ✅ 实测 | — |
| 「创建私人令牌」按钮 | `page.get_by_role('button', name='创建私人令牌')` | ✅ 实测 | `.private-token-head button` |
| 说明区（含"个人API"链接） | `.create-token-tip` | ✅ 实测 | — |
| 「个人API」链接 | `.create-token-tip .o-link-label` | ✅ 实测（元素存在） | `get_by_text('个人API')` |

> 🔴 **修正 3（原推导错误）**：`.create-token-tip` 内的「个人API」同样是**无 `href`、无 `target`**
> 的 `<a class="o-link">`。原文档标注的"新标签页打开"**未经证实**，跳转由 JS 处理。
> 该场景（N-10）需实跑确认是否真开新标签页，脚本里必须同时兼容"同页跳转"与"新标签页"两种结果。
>
> 说明区完整文案（实测）：`私人令牌可以用于访问 个人API , 私人令牌最多可创建20个`
> —— 20 个上限由页面明示，与源码一致。
| 令牌表格 | `.o-table .o-table-wrap table` | ✅ 实测 | `table` |
| 表头单元格 | `.private-token-list thead th` | ✅ 实测 | — |
| 数据行 | `.private-token-list tbody tr` | ✅ 实测 | — |
| 单元格 | `.private-token-list tbody td` | ✅ 实测 | — |
| 权限项（多值换行） | `.purview-item` | ✅ 实测 | — |
| 行内「重新生成」 | `row.get_by_text('重新生成', exact=True)` | ✅ 实测 | `row.locator('.o-link-label').nth(0)` |
| 行内「修改」 | `row.get_by_text('修改', exact=True)` | ✅ 实测 | `row.locator('.o-link-label').nth(1)` |
| 行内「删除」 | `row.get_by_text('删除', exact=True)` | ✅ 实测 | `row.locator('.o-link-label').nth(2)` |
| 空态提示 | `page.get_by_text('您暂未创建私人令牌')` | 🟡 中（本次账号有数据，未见空态） | — |
| 分页器 | `.o-pagination` | 🟡 中（本次仅 1 条，未渲染） | — |

> 🔴 **修正 1（原推导错误）**：表格**没有** `.o-table-header-cell` / `.o-table-body-row` /
> `.o-table-body-cell` 这类 class。实测是**原生语义标签** `thead th` / `tbody tr` / `tbody td`，
> 仅附带装饰性修饰 class（`.o-row-last`、`.o-cell-last-row`、`.o-cell-last-col`）。
> 这些修饰 class 依赖行位置，**不可用于定位**。
>
> 🔴 **修正 2（原推导错误）**：行内「重新生成/修改/删除」是**无 `href` 的 `<a class="o-link">`**，
> 文案嵌在 `span.o-link-label` 内。无 `href` 的 `<a>` 在 ARIA 中**不具备 link role**，
> 因此 `get_by_role('link', name='删除')` **定位不到**，必须用文本或 `.o-link-label`。

**表格列顺序（源码确认，共 5 列）**：

| # | 列头文案 | 数据字段 |
|---|---------|---------|
| 1 | 令牌名称 | `name` |
| 2 | 权限 | `permissionNames`（逗号分隔，渲染为多个 `.purview-item`） |
| 3 | 到期时间 | `expireAt` |
| 4 | 创建时间 | `createAt` |
| 5 | 操作 | 重新生成 / 修改 / 删除 |

**分页规则（源码确认）**：`pageSize=8`，可选 `[8,16,24]`；
分页器**仅当 `total > 8` 时渲染**，≤8 条时 DOM 中无分页器。

### 2.3 创建表单（✅ 已登录实测复核）/ 编辑表单（🟡 未进入编辑态）

| 元素 | 推荐定位器 | 置信度 | 说明 |
|------|-----------|--------|------|
| 表单根容器 | `.create-or-edit-token` | ✅ 实测 | 创建/编辑共用（实际 class 为 `box create-or-edit-token`） |
| 标题 | `.create-or-edit-token .box-header .header` | ✅ 实测 | 文案 `创建私人令牌` / `编辑私人令牌` |
| 令牌名称标签 | `私人令牌名称` | ✅ 实测 | 带必填星号 `.o-form-require-symbol` |
| 令牌名称输入框 | `.form-input input.o_input-input` | ✅ 实测 | **注意下划线**：`o_input-input`，不是 `o-input-input`；`.form-input` 是外层包裹 div |
| 过期时间标签 | `令牌过期时间` | ✅ 实测 | — |
| 过期时间下拉 | `.custom-day .o-select` | ✅ 实测 | 触发元素 `input.o-select-input[readonly]`，placeholder `请选择` |
| 下拉选项 | `.custom-day .o-option` | ✅ 实测 | 5 项：7天/30天/60天/365天/自定义 |
| 自定义天数输入框 | 选「自定义」后出现，`.o-form-item[field=customTime] input` | 🟡 中 | placeholder `最长不超过365天`，后缀「天」 |
| 实际过期提示 | `.form-item-extra` | 🟢 高 | 文案`该令牌将在{date_time}后过期` |
| 「恢复初始时间」 | `get_by_text('恢复初始时间')` | ✅ 实测 | **仅编辑态且改过时间时出现**，已验证 |
| 权限区标签 | `设置令牌权限` | 🟢 高 | — |
| 权限复选组 | `.form-checkboxgroup .o-checkbox-group-v` | ✅ 实测 | 竖向排列 |
| 单个权限复选框 | `.form-checkboxgroup label.o-checkbox` | ✅ 实测 | `<label>` 标签，含 `.permission-name` + `.permission-description` |
| 按权限名勾选 | `.o-checkbox:has(.permission-name:text-is('meeting-api'))` | ✅ 实测 | **推荐**：语义明确，不依赖顺序 |
| 权限名 | `.permission-name` | ✅ 实测 | 实测 3 项，见下表 |
| 权限描述 | `.permission-description` | ✅ 实测 | — |
| 提交按钮（创建） | `.create-or-edit-token` 内 `get_by_role('button', name='创建', exact=True)` | ✅ 实测 | class `o-btn-solid` |
| 提交按钮（编辑） | `get_by_role('button', name='保存')` | 🟡 中（未进入编辑态） | — |
| 取消按钮 | `get_by_role('button', name='取消')` | ✅ 实测 | class `o-btn-outline`，点击后返回列表态 |

> ⚠️ 「创建」按钮实测**不带 disabled**（空表单也可点击），点击后由前端逐项校验并回显错误，
> 而非置灰拦截。这与原文档 E-01/E-02/E-03 的"拦截"描述不同 —— 见 §4.2 修正。

#### 编辑态与创建态的实测差异（✅ 已实测）

| 项目 | 创建态 | 编辑态 |
|------|-------|-------|
| 标题 | `创建私人令牌` | `编辑私人令牌` |
| 名称输入框 | 空 | **预填**当前令牌名 |
| 过期时间 placeholder | `请选择` | **`重新设定时间`** |
| 过期时间 value | 空 | 空（不预填原值） |
| 权限复选框 | 全未勾 | **预勾选**当前权限 |
| `.form-item-extra` 提示 | 选完时间后才出现 | **进入即显示**`该令牌将在{时间}后过期` |
| 「恢复初始时间」 | 无 | 改过时间后出现 |
| 提交按钮 | `创建` | **`保存`** |
| `.form-input` 数量 | 1 | 1 |

**实测 `.form-item-extra` 文案（有个格式不一致，断言要注意）**：

| 时机 | 实测文案 | 秒 |
|------|---------|---|
| 进入编辑态（原始到期时间） | `该令牌将在2026/09/28 23:59后过期` | **无秒** |
| 改为「30天」后（前端重算） | `该令牌将在2026/10/21 23:59:59后过期` | **有秒** |

> ⚠️ 同一个提示位，原始值不带秒、前端重算值带秒。断言该文案时**不能**用统一的严格格式，
> 建议用 `该令牌将在.*后过期` 宽松匹配，或分两种情况断言。

**实测权限项（该账号可见，共 3 个）**：

| 权限名 | 描述 | checkbox value（实测） |
|-------|------|----------------------|
| `meeting-api` | 调用会议服务API | `1e5a7b3c` |
| `oeas-api` | 调用openEuler远程证明服务API | `3a7f9b2c` |
| `software-pkg-api` | 调用贡献软件包服务API | `e87arhp8` |

> checkbox 的 `value` 即 `permissionId`，`id` 属性为**每次加载随机生成**（实测 `389b0jju` 等），
> 严禁用 `id` 定位。`value` 相对稳定但属后端数据，建议仍按 `.permission-name` 文案定位。

**有效期下拉选项（源码确认）**：

| 选项文案 | 提交值 dayNum |
|---------|--------------|
| 7天 | 7 |
| 30天 | 30 |
| 60天 | 60 |
| 365天 | 365 |
| 自定义 | 取自定义输入框（1–365） |

### 2.4 用户身份验证弹窗（源码级推导）

| 元素 | 推荐定位器 | 置信度 |
|------|-----------|--------|
| 弹窗根 | `.o-dialog.dialog` | ✅ 实测（完整 class：`o-layer o-layer-to-body o-dialog o-dialog-auto o-dialog-responsive dialog`） |
| 弹窗标题 | `get_by_text('用户身份验证')` | ✅ 实测 |
| 提示文案 | `您正在进行私人令牌相关操作，请用绑定的邮箱（guo****@163.com）进行身份验证` | ✅ 实测（邮箱做了脱敏，断言只能用前后缀匹配） |
| 验证码输入框 | `input[placeholder="请输入邮箱中的验证码"]` | ✅ 实测 |
| 「获取验证码」 | `.o-dialog .o-link-label:text-is('获取验证码')` | ✅ 实测（是 `<a class="o-link">`，**不是 button**） |
| 确认按钮 | `.o-dlg-footer` 内 `get_by_role('button', name='确认')` | ✅ 实测 |
| 取消按钮 | `.o-dlg-footer` 内 `get_by_role('button', name='取消')` | ✅ 实测 |
| 弹窗底部区 | `.o-dlg-footer` | ✅ 实测 |

> 🔴 **修正 5（原推导错误）**：验证码输入框**没有 `maxlength` 属性**，也没有 `.form-input` class。
> 实际是 `input.o_input-input`，靠 `placeholder="请输入邮箱中的验证码"` 才能唯一定位。
>
> 🔴 **修正 6（影响所有 disabled 断言）**：「确认」按钮**没有真正的 `disabled` 属性**，
> 只有 CSS class `o-btn-disabled`：
>
> ```html
> <!-- 验证码为空时 -->
> <button type="submit" class="o-btn o-btn-primary o-btn-large o-btn-solid o-btn-disabled">确认</button>
> ```
>
> 因此 Playwright 的 `is_disabled()` / `to_be_disabled()` **恒返回 False**，会把断言写成永远通不过。
> 禁用态必须断 class：
>
> ```python
> expect(btn).to_have_class(re.compile(r"o-btn-disabled"))      # 禁用
> expect(btn).not_to_have_class(re.compile(r"o-btn-disabled"))  # 可用
> ```
>
> 同一规则适用于**登录按钮**和**令牌明文弹窗的确认按钮**。
>
> ⚠️ **弹窗是 teleport 到 body 的**（`o-layer-to-body`），且弹窗打开时**底层创建表单仍在 DOM 中**
> （`.create-or-edit-token` 依然 count=1），页面上会同时存在「创建」「取消」「确认」「取消」多个按钮。
> 所有弹窗内元素定位**必须限定在弹窗作用域内**，否则 strict mode 会报多匹配。

### 2.5 滑块验证（AJ-Captcha，可自动破解）

类名与现有 `slider_solver.py` **完全一致**，算法可直接复用（已实测破解成功）：

| 元素 | 定位器 | 置信度 |
|------|-------|--------|
| 遮罩层 | `.mask` | ✅ 实测 |
| 弹窗根 | `.verifybox` | ✅ 实测 |
| 弹窗标题 | `.verifybox-top` → `请拖动滑块完成人机校验` | ✅ 实测 |
| 关闭按钮 | `.verifybox-close` | ✅ 实测 |
| 底图面板 | `.verify-img-panel`（360×180 显示） | ✅ 实测 |
| 拼图块 | `.verify-sub-block`（54×180） | ✅ 实测 |
| 拖动手柄 | `.verify-move-block`（40×40） | ✅ 实测 |
| 滑动区 | `.verify-bar-area` | ✅ 实测 |
| 提示条 | `.verify-msg` → `向右滑动完成验证` | ✅ 实测 |

> 🔴 **修正 9 —— 滑块的真正陷阱是时序，不是结构**
>
> 直接在 `.verifybox` 可见后立刻调 `solve_slider()` 会失败，报
> 「弹窗内只找到 0 张图，预期 2 张」，实测连挂 3 次。根因：
>
> ```
> 点击「获取验证码」
>   → .verifybox 弹窗 DOM 立即出现（此时 .verify-img-panel 内是空的 <!---->）
>   → POST captcha/get 异步返回
>   → 图片才被塞进 DOM（实测约 3s 后）
> ```
>
> **`.verifybox` 可见 ≠ 可以开始分析**。必须先等图加载解码完成：
>
> ```python
> # 判据：.verifybox 内 naturalWidth > 0 的 <img> 数量 ≥ 2
> page.evaluate("""sel => [...document.querySelector(sel).querySelectorAll('img')]
>                         .filter(i => i.naturalWidth > 0).length""", ".verifybox")
> ```
>
> 已封装为 `slider_token.py`：`wait_captcha_images()` 等图 → 委托 `slider_solver.solve_slider()`。
> 加上等待后**一次拖拽即通过**（实测：底图原图 310×155 → 显示 360px，缩放 1.161，
> 缺口原图 x=117，拖拽 134.9px）。
>
> ⚠️ 排查期间我曾误判图片走 CSS `background-image` —— 实测三个元素的 `background-image`
> 均为 `none`，图**确实是 `<img src="data:image/png;base64,...">`**，与 openGauss 那套同构。

### 2.6 令牌明文弹窗

| 元素 | 推荐定位器 | 置信度 |
|------|-----------|--------|
| 弹窗标题（创建） | `get_by_text('私人令牌已创建')` | ✅ 实测 |
| 弹窗标题（重新生成） | `get_by_text('私人令牌已重新生成')` | 🟡 未实测（未跑重新生成） |
| 顶部提示 | `.created-token-tip` | ✅ 实测 |
| 令牌明文输入框 | `.o-dialog input.o_input-input`（取最后一个） | ✅ 实测 |
| 「复制」按钮 | `.o-dialog .o-link-label:text-is('复制')` | ✅ 实测 |
| 确认复选框 | `.token-auth`（`<label>`，内含 `input[type=checkbox][value="1"]`） | ✅ 实测 |
| 确认按钮 | `.o-dlg-footer` 内 `get_by_role('button', name='确认')` | ✅ 实测（禁用态查 `o-btn-disabled` class，见修正 6） |

**实测弹窗全文**（创建成功，令牌名 `auto_probe_83382`）：

```
私人令牌已创建
本页面关闭后，网站将不再明文显示私人令牌，请妥善保存
您的私人令牌auto_probe_83382已经生成
复制
我已经了解私人令牌不再明文显示在平台上，并且已经复制保存好该令牌
确认
```

> 🔴 **修正 7（原推导错误）**：令牌明文格式**不是** `oepat_` 前缀。
> 实测为 **32 位大写十六进制**，例：`81F9A3C6B3EC3CD971C4BFC51DBB9BD5`。
> 断言正则应为 `^[0-9A-F]{32}$`。
>
> 🔴 **修正 8**：令牌明文输入框**不是 readonly**（实测 `readonly: false`），原文档"只读展示"描述不准。
>
> ✅ **勾选联动已实测验证**：
> - 勾选前：确认按钮 class 含 `o-btn-disabled`
> - 点 `.token-auth` 后：`o-btn-disabled` 移除，checkbox 出现 `checked=""` 属性
>
> 复制按钮点击后确认弹出 Toast `复制成功`。

### 2.7 数量上限弹窗

| 元素 | 定位器 | 置信度 |
|------|-------|--------|
| 标题 | `get_by_text('私人令牌数量已达上限')` | 🟢 高 |
| 正文 | `.max-token-tip` → `已达数量上限，如需新增，请先删除已有令牌` | 🟢 高 |
| 确认按钮 | `get_by_role('button', name='确认')` | 🟢 高 |

### 2.8 未绑定邮箱弹窗

点击「创建私人令牌」时若账号未绑定邮箱，先弹此窗（不进入创建表单）：

| 元素 | 定位器 | 置信度 |
|------|-------|--------|
| 标题 | `get_by_text('绑定邮箱')` | 🟢 高 |
| 提示 | `.bind-email-tip` → `创建私人令牌需要验证您的身份，您的账号还未绑定邮箱，请绑定后在进行身份验证。` | 🟢 高 |

### 2.9 全局消息提示（Toast）

| 元素 | 定位器 | 置信度 |
|------|-------|--------|
| 容器 | `.o-message-list.o-message-list-top` | ✅ 实测（挂在 `</body>` 前，body 层） |
| 单条 | `.o-message`，成功态追加 `.o-message-success` | ✅ 实测 |
| 文本 | `.o-message-content` | ✅ 实测 |
| 图标 | `.o-message-icon` | ✅ 实测 |

实测 HTML 结构：

```html
<div class="o-message-list o-message-list-top">
  <div class="o-message o-message-success">
    <span class="o-message-icon">…svg…</span>
    <div class="o-message-main"><span class="o-message-content">删除成功</span></div>
  </div>
</div>
```

Toast 文案实测确认：`发送成功` ✅、`复制成功` ✅、`删除成功` ✅；`修改成功` 🟡 未实测（未执行保存）。

> ⚠️ Toast 是**自动消失**的，出现窗口很短。必须在触发动作后**立刻**用
> `wait_for_selector` / `expect(...).to_be_visible()` 捕获，不能先做别的操作再回来断言。

---

## 3. 易变动元素风险清单

| 风险等级 | 元素 | 风险说明 | 应对方案 |
|---------|------|---------|---------|
| 🔴 高 | 登录页 input 的 `id` | **每次加载随机生成**（实测 `j13hhhpu`） | 禁用 id，用 `type` + class 定位 |
| 🔴 高 | Vue `data-v-*` scopeId | 构建哈希，版本升级即变（如 `data-v-870fbd1d`） | 严禁用于定位 |
| 🟡 中 | `.o-*` 组件库类名 | OpenDesign 升级可能改名 | 优先 `get_by_role` / `get_by_text`，`.o-*` 仅作备选 |
| 🟡 中 | Nuxt chunk 文件名 | 每次构建哈希变化（`DOwrx8Yc.js`） | 仅分析用，脚本不依赖 |
| 🟡 中 | i18n 文案 | 文案可能调整 | 文案集中到配置文件，便于一处修改 |
| 🟢 低 | 业务语义 class | `.private-token-list` 等源码硬编码 | 首选定位锚点 |
| 🟢 低 | 后端接口路径 | 与 API.md 契约一致 | 可用于网络层断言 |

**定位策略优先级**：
1. 业务语义 class（`.private-token-list`、`.create-or-edit-token`、`.purview-item`）
2. `get_by_role` + 可见文案（`button[name='创建私人令牌']`）
3. 结构定位（容器内相对定位 + `nth`）
4. `.o-*` 组件库类名（备选）
5. ❌ 随机 id、`data-v-*` 哈希

---

## 3.1 补充踩坑（阶段4 自动化实测，2026-09-22）

以下两条来自 `diag_update.py` 的实测证据，均为**脚本侧陷阱**，非系统缺陷。
它们各自让「修改令牌」用例连续多轮失败，且失败表现完全相同：
点「保存」后**不发请求、不弹身份验证、无任何 Toast、静默停在编辑表单**。

### F-19｜令牌名 20 字符上限会静默拦住改名

- **现象**：改名提交后静默失败，`.o-form-item-danger` 文案为
  `请输入1到20个字符。只能由字母、数字、汉字或者特殊字符(_-)组成`；
  网络层捕获到 **0 条**业务接口调用。
- **根因**：测试令牌名原为 `auto_test_{10位时间戳}` = 恰好 20 字符（创建刚好卡在上限通过），
  加 `_renamed` 后缀变 28 字符 → 超限被前端拦截。
- **应对**：测试令牌名控制在 **12 字符以内**，为改名后缀留出余量。
  现用 `auto_{时间戳后6位}` = 11 字符，改名后 19 字符。
- **易误判为**：emailToken 失效、后端响应慢、确认按钮未点击（均已排除）。

### F-20｜`filter(has_text=)` 的子串语义会让「旧名已消失」断言永假

- **现象**：改名确实成功（`✅ Toast：修改成功`），但断言 `not token_exists(旧名)` 失败。
- **根因**：`row_of()` 原用 `filter(has_text=name)`，而 Playwright 该 API 是**子串匹配**。
  `auto_128100` 是 `auto_128100_renamed` 的子串，故改名后按旧名查询仍命中新行。
- **应对**：改为要求行内存在文本**恰好等于** name 的单元格：
  ```python
  page.locator(".private-token-list tbody tr").filter(
      has=page.locator("td").filter(
          has_text=re.compile(rf"^\s*{re.escape(name)}\s*$")))
  ```
- **注意**：该 bug 长期被 F-19 掩盖——改名从未成功过，自然测不到旧名是否消失。

### F-21｜写操作后列表刷新有延迟，读一次就断言会踩竞态

- **现象**：改名实际已成功，但紧接着 `token_exists(旧名)` 仍返回 True，断言「旧名应消失」失败。
- **根因**：后端已生效、前端列表尚未刷新，读到的是旧快照。
- **应对**：凡「写完立刻校验列表」的场景，一律走 `wait_for_token_state()`
  轮询等状态收敛，不要用 `wait_for_timeout(n)` + 读一次
  （固定睡眠治不了竞态，只是把失败概率调低）。
  `create_token` / `update_token` / `delete_token` 三处均已改用该方式。
- **易误判为**：改名功能失效、定位器匹配错误。

### F-22｜用例中途失败留下的遮罩会级联毁掉后续所有用例

- **现象**：某条用例失败后，后续 5 条用例（含此前从未失败的纯前端校验用例）
  全部报 `Locator.click: Timeout`，日志里都是
  `<div class="o-layer-mask"> ... intercepts pointer events`。
  连 fixture 的清理动作本身也被拦住，导致残留令牌删不掉。
- **根因**：用例在弹窗/遮罩打开时抛异常，遮罩留在 DOM 里；
  原先的清障逻辑是「找 `.o-dialog` 里的取消按钮点掉」，实测不可靠。
- **应对**：改用**整页 reload** 做状态复位（`reset_to_clean_list()`），
  它能无条件清掉任何弹窗/遮罩/表单态。在三处调用：
  用例开始前、`auto_cleanup_token` 清理前、`page` fixture 清理前。
  其中「清理前」那次是关键——`auto_cleanup_token` 的 teardown 早于
  `page` 的 teardown，不先复位则删除动作会被遮罩拦住。
- **教训**：多用例共享一个浏览器会话时，**状态复位必须足够暴力**，
  否则一条用例的失败会伪装成一批用例的失败，极大干扰定位。

### 反面教训：不要用代理信号判定操作成功

排查 F-19 期间我曾加过一条兜底：「未捕获『修改成功』Toast，但已离开编辑表单 → 视为成功」。
这个启发式**把失败误报成了成功**——实测出现「表单已关闭但改名未生效」，
`update_token()` 返回 True，直到后续断言才暴露，且报错指向完全无关的方向。

现已改为核对**真实结果**（列表里新名出现且旧名消失）。
判定写操作是否成功，应当校验业务状态本身，而非 Toast 出现、表单关闭这类代理信号。

### 附带修正：编辑态有效期留空**不是**必填错误

- 编辑态「令牌过期时间」不预填原值（placeholder `重新设定时间`、value 为空），
  但实测 `.o-select-danger == 0`，且 `.form-item-extra` 仍显示**原到期时间**。
- 结论：不传 `days` 时后端保留原有效期，**无需**兜底补选。
  曾一度加过「未指定则补 30 天」的逻辑，那会在调用方只想改名时悄悄重置有效期，已撤销。

---

## 4. 场景划分

### 4.1 正常操作（P0）

| 编号 | 场景 | 说明 |
|------|------|------|
| N-01 | 登录并进入 tokens 页 | 校验重定向回 `/zh/my/tokens` |
| N-02 | 列表首屏渲染 | 表头 5 列、空态或数据态 |
| N-03 | 创建令牌（7天 + 单权限） | 全链路含滑块 + 邮箱验证 |
| N-04 | 创建令牌（自定义天数 + 多权限） | 自定义分支 |
| N-05 | 重新生成令牌 | 校验弹窗文案含"以前的令牌已经失效" |
| N-06 | 修改令牌（改名 + 改权限） | 校验`修改成功` |
| N-07 | 修改令牌（重设有效期） | 校验「恢复初始时间」出现 |
| N-08 | 删除令牌 | 校验`删除成功` + 列表移除 |
| N-09 | 复制令牌明文 | 校验`复制成功` |
| ~~N-10~~ | ~~「个人API」外链~~ | ❌ **不覆盖**（阿蓁 2026-09-21 决策 Q7）：不纠结是否开新标签页，核心断言聚焦「令牌创建成功」的识别 |

### 4.2 空输入 / 校验（P1）

| 编号 | 场景 | 预期（✅ 已实测） |
|------|------|------|
| E-01 | 全空表单点「创建」 | ✅ 实测：三项同时报错，`.o-form-item` 追加 `o-form-item-danger`，**不发业务请求、不离开表单** |
| E-01a | 名称留空 | ✅ 实测提示 **`输入不能为空`**（**修正**：原文档写的是字符规则提示，实际空值提示不同） |
| E-01b | 有效期不选 | ✅ 实测提示 `请选择`，下拉框追加 `o-select-danger` |
| E-01c | 权限不勾选 | ✅ 实测提示 `请勾选令牌权限` |
| E-04 | 验证码留空 | 🟡 待实测：「确认」按钮 disabled |
| E-05 | 令牌弹窗不勾选确认 | 🟡 待实测：「确认」按钮 disabled |

**错误提示定位器（实测）**：

| 元素 | 定位器 |
|------|-------|
| 单项错误容器 | `.o-form-item-danger` |
| 错误文案 | `.o-form-item-message.type-danger` |
| 下拉错误态 | `.o-select-danger` |
| 输入框错误态 | `.o_box-danger` |

### 4.3 错误输入（P1）

| 编号 | 场景 | 预期 |
|------|------|------|
| W-01 | 名称含非法字符（如 `@#$`） | 提示`请输入1到20个字符。只能由字母、数字、汉字或者特殊字符(_-)组成` |
| W-02 | 名称超 20 字符 | 同上 |
| W-03 | 名称重复 | 后端 `1003 TOKEN_NAME_REPEATED` |
| W-04 | 自定义天数填 0 / 366 | 前端校验拦截（1–365） |
| W-05 | 自定义天数填非整数 | 提示`只能输入整数` |
| W-06 | 邮箱验证码填错 | 后端 `1008 EMAIL_CODE_ERROR` |
| W-07 | 登录密码错误 | 登录页报错，不跳转 |

### 4.4 边界 / 阻塞（P2）

| 编号 | 场景 | 预期 |
|------|------|------|
| ~~B-01~~ | ~~令牌数达 20 个~~ | ❌ **不覆盖**（阿蓁 2026-09-21 决策 Q8）：造 19 个令牌需 20+ 分钟，成本过高。定位器保留在 §2.7 备用 |
| B-02 | 未绑定邮箱 | 点创建弹`绑定邮箱` |
| B-03 | 滑块连续失败 | 刷新重试，3 次后回落人工 |
| B-04 | 1 分钟内重复点「获取验证码」 | 后端 `Verify Code has been sent` |
| B-05 | 列表 > 8 条 | 分页器出现 |
| B-06 | 页面加载超时 | 30s 超时 → 截图 + 明确报错 |
| B-07 | emailToken 过期（>600s） | 后端 `2004 EMAIL_TOKEN_ERROR` |
| B-08 | 未登录直接访问 | 302 到登录页 |
| B-09 | 重复提交（连点创建） | 不应产生两条记录 |

---

## 5. 断言校验点

### 5.1 页面级

| 断言 | 期望值 |
|------|-------|
| 登录页标题 | `登录 | openEuler社区` |
| 登录页 URL | 含 `openeuler-usercenter.test.osinfra.cn/login` 且 `redirect_uri` 指向 `/zh/my/tokens` |
| 登录后 URL | `https://openeuler.test.osinfra.cn/zh/my/tokens` |
| 列表容器 | `.private-token-list` 可见 |

### 5.2 列表级

| 断言 | 期望值 |
|------|-------|
| 表头 | 依序为 `令牌名称` `权限` `到期时间` `创建时间` `操作` |
| 行操作 | 每行含 `重新生成` `修改` `删除` |
| 空态 | 无数据时显示 `您暂未创建私人令牌`（🟡 未实测到） |
| 到期时间格式 | ✅ **修正 4**：实测为 `YYYY/MM/DD HH:mm`（斜杠分隔、**无秒**），如 `2027/01/09 23:59`。正则 `^\d{4}/\d{2}/\d{2} \d{2}:\d{2}$` |
| 创建时间格式 | 同上，实测 `2026/01/09 14:31` |
| 分页器 | `total>8` 时存在（实测 1 条时 DOM 中确实无分页器，`</table>` 后为 `<!--v-if-->`） |

### 5.3 操作结果级

| 操作 | 断言 |
|------|------|
| 创建成功 | 弹窗标题 `私人令牌已创建`；正文含令牌名；明文以 `oepat_` 开头；列表新增该行 |
| 重新生成 | 弹窗标题 `私人令牌已重新生成`；正文含 `以前的令牌已经失效`；明文与旧值不同 |
| 修改成功 | Toast `修改成功`；列表该行名称/权限已更新 |
| 删除成功 | Toast `删除成功`；列表不再含该名称；总数 -1 |
| 复制 | Toast `复制成功` |
| 发送验证码 | Toast `发送成功` |

### 5.4 网络层（辅助断言）

| 接口 | 断言 |
|------|------|
| `openapi/createToken` | 200 且 `data.token` 非空 |
| `openapi/getToken` | 200 且 `data` 为数组 |
| `captcha/verify` | 200 且 `data.emailToken` 长度 32 |
| `captcha/sendCode` | 200 且 `code=200` |

---

## 5.5 实测复核记录（2026-09-21 17:11，脚本 `phase1_probe.py`）

登录账号 `guozhi1992@163.com`（用户名 `guoxiaozhen2`），产物 `out/01_landing` ~ `out/08_back_to_list`。
**只读执行**：登录 → 列表 → 打开创建表单 → 空表单提交采集校验 → 展开下拉 → 取消返回。
**未产生任何数据**（未创建/未重新生成/未修改/未删除）。

### 新确认的关键事实（原文档未覆盖）

| # | 事实 | 对脚本的影响 |
|---|------|-------------|
| F-1 | 登录页是 **SPA 壳**：首屏标题为 `openEuler starter`，随后才变 `登录 \| openEuler社区` | **不能**用固定 sleep 或首屏标题判断加载完成，必须显式等 `input[type=password]` |
| F-2 | 令牌页存在**持续轮询请求**，`networkidle` **永不达成** | 🔴 **严禁** `wait_for_load_state('networkidle')`，本次调试已因此误判登录失败。只能等 URL + 业务容器 |
| F-3 | 登录按钮初始 **disabled**（class 含 `o-btn-disabled`），账号密码**都填完后自动启用** | 可作为断言点；填完需等按钮可用再点 |
| F-4 | 登录页**无协议勾选框**（实测 checkbox 数为 0） | 登录流程无需勾选步骤 |
| F-5 | 该测试账号登录**未触发滑块** | 滑块分支仍需保留（后端策略可能变），但登录路径通常直达 |
| F-6 | 创建/编辑是**同页状态切换**，URL 恒为 `/zh/my/tokens`，标题也不变 | 断言必须用容器切换（`.private-token-list` ⇄ `.create-or-edit-token`），不能断言 URL/标题 |
| F-7 | 下拉选项常驻 DOM，藏在 `.o-select-option-wrap[style="display: none"]` 内 | `.o-option` 的 `count` 恒为 5，**必须断 `visible`**，不能断 `count` |
| F-8 | 该账号当前有 **1 个**令牌：`software_token` / `software-pkg-api` / 到期 `2027/01/09 23:59` | 距 20 上限很远，B-01 需先造数据才能触达 |
| F-9 | 所有 `input` 的 `id` **每次加载重新随机**（本次登录页 `nwast0la`/`fvbdiggm`，名称框 `5k1dqpvb`，权限框 `389b0jju`/`6ftvdf4t`/`h0tfy09q`） | 🔴 **绝对禁止**用 id 定位 |
| F-10 | `data-v-*` 作用域哈希实测：列表 `data-v-870fbd1d`、表单 `data-v-3c93cfd7` / `data-v-0d81cdb2` | 🔴 构建哈希，严禁用于定位 |
| F-11 | Tab 面板用 `data-tab-pane-key="TOKEN"` 标识 | 可作为稳定锚点：`.o-tab-pane[data-tab-pane-key="TOKEN"]` |

### 本次实测确认的接口调用

匿名首访 → `302` 到 `openeuler-usercenter.test.osinfra.cn/login`，
`redirect_uri=https%3A%2F%2Fopeneuler.test.osinfra.cn%2Fzh%2Fmy%2Ftokens&lang=zh`（与原文档一致）。
登录后共抓到 13 条 `/api-workspace/` 与 `/oneid/` 接口调用，明细见 `out/network.json`。

---

## 5.6 写操作链路实测记录（2026-09-21 17:36–17:54，Q3 放行后）

脚本：`phase1_probe_write.py`（创建+编辑探查）、`cleanup_probe_tokens.py`（删除+清理）、
`diag_captcha.py`（滑块接口诊断）。测试令牌 `auto_probe_83382`，**自建自删，已确认清理干净**
（收尾列表恢复为 `['software_token']`，既有令牌未被触碰）。

### 实跑结果

| 环节 | 结果 | 关键证据 |
|------|------|---------|
| 创建令牌 | ✅ 成功 | 明文 `81F9A3C6B3EC3CD971C4BFC51DBB9BD5`（32位大写十六进制） |
| 身份验证弹窗 | ✅ 实测 | 滑块 → 邮箱取码 `776827` → 确认 |
| 令牌明文弹窗 | ✅ 实测 | 标题 `私人令牌已创建`，勾选联动已验证 |
| 复制令牌 | ✅ 实测 | Toast `复制成功` |
| 列表新增 | ✅ 实测 | 列表出现 `auto_probe_83382` |
| 编辑态结构 | ✅ 实测 | 标题 `编辑私人令牌`，提交按钮 `保存`，「恢复初始时间」已验证 |
| 删除令牌 | ✅ 成功 | 滑块自动破解 → 取码 `071721` → Toast `删除成功` → 列表行数 0 |
| 重新生成 | ⬜ 未跑 | 组件与创建共用，仅 `operate-type` 与标题不同 |
| 保存修改 | ⬜ 未跑 | 编辑态只抓结构后取消，未提交 |

### 时序实录（供阶段 4 排编排与超时用）

```
17:36:46  创建：发送成功 Toast
17:36:48  创建：邮箱取码成功（IMAP 第 1 次轮询即命中，约 2s）
17:36:49  创建：令牌明文弹窗出现
17:36:50  创建：列表已新增
17:36:55  删除：身份验证弹窗出现
17:36:55  删除：触发后端限流，等待 49s
17:53:46  删除：滑块弹出 → 等图就绪 → 一次拖拽通过（约 4s）
17:53:53  删除：发送成功 Toast
17:54:00  删除：邮箱取码成功（第 2 次轮询，约 7s）
17:54:01  删除：Toast 删除成功
```

**实测结论**：单个写操作（含滑块 + 邮箱验证）约 **15–20s**，
但相邻两次操作间会撞后端限流，需补等 **约 50–65s**。
四步全链路（创建→重新生成→修改→删除）预估 **4–5 分钟**，与 Q5 的 600s 超时设定匹配。

### 踩坑追加（阶段 2/3 必须规避）

| # | 坑 | 规避方式 |
|---|---|---|
| F-12 | 复用 `storage_state` 失效，且**失效重定向是异步的** —— `goto` 返回时 URL 还是目标页，之后才跳登录页 | 不复用登录态；落地判断必须等 `input[type=password]` 或 `.private-token-list` 真实出现后再做 |
| F-13 | hydration 未完成就点「创建私人令牌」，点击穿透触发 SSR Tab 链接，**误跳 `/zh/my/settings`** | 先等 `.o-tab-pane-active[data-tab-pane-key="TOKEN"]` + `.private-token-head button`，再留缓冲；并加跳错自愈重试 |
| F-14 | 登录页偶发抽风，30s 仍停在 SPA 壳（实测 17:31 一次） | 改成轮询 + 整页重载重试，不要一次性长等就判死（实测重载后 3s 即落地） |
| F-15 | 有效期下拉点内层 `input.o-select-input[readonly]` **不展开** | 必须点 `.o-select` 容器 |
| F-16 | 下拉展开后选项被 **Vue Teleport 移到 body 层** `.o-popup > .o-select-options`，已不在 `.custom-day` 内 | 等待与点击选项**不能带 `.custom-day` 前缀**，用 `.o-select-options:visible .o-option` |
| F-17 | 弹窗 teleport 到 body，且底层表单仍在 DOM，页面同时存在多个「确认」「取消」 | 弹窗内定位必须限定 `.o-dialog` / `.o-dlg-footer` 作用域 |
| F-18 | 禁用态只有 CSS class `o-btn-disabled`，**无 `disabled` 属性** | 断言查 class，`is_disabled()` 恒 False |

---

## 6. 疑问清单

### 已结清（本次实测解决）

| # | 疑问 | 结论 |
|---|------|------|
| Q1 | 测试账号能否登录 | ✅ **已解决**：`config.yaml` 的 `guozhi1992@163.com / Aa123456@` 可正常登录，用户名 `guoxiaozhen2`，无滑块 |
| Q2 | 账号绑定邮箱 | ✅ **已解决**：登录账号本身就是 163 邮箱，与 IMAP 授权码 `FRqpKBdvcMSabj2m` 同一邮箱，`email_verify.py` 可直接复用 |
| Q4 | 项目落地目录 | ✅ **已定**：`D:\gxz\ai_gxz\oneid-workbench\`（与 `email_verify.py`/`slider_solver.py` 同目录，直接 import，无需复制） |
| Q6 | 用哪种登录方式 | ✅ **已定**：「账号登录」Tab，实测稳定 |

### 阿蓁 2026-09-21 决策（全部结清，无遗留阻塞）

| # | 疑问 | 决策 | 落地约束 |
|---|------|------|---------|
| **Q3** | test 环境是否放行真实写操作 | ✅ **放行** | 自动化只创建/修改/删除 `auto_` 前缀令牌；**既有 `software_token` 绝不触碰**，脚本需硬编码该保护名单 |
| **Q5** | 全链路 5–6 分钟耗时是否接受 | ✅ **接受** | 全链路用例超时 600s；异常场景用例不走邮箱验证以省时间；后端限流 1 分钟 1 封，连续操作间需补等待 |
| **Q7** | 「个人API」是否开新标签页 | ✅ **不纠结**，只要能识别到令牌创建成功即可 | N-10 场景移除；断言重心放在「创建成功」的识别（见下方判定标准） |
| **Q8** | 是否覆盖令牌数达上限（20 个） | ✅ **不覆盖** | B-01 场景移除；§2.7 上限弹窗定位器保留备用 |

**「令牌创建成功」判定标准（按 Q7 决策明确为核心断言）**，以下三条同时成立才算成功：

1. 令牌明文弹窗出现，标题为 `私人令牌已创建`
2. 弹窗内令牌明文非空（明文**仅此一次可见**，必须立即抓取落盘）
3. 确认关闭后，列表中新增该令牌名对应的数据行

---

## 7. 阶段 1 结论

- ✅ **全链路已实测**：只读部分（§5.5）+ 写操作部分（§5.6）。创建、编辑态、删除
  全部真机跑通，滑块自动破解成功，邮箱验证码自动取码成功
- ✅ **定位清单已坐实**：原 🟡 推导项逐条升级为 ✅ 实测，仅「重新生成弹窗标题」
  「修改成功 Toast」「空态提示」「分页器」仍为 🟡（对应操作未执行或数据条件未满足）
- 🔴 **累计修正 9 处原推导错误**：
  1. 表格无 `.o-table-body-row` 等 class，实为原生 `thead th` / `tbody tr` / `tbody td`
  2. 时间格式是 `YYYY/MM/DD HH:mm`（无秒），不是 `YYYY-MM-DD HH:mm:ss`
  3. 行内操作与「个人API」是**无 href 的 `<a>`**，`get_by_role('link')` 定位不到
  4. 名称留空的提示是 `输入不能为空`，不是字符规则提示
  5. 验证码输入框无 `maxlength`、无 `.form-input`，只能靠 placeholder 定位
  6. **禁用态只有 CSS class `o-btn-disabled`，无 `disabled` 属性** —— `is_disabled()` 恒 False
  7. 令牌明文是 32 位大写十六进制，**不是** `oepat_` 前缀
  8. 令牌明文输入框**不是** readonly
  9. 滑块的坑是**时序**（图约 3s 后才进 DOM），不是结构
- ⚠️ **七条铁律**（全部有实测代价，阶段 2 工具层必须内置规避）：
  - `networkidle` 永不达成，严禁使用
  - 所有 `input` 的 `id` 每次随机，`data-v-*` 是构建哈希，两者都严禁用于定位
  - 禁用态断 class，不断 `is_disabled()`
  - 下拉选项 teleport 到 body，等待不能带容器前缀
  - 弹窗 teleport 到 body 且底层表单不卸载，弹窗内定位必须限定作用域
  - 点「创建私人令牌」前必须等 hydration 收敛，否则误跳 `/zh/my/settings`
  - 滑块必须等图加载完（`<img>` 且 `naturalWidth>0` ≥ 2 张）再破解
- ✅ **无遗留阻塞项**：Q1/Q2/Q3/Q4/Q5/Q6/Q7/Q8 全部结清
- 🧹 **测试数据已清理**：探查令牌已自行删除，列表恢复为 `['software_token']`

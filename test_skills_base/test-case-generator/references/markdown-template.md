# Markdown 用例表模板（人机两用）

## 文档结构

```
# 测试用例集：<项目/模块名>

> 元信息块（输入文档、用例总数、优先级分布、AI 执行工具）

## 一、模块 A
### 1.1 功能点 A.1（接口用例 或 UI 用例）
| 表头 8 列 |
| 用例行 1 |
```agent-exec
（紧跟用例行 1 的执行块）
```
| 用例行 2 |
```agent-exec
（紧跟用例行 2 的执行块）
```
...

## 二、覆盖矩阵
## 三、需补充信息（如有）
```

**关键**：每条用例的表格行与 `agent-exec` 块**交替排列**，紧邻；不要把所有 agent-exec 堆在文档末尾。

## 标准表头

```markdown
| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
```

表格内换行用 `<br>`；编号步骤用 `1. xxx<br>2. xxx`。

## 完整样例（接口用例 + UI 用例混合）

````markdown
# 测试用例集：用户登录模块 v2.5.0

> 输入文档：PRD-2026-LOGIN-V2.5.docx、API-Login-v2.5.yaml、登录页设计稿.fig
> 用例总数：6 条 ｜ P0：3 ｜ P1：2 ｜ P2：1
> AI 执行工具：curl + playwright

## 一、登录接口（接口用例）

### 1.1 POST /api/v1/user/login

| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-API-LOGIN-001 | 用户中心/登录接口 | POST /api/v1/user/login | [正常流] 合法账号密码登录返回 token | 1. 账号 test001@example.com 已注册，密码 Test@1234 | 1. 请求方式：POST<br>2. URL：https://api.example.com/api/v1/user/login<br>3. Headers：Content-Type: application/json<br>4. Body：{"account":"test001@example.com","password":"Test@1234"}<br>5. 发送请求 | 1. HTTP 200<br>2. body.code=0<br>3. body.data.token 非空，长度 ≥ 32<br>4. body.data.userId=1001 | P0 |

```agent-exec
type: api
tool: curl
request:
  method: POST
  url: https://api.example.com/api/v1/user/login
  headers:
    Content-Type: application/json
  body:
    account: test001@example.com
    password: Test@1234
assertions:
  - http_status: 200
  - jsonpath: $.code
    equals: 0
  - jsonpath: $.data.token
    not_empty: true
    type: string
    min_length: 32
  - jsonpath: $.data.userId
    equals: 1001
```

| TC-API-LOGIN-002 | 用户中心/登录接口 | POST /api/v1/user/login | [异常][异常输入] 密码错误返回 4002 | 1. 账号 test001@example.com 已注册 | 1. POST 同上 URL<br>2. Body：{"account":"test001@example.com","password":"WrongPass1!"} | 1. HTTP 200<br>2. body.code=4002<br>3. body.message="账号或密码错误"<br>4. body.data 为 null | P0 |

```agent-exec
type: api
tool: curl
request:
  method: POST
  url: https://api.example.com/api/v1/user/login
  headers:
    Content-Type: application/json
  body:
    account: test001@example.com
    password: WrongPass1!
assertions:
  - http_status: 200
  - jsonpath: $.code
    equals: 4002
  - jsonpath: $.message
    equals: '账号或密码错误'
  - jsonpath: $.data
    is_null: true
```

| TC-API-LOGIN-003 | 用户中心/登录接口 | POST /api/v1/user/login | [空值] account 字段缺失返回 4001 | — | 1. POST 同上 URL<br>2. Body：{"password":"Test@1234"}（不传 account） | 1. HTTP 400<br>2. body.code=4001<br>3. body.message 含 "account is required" | P1 |

```agent-exec
type: api
tool: curl
request:
  method: POST
  url: https://api.example.com/api/v1/user/login
  headers:
    Content-Type: application/json
  body:
    password: Test@1234
assertions:
  - http_status: 400
  - jsonpath: $.code
    equals: 4001
  - jsonpath: $.message
    contains: 'account is required'
```

| TC-API-LOGIN-004 | 用户中心/登录接口 | POST /api/v1/user/login | [特殊字符][SQL注入] account 含 SQL 注入串被拒绝 | — | 1. POST 同上 URL<br>2. Body：{"account":"test' OR '1'='1","password":"any"} | 1. HTTP 400<br>2. body.code=4001<br>3. 响应不暴露 SQL 错误信息 | P0 |

```agent-exec
type: api
tool: curl
request:
  method: POST
  url: https://api.example.com/api/v1/user/login
  headers:
    Content-Type: application/json
  body:
    account: "test' OR '1'='1"
    password: any
assertions:
  - http_status: 400
  - jsonpath: $.code
    equals: 4001
  - jsonpath: $.message
    not_contains: 'SQL'
  - jsonpath: $.message
    not_contains: 'syntax'
```

## 二、登录页（UI 用例）

### 2.1 /login 页面交互

| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-UI-LOGIN-001 | 用户中心/登录页 | 账号密码登录 | [正常流] 合法账号密码可登录成功 | 1. 已注册账号 test001@example.com<br>2. 密码 Test@1234<br>3. 浏览器已清除 Cookie | 1. 浏览器打开 https://app.example.com/login<br>2. 在【账号】输入框输入 test001@example.com<br>3. 在【密码】输入框输入 Test@1234<br>4. 点击【登录】按钮 | 1. 【登录】按钮显示加载态<br>2. 触发 POST /api/v1/login，返回 200，code=0<br>3. 跳转至 /dashboard<br>4. 顶部显示「test001」<br>5. localStorage 含 access_token | P0 |

```agent-exec
type: ui
tool: playwright
viewport: { width: 1280, height: 800 }
steps:
  - action: navigate
    url: https://app.example.com/login
    wait_until: domcontentloaded
  - action: fill
    selector: 'input[name="account"]'
    aria_label: '账号'
    value: test001@example.com
  - action: fill
    selector: 'input[name="password"]'
    aria_label: '密码'
    value: Test@1234
  - action: click
    selector: 'button:has-text("登录")'
    aria_label: '登录'
  - action: wait_for_url
    url_contains: '/dashboard'
    timeout_ms: 5000
assertions:
  - type: url
    equals: https://app.example.com/dashboard
  - type: text_visible
    selector: 'header'
    contains: 'test001'
  - type: storage
    storage: localStorage
    key: access_token
    not_empty: true
  - type: network
    method: POST
    url_contains: /api/v1/login
    response_status: 200
    response_jsonpath: $.code
    equals: 0
```

| TC-UI-LOGIN-002 | 用户中心/登录页 | 账号密码登录 | [空值] 密码为空时【登录】按钮 disabled | — | 1. 打开登录页<br>2. 在【账号】输入框输入 test001@example.com<br>3. 不在【密码】输入框输入任何内容<br>4. 观察【登录】按钮状态 | 1. 【登录】按钮 disabled<br>2. 点击无任何接口请求 | P1 |

```agent-exec
type: ui
tool: playwright
steps:
  - action: navigate
    url: https://app.example.com/login
  - action: fill
    selector: 'input[name="account"]'
    value: test001@example.com
  - action: focus
    selector: 'input[name="password"]'
  - action: blur
    selector: 'input[name="password"]'
assertions:
  - type: element_state
    selector: 'button:has-text("登录")'
    state: disabled
  - type: network
    method: POST
    url_contains: /api/v1/login
    expected: none
```

## 三、覆盖矩阵

| 功能点 \ 维度 | 1 正常流 | 2 异常 | 3 边界 | 4 空值 | 5 特殊字符 | 6 权限 | 7 唯一性 | 8 重复 | 9 异常输入 | 备注 |
|---|---|---|---|---|---|---|---|---|---|---|
| POST /api/v1/user/login | ✓ | ✓ | — | ✓ | ✓ | — | N/A | — | ✓ | 唯一性 N/A；边界/权限/重复待补 |
| 登录页 UI | ✓ | — | — | ✓ | — | — | N/A | — | — | 接口断言已在 UI 用例中覆盖 |

## 四、需补充信息

```
1. [字段] 邮箱/密码长度上下限与字符集？
2. [错误码] 4001/4002/4291 文案与触发条件？
3. [限流] 登录接口的限流阈值（单 IP / 单账号）？
4. [选择器] 登录页【账号】【密码】【登录】是否有稳定的 data-testid？
5. [鉴权] 受保护接口的 Token 形态（Bearer / Cookie / API Key）？
```
````

## 导入工具适配

`agent-exec` 代码块对人类导入工具不可见（被表格列分隔，工具按 8 列读取）；对 AI 可见（解析 markdown 时识别 fenced code block）。

| 工具 | 操作 | 对 agent-exec 的处理 |
|---|---|---|
| 禅道 | 复制 8 列表格 → 转 Excel → 导入 | 自动忽略 agent-exec 块 |
| Tapd | Markdown / Excel 导入 | 同上 |
| Jira / Xray | 转 CSV → 导入 | 同上 |
| TestRail | 转 CSV → 导入 | 同上 |
| AI 自动化执行 | 直接读 Markdown 文件 | 解析 agent-exec 块为工具调用 |

## 字段填写禁止项

- ❌ 用「正常」「成功」「失败」「不行」描述预期
- ❌ 用「合法的xx」「合适的xx」描述测试数据
- ❌ 用「环境就绪」描述前置条件
- ❌ 把多个验证点塞在一条用例里
- ❌ 在文档无依据的情况下编造金额、阈值、错误码
- ❌ agent-exec 块用 `<placeholder>` 假占位
- ❌ agent-exec 块的 selector 写中文名称而非可定位特征

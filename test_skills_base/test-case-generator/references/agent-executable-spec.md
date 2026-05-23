# AI 可执行块（agent-exec）规范

本规范定义每条测试用例附带的 `agent-exec` YAML 代码块的 schema。AI（Claude / Cursor / 其他 LLM agent）读到该块即可直接转为工具调用并执行，无需用户二次解释。

## 顶层 schema

```yaml
type: api | ui                       # 必填
tool: <工具名>                       # 必填，见下方"工具映射"
# 以下根据 type 不同有不同字段
```

## type=api（接口用例）

### 推荐工具
| tool | 实际执行方式 |
|---|---|
| `curl` | Bash 工具调用 curl，最通用 |
| `bash` | 任意 shell 脚本 |
| `http-mcp` | 通过 HTTP MCP server 调用 |

### 完整 schema

```yaml
type: api
tool: curl
request:
  method: GET | POST | PUT | DELETE | PATCH
  url: <完整 URL>
  path_params:                       # 可选，已插入 url 中也可省略
    key: value
  query_params:                      # 可选
    key: value
  headers:                           # 必填
    Content-Type: application/json
    Authorization: 'Bearer {{TOKEN}}' # 鉴权占位符在执行前由 AI 注入
  body:                              # POST/PUT/PATCH 必填
    field1: value1
    field2: value2
  body_type: json | form-urlencoded | multipart # 默认 json
  timeout_ms: 10000                   # 可选，默认 10000
  retry: 0                            # 可选，默认 0

assertions:                          # 必填，至少 1 条
  - http_status: 200                 # HTTP 状态码
  - jsonpath: $.code                 # 业务 code
    equals: 0
  - jsonpath: $.data.token
    not_empty: true
    type: string
    min_length: 32
  - jsonpath: $.data.user.role
    in: [admin, user, guest]
  - jsonpath: $.data.created_at
    matches_regex: '^\d{4}-\d{2}-\d{2}'
  - header: X-Trace-Id
    not_empty: true
  - response_time_ms:
      lt: 500

side_effects:                        # 可选，副作用断言（DB/MQ/缓存）
  - description: 表 t_user_login_log 新增 status=success 记录
    verification_hint: 'SELECT * FROM t_user_login_log WHERE account=? AND status=?'
  - description: Redis session:{userId} 写入 TTL=7200

depends_on:                          # 可选，前置依赖用例 ID
  - TC-API-LOGIN-001                  # 例如：依赖登录用例获取 token

setup:                               # 可选，执行前数据准备
  - description: 创建测试账号 test001@example.com
    method: api_call | sql | manual

teardown:                            # 可选，执行后清理
  - description: 删除创建的 Issue
    method: api_call | sql | manual
```

### 断言操作符清单

| 操作符 | 含义 | 示例 |
|---|---|---|
| `equals` | 等于 | `equals: 0` |
| `not_equals` | 不等于 | `not_equals: null` |
| `in` | 属于枚举 | `in: [200, 201]` |
| `contains` | 包含子串 | `contains: 'success'` |
| `not_contains` | 不含子串 | `not_contains: 'error'` |
| `matches_regex` | 正则匹配 | `matches_regex: '^Bearer .+'` |
| `not_empty` | 非空 | `not_empty: true` |
| `is_null` | 为 null | `is_null: true` |
| `min_length` / `max_length` | 字符串长度 | `min_length: 32` |
| `gt` / `gte` / `lt` / `lte` | 数值比较 | `lt: 500` |
| `type` | 类型断言 | `type: string \| number \| boolean \| array \| object` |
| `length` | 数组/字符串长度 | `length: 5` |

### 鉴权占位符约定

避免在用例中硬编码敏感 token，使用 `{{VAR}}` 占位符：
- `{{TOKEN}}` / `{{ACCESS_TOKEN}}` — 通用访问令牌
- `{{PAT}}` — Personal Access Token
- `{{COOKIE}}` — Cookie 串
- `{{API_KEY}}` — API Key
- `{{USER_TOKEN}}` / `{{ADMIN_TOKEN}}` — 角色差异化 token

执行前由 AI 从环境变量、用户输入或 setup 步骤注入。

## type=ui（UI 用例）

### 推荐工具
| tool | 实际执行方式 |
|---|---|
| `playwright` | 通过 mcp__playwright__ 一族工具 |
| `agent-browser` | 通过 agent-browser skill |

### 完整 schema

```yaml
type: ui
tool: playwright
viewport: { width: 1280, height: 800 } # 可选，默认 1280x720
browser: chromium | firefox | webkit   # 可选，默认 chromium
headless: true                         # 可选，默认 false

setup:                                  # 可选
  - description: 已通过 API 登录获得 cookie
    cookies:
      - name: session_id
        value: '{{SESSION_ID}}'
        domain: example.com

steps:                                  # 必填，按顺序执行
  - action: navigate
    url: https://staging.example.com/login
    wait_until: load | domcontentloaded | networkidle  # 可选

  - action: fill
    selector: 'input[name="account"]'
    aria_label: '账号'                # 可选，selector 备选
    value: test001@example.com

  - action: click
    selector: 'button:has-text("登录")'

  - action: wait_for_url
    url_contains: '/dashboard'
    timeout_ms: 5000

  - action: wait_for_selector
    selector: '.user-avatar'
    state: visible | hidden | attached | detached
    timeout_ms: 3000

  - action: select
    selector: 'select[name="role"]'
    value: 'admin'

  - action: check                        # 勾选 checkbox
    selector: 'input[name="agree"]'

  - action: hover
    selector: '.menu-item'

  - action: scroll
    selector: '.bottom-section'
    direction: into_view | down | up

  - action: press_key
    key: 'Enter'

  - action: upload
    selector: 'input[type="file"]'
    file_path: ./assets/test.png

  - action: screenshot                   # 可选，截图作为证据
    name: after-login
    full_page: true

  - action: evaluate                     # 注入脚本读取页面状态
    script: 'return localStorage.getItem("access_token")'
    capture_as: token_value

assertions:                              # 必填，至少 1 条
  - type: url
    equals: https://staging.example.com/dashboard
    # 或者：url_contains: '/dashboard'

  - type: text_visible
    selector: 'header .username'
    contains: 'test001'

  - type: element_state
    selector: 'button:has-text("登录")'
    state: enabled | disabled | visible | hidden

  - type: attribute
    selector: 'input[name="email"]'
    attribute: 'aria-invalid'
    equals: 'true'

  - type: count
    selector: '.error-message'
    equals: 1

  - type: storage
    storage: localStorage | sessionStorage | cookie
    key: access_token
    not_empty: true

  - type: network                        # 验证页面操作触发的接口
    method: POST
    url_contains: /api/v1/login
    response_status: 200
    response_jsonpath: $.code
    equals: 0

  - type: console
    level: error
    expected: none                       # 无 error 级别日志

  - type: screenshot_diff                # 可选，视觉回归
    baseline: ./baseline/login-success.png
    threshold: 0.1
```

### 选择器优先级（生成时遵循）

按以下优先级生成选择器，越靠前越稳定：

1. `aria-label` / `role` —— 无障碍属性，最稳定且语义化
2. `data-testid` / `data-test` —— 专为测试设计的属性
3. `id` —— 注意是否动态生成
4. `name` —— 表单控件常用
5. `:has-text("...")` —— Playwright 文本定位
6. CSS class —— 注意 class 易变，作为后备
7. XPath —— 最后手段，脆弱

如果用户提供的 UI 设计稿没有明确特征，应在「需补充信息」中要求开发同学补 `data-testid`，不要臆造选择器。

### UI 动作清单（标准动词）

| action | 必填字段 | 说明 |
|---|---|---|
| `navigate` | url | 打开 URL |
| `fill` | selector, value | 输入框填入文本 |
| `clear` | selector | 清空输入框 |
| `paste` | selector, value | 粘贴 |
| `click` | selector | 单击 |
| `double_click` | selector | 双击 |
| `right_click` | selector | 右键单击 |
| `hover` | selector | 悬停 |
| `focus` / `blur` | selector | 聚焦/失焦 |
| `check` / `uncheck` | selector | 勾选/取消勾选 |
| `select` | selector, value | 下拉选择 |
| `press_key` | key, selector(可选) | 按键 |
| `scroll` | selector 或 x/y | 滚动 |
| `drag_to` | source, target | 拖拽 |
| `upload` | selector, file_path | 上传 |
| `wait` | timeout_ms | 等待 |
| `wait_for_url` | url / url_contains | 等待 URL 变化 |
| `wait_for_selector` | selector, state | 等待元素 |
| `wait_for_response` | url_contains | 等待网络响应 |
| `go_back` / `go_forward` / `reload` | — | 导航 |
| `screenshot` | name | 截图 |
| `evaluate` | script | 注入 JS |

## 工具映射（执行端参考）

AI 在执行 `agent-exec` 块时，参考下表选择工具：

| type/tool | Claude Code 工具 | 备注 |
|---|---|---|
| api/curl | `Bash` | 执行 `curl -X METHOD ...` |
| api/bash | `Bash` | 执行任意 shell |
| api/http-mcp | 项目配置的 HTTP MCP | 如 fetch、http 等 |
| ui/playwright | `mcp__playwright__playwright_*` 一族 | navigate/click/fill/screenshot/evaluate/console_logs |
| ui/agent-browser | `agent-browser` skill | 桌面浏览器自动化 |

## 占位符与变量

`agent-exec` 块允许以下占位符，执行时由 AI 注入：

| 占位符 | 来源 |
|---|---|
| `{{ENV_*}}` | 环境变量 |
| `{{USER_INPUT_*}}` | 用户在执行时提供 |
| `{{CAPTURE_*}}` | 前序步骤 `capture_as` 字段捕获 |
| `{{DEPENDS_*}}` | `depends_on` 用例执行后的输出（如 token） |

例：

```yaml
- action: click
  selector: 'button[data-id="{{CAPTURE_issue_id}}"]'
```

## 完整执行流程（AI 端参考）

AI 读到 `agent-exec` 块后的标准执行流程：

1. 解析 YAML，校验 `type` 与 `tool`
2. 解析占位符，从环境变量/前序输出/用户输入注入实际值
3. 执行 `setup`（如有）
4. **接口用例**：组装 curl 命令 → Bash 执行 → 抓取响应（status / headers / body）
5. **UI 用例**：依序执行 `steps` → 抓取各动作结果与截图
6. 逐条评估 `assertions`，记录 pass/fail
7. 执行 `teardown`（如有）
8. 输出标准化执行结果（用例ID、状态、断言明细、证据）

## 反模式（生成时禁止）

- ❌ `body: <合法 JSON>` —— 必须给具体字段
- ❌ `assertions: 返回成功` —— 必须给 HTTP 码 + jsonpath
- ❌ `selector: 登录按钮` —— 必须给 CSS/Playwright 选择器
- ❌ `value: 任意密码` —— 必须给具体值
- ❌ 把多个接口/页面塞进同一个 agent-exec 块 —— 一条用例一个 agent-exec
- ❌ 用 `<placeholder>` 假占位 —— 信息缺失时在 SKILL.md 「需补充信息」列出，不硬产

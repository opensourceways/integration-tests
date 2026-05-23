# 用例类型分支规范（人机两用版）

## 自动分支规则

| 输入特征 | 用例类型 | 用例 ID 前缀 | agent-exec.type | 主要执行工具 |
|---|---|---|---|---|
| 含 HTTP 接口字段、Swagger、curl、API 字段表 | 接口用例 | `TC-API-` | `api` | curl / Bash / http-mcp |
| 含 UI 原型、设计稿、页面截图、控件交互描述 | UI 用例 | `TC-UI-` | `ui` | playwright / agent-browser |
| 同时含两者（如登录页 + 登录接口） | **分两组**输出，UI 组 + API 组 | 各自前缀 | 各自 type | 各自工具 |

## 接口用例（API 用例）

### 强制字段（人类表格）

| 字段 | 必填项 |
|---|---|
| 操作步骤 | 请求方式 + 完整 URL + Headers + Body + 媒体类型 |
| 预期结果 | HTTP 状态码 + 业务 code + 关键响应字段断言（含字段路径与具体值） |

### 强制字段（agent-exec 块）

```yaml
type: api
tool: curl
request:
  method: <必填>
  url: <必填，完整 URL>
  headers: <必填，至少 Content-Type；鉴权用占位符 {{TOKEN}}>
  body: <POST/PUT/PATCH 必填，给具体字段值>
assertions:
  - http_status: <必填>
  - jsonpath: <必填，至少 1 条业务断言>
    equals/not_empty/...: <必填具体值>
```

### 接口用例 9 维度执行落点

| 维度 | 在 agent-exec 中的体现 |
|---|---|
| 正常流 | 标准 body + http_status: 200 + jsonpath $.code equals 0 |
| 异常 | 错误 body + http_status: 4xx/5xx + 错误码 jsonpath 断言 |
| 边界值 | body 字段长度取 min/max ± 1 |
| 空值 | body 中字段缺失 / null / "" / [] / {} 分别建用例 |
| 特殊字符 | body 字段值含 emoji / SQL 注入串 / `<script>` |
| 权限 | headers Authorization 缺失/错误/过期/横向越权（换 user_id） |
| 唯一性 | 同 body 重复 POST，验证第二次返回业务码 |
| 重复 | 并发或快速连续 POST，验证幂等键效果 |
| 异常输入 | body 类型错（int 传 string、枚举外值、JSON 格式错） |

### 接口用例完整样例

````markdown
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
````

## UI 用例（前端交互用例）

### 强制字段（人类表格）

| 字段 | 必填项 |
|---|---|
| 操作步骤 | 标准操作动词 + 操作对象（含选择器线索）+ 操作位置 + 输入数据具体值 |
| 预期结果 | UI 视觉变化 + 接口断言 + 路由跳转 |

### 强制字段（agent-exec 块）

```yaml
type: ui
tool: playwright
steps:
  - action: <必填，标准动作>
    selector: <必填（导航除外），优先 aria_label/data-testid/id>
    value: <输入类动作必填，给具体值>
assertions:
  - type: <必填，url|text_visible|element_state|storage|network|count|attribute>
    具体断言字段: 具体值
```

### 操作动词清单（标准化，与 SKILL.md 一致）

**点击 / 双击 / 右击 / 长按 / 输入 / 清空 / 粘贴 / 选择 / 勾选 / 切换 / 拖动 / 滑动 / 滚动 / 悬停 / 聚焦 / 失焦 / 上传 / 下载 / 等待 / 刷新 / 返回 / 关闭 / 按键**

人类表格中用中文动词，`agent-exec.steps[].action` 用对应英文（click/fill/select/check/hover/upload/...）。

### 选择器优先级（agent-exec 中遵循）

1. `aria_label` 字段（最稳定，语义化）
2. `data-testid` / `data-test`
3. `id`
4. `name`
5. CSS `:has-text("...")`
6. CSS class（易变，谨慎用）
7. XPath（最后手段）

如设计稿无明确特征，**不要臆造选择器**——在「需补充信息」中要求补 `data-testid`。

### UI 用例 9 维度执行落点

| 维度 | 在 agent-exec 中的体现 |
|---|---|
| 正常流 | 标准 steps + url 跳转断言 + network 断言 200 |
| 异常 | 错误输入或非法点击顺序 + element_state(disabled) 或 text_visible 错误提示 |
| 边界值 | fill 长度取 min/max ± 1 + 校验提示文案 |
| 空值 | fill 跳过或填空字符串 + element_state(disabled) 提交按钮 |
| 特殊字符 | fill 含 emoji/`<script>` + assert 转义后展示文案 |
| 权限 | setup 不带 cookie / 用低权角色 cookie + url 重定向至 /login |
| 唯一性 | 重复创建同名 + text_visible 唯一性提示 |
| 重复 | 1 秒内 click × 3 + network 实际只触发 1 次 |
| 异常输入 | 粘贴非法格式 + element_state(invalid) |

### UI 用例完整样例

````markdown
| TC-UI-LOGIN-001 | 用户中心/登录页 | 账号密码登录 | [正常流] 合法账号密码可登录成功 | 1. 已注册账号 a@test.com<br>2. 密码 Test@1234<br>3. 浏览器已清除 Cookie | 1. 浏览器打开 https://app.example.com/login<br>2. 在【账号】输入框输入 a@test.com<br>3. 在【密码】输入框输入 Test@1234<br>4. 点击【登录】按钮 | 1. 【登录】按钮显示加载态<br>2. 触发 POST /api/v1/login，返回 200<br>3. 跳转至 /dashboard<br>4. 顶部显示「a@test.com」<br>5. localStorage 含 access_token | P0 |

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
    value: a@test.com
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
    contains: 'a@test.com'
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
````

## 混合用例处理规则

一个功能点同时涉及前端操作与接口调用时（如登录页点击按钮后调登录接口）：

1. **优先归为 UI 用例**，预期结果中显式断言所触发的接口（agent-exec 中用 `network` 断言）
2. **如需独立验证接口逻辑**（不经过界面），单独再写一条接口用例，前缀 `TC-API-`
3. **不要把同一断言写两遍**

## 反模式（生成时禁止）

接口用例：
- ❌ 操作步骤只写「调用 XX 接口」不给 URL/Method/Headers/Body
- ❌ 预期结果只写「返回成功」不给 HTTP 码 + 业务 code + jsonpath
- ❌ Body 用「合法 JSON」描述不给具体字段值
- ❌ agent-exec 中 body 缺字段或用 `<placeholder>` 假占位

UI 用例：
- ❌ 用「操作页面」「点一下」描述步骤
- ❌ 输入数据写「合法的xx」「合适的xx」
- ❌ 预期结果写「显示正常」「成功」「页面跳转」
- ❌ agent-exec 中 selector 写中文「登录按钮」、不给可定位特征
- ❌ UI 用例无 network 断言（涉及接口的场景必须断言）

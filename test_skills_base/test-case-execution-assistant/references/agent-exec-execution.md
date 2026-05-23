# agent-exec 执行规范

本文档说明如何把 test-case-generator / robot-test-case-generator 输出的 ` ```agent-exec ` YAML 代码块自动解析为工具调用，完成执行与断言。

## 顶层 schema 识别

```yaml
type: api | ui                  # 必填
tool: curl | bash | playwright  # 必填
inputs: { ... }                  # 可选，需要从用户/前序步骤注入的变量
steps: [ ... ]                   # 必填，按序执行
```

## 占位符注入

执行前从下表来源注入：

| 占位符 | 来源 |
|---|---|
| `{{TOKEN}}` / `{{ENV_*}}` | 环境变量 |
| `{{USER_INPUT_*}}` | 用户在执行时提供 |
| `{{CAPTURE_<key>}}` | 同一用例前序步骤 `capture_as` 字段输出 |
| `{{inputs.<key>}}` | 同一用例顶层 `inputs:` 字段 |

注入失败（用户未提供必要值）→ 用例状态【阻塞】，「缺陷说明」记录缺失变量名。

## type=api 执行流

### 1. 组装 curl 命令

```yaml
- id: post_assign
  request:
    method: POST
    url: https://api.gitcode.com/api/v5/repos/.../comments
    headers:
      Content-Type: application/json
      PRIVATE-TOKEN: '{{TOKEN}}'
    body:
      body: /assign
```

转为 Bash：

```bash
curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "PRIVATE-TOKEN: ${TOKEN}" \
  -d '{"body":"/assign"}' \
  "https://api.gitcode.com/api/v5/repos/.../comments" \
  -w "\nHTTP=%{http_code}\n" \
  -o /tmp/resp.json
```

注意：
- 用 `-s` 静默模式
- 用 `-w "\nHTTP=%{http_code}\n"` 抓取状态码
- 用 `-o <file>` 把响应 body 写到文件，避免 GBK 解码问题
- 中文响应用 Python `open(..., 'rb').read().decode('utf-8')` 读取

### 2. 抓取响应

| 抓取项 | 来源 |
|---|---|
| HTTP 状态码 | `curl -w` 输出 |
| 响应 body（JSON） | `-o /tmp/resp.json` 后用 Python 加载 |
| 响应 headers | `curl -i` 或 `-D /tmp/headers.txt` |

### 3. 评估 assertions

```yaml
assertions:
  - http_status: 200
  - jsonpath: $.code
    equals: 0
  - jsonpath: $.data.token
    not_empty: true
    min_length: 32
```

JSONPath 在 Python 中实现：

```python
import json
d = json.loads(open('/tmp/resp.json','rb').read().decode('utf-8'))
# $.code
assert d.get('code') == 0
# $.data.token
token = d.get('data', {}).get('token')
assert token and isinstance(token, str) and len(token) >= 32
```

**复杂 JSONPath（如 `$[?(@.user.login=='openeuler-ci-bot')]`）建议直接用 Python 列表推导**，避免依赖 jsonpath 第三方库的方言差异：

```python
bot_comments = [c for c in d if c.get('user', {}).get('login') == 'openeuler-ci-bot']
assert len(bot_comments) > 0
assert 'already assigned to' in bot_comments[-1].get('body', '')
```

### 4. 处理 capture_as

```yaml
capture_as:
  number: $.number
  comment_id: $.id
  created_at: $.created_at
```

执行后把对应路径的值存入会话上下文，后续步骤用 `{{CAPTURE_<key>}}` 引用：

```python
captures = {
    'number': d.get('number'),
    'comment_id': d.get('id'),
    'created_at': d.get('created_at'),
}
# 后续 URL 模板替换
url = url_template.replace('{{CAPTURE_number}}', str(captures['number']))
```

## type=ui 执行流

### 1. 工具映射

| tool | Claude Code 工具 |
|---|---|
| playwright | `mcp__playwright__playwright_*` |
| agent-browser | agent-browser skill 调用 |

### 2. 动作映射

| agent-exec action | Playwright MCP 工具 |
|---|---|
| navigate | playwright_navigate |
| fill | playwright_fill |
| click | playwright_click |
| select | playwright_select |
| hover | playwright_hover |
| press_key | playwright_press_key |
| upload | playwright_upload_file |
| screenshot | playwright_screenshot |
| evaluate | playwright_evaluate |
| wait | sleep（无对应 MCP 工具时用 Bash sleep） |
| wait_for_url / wait_for_selector | playwright_evaluate 自循环检查 |

### 3. 断言映射

| assertion.type | 实现 |
|---|---|
| url | playwright_evaluate `window.location.href` |
| text_visible | playwright_get_visible_text + 子串包含 |
| element_state | playwright_evaluate `document.querySelector(...).disabled` |
| storage | playwright_evaluate `localStorage.getItem(key)` |
| network | playwright_expect_response + assert_response |
| count | playwright_evaluate `document.querySelectorAll(...).length` |
| attribute | playwright_evaluate `document.querySelector(...).getAttribute(...)` |

## 多步执行的失败处理

`steps:` 数组中任一步失败：

| 失败类型 | 处理 |
|---|---|
| HTTP 5xx / 网络错误 / 工具不可用 | 状态【阻塞】，停止后续步骤 |
| HTTP 4xx 但用例预期就是 4xx | 不算失败，按 assertions 判定 |
| assertion 失败（值不匹配、jsonpath 找不到字段等） | 状态【不通过】，**继续执行后续步骤以收集证据**（除非后续依赖此步的 capture） |
| capture 失败（被引用的字段不存在） | 状态【阻塞】，停止后续步骤 |

## 异步等待（Robot 类用例必备）

```yaml
- action: wait
  timeout_ms: 12000
```

实现：Bash `sleep 12`。
**绝不**在等待步骤前评估后续断言；也**绝不**为了"加快执行"擅自缩短或删除 wait 步骤。

## 完整执行流程（伪代码）

```
for case in cases:
    if not preconditions_met(case):
        record(case, status='阻塞', defect=missing_preconditions)
        continue
    
    captures = {}
    for step in case.agent_exec.steps:
        # 占位符注入
        step = inject(step, env, user_inputs, captures)
        
        # 执行
        if step.action == 'wait':
            sleep(step.timeout_ms / 1000)
            continue
        
        try:
            response = execute(step)  # curl / playwright
        except ToolError as e:
            record(case, status='阻塞', defect=str(e))
            break
        
        # 抓取 captures
        if step.capture_as:
            for k, path in step.capture_as.items():
                captures[k] = jsonpath_get(response.body, path)
        
        # 评估 assertions
        for a in step.assertions:
            if not evaluate(a, response, captures):
                record_failed_assertion(case, step, a, response)
    
    # 收尾判定
    final_status = compute_status(case)
    record(case, status=final_status)
```

## 执行端的"诚实原则"

- 工具调用真实失败 → 写真实失败原因，不要为了让用例"看起来过了"而修改预期
- 工具调用成功但响应与预期不符 → 状态【不通过】，原文摘录响应关键片段
- 多次重试同一步骤 → 在「实际结果」中说明"经 N 次重试后"
- 用户提供的现象与工具实测冲突 → 同时记录两份，并在「缺陷说明」标注差异，让用户裁定

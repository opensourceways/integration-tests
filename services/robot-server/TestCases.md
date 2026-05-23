# robot-server 模块测试用例集（人机两用）

## 更新记录

| PR 号 | Issue 列表 | 合入时间 | 更新内容 |
|-------|-----------|----------|----------|
| [#115](https://github.com/agentic-develop-playground/backlog/pull/115) | 200 | 2026-05-23 | 新增 /healthz 健康检查端点测试用例（11 条） |

> 输入文档：issue_docs/200/Architecture Design/#200 Architecture Design Specification.md  
> 被测对象：robot-server 服务  
> 用例总数：11 条 ｜ P0：5 ｜ P1：4 ｜ P2：2  
> AI 执行工具：curl（Bash）

---

## 一、接口契约验证

### 1.1 GET /healthz 正常访问

| 用例ID | 对应 task(issueID) 链接 | 前置条件                                                    | 操作步骤                                        | 预期结果                                                                                                                             | 优先级 | 类型  |
| -------------- | ----------------------- | ----------------------------------------------------------- | ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------ | ----- |
| TC-HEALTHZ-001 | T-200-1                 | robot-server 服务已启动并监听指定端口（默认端口或配置端口） | 1. 发送 GET 请求到 http://<host>:<port>/healthz | 1. HTTP 状态码为 200<br>2. 响应头 Content-Type 为 application/json<br>3. 响应体 JSON 结构为 `{"status":"ok"}`<br>4. 响应时间 < 100ms | P0     | smoke |

```agent-exec
type: api
tool: curl
request:
  method: GET
  url: 'http://localhost:8080/healthz'
  headers: {}
  timeout_ms: 5000
assertions:
  - http_status: 200
  - header: Content-Type
    contains: 'application/json'
  - jsonpath: $.status
    equals: 'ok'
  - response_time_ms:
      lt: 100
```

| TC-HEALTHZ-002 | T-200-1 | robot-server 服务已启动 | 1. 发送 GET 请求到 http://<host>:<port>/healthz/（带尾部斜杠） | 1. HTTP 状态码为 200 或 404（根据路由设计）<br>2. 若 200，响应体为 `{"status":"ok"}` | P1 | interface contract |

```agent-exec
type: api
tool: curl
request:
  method: GET
  url: 'http://localhost:8080/healthz/'
  headers: {}
  timeout_ms: 5000
assertions:
  - http_status:
      in: [200, 404]
  - jsonpath: $.status
    equals: 'ok'
```

| TC-HEALTHZ-003 | T-200-1 | robot-server 服务已启动 | 1. 发送 POST 请求到 http://<host>:<port>/healthz | 1. HTTP 状态码为 405 Method Not Allowed 或 404 | P1 | interface contract |

```agent-exec
type: api
tool: curl
request:
  method: POST
  url: 'http://localhost:8080/healthz'
  headers:
    Content-Type: application/json
  body: {}
  timeout_ms: 5000
assertions:
  - http_status:
      in: [404, 405]
```

| TC-HEALTHZ-004 | T-200-1 | robot-server 服务已启动 | 1. 发送 GET 请求到 http://<host>:<port>/healthz，无请求体 | 1. HTTP 状态码为 200<br>2. 响应体为 `{"status":"ok"}` | P0 | smoke |

```agent-exec
type: api
tool: curl
request:
  method: GET
  url: 'http://localhost:8080/healthz'
  headers: {}
  timeout_ms: 5000
assertions:
  - http_status: 200
  - jsonpath: $.status
    equals: 'ok'
```

| TC-HEALTHZ-005 | T-200-3 | robot-server 服务已启动 | 1. 发送 GET 请求到 http://<host>:<port>/healthz<br>2. 检查响应头 Content-Type | 1. Content-Type 为 `application/json` 或 `application/json; charset=utf-8` | P0 | smoke |

```agent-exec
type: api
tool: curl
request:
  method: GET
  url: 'http://localhost:8080/healthz'
  headers: {}
  timeout_ms: 5000
assertions:
  - http_status: 200
  - header: Content-Type
    contains: 'application/json'
```

### 1.2 边界与异常输入验证

| TC-HEALTHZ-006 | T-200-1 | robot-server 服务已启动 | 1. 发送 GET 请求到 http://<host>:<port>/healthz，携带任意 Query 参数 | 1. HTTP 状态码为 200<br>2. 响应体为 `{"status":"ok"}`（忽略 Query 参数） | P2 | interface contract |

```agent-exec
type: api
tool: curl
request:
  method: GET
  url: 'http://localhost:8080/healthz?random_param=value'
  headers: {}
  timeout_ms: 5000
assertions:
  - http_status: 200
  - jsonpath: $.status
    equals: 'ok'
```

| TC-HEALTHZ-007 | T-200-1 | robot-server 服务已启动 | 1. 发送 GET 请求到 http://<host>:<port>/healthz，携带自定义请求头 | 1. HTTP 状态码为 200<br>2. 响应体为 `{"status":"ok"}` | P2 | interface contract |

```agent-exec
type: api
tool: curl
request:
  method: GET
  url: 'http://localhost:8080/healthz'
  headers:
    X-Custom-Header: 'test-value'
    Authorization: 'Bearer test-token'
  timeout_ms: 5000
assertions:
  - http_status: 200
  - jsonpath: $.status
    equals: 'ok'
```

---

## 二、K8s 健康检查集成验证

| TC-HEALTHZ-008 | T-200-2 | K8s deployment 配置文件已更新，包含 livenessProbe 和 readinessProbe 配置 | 1. 检查 deployment YAML 中 livenessProbe.httpGet.path<br>2. 检查 livenessProbe.httpGet.port<br>3. 检查 readinessProbe.httpGet.path<br>4. 检查 readinessProbe.httpGet.port | 1. livenessProbe.httpGet.path 为 `/healthz`<br>2. livenessProbe.httpGet.port 与容器端口一致<br>3. readinessProbe.httpGet.path 为 `/healthz`<br>4. readinessProbe.httpGet.port 与容器端口一致 | P0 | integration |

```agent-exec
type: api
tool: bash
request:
  method: GET
  url: 'N/A'
  headers: {}
  body: |
    # 检查 deployment YAML 配置
    # 假设 deployment 文件路径为 ./deployment.yaml
    # 使用 grep 或 yq 解析配置

    echo "请在 K8s 集群上执行以下验证命令："
    echo "1. kubectl get deployment <deployment-name> -o yamlpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.path}'"
    echo "2. kubectl get deployment <deployment-name> -o yamlpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}'"
    echo ""
    echo "预期输出："
    echo "- livenessProbe.httpGet.path = /healthz"
    echo "- readinessProbe.httpGet.path = /healthz"
assertions:
  - http_status: 200
side_effects:
  - description: 此用例需要人工在 K8s 集群上执行验证命令，或通过 CI/CD 流水线自动化检查
```

| TC-HEALTHZ-009 | T-200-2 | Pod 已在 K8s 集群中运行，deployment 已应用 liveness/readiness probe 配置 | 1. 部署 robot-server 到 K8s 集群<br>2. 等待 Pod 状态变为 Running<br>3. 执行 `kubectl describe pod <pod-name>` 查看 probe 事件<br>4. 查看 robot-server 日志，确认 /healthz 被定期访问 | 1. Pod 启动后状态保持 Running<br>2. `kubectl describe pod` 输出中无 probe 失败警告<br>3. 服务日志显示 /healthz 端点被定期调用（频率与 periodSeconds 配置一致） | P0 | integration |

```agent-exec
type: api
tool: bash
request:
  method: GET
  url: 'N/A'
  headers: {}
  body: |
    # K8s 环境验证脚本
    # 假设 POD_NAME 和 NAMESPACE 已配置

    echo "=== Step 1: 检查 Pod 状态 ==="
    kubectl get pods -n ${NAMESPACE:-default} -l app=robot-server

    echo ""
    echo "=== Step 2: 检查 Pod 事件（probe 相关） ==="
    kubectl describe pod ${POD_NAME} -n ${NAMESPACE:-default} | grep -A 5 -i "probe\|liveness\|readiness"

    echo ""
    echo "=== Step 3: 检查服务日志中的 /healthz 访问记录 ==="
    kubectl logs ${POD_NAME} -n ${NAMESPACE:-default} --tail=50 | grep -i "healthz\|GET /healthz"

    echo ""
    echo "预期结果："
    echo "- Pod 状态为 Running"
    echo "- 无 probe 失败警告"
    echo "- 日志显示 /healthz 被定期访问"
assertions:
  - http_status: 200
side_effects:
  - description: 此用例需要在 K8s 集群环境中执行，验证 Pod 健康检查功能
```

---

## 三、单元测试覆盖验证

| TC-HEALTHZ-010 | T-200-3 | 单元测试代码已编写（路径命中测试） | 1. 运行单元测试：`npm test` 或对应测试命令<br>2. 检查测试报告覆盖率 | 1. /healthz 路由处理函数被单元测试覆盖<br>2. 测试断言验证路径匹配正确<br>3. 测试通过，无失败用例 | P0 | unit |

```agent-exec
type: api
tool: bash
request:
  method: GET
  url: 'N/A'
  headers: {}
  body: |
    # 运行单元测试
    # 假设项目使用 npm

    npm test -- --coverage --testPathPattern="healthz"

    echo ""
    echo "预期结果："
    echo "- 测试通过，无失败用例"
    echo "- /healthz 路径测试覆盖"
assertions:
  - http_status: 200
side_effects:
  - description: 此用例验证单元测试执行结果，需要在项目根目录运行测试命令
```

| TC-HEALTHZ-011 | T-200-3 | 单元测试代码已编写（Content-Type 和 response body 测试） | 1. 运行单元测试<br>2. 检查 Content-Type 断言<br>3. 检查响应体断言 | 1. 单元测试断言响应头 Content-Type 为 `application/json`<br>2. 单元测试断言响应体为 `{"status":"ok"}`<br>3. 测试通过 | P1 | unit |

```agent-exec
type: api
tool: bash
request:
  method: GET
  url: 'N/A'
  headers: {}
  body: |
    # 运行单元测试并检查断言

    npm test -- --coverage --testPathPattern="healthz"

    echo ""
    echo "预期结果："
    echo "- Content-Type 断言：application/json"
    echo "- response body 断言：{\"status\":\"ok\"}"
    echo "- 测试通过"
assertions:
  - http_status: 200
side_effects:
  - description: 此用例验证单元测试中的 Content-Type 和 response body 断言
```

---

## 四、覆盖矩阵

| 功能点 \ 维度         | 1 正常流           | 2 异常     | 3 边界             | 4 空值 | 5 特殊字符 | 6 权限 | 7 唯一性 | 8 重复               | 9 异常输入 | 备注                                 |
| --------------------- | ------------------ | ---------- | ------------------ | ------ | ---------- | ------ | -------- | -------------------- | ---------- | ------------------------------------ |
| GET /healthz 正常访问 | ✓ (TC-001)         | ✓ (TC-003) | ✓ (TC-002, TC-006) | N/A    | N/A        | N/A    | N/A      | ✓ (重复调用无副作用) | N/A        | 静态端点，无权限、无状态、无输入字段 |
| K8s 健康检查集成      | ✓ (TC-009)         | N/A        | N/A                | N/A    | N/A        | N/A    | N/A      | N/A                  | N/A        | K8s probe 配置验证                   |
| 单元测试覆盖          | ✓ (TC-010, TC-011) | N/A        | N/A                | N/A    | N/A        | N/A    | N/A      | N/A                  | N/A        | 单元测试验证                         |

**覆盖说明：**

- **维度 4 空值**：/healthz 端点不接受请求体，无需验证空值
- **维度 5 特殊字符**：无输入字段，无需验证特殊字符
- **维度 6 权限**：健康检查端点公开访问，无权限控制
- **维度 7 唯一性**：无状态创建，无需验证唯一性
- **维度 9 异常输入**：端点为 GET /healthz，无输入参数，仅需验证非法 HTTP 方法（已覆盖）

---

## 五、需补充信息

1. **服务端口配置**：测试用例中假设服务监听 8080 端口，请确认实际配置端口并在执行时替换 `http://localhost:8080` 为实际地址。
2. **K8s 集群访问**：TC-HEALTHZ-008 和 TC-HEALTHZ-009 需要 K8s 集群访问权限，请在具备 kubectl 访问权限的环境中执行。
3. **单元测试命令**：TC-HEALTHZ-010 和 TC-HEALTHZ-011 假设使用 `npm test` 命令，请根据实际项目测试框架调整命令。
4. **Pod 名称和命名空间**：TC-HEALTHZ-009 需要指定 POD_NAME 和 NAMESPACE，请在执行前设置环境变量。

---

## 六、清理建议

测试完成后，建议执行以下清理操作：

1. 若在测试环境中创建了临时 Pod，请在测试完成后删除
2. 若修改了 deployment 配置用于测试，请恢复原始配置
3. 若在测试环境创建了测试用 Issue 或资源，请及时清理
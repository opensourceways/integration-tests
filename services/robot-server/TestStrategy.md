# robot-server 模块测试策略设计说明书

## 更新记录

| PR 号 | issue 列表 | 合入时间 | 变更摘要 |
| --- | --- | --- | --- |
| [#114](https://github.com/agentic-develop-playground/backlog/pull/114) | 200 | 2026-05-23 | 新增 /healthz 健康检查端点测试策略 |

---

## 1. 基本信息

- **模块名称**: robot-server
- **模块职责**: Robot 类机器人服务，处理代码托管平台 Webhook 事件，实现自动分配、标签管理、状态流转等自动化操作
- **核心目标**: 验证 robot-server 各功能组件正确性，确保 Webhook 事件处理、API 响应、K8s 健康检查等非功能特性闭环验收
- **开发责任人**: TBD
- **测试责任人**: TBD

---

## 2. 测试维度确认

> **操作指南**：请依据需求分析阶段的标签勾选。勾选后，必须在"第 3 节"提供对应的测试用例或方案。

- [x] **功能自检测试**

> - **测试重点：** API 契约验证、Webhook 事件处理逻辑验证、业务状态机闭环。
> - **目的：** 确保功能实现符合设计预期。
> - **触发条件：** 强制执行,**可委托开发测试完成，测试完成验收**。
> - **覆盖模块：** /healthz 端点、自动分配、评论命令、自动打标、状态流转等

- [ ] **体验测试**

> - **测试重点：** 站在用户角度进行体验使用，验证产品是否符合用户习惯。
> - **目的：** 满足用户需求，超出用户期望；判定产品是否能让用户快速的接受和使用。
> - **触发条件：** 需求标签含 `need_experience`
> - **未勾选理由：** robot-server 无 UI 界面，为纯后端服务

- [ ] **集成测试**

> - **测试重点：** 跨服务调用链路验证、上下游数据最终一致性、数据库/中间件版本兼容性。
> - **目的：** 消除组件间级联影响风险。
> - **触发条件：** 需求标签含 `need_itest`
> - **未勾选理由：** 当前需求（/healthz）为独立静态端点，无跨服务调用；其他 Robot 功能涉及平台 API 调用时需勾选

- [ ] **安全与隐私测试**

> - **测试重点：** 鉴权绕过测试、SQL/命令注入、敏感数据（PII）日志脱敏校验、SBOM 依赖漏洞扫描。
> - **目的：** 验证"纵深防御"机制是否生效，确保无隐私泄露。
> - **触发条件：** 需求标签含 `need_security`
> - **未勾选理由：** /healthz 健康检查端点为公开访问，无鉴权需求，无敏感数据传输，无数据库操作；其他 Robot 功能涉及权限控制时需勾选

- [ ] **可靠性与韧性测试**

> - **测试重点：** 故障注入（Chaos）。模拟网络丢包/延迟、进程意外溢出、磁盘 IO 满载后等异常情况下的系统自愈行为。
> - **目的：** 验证架构设计中的"面向失败设计"等能力。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含可靠性与韧性设计。
> - **未勾选理由：** 简单静态端点，无复杂状态管理，不涉及故障自愈机制

- [ ] **可服务性与可观测性测试**

> - **测试重点：** 告警有效性验证、指标准确性抽检、排障手册实操演练、优雅停机验证。
> - **目的：** 确保系统"可感知、可定位、可维护"。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含可服务性与可观测性设计。
> - **未勾选理由：** 本次变更不涉及新增监控、告警、日志等可观测性能力

- [ ] **性能与伸缩性测试**

> - **测试重点：** 基准测试、负载测试。验证延迟、吞吐量上限及资源配额（CPU/Mem）稳定性。
> - **目的：** 确保不产生性能退化，满足 SLO 要求。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含性能与伸缩性设计。
> - **未勾选理由：** 静态 JSON 响应，性能开销极低，无需专项性能测试

---

## 3. 专项验证设计和执行详情

> 测试自检
>
> - [ ] **Task 闭环**: 架构设计说明书中定义的 **TASK** 是否均有对应的测试结果？
> - [ ] **证据留存**: 关键测试（如性能、安全扫描）是否附带了截图或报告链接？

### 3.1 功能测试专项

> 参考测试设计方向
>
> - API 语义验证：验证 HTTP 状态码（2xx, 4xx, 5xx）的使用是否符合 RESTful 规范。
> - 边界与非法输入：验证大数据量、空字段、特殊字符及非法 JSON 格式的拦截能力。
> - 业务状态机闭环：验证资源从"创建中"到"运行中"再到"已释放"的全生命周期逻辑。

#### 3.1.1 /healthz 健康检查端点（issue #200）

**1.GET /healthz 正常访问返回 200 + JSON**

- **对应task(issueID)链接:** T-200-1（注册 /healthz 路由 + 返回静态 JSON）
- **前置条件:** robot-server 服务已启动并监听指定端口
- **操作步骤:**
  1. 向 /healthz 端点发送 GET 请求
- **预期结果:**
  - HTTP 状态码为 200
  - 响应头 Content-Type 为 application/json
  - 响应体为 `{"status":"ok"}`
  - 响应时间 < 100ms（健康检查端点应快速响应）

**2.GET /healthz 路径匹配验证**

- **对应task(issueID)链接:** T-200-1
- **前置条件:** robot-server 服务已启动
- **操作步骤:**
  1. 发送 GET /healthz（无尾部斜杠）
  2. 发送 GET /healthz/（有尾部斜杠）
- **预期结果:**
  - 两种路径均返回 200 + `{"status":"ok"}`（或明确 404，根据路由设计）

**3.GET /healthz 不接受 POST 方法**

- **对应task(issueID)链接:** T-200-1
- **前置条件:** robot-server 服务已启动
- **操作步骤:**
  1. 向 /healthz 端点发送 POST 请求
- **预期结果:**
  - HTTP 状态码为 405 Method Not Allowed（或 404，根据实现）

**4.GET /healthz 不带请求体正常响应**

- **对应task(issueID)链接:** T-200-1
- **前置条件:** robot-server 服务已启动
- **操作步骤:**
  1. 向 /healthz 端点发送 GET 请求，无请求体
- **预期结果:**
  - HTTP 状态码为 200
  - 响应体为 `{"status":"ok"}`

**5.响应 Content-Type 验证**

- **对应task(issueID)链接:** T-200-3（单元测试：path 命中 / Content-Type / response body）
- **前置条件:** robot-server 服务已启动
- **操作步骤:**
  1. 发送 GET /healthz
  2. 检查响应头 Content-Type
- **预期结果:**
  - Content-Type 为 `application/json` 或 `application/json; charset=utf-8`

#### 3.1.2 K8s 健康检查集成验证（issue #200）

**1.liveness probe 配置正确性验证**

- **对应task(issueID)链接:** T-200-2（配置 K8s deployment 的 liveness/readiness probe）
- **前置条件:** K8s deployment 配置文件已更新
- **操作步骤:**
  1. 检查 deployment YAML 中 livenessProbe 配置
  2. 确认 probe 指向 /healthz 路径
  3. 确认 probe 端口与容器端口一致
- **预期结果:**
  - livenessProbe.httpGet.path 为 `/healthz`
  - livenessProbe.httpGet.port 与容器端口一致
  - initialDelaySeconds、periodSeconds、timeoutSeconds 参数配置合理

**2.readiness probe 配置正确性验证**

- **对应task(issueID)链接:** T-200-2
- **前置条件:** K8s deployment 配置文件已更新
- **操作步骤:**
  1. 检查 deployment YAML 中 readinessProbe 配置
  2. 确认 probe 指向 /healthz 路径
- **预期结果:**
  - readinessProbe.httpGet.path 为 `/healthz`
  - readinessProbe.httpGet.port 与容器端口一致
  - 参数配置合理

**3.K8s 环境下健康检查实际触发验证**

- **对应task(issueID)链接:** T-200-2
- **前置条件:** Pod 已在 K8s 集群中运行，deployment 已应用 liveness/readiness probe 配置
- **操作步骤:**
  1. 部署 robot-server 到 K8s 集群
  2. 等待 Pod 状态变为 Running
  3. 执行 `kubectl describe pod <pod-name>` 查看 probe 事件
  4. 查看 robot-server 日志，确认 /healthz 被定期访问
- **预期结果:**
  - Pod 启动后状态保持 Running
  - `kubectl describe pod` 输出中无 probe 失败警告
  - 服务日志显示 /healthz 端点被定期调用（频率与 periodSeconds 配置一致）

**4.Pod 重启场景验证**

- **对应task(issueID)链接:** T-200-2
- **前置条件:** Pod 已在 K8s 集群中运行
- **操作步骤:**
  1. 手动删除 Pod
  2. 等待 K8s 自动重建 Pod
  3. 验证新 Pod 通过 liveness/readiness probe
- **预期结果:**
  - 新 Pod 自动创建并启动
  - 新 Pod 通过 healthz 检查，状态变为 Ready
  - 服务恢复对外访问

#### 3.1.3 单元测试覆盖验证（issue #200）

**1.单元测试路径命中验证**

- **对应task(issueID)链接:** T-200-3
- **前置条件:** 单元测试代码已编写
- **操作步骤:**
  1. 运行单元测试：`npm test` 或对应测试命令
  2. 检查测试报告覆盖率
- **预期结果:**
  - /healthz 路由处理函数被单元测试覆盖
  - 测试断言验证路径匹配正确
  - 测试通过，无失败用例

**2.单元测试 Content-Type 验证**

- **对应task(issueID)链接:** T-200-3
- **前置条件:** 单元测试代码已编写
- **操作步骤:**
  1. 运行单元测试
  2. 检查 Content-Type 断言
- **预期结果:**
  - 单元测试断言响应头 Content-Type 为 `application/json`
  - 测试通过

**3.单元测试 response body 验证**

- **对应task(issueID)链接:** T-200-3
- **前置条件:** 单元测试代码已编写
- **操作步骤:**
  1. 运行单元测试
  2. 检查响应体断言
- **预期结果:**
  - 单元测试断言响应体为 `{"status":"ok"}`
  - 测试通过

---

## 4. TASK 闭环检查表

| Task ID | 描述 | 测试覆盖 | 验证方式 |
| ------- | ----------------------------------------------- | -------- | ------------------------------------------------ |
| T-200-1 | 注册 /healthz 路由 + 返回静态 JSON | ✓ | 3.1.1 功能测试专项 - 接口契约验证（用例 1-5） |
| T-200-2 | 配置 K8s deployment 的 liveness/readiness probe | ✓ | 3.1.2 K8s 健康检查集成验证（用例 1-4） |
| T-200-3 | 单元测试：path 命中 / Content-Type / response body | ✓ | 3.1.3 单元测试覆盖验证（用例 1-3） |

---

## 5. Robot 类服务通用测试约定

### 5.1 测试前置条件

- 必须有执行仓库：Robot 类服务通过 Webhook 事件触发，需在真实可访问的代码托管仓库中测试
- 必须先探测平台：调用平台 API 确认仓库可达性、鉴权方式、members 列表、Bot 账号身份等真实环境特征
- 预期断言以实测为准：当设计文档与实测冲突时，以实测结果为准

### 5.2 测试用例设计要点

- 用例都是接口用例：Robot 无 UI，type 固定为 `api`，tool 固定为 `curl`
- 必含异步等待步骤：Robot 通过 Webhook 异步处理事件，POST 之后必须 sleep 后再 GET
- 断言 Bot 产物：通过 GET `/issues/{n}/comments` 过滤 Bot 账号后断言评论内容
- 文案断言使用实测语种与原文，不抄设计文档
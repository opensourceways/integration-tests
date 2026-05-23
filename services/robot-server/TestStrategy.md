# robot-server 模块测试策略

> 模块：services/robot-server
> 维护规范：每次需求合入追加更新记录，既有内容不删除

## 更新记录

| PR | Issues | 合入时间 | 备注 |
|----|--------|----------|------|
| [#127](https://github.com/agentic-develop-playground/backlog/pull/127) | 300 | 2026-05-23 | /needs-validation 评论指令自动转 VALIDATION 状态 |

---

## 1. 基本信息

### 1.1 需求 #300: robot-server 评论指令 /needs-validation 自动转 VALIDATION 状态

- **需求链接**: N/A (E2E smoke)
- **需求名称**: robot-server 新增 `/needs-validation` 评论指令，自动将 issue 状态切换到 VALIDATION
- **核心目标**:
  验证 `/needs-validation` 命令的功能正确性，以及架构设计中定义的可靠性与韧性、可服务性与可观测性等非功能专项任务的闭环验收。
- **开发责任人**: TBD
- **测试责任人**: TBD

---

## 2. 测试维度确认

> **操作指南**：请依据需求分析阶段的标签勾选。勾选后，必须在"第 3 节"提供对应的测试用例或方案。

### 2.1 需求 #300 测试维度

- [x] **功能自检测试**

> - **测试重点：** API 契约验证、业务逻辑分支覆盖、边界值测试。
> - **目的：** 确保功能实现符合设计预期。
> - **触发条件：** 强制执行，可委托开发测试完成，测试完成验收。
> - **勾选理由：** 架构设计包含 6 个 TASK，涉及命令路由、鉴权、状态切换、回执评论等核心功能，需覆盖 6 种状态标签（TODO/ACCEPTED/WIP/DONE/REJECTED/VALIDATION）及鉴权逻辑。

- [ ] **体验测试**

> - **测试重点：** 站在用户角度进行体验使用，验证产品是否符合用户习惯。
> - **目的：** 满足用户需求，超出用户期望；判定产品是否能让用户快速的接受和使用。
> - **触发条件：** 需求标签含 `need_experience`
> - **未勾选理由：** 需求无 `need_ux` 或 `need_experience` 标签，且命令行交互简单。

- [x] **集成测试**

> - **测试重点：** 跨服务调用链路验证、上下游数据最终一致性、数据库/中间件版本兼容性。
> - **目的：** 消除组件间级联影响风险。
> - **触发条件：** 需求标签含 `need_itest`
> - **勾选理由：** 架构设计 TASK4 明确要求"端到端冒烟：在测试仓真实评论 `/needs-validation`，验证状态切换 + 回执评论 + 下游 `resolved` 规则同步生效"，涉及跨服务调用链路验证。

- [ ] **安全与隐私测试**

> - **测试重点：** 鉴权绕过测试、SQL/命令注入、敏感数据（PII）日志脱敏校验、SBOM 依赖漏洞扫描。
> - **目的：** 验证"纵深防御"机制是否生效，确保无隐私泄露。
> - **触发条件：** 需求标签含 `need_security`
> - **未勾选理由：** 架构设计 3.1 节明确"不涉及（无 `need_security` 标签；只读 issue 公开元数据 + 写本仓标签与评论，无凭证 / 个人数据流转）。鉴权由现有 `AuthChecker` 保证。"

- [x] **可靠性与韧性测试**

> - **测试重点：** 故障注入（Chaos）。模拟网络丢包/延迟、进程意外溢出、磁盘 IO 满载后等异常情况下的系统自愈行为。
> - **目的：** 验证架构设计中的"面向失败设计"等能力。
> - **触发条件：** 涉及核心 Core 服务变更，且架构设计含可靠性与韧性设计。
> - **勾选理由：** 架构设计 3.2 节包含"失败重试"（GitHub API 5xx / 429 指数退避）与"幂等"（comment-id 去重缓存、状态切换幂等）设计。

- [x] **可服务性与可观测性测试**

> - **测试重点：** 告警有效性验证、指标准确性抽检、排障手册实操演练、优雅停机验证。
> - **目的：** 确保系统"可感知、可定位、可维护"。
> - **触发条件：** 涉及核心 Core 服务变更，且架构设计含可服务性与可观测性设计。
> - **勾选理由：** 架构设计 3.3 节定义了关键日志字段（event_id、repo、issue_number、commenter、from_status、to_status、action）和 metrics（robot_command_needs_validation_total、robot_command_needs_validation_errors_total）。

- [ ] **性能与伸缩性测试**

> - **测试重点：** 基准测试、负载测试。验证延迟、吞吐量上限及资源配额（CPU/Mem）稳定性。
> - **目的：** 确保不产生性能退化，满足 SLO 要求。
> - **触发条件：** 涉及核心 Core 服务变更，且架构设计含性能与伸缩性设计。
> - **未勾选理由：** 架构设计 3.4 节明确"不涉及性能专项。命令调用频率极低（每个 issue 生命周期约 1 次）。"

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

#### 3.1.1 需求 #300 功能测试

**1. 命令解析验证**

- **对应 TASK**: TASK2 #300-02
- **测试内容**: 验证 `comment.body` 首行 strip 后严格等于 `/needs-validation`（不区分大小写）时触发命令，否则跳过。
- **预期结果**: 
  - `/needs-validation` 触发命令处理
  - `/needs-validation `（尾部空格）触发命令处理
  - `/NEEDS-VALIDATION` 触发命令处理
  - `/needs-validation extra` 不触发命令处理
  - `This is /needs-validation` 不触发命令处理
  - 空评论不触发命令处理

**2. 鉴权验证**

- **对应 TASK**: TASK2 #300-02, TASK3 #300-03
- **测试内容**: 验证 `comment.user.login` ∈ `repo_maintainers ∪ {issue.user.login}` 时通过鉴权，否则回 confused reaction 并退出。
- **预期结果**:
  - Maintainer 评论 → 通过鉴权 → 执行状态切换
  - Issue 提代人评论 → 通过鉴权 → 执行状态切换
  - 非 Maintainer 且非提代人评论 → 拒绝 → 返回 confused reaction（GitHub API POST `/repos/{owner}/{repo}/issues/{issue_number}/comments` 返回 reaction）
  - 未登录用户（匿名）评论 → Webhook 不触发或拒绝

**3. 状态切换验证**

- **对应 TASK**: TASK2 #300-02
- **测试内容**: 验证从 6 种现有状态标签（TODO/ACCEPTED/WIP/DONE/REJECTED/无状态）切换到 VALIDATION 的行为。
- **预期结果**:
  - 当前状态 TODO → 移除 TODO 标签，添加 VALIDATION 标签
  - 当前状态 ACCEPTED → 移除 ACCEPTED 标签，添加 VALIDATION 标签
  - 当前状态 WIP → 移除 WIP 标签，添加 VALIDATION 标签
  - 当前状态 DONE → 移除 DONE 标签，添加 VALIDATION 标签
  - 当前状态 REJECTED → 移除 REJECTED 标签，添加 VALIDATION 标签
  - 当前无状态标签 → 仅添加 VALIDATION 标签
  - 当前已有 VALIDATION 标签 → 幂等，跳过添加（重复触发保护）

**4. 回执评论验证**

- **对应 TASK**: TASK2 #300-02, TASK5 #300-05
- **测试内容**: 验证 POST 评论内容为 `✅ #${issue_number} 已切到 VALIDATION，CI 与测试将在 10 分钟内开始`（英文版 `✅ #${issue_number} has been switched to VALIDATION. CI and tests will start within 10 minutes.`）。
- **预期结果**:
  - 评论成功创建，body 包含正确的 issue_number
  - 评论作者为 robot-server 账号
  - 文案语种符合 i18n 配置（英文优先，中文占位）

**5. 命令路由注册验证**

- **对应 TASK**: TASK1 #300-01
- **测试内容**: 验证 `CommandRouter` 正确注册 `/needs-validation` 路由并调用 `ValidationCommand.handle`。
- **预期结果**:
  - Webhook 收到 `issue_comment.created` 事件，comment.body 以 `/needs-validation` 开头时，请求被路由到 `ValidationCommand.handle`
  - 路由不匹配时不调用 `ValidationCommand.handle`

**6. 单元测试覆盖**

- **对应 TASK**: TASK2 #300-02, TASK3 #300-03
- **测试内容**: 验证单元测试覆盖 6 个状态 + 鉴权拒绝 + 重复触发幂等场景。
- **预期结果**:
  - 单元测试覆盖率 ≥ 80%（或项目既定门禁）
  - 6 种状态切换场景均有测试用例
  - 鉴权拒绝场景有测试用例
  - 重复触发幂等场景有测试用例

### 3.2 体验测试专项

> 需求 #300 未勾选，本节不涉及

### 3.3 集成测试专项

#### 3.3.1 需求 #300 集成测试

**1. 端到端冒烟测试**

- **对应 TASK**: TASK4 #300-04
- **测试内容**: 在测试仓真实评论 `/needs-validation`，验证状态切换 + 回执评论 + 下游 `resolved` 规则同步生效。
- **前置条件**:
  - 测试仓库可访问，robot-server 已部署并配置 Webhook
  - 测试账号有权限创建 Issue 和评论
  - 测试仓库有至少一个 Maintainer 账号
- **操作步骤**:
  1. 在测试仓库创建新 Issue（状态标签 TODO）
  2. 用 Maintainer 账号评论 `/needs-validation`
  3. 等待 10-30 秒
  4. 检查 Issue 标签是否从 TODO 切换到 VALIDATION
  5. 检查 Issue 是否有 robot-server 的回执评论
  6. 检查下游 `resolved` 规则是否触发（如有）
- **预期结果**:
  - 标签成功切换为 VALIDATION
  - 回执评论正确发布
  - 下游规则同步生效

**2. Webhook 事件处理验证**

- **对应 TASK**: TASK1 #300-01, TASK2 #300-02
- **测试内容**: 验证 robot-server 正确处理 GitHub `issue_comment.created` 事件。
- **预期结果**:
  - `issue_comment.created` 事件触发处理
  - `issue_comment.edited` 事件不触发处理（仅 created）
  - 其他事件类型不触发 `/needs-validation` 处理

**3. 跨服务调用链路验证**

- **对应 TASK**: TASK2 #300-02
- **测试内容**: 验证 robot-server 与 GitHub API 的交互链路。
- **预期结果**:
  - GET `/repos/{owner}/{repo}/issues/{issue_number}` 获取 Issue 标签成功
  - DELETE `/repos/{owner}/{repo}/issues/{issue_number}/labels/{name}` 移除旧标签成功
  - POST `/repos/{owner}/{repo}/issues/{issue_number}/labels` 添加 VALIDATION 标签成功
  - POST `/repos/{owner}/{repo}/issues/{issue_number}/comments` 发布回执评论成功

### 3.4 安全与隐私测试专项

> 需求 #300 未勾选，本节不涉及

### 3.5 可靠性与韧性专项

#### 3.5.1 需求 #300 可靠性与韧性测试

**1. GitHub API 失败重试验证**

- **对应 TASK**: TASK2 #300-02
- **测试内容**: 验证 GitHub API 返回 5xx 或 429 时走指数退避重试（基线 1s，最多 5 次）。
- **前置条件**:
  - 可模拟 GitHub API 5xx/429 响应（通过 Mock 或代理）
- **操作步骤**:
  1. 配置 Mock 返回 GitHub API 500 错误
  2. 触发 `/needs-validation` 命令
  3. 观察日志中的重试行为
  4. 配置 Mock 返回 GitHub API 429 错误
  5. 触发 `/needs-validation` 命令
  6. 观察日志中的重试行为
- **预期结果**:
  - 5xx 错误触发最多 5 次重试，每次间隔指数增长
  - 429 错误触发最多 5 次重试
  - 重试成功后继续正常流程
  - 重试耗尽后记录错误日志并退出

**2. GitHub API 4xx 错误处理验证**

- **对应 TASK**: TASK2 #300-02
- **测试内容**: 验证 GitHub API 返回 4xx 时进入死信日志，不重试。
- **前置条件**:
  - 可模拟 GitHub API 4xx 响应
- **操作步骤**:
  1. 配置 Mock 返回 GitHub API 404 错误
  2. 触发 `/needs-validation` 命令
  3. 观察日志中的错误处理
- **预期结果**:
  - 4xx 错误不触发重试
  - 错误记录到死信日志，包含 event_id、repo、issue_number、error 详情

**3. 幂等性验证**

- **对应 TASK**: TASK2 #300-02
- **测试内容**: 验证重复触发同评论的幂等性。
- **操作步骤**:
  1. 在测试仓库创建 Issue
  2. 评论 `/needs-validation`
  3. 手动重新发送相同的 Webhook 事件（模拟重复触发）
  4. 检查 Issue 标签和评论状态
- **预期结果**:
  - Comment ID 在 24h TTL 缓存中命中，跳过处理
  - Issue 状态标签仍为 VALIDATION（无副作用）
  - 无重复回执评论

**4. 状态切换幂等验证**

- **对应 TASK**: TASK2 #300-02
- **测试内容**: 验证 VALIDATION 标签已存在时跳过添加。
- **操作步骤**:
  1. 在测试仓库创建 Issue（已有 VALIDATION 标签）
  2. 评论 `/needs-validation`
  3. 检查标签操作
- **预期结果**:
  - 不调用添加标签 API（或调用但幂等）
  - 回执评论仍正常发布

### 3.6 可服务性与可观测性专项

#### 3.6.1 需求 #300 可服务性与可观测性测试

**1. 关键日志验证**

- **对应 TASK**: TASK6 #300-06
- **测试内容**: 验证日志包含关键字段：event_id、repo、issue_number、commenter、from_status、to_status=VALIDATION、action(success/denied/error)。
- **前置条件**:
  - robot-server 日志可访问（如 stdout、文件、ELK）
- **操作步骤**:
  1. 触发成功的 `/needs-validation` 命令
  2. 检查日志是否包含所有关键字段
  3. 触发鉴权拒绝的 `/needs-validation` 命令
  4. 检查日志是否包含 action=denied
  5. 触发错误的 `/needs-validation` 命令（模拟 API 错误）
  6. 检查日志是否包含 action=error 及错误详情
- **预期结果**:
  - 成功日志包含 event_id、repo、issue_number、commenter、from_status、to_status=VALIDATION、action=success
  - 拒绝日志包含 action=denied 及原因
  - 错误日志包含 action=error 及错误堆栈

**2. Metrics 验证**

- **对应 TASK**: TASK2 #300-02
- **测试内容**: 验证 metrics `robot_command_needs_validation_total{result}` 和 `robot_command_needs_validation_errors_total{kind}` 正确上报。
- **前置条件**:
  - robot-server metrics 端点可访问（如 `/metrics`）
  - Prometheus 或其他监控系统已配置抓取
- **操作步骤**:
  1. 触发成功的 `/needs-validation` 命令
  2. 检查 `robot_command_needs_validation_total{result="success"}` 是否增加
  3. 触发鉴权拒绝的 `/needs-validation` 命令
  4. 检查 `robot_command_needs_validation_total{result="denied"}` 是否增加
  5. 触发错误的 `/needs-validation` 命令
  6. 检查 `robot_command_needs_validation_errors_total{kind="..."}` 是否增加
- **预期结果**:
  - 成功场景：counter 增加，result=success
  - 拒绝场景：counter 增加，result=denied
  - 错误场景：error counter 增加，kind 为错误类型

**3. 排障文档验证**

- **对应 TASK**: TASK6 #300-06
- **测试内容**: 验证 `robot-server/docs/runbook.md` 包含 `/needs-validation` 的失败码与排障步骤。
- **前置条件**:
  - 文档已更新
- **操作步骤**:
  1. 检查文档是否包含命令名称 `/needs-validation`
  2. 检查是否包含常见失败码（如 401 Unauthorized、403 Forbidden、404 Not Found、500 Internal Server Error）
  3. 检查每个失败码是否有对应的排障步骤
- **预期结果**:
  - 文档包含 `/needs-validation` 命令的失败码清单
  - 每个失败码有明确的排障步骤（如检查 Token 权限、检查网络连通性、检查 GitHub 状态页面）

### 3.7 性能与可伸缩性专项

> 需求 #300 未勾选，本节不涉及

---

## 4. 测试用例索引

> 详细测试用例见 `test_cases.py`（Python pytest 脚本）

### 4.1 需求 #300 用例索引

| 用例 ID | 测试标题 | 关联 TASK | 优先级 | 测试类型 |
|---------|----------|-----------|--------|----------|
| TC-ROBOT-VAL-001 | 命令解析-合法命令触发处理 | TASK2 | P0 | unit |
| TC-ROBOT-VAL-002 | 命令解析-非法命令不触发 | TASK2 | P1 | unit |
| TC-ROBOT-VAL-003 | 鉴权-Maintainer通过 | TASK2, TASK3 | P0 | unit |
| TC-ROBOT-VAL-004 | 鉴权-Issue提代人通过 | TASK2, TASK3 | P0 | unit |
| TC-ROBOT-VAL-005 | 鉴权-非授权用户拒绝 | TASK2, TASK3 | P0 | unit |
| TC-ROBOT-VAL-006 | 状态切换-TODO到VALIDATION | TASK2 | P0 | integration |
| TC-ROBOT-VAL-007 | 状态切换-ACCEPTED到VALIDATION | TASK2 | P1 | integration |
| TC-ROBOT-VAL-008 | 状态切换-WIP到VALIDATION | TASK2 | P1 | integration |
| TC-ROBOT-VAL-009 | 状态切换-DONE到VALIDATION | TASK2 | P1 | integration |
| TC-ROBOT-VAL-010 | 状态切换-REJECTED到VALIDATION | TASK2 | P1 | integration |
| TC-ROBOT-VAL-011 | 状态切换-无状态到VALIDATION | TASK2 | P1 | integration |
| TC-ROBOT-VAL-012 | 状态切换-幂等性验证 | TASK2 | P1 | integration |
| TC-ROBOT-VAL-013 | 回执评论-成功发布 | TASK2, TASK5 | P0 | integration |
| TC-ROBOT-VAL-014 | 路由注册-正确分发 | TASK1 | P1 | unit |
| TC-ROBOT-VAL-015 | API重试-5xx指数退避 | TASK2 | P1 | reliability |
| TC-ROBOT-VAL-016 | API重试-4xx不重试 | TASK2 | P1 | reliability |
| TC-ROBOT-VAL-017 | 幂等性-CommentID缓存 | TASK2 | P1 | reliability |
| TC-ROBOT-VAL-018 | 日志-关键字段验证 | TASK6 | P1 | observability |
| TC-ROBOT-VAL-019 | Metrics-counter验证 | TASK2 | P1 | observability |
| TC-ROBOT-VAL-020 | E2E冒烟-完整流程 | TASK4 | P0 | e2e |
| TC-ROBOT-VAL-BOUNDARY-001 | 边界值-评论体变体测试 | TASK2 | P2 | unit |
| TC-ROBOT-VAL-BOUNDARY-002 | 边界值-多状态标签场景 | TASK2 | P2 | integration |
| TC-ROBOT-VAL-SPECIAL-001 | 特殊字符-Issue标题包含特殊字符 | TASK2 | P2 | unit |

---

## 5. 风险与依赖

### 5.1 需求 #300 风险与依赖

| 风险项 | 影响 | 缓解措施 |
|--------|------|----------|
| GitHub API 限流 | 状态切换失败 | 实现 429 重试机制，监控 rate limit 剩余量 |
| Webhook 延迟 | 用户等待时间变长 | 在回执评论中明确说明"10 分钟内"，设置合理预期 |
| Robot 账号权限不足 | 无法操作标签/评论 | 部署前验证 Robot 账号对目标仓库的 write 权限 |
| 状态标签命名不一致 | 状态切换失败 | 统一使用 GitHub Label API，避免硬编码标签名 |
| 测试仓库不可达 | E2E 测试无法执行 | 使用专用测试仓库，确保 CI 环境网络连通 |
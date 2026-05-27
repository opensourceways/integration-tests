# robot-server 测试策略设计说明书

## 更新记录

| PR 号 | issue 列表 | 合入时间 | 备注 |
|-------|-----------|---------|------|
| [#342](https://github.com/agentic-develop-playground/backlog/pull/342) | #889 | 2026-05-27 | docs(test): test design from #341 - robot-server 在新 issue 创建时自动检测疑似重复并关联 |

---

## 1. 基本信息

- **模块名称**: robot-server
- **核心目标**:
  验证 robot-server 的重复 issue 自动检测与关联功能正确性，以及架构设计中定义的可靠性与韧性、可服务性与可观测性等非功能专项任务的闭环验收。
- **当前测试责任人**: TBD

---

## 2. 测试维度确认

> **操作指南**：依据需求分析阶段的标签勾选。勾选后，必须在"第 3 节"提供对应的测试用例或方案。

**来自 issue #889**：

- [x] **功能自检测试**

> - **测试重点：** API 契约验证、业务逻辑分支覆盖、边界值测试。
> - **目的：** 确保功能实现符合设计预期。
> - **触发条件：** 强制执行,**可委托开发测试完成，测试完成验收**。
> - **勾选理由：** 核心功能需验证 webhook 接收、相似度算法、评论发送的完整链路。

- [ ] **体验测试**

> - **测试重点：** 站在用户角度进行体验使用，验证产品是否符合用户习惯。
> - **目的：** 满足用户需求，超出用户期望；判定产品是否能让用户快速的接受和使用。
> - **触发条件：** 需求标签含 `need_experience`
> - **未勾选理由：** 无 `need_ux` 或 `need_experience` 标签。

- [x] **集成测试**

> - **测试重点：** 跨服务调用链路验证、上下游数据最终一致性、数据库/中间件版本兼容性。
> - **目的：** 消除组件间级联影响风险。
> - **触发条件：** 需求标签含 `need_itest`
> - **勾选理由：** 涉及 GitHub API 外部依赖，需验证 webhook 接收 → GitHub issue API 调用链路。

- [ ] **安全与隐私测试**

> - **测试重点：** 鉴权绕过测试、SQL/命令注入、敏感数据（PII）日志脱敏校验、SBOM 依赖漏洞扫描。
> - **目的：** 验证"纵深防御"机制是否生效，确保无隐私泄露。
> - **触发条件：** 需求标签含 `need_security`
> - **未勾选理由：** 架构文档明确"不涉及（无 need_security 标签；只读 issue 公开元数据 + 写本仓评论，无凭证/个人数据流转）"。

- [x] **可靠性与韧性测试**

> - **测试重点：** 故障注入（Chaos）。模拟网络丢包/延迟、进程意外溢出、磁盘 IO 满载后等异常情况下的系统自愈行为。
> - **目的：** 验证架构设计中的"面向失败设计"等能力。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含可靠性与韧性设计。
> - **勾选理由：** 架构设计包含失败重试（指数退避）、幂等性设计、降级策略（TASK7）。

- [x] **可服务性与可观测性测试**

> - **测试重点：** 告警有效性验证、指标准确性抽检、排障手册实操演练、优雅停机验证。
> - **目的：** 确保系统"可感知、可定位、可维护"。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含可服务性与可观测性设计。
> - **勾选理由：** 架构设计定义了 3 个核心指标（robot_dup_detect_total、robot_dup_hint_posted_total、robot_dup_detect_latency_seconds），并有 TASK8 Grafana 面板任务。

- [ ] **性能与伸缩性测试**

> - **测试重点：** 基准测试、负载测试。验证延迟、吞吐量上限及资源配额（CPU/Mem）稳定性。
> - **目的：** 确保不产生性能退化，满足 SLO 要求。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含性能与伸缩性设计。
> - **未勾选理由：** 架构文档明确"不涉及性能专项。单 issue 比对候选上限 < 500，TF-IDF 在内存内计算，单次 < 2s"。

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

#### 3.1.1 IssueOpenedHook 组织白名单过滤

**对应 TASK**: [TASK1 #889-01](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-FUNC-001 | IssueOpenedHook | 组织白名单 | [正常流] 白名单组织 issue.opened 触发检测 | 1. robot-server 部署完成<br>2. 组织白名单配置含 `ascend`、`cann` | 1. 向白名单组织仓库发送 `issues.opened` webhook 事件 | 1. 日志显示事件被接收<br>2. 进入 DuplicateDetector 处理流程 | P0 |
| TC-FUNC-002 | IssueOpenedHook | 组织白名单 | [异常] 非白名单组织事件被丢弃 | 1. robot-server 部署完成<br>2. 组织白名单配置不含 `other-org` | 1. 向非白名单组织仓库发送 `issues.opened` webhook 事件 | 1. 日志显示事件被丢弃<br>2. 不调用 DuplicateDetector<br>3. 不发送评论 | P0 |
| TC-FUNC-003 | IssueOpenedHook | 组织白名单 | [边界值] 白名单大小写敏感测试 | 1. 组织白名单配置含 `Ascend`（大写） | 1. 发送 `ascend`（小写）组织的 webhook | 1. 根据配置决定是否匹配（需确认配置大小写策略） | P2 |

#### 3.1.2 DuplicateDetector 相似度算法

**对应 TASK**: [TASK2 #889-02](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-FUNC-004 | DuplicateDetector | 相似度算法 | [正常流] 完全相同标题和正文返回 score=1.0 | 1. 测试仓存在 issue #1 标题"Bug: login fail"正文"步骤：..." | 1. 新建 issue #2 标题"Bug: login fail"正文"步骤：..."（完全相同） | 1. score = 1.0<br>2. 列入候选列表 | P0 |
| TC-FUNC-005 | DuplicateDetector | 相似度算法 | [正常流] 部分相似标题命中阈值 | 1. 测试仓存在 issue #1 标题"Bug: login fail on Chrome"<br>2. 阈值 THRESHOLD=0.75 | 1. 新建 issue #2 标题"Bug: login fail on Firefox"（正文不同） | 1. 0.75 ≤ score < 1.0<br>2. 列入候选列表 | P0 |
| TC-FUNC-006 | DuplicateDetector | 相似度算法 | [正常流] 完全不同标题不命中 | 1. 测试仓存在 issue #1 标题"Feature: add dark mode" | 1. 新建 issue #2 标题"Bug: API timeout"（正文不同） | 1. score < THRESHOLD<br>2. 不列入候选列表 | P0 |
| TC-FUNC-007 | DuplicateDetector | 相似度算法 | [空值] 空正文处理 | 1. 测试仓存在 issue #1 标题"Test"正文为空 | 1. 新建 issue #2 标题"Test"正文为空 | 1. 算法正常处理，不抛异常<br>2. 根据标题计算相似度 | P1 |
| TC-FUNC-008 | DuplicateDetector | 相似度算法 | [边界值] 阈值边界 score=THRESHOLD | 1. THRESHOLD=0.75<br>2. 构造 score 刚好=0.75 的标题组合 | 1. 新建 issue 触发检测 | 1. 刚好达到阈值，列入候选 | P1 |
| TC-FUNC-009 | DuplicateDetector | 相似度算法 | [边界值] 阈值边界 score=THRESHOLD-0.01 | 1. THRESHOLD=0.75<br>2. 构造 score=0.74 的标题组合 | 1. 新建 issue 触发检测 | 1. 未达到阈值，不列入候选 | P1 |
| TC-FUNC-010 | DuplicateDetector | 相似度算法 | [特殊字符] 标题含 emoji/中文/SQL关键字 | 1. 测试仓存在 issue #1 标题"🐛 Bug: 登录失败" | 1. 新建 issue #2 标题"🐛 Bug: 登录失败"（相同） | 1. TF-IDF 正确处理 Unicode<br>2. score = 1.0 | P2 |

#### 3.1.3 SimilarityCommenter 评论发送

**对应 TASK**: [TASK3 #889-03](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-FUNC-011 | SimilarityCommenter | 评论发送 | [正常流] top-3 候选发送评论 | 1. 检测到 5 个相似候选，score 分别 0.95, 0.88, 0.82, 0.80, 0.78 | 1. 触发评论发送 | 1. 评论中列出前 3 个候选<br>2. 按相似度降序排列<br>3. 每项包含 issue 链接和相似度百分比 | P0 |
| TC-FUNC-012 | SimilarityCommenter | 评论发送 | [正常流] 无候选不发送评论 | 1. 检测到 0 个相似候选 | 1. 触发评论发送逻辑 | 1. 不调用 GitHub API 发送评论<br>2. 日志记录 no-op | P0 |
| TC-FUNC-013 | SimilarityCommenter | 评论发送 | [边界值] 刚好 1 个候选 | 1. 检测到 1 个相似候选 | 1. 触发评论发送 | 1. 评论中列出 1 个候选 | P1 |
| TC-FUNC-014 | SimilarityCommenter | 评论发送 | [边界值] 刚好 3 个候选 | 1. 检测到 3 个相似候选 | 1. 触发评论发送 | 1. 评论中列出 3 个候选 | P1 |
| TC-FUNC-015 | SimilarityCommenter | 评论发送 | [重复] 同一 issue 重复 opened 事件幂等 | 1. issue #1 已触发过评论 | 1. 模拟同一 issue 再次发送 opened 事件（如 webhook 重试） | 1. 不重复发送评论（幂等）<br>2. 日志标记去重 | P1 |

#### 3.1.4 配置参数化

**对应 TASK**: [TASK4 #889-04](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-FUNC-016 | Config | 配置热更新 | [正常流] THRESHOLD 配置生效 | 1. 当前 THRESHOLD=0.75 | 1. 修改 ConfigMap THRESHOLD=0.80<br>2. 等待配置生效<br>3. 新建 issue 触发检测 | 1. score=0.78 的候选不再命中 | P1 |
| TC-FUNC-017 | Config | 配置热更新 | [正常流] lookback_days 配置生效 | 1. 当前 lookback_days=90 | 1. 修改 ConfigMap lookback_days=30<br>2. 等待配置生效<br>3. 新建 issue 触发检测 | 1. 只查询 30 天内的 issue | P1 |
| TC-FUNC-018 | Config | 配置热更新 | [正常流] 组织白名单配置生效 | 1. 当前白名单=[ascend, cann] | 1. 修改 ConfigMap 添加 `new-org`<br>2. 等待配置生效<br>3. `new-org` 发送 webhook | 1. `new-org` 事件被处理 | P1 |

#### 3.1.5 端到端冒烟测试

**对应 TASK**: [TASK5 #889-05](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-FUNC-019 | E2E | 端到端 | [正常流] 高度相似 issue 收到疑似重复评论 | 1. 测试仓已有 issue #1 标题"Bug: API 500 error on /users" | 1. 新建 issue #2 标题"Bug: API 500 error on /users"（相同或高度相似） | 1. issue #2 收到疑似重复评论<br>2. 评论列出 issue #1 及相似度 | P0 |
| TC-FUNC-020 | E2E | 端到端 | [正常流] 完全不同 issue 不收到评论 | 1. 测试仓已有 issue #1 标题"Feature: add export" | 1. 新建 issue #2 标题"Bug: login timeout"（完全不同） | 1. issue #2 不收到疑似重复评论 | P0 |

### 3.2 集成测试专项

#### 3.2.1 GitHub API 集成

**对应 TASK**: [TASK1 #889-01](https://github.com/agentic-develop-playground/backlog/issues/889), [TASK3 #889-03](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-INT-001 | GitHub API | 接口契约 | [正常流] 获取 issue 列表返回 200 | 1. robot-server 有有效 GitHub Token | 1. 调用 `GET /repos/{org}/{repo}/issues?state=open&since=...` | 1. HTTP 200<br>2. 返回 issue 数组 | P0 |
| TC-INT-002 | GitHub API | 接口契约 | [正常流] 发送评论返回 201 | 1. robot-server 有有效 GitHub Token | 1. 调用 `POST /repos/{org}/{repo}/issues/{number}/comments` | 1. HTTP 201<br>2. 返回 comment 对象 | P0 |
| TC-INT-003 | GitHub API | 异常场景 | [异常] GitHub API 返回 401 Unauthorized | 1. GitHub Token 无效或过期 | 1. 触发检测流程 | 1. 日志记录 401 错误<br>2. 不重试（4xx 不重试）<br>3. 进入死信日志 | P1 |
| TC-INT-004 | GitHub API | 异常场景 | [异常] GitHub API 返回 403 Rate Limit | 1. GitHub API 触发速率限制 | 1. 触发检测流程 | 1. 日志记录 403 错误<br>2. 进入指数退避重试 | P1 |
| TC-INT-005 | GitHub API | 异常场景 | [异常] GitHub API 返回 500 | 1. GitHub 服务端故障 | 1. 触发检测流程 | 1. 日志记录 500 错误<br>2. 指数退避重试（最多 5 次） | P1 |

### 3.3 可靠性与韧性专项

#### 3.3.1 失败重试机制

**对应 TASK**: [TASK7 #889-07](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-REL-001 | Reliability | 重试机制 | [正常流] GitHub 5xx 触发指数退避重试 | 1. Mock GitHub API 第一次返回 500，第二次返回 200 | 1. 触发检测流程 | 1. 第一次请求失败后等待 1s 重试<br>2. 第二次请求成功<br>3. 日志记录重试次数 | P0 |
| TC-REL-002 | Reliability | 重试机制 | [异常] 重试 5 次后放弃 | 1. Mock GitHub API 持续返回 500 | 1. 触发检测流程 | 1. 重试 5 次后放弃<br>2. 日志记录最终失败<br>3. 不影响其他 issue 处理 | P1 |
| TC-REL-003 | Reliability | 重试机制 | [异常] GitHub 4xx 不重试直接放弃 | 1. Mock GitHub API 返回 400/401/403/404 | 1. 触发检测流程 | 1. 不触发重试<br>2. 进入死信日志 | P1 |

#### 3.3.2 幂等性验证

**对应 TASK**: [TASK3 #889-03](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-REL-004 | Reliability | 幂等性 | [重复] 同一 issue 多次 opened 事件只发一条评论 | 1. issue #1 未处理过 | 1. 连续发送 3 次 `issues.opened` webhook（同一 issue） | 1. 只发送 1 条评论<br>2. comment-id 缓存去重生效 | P0 |

#### 3.3.3 降级策略

**对应 TASK**: [TASK7 #889-07](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-REL-005 | Reliability | 降级策略 | [异常] 分页失败降级为仅比对首页 | 1. Mock GitHub API issue 列表第一页成功，第二页 500 | 1. 触发检测流程（候选 issue > 100） | 1. 仅使用第一页数据比对<br>2. 日志标记降级<br>3. 仍然发出评论（如果首页有命中） | P1 |

### 3.4 可服务性与可观测性专项

#### 3.4.1 指标采集验证

**对应 TASK**: [TASK8 #889-08](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-OBS-001 | Observability | 指标 | [正常流] robot_dup_detect_total 指标递增 | 1. Prometheus 已采集 robot-server 指标 | 1. 触发 5 次 issue 创建检测 | 1. `robot_dup_detect_total` 增加 5 | P1 |
| TC-OBS-002 | Observability | 指标 | [正常流] robot_dup_hint_posted_total 按 org 分组 | 1. 有 2 个组织 `ascend`、`cann` 触发检测 | 1. `ascend` 触发 3 次命中评论<br>2. `cann` 触发 2 次命中评论 | 1. `robot_dup_hint_posted_total{org="ascend"}` = 3<br>2. `robot_dup_hint_posted_total{org="cann"}` = 2 | P1 |
| TC-OBS-003 | Observability | 指标 | [正常流] robot_dup_detect_latency_seconds P99 < 2s | 1. 触发 100 次检测 | 1. 查询 Prometheus P99 延迟 | 1. P99 < 2s | P1 |

#### 3.4.2 排障文档验证

**对应 TASK**: [TASK6 #889-06](https://github.com/agentic-develop-playground/backlog/issues/889)

**测试点（来自 issue #889）**：

| 用例ID | 模块 | 功能点 | 用例标题 | 置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|------|--------|----------|----------|----------|----------|--------|
| TC-OBS-004 | Observability | 排障文档 | [正常流] 误报排查步骤可执行 | 1. 排障文档已写入 runbook | 1. 按 runbook 步骤排查"误报"场景 | 1. 步骤清晰可执行<br>2. 能定位到相似度算法参数 | P2 |
| TC-OBS-005 | Observability | 排障文档 | [正常流] 漏报排查步骤可执行 | 1. 排障文档已写入 runbook | 1. 按 runbook 步骤排查"漏报"场景 | 1. 步骤清晰可执行<br>2. 能定位到 THRESHOLD 配置或算法问题 | P2 |

---

## 4. 用例覆盖矩阵（来自 issue #889）

| 功能点 \ 维度 | 1 正常流 | 2 异常 | 3 边界 | 4 空值 | 5 特殊字符 | 6 权限 | 7 唯一性 | 8 重复 | 9 异常输入 | 备注 |
|---|---|---|---|---|---|---|---|---|---|---|
| 组织白名单过滤 | ✓ (TC-FUNC-001) | ✓ (TC-FUNC-002) | ✓ (TC-FUNC-003) | N/A | N/A | N/A | N/A | N/A | N/A | 权限由 GitHub Token 控制，不在此功能点 |
| TF-IDF 相似度算法 | ✓ (TC-FUNC-004,005,006) | N/A | ✓ (TC-FUNC-008,009) | ✓ (TC-FUNC-007) | ✓ (TC-FUNC-010) | N/A | N/A | N/A | N/A | 算法层面无异常输入场景 |
| 评论发送 | ✓ (TC-FUNC-011,012) | N/A | ✓ (TC-FUNC-013,014) | N/A | N/A | N/A | N/A | ✓ (TC-FUNC-015) | N/A | 幂等性已覆盖重复 |
| 配置热更新 | ✓ (TC-FUNC-016,017,018) | N/A | N/A | N/A | N/A | N/A | N/A | N/A | N/A | 配置无边界/空值场景 |
| GitHub API 成 | ✓ (TC-INT-001,002) | ✓ (TC-INT-003,004,005) | N/A | N/A | N/A | N/A | N/A | N/A | N/A | 外部 API 边界由 GitHub 控制 |
| 失败重试 | ✓ (TC-REL-001) | ✓ (TC-REL-002,003) | N/A | N/A | N/A | N/A | N/A | N/A | N/A | 重试机制无边界场景 |
| 幂等性 | ✓ (TC-REL-004) | N/A | N/A | N/A | N/A | N/A | N/A | ✓ (TC-REL-004) | N/A | 正常流与重复场景相同 |
| 降级策略 | N/A | ✓ (TC-REL-005) | N/A | N/A | N/A | N/A | N/A | N/A | N/A | 降级是异常场景 |
| 指标采集 | ✓ (TC-OBS-001,002,003) | N/A | N/A | N/A | N/A | N/A | N/A | N/A | N/A | 指标无异常/边界场景 |
| 排障文档 | ✓ (TC-OBS-004,005) | N/A | N/A | N/A | N/A | N/A | N/A | N/A | N/A | 文档验证无边界场景 |

---

## 5. 需补充信息

（如有）
# robot-server 测试策略设计说明书

> 本文档为 robot-server 模块的全量测试策略，融合各需求 Issue 的测试要点。
> 生成工具：测试集成 Agent（自动化融合 workflow）

## 更新记录

| PR 号 | Issue 列表 | 合入时间 | 更新内容 |
| --- | --- | --- | --- |
| [#167](https://github.com/agentic-develop-playground/backlog/pull/167) | 300, 888 | 2026-05-23 | 融合 #300 /needs-validation 评论指令测试策略 + #888 长期无活动 PR 自动评论提醒测试策略 |

---

## 1. 基本信息

- **模块名称**: robot-server
- **核心目标**: 验证 Robot 类服务（Issue/PR 自动处理、评论指令响应、定时巡检）的功能正确性、可靠性与韧性、可服务性与可观测性。
- **开发责任人**: TBD
- **测试责任人**: TBD

---

## 2. 测试维度确认

> **操作指南**：请依据需求分析阶段的标签勾选。勾选后，必须在"第 3 节"提供对应的测试用例或方案。

- [x] **功能自检测试**

> - **测试重点：** API 契约验证、业务逻辑分支覆盖、边界值测试、命令解析、鉴权、状态切换、定时巡检。
> - **目的：** 确保功能实现符合设计预期。
> - **触发条件：** 强制执行，可委托开发测试完成，测试完成验收。
> - **勾选理由：** robot-server 包含评论指令处理（/needs-validation 等）、定时巡检（StaleScanner）、自动评论（ReminderPoster）、标签操作（StaleLabeler）等核心功能。

- [ ] **体验测试**

> - **测试重点：** 站在用户角度进行体验使用，验证产品是否符合用户习惯。
> - **目的：** 满足用户需求，超出用户期望；判定产品是否能让用户快速的接受和使用。
> - **触发条件：** 需求标签含 `need_experience`
> - **未勾选理由：** Robot 类服务无 UI，交互通过评论指令与定时任务，无需体验测试。

- [x] **集成测试**

> - **测试重点：** 跨服务调用链路验证、上下游数据最终一致性、数据库/中间件版本兼容性、GitHub API 交互验证。
> - **目的：** 消除组件间级联影响风险。
> - **触发条件：** 需求标签含 `need_itest`
> - **勾选理由：** #300 架构设计 TASK4 明确要求端到端冒烟，涉及 GitHub API 调用链路（GET/DELETE/POST labels、POST comments）；#888 涉及定时巡检与 GitHub search API 集成。

- [ ] **安全与隐私测试**

> - **测试重点：** 鉴权绕过测试、SQL/命令注入、敏感数据（PII）日志脱敏校验、SBOM 依赖漏洞扫描。
> - **目的：** 验证"纵深防御"机制是否生效，确保无隐私泄露。
> - **触发条件：** 需求标签含 `need_security`
> - **未勾选理由：** #300 架构设计明确"不涉及安全与隐私设计（只读 issue 公开元数据 + 写本仓标签与评论，无凭证/个人数据流转）"；#888 同样不涉及敏感数据流转。

- [x] **可靠性与韧性测试**

> - **测试重点：** 故障注入（Chaos）、GitHub API 5xx/429 指数退避重试、幂等性验证。
> - **目的：** 验证架构设计中的"面向失败设计"等能力。
> - **触发条件：** 涉及核心 Core 服务变更，且架构设计含可靠性与韧性设计。
> - **勾选理由：** #300 架构设计 3.2 节包含失败重试（GitHub API 5xx/429 指数退避）与幂等（comment-id 去重缓存、状态切换幂等）；#888 架构设计 3.2 节同样定义失败重试与同日多次扫描幂等。

- [x] **可服务性与可观测性测试**

> - **测试重点：** 告警有效性验证、指标准确性抽检、排障手册实操演练、日志字段完整性验证。
> - **目的：** 确保系统"可感知、可定位、可维护"。
> - **触发条件：** 涉及核心 Core 服务变更，且架构设计含可服务性与可观测性设计。
> - **勾选理由：** #300 架构设计 3.3 节定义关键日志字段（event_id、repo、issue_number、commenter、from_status、to_status、action）与 metrics；#888 架构设计 3.3 节定义 scan_id、org、prs_stale、reminders_sent、labels_added 等日志字段与 metrics。

- [ ] **性能与伸缩性测试**

> - **测试重点：** 基准测试、负载测试。验证延迟、吞吐量上限及资源配额（CPU/Mem）稳定性。
> - **目的：** 确保不产生性能退化，满足 SLO 要求。
> - **触发条件：** 涉及核心 Core 服务变更，且架构设计含性能与伸缩性设计。
> - **未勾选理由：** #300 架构设计 3.4 节明确"不涉及性能专项（命令调用频率极低）"；#888 架构设计 3.4 节同样明确"不涉及性能专项"。

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

#### 3.1.1 评论指令 /needs-validation 功能测试（来源：#300）

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
  - Issue 提单人评论 → 通过鉴权 → 执行状态切换
  - 非 Maintainer 且非提单人评论 → 拒绝 → 返回 confused reaction
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
- **测试内容**: 验证 POST 评论内容为 `✅ #${issue_number} 已切到 VALIDATION，CI 与测试将在 10 分钟内开始`（英文版同理）。
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

#### 3.1.2 长期无活动 PR 自动评论提醒功能测试（来源：#888）

**1. 定时巡检触发验证**

- **对应 TASK**: TASK1 #888-01（k8s CronJob 配置）
- **测试内容**: 验证 k8s CronJob 正确配置 schedule（每天 02:00 UTC）并触发 `/internal/stale-scan` 端点。
- **预期结果**:
  - CronJob 配置 schedule 正确（`0 2 * * *`）
  - 手动触发后日志含 `scan_id`、`orgs_scanned` 字段
  - HTTP 200 响应

**2. StaleScanner 扫描逻辑验证**

- **对应 TASK**: TASK2 #888-02（StaleScanner 实现）
- **测试内容**: 验证 StaleScanner 正确识别 >14 天无活动的 open PR，跳过 draft PR 与已带 stale label 的 PR。
- **预期结果**:
  - open PR（非 draft、无 stale label、>14 天）出现在 `prs_stale`
  - draft PR 不出现在 `prs_stale`（跳过 draft）
  - 已带 stale label 的 PR 不出现在 `prs_stale`（跳过已有 label）

**3. ReminderPoster 评论发送验证**

- **对应 TASK**: TASK3 #888-03（ReminderPoster 实现）
- **测试内容**: 验证 ReminderPoster 发送提醒评论含隐藏标记 `<!-- stale-reminder count=N -->`。
- **预期结果**:
  - 新评论 body 含 `<!-- stale-reminder count=1 -->` 隐藏标记
  - 评论可见部分含 `👋 @{author} — 这个 PR 已经 {days} 天无新活动了。`
  - 评论 user.login 为 robot-server bot 账号

**4. 连续提醒后 stale 标签添加验证**

- **对应 TASK**: TASK4 #888-04（StaleLabeler 集成）
- **测试内容**: 验证第 3 次提醒后触发 StaleLabeler.add_label()。
- **预期结果**:
  - 第 3 次提醒评论含 `<!-- stale-reminder count=3 -->`
  - Issue labels 新增 `stale` 标签
  - 第 3 次评论文案明确告知"再无回复将打 stale 标签"

**5. 端到端冒烟验证**

- **对应 TASK**: TASK5 #888-05（端到端冒烟）
- **测试内容**: 在测试仓制造 16 天 PR，验证 3 次扫描后 3 评论 + 1 标签。
- **预期结果**:
  - 第 1 次扫描：新增 1 条提醒评论（count=1）
  - 第 2 次扫描：新增 1 条提醒评论（count=2）
  - 第 3 次扫描：新增 1 条提醒评论（count=3） + `stale` label 添加
  - 共 3 条评论 + 1 次 label 操作

### 3.2 体验测试专项

> 第二节未勾选，本节删除

### 3.3 集成测试专项

#### 3.3.1 评论指令 /needs-validation 集成测试（来源：#300）

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

#### 3.3.2 长期无活动 PR 集成测试（来源：#888）

> 本需求无 `need_itest` 标签，robot-server 内部功能，无跨服务调用链路。

### 3.4 安全与隐私测试专项

> 第二节未勾选，本节删除

### 3.5 可靠性与韧性专项

#### 3.5.1 评论指令 /needs-validation 可靠性测试（来源：#300）

**1. GitHub API 失败重试验证**

- **对应 TASK**: TASK2 #300-02
- **测试内容**: 验证 GitHub API 返回 5xx 或 429 时走指数退避重试（基线 1s，最多 5 次）。
- **前置条件**: 可模拟 GitHub API 5xx/429 响应（通过 Mock 或代理）
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
- **前置条件**: 可模拟 GitHub API 4xx 响应
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

#### 3.5.2 长期无活动 PR 可靠性测试（来源：#888）

**1. GitHub API 5xx 指数退避重试验证**

- **对应 TASK**: 架构设计 3.2 章节
- **测试内容**: 验证 GitHub search API 返回 500 时走指数退避重试。
- **前置条件**: robot-server 已部署，GitHub API 可被 mock 或触发真实 5xx
- **操作步骤**:
  1. Mock GitHub search API 返回 500
  2. 触发扫描
  3. 观察日志是否记录重试次数与退避时间
- **预期结果**:
  - 日志记录 5 次重试（基线 1s，指数退避）
  - 最终失败后记录死信日志
  - 不会立即放弃

**2. GitHub API 429 Rate Limit 重试验证**

- **对应 TASK**: 架构设计 3.2 章节
- **测试内容**: 验证 GitHub API 返回 429 时走指数退避重试。
- **前置条件**: robot-server 已部署，GitHub API 返回 429
- **操作步骤**:
  1. Mock 或触发 GitHub API 返回 429（rate limit exceeded）
  2. 触发扫描
  3. 观察是否走指数退避重试
- **预期结果**:
  - 日志记录 429 响应与重试行为
  - 重试成功后正常处理后续 PR

**3. GitHub API 4xx 不重试验证**

- **对应 TASK**: 架构设计 3.2 章节
- **测试内容**: 验证 GitHub API 返回 4xx 时进入死信日志，不重试。
- **前置条件**: robot-server 已部署
- **操作步骤**:
  1. Mock GitHub API 返回 404（仓库不存在）或 401（鉴权失败）
  2. 触发扫描
  3. 观察日志是否记录死信且不重试
- **预期结果**:
  - 日志记录 4xx 错误进入死信队列
  - 不执行重试（日志无 retry attempt）

**4. 同日多次扫描幂等性验证**

- **对应 TASK**: 架构设计 3.2 章节
- **测试内容**: 验证同一 PR 同一日多次扫描不重复发送评论。
- **前置条件**: 测试仓存在一个 >14 天无活动的 PR（reminder_count=0）
- **操作步骤**:
  1. 第 1 次扫描 → 发送提醒评论（count=1）
  2. 立即第 2 次扫描（同一日）
  3. GET PR 评论列表
- **预期结果**:
  - 第 2 次扫描不发送重复评论（通过 reminder_count 解析判断已发送）
  - 评论列表仅 1 条 stale-reminder 评论

**5. CronJob 连续失败告警验证**

- **对应 TASK**: TASK7 #888-07（CronJob 失败告警）
- **测试内容**: 验证连续两天扫描失败触发 Prometheus alert。
- **前置条件**: Prometheus alert 规则已配置，on-call 已绑定
- **操作步骤**:
  1. Mock 连续两天扫描失败（返回 500 或超时）
  2. 检查 Prometheus alert 是否触发
  3. 检查告警是否推送到 on-call
- **预期结果**:
  - 连续两天失败后 Prometheus alert 触发
  - 告警通知发送到 on-call channel

### 3.6 可服务性与可观测性专项

#### 3.6.1 评论指令 /needs-validation 可观测性测试（来源：#300）

**1. 关键日志验证**

- **对应 TASK**: TASK6 #300-06
- **测试内容**: 验证日志包含关键字段：event_id、repo、issue_number、commenter、from_status、to_status=VALIDATION、action(success/denied/error)。
- **前置条件**: robot-server 日志可访问（如 stdout、文件、ELK）
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
- **前置条件**: robot-server metrics 端点可访问（如 `/metrics`）
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
- **前置条件**: 文档已更新
- **操作步骤**:
  1. 检查文档是否包含命令名称 `/needs-validation`
  2. 检查是否包含常见失败码（如 401 Unauthorized、403 Forbidden、404 Not Found、500 Internal Server Error）
  3. 检查每个失败码是否有对应的排障步骤
- **预期结果**:
  - 文档包含 `/needs-validation` 命令的失败码清单
  - 每个失败码有明确的排障步骤

#### 3.6.2 长期无活动 PR 可观测性测试（来源：#888）

**1. 日志字段完整性验证**

- **对应 TASK**: 架构设计 3.3 章节
- **测试内容**: 验证日志包含 scan_id、org、repos_scanned、prs_stale、reminders_sent、labels_added、errors 字段。
- **前置条件**: robot-server 已部署，日志收集已配置
- **操作步骤**:
  1. 触发一次扫描（成功场景）
  2. 提取日志条目
  3. 检查是否含所有定义字段
- **预期结果**:
  - 日志条目包含所有定义字段
  - 字段值为具体数值（如 `reminders_sent: 2`）

**2. Metrics 数值正确性验证**

- **对应 TASK**: 架构设计 3.3 章节
- **测试内容**: 验证 `robot_stale_scan_total`、`robot_stale_reminders_total{org}`、`robot_stale_label_added_total{org}` 正确上报。
- **前置条件**: Prometheus metrics endpoint 已暴露
- **操作步骤**:
  1. 触发扫描（制造 2 个 stale PR）
  2. GET `/metrics` 端点
  3. 检查 metrics 数值
- **预期结果**:
  - `robot_stale_scan_total` 增加 1
  - `robot_stale_reminders_total{org=<org>}` 增加 2
  - 若有 label 添加，`robot_stale_label_added_total{org=<org>}` 增加

**3. Grafana 面板展示验证**

- **对应 TASK**: TASK8 #888-08
- **测试内容**: 验证 Grafana 面板展示每日扫描覆盖率、提醒发送量、label 添加量。
- **前置条件**: Grafana 面板已配置，数据源为 Prometheus
- **操作步骤**:
  1. 打开 Grafana 面板
  2. 检查是否展示 3 个图表
  3. 触发一次扫描，观察面板数值更新
- **预期结果**:
  - 面板展示 3 个图表（扫描覆盖率、提醒发送量、label 添加量）
  - 扫描后数值实时更新（或按采集周期更新）

**4. 排障文档验证**

- **对应 TASK**: TASK6 #888-06
- **测试内容**: 验证 `robot-server/docs/runbook.md` 包含错误码列表与排障步骤、dry-run 入口说明。
- **前置条件**: 文档已创建
- **操作步骤**:
  1. 读取 runbook.md 内容
  2. 检查是否包含错误码列表与排障步骤
  3. 检查是否包含 dry-run 入口说明
- **预期结果**:
  - 文档包含 GitHub API 错误码（4xx/5xx）对应排障步骤
  - 文档包含 dry-run 命令示例（如 `curl /internal/stale-scan?dry_run=true`）

### 3.7 性能与可伸缩性专项

> 第二节未勾选，本节删除

---

## 4. 测试用例索引

> 详细测试用例见 `test_cases.py`（Python pytest 脚本）

### 4.1 评论指令 /needs-validation 用例索引（来源：#300）

| 用例 ID | 测试标题 | 关联 TASK | 优先级 | 测试类型 |
| --- | --- | --- | --- | --- |
| TC-ROBOT-VAL-001 | 命令解析-合法命令触发处理 | TASK2 | P0 | unit |
| TC-ROBOT-VAL-002 | 命令解析-非法命令不触发 | TASK2 | P1 | unit |
| TC-ROBOT-VAL-003 | 鉴权-Maintainer通过 | TASK2, TASK3 | P0 | unit |
| TC-ROBOT-VAL-004 | 鉴权-Issue提单人通过 | TASK2, TASK3 | P0 | unit |
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

### 4.2 长期无活动 PR 自动评论提醒用例索引（来源：#888）

| 用例 ID | 测试标题 | 关联 TASK | 优先级 | 测试类型 |
| --- | --- | --- | --- | --- |
| TC-ROBOT-STALE-001 | StaleScanner 正确识别 >14 天无活动的 open PR | TASK2 #888-02 | P0 | integration |
| TC-ROBOT-STALE-002 | StaleScanner 跳过 draft PR | TASK2 #888-02 | P0 | integration |
| TC-ROBOT-STALE-003 | StaleScanner 跳过已带 stale label 的 PR | TASK2 #888-02 | P0 | integration |
| TC-ROBOT-STALE-004 | 边界值-updated_at 刚好 14 天 | TASK2 #888-02 | P1 | integration |
| TC-ROBOT-STALE-005 | 边界值-updated_at 13 天（不触发） | TASK2 #888-02 | P1 | integration |
| TC-ROBOT-REMINDER-001 | ReminderPoster 发送提醒评论含隐藏标记 | TASK3 #888-03 | P0 | integration |
| TC-ROBOT-REMINDER-002 | ReminderPoster 第 2 次提醒 count=2 | TASK3 #888-03 | P1 | integration |
| TC-ROBOT-REMINDER-003 | 第 3 次提醒明确告知将打 stale 标签 | TASK3 #888-03 + TASK4 #888-04 | P0 | integration |
| TC-ROBOT-LABELER-001 | count>=3 时添加 stale 标签 | TASK4 #888-04 | P0 | integration |
| TC-ROBOT-LABELER-002 | 已有 stale 标签时不重复添加 | TASK4 #888-04 | P1 | integration |
| TC-ROBOT-CRON-001 | 手动触发 /internal/stale-scan 端点 | TASK1 #888-01 | P0 | integration |
| TC-ROBOT-CRON-002 | k8s CronJob 每天 02:00 UTC 自动触发（手工） | TASK1 #888-01 | P0 | manual |
| TC-ROBOT-E2E-001 | 端到端：16 天 PR → 3 次扫描 → 3 评论 + 1 标签 | TASK5 #888-05 | P0 | e2e |
| TC-ROBOT-E2E-002 | 端到端：在真实测试仓制造 16 天 PR 并验证 3 次扫描完整流程（手工） | TASK5 #888-05 | P0 | manual |
| TC-ROBOT-RELIABILITY-001 | GitHub API 5xx 指数退避重试 | 架构 3.2 | P0 | reliability |
| TC-ROBOT-RELIABILITY-002 | GitHub API 429 rate limit 重试 | 架构 3.2 | P1 | reliability |
| TC-ROBOT-RELIABILITY-003 | GitHub API 4xx 不重试（死信） | 架构 3.2 | P1 | reliability |
| TC-ROBOT-RELIABILITY-004 | 同日多次扫描幂等性 | 架构 3.2 | P1 | reliability |
| TC-ROBOT-RELIABILITY-005 | CronJob 连续两天失败触发 Prometheus alert（手工） | TASK7 #888-07 | P1 | manual |
| TC-ROBOT-OBSERV-001 | 日志字段完整性 | 架构 3.3 | P1 | observability |
| TC-ROBOT-OBSERV-002 | metrics 数值正确性 | 架构 3.3 | P1 | observability |
| TC-ROBOT-OBSERV-003 | Grafana 面板展示 | TASK8 #888-08 | P2 | observability |
| TC-ROBOT-OBSERV-004 | Grafana 面板展示三个图表（手工） | TASK8 #888-08 | P2 | manual |
| TC-ROBOT-OBSERV-005 | 日志条目字段为具体数值而非占位符（手工） | 架构 3.3 | P2 | manual |
| TC-ROBOT-DOCS-001 | 排障文档 runbook.md 内容完整（手工） | TASK6 #888-06 | P1 | manual |

---

## 5. 风险与依赖

| 风险项 | 影响 | 缓解措施 |
| --- | --- | --- |
| GitHub API 限流 | 状态切换失败、扫描失败 | 实现 429 重试机制，监控 rate limit 剩余量 |
| Webhook 延迟 | 用户等待时间变长 | 在回执评论中明确说明"10 分钟内"，设置合理预期 |
| Robot 账号权限不足 | 无法操作标签/评论 | 部署前验证 Robot 账号对目标仓库的 write 权限 |
| 状态标签命名不一致 | 状态切换失败 | 统一使用 GitHub Label API，避免硬编码标签名 |
| 测试仓库不可达 | E2E 测试无法执行 | 使用专用测试仓库，确保 CI 环境网络连通 |
| CronJob 配置错误 | 定时巡检不触发 | 部署前验证 schedule 配置与 k8s CronJob 状态 |
| Prometheus/Grafana 不可达 | 可观测性验证失败 | 确保 metrics endpoint 与 Grafana 面板可访问 |

---

## 6. 测试执行建议

- **单元测试**: 评论指令处理（ValidationCommand、AuthChecker）、StaleScanner、ReminderPoster、StaleLabeler 的核心逻辑应覆盖单元测试
- **集成测试**: 在测试仓（如 `agentic-develop-playground/test-robot-server`）进行端到端验证
- **手动触发入口**: 
  - `/needs-validation`：在测试仓真实评论触发
  - `/internal/stale-scan?dry_run=true`：dry-run 模式验证 stale PR 扫描
- **清理**: 测试完成后关闭制造的测试 Issue/PR，避免影响真实仓库
# robot-server 模块测试策略

## 更新记录

| PR | Issue | 合入时间 | 说明 |
|---|---|---|---|
| [#166](https://github.com/agentic-develop-playground/backlog/pull/166) | #888 | 2026-05-23 | 长期无活动 PR 自动评论提醒测试策略 |

---

## 1. 基本信息

### 1.1 模块概述

- **模块名称**: robot-server
- **模块描述**: 机器人服务模块，处理代码托管平台（GitHub/GitCode/Gitee 等）的 Webhook 事件，提供自动化操作能力
- **核心组件**: StaleScanner、ReminderPoster、StaleLabeler、CronJob 调度器

### 1.2 需求索引

| Issue | 需求名称 | 测试策略章节 |
|---|---|---|
| #888 | 长期无活动 PR 自动评论提醒 | [3.1.1](#311-定时巡检触发验证) - [3.3.3](#333-grafana-面板展示验证) |

---

## 2. 测试维度确认

> **操作指南**：请依据需求分析阶段的标签勾选。勾选后，必须在"第 3 节"提供对应的测试用例或方案。

- [x] **功能自检测试**

> - **测试重点：** API 契约验证、业务逻辑分支覆盖、边界值测试。
> - **目的：** 确保功能实现符合设计预期。
> - **触发条件：** 强制执行,**可委托开发测试完成，测试完成验收**。

- [ ] **体验测试**

> - **测试重点：** 站在用户角度进行体验使用，验证产品是否符合用户习惯。
> - **目的：** 满足用户需求，超出用户期望；判定产品是否能让用户快速的接受和使用。
> - **触发条件：** 需求标签含 `need_experience`

- [ ] **集成测试**

> - **测试重点：** 跨服务调用链路验证、上下游数据最终一致性、数据库/中间件版本兼容性。
> - **目的：** 消除组件间级联影响风险。
> - **触发条件：** 需求标签含 `need_itest`

- [ ] **安全与隐私测试**：

> - **测试重点：** 鉴权绕过测试、SQL/命令注入、敏感数据（PII）日志脱敏校验、SBOM 依赖漏洞扫描。
> - **目的：** 验证"纵深防御"机制是否生效，确保无隐私泄露。
> - **触发条件：** 需求标签含 `need_security`

- [x] **可靠性与韧性测试**

> - **测试重点：** 故障注入（Chaos）。模拟网络丢包/延迟、进程意外溢出、磁盘 IO 满载后等异常情况下的系统自愈行为。
> - **目的：** 验证架构设计中的"面向失败设计"等能力。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含可靠性与韧性设计。

- [x] **可服务性与可观测性测试**

> - **测试重点：** 告警有效性验证、指标准确性抽检、排障手册实操演练、优雅停机验证。
> - **目的：** 确保系统"可感知、可定位、可维护"。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含可服务性与可观测性设计。

- [ ] **性能与伸缩性测试**

> - **测试重点：** 基准测试、负载测试。验证延迟、吞吐量上限及资源配额（CPU/Mem）稳定性。
> - **目的：** 确保不产生性能退化，满足 SLO 要求。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含性能与伸缩性设计。

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

#### 3.1.1 定时巡检触发验证（#888）

**对应 TASK**: TASK1 #888-01（k8s CronJob 配置）

- **前置条件**: k8s CronJob 已部署，配置每天 02:00 UTC 触发 `/internal/stale-scan` 端点
- **操作步骤**:
  1. 检查 CronJob 配置文件（schedule: `0 2 * * *`）
  2. 手动触发一次 `/internal/stale-scan` 端点（dry-run 或真实调用）
  3. 观察 robot-server 日志是否记录扫描开始
- **预期结果**:
  - CronJob 配置 schedule 正确
  - 手动触发后日志含 `scan_id`、`orgs_scanned` 字段
  - HTTP 200 响应

#### 3.1.2 StaleScanner 扫描逻辑验证（#888）

**对应 TASK**: TASK2 #888-02（StaleScanner 实现）

- **前置条件**: GitHub Token 已配置，org 白名单 `[ascend, cann]` 已配置
- **操作步骤**:
  1. 在测试仓制造一个 open PR，updated_at 设为 16 天前
  2. 制造另一个 draft PR（同条件）
  3. 制造另一个已带 `stale` label 的 PR
  4. 调用 `/internal/stale-scan` 或 StaleScanner.scan()
  5. 检查返回的 Report 中 `prs_stale` 列表
- **预期结果**:
  - open PR（非 draft、无 stale label、>14 天）出现在 `prs_stale`
  - draft PR 不出现在 `prs_stale`（跳过 draft）
  - 已带 stale label 的 PR 不出现在 `prs_stale`（跳过已有 label）

#### 3.1.3 ReminderPoster 评论发送验证（#888）

**对应 TASK**: TASK3 #888-03（ReminderPoster 实现）

- **前置条件**: 测试仓存在一个 >14 天无活动的 open PR（reminder_count=0）
- **操作步骤**:
  1. 调用 ReminderPoster.post(repo, pr, count=0)
  2. 等待 10-15 秒（异步 Webhook 处理）
  3. GET `/repos/{o}/{r}/issues/{n}/comments`
  4. 过滤 body 含 `<!-- stale-reminder count=1 -->` 的评论
- **预期结果**:
  - 新评论 body 含 `<!-- stale-reminder count=1 -->` 隐藏标记
  - 评论可见部分含 `👋 @{author} — 这个 PR 已经 {days} 天无新活动了。`
  - 评论 user.login 为 robot-server bot 账号

#### 3.1.4 连续提醒后 stale 标签添加验证（#888）

**对应 TASK**: TASK4 #888-04（StaleLabeler 集成）

- **前置条件**: 测试仓存在一个 >14 天无活动的 open PR，已有 2 条 stale-reminder 评论（count=2）
- **操作步骤**:
  1. 调用 ReminderPoster.post(repo, pr, count=2) → 发送第 3 次提醒
  2. 检查是否触发 StaleLabeler.add_label()
  3. GET `/repos/{o}/{r}/issues/{n}` 查看 labels
- **预期结果**:
  - 第 3 次提醒评论含 `<!-- stale-reminder count=3 -->`
  - Issue labels 新增 `stale` 标签
  - 第 3 次评论文案明确告知"再无回复将打 stale 标签"

#### 3.1.5 端到端冒烟验证（#888）

**对应 TASK**: TASK5 #888-05（端到端冒烟）

- **前置条件**: 测试仓已就绪，robot-server 已部署，配置 `stale_days=14, max_reminders=3`
- **操作步骤**:
  1. 在测试仓制造一个 16 天前的 open PR（非 draft）
  2. 连续调用 3 次扫描（或等待 3 天的自然触发）
  3. 每次调用后等待 10-15 秒，GET PR 评论列表
- **预期结果**:
  - 第 1 次扫描：新增 1 条提醒评论（count=1）
  - 第 2 次扫描：新增 1 条提醒评论（count=2）
  - 第 3 次扫描：新增 1 条提醒评论（count=3） + `stale` label 添加
  - 共 2 条评论 + 1 次 label 操作

#### 3.1.6 排障文档验证（#888）

**对应 TASK**: TASK6 #888-06（排障文档）

- **前置条件**: `robot-server/docs/runbook.md` 已创建
- **操作步骤**:
  1. 读取 runbook.md 内容
  2. 检查是否包含错误码列表与排障步骤
  3. 检查是否包含人工触发 dry-run 入口说明
- **预期结果**:
  - 文档包含 GitHub API 错误码（4xx/5xx）对应排障步骤
  - 文档包含 dry-run 命令示例（如 `curl /internal/stale-scan?dry_run=true`）

### 3.2 可靠性与韧性专项

#### 3.2.1 GitHub API 5xx 指数退避重试验证（#888）

**对应 TASK**: 无（架构设计 3.2 章节）

- **前置条件**: robot-server 已部署，GitHub API 可被 mock 或触发真实 5xx
- **操作步骤**:
  1. Mock GitHub search API 返回 500
  2. 触发扫描
  3. 观察日志是否记录重试次数与退避时间
- **预期结果**:
  - 日志记录 5 次重试（基线 1s，指数退避）
  - 最终失败后记录死信日志
  - 不会立即放弃

#### 3.2.2 GitHub API 429 Rate Limit 重试验证（#888）

**对应 TASK**: 无（架构设计 3.2 章节）

- **前置条件**: robot-server 已部署，GitHub API 返回 429
- **操作步骤**:
  1. Mock 或触发 GitHub API 返回 429（rate limit exceeded）
  2. 触发扫描
  3. 观察是否走指数退避重试
- **预期结果**:
  - 日志记录 429 响应与重试行为
  - 重试成功后正常处理后续 PR

#### 3.2.3 GitHub API 4xx 不重试验证（#888）

**对应 TASK**: 无（架构设计 3.2 章节）

- **前置条件**: robot-server 已部署
- **操作步骤**:
  1. Mock GitHub API 返回 404（仓库不存在）或 401（鉴权失败）
  2. 触发扫描
  3. 观察日志是否记录死信且不重试
- **预期结果**:
  - 日志记录 4xx 错误进入死信队列
  - 不执行重试（日志无 retry attempt）

#### 3.2.4 同日多次扫描幂等性验证（#888）

**对应 TASK**: 无（架构设计 3.2 章节）

- **前置条件**: 测试仓存在一个 >14 天无活动的 PR（reminder_count=0）
- **操作步骤**:
  1. 第 1 次扫描 → 发送提醒评论（count=1）
  2. 立即第 2 次扫描（同一日）
  3. GET PR 评论列表
- **预期结果**:
  - 第 2 次扫描不发送重复评论（通过 reminder_count 解析判断已发送）
  - 评论列表仅 1 条 stale-reminder 评论

#### 3.2.5 CronJob 连续失败告警验证（#888）

**对应 TASK**: TASK7 #888-07（CronJob 失败告警）

- **前置条件**: Prometheus alert 规则已配置，on-call 已绑定
- **操作步骤**:
  1. Mock 连续两天扫描失败（返回 500 或超时）
  2. 检查 Prometheus alert 是否触发
  3. 检查告警是否推送到 on-call
- **预期结果**:
  - 连续两天失败后 Prometheus alert 触发
  - 告警通知发送到 on-call channel

### 3.3 可服务性与可观测性专项

#### 3.3.1 日志字段完整性验证（#888）

**对应 TASK**: 无（架构设计 3.3 章节）

- **前置条件**: robot-server 已部署，日志收集已配置
- **操作步骤**:
  1. 触发一次扫描（成功场景）
  2. 提取日志条目
  3. 检查是否含 `scan_id`、`org`、`repos_scanned`、`prs_stale`、`reminders_sent`、`labels_added`、`errors`
- **预期结果**:
  - 日志条目包含所有定义字段
  - 字段值为具体数值（如 `reminders_sent: 2`）

#### 3.3.2 Metrics 数值正确性验证（#888）

**对应 TASK**: 无（架构设计 3.3 章节）

- **前置条件**: Prometheus metrics endpoint 已暴露
- **操作步骤**:
  1. 触发扫描（制造 2 个 stale PR）
  2. GET `/metrics` 端点
  3. 检查 `robot_stale_scan_total`、`robot_stale_reminders_total{org}`、`robot_stale_label_added_total{org}`
- **预期结果**:
  - `robot_stale_scan_total` 增加 1
  - `robot_stale_reminders_total{org=<org>}` 增加 2
  - 若有 label 添加，`robot_stale_label_added_total{org=<org>}` 增加

#### 3.3.3 Grafana 面板展示验证（#888）

**对应 TASK**: TASK8 #888-08（Grafana 面板）

- **前置条件**: Grafana 面板已配置，数据源为 Prometheus
- **操作步骤**:
  1. 打开 Grafana 面板
  2. 检查是否展示每日扫描覆盖率、提醒发送量、label 添加量
  3. 触发一次扫描，观察面板数值更新
- **预期结果**:
  - 面板展示 3 个图表（扫描覆盖率、提醒发送量、label 添加量）
  - 扫描后数值实时更新（或按采集周期更新）

---

## 4. Task 闭环自查

| TASK ID | 功能/可靠性/可服务性任务描述 | 测试覆盖情况 | 来源 Issue |
|---|---|---|---|
| TASK1 #888-01 | k8s CronJob 配置 | 3.1.1 定时巡检触发验证 | #888 |
| TASK2 #888-02 | StaleScanner 实现 | 3.1.2 StaleScanner 扫描逻辑验证 | #888 |
| TASK3 #888-03 | ReminderPoster 实现 | 3.1.3 ReminderPoster 评论发送验证 | #888 |
| TASK4 #888-04 | StaleLabeler 集成 | 3.1.4 连续提醒后 stale 标签添加验证 | #888 |
| TASK5 #888-05 | 端到端冒烟 | 3.1.5 端到端冒烟验证 | #888 |
| TASK6 #888-06 | 排障文档 | 3.1.6 排障文档验证 | #888 |
| TASK7 #888-07 | CronJob 失败告警 | 3.2.5 CronJob 连续失败告警验证 | #888 |
| TASK8 #888-08 | Grafana 面板 | 3.3.3 Grafana 面板展示验证 | #888 |

---

## 5. 测试执行建议

- **单元测试**: TASK2/TASK3/TASK4 的核心逻辑应覆盖单元测试（updated_at 边界、draft 跳过、count 解析）
- **集成测试**: 在测试仓（如 `agentic-develop-playground/test-stale-pr`）进行端到端验证
- **手动触发入口**: 使用 `curl /internal/stale-scan?dry_run=true` 进行 dry-run 模式验证，避免污染真实 PR
- **清理**: 测试完成后关闭制造的测试 PR，避免影响真实仓库

---

## 6. 需补充信息

1. **测试仓 URL**: 需提供一个用于端到端测试的真实 GitHub 仓库 URL（含 bot 账号与 Token）
2. **GitHub Token**: 用于测试的 PAT（需 repo:read + issues:write 权限）
3. **Grafana 面板 URL**: 用于可观测性验证的 Grafana 面板地址
4. **Prometheus endpoint**: metrics 抓取端点地址
5. **k8s CronJob 配置文件路径**: 用于验证 schedule 配置
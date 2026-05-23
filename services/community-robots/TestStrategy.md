# community-robots 模块测试策略

## 更新记录

| PR | Issues | 合入时间 | 说明 |
| --- | --- | --- | --- |
| [#100](https://github.com/agentic-develop-playground/backlog/pull/100) | 77 | 2026-05-23 | 昇腾社区 issue 状态自动同步 resolved 标签 |

---

## 1. 模块概述

- **模块名称**: community-robots
- **模块职责**: 昇腾社区机器人服务，处理 GitHub issue 状态与标签同步等自动化任务
- **核心组件**: StatusMapper、LabelSyncer、EventRouter、ConfigManager

---

## 2. 测试维度确认

> **操作指南**：依据各需求的标签勾选。勾选后，必须在"第 3 节"提供对应的测试用例或方案。

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

- [ ] **安全与隐私测试**

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

#### #77 昇腾社区 issue 状态自动同步 resolved 标签

**需求链接**: https://github.com/agentic-develop-playground/backlog/issues/77

##### 1. StatusMapper 状态映射逻辑验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK1 #77-01)
- **测试内容**:
  - 验证 6 个状态标签（TODO、ACCEPTED、WIP、VALIDATION、DONE、REJECTED）的映射逻辑
  - 验证 `should_resolved = S ∩ {VALIDATION, DONE} ≠ ∅` 计算正确性
  - 验证多标签共存场景（如 `VALIDATION + WIP`）
- **预期结果**:
  - 只有当 issue 状态为 VALIDATION 或 DONE 时，`should_resolved` 返回 true
  - 多标签场景下，只要有 VALIDATION 或 DONE 之一，即返回 true
  - 单元测试覆盖率 ≥ 90%

##### 2. LabelSyncer 幂等性验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK2 #77-02)
- **测试内容**:
  - 验证 add 操作幂等性：重复添加 `resolved` 标签不会产生副作用
  - 验证 remove 操作幂等性：重复移除不存在的 `resolved` 标签不报错
  - 验证 no-op 场景：`should=T, has=T` 或 `should=F, has=F` 不触发任何 API 调用
- **预期结果**:
  - 重复操作后 issue 标签状态一致
  - 无多余的 GitHub API 调用

##### 3. LabelSyncer GitHub 4xx 错误处理验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK2 #77-02)
- **测试内容**:
  - 验证 404（label 不存在）：自动创建 `resolved` 标签一次
  - 验证 403（权限不足）：记录告警日志，不重试
  - 验证 422（验证失败）：记录告警日志，不重试
- **预期结果**:
  - 404 场景：自动创建标签后重试成功
  - 403/422 场景：进入死信日志，告警触发

##### 4. EventRouter 事件过滤与路由验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK3 #77-03)
- **测试内容**:
  - 验证 `issues.labeled` 和 `issues.unlabeled` 事件触发处理
  - 验证组织白名单过滤：`owner ∈ {ascend, cann}` 放行，否则丢弃
  - 验证非目标 action（如 `opened`、`edited`）被忽略
- **预期结果**:
  - 只有 asc/ann 组织的 labeled/unlabeled 事件触发后续处理
  - 其他组织和 action 类型的事件被正确丢弃

##### 5. 组织白名单配置验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK4 #77-04)
- **测试内容**:
  - 验证 ConfigMap 默认值为 `ascend,cann`
  - 验证配置修改后实时生效
  - 验证 README 中配置覆盖方式的准确性
- **预期结果**:
  - ConfigMap 默认配置符合预期
  - 配置变更后无需重启即可生效

##### 6. 端到端冒烟测试（ascend 组织）

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK5 #77-05)
- **测试内容**:
  - 在 `ascend/` 测试仓创建 issue
  - 打上 `VALIDATION` 标签 → 验证 `resolved` 自动添加
  - 打上 `DONE` 标签 → 验证 `resolved` 保持存在
  - 撤销 `VALIDATION` 和 `DONE`，打上 `WIP` → 验证 `resolved` 自动移除
- **预期结果**:
  - `resolved` 标签随状态标签自动同步
  - 同步延迟 < 5 秒

##### 7. 端到端冒烟测试（cann 组织）

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK5 #77-05)
- **测试内容**:
  - 在 `cann/` 测试仓创建 issue
  - 执行与 ascend 组织相同的标签操作序列
- **预期结果**:
  - `resolved` 标签同步行为与 ascend 组织一致

##### 8. 排障文档可操作性验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK6 #77-06)
- **测试内容**:
  - 模拟常见错误场景（403、422、5xx）
  - 按照 `robot-issue-manage/docs/runbook.md` 执行排障步骤
- **预期结果**:
  - 排障步骤清晰、可执行
  - 错误码与排障步骤映射准确

### 3.2 体验测试专项

> 参考测试设计方向
>
> - 无效引导：是否有空数据界面设计，引导用户去执行操作；是否滥用用户引导；是否有不可点击的效果。
> - 页面易用性：菜单层次是否太深；网站页面是否过长，内容过多，引起浏览者视觉疲劳；一次是否载入太多的数据；交互流程分支是否太多。
> - 设计易用性：标签页是否跟内容没有从属关系，当切换标签的时候，内容跟着切换；操作应该有主次从属关系；导航是否友好，不知如何返回上一页，不知当前页面在哪个栏目下；过于复杂的验证码，不清晰的验证码。
> - 页面性能：页面加载，下载时间是否过长，是否在合理的加载范围内；页面是否有过多新窗口，大量占用计算机资源。
> - 页面信息：是否有死链接或者链接错误；是否有页面安全信息；过于复杂的验证码，不清晰的验证码。

*暂无体验测试需求*

### 3.3 集成测试专项

> 参考测试设计方向
>
> - 协议兼容性：验证不同版本的组件间（如旧版网关与新版后端）通过 gRPC/HTTP 通信的兼容性。
> - 分布式事务/最终一致性：验证跨数据库操作或跨服务调用时，在网络波动下的数据对齐情况。
> - 全链路追踪覆盖：确保 TraceID 在所有微服务节点间透传，无断链现象。

*暂无集成测试需求*

### 3.4 安全与隐私测试专项

> 参考测试设计方向
>
> - 最小特权原则 (PoLP)：验证服务账户（Service Account）是否无法越权操作未授权的资源。
> - 软件供应链审计：通过 SBOM 检查，验证容器镜像中是否存在已知的高危 CVE 漏洞。
> - 敏感信息外泄防护：检查日志、监控指标及 API 报错中是否夹带了明文密钥或隐私数据。

*暂无安全与隐私测试需求*

### 3.5 可靠性与韧性专项

> 参考测试设计方向
>
> - 优雅降级与熔断：验证当外部依赖响应极慢时，系统是否能快速切换到"断路"状态以保护自身。
> - 自愈能力 (Chaos Engineering)：验证 Pod 被随机 Kill 或节点网络分区后，流量是否能自动漂移并恢复。
> - 幂等性验证：验证同一请求重试多次后，系统状态和数据是否保持唯一，无重复记录。

#### #77 昇腾社区 issue 状态自动同步 resolved 标签

**需求链接**: https://github.com/agentic-develop-playground/backlog/issues/77

##### 1. GitHub API 5xx 重试验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK7 #77-07)
- **测试内容**:
  - 模拟 GitHub API 返回 500、502、503、504
  - 验证指数退避 + 抖动重试（基线 1s，最多 5 次）
  - 验证 429（Rate Limit）触发退避重试
- **预期结果**:
  - 5xx 和 429 错误触发重试
  - 重试间隔符合指数退避策略
  - 最终成功或达到最大重试次数后记录死信日志

##### 2. GitHub API 4xx 死信处理验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK2 #77-02)
- **测试内容**:
  - 模拟 GitHub API 返回 403、422
  - 验证不重试，直接进入死信日志
- **预期结果**:
  - 4xx 错误不触发重试
  - 死信日志包含完整错误信息和事件上下文

##### 3. 幂等性验证（事件重放）

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK2 #77-02)
- **测试内容**:
  - 手动重放同一个 `issues.labeled` 事件多次
  - 验证 issue 标签状态最终一致
- **预期结果**:
  - 多次重放后 issue 标签状态无变化
  - 无重复添加或重复删除

##### 4. Webhook 失败降级验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK7 #77-07)
- **测试内容**:
  - 模拟 webhook 丢失或处理失败
  - 验证其他 robot 业务不受影响
- **预期结果**:
  - 失败事件不阻塞其他事件处理
  - 补偿作业可在 6 小时内自动修复漂移

##### 5. 定时巡检补偿作业验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK7 #77-07)
- **测试内容**:
  - 手动创建一个带有 `VALIDATION` 或 `DONE` 标签但缺少 `resolved` 的 issue
  - 等待巡检作业执行（最多 6 小时）
  - 验证 `resolved` 标签被自动补打
- **预期结果**:
  - 巡检作业正确识别漂移 issue
  - 补打成功后记录日志

### 3.6 可服务性与可观测性专项

> 参考测试设计方向
>
> - 告警闭环验证：验证从指标触发阈值到告警推送（通知到人）的全流程时效性。
> - 资源优雅退出：验证服务在重启过程中，是否能确保存量请求处理完后再断开连接。
> - 排障手册 (Runbook) 校验：验证运维人员能否仅凭监控图表和文档快速定位根因。

#### #77 昇腾社区 issue 状态自动同步 resolved 标签

**需求链接**: https://github.com/agentic-develop-playground/backlog/issues/77

##### 1. 关键日志字段验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK8 #77-08)
- **测试内容**:
  - 触发标签同步操作
  - 检查日志是否包含：`event_id`、`repo`、`issue_number`、`from_labels`、`to_labels`、`action(add/remove/noop/error)`
- **预期结果**:
  - 所有日志字段完整且准确
  - 日志格式符合结构化日志规范

##### 2. Metrics 指标验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK8 #77-08)
- **测试内容**:
  - 触发多次标签同步（add/remove/noop/error）
  - 查询 Prometheus 指标：`robot_issue_resolved_sync_total{action}`、`robot_issue_resolved_sync_errors_total{kind}`
- **预期结果**:
  - 指标值与实际操作次数一致
  - 错误分类正确（如 `403`、`422`、`5xx`）

##### 3. Grafana 面板数据准确性验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK8 #77-08)
- **测试内容**:
  - 查看新增的「过去 24h resolved 同步速率 / 错误率」面板
  - 对比 Prometheus 原始数据与面板展示
- **预期结果**:
  - 面板数据与 Prometheus 数据一致
  - 图表可读性良好，无数据缺失

##### 4. 健康检查端点验证

- **对应task(issueID)链接**: https://github.com/agentic-develop-playground/backlog/issues/77 (TASK8 #77-08)
- **测试内容**:
  - 访问 `/health` 端点
  - 验证新规则启用状态（`enabled=true` flag）
- **预期结果**:
  - 健康检查返回 200 OK
  - 新规则状态正确反映

### 3.7 性能与可伸缩性专项

> 参考测试设计方向
>
> - 吞吐量与时延基准：验证在额定并发下，P99 延迟是否满足服务水平协议（SLA）。
> - 自动扩缩容效率：验证 HPA（水平扩容）从触发阈值到新副本就绪的响应时间。
> - 长期稳定性 (Soak Test)：验证在持续负载下，是否存在内存缓慢泄漏或连接数不释放的问题。

*暂无性能与可伸缩性测试需求*
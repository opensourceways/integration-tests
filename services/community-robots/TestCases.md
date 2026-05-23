# services/community-robots 模块测试用例清单

> 模块：community-robots
> 用例总数：43 条 ｜ P0：23 ｜ P1：20
> 更新记录：PR [#115](https://github.com/agentic-develop-playground/backlog/pull/115) | Issues: 77 | 合入时间: 2026-05-23

---

## 【PR #115】#77 昇腾社区 issue 状态自动同步 resolved 标签

**需求链接**: https://github.com/agentic-develop-playground/backlog/issues/77

### 一、StatusMapper 状态映射逻辑验证

| 用例 ID | 对应 task(issueID) 链接 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 类型 |
| --- | --- | --- | --- | --- | --- | --- |
| statmapper.001 | [TASK1 #77-01](https://github.com/agentic-develop-playground/backlog/issues/77) | StatusMapper 组件已部署；测试环境可访问 | 1. 输入 labels=['VALIDATION']<br>2. 调用 map() 方法 | should_resolved = true | P0 | unit |
| statmapper.002 | [TASK1 #77-01](https://github.com/agentic-develop-playground/backlog/issues/77) | StatusMapper 组件已部署；测试环境可访问 | 1. 输入 labels=['DONE']<br>2. 调用 map() 方法 | should_resolved = true | P0 | unit |
| statmapper.003 | [TASK1 #77-01](https://github.com/agentic-develop-playground/backlog/issues/77) | StatusMapper 组件已部署；测试环境可访问 | 1. 输入 labels=['TODO']<br>2. 调用 map() 方法 | should_resolved = false | P0 | unit |
| statmapper.004 | [TASK1 #77-01](https://github.com/agentic-develop-playground/backlog/issues/77) | StatusMapper 组件已部署；测试环境可访问 | 1. 输入 labels=['ACCEPTED']<br>2. 调用 map() 方法 | should_resolved = false | P1 | unit |
| statmapper.005 | [TASK1 #77-01](https://github.com/agentic-develop-playground/backlog/issues/77) | StatusMapper 组件已部署；测试环境可访问 | 1. 输入 labels=['WIP']<br>2. 调用 map() 方法 | should_resolved = false | P1 | unit |
| statmapper.006 | [TASK1 #77-01](https://github.com/agentic-develop-playground/backlog/issues/77) | StatusMapper 组件已部署；测试环境可访问 | 1. 输入 labels=['REJECTED']<br>2. 调用 map() 方法 | should_resolved = false | P1 | unit |
| statmapper.007 | [TASK1 #77-01](https://github.com/agentic-develop-playground/backlog/issues/77) | StatusMapper 组件已部署；测试环境可访问 | 1. 输入 labels=['VALIDATION', 'WIP']<br>2. 调用 map() 方法 | should_resolved = true（多标签共存场景） | P0 | unit |
| statmapper.008 | [TASK1 #77-01](https://github.com/agentic-develop-playground/backlog/issues/77) | StatusMapper 组件已部署；测试环境可访问 | 1. 输入 labels=['DONE', 'ACCEPTED']<br>2. 调用 map() 方法 | should_resolved = true（多标签共存场景） | P0 | unit |
| statmapper.009 | [TASK1 #77-01](https://github.com/agentic-develop-playground/backlog/issues/77) | StatusMapper 组件已部署；测试环境可访问 | 1. 输入 labels=[]<br>2. 调用 map() 方法 | should_resolved = false（空标签边界） | P1 | unit |

### 二、LabelSyncer 幂等性与错误处理验证

| 用例 ID | 对应 task(issueID) 链接 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 类型 |
| --- | --- | --- | --- | --- | --- | --- |
| labelsyncer.001 | [TASK2 #77-02](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；GitHub API 可访问；测试仓库已存在 | 1. 创建一个 issue 无 resolved 标签<br>2. 调用 sync(should=true, has=false)<br>3. 检查 issue 标签 | resolved 标签被成功添加；API 调用 1 次 | P0 | integration |
| labelsyncer.002 | [TASK2 #77-02](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；GitHub API 可访问；测试仓库已存在 | 1. 创建一个 issue 已有 resolved 标签<br>2. 调用 sync(should=true, has=true)<br>3. 检查 API 调用次数 | resolved 标签保持存在；无 API 调用（no-op） | P0 | integration |
| labelsyncer.003 | [TASK2 #77-02](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；GitHub API 可访问；测试仓库已存在 | 1. 创建一个 issue 已有 resolved 标签<br>2. 调用 sync(should=false, has=true)<br>3. 检查 issue 标签 | resolved 标签被成功移除；API 调用 1 次 | P0 | integration |
| labelsyncer.004 | [TASK2 #77-02](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；GitHub API 可访问；测试仓库已存在 | 1. 创建一个 issue 无 resolved 标签<br>2. 调用 sync(should=false, has=false)<br>3. 检查 API 调用次数 | 无 resolved 标签；无 API 调用（no-op） | P0 | integration |
| labelsyncer.005 | [TASK2 #77-02](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；GitHub API 可访问；测试仓库已存在 | 1. 创建一个 issue 无 resolved 标签<br>2. 连续调用 sync(should=true, has=false) 3 次<br>3. 检查 issue 标签和 API 调用次数 | resolved 标签仅添加 1 次；无重复 API 调用 | P0 | integration |
| labelsyncer.006 | [TASK2 #77-02](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；测试仓库不存在 resolved 标签定义；GitHub token 有创建标签权限 | 1. 模拟 GitHub API 返回 404（标签不存在）<br>2. 调用 sync(should=true, has=false)<br>3. 检查日志和最终标签状态 | 自动创建 resolved 标签并添加成功；日志记录创建过程 | P0 | integration |
| labelsyncer.007 | [TASK2 #77-02](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；GitHub API 可访问 | 1. 模拟 GitHub API 返回 403（权限不足）<br>2. 调用 sync(should=true, has=false)<br>3. 检查日志 | 不重试；错误进入死信日志；触发告警 | P0 | integration |
| labelsyncer.008 | [TASK2 #77-02](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；GitHub API 可访问 | 1. 模拟 GitHub API 返回 422（验证失败）<br>2. 调用 sync(should=true, has=false)<br>3. 检查日志 | 不重试；错误进入死信日志；触发告警 | P0 | integration |

### 三、EventRouter 事件过滤与路由验证

| 用例 ID | 对应 task(issueID) 链接 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 类型 |
| --- | --- | --- | --- | --- | --- | --- |
| eventrouter.001 | [TASK3 #77-03](https://github.com/agentic-develop-playground/backlog/issues/77) | EventRouter 组件已部署；webhook 端点可访问 | 1. 发送 POST /webhook<br>2. payload: {action: 'labeled', issue.labels:['VALIDATION'], repository.owner.login:'ascend', repository.name:'test-repo', issue.number:1}<br>3. 检查日志和 issue 标签 | 事件被处理；resolved 标签被添加 | P0 | integration |
| eventrouter.002 | [TASK3 #77-03](https://github.com/agentic-develop-playground/backlog/issues/77) | EventRouter 组件已部署；webhook 端点可访问 | 1. 发送 POST /webhook<br>2. payload: {action: 'labeled', issue.labels:['VALIDATION'], repository.owner.login:'cann', repository.name:'test-repo', issue.number:1}<br>3. 检查日志和 issue 标签 | 事件被处理；resolved 标签被添加 | P0 | integration |
| eventrouter.003 | [TASK3 #77-03](https://github.com/agentic-develop-playground/backlog/issues/77) | EventRouter 组件已部署；webhook 端点可访问 | 1. 发送 POST /webhook<br>2. payload: {action: 'labeled', issue.labels:['VALIDATION'], repository.owner.login:'other-org', repository.name:'test-repo', issue.number:1}<br>3. 检查日志 | 事件被丢弃；无后续处理 | P0 | integration |
| eventrouter.004 | [TASK3 #77-03](https://github.com/agentic-develop-playground/backlog/issues/77) | EventRouter 组件已部署；webhook 端点可访问 | 1. 发送 POST /webhook<br>2. payload: {action: 'unlabeled', issue.labels:['VALIDATION'], repository.owner.login:'ascend', repository.name:'test-repo', issue.number:1}<br>3. 检查日志和 issue 标签 | 事件被处理；resolved 标签被移除 | P0 | integration |
| eventrouter.005 | [TASK3 #77-03](https://github.com/agentic-develop-playground/backlog/issues/77) | EventRouter 组件已部署；webhook 端点可访问 | 1. 发送 POST /webhook<br>2. payload: {action: 'opened', issue.labels:[], repository.owner.login:'ascend', repository.name:'test-repo', issue.number:1}<br>3. 检查日志 | 事件被忽略；无后续处理 | P1 | integration |

### 四、组织白名单配置验证

| 用例 ID | 对应 task(issueID) 链接 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 类型 |
| --- | --- | --- | --- | --- | --- | --- |
| config.001 | [TASK4 #77-04](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage 已部署；ConfigMap 可访问 | 1. 检查 ConfigMap 中 org-allowlist 字段<br>2. 验证默认值 | 默认值为 'ascend,cann' | P0 | smoke |
| config.002 | [TASK4 #77-04](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage 已部署；ConfigMap 可修改 | 1. 修改 ConfigMap 中 org-allowlist 为 'ascend,cann,other'<br>2. 发送来自 'other' 组织的 webhook 事件<br>3. 检查事件是否被处理 | 配置实时生效；'other' 组织事件被处理 | P1 | integration |

### 五、端到端冒烟测试

| 用例 ID | 对应 task(issueID) 链接 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 类型 |
| --- | --- | --- | --- | --- | --- | --- |
| e2e.001 | [TASK5 #77-05](https://github.com/agentic-develop-playground/backlog/issues/77) | ascend 组织测试仓库存在；GitHub App 已安装；robot-issue-manage 已部署 | 1. 在 ascend 测试仓创建新 issue<br>2. 打上 VALIDATION 标签<br>3. 等待 5 秒后检查 issue 标签<br>4. 移除 VALIDATION 标签，打上 DONE 标签<br>5. 等待 5 秒后检查 issue 标签<br>6. 移除 DONE 标签，打上 WIP 标签<br>7. 等待 5 秒后检查 issue 标签 | 步骤3后 resolved 标签存在；步骤5后 resolved 标签存在；步骤7后 resolved 标签被移除 | P0 | e2e |
| e2e.002 | [TASK5 #77-05](https://github.com/agentic-develop-playground/backlog/issues/77) | cann 组织测试仓库存在；GitHub App 已安装；robot-issue-manage 已部署 | 1. 在 cann 测试仓创建新 issue<br>2. 打上 VALIDATION 标签<br>3. 等待 5 秒后检查 issue 标签<br>4. 移除 VALIDATION 标签，打上 DONE 标签<br>5. 等待 5 秒后检查 issue 标签<br>6. 移除 DONE 标签，打上 WIP 标签<br>7. 等待 5 秒后检查 issue 标签 | 步骤3后 resolved 标签存在；步骤5后 resolved 标签存在；步骤7后 resolved 标签被移除 | P0 | e2e |

### 六、可靠性与韧性验证

| 用例 ID | 对应 task(issueID) 链接 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 类型 |
| --- | --- | --- | --- | --- | --- | --- |
| reliability.001 | [TASK7 #77-07](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；可模拟 GitHub API 错误 | 1. Mock GitHub API 返回 500 Internal Server Error<br>2. 触发标签同步操作<br>3. 检查重试次数和间隔 | 执行最多 5 次重试；重试间隔符合指数退避策略（1s, 2s, 4s, 8s, 16s） | P0 | integration |
| reliability.002 | [TASK7 #77-07](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；可模拟 GitHub API 错误 | 1. Mock GitHub API 返回 429 Rate Limit<br>2. 触发标签同步操作<br>3. 检查重试次数和间隔 | 执行最多 5 次重试；重试间隔符合指数退避策略 | P0 | integration |
| reliability.003 | [TASK7 #77-07](https://github.com/agentic-develop-playground/backlog/issues/77) | LabelSyncer 组件已部署；可模拟 GitHub API 错误 | 1. Mock GitHub API 返回 502 Bad Gateway<br>2. 触发标签同步操作<br>3. 等待所有重试失败<br>4. 检查日志 | 达到最大重试次数后进入死信日志；日志包含完整错误信息和事件上下文 | P0 | integration |
| reliability.004 | [TASK7 #77-07](https://github.com/agentic-develop-playground/backlog/issues/77) | EventRouter 组件已部署；可重放 webhook 事件 | 1. 发送一次 issues.labeled 事件<br>2. 记录 issue 最终标签状态<br>3. 再次发送完全相同的事件<br>4. 再次检查 issue 标签状态 | issue 标签状态无变化；无重复 API 调用 | P0 | integration |
| reliability.005 | [TASK7 #77-07](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage 已部署；定时巡检作业已配置 | 1. 手动创建一个带有 VALIDATION 标签但缺少 resolved 标签的 issue<br>2. 手动触发定时巡检作业<br>3. 检查 issue 标签 | 巡检作业识别漂移；resolved 标签被补打 | P1 | integration |

### 七、可服务性与可观测性验证

| 用例 ID | 对应 task(issueID) 链接 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 类型 |
| --- | --- | --- | --- | --- | --- | --- |
| observability.001 | [TASK8 #77-08](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage 已部署；日志系统可访问 | 1. 触发一次标签同步 add 操作<br>2. 查询日志系统<br>3. 验证日志字段 | 日志包含 event_id、repo、issue_number、from_labels、to_labels、action=add 字段且值正确 | P0 | smoke |
| observability.002 | [TASK8 #77-08](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage 已部署；日志系统可访问 | 1. 触发一次标签同步 remove 操作<br>2. 查询日志系统<br>3. 验证日志字段 | 日志包含 event_id、repo、issue_number、from_labels、to_labels、action=remove 字段且值正确 | P0 | smoke |
| observability.003 | [TASK8 #77-08](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage 已部署；Prometheus 可访问 | 1. 触发 5 次 add 操作<br>2. 触发 3 次 remove 操作<br>3. 触发 1 次 noop 操作<br>4. 查询 Prometheus 指标 robot_issue_resolved_sync_total | 指标值：{action="add"}=5, {action="remove"}=3, {action="noop"}=1 | P0 | smoke |
| observability.004 | [TASK8 #77-08](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage 已部署；Prometheus 可访问；可模拟 GitHub API 错误 | 1. 触发 2 次 403 错误<br>2. 触发 1 次 422 错误<br>3. 查询 Prometheus 指标 robot_issue_resolved_sync_errors_total | 指标值：{kind="403"}=2, {kind="422"}=1 | P0 | smoke |
| observability.005 | [TASK8 #77-08](https://github.com/agentic-develop-playground/backlog/issues/77) | Grafana 已配置；Prometheus 数据源已连接 | 1. 访问 Grafana 「过去 24h resolved 同步速率 / 错误率」面板<br>2. 对比 Prometheus 原始数据与面板展示值 | 面板数据与 Prometheus 数据一致；图表可读性良好 | P1 | smoke |

### 八、排障文档验证

| 用例 ID | 对应 task(issueID) 链接 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 类型 |
| --- | --- | --- | --- | --- | --- | --- |
| runbook.001 | [TASK6 #77-06](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage/docs/runbook.md 已存在；测试环境可访问 | 1. 模拟 403 错误场景<br>2. 按照 runbook 执行排障步骤<br>3. 记录排障结果 | 排障步骤可执行；错误原因可定位；解决方案有效 | P1 | smoke |
| runbook.002 | [TASK6 #77-06](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage/docs/runbook.md 已存在；测试环境可访问 | 1. 模拟 422 错误场景<br>2. 按照 runbook 执行排障步骤<br>3. 记录排障结果 | 排障步骤可执行；错误原因可定位；解决方案有效 | P1 | smoke |
| runbook.003 | [TASK6 #77-06](https://github.com/agentic-develop-playground/backlog/issues/77) | robot-issue-manage/docs/runbook.md 已存在；测试环境可访问 | 1. 模拟 GitHub API 5xx 错误场景<br>2. 按照 runbook 执行排障步骤<br>3. 记录排障结果 | 排障步骤可执行；错误原因可定位；解决方案有效 | P1 | smoke |

---
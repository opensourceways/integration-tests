# om-dataarts 模块测试策略

## 更新记录

| PR | Issue | 合入时间 | 说明 |
|----|-------|----------|------|
| #456 | #450 | 2025-05-29 | 新增 Torch-NPU、openUBMC、Ascend IR 社区测试策略 |

---

## 1. 基本信息

- **需求链接**: https://github.com/agentic-develop-playground/backlog/issues/450
- **需求名称**: 开源实习数据看板新增 Torch-NPU、openUBMC、Ascend IR 社区的实习数据
- **核心目标**: 验证三个新社区的数据采集配置、数据库表创建、前端看板展示与下载功能，确保数据字段与已有社区完全一致，数据与 GitCode 原始 Issue 一致。
- **开发责任人**: 待分配
- **测试责任人**: 待分配

---

## 2. 测试维度确认

- [x] **功能自检测试**

> - **测试重点**：社区列表接口返回、数据采集配置解析、数据库表结构与写入、API 查询响应、前端展示与下载。
> - **目的**：确保三个新社区的数据从采集到展示全链路功能正确。
> - **勾选理由**：架构设计 §2.4 定义了明确的验收标准（社区列表接口、数据采集、前端展示、下载、一致性），需逐项验证。

- [ ] **体验测试**

> - **未勾选原因**：需求标签不含 `need_experience`，前端交互复用现有组件，无 UX 变更。

- [ ] **集成测试**

> - **未勾选原因**：需求标签不含 `need_itest`，本需求仅新增配置和数据库表，不涉及跨服务调用链路变更。

- [ ] **安全与隐私测试**

> - **未勾选原因**：需求分析 §5.A 已判定未触发 `need_security`，GitCode API Token 复用现有凭证，无新增密钥或权限调整。

- [ ] **可靠性与韧性测试**

> - **未勾选原因**：不涉及核心 Core 服务变更，数据采集为定时任务，失败不影响看板查询。

- [ ] **可服务性与可观测性测试**

> - **未勾选原因**：不涉及核心 Core 服务变更，无新增监控告警需求。

- [ ] **性能与伸缩性测试**

> - **未勾选原因**：不涉及核心 Core 服务变更，预估每社区数据量 < 1000 条，无需性能优化。

---

## 3. 专项验证设计和执行详情

### 3.1 功能测试专项

#### 3.1.1 社区列表接口验证（来源 PR #456 / Issue #450）

**测试目标**：验证 `GET /server/community/dict` 返回包含三个新社区。

- **对应 TASK**：TASK-1（数据采集配置）
- **前置条件**：APIMagic 服务正常运行，社区字典已更新
- **操作步骤**：
  1. 调用 `GET https://magicapi.osinfra.cn/server/community/dict`
  2. 解析响应 JSON
- **预期结果**：
  1. HTTP 状态码 200
  2. JSON data 数组包含 `{ "key": "Torch-NPU", "value": "torchnpu", "label": "Torch-NPU" }`
  3. JSON data 数组包含 `{ "key": "openUBMC", "value": "openubmc", "label": "openUBMC" }`
  4. JSON data 数组包含 `{ "key": "Ascend IR", "value": "ascendnpuir", "label": "Ascend IR" }`

#### 3.1.2 数据采集配置验证（来源 PR #456 / Issue #450）

**测试目标**：验证 `config.yaml` 新增三个社区配置项完整性。

- **对应 TASK**：TASK-1
- **前置条件**：配置文件已提交到 om-dataarts
- **操作步骤**：
  1. 读取 `om-dataarts/config.yaml` 中 `practice_collect` 章节
  2. 检查 `torchnpu`、`openubmc`、`ascendnpuir` 三个配置块
- **预期结果**：
  1. 每个配置块包含 `community`、`api`、`robot_user`、`intern_assign`、`success_assign`、`freed_assign`、`intern_completed`、`intern_done` 字段
  2. `api` 字段为有效 GitCode API URL（含 projects 路径）
  3. `robot_user` 数组非空
- **验证方式**：手动验证 / 配置文件静态检查（CI 环境外依赖）

#### 3.1.3 数据库表结构验证（来源 PR #456 / Issue #450）

**测试目标**：验证三张新增表结构与已有社区一致。

- **对应 TASK**：TASK-2
- **前置条件**：PostgreSQL 数据库可连接
- **操作步骤**：
  1. 执行 SQL `\d fact_torchnpu_practice`
  2. 执行 SQL `\d fact_openubmc_practice`
  3. 执行 SQL `\d fact_ascendnpuir_practice`
  4. 对比字段列表与 `fact_openeuler_practice` 结构
- **预期结果**：
  1. 三张表均有 14 个字段：uuid、title、html_url、tutor_login、tutor_email、score、sig_name、assign_user、assign_at、status、issue_state、pr_url、created_at、finished_at
  2. `uuid` 为 PRIMARY KEY（text 类型）
  3. `status` 为 varchar(16)，`issue_state` 为 varchar(16)
  4. 时间字段为 timestamptz(6)

#### 3.1.4 数据采集执行验证（来源 PR #456 / Issue #450）

**测试目标**：验证采集任务能成功写入三张表。

- **对应 TASK**：TASK-2
- **前置条件**：GitCode API 可访问，Token 有效
- **操作步骤**：
  1. 执行 `python3 -m om.tasks.practice_task_collect --config config.yaml --communities torchnpu,openubmc,ascendnpuir`
  2. 查询 `SELECT COUNT(*) FROM fact_torchnpu_practice`
  3. 查询 `SELECT COUNT(*) FROM fact_openubmc_practice`
  4. 查询 `SELECT COUNT(*) FROM fact_ascendnpuir_practice`
- **预期结果**：
  1. 命令执行成功，无异常退出
  2. 每张表 COUNT >= 1（至少有 1 条记录）
  3. 日志输出 `Page: N collected.` 进度信息
- **验证方式**：手动执行 / 集成测试环节（需 GitCode API Token 与生产环境网络）

#### 3.1.5 数据字段完整性验证（来源 PR #456 / Issue #450）

**测试目标**：验证采集数据字段完整性 100%。

- **对应 TASK**：TASK-2
- **前置条件**：数据已写入
- **操作步骤**：
  1. 执行 `SELECT * FROM fact_torchnpu_practice LIMIT 10`
  2. 检查每条记录的必填字段（uuid、title、html_url、status、issue_state）
- **预期结果**：
  1. 抽查 10 条记录，所有必填字段不为 NULL 或空字符串
  2. `uuid` 格式为 `gitcode-<owner>-<repo>-<issue号>`

#### 3.1.6 API 数据查询验证（来源 PR #456 / Issue #450）

**测试目标**：验证 `/server/detail/page` 能查询三个社区数据。

- **对应 TASK**：TASK-2、TASK-3
- **前置条件**：APIMagic 服务正常，数据已写入
- **操作步骤**：
  1. 调用 `POST https://magicapi.osinfra.cn/server/detail/page` body: `{"community":"torchnpu","page":1,"pageSize":10}`
  2. 调用同接口，body: `{"community":"openubmc","page":1,"pageSize":10}`
  3. 调用同接口，body: `{"community":"ascendnpuir","page":1,"pageSize":10}`
- **预期结果**：
  1. 三次请求均返回 HTTP 200
  2. 响应 JSON 包含 `{"list":[...],"total":N}` 结构
  3. list 数组元素包含所有 14 个字段

#### 3.1.7 空社区参数验证（来源 PR #456 / Issue #450）

**测试目标**：验证空社区参数返回参数校验失败。

- **对应 TASK**：TASK-2（异常场景）
- **前置条件**：APIMagic 服务正常
- **操作步骤**：
  1. 调用 `POST /server/detail/page` body: `{"community":"","page":1}`
- **预期结果**：
  1. HTTP 状态码 400 或 4xx
  2. 响应包含错误信息（参数校验失败）

#### 3.1.8 非法社区名验证（来源 PR #456 / Issue #450）

**测试目标**：验证非法社区名返回 SQL 执行失败。

- **对应 TASK**：TASK-2（异常场景）
- **前置条件**：APIMagic 服务正常
- **操作步骤**：
  1. 调用 `POST /server/detail/page` body: `{"community":"invalid","page":1}`
- **预期结果**：
  1. HTTP 状态码 500 或 4xx
  2. 响应包含错误信息（表不存在或 SQL 执行失败）

#### 3.1.9 前端看板社区切换验证（来源 PR #456 / Issue #450）

**测试目标**：验证看板能切换三个新社区。

- **对应 TASK**：TASK-3
- **前置条件**：前端服务部署完成
- **操作步骤**：
  1. 打开 `https://beta.datastat.osinfra.cn/customize-view?name=开源实习&community=opensource`
  2. 点击社区下拉列表，选择 Torch-NPU
  3. 检查 URL 参数与表格数据
  4. 依次切换 openUBMC、Ascend IR
- **预期结果**：
  1. 下拉列表包含 Torch-NPU、openUBMC、Ascend IR 选项
  2. 选择后 URL 参数更新为 `community=torchnpu`（对应值）
  3. 表格展示对应社区数据，字段包含标题、导师、认领学生、状态、创建时间等
- **验证方式**：手动测试 / E2E 测试（需前端环境与浏览器自动化工具）

#### 3.1.10 数据下载验证（来源 PR #456 / Issue #450）

**测试目标**：验证 CSV 下载包含完整字段。

- **对应 TASK**：TASK-3
- **前置条件**：看板页面已加载
- **操作步骤**：
  1. 在看板点击下载按钮
  2. 选择 Torch-NPU 社区
  3. 检查下载 CSV 文件
- **预期结果**：
  1. CSV 文件成功下载
  2. CSV 包含 uuid、title、html_url、tutor_login、status、created_at 等字段
  3. 字段数 >= 14，与已有社区下载文件一致
- **验证方式**：手动测试 / E2E 测试（需前端环境与浏览器自动化工具）

#### 3.1.11 数据一致性验证（来源 PR #456 / Issue #450）

**测试目标**：验证看板数据与 GitCode 原始 Issue 一致。

- **对应 TASK**：TASK-3
- **前置条件**：看板已展示数据
- **操作步骤**：
  1. 从看板随机抽取 Torch-NPU 社区 3 条任务
  2. 打开对应 GitCode Issue 页面
  3. 对比任务标题、导师账号、认领学生、状态字段
- **预期结果**：
  1. 任务标题 100% 一致
  2. 导师账号、认领学生 95% 以上一致
  3. 状态字段允许因评论解析时序差异存在轻微不一致（> 95%）
- **验证方式**：手动抽样验证 / 调用 GitCode API 比对（需 GitCode API Token）

#### 3.1.12 空数据场景验证（来源 PR #456 / Issue #450）

**测试目标**：验证新社区无任务时看板无报错。

- **对应 TASK**：TASK-3
- **前置条件**：某社区数据表为空（或使用测试社区）
- **操作步骤**：
  1. 切换到无任务的社区
  2. 检查表格展示与页面状态
- **预期结果**：
  1. 表格显示空列表，无报错
  2. 页面无 JavaScript 异常
  3. 可正常切换回其他社区
- **验证方式**：API 空数据响应验证（已自动化 TC-API-041）+ 前端空数据展示验证（手动/E2E）

#### 测试自检

- [x] **Task 闭环**：TASK-1、TASK-2、TASK-3 均有对应测试项
- [ ] **证据留存**：执行后需附带数据库查询截图、API 响应截图、CSV 文件样例（待执行）

---

## 4. 附录

### 4.1 用例索引

详细用例列表见 `test_cases.py` 文件末尾的用例索引表格。

### 4.2 测试数据

- GitCode API Token（环境变量 `GITCODE_TOKEN`）
- PostgreSQL 连接信息（环境变量 `DB_HOST`、`DB_PORT`、`DB_NAME`、`DB_USER`、`DB_PASSWORD`）
- APIMagic 服务地址（环境变量 `BASE_API`）

### 4.3 验证方式说明

| 验证方式 | 说明 |
|---------|------|
| API 自动化 | 通过 `test_cases.py` 执行 pytest 自动化 |
| 手动验证 | 需人工介入的验证项（前端交互、配置文件检查） |
| E2E 测试 | 需前端环境与浏览器自动化工具的验证项 |
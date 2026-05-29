# om-dataarts 模块测试策略

## 更新记录

| PR | Issue | 合入时间 | 说明 |
|----|-------|---------|------|
| #460 | #450 | - | 新增 Torch-NPU、openUBMC、Ascend IR 三个社区的实习数据采集与看板展示测试 |

---

## 1. 基本信息

- **模块名称**: om-dataarts（开源实习数据看板）
- **核心目标**: 验证开源实习数据看板的数据采集、存储、查询与展示功能，确保多社区数据一致性、完整性与可用性
- **开发责任人**: 待分配
- **测试责任人**: 待分配

---

## 2. 测试维度确认

> **操作指南**：请依据需求分析阶段的标签勾选。勾选后，必须在"第 3 节"提供对应的测试用例或方案。

- [x] **功能自检测试**

> - **测试重点**：社区列表接口返回、数据采集配置解析、数据库表结构与写入、API 查询响应、前端展示与下载。
> - **目的**：确保新社区的数据从采集到展示全链路功能正确。
> - **触发条件**：强制执行。

- [ ] **体验测试**

> - **未勾选原因**：前端交互复用现有组件，无 UX 变更。

- [ ] **集成测试**

> - **未勾选原因**：本模块仅新增配置和数据库表，不涉及跨服务调用链路变更。

- [ ] **安全与隐私测试**

> - **未勾选原因**：GitCode API Token 复用现有凭证，无新增密钥或权限调整。

- [ ] **可靠性与韧性测试**

> - **未勾选原因**：数据采集为定时任务，失败不影响看板查询。

- [ ] **可服务性与可观测性测试**

> - **未勾选原因**：无新增监控告警需求。

- [ ] **性能与伸缩性测试**

> - **未勾选原因**：预估每社区数据量 < 1000 条，无需性能优化。

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

#### 3.1.1 社区列表接口验证

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

#### 3.1.2 数据采集配置验证

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
- **验证方式**：手动验证 / 配置文件静态检查（CI 环境外依赖，仅手动验证）
- **自动化边界**：配置文件解析依赖生产环境 GitCode API Token 与网络，暂无法在 CI 环境自动化；后续可考虑配置项 Schema 校验（无网络依赖）

#### 3.1.3 数据库表结构验证

**测试目标**：验证三张新增表结构与已有社区一致。

- **对应 TASK**：TASK-2
- **前置条件**：PostgreSQL 数据库可连接
- **操作步骤**：
  1. 执行 SQL `\d fact_torchnpu_practice`
  2. 执行 SQL `\d fact_openubmc_practice`
  3. 执行 SQL `\d fact_ascendnpuir_practice`
  4. 对比字段列表与 `fact_openeuler_practice` 结构
- **预期结果**：
  1. 三张表均有 15 个字段：uuid、title、html_url、tutor_login、tutor_email、score、sig_name、assign_user、assign_at、status、issue_state、pr_url、created_at、finished_at、expect_complete_date
  2. `uuid` 为 PRIMARY KEY（text 类型）
  3. `status` 为 varchar(16)，`issue_state` 为 varchar(16)
  4. 时间字段为 timestamptz(6)

#### 3.1.4 数据采集执行验证

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
- **自动化边界**：数据采集脚本执行需生产环境 GitCode API 与网络连通，暂无法在 CI 环境自动化；集成测试阶段可补充自动化采集任务验证（需准备集成测试专用 Token 与网络）

#### 3.1.5 数据字段完整性验证

**测试目标**：验证采集数据字段完整性 100%。

- **对应 TASK**：TASK-2
- **前置条件**：数据已写入
- **操作步骤**：
  1. 执行 `SELECT * FROM fact_torchnpu_practice LIMIT 10`
  2. 检查每条记录的必填字段（uuid、title、html_url、status、issue_state）
- **预期结果**：
  1. 抽查 10 条记录，所有必填字段不为 NULL 或空字符串
  2. `uuid` 格式为 `gitcode-<owner>-<repo>-<issue号>`

#### 3.1.6 API 数据查询验证

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

#### 3.1.7 空社区参数验证

**测试目标**：验证空社区参数返回参数校验失败。

- **对应 TASK**：TASK-2（异常场景）
- **前置条件**：APIMagic 服务正常
- **操作步骤**：
  1. 调用 `POST /server/detail/page` body: `{"community":"","page":1}`
- **预期结果**：
  1. HTTP 状态码 400 或 4xx
  2. 响应包含错误信息（参数校验失败）
- **自动化覆盖**：TC-API-015（空字符串）、TC-API-017（缺失参数）、TC-API-018（null值）

#### 3.1.8 非法社区名验证

**测试目标**：验证非法社区名返回 SQL 执行失败。

- **对应 TASK**：TASK-2（异常场景）
- **前置条件**：APIMagic 服务正常
- **操作步骤**：
  1. 调用 `POST /server/detail/page` body: `{"community":"invalid","page":1}`
- **预期结果**：
  1. HTTP 状态码 500 或 4xx
  2. 响应包含错误信息（表不存在或 SQL 执行失败）
- **自动化覆盖**：TC-API-016（非法社区名）

#### 3.1.9 社区参数异常场景验证

**测试目标**：验证社区参数异常输入场景的安全性。

- **对应 TASK**：TASK-3（异常场景与安全性）
- **前置条件**：APIMagic 服务正常
- **操作步骤**：
  1. 社区名大小写测试：`{"community":"TORCHNPU","page":1}`
  2. 特殊字符测试：`{"community":"torchnpu; DROP TABLE fact_torchnpu_practice","page":1}`
  3. SQL 注入测试：`{"community":"torchnpu' OR '1'='1","page":1}`
- **预期结果**：
  1. 大小写场景返回正确数据或 4xx 错误
  2. 特殊字符场景返回 4xx 错误
  3. SQL 注入场景返回 4xx 错误且不执行恶意语句
- **自动化覆盖**：TC-API-029（大小写）、TC-API-030（特殊字符）、TC-API-031（SQL注入）

#### 3.1.10 参数类型错误验证

**测试目标**：验证分页参数类型错误时的异常处理。

- **对应 TASK**：TASK-3（异常场景）
- **前置条件**：APIMagic 服务正常
- **操作步骤**：
  1. page 参数类型错误：`{"community":"torchnpu","page":"abc","pageSize":10}`
  2. pageSize 参数类型错误：`{"community":"torchnpu","page":1,"pageSize":"ten"}`
  3. 空 JSON 请求体
  4. 非法 JSON 格式请求体
- **预期结果**：
  1. page 类型错误返回 4xx
  2. pageSize 类型错误返回 4xx
  3. 空请求体返回 4xx
  4. 非 JSON 格式返回 4xx
- **自动化覆盖**：TC-API-037（page类型）、TC-API-038（pageSize类型）、TC-API-039（空请求体）、TC-API-040（非法JSON）

#### 3.1.11 前端看板社区切换验证

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
- **自动化边界**：后端 API 层已通过 TC-API-012/013/014 覆盖社区数据查询；前端交互逻辑需 E2E 环境，暂不在 CI 自动化范围

#### 3.1.12 数据下载验证

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
- **自动化边界**：CSV 导出功能依赖前端文件流处理，需 E2E 环境；后端数据完整性已通过 TC-DB 系列验证

#### 3.1.13 数据一致性验证

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
- **自动化边界**：需生产环境 GitCode API Token，暂定为手动验证项；数据字段完整性已通过 TC-DB 系列验证

#### 3.1.14 空数据场景验证

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

### 3.2 体验测试专项

> **第二节未勾选应直接删除**

不适用。

---

### 3.3 集成测试专项

> **第二节未勾选应直接删除**

不适用。

---

### 3.4 安全与隐私测试专项

> **第二节未勾选应直接删除**

不适用。

---

### 3.5 可靠性与韧性专项

> **第二节未勾选应直接删除**

不适用。

---

### 3.6 可服务性与可观测性专项

> **第二节未勾选应直接删除**

不适用。

---

### 3.7 性能与可伸缩性专项

> **第二节未勾选应直接删除**

不适用。

---
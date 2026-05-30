# meeting-platform 测试策略设计说明书

## 更新记录

| PR 号 | Issue 列表 | 合入时间 | 备注 |
|-------|-----------|---------|------|
| [#174](https://github.com/agentic-develop-playground/backlog/pull/174) | 140 | 2026-05-24 | 会议官网列表接口增加历史会议人数显示 |
| [#502](https://github.com/agentic-develop-playground/backlog/pull/502) | 476 | 2026-05-30 | 会议页面显示，同一个开始时间的会议需要按照会议名称进行排序 |

---

## 1. 基本信息

- **模块名称**: meeting-platform
- **核心目标**:
  验证模块功能正确性，以及架构设计中定义的安全与隐私、可靠性与韧性、可服务性与可观测性和性能与伸缩性等非功能专项任务的闭环验收。

---

## 2. 测试维度确认

> **操作指南**：请依据需求分析阶段的标签勾选。勾选后，必须在"第 3 节"提供对应的测试用例或方案。

- [x] **功能自检测试**

> - **测试重点：** API 契约验证、业务逻辑分支覆盖、边界值测试。
> - **目的：** 确保功能实现符合设计预期。
> - **触发条件：** 强制执行,**可委托开发测试完成，测试完成验收**。
> - **合入 PR #174（Issue 140）新增**：新增统计接口与公开接口字段，需验证响应结构、数据正确性、边界情况。
> - **合入 PR #502（Issue 476）新增**：排序逻辑验证、边界值测试（相同 date/start 不同 topic、不同 date/start）、升降序模式验证，确保 topic 作为第三级排序条件正确生效。

- [ ] **体验测试**

> - **测试重点：** 站在用户角度进行体验使用，验证产品是否符合用户习惯。
> - **目的：** 满足用户需求，超出用户期望；判定产品是否能让用户快速的接受和使用。
> - **触发条件：** 需求标签含 `need_experience`

- [x] **集成测试**

> - **测试重点：** 跨服务调用链路验证、上下游数据最终一致性、数据库/中间件版本兼容性。
> - **目的：** 消除组件间级联影响风险。
> - **触发条件：** 需求标签含 `need_itest`
> - **合入 PR #174（Issue 140）新增**：meeting-center 调用 meeting-platform 统计接口，涉及跨服务调用与数据合并，需验证链路稳定性与异常处理。

- [ ] **安全与隐私测试**：

> - **测试重点：** 鉴权绕过测试、SQL/命令注入、敏感数据（PII）日志脱敏校验、SBOM 依赖漏洞扫描。
> - **目的：** 验证"纵深防御"机制是否生效，确保无隐私泄露。
> - **触发条件：** 需求标签含 `need_security`

- [ ] **可靠性与韧性测试**

> - **测试重点：** 故障注入（Chaos）。模拟网络丢包/延迟、进程意外溢出、磁盘 IO 满载后等异常情况下的系统自愈行为。
> - **目的：** 验证架构设计中的"面向失败设计"等能力。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含可靠性与韧性设计。

- [ ] **可服务性与可观测性测试**

> - **测试重点：** 告警有效性验证、指标准确性抽检、排障手册实操演练、优雅停机验证。
> - **目的：** 确保系统"可感知、可定位、可维护"。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含可服务性与可观测性设计。

- [x] **性能与伸缩性测试**

> - **测试重点：** 基准测试、负载测试。验证延迟、吞吐量上限及资源配额（CPU/Mem）稳定性。
> - **目的：** 确保不产生性能退化，满足 SLO 要求。
> - **触发条件：** 涉及核心Core服务变更,且架构设计含性能与伸缩性设计。
> - **合入 PR #174（Issue 140）新增**：架构文档明确性能验收标准（响应时间 < 1000ms，并发 50 QPS），需验证性能达标。

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

#### 3.1.1 meeting-platform 统计接口功能测试（PR #174 / Issue 140）

**1.正常值验证：统计接口返回正确数据**

- **对应task链接:** 架构文档 §meeting-platform 统计接口
- **前置条件**:
  1. 数据库中存在已结束会议（status = ENDED 或 OVERTIME，is_delete = false）
  2. 数据库中存在对应会议的参与人数数据（MeetingParticipants 表）
- **操作步骤**:
  1. 请求方式：GET
  2. URL：`http://meeting-platform-host/inner/v1/meeting/meeting/stats/participants/`
  3. Headers：Authorization: Basic `<内部服务认证>`
  4. 发送请求
- **预期结果**:
  1. HTTP 200
  2. body.code = 200
  3. body.data.total_meeting_participants ≥ 0（历史会议人数总和）
  4. body.data.ended_meeting_count ≥ 0（已结束会议总数）
  5. body.data.update_time 为 ISO 时间格式
- **优先级**: P0

**2.边界值验证：数据库无会议数据时返回零值**

- **对应task链接:** 架构文档 §验收标准 - 边界验证
- **前置条件**:
  1. 数据库中无会议数据（Meeting 表为空或全部 is_delete = true）
- **操作步骤**:
  1. GET `/inner/v1/meeting/meeting/stats/participants/`
  2. Headers：Authorization: Basic `<内部服务认证>`
- **预期结果**:
  1. HTTP 200
  2. body.data.total_meeting_participants = 0
  3. body.data.ended_meeting_count = 0
- **优先级**: P1

**3.权限验证：无 Basic Auth 时拒绝访问**

- **对应task链接:** 架构文档 §注意事项 - 安全性
- **前置条件**: 无
- **操作步骤**:
  1. GET `/inner/v1/meeting/meeting/stats/participants/`
  2. Headers：无 Authorization
- **预期结果**:
  1. HTTP 401 Unauthorized
  2. 或返回 403 Forbidden（取决于实现）
- **优先级**: P1

#### 3.1.2 meeting-center 公开接口功能测试（PR #174 / Issue 140）

**1.正常值验证：公开接口返回包含 meeting_stats 字段**

- **对应task链接:** 架构文档 §meeting-center 改动接口
- **前置条件**:
  1. meeting-platform 统计接口正常运行
  2. 数据库中存在 Activity 数据
- **操作步骤**:
  1. GET `/api/v1/meeting/public/activity/`
  2. 无需认证（公开接口）
- **预期结果**:
  1. HTTP 200
  2. body.code = 200
  3. body.data.results 为 Activity 列表（原有结构不变）
  4. body.data.meeting_stats.total_meeting_participants ≥ 0
  5. body.data.meeting_stats.ended_meeting_count ≥ 0
- **优先级**: P0

**2.异常处理：meeting-platform 接口异常时返回空统计**

- **对应task链接:** 架构文档 §验收标准 - 边界验证
- **前置条件**:
  1. meeting-platform 统计接口异常（超时/返回错误码）
- **操作步骤**:
  1. 模拟 meeting-platform 接口异常（可使用 mock 或关闭服务）
  2. GET `/api/v1/meeting/public/activity/`
- **预期结果**:
  1. HTTP 200
  2. body.data.results 正常返回（不影响原有 Activity 列表）
  3. body.data.meeting_stats = {} 或为空对象（不阻塞主流程）
- **优先级**: P1

**3.参数兼容性：原有查询参数功能不变**

- **对应task链接:** 架构文档 §验收标准 - 兼容性验收
- **前置条件**:
  1. 数据库中存在多种 Activity 数据
- **操作步骤**:
  1. GET `/api/v1/meeting/public/activity/?activity_mode=<value>&start_date=2026-05-20&search=测试`
  2. 验证参数筛选功能
- **预期结果**:
  1. HTTP 200
  2. Activity 列表按参数正确筛选
  3. meeting_stats 字段正常返回
- **优先级**: P1

#### 3.1.3 排序逻辑验证（PR #502 / Issue 476）

**对应task链接:** https://github.com/agentic-develop-playground/backlog/issues/476

**测试范围：** `meeting_platform/apps/meeting/application/meeting.py:693` 排序逻辑改动

**测试类型：** 单元测试风格验证（使用本地 mock 数据验证排序算法逻辑，不调用真实后端 API）

> **说明：** TC-API-SORT-001 至 TC-API-SORT-010 采用 Python `sorted()` 函数在本地对 mock 数据进行排序验证，目的是快速验证 `date > start > topic` 排序优先级逻辑的正确性。此方式不依赖后端服务部署，可在 CI 环境独立运行。后端实际排序逻辑由开发人员在 `meeting_platform/apps/meeting/application/meeting.py` 中实现的 Django QuerySet 排序，应由单元测试覆盖（见 §3.1.4）。

**测试用例设计：**

| 用例ID | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|----------|----------|----------|----------|--------|
| TC-API-SORT-001 | [正常流] 相同date/start按topic升序排列 | 创建3个会议：date/start相同，topic分别为"Gamma"、"Alpha"、"Beta" | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=asc | 返回列表中3个会议按 topic 字母序排列：Alpha → Beta → Gamma | P0 |
| TC-API-SORT-002 | [边界值] date优先级最高 | 创建会议：date分别为2026-05-30、2026-05-29，topic相同 | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=asc | date=2026-05-29 的会议排在 date=2026-05-30 之前（date优先级最高） | P0 |
| TC-API-SORT-003 | [边界值] start优先级高于topic | 创建会议：date相同，start分别为09:00、08:00，topic按逆序设置 | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=asc | start=08:00 的会议排在 start=09:00 之前（start优先级高于topic） | P0 |
| TC-API-SORT-004 | [正常流] 降序模式topic仍升序 | 创建会议：date/start相同，topic分别为"C会议"、"A会议"、"B会议" | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=desc | date降序排列；相同date的会议按start降序；相同date/start的会议按topic升序 | P0 |
| TC-API-SORT-005 | [边界值] topic包含中英文混合 | 创建会议：date/start相同，topic分别为"Z会议"、"A会议"、"会议B" | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=asc | 按 MySQL 默认字符集排序规则排列（验证中英文混合场景稳定性） | P1 |
| TC-API-SORT-006 | [边界值] topic包含特殊字符 | 创建会议：date/start相同，topic分别为"_会议"、"会议"、"会议" | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=asc | 按字符编码顺序排列（验证特殊字符场景稳定性） | P1 |
| TC-API-SORT-007 | [边界值] topic全相同 | 创建会议：date/start/topic完全相同 | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=asc | 返回结果不报错，顺序按数据库默认（如id） | P2 |
| TC-API-SORT-008 | [正常流] order_by=start时topic作为第二级 | 创建会议：date不同、start相同、topic不同 | 调用 GET /inner/v1/meeting/meeting/list/?order_by=start&order_type=asc | start作为主排序，topic作为第二级排序 | P1 |
| TC-API-SORT-009 | [空值] topic为空字符串 | 创建会议：date/start相同，topic为空字符串"" | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=asc | 空字符串topic排在最前（验证空值排序稳定性） | P2 |
| TC-API-SORT-010 | [正常流] 默认order_by参数 | 创建会议：不传order_by参数 | 调用 GET /inner/v1/meeting/meeting/list/ | 默认按date排序，topic作为第三级排序 | P1 |

**预期结果：** 
1. 所有测试用例返回 HTTP 200，响应结构包含 `{total, list, page, size}`。
2. 排序逻辑符合验收标准：
   - 验收条件1：相同 start 时按 topic 字母序升序
   - 验收条件2：date > start > topic 优先级正确
   - 验收条件3：order_type=desc 时 topic 仍升序
   - 验收条件4：原有参数功能不变

#### 3.1.4 单元测试验证（PR #502 / Issue 476）

**对应task链接:** https://github.com/agentic-develop-playground/backlog/issues/476

**测试文件位置：** `meeting_platform/test/meeting/test_meeting_app.py`

**测试类型：** 后端 Django 单元测试（由开发人员编写，验证实际 Django QuerySet 排序逻辑）

**测试步骤：**
1. 在 meeting-platform 项目根目录执行：`pytest meeting_platform/test/meeting/test_meeting_app.py -v`
2. 确认以下测试用例执行通过：
   - `test_merged_meeting_list_sort_by_topic_same_start`：验证相同 start 时按 topic 升序
   - `test_merged_meeting_list_sort_priority`：验证 date > start > topic 优先级
   - `test_merged_meeting_list_sort_with_desc`：验证降序模式下 topic 仍升序

**验证方法：**
- 单元测试应覆盖 `meeting_platform/apps/meeting/application/meeting.py:693` 的 QuerySet 排序逻辑
- 使用 Django TestCase 创建模拟会议数据，调用 `merged_meeting_list` 方法，断言返回结果顺序符合预期
- 测试数据需包含：相同 date/start 不同 topic、不同 date、不同 start 等边界场景

**预期结果：** 
1. `test_merged_meeting_list_sort_by_topic_same_start` 通过
2. `test_merged_meeting_list_sort_priority` 通过
3. `test_merged_meeting_list_sort_with_desc` 通过
4. 单元测试覆盖率 ≥ 原有水平

> **说明：** 本章节描述的单元测试由开发人员在代码提交前编写并执行。测试设计阶段仅定义验证目标，具体实现由开发人员负责。

#### 3.1.5 接口兼容性验证（PR #502 / Issue 476）

**对应task链接:** https://github.com/agentic-develop-playground/backlog/issues/476

**测试范围：** 验证原有接口参数功能不变

**测试用例设计：**

| 用例ID | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|--------|----------|----------|----------|----------|--------|
| TC-API-COMPAT-001 | [正常流] order_by=date&order_type=asc | 创建多个会议 | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=asc | 返回结构包含 `{total, list, page, size}`，list中包含topic字段 | P0 |
| TC-API-COMPAT-002 | [正常流] order_by=date&order_type=desc | 创建多个会议 | 调用 GET /inner/v1/meeting/meeting/list/?order_by=date&order_type=desc | 返回结构正确，date降序排列 | P0 |
| TC-API-COMPAT-003 | [正常流] 分页参数 | 创建多个会议 | 调用 GET /inner/v1/meeting/meeting/list/?page=1&size=10 | 返回结构正确，分页参数生效 | P1 |
| TC-API-COMPAT-004 | [边界值] order_by=start接口验证 | 创建多个会议 | 调用 GET /inner/v1/meeting/meeting/list/?order_by=start&order_type=asc | 返回结构正确，start升序，同start组内topic升序 | P1 |

**预期结果：** 接口返回结构不变，原有参数功能正常。

### 3.2 体验测试专项

> 参考测试设计方向
>
> - 无效引导：是否有空数据界面设计，引导用户去执行操作；是否滥用用户引导；是否有不可点击的效果。
> - 页面易用性：菜单层次是否太深；网站页面是否过长，内容过多，引起浏览者视觉疲劳；一次是否载入太多的数据；交互流程分支是否太多。
> - 设计易用性：标签页是否跟内容没有从属关系，当切换标签的时候，内容跟着切换；操作应该有主次从属关系；导航是否友好，不知如何返回上一页，不知当前页面在哪个栏目下；过于复杂的验证码，不清晰的验证码。
> - 页面性能：页面加载，下载时间是否过长，是否在合理的加载范围内；页面是否有过多新窗口，大量占用计算机资源。
> - 页面信息：是否有死链接或者链接错误；是否有页面安全信息；过于复杂的验证码，不清晰的验证码。

暂无体验测试需求。

### 3.3 集成测试专项

> 参考测试设计方向
>
> - 协议兼容性：验证不同版本的组件间（如旧版网关与新版后端）通过 gRPC/HTTP 通信的兼容性。
> - 分布式事务/最终一致性：验证跨数据库操作或跨服务调用时，在网络波动下的数据对齐情况。
> - 全链路追踪覆盖：确保 TraceID 在所有微服务节点间透传，无断链现象。

#### 3.3.1 跨服务调用链路验证（PR #174 / Issue 140）

**1.跨服务调用链路验证：meeting-center 正确调用 meeting-platform 统计接口**

- **对应task链接:** 架构文档 §数据流
- **前置条件**:
  1. meeting-platform 与 meeting-center 正常运行
  2. 数据库中有会议数据
- **操作步骤**:
  1. 触发 GET `/api/v1/meeting/public/activity/`
  2. 监控 meeting-platform 统计接口调用日志
  3. 验证 meeting-center 是否正确合并数据
- **预期结果**:
  1. meeting-platform 接口被正确调用
  2. 返回的统计数据被正确合并到顶层 meeting_stats 字段
  3. Activity 列表数据不变
- **优先级**: P0

**2.异常链路验证：meeting-platform 接口超时时不阻塞主流程**

- **对应task链接:** 架构文档 §验收标准 - 非法参数验证
- **前置条件**:
  1. meeting-platform 统计接口响应超时（> timeout 阈值）
- **操作步骤**:
  1. 模拟 meeting-platform 接口超时（延迟 > 10s）
  2. GET `/api/v1/meeting/public/activity/`
- **预期结果**:
  1. meeting-center 不崩溃，正常返回 Activity 列表
  2. meeting_stats 字段为空对象或默认值
  3. 响应时间在可接受范围内（不无限等待）
- **优先级**: P1

### 3.4 安全与隐私测试专项

> 参考测试设计方向
>
> - 最小特权原则 (PoLP)：验证服务账户（Service Account）是否无法越权操作未授权的资源。
> - 软件供应链审计：通过 SBOM 检查，验证容器镜像中是否存在已知的高危 CVE 漏洞。
> - 敏感信息外泄防护：检查日志、监控指标及 API 报错中是否夹带了明文密钥或隐私数据。

暂无安全与隐私测试需求。

### 3.5 可靠性与韧性专项

> 参考测试设计方向
>
> - 优雅降级与熔断：验证当外部依赖响应极慢时，系统是否能快速切换到"断路"状态以保护自身。
> - 自愈能力 (Chaos Engineering)：验证 Pod 被随机 Kill 或节点网络分区后，流量是否能自动漂移并恢复。
> - 幂等性验证：验证同一请求重试多次后，系统状态和数据是否保持唯一，无重复记录。

暂无可靠性与韧性测试需求。

### 3.6 可服务性与可观测性专项

> 参考测试设计方向
>
> - 告警闭环验证：验证从指标触发阈值到告警推送（通知到人）的全流程时效性。
> - 资源优雅退出：验证服务在重启过程中，是否能确保存量请求处理完后再断开连接。
> - 排障手册 (Runbook) 校验：验证运维人员能否仅凭监控图表和文档快速定位根因。

暂无可服务性与可观测性测试需求。

### 3.7 性能与可伸缩性专项

> 参考测试设计方向
>
> - 吞吐量与时延基准：验证在额定并发下，P99 延迟是否满足服务水平协议（SLA）。
> - 自动扩缩容效率：验证 HPA（水平扩容）从触发阈值到新副本就绪的响应时间。
> - 期稳定性 (Soak Test)：验证在持续负载下，是否存在内存缓慢泄漏或连接数不释放的问题。

#### 3.7.1 性能验收测试（PR #174 / Issue 140）

**1.基准性能测试：单次接口调用响应时间 < 1000ms**

- **对应task链接:** 架构文档 §验收标准 - 性能验收
- **前置条件**:
  1. 数据库中有一定量会议数据（>100 条）
- **操作步骤**:
  1. GET `/api/v1/meeting/public/activity/`
  2. 记录响应时间（重复 10 次）
  3. 计算 P99 响应时间
- **预期结果**:
  1. P99 响应时间 < 1000ms
  2. meeting-platform 统计接口响应时间 < 200ms
- **优先级**: P0

**2.负载测试：并发 50 QPS 时响应时间 < 1200ms**

- **对应task链接:** 架构文档 §验收标准 - 性能验收
- **前置条件**:
  1. 数据库中有大量会议数据（>10000 条）
- **操作步骤**:
  1. 使用压测工具模拟 50 QPS 并发请求
  2. 持续 5 分钟
  3. 监控响应时间与错误率
- **预期结果**:
  1. 平均响应时间 < 1200ms
  2. 错误率 < 0.1%
  3. 服务无崩溃
- **优先级**: P1

**3.大数据量性能测试：数据库 >10000 条会议时性能稳定**

- **对应task链接:** 架构文档 §验收标准 - 边界验证
- **前置条件**:
  1. 数据库中有 >10000 条已结束会议数据
- **操作步骤**:
  1. GET `/inner/v1/meeting/meeting/stats/participants/`
  2. 记录响应时间
- **预期结果**:
  1. HTTP 200
  2. 响应时间 < 1000ms
  3. 数据聚合查询使用索引，未全表扫描
- **优先级**: P1

---
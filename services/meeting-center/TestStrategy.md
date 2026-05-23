# meeting-center 模块测试策略设计说明书

## 更新记录

| PR 号 | issue 列表 | 合入时间 | 说明 |
|-------|------------|----------|------|
| [#133](https://github.com/agentic-develop-playground/backlog/pull/133) | 5 | 2026-05-23 | 会议参会者列表 API 测试策略 |
| [#167](https://github.com/agentic-develop-playground/backlog/pull/167) | 5 | 2026-05-23 | 会议参会者列表 API 测试策略（合并 issue #5 交付件） |

---

## 1. 基本信息

- **需求链接**: 
  - #5: https://github.com/agentic-develop-playground/backlog/issues/5
- **需求名称**: 
  - #5: 会议参会者列表 API
- **核心目标**:
  - #5: 验证会议参会者列表查询接口功能正确性，确保权限分层、敏感信息脱敏、分页功能等设计要点按预期实现，保障官网展示参会人员信息的安全性与用户体验。
- **开发责任人**: [TODO]
- **测试责任人**: [TODO]

---

## 2. 测试维度确认

> **操作指南**：请依据需求分析阶段的标签勾选。勾选后，必须在"第 3 节"提供对应的测试用例或方案。

- [x] **功能自检测试**

> - **测试重点**：API 契约验证、业务逻辑分支覆盖、边界值测试。
> - **目的**：确保功能实现符合设计预期。
> - **触发条件**：强制执行，**可委托开发测试完成，测试完成验收**。
> - **勾选理由**（#5）：新增 API 接口，需验证接口契约、权限校验、脱敏逻辑、分页功能等核心业务逻辑。

- [ ] **体验测试**

> - **测试重点**：站在用户角度进行体验使用，验证产品是否符合用户习惯。
> - **目的**：满足用户需求，超出用户期望；判定产品是否能让用户快速的接受和使用。
> - **触发条件**：需求标签含 `need_experience`
> - **未勾选理由**（#5）：后端 API 接口，无直接用户交互界面，体验测试由前端集成时验证。

- [x] **集成测试**

> - **测试重点**：跨服务调用链路验证、上下游数据最终一致性、数据库/中间件版本兼容性。
> - **目的**：消除组件间级联影响风险。
> - **触发条件**：需求标签含 `need_itest`
> - **勾选理由**（#5）：涉及跨服务调用链路（meeting-center → meeting-platform → OneID），需验证服务间接口契约、数据流转正确性。

- [x] **安全与隐私测试**

> - **测试重点**：鉴权绕过测试、SQL/命令注入、敏感数据（PII）日志脱敏校验、SBOM 依赖漏洞扫描。
> - **目的**：验证"纵深防御"机制是否生效，确保无隐私泄露。
> - **触发条件**：需求标签含 `need_security`
> - **勾选理由**（#5）：涉及敏感信息脱敏（邮箱、手机号）、动态认证、权限分层，需验证安全机制有效性。

- [ ] **可靠性与韧性测试**

> - **测试重点**：故障注入（Chaos）。模拟网络丢包/延迟、进程意外溢出、磁盘 IO 满载后等异常情况下的系统自愈行为。
> - **目的**：验证架构设计中的"面向失败设计"等能力。
> - **触发条件**：涉及核心 Core 服务变更，且架构设计含可靠性与韧性设计。
> - **未勾选理由**（#5）：新增查询接口，架构设计中未涉及可靠性韧性专项设计（如熔断、降级）。

- [ ] **可服务性与可观测性测试**

> - **测试重点**：告警有效性验证、指标准确性抽检、排障手册实操演练、优雅停机验证。
> - **目的**：确保系统"可感知、可定位、可维护"。
> - **触发条件**：涉及核心 Core 服务变更，且架构设计含可服务性与可观测性设计。
> - **未勾选理由**（#5）：架构设计中未涉及可服务性可观测性专项设计（如告警、监控指标）。

- [ ] **性能与伸缩性测试**

> - **测试重点**：基准测试、负载测试。验证延迟、吞吐量上限及资源配额（CPU/Mem）稳定性。
> - **目的**：确保不产生性能退化，满足 SLO 要求。
> - **触发条件**：涉及核心 Core 服务变更，且架构设计含性能与伸缩性设计。
> - **未勾选理由**（#5）：架构设计中仅提及性能考虑（批量查询优化、分页限制），未明确 SLO 要求，暂不纳入专项性能测试。

---

## 3. 专项验证设计和执行详情

> 测试自检
>
> - [ ] **Task 闭环**：架构设计说明书中定义的 **TASK** 是否均有对应的测试结果？
> - [ ] **证据留存**：关键测试（如性能、安全扫描）是否附带了截图或报告链接？

### 3.1 功能测试专项

> 参考测试设计方向
>
> - API 语义验证：验证 HTTP 状态码（2xx, 4xx, 5xx）的使用是否符合 RESTful 规范。
> - 边界与非法输入：验证大数据量、空字段、特殊字符及非法 JSON 格式的拦截能力。
> - 业务状态机闭环：验证资源从"创建中"到"运行中"再到"已释放"的全生命周期逻辑。

#### 3.1.1 公开会议参会者查询（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: GET /meeting/1/participants/（会议 ID=1 为公开会议）
- **预期结果**:
  1. 返回 HTTP 200
  2. `data.participants` 包含参会者列表
  3. `email` 字段格式为 `前3位***@域名`（如 `use***@example.com`）
  4. `phone` 字段格式为 `前3位****后4位`（如 `138****8001`）
  5. 无需认证即可访问（无 Authorization Header）

#### 3.1.2 私有会议发起人查询（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: GET /meeting/2/participants/（会议 ID=2 为私有会议，发起人已认证）
- **预期结果**:
  1. Header 包含有效 OneID token
  2. 返回 HTTP 200
  3. 参会者列表正常返回，数据结构正确
  4. 脱敏逻辑生效

#### 3.1.3 分页功能（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: GET /meeting/1/participants/?page=2&size=10
- **预期结果**:
  1. 返回 HTTP 200
  2. `data.page=2, data.size=10`
  3. `data.participants` 包含 10 条记录
  4. `data.total` 正确反映参会者总数

#### 3.1.4 会议不存在（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: GET /meeting/99999/participants/
- **预期结果**:
  1. 返回 HTTP 404
  2. `message="会议不存在或已删除"`

#### 3.1.5 已删除会议（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: GET /meeting/6/participants/（会议已标记 `is_delete=true`）
- **预期结果**:
  1. 返回 HTTP 404
  2. `message="会议不存在或已删除"`

#### 3.1.6 私有会议无权限访问（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: GET /meeting/5/participants/（私有会议，当前用户非发起人/非组成员/非管理员）
- **预期结果**:
  1. 返回 HTTP 403
  2. `message="当前会议参会者信息暂不对外公开"`

#### 3.1.7 分页边界值（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景 A**: GET /meeting/1/participants/?page=1&size=100
- **预期结果 A**: 返回 HTTP 200，最多返回 100 条记录
- **测试场景 B**: GET /meeting/1/participants/?page=1&size=101
- **预期结果 B**: 返回 HTTP 400（size 超限）

#### 3.1.8 非法分页参数（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: 多种非法参数组合
  - GET /meeting/1/participants/?page=0 → 返回 400
  - GET /meeting/1/participants/?page=-1 → 返回 400
  - GET /meeting/1/participants/?size=0 → 返回 400
  - GET /meeting/1/participants/?size=-5 → 返回 400
  - GET /meeting/1/participants/?page=abc → 返回 400
  - GET /meeting/1/participants/?size=xyz → 返回 400
- **预期结果**: 所有非法参数场景统一返回 HTTP 400

### 3.2 体验测试专项

> **第二节未勾选应直接删除**

（暂无体验测试专项）

### 3.3 集成测试专项

> 参考测试设计方向
>
> - 协议兼容性：验证不同版本的组件间（如旧版网关与新版后端）通过 gRPC/HTTP 通信的兼容性。
> - 分布式事务/最终一致性：验证跨数据库操作或跨服务调用时，在网络波动下的数据对齐情况。
> - 全链路追踪覆盖：确保 TraceID 在所有微服务节点间透传，无断链现象。

#### 3.3.1 跨服务调用链路验证（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: 验证 meeting-center → meeting-platform → OneID 调用链路
- **预期结果**:
  1. MeetingAdapterImpl.get() 正确调用 meeting-platform 获取会议详情
  2. MeetingAdapterImpl.get_participants() 正确调用 meeting-platform 获取参会者列表
  3. OneIDAdapterImpl.batch_query() 正确调用 OneID 批量查询用户详情
  4. 各接口返回数据格式符合契约定义

#### 3.3.2 依赖服务异常处理（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: 模拟 meeting-platform 或 OneID 服务不可用
- **预期结果**:
  1. meeting-platform 返回 500/超时时，meeting-center 返回适当错误响应
  2. OneID batch_query 失败时，参会者详情缺失字段合理处理
  3. 错误信息不暴露下游服务内部细节

#### 3.3.3 数据流转一致性（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: 验证参会者 username 列表与 OneID 用户详情的数据一致性
- **预期结果**:
  1. meeting-platform 返回的 username 列表与 OneID 批量查询的用户信息一一对应
  2. 缺失用户详情时，返回结构中相应字段为空或有默认值

### 3.4 安全与隐私测试专项

> 参考测试设计方向
>
> - 最小特权原则（PoLP）：验证服务账户（Service Account）是否无法越权操作未授权的资源。
> - 软件供应链审计：通过 SBOM 检查，验证容器镜像中是否存在已知的高危 CVE 漏洞。
> - 敏感信息外泄防护：检查日志、监控指标及 API 报错中是否夹带了明文密钥或隐私数据。

#### 3.4.1 权限分层验证（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: 验证公开会议与私有会议的权限分层
- **预期结果**:
  1. 公开会议：无 Authorization Header 可正常访问
  2. 私有会议：无 Authorization Header 返回 401
  3. 私有会议：非发起人/非组成员/非管理员 token 返回 403
  4. 私有会议：发起人 token 返回 200
  5. 私有会议：SIG组成员 token 返回 200
  6. 私有会议：管理员 token 返回 200

#### 3.4.2 动态认证机制验证（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: 验证 DynamicParticipantsAuthentication 根据会议 is_private 属性动态决定认证要求
- **预期结果**:
  1. 公开会议请求不触发认证校验
  2. 私有会议请求触发 CommunityAuthentication (OneID)
  3. Token 过期/无效返回 401
  4. Token 格式错误返回 401

#### 3.4.3 敏感信息脱敏验证（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: 验证邮箱和手机号脱敏逻辑
- **预期结果**:
  1. 邮箱脱敏格式：`前3位 + *** + @域名`（如 `user@example.com` → `use***@example.com`）
  2. 手机号脱敏格式：`前3位 + **** + 后4位`（如 `13800138000` → `138****8000`）
  3. 短邮箱（<3位）、短手机号（<7位）合理处理
  4. 无效邮箱/手机号格式不脱敏或返回空值
  5. API 返回、日志、监控均不暴露明文邮箱/手机号

#### 3.4.4 权限越权测试（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: 验证横向/纵向越权防护
- **预期结果**:
  1. 横向越权：用户 A 的 token 无法访问用户 B 创建的私有会议参会者列表
  2. 纵向越权：普通用户 token 无法通过修改 URL 参数访问管理员权限会议
  3. 跨租户：不同 SIG 组成员无法访问其他 SIG 组的私有会议

#### 3.4.5 输入注入防护（#5）

- **对应 task(issueID) 链接**: https://github.com/agentic-develop-playground/backlog/issues/5
- **测试场景**: 验证 SQL 注入、XSS 等攻击防护
- **预期结果**:
  1. URL path 参数注入 SQL 关键字（如 `/meeting/1' OR '1'='1/participants/`）返回 400 或安全错误
  2. Query 参数注入特殊字符（如 `?page=<script>alert(1)</script>`）返回 400
  3. 注入攻击不影响数据库稳定性
  4. 错误响应不暴露数据库结构信息

### 3.5 可靠性与韧性专项

> **第二节未勾选应直接删除**

（暂无可靠性与韧性专项）

### 3.6 可服务性与可观测性专项

> **第二节未勾选应直接删除**

（暂无可服务性与可观测性专项）

### 3.7 性能与可伸缩性专项

> **第二节未勾选应直接删除**

（暂无性能与可伸缩性专项）

---

## 4. 测试用例索引

| 用例 ID | 标题 | 关联 task | 优先级 | 类型 | 来源 PR |
|---------|------|-----------|--------|------|---------|
| TC-API-MEETING-PUBLIC-001 | [正常流] 公开会议无认证可访问 | #5 验收标准 1 | P0 | interface | #133 |
| TC-API-MEETING-PUBLIC-002 | [正常流] 公开会议参会者数据结构正确 | #5 验收标准 1 | P0 | interface | #133 |
| TC-API-MEETING-PUBLIC-003 | [安全] 公开会议参会者邮箱脱敏生效 | #5 验收标准 1 | P1 | interface | #133 |
| TC-API-MEETING-PUBLIC-004 | [安全] 公开会议参会者手机号脱敏生效 | #5 验收标准 1 | P1 | interface | #133 |
| TC-API-MEETING-PRIVATE-001 | [正常流] 私有会议发起人认证后可访问 | #5 验收标准 2 | P0 | interface | #133 |
| TC-API-MEETING-PRIVATE-002 | [权限] 私有会议 SIG 组成员认证后可访问 | #5 验收标准 2 | P1 | interface | #133 |
| TC-API-MEETING-PRIVATE-003 | [权限] 私有会议管理员认证后可访问 | #5 验收标准 2 | P1 | interface | #133 |
| TC-API-MEETING-PRIVATE-004 | [权限] 私有会议无认证访问返回 401 | #5 验收标准 6 | P0 | interface | #133 |
| TC-API-MEETING-PRIVATE-005 | [权限] 私有会议无权限用户访问返回 403 | #5 验收标准 6 | P0 | interface | #133 |
| TC-API-MEETING-PRIVATE-006 | [权限] 私有会议 Token 过期返回 401 | #5 醇收标准 6 | P1 | interface | #133 |
| TC-API-MEETING-PAGINATION-001 | [正常流] 默认分页参数返回正确数据 | #5 验收标准 3 | P0 | interface | #133 |
| TC-API-MEETING-PAGINATION-002 | [正常流] 自定义分页参数返回正确数据 | #5 验收标准 3 | P0 | interface | #133 |
| TC-API-MEETING-PAGINATION-003 | [边界值] 分页 size=100 返回最多 100 条 | #5 验收标准 7 | P1 | interface | #133 |
| TC-API-MEETING-PAGINATION-004 | [边界值] 分页 size=101 返回 400 | #5 验收标准 7 | P1 | interface | #133 |
| TC-API-MEETING-PAGINATION-005 | [异常输入] 分页 page=0 返回 400 | #5 验收标准 8 | P1 | interface | #133 |
| TC-API-MEETING-PAGINATION-006 | [异常输入] 分页 page=-1 返回 400 | #5 验收标准 8 | P1 | interface | #133 |
| TC-API-MEETING-PAGINATION-007 | [异常输入] 分页 size=0 返回 400 | #5 验收标准 8 | P1 | interface | #133 |
| TC-API-MEETING-PAGINATION-008 | [异常输入] 分页 size=-5 返回 400 | #5 验收标准 8 | P1 | interface | #133 |
| TC-API-MEETING-PAGINATION-009 | [异常输入] 分页 page=abc 返回 400 | #5 验收标准 8 | P1 | interface | #133 |
| TC-API-MEETING-PAGINATION-010 | [异常输入] 分页 size=xyz 返回 400 | #5 验收标准 8 | P1 | interface | #133 |
| TC-API-MEETING-NOTFOUND-001 | [异常] 会议不存在返回 404 | #5 验收标准 4 | P0 | interface | #133 |
| TC-API-MEETING-NOTFOUND-002 | [异常] 已删除会议返回 404 | #5 验收标准 5 | P0 | interface | #133 |
| TC-API-MEETING-INTEGRATION-001 | [集成] 跨服务调用链路正常 | #5 设计要点 | P1 | integration | #133 |
| TC-API-MEETING-INTEGRATION-002 | [集成] meeting-platform 异常时正确处理 | #5 设计要点 | P1 | integration | #133 |
| TC-API-MEETING-INTEGRATION-003 | [集成] OneID 批量查询失败时正确处理 | #5 设计要点 | P1 | integration | #133 |
| TC-API-MEETING-SECURITY-001 | [安全] 动态认证机制生效 | #5 安全设计 | P1 | interface | #133 |
| TC-API-MEETING-SECURITY-002 | [安全] 横向越权防护生效 | #5 安全设计 | P1 | interface | #133 |
| TC-API-MEETING-SECURITY-003 | [安全] 纵向越权防护生效 | #5 安全设计 | P2 | interface | #133 |
| TC-API-MEETING-SECURITY-004 | [安全] SQL 注入防护生效 | #5 安全设计 | P2 | interface | #133 |
| TC-API-MEETING-SECURITY-005 | [安全] XSS 注入防护生效 | #5 安全设计 | P2 | interface | #133 |
| TC-API-MEETING-MASK-001 | [安全] 短邮箱脱敏处理正确 | #5 脱敏逻辑 | P2 | interface | #133 |
| TC-API-MEETING-MASK-002 | [安全] 短手机号脱敏处理正确 | #5 脱敏逻辑 | P2 | interface | #133 |
| TC-API-MEETING-MASK-003 | [安全] 无效邮箱格式不脱敏 | #5 脱敏逻辑 | P2 | interface | #133 |
| TC-API-MEETING-MASK-004 | [安全] 无效手机号格式不脱敏 | #5 脱敏逻辑 | P2 | interface | #133 |

---

## 5. 覆盖矩阵

| 功能点 \ 维度 | 1 正常流 | 2 异常 | 3 边界值 | 4 空值 | 5 特殊字符 | 6 权限 | 7 唯一性 | 8 重复 | 9 异常输入 | 备注 |
|---|---|---|---|---|---|---|---|---|---|---|
| 公开会议查询 | ✓ | — | — | — | — | ✓ | N/A | N/A | — | 空值/特殊字符/异常输入不适用查询接口 |
| 私有会议查询 | ✓ | ✓ | — | — | — | ✓ | N/A | N/A | — | 空值/特殊字符/异常输入不适用查询接口 |
| 分页功能 | ✓ | ✓ | ✓ | ✓ | ✓ | N/A | N/A | N/A | ✓ | 唯一性/重复不适用分页参数 |
| 权限校验 | ✓ | ✓ | — | — | — | ✓ | N/A | N/A | — | 空值/特殊字符/异常输入在分页测试覆盖 |
| 脱敏逻辑 | ✓ | ✓ | ✓ | ✓ | ✓ | N/A | N/A | N/A | ✓ | 空值覆盖无效格式场景 |
| 会议不存在 | — | ✓ | — | — | — | — | N/A | N/A | — | 正常流不适用不存在场景 |
| 跨服务调用 | ✓ | ✓ | — | — | — | — | N/A | N/A | — | 集成测试专项覆盖 |
| 注入防护 | — | — | — | — | ✓ | — | N/A | N/A | ✓ | 安全测试专项覆盖 |

---

## 6. 测试工具与环境

- **测试工具**: pytest + requests
- **测试环境**: 预览环境 / 本地开发环境
- **依赖服务**: meeting-platform、OneID 服务需正常运行
- **配置检查**（#5）:
  - `settings.MEETING_PLATFORM.URL` 正确配置
  - `settings.ONEID_PLATFORM` 正确配置
  - 权限平台管理员角色配置正确

---

## 7. 执行计划

1. **单元测试**（#5）: `python manage.py test meeting_center.apps.meeting.tests.test_participants --verbosity=2`
2. **接口测试**: 执行 pytest 自动化脚本，覆盖功能自检测试用例
3. **集成测试**: 在预览环境验证跨服务调用链路
4. **安全测试**: 验证权限分层、脱敏逻辑、注入防护
5. **回归测试**: 验证部署后功能稳定性
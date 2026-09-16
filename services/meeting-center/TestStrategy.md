# meeting-center 测试策略设计说明书

## 更新记录

| Issue | 备注 |
|-------|------|
| #736 | 会议系统支持自动发送纪要到邮件列表 — meeting-center 门户层集成测试 |

---

## 1. 基本信息

- **模块名称**: meeting-center
- **核心目标**:
  验证 meeting-center 门户层 API 的可用性、meeting-center → meeting-platform 代理链路的正确性，以及异常处理健壮性。

---

## 2. 测试维度确认

- [x] **功能自检测试**
  - 测试重点：API 契约验证（响应 code=200 + data 结构）。
  - 覆盖端点：`/ping/`、`/api/v1/meeting/meeting_date/`、`/api/v1/meeting/meeting/`、`/api/v1/meeting/group_name/`、`/api/v1/meeting/platform/`、`/api/v1/meeting/roles/`。

- [x] **集成测试**
  - 测试重点：meeting-center 代理 meeting-platform 的数据链路验证。
  - 验证：会议列表响应含 platform 的核心字段（community/topic/date/start/end）；日期列表与会议列表日期一致（同源代理）。
  - 触发条件：需求标签含 `need_itest`。

- [ ] **体验测试**（后续按需补充）
- [ ] **安全与隐私测试**（后续按需补充）

---

## 3. 认证模型

- meeting-center 使用 **OneID 会话认证**（Cookie/Token），非 BasicAuth。
- 测试通过环境变量 `AUTH_TOKEN` 注入 OneID Cookie/Token。
- `/ping/` 为公开端点，无需认证。

---

## 4. 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `MEETING_CENTER_HOST` | meeting-center 服务地址 | `http://meeting-center.test.osinfra.cn` |
| `COMMUNITY` | 测试社区名 | `openEuler` |
| `AUTH_TOKEN` | OneID 登录 Cookie/Token | （CI 注入） |

---

## 5. 用例清单

| ID | 级别 | 用例名 | 端点 | 验证点 |
|----|------|--------|------|--------|
| 1 | P0 | test_ping | `GET /ping/` | 200 |
| 2 | P0 | test_meeting_date_list | `GET /api/v1/meeting/meeting_date/?community=X` | 200 + 日期列表 |
| 3 | P0 | test_meeting_list | `GET /api/v1/meeting/meeting/?community=X` | 200 + 会议列表 |
| 4 | P0 | test_group_name_list | `GET /api/v1/meeting/group_name/?community=X` | 200 + 组名列表 |
| 5 | P0 | test_platform_list | `GET /api/v1/meeting/platform/?community=X` | 200 + 类型列表 |
| 6 | P0 | test_roles_list | `GET /api/v1/meeting/roles/?community=X` | 200 + 角色列表 |
| 7 | P1 | test_meeting_list_has_platform_fields | `GET /api/v1/meeting/meeting/?community=X` | 响应含 platform 核心字段 |
| 8 | P1 | test_meeting_date_matches_meeting_list | 两次 GET | 日期列表 ∩ 会议列表日期 |
| 9 | P2 | test_invalid_community_returns_graceful | `GET /api/v1/meeting/meeting/?community=INVALID` | 不 500 |
| 10 | P2 | test_nonexistent_meeting_returns_graceful | `GET /api/v1/meeting/99999999/` | 400/404 |

---

## 6. 后续补充

- 活动管理端点（`/api/v1/activity/`）的集成测试。
- 写操作（POST 预定/PUT 修改/DELETE 删除）的测试（需 OneID 认证 + 测试数据管理）。
- 会议纪要端点（`/api/v1/meeting/minutes/<id>/`）的代理验证。

# oss-map 模块测试策略

## 更新记录

| PR | Issue | 合入时间 | 说明 |
|----|-------|---------|------|
| — | — | 2026-08-07 | 首版：范式 A 只读冒烟（health / projects / search / 鉴权负向） |

---

## 1. 基本信息

- **模块名称**: oss-map（OSS 全景地图）
- **核心目标**: 验证测试环境 REST 只读主路径可用，且未鉴权写/敏感读被正确拒绝
- **被测环境**: `https://oss-map.test.osinfra.cn`（ArgoCD 测试环境，非 preview）
- **用例脚本**: `services/oss-map/test_cases.py`
- **安全原则**: 不创建、不修改、不删除业务数据；不触发采集

---

## 2. 测试维度确认

- [x] **功能自检测试** — 健康检查、项目列表/详情/搜索、元数据选项、全局搜索、组织列表
- [x] **安全与隐私测试（轻量）** — `/me` 无 Token、错误登录、受保护导出接口无 Token → 401
- [ ] **体验测试** — 首版不做 UI（Playwright）；后续可加
- [ ] **性能与伸缩性测试** — 首版不做
- [ ] **可靠性与韧性测试** — 首版不做

---

## 3. 专项验证

### 3.1 功能（只读）

| 用例意图 | 方法 | 路径 | 预期 |
|----------|------|------|------|
| 健康检查 | GET | `/api/v1/health` | 200，`status=ok` |
| 前端入口 | GET | `/` | 200，HTML |
| 项目分页列表 | GET | `/api/v1/projects` | 200，含 `items/total/page/page_size` |
| 项目搜索 | GET | `/api/v1/projects?q=` | 200，结构合法 |
| 项目详情 | GET | `/api/v1/projects/{id}` | 200，含 `id/name` |
| 不存在项目 | GET | `/api/v1/projects/999999999` | 404 |
| 分类/协议选项 | GET | `/api/v1/projects/category-options` 等 | 200，非空数组 |
| 全局搜索 | GET | `/api/v1/search?q=vllm` | 200，含 projects/people/organizations |
| 组织列表 | GET | `/api/v1/orgs` | 200，元素含 `id/name` |
| 幂等连打 | GET | health / projects | 两次结果形态一致 |

### 3.2 鉴权负向（不改数据）

| 用例意图 | 方法 | 路径 | 预期 |
|----------|------|------|------|
| 未登录查自己 | GET | `/api/v1/me` | 401 |
| 错误账号密码 | POST | `/api/v1/login` | 401 |
| 未登录导出 | GET | `/api/v1/projects/export` | 401 |

### 3.3 可选正向登录（需环境变量）

设置 `OSS_MAP_TEST_ACCOUNT` + `OSS_MAP_TEST_PASSWORD` 后：`POST /login` 拿 JWT，再 `GET /me` 校验用户名。未设置则 skip，不阻断流水线。

---

## 4. 与流水线的关系

- 用例落在 `opensourceways/integration-tests`，由 backlog `issue-3-release.yml`（`/ai-deploy-test`）经 `run_integration_tests.py` 探测 `services/oss-map/test_cases.py` 执行。
- Preview（`/ai-develop-preview`）不跑本套件；本套件默认打 **test** 域名。

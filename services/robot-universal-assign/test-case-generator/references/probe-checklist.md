# 探测脚本骨架（Step 1 平台 API 探测）

Robot 类用例生成前必须执行的探测清单。所有命令以 gitcode 为例；其他平台按 [platform-api-cheatsheet.md](platform-api-cheatsheet.md) 替换 base URL 与鉴权头。

执行约定：
- `${TOKEN}` 由用户提供（用例中固化为 `{{TOKEN}}` 占位符）
- `${OWNER}`、`${REPO}` 来自用户提供的仓库 URL（如 `openeuler-test` / `test-feature`）
- `${BOT}`：探测后填入实际 bot 账号（如 `openeuler-ci-bot`）
- `${TARGET}`：若用例涉及指定目标用户，填入对应 login（如 `xiaoguozhi34`）

## P1 — 仓库可达性与 members 列表

```bash
curl -s -H "PRIVATE-TOKEN: ${TOKEN}" \
  "https://api.gitcode.com/api/v5/repos/${OWNER}/${REPO}" \
  | python -m json.tool | head -60
```

关注：HTTP 状态、`members[]`、`default_branch`、`open_issues_count`、`creator.login`。

## P2 — Token 持有者身份

```bash
curl -s -H "PRIVATE-TOKEN: ${TOKEN}" \
  "https://api.gitcode.com/api/v5/user"
```

关注：`login`、`name`、`type`。后续判断该用户是否在 P1 的 members 中。

## P3 — 目标用户存在性与是否 member

```bash
curl -s -H "PRIVATE-TOKEN: ${TOKEN}" \
  "https://api.gitcode.com/api/v5/users/${TARGET}"
```

关注：HTTP 200 + 用户存在；与 P1 的 members 比较，判断是否 member。
**典型应用**：用户存在但非 member → 适合写 `[权限][反向] /assign 指定非协作者` 用例。

## P4 — Issue 列表 + issue_type 字典

```bash
curl -s -H "PRIVATE-TOKEN: ${TOKEN}" \
  "https://api.gitcode.com/api/v5/repos/${OWNER}/${REPO}/issues?state=all&per_page=5" \
  | python -c "import sys,json; d=json.load(sys.stdin); print('count:', len(d)); [print('type:', i.get('issue_type'), 'assignee:', (i.get('assignee') or {}).get('login')) for i in d]"
```

关注：仓库实际支持的 `issue_type` 取值（gitcode 上常见「任务」「CVE和安全问题」，缺陷/需求未必默认启用）；当前 issue 的 assignee 现状。

## P5 — Bot 实际响应（核心探测）

创建一个不带 assignee 的轻量 Issue → 等 10–15s → 查 assignee + 评论：

```bash
# 5a. 创建
curl -s -X POST \
  -H "PRIVATE-TOKEN: ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"repo\":\"${REPO}\",\"title\":\"[Probe] Bot reaction baseline\",\"body\":\"探测用例\"}" \
  "https://api.gitcode.com/api/v5/repos/${OWNER}/${REPO}/issues" \
  -w "\nHTTP=%{http_code}\n"

# 5b. 等待 + 抓 number
sleep 15
NUMBER=<上一步返回的 number>

# 5c. 查 assignee
curl -s -H "PRIVATE-TOKEN: ${TOKEN}" \
  "https://api.gitcode.com/api/v5/repos/${OWNER}/${REPO}/issues/${NUMBER}" \
  | python -c "import sys,json; d=json.load(sys.stdin); print('assignee:', (d.get('assignee') or {}).get('login'))"

# 5d. 查评论 + bot 账号
curl -s -H "PRIVATE-TOKEN: ${TOKEN}" \
  "https://api.gitcode.com/api/v5/repos/${OWNER}/${REPO}/issues/${NUMBER}/comments" \
  | python -c "import sys,json; d=json.load(sys.stdin); [print('---', c.get('user',{}).get('login'), '---', (c.get('body') or '')[:300]) for c in d]"
```

关键产物：
- **创建 Issue 真实 HTTP 状态码**（如 200 / 201）
- **default_assignee 实际值**
- **Bot 账号 login**（如 `openeuler-ci-bot`）
- **Bot 评论文案与语种**

## P6 — 组织级看板能力探测

```bash
curl -s -H "PRIVATE-TOKEN: ${TOKEN}" \
  "https://api.gitcode.com/api/v5/orgs/${OWNER}/dashboards" \
  -w "\nHTTP=%{http_code}\n"
```

- HTTP 200 + 数组 → 平台支持组织看板，可设计归集类用例
- HTTP 404 → 平台无此端点，**看板归集类用例不可生成**（标阻塞）

## P7 — issue_type 字典验证

```bash
# 用设计文档假设的中文「缺陷」试创建
curl -s -X POST \
  -H "PRIVATE-TOKEN: ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"repo\":\"${REPO}\",\"title\":\"[Probe] issue_type check\",\"issue_type\":\"缺陷\"}" \
  "https://api.gitcode.com/api/v5/repos/${OWNER}/${REPO}/issues" \
  -w "\nHTTP=%{http_code}\n"
```

- HTTP 200 → 平台/仓库支持该枚举值，可在用例中使用
- HTTP 400 + `error_message: 设置的issue_type不存在` → 不支持，相关用例需调整或阻塞

## P8 — repoConfig 当前生效配置（视可见性）

repoConfig 通常存于另一个治理仓库或 K8s ConfigMap，**不一定可通过 REST API 公开访问**：

- 若用户能提供 repoConfig 文件路径 / 片段 → 直接读取并固化到用例文档
- 若不可见 → 跳过，并在「需补充信息」记录

## 探测产物模板（写入用例文档）

完成 P1–P8 后，按以下表格固化结果（替换具体值后写入用例文档头部「平台实测事实」节）：

```markdown
| 序号 | 探测项 | 实测结果 |
|---|---|---|
| F1 | 平台 / 仓库 | gitcode / openeuler-test/test-feature |
| F2 | 鉴权头 | PRIVATE-TOKEN: {{TOKEN}} |
| F3 | Token 持有者 | weixin_55883847（member） |
| F4 | 仓库 members 数量 | 18（前 10：ibforu, georgecao, ...） |
| F5 | Bot 账号 | openeuler-ci-bot |
| F6 | default_assignee 实测 | Guangyue-Xu |
| F7 | Bot 文案语种 | 英文 |
| F8 | 创建 Issue HTTP 状态 | 200 |
| F9 | POST body 必填字段 | repo |
| F10 | issue_type 字典 | 任务（默认）、CVE和安全问题；缺陷/需求 → HTTP 400 不支持 |
| F11 | 组织看板 API | HTTP 404，不可用 |
| F12 | 目标用户 xiaoguozhi34 | 存在但非 member（适合权限反向用例） |
| F13 | repoConfig 可见性 | 不可见（已记入需补充信息） |
```

## 探测的"轻量化"原则

探测过程会在仓库新建 1–2 个 Issue。原则：
- 每个探测 Issue 都加 `[Probe]` 前缀，便于事后批量清理
- 用例文档生成完成后，提醒用户关闭探测 Issue（不要保留污染数据）
- 多人共用仓库时，先与维护人确认是否允许探测，避免影响他人测试

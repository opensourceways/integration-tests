# Robot Universal Associate - 项目完整文档

> 本文档参照 `opensourceways/robot-universal-review` 的 `docs/PROJECT_DOCUMENTATION.md`
> 风格，依据 `opensourceways/robot-universal-associate` 仓库源码（含 `.planning/codebase/`
> 架构分析）整理生成，用于 `agentic-develop-playground/integration-tests` 中编写该机器人
> 的集成测试用例时作为需求/行为参考。

## 1. 项目概览

### 1.1 项目简介

**Robot Universal Associate** 是面向开源社区的**关联检查机器人**，支持 Gitee / GitHub /
GitCode 三大代码托管平台（通过 `robot-framework-lib` 平台客户端抽象）。它监听 PR 事件与
PR 评论事件，自动检查 **PR 是否关联了合规的 Issue 或上游 PR**，并通过**打阻塞标签 + 发反馈
评论**的方式提示开发者。

核心能力：

1. **PR 关联 Issue 检查**（`enable_check_associate_issue`）
   - 检查 PR 是否关联了至少一个合规 Issue（可限定 Issue 状态、按 Issue 类型限定工作流状态）
   - 不合规：添加阻塞标签（如 `needs-issue`）并发反馈评论
   - 合规且已打标签：自动移除阻塞标签
   - 规则优先级：URL > Repo > Org（先命中者生效）

2. **PR 关联上游 PR 检查**（`enable_check_associate_pr`）
   - 检查 PR 是否关联了指定上游仓库（如文档仓）的 PR
   - 不合规：添加阻塞标签（如 `need-doc-pr`）并发反馈评论
   - 仅支持 Repo 级别规则

3. **评论命令**
   - 检查命令（如 `/check-issue`、`/check-doc`）：重新执行关联检查
   - 移除标签命令（如 `/remove-needs-issue`、`/remove-need-doc`）：移除阻塞标签，可选权限校验

### 1.2 技术栈

| 类别 | 选型 |
|------|------|
| 语言 | Go |
| 机器人框架 | `github.com/opensourceways/robot-framework-lib`（HTTP 服务、事件分发、平台客户端、ConfigMap 热加载） |
| 日志 | `github.com/sirupsen/logrus` |
| 集合工具 | `k8s.io/apimachinery`（`sets` 包做命令集合运算） |
| 测试 | `github.com/stretchr/testify`（`assert` / `mock`） |
| 平台 SDK（框架间接依赖） | go-gitee / go-gitcode / go-github-adapter |
| 配置 | YAML（`testdata/config.yaml` 为完整示例），命令行参数传入路径 |
| 容器基础镜像 | openeuler（见 `Dockerfile`） |

### 1.3 项目架构

**整体：事件驱动 + 策略模式。** 业务逻辑只实现「事件处理 + 关联规则匹配 + 标签/评论操作」，
HTTP 服务、Webhook 解析、平台 API、配置热加载由 `robot-framework-lib` 提供。

```text
┌──────────────────────────────────────────────────────────────┐
│                    robot-framework-lib                        │
│   HTTP Server / Event Router / ConfigMap Agent               │
└────────────────────────┬─────────────────────────────────────┘
                         │ GenericEvent
                         ▼
┌──────────────────────────────────────────────────────────────┐
│                      robot (robot.go)                         │
│   RegisterEventHandler → handlePREvent / handlePRCommentEvent│
└──────┬──────────────────────────┬────────────────────────────┘
       │                          │
       ▼                          ▼
┌─────────────────┐   ┌──────────────────────────┐
│ PRAssociateWith │   │   PRAssociateWithPR        │
│ Issue           │   │   (robot_helper.go)        │
└──────┬──────────┘   └──────────┬───────────────┘
       │                         │
       ▼                         ▼
┌──────────────────────────────────────────────────────────────┐
│                    iClient (robot.go)                         │
│   AddPRLabels / RemovePRLabels / GetPRLinkedIssue / GetIssue  │
│   CreatePRComment / CheckPermission / ListPullRequestComments │
└──────────────────────────────────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────────────────────────────┐
│              Git 平台 API（Gitee / GitHub / GitCode）         │
└──────────────────────────────────────────────────────────────┘
```

**关键特征：**
- `iClient` 接口隔离平台 API，便于测试 mock（定义 `robot.go:29-47`）
- 规则匹配优先级链：URL > Repo > Org（`checkRepoRule` → `checkOrgRule`，先命中者生效）
- 全局命令集合（`commandCheckIssueLabelList` 等）在 `Validate()` 构建，运行时只读
- 无持久化状态，全部实时查询平台 API
- 配置热加载（框架检测 ConfigMap 变更，调用 `NewConfig` / `GetConfigmap`）

### 1.4 目录结构

```
robot-universal-associate/
├── main.go              # 程序入口：解析参数 → 加载配置 → 创建 robot → 启动 HTTP 服务
├── option.go            # 启动参数封装，调用框架 ValidateComposite 完成配置加载与校验
├── robot.go             # robot 结构体、iClient 接口、PR/PR评论 事件入口
├── robot_helper.go      # 核心业务：PRAssociateWithIssue / PRAssociateWithPR / 标签移除
├── config.go            # 配置结构：configuration / repoConfig / PRAssociateWith*Rules
├── config_helper.go     # 规则匹配：checkRepoRule / checkOrgRule / 工作流状态校验
├── *_test.go            # 各模块单元测试（testify + mock iClient）
├── testdata/config.yaml # 完整配置示例
├── .planning/codebase/  # 架构分析文档（ARCHITECTURE/STRUCTURE/STACK/.../TESTING）
├── Dockerfile           # 容器镜像构建
├── go.mod / go.sum      # Go 模块（module: github.com/opensourceways/robot-universal-associate）
└── LICENSE              # Apache 2.0
```

整个项目为单一 `package main`，所有 `.go` 文件平铺在根目录。

---

## 2. 核心模块详解

### 2.1 程序入口模块 (main.go)

**位置**: `main.go:25`

**功能说明**: 解析命令行参数 → 加载配置 → 创建 robot → 启动 HTTP 服务。

**执行流程**:
1. 创建 logger
2. `robotOptions.gatherOptions` 解析参数，框架 `ValidateComposite` 加载并校验配置
3. 从 configmap 取 `*configuration`
4. `newRobot(cnf, token, logger)` 创建 robot
5. `framework.StartupServer(...)` 启动 HTTP 服务，开始接收 Webhook

### 2.2 机器人核心模块 (robot.go)

#### 2.2.1 iClient 接口

**位置**: `robot.go:29-47`

抽象所有平台操作，便于测试 mock。关键方法：

- **标签**: `AddPRLabels` / `RemovePRLabels` / `AddIssueLabels` / `RemoveIssueLabels` /
  `GetPullRequestLabels` / `GetIssueLabels`
- **Issue/PR 查询**: `GetIssue` / `GetPRLinkedIssue`
- **评论**: `CreatePRComment` / `CreateIssueComment` / `ListPullRequestComments` / `DeletePRComment`
- **权限**: `CheckPermission`
- **事件判定**: `CheckIfPRCreateEvent` / `CheckIfPRSelfUpdateEvent` /
  `CheckIfPRLinkIssueUpdateEvent` / `CheckIfIssueCreateEvent`

#### 2.2.2 robot 结构体与注册

**位置**: `robot.go:49-78`

```go
type robot struct {
    cli iClient
    cnf *configuration
    log *logrus.Entry
}

func (bot *robot) RegisterEventHandler(p framework.HandlerRegister) {
    p.RegisterPullRequestHandler(bot.handlePREvent)
    p.RegisterPullRequestCommentHandler(bot.handlePRCommentEvent)
}
```

同时实现 `NewConfig()` / `GetConfigmap()` 支持配置热加载（`robot.go:55-69`）。

#### 2.2.3 PR 事件处理器 `handlePREvent`

**位置**: `robot.go:80-119`

**功能说明**: PR 事件同时驱动 Issue 关联检查与上游 PR 关联检查。

**执行流程**:
1. `handlePRAssociateWithIssue`（`:86`）：
   - 未开启 `enable_check_associate_issue` → 返回
   - 仅在 PR 创建 / 自更新 / 关联 Issue 更新事件下处理；创建/自更新时 `time.Sleep(6s)` 等平台同步
   - 调 `PRAssociateWithIssue` 执行检查
2. `handlePRAssociateWithPR`（`:106`）：
   - 未开启 `enable_check_associate_pr` → 返回
   - 仅在 PR 创建事件下处理
   - 调 `PRAssociateWithPR` 执行检查

> ⚠️ `time.Sleep(6 * time.Second)`（`robot.go:97`）为硬编码同步等待，集成测试需把等待时间设得 ≥ 该值。

#### 2.2.4 PR 评论事件处理器 `handlePRCommentEvent`

**位置**: `robot.go:121-171`

**功能说明**: 解析 PR 评论命令，触发关联检查或移除标签。

**执行流程**:
1. `handlePRAssociateWithIssueComment`（`:127`）：
   - 评论命中 `commandCheckIssueLabelList`（如 `/check-issue`）→ 重新执行 `PRAssociateWithIssue`
   - 逐行匹配 `commandRemoveIssueLabelList`（如 `/remove-needs-issue`）→ `handleRemoveIssueLabel`
2. `handlePRAssociateWithPRComment`（`:150`）：
   - 命中 `commandCheckPRLabelList`（如 `/check-doc`）→ 重新执行 `PRAssociateWithPR`
   - 命中 `commandRemovePRLabelList`（如 `/remove-need-doc`）→ `handleRemovePRLabel`

### 2.3 业务逻辑模块 (robot_helper.go)

#### 2.3.1 PR 关联 Issue 检查 `PRAssociateWithIssue`

**位置**: `robot_helper.go:35-104`

**执行流程**:
1. 取 PR 当前标签
2. `GetPRLinkedIssue` 取 PR 关联的 Issue 列表；逐个 `GetIssue` 补全工作流状态（`IssueState`/`IssueType`）
3. `getPRLinkingIssueConfig` 匹配规则（Repo → Org），得到 `issueRuleHelper`
4. 规则未命中（`!enable`）→ 返回
5. 若由命令触发且命令不等于该规则的 check 命令 → 返回
6. **工作流状态不匹配**（命令触发 + 无合规 Issue + `commentWorkflowStateMismatch` 非空）→
   评论 `*_comment_state_mismatch_feedback`，返回
7. **无合规 Issue 且无标签**：添加阻塞标签 → 删除旧的「Linking Issue Notice」评论 →
   发反馈评论 `*_comment_label_block_feedback`（`@author`）
8. **有合规 Issue 且已有标签**：移除阻塞标签

#### 2.3.2 PR 关联上游 PR 检查 `PRAssociateWithPR`

**位置**: `robot_helper.go:193-232`

**执行流程**:
1. 取 PR 标签 → `checkRepoRule` 匹配规则（仅 Repo 级）
2. 规则未命中/未启用 → 返回；命令触发但命令不符 → 返回
3. **无标签**：添加阻塞标签 → 删除旧「Linking PR Notice」评论 → 发反馈评论 `repo_comment_label_block_feedback`

#### 2.3.3 移除标签 `handleRemove*Label` / `removeLabelByPermission`

**位置**: `robot_helper.go:106-191`

- 按命令选定要移除的标签、是否需要权限、无权限文案
- PR 当前无该标签 → 返回
- 需要权限（`*_remove_label_permission=true`）：`CheckPermission` 校验评论者是否仓库成员；
  非成员 → 评论 `*_comment_remove_label_no_permission`，不移除
- 通过 → `RemovePRLabels` 移除标签

### 2.4 配置模块 (config.go / config_helper.go)

#### 2.4.1 全局配置 `configuration`

**位置**: `config.go:25-32`

- `config_items`：仓库级规则列表（`repoConfig`）
- `sig_info_url`（必填）、`community_name`（必填）、`community_robot_id`
- `placeholder_linking_issue_notice_title`（必填）/ `placeholder_linking_pr_notice_title`（必填）：
  用于在重发反馈前**去重删除旧通知评论**的标题匹配串

`Validate()`（`config.go:42`）做必填与各 `repoConfig` 校验，并把各规则的 check / remove 命令
写入四个全局命令集合（`commandCheckIssueLabelList` 等）。

#### 2.4.2 仓库配置 `repoConfig`

**位置**: `config.go:68-81`

- `repos`（必填）、`excluded_repos`
- `enable_check_associate_issue` + `associate_issue_rules`（`PRAssociateWithIssueRules`）
- `enable_check_associate_pr` + `associate_pr_rules`（`PRAssociateWithPRRules`）
- `enable_check_associate_milestone`（里程碑检查开关）

启用 issue/pr 检查时对应 rule 必填，否则 `Validate` 报错。

#### 2.4.3 Issue 关联规则 `PRAssociateWithIssueRules`

**位置**: `config.go:116-147`。三级优先（URL > Repo > Org），每级字段对称：

| 字段（以 Org 级为例） | 说明 |
|------|------|
| `org` / `repo` / `url` | 合规 Issue 必须归属的组织/仓库/URL 列表 |
| `*_label` | 阻塞标签名（如 `needs-issue`） |
| `*_issue_state_limit` / `*_issue_limit_state` | 是否限定 Issue 状态、允许状态（如 `open`） |
| `*_issue_limit_workflow_state` | 按 `issue_type` 限定允许的工作流状态（逗号分隔多状态） |
| `*_comment_command_check_label` | 检查命令（如 `/check-issue`） |
| `*_comment_command_remove_label` | 移除标签命令（如 `/remove-needs-issue`） |
| `*_remove_label_permission` | 移除标签是否需仓库成员权限 |
| `*_comment_remove_label_no_permission` | 无权限提示文案 |
| `*_comment_label_block_feedback` | 阻塞反馈文案（`@%s` 为作者） |
| `*_comment_state_mismatch_feedback` | 工作流状态不符提示（`%s` 为允许状态） |

#### 2.4.4 PR 关联规则 `PRAssociateWithPRRules`

**位置**: `config.go:149-157`。仅 Repo 级：`repo` / `repo_label` / `repo_comment_command_check_label` /
`repo_comment_command_remove_label` / `repo_remove_label_permission` /
`repo_comment_remove_label_no_permission` / `repo_comment_label_block_feedback`。

#### 2.4.5 规则匹配 (config_helper.go)

- `getPRLinkingIssueConfig`（`robot_helper.go:27`）：`checkRepoRule` → `checkOrgRule`，先 enable 者生效
- `checkRepoRule`（`config_helper.go:42`）/ `checkOrgRule`（`:77`）：
  - 填充 `issueRuleHelper`（`enable` / `hasIssue` / `hasLabel` / `labelName` / 命令 / 反馈文案）
  - 遍历关联 Issue：先按 `*_issue_state_limit` 过滤状态；再按
    `matchIssueTypeWorkflowState` 校验工作流状态，命中类型但状态不允许 → 记 `commentWorkflowStateMismatch`
  - Issue 归属命中配置的 org/repo 列表 → `hasIssue=true`
- `matchIssueTypeWorkflowState`（`config_helper.go:13`）：按 `issue_type` 找规则，逗号拆分允许状态做匹配

---

## 3. 业务流程说明

### 3.1 PR 关联 Issue 检查流程

1. 框架接收 Webhook → `handlePREvent` → `handlePRAssociateWithIssue`
2. PR 创建/自更新等待 6s（平台数据同步）
3. 取标签 + 关联 Issue（含工作流状态）
4. 规则匹配（Repo→Org）
5. 判定：
   - 无合规 Issue 且无标签 → 加阻塞标签 + 发反馈（`@author`）
   - 工作流状态不符（命令触发）→ 发状态不符提示
   - 有合规 Issue 且有标签 → 移除阻塞标签

### 3.2 评论命令流程

1. `/check-issue`（或配置的 check 命令）→ 重新执行关联检查
2. `/remove-needs-issue`（或配置的 remove 命令）→ 按权限移除阻塞标签；无权限发提示

### 3.3 用户操作场景

- **场景 1（自动）**：开发者建 PR 但未关联 Issue → 机器人加 `needs-issue` 标签 + 评论提示关联
- **场景 2（补关联后复检）**：开发者关联 Issue 后评论 `/check-issue` → 机器人复检并移除 `needs-issue`
- **场景 3（状态不符）**：关联的需求 Issue 不在允许工作流状态（如非「已接纳/开发中」）→ 评论状态不符提示
- **场景 4（上游 PR）**：改动文档相关内容但未关联文档仓 PR → 加 `need-doc-pr` 标签 + 评论；
  确认无需关联可评论 `/remove-need-doc` 移除

---

## 4. 配置和环境

### 4.1 配置文件说明

配置文件使用 YAML（`testdata/config.yaml` 为完整参考）。

#### 4.1.1 配置示例（节选自 testdata/config.yaml）

```yaml
config_items:
  - repos:
      - openeuler-test
    enable_check_associate_issue: true
    associate_issue_rules:
      org: ["openeuler-test"]
      org_label: needs-issue
      org_issue_state_limit: true
      org_issue_limit_state: "open"
      org_issue_limit_workflow_state:
        - issue_type: 需求
          state: 已接纳,开发中,转测中,待验收
      org_comment_command_check_label: /check-issue
      org_comment_command_remove_label: /remove-needs-issue
      org_remove_label_permission: true
      org_comment_remove_label_no_permission: "### Notice \nOnly members of the repository can delete the **needs-issue** label. Please contact them to do it."
      org_comment_label_block_feedback: "### Linking Issue Notice \n @%s , the pull request must be linked to at least one issue. \nIf an issue has already been linked, but the **needs-issue** label remains, you can remove the label by commenting **`/check-issue`** ."
      org_comment_state_mismatch_feedback: "### Issue State Mismatch Notice \n The pull request is linked to issue(s) that are not in allowed states. ... Allowed issue states: %s."

  - repos:
      - opengauss/openGauss-server
    enable_check_associate_pr: true
    associate_pr_rules:
      repo: ["docs"]
      repo_label: need-doc-pr
      repo_comment_command_check_label: /check-doc
      repo_comment_command_remove_label: /remove-need-doc
      repo_remove_label_permission: false
      repo_comment_label_block_feedback: "### Linking PR Notice \n @%s , the pull request should be linked to at least one .../docs repository's PR. \nIf it is confirmed that no PR association is needed, you can remove the label by commenting **`/remove-need-doc`** ."
    enable_check_associate_issue: true
    associate_issue_rules:
      org: ["opengauss"]
      org_label: needs-issue
      org_comment_command_check_label: /check-issue
      org_comment_command_remove_label: /remove-needs-issue
      org_remove_label_permission: true

sig_info_url: "http://robot-universal-cache-service...:8888/robot-cache"
community_name: openeuler
community_robot_id: openeuler-ci-bot
placeholder_linking_issue_notice_title: "### Linking Issue Notice"
placeholder_linking_pr_notice_title: "### Linking PR Notice"
```

#### 4.1.2 命令一览

| 命令 | 作用 | 权限 |
|------|------|------|
| `/check-issue` | 复检 PR 是否关联合规 Issue | 任何人 |
| `/remove-needs-issue` | 移除 `needs-issue` 阻塞标签 | 视 `*_remove_label_permission` 而定（默认需仓库成员） |
| `/check-doc` | 复检 PR 是否关联上游（文档仓）PR | 任何人 |
| `/remove-need-doc` | 移除 `need-doc-pr` 阻塞标签 | 视 `repo_remove_label_permission` 而定 |

> 命令名均来自配置；不同社区/仓库可自定义。

### 4.2 环境与启动参数

| 项 | 说明 |
|----|------|
| 配置文件路径 | 命令行参数（框架 `FrameworkOptions`） |
| Token | 命令行参数或文件 |
| 配置格式 | YAML |

### 4.3 部署要求

- **运行时**：Go（见 `go.mod`）；Linux
- **容器**：基础镜像 openeuler（见 `Dockerfile`）
- **构建**：`go build` 产出单二进制（参考 `Dockerfile`）

---

## 5. 使用指南

### 5.1 本地开发

```bash
git clone https://github.com/opensourceways/robot-universal-associate.git
cd robot-universal-associate
go mod download
# 编辑 testdata/config.yaml，配置关联规则、阻塞标签、命令与反馈文案
go build -o robot-universal-associate .
./robot-universal-associate --config-file=testdata/config.yaml --token-path=<token>
```

配置 Webhook 指向服务端点，订阅 PR / PR 评论事件。

### 5.2 Docker 部署

```bash
docker build -t robot-universal-associate:latest .
docker run -d -p 8888:8888 \
  -v /path/to/config.yaml:/opt/app/config.yaml \
  -v /path/to/token:/opt/app/token \
  robot-universal-associate:latest
```

### 5.3 测试

```bash
go test ./...   # 全部单元测试（testify + mock iClient）
```

---

## 6. 集成测试参考要点

为 `integration-tests` 编写本机器人用例时，关注以下可观测行为（黑盒断言点）：

1. **未关联 Issue 加标签**：创建未关联 Issue 的 PR → 等待（≥6s 同步延迟）→ PR labels 出现阻塞标签
   （如 `needs-issue`），且有「Linking Issue Notice」反馈评论（含 `@作者`）
2. **关联后复检移除**：关联合规 Issue 后评论 `/check-issue` → 阻塞标签被移除
3. **工作流状态不符**：关联的需求 Issue 状态不在允许集合 → 评论「Issue State Mismatch Notice」，含允许状态
4. **上游 PR 检查**：命中 `associate_pr_rules` 的 PR 未关联上游 PR → 加 `need-doc-pr` + 「Linking PR Notice」
5. **移除标签权限**：`*_remove_label_permission=true` 时，非仓库成员评论移除命令 → 收到无权限提示、标签不变
6. **命令匹配**：仅当评论整行等于配置的 check/remove 命令时才触发（`/check-issue` 等）
7. **评论去重**：重复触发时旧的通知评论会被先删除再重发（依赖 `placeholder_*_notice_title`）

> 注：精确断言文案以目标仓库实际部署的 `config.yaml` 模板为准；标签/命令/规则均依赖该仓库配置，
> 编写实测用例前需对齐部署配置（参见本仓 `services/robot-server/base_community/test_cases.py`
> 中 review 机器人用例的 `REVIEW_ROBOT_ENABLED` 门禁与前置说明同样适用）。

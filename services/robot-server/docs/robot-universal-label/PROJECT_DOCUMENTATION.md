# Robot Universal Label - 项目完整文档

> 本文档参照 `opensourceways/robot-universal-review` 的 `docs/PROJECT_DOCUMENTATION.md`
> 风格，依据 `opensourceways/robot-universal-label` 仓库源码（含 `.planning/codebase/`
> 架构分析）整理生成，用于 `agentic-develop-playground/integration-tests` 中编写该机器人
> 的集成测试用例时作为需求/行为参考。

## 1. 项目概览

### 1.1 项目简介

**Robot Universal Label** 是面向开源社区的**通用标签机器人**，支持 Gitee / GitCode / GitHub
三大代码托管平台（通过 `robot-framework-lib` 的平台客户端抽象）。它监听 PR / Issue 的 Webhook
事件，按仓库配置的规则**自动或手动地为 PR / Issue 增删标签**，并可选开启基于 SIG 角色的
**代码审查（/lgtm /approve）能力**与审查报告生成。

核心能力分两大类：

1. **标签规则模式（始终启用）**
   - 自动标签：按提交数阈值、变更文件路径、PR 描述正则，自动为 PR 增删标签
   - 手动标签：评论命令触发，经多层权限校验后为 PR / Issue 增删标签
   - 通用命令：可配置关键字（如 `kind|priority|sig|good`）的 `/<kw> <value>` 与
     `/remove-<kw> <value>` 命令；以及 `/label add|remove <labels>`（适配 Ascend 社区）
   - 生命周期：PR 源码更新 / 关闭时按规则自动移除标签

2. **SIG 审查模式（`enable_lgtm_approve=true` 时启用）**
   - `/lgtm`、`/approve` 及其 `cancel` 命令，基于 SIG 角色与审查配置授予/移除 `lgtm`、`approved` 标签
   - PR 创建/更新生成审查报告评论；PR 源码更新/重开时清除既有 `lgtm`/`approved` 标签
   - 定时任务（cron）周期刷新组织/SIG 权限快照

### 1.2 技术栈

| 类别 | 选型 |
|------|------|
| 语言 | Go 1.25.10 |
| 机器人框架 | `github.com/opensourceways/robot-framework-lib v1.4.7`（HTTP 服务、事件分发、平台客户端） |
| 日志 | `github.com/sirupsen/logrus v1.9.4` |
| 集合工具 | `k8s.io/apimachinery`（`sets` 包做标签集合运算） |
| 测试 | `github.com/stretchr/testify v1.11.1`（`assert` / `mock`） |
| 平台 SDK（框架间接依赖） | go-gitee / go-gitcode / go-github-adapter |
| 配置 | YAML（`testdata/config.yaml` 为完整示例），通过命令行参数传入路径 |
| 容器基础镜像 | `openeuler/openeuler:24.03-lts-sp3` |

### 1.3 项目架构

**整体：单体事件驱动服务（Event-Driven Monolith）。** 业务逻辑只实现「事件处理 + 标签规则
匹配 + 权限校验」，HTTP 服务、Webhook 解析、平台 API 由 `robot-framework-lib` 提供。

```text
┌─────────────────────────────────────────────────────────────┐
│                   robot-framework-lib                        │
│          (HTTP Server / Event Router / Client SDK)           │
└──────────────────────────┬──────────────────────────────────┘
                           │ GenericEvent
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                      robot (robot.go)                        │
│  RegisterEventHandler → handlePullRequestEvent               │
│                       → handleIssueCommentEvent              │
│                       → handlePullRequestCommentEvent        │
└────────┬──────────────────┬──────────────────┬──────────────┘
         │                  │                  │
         ▼                  ▼                  ▼
┌──────────────┐  ┌──────────────────┐  ┌──────────────────┐
│ add_label.go │  │ remove_label.go  │  │ robot_helper.go  │
│ 自动/手动加  │  │ 自动/手动/关闭删 │  │ 命令解析/权限校验│
└──────┬───────┘  └────────┬─────────┘  └────────┬─────────┘
       │                   │                      │
       │   lgtm.go / approve.go / reviewstatus.go / siginfo.go
       │   （enable_lgtm_approve=true 时的 SIG 审查链）
       └───────────────────┴──────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    iClient (robot.go)                        │
│  AddPRLabels / RemovePRLabels / CreatePRComment              │
│  CheckPermission* / ListSigInfo / GetPullRequestChanges ...  │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              Git 平台 API（Gitee / GitCode / GitHub）        │
└─────────────────────────────────────────────────────────────┘
```

**关键特征：**
- 通过 `iClient` 接口隔离平台 API，便于测试 mock（定义见 `robot.go:31-67`）
- 配置经 configmap 热加载，无需重启
- 所有事件同步处理，无消息队列；SIG 审查模式下有一个后台 cron goroutine 刷新权限快照

### 1.4 目录结构

```
robot-universal-label/
├── main.go              # 程序入口：初始化配置/token/robot，启动 HTTP 服务，按需启动 cron
├── options.go           # 命令行参数解析与初始化（configmap、SigInfo URL、社区名）
├── config.go            # 配置结构体：configuration / repoConfig / LabelRule / ReviewConfig ...
├── robot.go             # robot 核心结构体、iClient 接口、三个事件处理入口、argList
├── robot_helper.go      # 评论命令解析、正则匹配、五层权限校验链
├── add_label.go         # 添加标签（自动按变更/描述、手动按命令；PR/Issue）
├── remove_label.go      # 删除标签（自动按变更/描述/关闭、手动按命令；PR/Issue）
├── lgtm.go              # /lgtm /lgtm cancel 命令处理（SIG 审查模式）
├── approve.go           # /approve /approve cancel 命令处理（SIG 审查模式）
├── reviewstatus.go      # 审查状态计算、审查报告生成、标签清理
├── siginfo.go           # SIG/组织信息加载、权限快照构建
├── actions_review.go    # 审查动作（lgtm/approve 授予逻辑、模块状态）
├── *_test.go            # 各模块单元测试（testify + mock iClient）
├── testdata/
│   ├── config.yaml      # 完整配置示例
│   └── token            # 测试用 token
├── .planning/codebase/  # 架构分析文档（ARCHITECTURE/STRUCTURE/STACK/...）
├── Dockerfile           # 多阶段构建（基础镜像 openeuler 24.03-lts-sp3）
├── go.mod / go.sum      # Go 模块（module: github.com/opensourceways/robot-universal-label）
└── LICENSE              # Apache 2.0
```

整个项目为单一 `package main`，所有 `.go` 文件平铺在根目录，无子包分层。

---

## 2. 核心模块详解

### 2.1 程序入口模块 (main.go)

**位置**: `main.go:26-53`

**功能说明**: 解析命令行参数 → 加载 configmap → 创建 robot → 按开关启动 cron → 启动 HTTP 服务。

**执行流程**:
1. 创建 logger（`component=robot-universal-label`）
2. `opt.gatherOptions(...)` 解析命令行参数；若 `opt.service.Interrupt` 为真则直接退出
3. 从 configmap 取出 `*configuration`
4. `newRobot(cnf, token, logger)` 创建 robot；为 nil 则退出
5. 若 `cnf.EnableLgtmApprove`：
   - `bot.initApprovalStrategies()` 初始化各组织审批策略
   - 启动 `time.Ticker`（周期 `cnf.CronJobInterval` 分钟），后台 goroutine 周期执行 `bot.init()` 刷新权限快照
6. `framework.StartupServer(...)` 启动 HTTP 服务，开始接收 Webhook

**关键代码**:
```go
if cnf.EnableLgtmApprove {
    bot.initApprovalStrategies()
    ticker := time.NewTicker(time.Duration(cnf.CronJobInterval) * time.Minute)
    defer ticker.Stop()
    go func() {
        bot.init()
        for range ticker.C { bot.init() }
    }()
}
framework.StartupServer(framework.NewServer(bot, opt.service), opt.service)
```

### 2.2 机器人核心模块 (robot.go)

#### 2.2.1 iClient 接口

**位置**: `robot.go:31-67`

抽象所有平台操作，便于测试注入 mock。关键方法分组：

- **标签**: `AddPRLabels` / `RemovePRLabels` / `AddIssueLabels` / `RemoveIssueLabels` /
  `GetPullRequestLabels` / `GetIssueLabels` / `GetRepoIssueLabels`
- **评论**: `CreatePRComment` / `CreateIssueComment` / `CallCommentAPI` / `UpdatePRComment` /
  `ListPullRequestComments` / `DeletePRComment`
- **PR 信息**: `GetPullRequest` / `GetPullRequestCommits` / `GetPullRequestChanges` /
  `ListPullRequestReviewComments` / `ResolveReviewComment` / `MergePullRequest` /
  `ListPullRequestOperationLogs`
- **权限/SIG**: `CheckPermission` / `CheckPermissionWithBranch` / `CheckPermissionWithSigName` /
  `ListSigInfo` / `ListRepoAllMember`
- **事件判定**: `CheckIfPRCreateEvent` / `CheckIfPRSourceCodeUpdateEvent` /
  `CheckIfPRSelfUpdateEvent` / `CheckIfPRCloseEvent` / `CheckIfPRReopenEvent` /
  `CheckIfPRLabelsUpdateEvent`

#### 2.2.2 robot 结构体与注册

**位置**: `robot.go:69-93`

```go
type robot struct {
    cli                iClient
    cnf                *configuration
    log                *logrus.Entry
    approvalStrategies map[string]LgtmApproveFunc
    repoConfigCache    sync.Map
}

func (bot *robot) RegisterEventHandler(p framework.HandlerRegister) {
    p.RegisterPullRequestHandler(bot.handlePullRequestEvent)
    p.RegisterIssueCommentHandler(bot.handleIssueCommentEvent)
    p.RegisterPullRequestCommentHandler(bot.handlePullRequestCommentEvent)
}
```

#### 2.2.3 argList 上下文

**位置**: `robot.go:99-128`

在事件处理链中传递上下文，避免大量参数。包含 `traceId / org / repo / number / title /
comment / commenter / author / targetBranch / eventType / ruleType / labels / commits /
changes / feedback` 等。`buildArgList(evt)`（`robot.go:130`）从 `GenericEvent` 构造。

#### 2.2.4 PR 事件处理器 `handlePullRequestEvent`

**位置**: `robot.go:149-244`

**功能说明**: 处理 PR 新建 / 源码更新 / 自身信息更新 / 关闭四类事件，驱动自动标签规则；
SIG 审查模式下额外处理标签清理与审查报告。

**执行流程**:
1. 判定事件类型；四类皆非则直接 return
2. `buildArgList`，取 `*repoConfig`；非关闭事件按 `DelayedSeconds` 等待（平台创建 PR 有时延）
3. 取 commits，为空 → 评论 `CommentPRNoFoundCommits` 后返回
4. 取 changes，为空 → 评论 `CommentPRNoFoundCodeChange` 后返回
5. 取当前 labels；若规则集含 PR 描述正则则额外拉取 PR body
6. 分支处理：
   - **关闭**：`ruleType=PRRemoveLabelByClose`，`autoRemovePRLabelByAction`（仅处理 `event_actions` 含「pr close...」的规则）
   - **仅自身更新**（非源码、非新建）：按 PR body 正则 `autoAddPRLabelByBody` / `autoRemovePRLabelByBody`
   - **新建/源码更新**：`autoAddPRLabel` + `autoRemovePRLabel`（按变更路径/提交数）
7. 若 `EnableLgtmApprove`：
   - 新建事件 → `welcomeAndReviewReport` 生成欢迎与审查报告
   - 重开/源码更新 → `clearLabel` 清除 `lgtm`/`approved` 等，再生成审查报告

#### 2.2.5 Issue 评论事件处理器 `handleIssueCommentEvent`

**位置**: `robot.go:246-294`

**功能说明**: 解析 Issue 评论命令，匹配规则、校验权限后增删 Issue 标签。

**执行流程**:
1. 正则命令匹配 `matchLabelRuleWithCommentRegexp`（通用 `/<kw> v`、`/remove-<kw> v`）
2. 规则匹配 `matchIssueLabelRuleWithComment`（配置的 `add_label_command` / `remove_label_command`）
3. `/label add|remove` 命令匹配 `matchLabelAddRemoveFromComment`
4. 三类皆空 → 无事可做
5. 取当前 labels，对加/删做差集/交集，命令规则经 `commentAddLabelByRule` / `commentRemoveLabelByRule` 处理
6. 有反馈 → `CreateIssueComment` 用 `FeedbackCommentPrefix` 汇总发出
7. 加/删交集冲突 → 评论 `CommentLabelCommandConflict` 并返回
8. 执行 `addIssueLabels` / `removeIssueLabels`

#### 2.2.6 PR 评论事件处理器 `handlePullRequestCommentEvent`

**位置**: `robot.go:296-363`

**功能说明**: 解析 PR 评论命令并增删 PR 标签；SIG 审查模式下改走 `/lgtm` `/approve` 流程。

**执行流程**:
1. 若 `EnableLgtmApprove`：逐行调用 `handleLGTM` 与 `handleApprove`，**直接返回**（与标签规则流互斥，避免冲突）
2. 否则：正则命令 + 规则命令匹配；皆空则返回
3. 取 labels 做差集/交集；若有规则命令则补 changes（为空时把「无代码变更」加入反馈）
4. 经权限校验得到加/删标签；有反馈 → 评论；冲突 → 评论 `CommentLabelCommandConflict`
5. 执行 `addPRLabels` / `removePRLabels`

### 2.3 标签添加模块 (add_label.go)

**位置**: `add_label.go:12-137`

- `autoAddPRLabel`（`:12`）：`ruleType==PRAddLabelByPRChange` 时，遍历 `AutoAddPRLabelRules`，
  对每条规则调 `autoAddLabelByRule`
- `autoAddLabelByRule`（`:48`）：命中即返回标签名，触发条件（任一满足）：
  1. 已有该标签 → 跳过
  2. `CommitsThreshold > 0` 且提交数 `> 阈值`
  3. 变更文件路径前缀匹配 `PRChangePaths` 任一项
  4. `pr_body_regex` 命中 PR 描述
- `autoAddPRLabelByBody`（`:25`）：仅 PR 自身信息更新事件，按 `pr_body_regex` 加标签
- `addPRLabels`（`:83`）：调用平台 API 加标签；成功且标签命中 `AddLabelToFeedback` 前缀时，
  评论 `CommentAddLabelSuccessful`；失败评论 `CommentUpdateLabelFailed`
- `addIssueLabels`（`:111`）：加 Issue 标签，失败评论
- `commentAddLabelByRule`（`:123`）：对命令命中的规则逐条权限校验取标签；`weak` 权限下若标签为空再查标签是否存在

### 2.4 标签删除模块 (remove_label.go)

**位置**: `remove_label.go:13-147`

- `autoRemovePRLabel`（`:13`）：PR 源码变更时，按规则删除标签
- `autoRemovePRLabelByAction`（`:26`）：PR 关闭时，仅删除 `event_actions` 含 `PRRemoveLabelByClose`（"pr close to trigger remove label"）的规则对应标签（典型：关闭时清 `lgtm`/`approved`）
- `autoRemovePRLabelByBody`（`:40`）：PR 自身更新时按 `pr_body_regex` 删标签（支持 `label_prefix` 前缀匹配）
- `autoRemoveLabelByRule`（`:67`）：按 `LabelName`/`LabelPrefix` 选中标签；但若 `pr_body_regex` 不匹配、或提交数高于阈值、或存在 `pr_change_paths` 命中的文件，则**不移除**
- `removePRLabels`（`:97`）：URL 转义后调用平台 API 删除；`feedback=true` 时评论 `CommentRemoveLabelsWhenPRSourceCodeUpdated`
- `removeIssueLabels`（`:118`）/ `commentRemoveLabelByRule`（`:133`）：对应 Issue 与命令删除路径

### 2.5 命令解析与权限校验模块 (robot_helper.go)

#### 2.5.1 规则类型与权限常量

**位置**: `robot_helper.go:28-48`

```go
PRAddLabelByComment   = "comment command to trigger add label"
PRAddLabelByPRChange  = "pr change to trigger add label"
PRAddLabelByPRBody    = "pr body change to trigger add label"
PRRemoveLabelByComment= "comment command to trigger remove label"
PRRemoveLabelByPRChange="pr change to trigger remove label"
PRRemoveLabelByPRBody = "pr body change to trigger remove label"
PRRemoveLabelByClose  = "pr close to trigger remove label"
// 权限级别
permissionLevelStrict = "strict"   permissionLevelWeak = "weak"   permissionLevelNone = "none"
```

#### 2.5.2 命令解析

- `filterValidCommentCommand`（`:60`）：按行拆分，取以 `/` 开头的行作为命令
- `matchPRLabelRuleWithComment`（`:72`）/ `matchIssueLabelRuleWithComment`（`:154`）：命令精确匹配配置的 `add_label_command` / `remove_label_command`
- `matchLabelRuleWithCommentRegexp`（`:87`）：通用正则命令。`/<kw> <value>` → 标签 `kw/value`；
  对仓库不存在的标签，maintainer/committer 可直接创建，否则评论 `CommentAddNotExistLabel`
- `matchLabelFromCommentLine`（`:128`）：把 `/<kw> <value>` 拼成 `kw<sep>value`（默认分隔符 `/`，`command_label_separator` 可配）；`remove-` 前缀去掉后拼接
- `matchLabelAddRemoveFromComment`（`:378`）：解析 `/label add <l1 l2...>`、`/label remove <...>`（适配 Ascend 社区）

#### 2.5.3 五层权限校验链 `commentAddOrRemoveLabelByRule`

**位置**: `robot_helper.go:168-206`

按以下顺序短路校验（任一通过即授权）：

| 顺序 | 校验 | 字段 | 函数 |
|------|------|------|------|
| 0 | 加已有/删不存在 → 跳过 | — | `shouldSkipLabelOperation` |
| 0 | `can_not_add_labels_by_self` 且评论者=作者 → 拒绝 | `CanNotAddLabelsBySelf` | 评论 `CommentAddLabelBySelf` |
| — | `verify_permission=none` → 直接放行 | — | — |
| 1 | SigDir 目录归属 | `repo_sig_dir` | `checkSigDirPermission` |
| 2 | SIG Maintainer 列表 | `user_sig_maintainer_list` + `pr_change_paths` | `checkSigMaintainerPermission` |
| 3 | 用户 ID 白名单 | `user_id_list` / `user_id_only` | `checkUserIDPermission` |
| 4 | SIG 角色（maintainer/committer/repo admin/branch keeper） | `user_sig_role_list` / `user_sig_role_only` | `checkUserSigRolePermission` |
| 5 | 仓库角色 | `user_repo_role_list` | `checkUserRepoRolePermission` |

全部不通过 → 追加 `CommentNoPermissionForRepoMember` 反馈，返回空标签。
`branch keeper` 仅对 `targetBranch` 匹配的分支生效，否则提示 `CommentPermissionTipForBranchKeeper`。

#### 2.5.4 标签名生成 `getLabel`

**位置**: `robot_helper.go:362-375`

- 有 `label_name` → 直接用
- 否则有 `label_prefix` → 拼 `prefix-<commenter>`（截断 50 字符防过长）

### 2.6 SIG 审查模块 (lgtm.go / approve.go / reviewstatus.go / actions_review.go / siginfo.go)

> 仅 `enable_lgtm_approve=true` 时生效，PR 评论事件改走此流程（与标签规则流互斥）。

#### 2.6.1 /lgtm 命令 (lgtm.go)

**位置**: `lgtm.go`

- 命令：`/lgtm`（正则 `(?mi)^/lgtm\s*$`）、`/lgtm cancel`（`(?mi)^/lgtm cancel\s*$`），标签 `lgtm`
- `addLGTM`（`:37`）：
  - 作者本人评论 `/lgtm` → 评论 `CommentAddLGTMBySelf`，拒绝自审
  - 已有 `lgtm` 标签 → 跳过
  - 否则进入 `handleLgtmOrApprove` 按审查配置授予
- `removeLGTM`（`:56`）：取权限快照与审查上下文，计算可 lgtm 人群 `CanLgtmPersons`；
  评论者在其中 → 移除 `lgtm` 标签并评论 `CommentRemovedLabel`，否则评论 `CommentNoPermissionForLabel`

#### 2.6.2 /approve 命令 (approve.go)

**位置**: `approve.go`

- 命令：`/approve`、`/approve cancel`，标签 `approved`
- `AddApprove`（`:35`）：作者本人 → `CommentAddAPPROVEDBySelf` 拒绝；已同时有 `lgtm`+`approved` → 跳过；否则按审查配置授予
- `removeApprove`（`:55`）：按可 approve 人群 `CanApprovePersons` 判定权限后移除 `approved`

#### 2.6.3 审查状态与报告 (reviewstatus.go / actions_review.go / siginfo.go)

- `siginfo.go`：加载 SIG/组织信息，构建权限快照（`getPermSnapshot`，含 `RepoSigMap`）
- `reviewstatus.go` / `actions_review.go`：依据 `ReviewConfig`（`total_number_of_lgtm` /
  `total_number_of_approve`）与 PR 评审评论计算各模块审查状态、生成审查报告评论、判定
  `lgtm`/`approved` 授予；`ReviewReportConfig` 提供报告所有文案模板
- `clearLabel`：PR 源码更新/重开时清除 `lgtm`/`approved`，评论 `CommentClearLabelCaseByPRUpdate` /
  `CommentClearLabelCaseByReopenPR`

### 2.7 配置模块 (config.go)

#### 2.7.1 全局配置 `configuration`

**位置**: `config.go:25-80`。关键字段：

- `config_items`：仓库级规则列表（`repoConfig`）
- `sig_info_url`（必填）、`community_name`（必填）、`community_robot_id`
- `command_reg_exp_key_word`（必填）：通用命令关键字正则（如 `kind|priority|sig|good`）
- `command_label_separator`：命令值与关键字拼接分隔符（默认 `/`）
- `delayed_seconds`：处理 PR 前的等待秒数（应对平台创建时延）
- 一组 `comment_*` 评论模板（见 2.7.4）；`add_label_to_feedback`、`feedback_comment_prefix`（必填）
- `enable_lgtm_approve` 及一组仅审查模式生效的字段（`info_repo_configs` / `cron_job_interval` /
  `review_report_config` / `comment_robot_url` 等）

`Validate()`（`:83`）做必填校验、预编译 `pr_body_regex`，并初始化通用命令全局正则：
```go
regexpCommentByAnyoneToAddLabel  = ^/(<kw>)[\t ]+[A-Za-z0-9_-]+$
regexpCommentByAnyoneRemoveLabel = ^/remove-(<kw>)[\t ]+[A-Za-z0-9_-]+$
```

#### 2.7.2 仓库配置 `repoConfig`

**位置**: `config.go:133-149`

- `repos`（必填，`org` 或 `org/repo`）、`excluded_repos`、`branches`、`excluded_branches`
- `auto_remove_pr_label_rules` / `auto_add_pr_label_rules`
- `manual_add_or_remove_pr_label_rules` / `manual_add_or_remove_issue_label_rules`
- `review`（`ReviewConfig`）、`branch_configs`、`need_set_pr_assignees_and_reviewers`

#### 2.7.3 标签规则 `LabelRule`

**位置**: `config.go:151-177`

| 字段 | 说明 |
|------|------|
| `add_label_command` / `remove_label_command` | 触发增/删的评论命令 |
| `event_actions` | 触发事件类型（如 `pr close to trigger remove label`） |
| `label_name` / `label_prefix` | 标签名 / 前缀（前缀模式拼 `prefix-<commenter>`） |
| `can_not_add_labels_by_self` | 禁止作者自加（如 `/lgtm` 自审） |
| `verify_permission`（必填） | `strict` / `weak` / `none` |
| `user_id_list` / `user_id_only` | 用户白名单及是否独占 |
| `user_sig_role_list` / `user_sig_role_only` | SIG 角色（maintainer/committer/repo admin/branch keeper） |
| `user_repo_role_list` | 仓库角色 |
| `user_sig_maintainer_list` | SIG maintainer（配合 `pr_change_paths`） |
| `repo_sig_dir` | SIG 目录归属校验根目录 |
| `commits_threshold` | 提交数阈值（超过触发） |
| `pr_change_paths` | 变更路径前缀触发 |
| `pr_body_regex` | PR 描述正则触发 |
| `precondition_label_name` | 前置标签条件 |

#### 2.7.4 评论模板（节选，`config.yaml`）

| 配置键 | 用途 / 文案核心子串 |
|--------|---------------------|
| `comment_add_label_successful` | 加标签成功（含 `reviewed the code changes`、`/check-pr` 提示） |
| `comment_update_label_failed` | 标签更新失败（`update failed, please comment once again`） |
| `comment_add_not_exist_label` | 仓库无此标签（`doesn't have the label`） |
| `comment_add_label_by_self` | 禁止自审（`you can't review code by yourself`） |
| `comment_label_command_conflict` | 同时加删同一标签冲突 |
| `comment_no_permission_for_user_list` | 权限属于指定用户列表 |
| `comment_no_permission_for_repo_member` | 权限在仓库外（`permission is outside`） |
| `comment_permission_tip_for_branch_keeper` | branch keeper 提示 |
| `comment_remove_labels_when_pr_source_code_updated` | 源码更新/关闭移除标签通知 |
| `comment_pr_no_found_commits` / `comment_pr_no_found_code_change` | 取不到提交/变更 |
| `feedback_comment_prefix` | 反馈汇总外层（`### Label Command Feedback`） |

---

## 3. 业务流程说明

### 3.1 PR 新建/更新自动标签流程

1. `robot-framework-lib` 接收 Webhook，解析为 `client.GenericEvent`
2. `handlePullRequestEvent` 判定事件类型，等待 `delayed_seconds`
3. 取 commits / changes / labels（必要时取 PR body）
4. `autoAddPRLabel` 按 `commits_threshold` / `pr_change_paths` / `pr_body_regex` 加标签
5. `autoRemovePRLabel` 按规则删标签（注意「存在变更路径命中/提交超阈值」时不删）
6. 调用平台 API；失败评论反馈

### 3.2 评论命令增删标签流程

1. `handleIssueCommentEvent` / `handlePullRequestCommentEvent` 接收评论
2. 通用正则命令 + 配置命令 + `/label add|remove` 三路解析
3. 五层权限校验链逐层短路
4. 加/删差集计算与冲突检查
5. 执行标签操作，结果/反馈以评论返回

### 3.3 用户操作场景

- **场景 1（自动）**：开发者创建/更新 PR → 机器人按变更自动加 `stat/needs-squash`、
  `need-doc-sig-review` 等；源码再更新/关闭时按规则清理标签
- **场景 2（手动命令）**：审查者评论 `/lgtm`、`/approve`、`/squash`、`/ack`、`/kind bug` 等 →
  权限校验通过则增删对应标签并反馈
- **场景 3（SIG 审查，开关开启）**：`/lgtm`、`/approve` 经 SIG 角色与审查数量要求授予
  `lgtm`/`approved`；PR 源码更新/重开自动清除，生成审查报告

---

## 4. 配置和环境

### 4.1 配置文件说明

配置文件使用 YAML 格式（`testdata/config.yaml` 为完整参考）。

#### 4.1.1 配置示例（节选自 testdata/config.yaml）

```yaml
config_items:
  - repos:
      - openeuler-test/test-feature
    auto_remove_pr_label_rules:
      - label_name: "stat/needs-squash"
        commits_threshold: 1
      - label_name: "lgtm"
        event_actions:
          - "pr close to trigger remove label"
      - label_prefix: "lgtm"
        event_actions:
          - "pr close to trigger remove label"
      - label_name: "need-doc-sig-review"
        pr_change_paths:
          - "docs/zh"
          - "docs/en"
    auto_add_pr_label_rules:
      - label_name: "stat/needs-squash"
        commits_threshold: 1
      - label_name: "need-doc-sig-review"
        pr_change_paths:
          - "docs/zh"
          - "docs/en"
    manual_add_or_remove_pr_label_rules:
      - label_name: "Acked"
        add_label_command: "/ack"
        verify_permission: "strict"
        user_id_list: ["oekernel", "zhengzengkai", "ibforu"]
        user_id_only: true
      - label_name: "merge/squash"
        add_label_command: "/squash"
        remove_label_command: "/squash cancel"
        verify_permission: "strict"
        user_sig_role_list: ["maintainer", "committer"]
        user_sig_role_only: true
      - label_prefix: "lgtm"
        add_label_command: "/lgtm"
        remove_label_command: "/lgtm cancel"
        verify_permission: "strict"
        can_not_add_labels_by_self: true
        user_sig_role_list: ["maintainer", "committer", "repo admin"]
        user_sig_role_only: true
        repo_sig_dir: "sig"
      - label_name: "doc-sig-reviewed"
        add_label_command: "/review-by-doc-sig"
        remove_label_command: "/remove-doc-sig"
        verify_permission: "strict"
        user_sig_maintainer_list: ["doc"]
        precondition_label_name: "need-doc-sig-review"
        pr_change_paths: ["docs/zh", "docs/en"]

sig_info_url: "http://localhost:18890/openeuler.json"
community_name: openeuler
community_robot_id: openeuler-ci-bot
command_reg_exp_key_word: "kind|priority|sig|good"
command_label_separator: "/"
delayed_seconds: 2

feedback_comment_prefix: "### Label Command Feedback  \n%s"
add_label_to_feedback: ["lgtm", "approved", "lgtm-"]
```

#### 4.1.2 命令一览

| 命令 | 作用 | 典型权限 |
|------|------|----------|
| `/lgtm` / `/lgtm cancel` | 加/撤 `lgtm` 标签 | SIG 角色，禁止自审 |
| `/approve` / `/approve cancel` | 加/撤 `approved` 标签 | SIG 角色（含 branch keeper） |
| `/squash` / `/rebase`（+ cancel） | 加/撤 `merge/squash`、`merge/rebase` | maintainer/committer |
| `/ack` | 加 `Acked` | 指定用户白名单 |
| `/remove-needs-issue` / `/kabi-reviewed` | 删 `needs-issue` / `kabi-need-review` | 指定用户白名单 |
| `/review-by-doc-sig` / `/remove-doc-sig` | 加/删 `doc-sig-reviewed` | doc SIG maintainer |
| `/<kw> <value>`（kw∈关键字） | 加 `kw/value` 标签 | 任何人（标签需存在或有权创建） |
| `/remove-<kw> <value>` | 删 `kw/value` 标签 | 同上 |
| `/label add <labels>` / `/label remove <labels>` | 批量加/删（Ascend 社区） | 同通用规则 |

### 4.2 环境变量与启动参数

| 项 | 说明 |
|----|------|
| 配置文件路径 | 命令行参数（`robot-framework-lib` 的 `FrameworkOptions`） |
| Token | 命令行参数或文件（`testdata/token`） |
| 配置格式 | YAML |

### 4.3 部署要求

- **运行时**：Go 1.25.10+；Linux（`linux-amd64`）
- **容器**：基础镜像 `openeuler/openeuler:24.03-lts-sp3`；非 root 用户 `robot`（uid=1000）；
  时区 `Asia/Shanghai`；二进制 `/opt/app/robot-universal-label`
- **构建**：
  ```bash
  go build -a -o robot-universal-label -buildmode=pie \
    -ldflags "-s -linkmode 'external' -extldflags '-Wl,-z,now'"
  ```

---

## 5. 使用指南

### 5.1 本地开发

```bash
git clone https://github.com/opensourceways/robot-universal-label.git
cd robot-universal-label
go mod download
# 编辑 testdata/config.yaml，配置仓库标签规则与权限
go build -o robot-universal-label .
./robot-universal-label --config-file=testdata/config.yaml --token-path=testdata/token
```

配置 Webhook 指向服务 HTTP 端点，订阅 PR / Issue / 评论事件。

### 5.2 Docker 部署

```bash
docker build -t robot-universal-label:latest .
docker run -d -p 8888:8888 \
  -v /path/to/config.yaml:/opt/app/config.yaml \
  -v /path/to/token:/opt/app/token \
  robot-universal-label:latest
```

### 5.3 测试

```bash
go test ./...        # 全部单元测试（testify + mock iClient）
```

---

## 6. 集成测试参考要点

为 `integration-tests` 编写本机器人用例时，关注以下可观测行为（黑盒断言点）：

1. **自动标签**：按 `commits_threshold` / `pr_change_paths` 变更 PR 后，PR labels 出现/消失对应标签
2. **手动命令**：评论 `/lgtm`、`/approve`、`/squash`、`/ack`、`/kind xxx` 后标签变化与权限拒绝反馈
3. **权限校验**：非授权用户评论命令 → 反馈 `permission is outside` / 用户列表提示，标签不变
4. **自审拦截**：PR 作者本人 `/lgtm` → 反馈 `you can't review code by yourself`
5. **冲突检查**：同评论同时加删同一标签 → 冲突反馈
6. **生命周期**：PR 源码更新/关闭 → `event_actions` 命中的标签（如 `lgtm`）被自动移除并通知
7. **不存在标签**：`/<kw> <value>` 指向仓库无的标签且无创建权限 → `doesn't have the label` 提示

> 注：精确断言文案以目标仓库实际部署的 `config.yaml` 评论模板为准；标签/命令/权限均依赖该仓库
> 的配置，编写实测用例前需对齐部署配置（参见本仓 `services/robot-server/base_community/test_cases.py`
> 中 review 机器人用例的 `REVIEW_ROBOT_ENABLED` 门禁与前置说明同样适用）。

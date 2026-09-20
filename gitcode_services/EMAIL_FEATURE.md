# 测试报告邮件发送功能

## 功能说明

自动将测试报告发送到指定邮箱，包含：
- HTML格式邮件正文（门禁状态、执行摘要）
- 附件：report.md（详细报告）
- 附件：summary.json（JSON汇总）
- 附件：junit.xml（JUnit格式，如有）

## 配置

在 `config.yaml` 的 `email` 节配置邮件参数：

```yaml
email:
  enabled: true                        # false 时跳过发送
  sender: "your_email@163.com"         # 发件人邮箱
  password: "your_smtp_password"       # SMTP授权密码（非登录密码）
  receivers:                           # 收件人邮箱，可多个
    - "receiver1@example.com"
  smtp_host: smtp.163.com
  smtp_port: 465                       # 465=SSL；587 需把 use_ssl 设为 false
  use_ssl: true
```

### 注意事项

1. **password** 不是邮箱登录密码，而是SMTP授权码
   - 163邮箱：设置 → POP3/SMTP/IMAP → 开启并获取授权码
   - QQ邮箱：设置 → 账户 → POP3/IMAP/SMTP → 生成授权码

2. **多个收件人** 写成 YAML 列表：
   ```yaml
   receivers:
     - user1@example.com
     - user2@example.com
   ```

3. **`email` 节不注入环境变量**：`git_runner.py` 会把整份 `os.environ` 传给 git
   子进程，SMTP 授权码不应随之外泄，故由 `email_sender.py` 结构化读取。

## 使用方式

### 1. 自动发送（推荐）

运行测试时自动发送邮件：

```bash
./run_daily.sh
```

执行流程：
1. [1/8] Schema 校验与分流
2. [2/8] workflow 批量执行
3. [3/8] api 批量执行
4. [4/8] ui 批量执行
5. [5/8] git 批量执行
6. [6/8] JUnit XML 导出
7. [7/8] 报告生成
8. [8/8] **发送邮件报告** ← 新增步骤

### 2. 手动发送

对已生成的报告发送邮件：

```bash
# 查看可用的报告
ls phase02/reports/

# 发送指定报告
python phase02/scripts/email_sender.py daily-20260920-143000
```

或使用测试脚本：

```bash
./test_email.sh daily-20260920-143000
```

## 邮件内容

### 主题格式
```
[GO/BLOCKED/INCONCLUSIVE] GitCode 测试报告 - {run_id}
```

### 正文内容
- **门禁状态**：GO（✅）/ BLOCKED（⛔）/ INCONCLUSIVE（⚪）
- **执行摘要**：
  - Run ID
  - 执行时间
  - 总用例数
  - 通过数
  - 失败数
- **附件说明**

### 附件
1. `report.md` - Markdown格式详细报告
2. `summary.json` - JSON格式汇总数据
3. `junit.xml` - JUnit格式测试结果（如存在）

## 错误处理

邮件发送失败不会影响测试结果：
- 测试正常执行和报告生成
- 邮件发送失败仅输出警告
- 最终退出码仍为测试门禁状态

## 文件结构

```
gitcode_services/
├── config.yaml                       # 邮件配置（email 节）
├── run_daily.sh                      # 测试入口（已集成邮件发送）
├── test_email.sh                     # 邮件测试脚本
└── phase02/
    ├── scripts/
    │   └── email_sender.py          # 邮件发送模块
    └── reports/
        └── {run_id}/
            ├── report.md            # 测试报告
            └── summary.json         # 汇总数据
```

## 示例输出

```bash
=== GitCode 每日回归测试 ===
...
[7/8] 报告生成...
报告已生成: reports/daily-20260920-143000/report.md

[8/8] 发送邮件报告...
=== GitCode 测试报告邮件发送 ===
Run ID: daily-20260920-143000
报告路径: phase02/reports/daily-20260920-143000/report.md
发件人: guozhi1992@163.com
收件人: guoxiaozhen3@h-partners.com

正在连接到邮件服务器 smtp.163.com:465...
正在发送邮件到: guoxiaozhen3@h-partners.com
✅ 邮件发送成功！
   收件人: guoxiaozhen3@h-partners.com
   主题: [GO] GitCode 测试报告 - daily-20260920-143000
✅ 邮件发送成功

门禁判定: GO（可上线） (退出码 0)
```

## 常见问题

### 1. 邮件发送失败

**错误**：`535 Error: authentication failed`
- **原因**：SMTP密码错误或未开启SMTP服务
- **解决**：
  1. 检查 `config.yaml` 中 `email.password` 是否为授权码
  2. 确认邮箱已开启SMTP服务

**错误**：连接超时
- **原因**：网络或防火墙问题
- **解决**：检查网络连接，确保可以访问 smtp.163.com:465

### 2. 配置文件不存在

**错误**：`配置文件不存在: config.yaml`
- **解决**：确保 `config.yaml` 在项目根目录（可从 `config.yaml.example` 复制）

### 3. 收件人配置错误

**问题**：没有收到邮件
- **检查**：
  1. `config.yaml` 中 `email.receivers` 为合法 YAML 列表
  2. 邮箱地址拼写正确
  3. 查看垃圾邮件箱

## 技术实现

- **邮件协议**：SMTP over SSL (端口 465)
- **服务器**：smtp.163.com（163邮箱）
- **编码**：UTF-8
- **附件编码**：Base64
- **邮件格式**：HTML + 附件

如需更换邮件服务商，修改 `email_sender.py` 中的 `smtp_server` 和 `smtp_port`。

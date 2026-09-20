# FAIL 用例备份区

**创建时间**: 2025-01-18  
**用例数量**: 30 条  
**来源**: phase02/runs/ui-final-authed（UI 测试 FAIL 结果）

---

## 目录说明

本目录包含所有测试失败的用例，已从 `cases/yaml/` 备份到此处。

### 文件清单

- **`*.yaml`** — 30 个失败用例的 YAML 文件（备份）
- **`failed_cases.txt`** — 失败用例的 case_id 清单
- **`验证进度.md`** — 人工验证进度跟踪表
- **`删除原文件.bat`** — 从 cases/yaml/ 删除原文件的脚本
- **`恢复用例.bat`** — 验证后恢复用例到 cases/yaml/ 的脚本
- **`README.md`** — 本文件

---

## 使用流程

### 1. 删除原文件（可选）

如果希望执行测试时跳过这些 FAIL 用例，运行：

```bash
# Windows
cases\failed_reserved\删除原文件.bat

# Linux/Mac
cd cases/yaml
cat ../failed_reserved/failed_cases.txt | xargs -I {} rm {}.yaml
```

**效果**: cases/yaml/ 中只剩 PASS/INCONCLUSIVE 的用例（约 45 条）

### 2. 人工验证

按优先级逐条验证（参考 `phase02/runs/ui-final-authed/人工验证清单.md`）：

**P0（7 条）** — 安全问题，最高优先级
- COMP-SECRETS-02-001
- SEC-FORK2-02-001
- SEC-FORK3-02-001
- SEC-PAT-02-001
- SEC-PKG-02-001
- SEC-ROLE2-02-001
- SEC-RUNNER-02-001

**P1（12 条）** — 功能完整性问题
- UI-BOARD-25-001（看板）
- UI-ISSUE-* （Issue 功能）
- UI-MR-* （MR 功能）
- UI-REPO-* （仓库管理）
- 等

**P2（11 条）** — 可用性问题
- UI-CODE-25-001
- UI-SEARCH-25-001
- UI-USER-*
- 等

### 3. 记录验证结果

在 `验证进度.md` 中填写：
- **验证结果**: 真缺陷 / 用例问题 / 功能缺失 / 环境问题
- **处理方案**: 提缺陷 / 修正用例 / 标记 SKIP / 恢复执行
- **备注**: 补充说明

### 4. 处理验证结果

#### 情况 A: 真缺陷
1. 提交到缺陷管理系统（Jira/禅道）
2. 用例保留在此目录
3. 缺陷修复后，运行 `恢复用例.bat` 放回 cases/yaml/
4. 重新执行测试验证

#### 情况 B: 用例问题（selector 错误等）
1. 编辑此目录中的 YAML 文件，修正问题
2. 运行 `恢复用例.bat` 或手动复制到 cases/yaml/
3. 重新执行测试验证

#### 情况 C: 功能缺失
1. 记录到产品需求 backlog
2. 在 YAML 文件头部添加注释：
   ```yaml
   # SKIP: 功能未实现，待上线后恢复测试
   ```
3. 用例保留在此目录，不放回 cases/yaml/

#### 情况 D: 环境问题（权限不足、数据缺失）
1. 修复环境配置（如调整测试账号权限）
2. 准备测试数据
3. 运行 `恢复用例.bat` 放回 cases/yaml/
4. 重新执行测试验证

---

## 批量恢复用例

### 恢复所有用例
```bash
# Windows
cases\failed_reserved\恢复用例.bat

# Linux/Mac
cp cases/failed_reserved/*.yaml cases/yaml/
```

### 恢复部分用例（按优先级）
```bash
# 只恢复 P0 安全用例
cp cases/failed_reserved/COMP-SECRETS-02-001.yaml cases/yaml/
cp cases/failed_reserved/SEC-*.yaml cases/yaml/

# 只恢复 Issue 相关用例
cp cases/failed_reserved/UI-ISSUE-*.yaml cases/yaml/
```

---

## 重新执行测试

恢复用例后，重新生成队列并执行：

```bash
cd D:/业务/integration-tests/gitcode_services

# 重新生成队列（只包含 cases/yaml/ 中的用例）
py phase02/scripts/schema_check_ext.py ui ui-retest --src-dir cases/yaml

# 执行测试
py phase02/scripts/run_ui_batch.py ui-retest

# 或只执行单条
py phase02/scripts/run_ui_batch.py ui-retest --only COMP-SECRETS-02-001
```

---

## 统计信息

### 按优先级分布
- P0（安全）: 7 条
- P1（功能）: 12 条
- P2（体验）: 11 条

### 按失败类型分布
- UI 交互失败: 20 条
- 内容不匹配: 8 条
- 元素不可见: 2 条

---

## 相关文档

- **详细分析**: `phase02/runs/ui-final-authed/FAIL_分析报告.md`
- **深度分析**: `phase02/runs/ui-final-authed/FAIL_深度分析.md`
- **验证手册**: `phase02/runs/ui-final-authed/人工验证清单.md`
- **CSV 清单**: `phase02/runs/ui-final-authed/FAIL_清单.csv`

---

**维护者**: 测试团队  
**更新时间**: 2025-01-18

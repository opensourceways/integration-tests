# Service A openEuler Community Tests

openEuler 社区专属测试用例。该目录下的测试用例仅在 openEuler 社区环境中执行。

## 目录结构

```
services/meeting-server/openeuler_community/
├── README.md              # 本文件
├── run_all.sh             # 执行所有 openEuler 专属测试用例
└── test_*.sh              # openEuler 专属测试用例脚本
```

## 使用方法

```bash
# 执行所有 openEuler 专属测试用例
bash services/meeting-server/openeuler_community/run_all.sh
```

## 与 base_community 的关系

1. 先执行 `base_community/` 下的公共测试用例
2. 再执行 `openeuler_community/` 下的 openEuler 专属测试用例
3. 公共测试用例由所有社区共享，专属测试用例仅针对特定社区

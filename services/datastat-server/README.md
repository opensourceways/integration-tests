# Service A Base Community Tests

所有社区的公共测试用例脚本。这些测试用例是所有社区共用的基础测试。

## 目录结构

```
services/meeting-server/base_community/
├── README.md              # 本文件
├── run_all.sh             # 执行所有公共测试用例
└── test_*.sh              # 公共测试用例脚本
```

## 使用方法

```bash
# 执行所有公共测试用例
bash services/meeting-server/base_community/run_all.sh

# 执行单个测试用例
bash services/meeting-server/base_community/test_service_a_basic.sh
```

## 测试用例说明

- 所有放在 `base_community/` 下的测试用例会被所有社区执行
- 社区特定的测试用例请放在对应的 `*_community/` 目录下（如 `openeuler_community/`）

# Integration Tests

集成测试仓库：跨仓端到端测试场景。

## 目录结构

```
integration-tests/
├── README.md                          # 本文件
├── CLAUDE.md                          # 项目 Claude 配置
├── .github/workflows/ci.yml           # CI 配置
└── services/                          # 各服务的测试用例
    └── meeting-server/                # Meeting Server 测试
        ├── base_community/            #   所有社区共用的公共测试用例
        └── openeuler_community/       #   openEuler 社区专属测试用例
```

## 使用方法

```bash
# 执行 Meeting Server 公共测试用例
bash services/meeting-server/base_community/run_all.sh

# 执行 Meeting Server openEuler 社区专属测试（会先跑 base_community）
bash services/meeting-server/openeuler_community/run_all.sh
```

## 规则

1. 公共测试用例放在 `services/<service-name>/base_community/`，所有社区共享
2. 社区专属测试用例放在 `services/<service-name>/*_community/`，仅对应社区执行
3. 社区专属测试执行前先跑 base_community 公共测试

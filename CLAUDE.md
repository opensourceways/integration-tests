# Integration Tests

集成测试仓库：跨仓端到端测试场景。

## 结构

- `service/base_community/` — 所有社区共用的公共测试用例
- `service/openeuler_community/` — openEuler 社区专属测试用例
- `.github/workflows/ci.yml` — CI 配置

## 规则

1. 公共测试用例放在 `base_community/`，所有社区共享
2. 社区专属测试用例放在 `*_community/`，仅对应社区执行
3. 社区专属测试执行前先跑 base_community 公共测试

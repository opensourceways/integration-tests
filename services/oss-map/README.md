# oss-map 集成测试

范式 A：`pytest` + `requests`，打**测试环境**真实服务（不是 preview）。

## 被测环境

| 项 | 值 |
|----|----|
| 默认 Base URL | `https://oss-map.test.osinfra.cn` |
| API 前缀 | `/api/v1` |
| 流水线挂载点 | backlog `/ai-deploy-test` → `run_integration_tests.py` |

## 安全边界

本目录用例**只做只读探测 + 鉴权负向**：

- 允许：`GET` 健康检查 / 列表 / 详情 / 搜索；故意无 Token 或错误密码的 401
- **禁止**：创建 / 更新 / 删除项目、人员合并、写 MCP Key、触发采集等会改测试环境数据的操作

可选登录用例仅在同时设置了 `OSS_MAP_TEST_ACCOUNT` 与 `OSS_MAP_TEST_PASSWORD` 时执行；未设置则 skip。

## 运行

```bash
cd services/oss-map
bash run_all.sh

# 或
pip install -r requirements.txt
pytest -v test_cases.py

# 覆盖 Base URL（一般不需要）
OSS_MAP_BASE_URL=https://oss-map.test.osinfra.cn pytest -v test_cases.py
```

## 文件

| 文件 | 说明 |
|------|------|
| `test_cases.py` | 可执行 pytest 用例 |
| `TestStrategy.md` | 模块测试策略（交付件） |
| `requirements.txt` | 依赖 |
| `run_all.sh` | 统一入口（供 integration-tests 探测） |

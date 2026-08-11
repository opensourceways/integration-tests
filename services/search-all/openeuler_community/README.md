# API-euler 接口自动化测试框架

基于 **pytest + requests** 的标准化 Python 接口自动化测试脚本，覆盖 `API-euler.md` 与 `API-common.md` 中定义的全部接口。

---

## 一、项目结构

```
api_automation/
├── settings.py          # 全局配置（URL、超时、重试、日志等）
├── logger.py            # 日志封装（INFO / ERROR 分级）
├── request_client.py    # 通用 HTTP 请求工具（重试、异常捕获、响应封装）
├── assertions.py        # 断言体系（HTTP状态、业务状态、字段、类型）
├── test_all.py          # 全部接口测试用例
├── test_data.json       # 测试数据（正向/反向用例参数）
├── conftest.py          # pytest 全局 fixture / 钩子
├── run.py               # 统一执行入口（带参数解析、报告生成）
├── requirements.txt     # Python 依赖清单
└── README.md            # 本文件
```

---

## 二、运行命令

### 2.1 安装依赖

```bash
pip install -r requirements.txt
```

### 2.2 运行全部用例

```bash
python run.py
```

或直接使用 pytest：

```bash
pytest -v
```

### 2.3 运行指定模块

```bash
python run.py --module test_search
python run.py --module test_sort
python run.py --module test_software
python run.py --module test_jumper
python run.py --module test_sig
```

### 2.4 切换目标环境

```bash
# 测试 openEuler 生产环境
python run.py --base-url https://doc-search.openeuler.org --referer https://www.openeuler.org/

# 测试多社区分支（API-common）
python run.py --base-url http://localhost:8080 --source openfuyao --referer https://www.openfuyao.org/
```

### 2.5 生成报告

```bash
# HTML 报告（默认）
python run.py --report html
# 报告位置: report.html

# Allure 报告
python run.py --report allure
allure serve allure_results

# JUnit XML（CI 集成）
python run.py --report xml
# 报告位置: junit.xml
```

### 2.6 并行执行

```bash
python run.py --parallel
```

### 2.7 完整参数示例

```bash
python run.py \
  --module test_search \
  --base-url https://doc-search.openeuler.org \
  --source opengauss \
  --referer https://www.openeuler.org/ \
  --env prod \
  --report html \
  --verbose
```

---

## 三、参数调整说明

### 3.1 通过环境变量调整（推荐 CI 使用）

| 环境变量 | 默认值 | 说明 |
|---|---|---|
| `BASE_URL` | `https://doc-search.openeuler.org` | 目标服务地址 |
| `REFERER` | `https://www.openeuler.org/` | Referer 请求头（白名单校验） |
| `SOURCE` | `openeuler` | 多社区标识（opengauss/mindspore/ubmc/openfuyao/hifloat） |
| `CONNECT_TIMEOUT` | `10` | TCP 连接超时（秒） |
| `READ_TIMEOUT` | `30` | 响应读取超时（秒） |
| `MAX_RETRIES` | `3` | 请求重试次数 |
| `RETRY_DELAY` | `1.0` | 重试间隔（秒） |
| `CASE_INTERVAL` | `0.5` | 用例间执行间隔（秒），防限流 |
| `LOG_LEVEL` | `INFO` | 日志级别（DEBUG/INFO/WARNING/ERROR） |
| `LOG_FILE` | `` | 日志文件路径，空则只输出控制台 |
| `ENV_NAME` | `openeuler-prod` | 环境标识（写入报告） |

**Linux/macOS 示例：**

```bash
export BASE_URL=https://doc-search.openeuler.org
export SOURCE=opengauss
export MAX_RETRIES=5
export LOG_LEVEL=DEBUG
pytest -v
```

**Windows CMD 示例：**

```cmd
set BASE_URL=https://doc-search.openeuler.org
set SOURCE=opengauss
pytest test_cases\ -v
```

**Windows PowerShell 示例：**

```powershell
$env:BASE_URL="https://doc-search.openeuler.org"
$env:SOURCE="opengauss"
pytest test_cases\ -v
```

### 3.2 通过 `run.py` 命令行参数调整

```bash
python run.py --base-url https://doc-search.openeuler.org --source opengauss --referer https://www.openeuler.org/
```

### 3.3 修改 `settings.py`

如需持久化调整，直接编辑 `settings.py` 中的默认值。

---

## 四、测试数据扩展

所有接口的测试参数集中在 `test_data.json`，按 `接口名 -> positive_cases / negative_cases` 组织：

```json
{
  "search": {
    "docs": {
      "positive_cases": [
        {
          "case_id": "SEARCH-DOCS-001",
          "desc": "标准文档检索-中文",
          "body": { "lang": "zh", "keyword": "kernel", "page": 1, "pageSize": 12 },
          "expected_business_status": 200
        }
      ],
      "negative_cases": [
        {
          "case_id": "SEARCH-DOCS-101",
          "desc": "缺少必填字段 lang",
          "body": { "keyword": "kernel" },
          "expected_business_status": 400
        }
      ]
    }
  }
}
```

新增用例时，只需在 JSON 中追加 case 对象，`test_search.py` 会自动通过 `pytest.mark.parametrize` 遍历执行。

---

## 五、断言体系说明

| 断言类型 | 说明 | 对应函数 |
|---|---|---|
| HTTP 状态码 | 校验响应 HTTP status（如 200/404/500） | `assert_http_status` |
| 业务状态码 | 校验 body 中的 `status` / `code` 字段 | `assert_business_status` |
| 字段存在性 | 校验指定 key 是否存在 | `assert_field_exists` |
| 字段数据类型 | 校验字段类型（int/str/list/dict） | `assert_field_type` |
| 非空断言 | 校验值不为 None | `assert_not_none` |
| 列表非空 | 校验列表有元素 | `assert_list_not_empty` |
| 字符串包含 | 校验子串存在 | `assert_contains` |

单条用例失败**不会中断**整体测试；最终通过 pytest 的 `--continue-on-collection-errors` 及异常捕获保证全量执行。

---

## 六、日志说明

- **INFO**：请求发送、响应摘要、断言通过信息
- **ERROR**：断言失败、超时、连接错误、异常堆栈

每条日志均包含用例编号，便于快速定位问题。

---

## 七、接口覆盖清单

| # | 接口路径 | 方法 | 所在模块 |
|---|---|---|---|
| 1 | `/search/docs` | POST | test_search.py |
| 2 | `/search/docsng` | POST | test_search.py |
| 3 | `/search/sugg` | POST | test_search.py |
| 4 | `/search/count` | POST | test_search.py |
| 5 | `/search/pop` | POST | test_search.py |
| 6 | `/search/sort` | POST | test_search.py |
| 7 | `/search/tags` | POST | test_search.py |
| 8 | `/search/word` | POST | test_search.py |
| 9 | `/search/webword` | POST | test_search.py |
| 10 | `/search/nps` | POST | test_search.py |
| 11 | `/search/multitimodal` | POST | test_search.py |
| 12 | `/search/sort/{type}` | POST | test_sort.py |
| 13 | `/search/sort/docs` | POST | test_sort.py |
| 14 | `/search/sort/upload/image` | POST | test_sort.py |
| 15 | `/search/sig/name` | GET | test_jumper.py |
| 16 | `/search/sig/readme` | GET | test_jumper.py |
| 17 | `/search/all` | GET | test_jumper.py |
| 18 | `/search/stars` | GET | test_jumper.py |
| 19 | `/search/ecosystem/repo/info` | GET | test_jumper.py |
| 20 | `/software/docs` | POST | test_software.py |
| 21 | `/software/count` | POST | test_software.py |
| 22 | `/software/docsAll` | POST | test_software.py |
| 23 | `/sigsearch/docs` | POST | test_sig.py |

---

## 八、常见问题

1. **返回 403 / 被拒绝**
   - 检查 `Referer` 头是否在白名单内，通过 `--referer` 或 `REFERER` 环境变量调整。

2. **`/software/**` 全 404**
   - 服务端 `controller.enabled.easysoftware` 开关未开启，不是脚本问题。

3. **触发限流**
   - 增大 `CASE_INTERVAL`（如设为 `2.0`），降低请求频率。

4. **图片上传失败（201）**
   - 服务端缺少 OBS / 图片审核配置，属于环境依赖问题。

5. **多社区接口返回 `not supported currently source`**
   - 对照 `API-common.md` 的社区支持矩阵，确认该端点是否支持当前 `source`。

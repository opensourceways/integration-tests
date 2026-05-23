# Meeting Fixtures：登录 / 建会 / 删会 setup-teardown 完整模板

本文档给出 Meeting Server 用例三大前置/后置动作的标准实现，覆盖 Markdown 模式下的 `agent-exec` YAML 块与 Python 模式下的 pytest fixture。**生成用例时必须严格按本文档的 schema 与实现填充**，不要自行发明字段。

## 目录

- [1. 占位符计算规则](#1-占位符计算规则)
- [2. setup.login —— 登录拿 token + cookies](#2-setuplogin--登录拿-token--cookies)
- [3. setup.create_meeting —— 创建测试专用会议](#3-setupcreate_meeting--创建测试专用会议)
- [4. teardown.delete_meeting —— 强制清理会议](#4-teardowndelete_meeting--强制清理会议)
- [5. Python 模式完整 fixture 实现](#5-python-模式完整-fixture-实现)
- [6. 完整 agent-exec 范例（Markdown 模式）](#6-完整-agent-exec-范例markdown-模式)

---

## 1. 占位符计算规则

| 占位符 | 计算时机 | 计算方式 |
|---|---|---|
| `{{TEST_ACCOUNT}}` | 进入 setup.login 时 | `os.environ["TEST_ACCOUNT"]`；缺失则用例直接 SKIP 并报"未设置环境变量 TEST_ACCOUNT" |
| `{{TEST_PASSWORD}}` | 进入 setup.login 时 | `os.environ["TEST_PASSWORD"]`；缺失则用例直接 SKIP |
| `{{NEXT_MONTH_FIRST_DAY}}` | 进入 setup.create_meeting 前 | 见下方代码 |
| `{{TOKEN}}` | setup.login 完成后捕获 | login 响应 `body.data.token`，或 Set-Cookie 中 `_U_T_`（两者一致时用前者） |
| `{{YG}}` | setup.login 完成后捕获 | 登录响应 Set-Cookie 中 `_Y_G_` 的值 |
| `{{MEETING_ID}}` | setup.create_meeting 完成后捕获 | 建会响应 `body.data.id`（部分版本为 `body.data.meetingId`，取存在的那个） |
| `{{TC_ID}}` | 用例渲染时 | 当前用例 ID 字面量 |
| `{{TS}}` | setup.create_meeting 时 | `int(time.time())` |

**次月 1 号计算（纯 stdlib，禁用第三方库以保证可移植）**：

```python
from datetime import date

def next_month_first_day() -> str:
    """返回当前日期所在月的次月 1 号 YYYY-MM-DD"""
    today = date.today()
    if today.month == 12:
        return date(today.year + 1, 1, 1).strftime("%Y-%m-%d")
    return date(today.year, today.month + 1, 1).strftime("%Y-%m-%d")
```

---

## 2. setup.login —— 登录拿 token + cookies

### 2.1 登录流程（实测自 services/meeting-server/base_community/conftest.py）

1. `GET https://usercenter.openubmc.test.osinfra.cn/oneid/public/key` → 取 RSA 公钥 PEM
2. 用 RSA PKCS1v15 加密 `${TEST_PASSWORD}` 明文，结果转 hex 字符串
3. `POST https://usercenter.openubmc.test.osinfra.cn/oneid/login`，body：
   ```json
   {
     "permission": "sigRead",
     "account": "${TEST_ACCOUNT}",
     "client_id": "672b25d8b92861baa16ce1e3",
     "redirect_uri": "https://openubmc-website.test.osinfra.cn/personal/meeting",
     "password": "<hex-encrypted-password>",
     "oneidPrivacyAccepted": "20240830"
   }
   ```
4. 从响应捕获：
   - `{{TOKEN}}` ← `body.data.token`（若 Set-Cookie 中 `_U_T_` 与之不一致，以 `_U_T_` 为准）
   - `{{YG}}` ← Set-Cookie 中 `_Y_G_` 的值
5. 业务接口请求时同时携带 `Header: token: {{TOKEN}}` + `Cookie: _U_T_={{TOKEN}}; _Y_G_={{YG}}`，**两者缺一即 401**

### 2.2 agent-exec YAML schema

```yaml
setup:
  login:
    account_env: TEST_ACCOUNT          # 环境变量名，固定
    password_env: TEST_PASSWORD        # 环境变量名，固定
    base_auth_url: https://usercenter.openubmc.test.osinfra.cn
    client_id: 672b25d8b92861baa16ce1e3
    redirect_uri: https://openubmc-website.test.osinfra.cn/personal/meeting
    capture:
      TOKEN: $.data.token              # 或 cookie._U_T_，取存在者
      YG: cookie._Y_G_
    on_missing_env: skip               # 环境变量缺失时 SKIP 用例（不要 FAIL）
```

### 2.3 校验断言

login 步骤本身的隐含断言（执行器自动校验，无需用例显式写）：

- `http_status == 200`
- `body.code == 200`
- `body.data.token` 非空且长度 ≥ 32
- Set-Cookie 中含 `_Y_G_`

任一失败 → 用例 SKIP（不是 FAIL，避免一次环境抖动连带 30 条用例红）。

---

## 3. setup.create_meeting —— 创建测试专用会议

### 3.1 接口

`POST https://openubmc-website.test.osinfra.cn/api-meeting/v1/meeting/`

请求头：`token: {{TOKEN}}` + `Content-Type: application/json;charset=UTF-8`
请求 cookie：`_U_T_={{TOKEN}}; _Y_G_={{YG}}`

请求体（最小可成功集，所有 setup 建会都用这一套基线，需求未明示的字段不要乱加）：

```json
{
  "is_record": false,
  "is_cycle": false,
  "agenda": "auto-test-precondition",
  "email_list": "",
  "platform": "WELINK",
  "topic": "testcase-{{TC_ID}}-{{TS}}",
  "group_name": "infrastructure",
  "etherpad": "https://etherpad.openubmc.cn/p/infrastructrue",
  "date": "{{NEXT_MONTH_FIRST_DAY}}",
  "start": "10:00",
  "time": "10:00-10:30",
  "end": "10:30"
}
```

**字段说明**：

| 字段 | 取值约定 | 为什么 |
|---|---|---|
| `topic` | `testcase-{{TC_ID}}-{{TS}}` | 用例 ID + 时间戳，并发执行不撞主题 |
| `date` | `{{NEXT_MONTH_FIRST_DAY}}` | **强制次月 1 号**，避开"进行中会议禁止删除"等保护逻辑 |
| `start` / `end` / `time` | `10:00 / 10:30 / 10:00-10:30` | 30 分钟时间窗即可；同一天可起多场，但建议每条用例 setup 时把 start 错峰 +N 分钟，避免同会议室冲突 |
| `is_cycle` | `false` | 默认单次；周期会议用例（CYCLE 模块）才置 true 并补 cycle 字段 |
| `platform` / `group_name` / `etherpad` | 取 base_community 默认值 | 与现存 conftest.py 保持一致，便于排障 |

### 3.2 agent-exec YAML schema

```yaml
setup:
  create_meeting:
    base_biz_url: https://openubmc-website.test.osinfra.cn
    path: /api-meeting/v1/meeting/
    body:
      is_record: false
      is_cycle: false
      agenda: auto-test-precondition
      email_list: ""
      platform: WELINK
      topic: 'testcase-{{TC_ID}}-{{TS}}'
      group_name: infrastructure
      etherpad: https://etherpad.openubmc.cn/p/infrastructrue
      date: '{{NEXT_MONTH_FIRST_DAY}}'
      start: '10:00'
      time: '10:00-10:30'
      end: '10:30'
    capture:
      MEETING_ID: $.data.id          # 部分版本字段名为 meetingId，执行器需兼容两者
    expect:
      http_status: 200
      jsonpath: $.code
      equals: 200
    on_failure: skip                  # setup 失败 → 用例 SKIP（不是 FAIL）
```

### 3.3 何时**不要**调用 create_meeting

- 用例就是测「创建会议」本身（CREATE 模块的正向用例 / 异常用例）：被测对象 = 创建动作，不应在 setup 里再建一个。
- 鉴权类用例（无 token / 错 token）：根本不该 setup 成功，否则掩盖被测点。

---

## 4. teardown.delete_meeting —— 强制清理会议

### 4.1 接口

`DELETE https://openubmc-website.test.osinfra.cn/api-meeting/v1/meeting/{meeting_id}/`

请求头/cookie 同上（用 setup 阶段捕获到的 `{{TOKEN}}` / `{{YG}}`）。

### 4.2 agent-exec YAML schema

```yaml
teardown:
  always_run: true                    # 不论 steps 成败/异常，强制执行
  delete_meeting:
    base_biz_url: https://openubmc-website.test.osinfra.cn
    path: /api-meeting/v1/meeting/{{MEETING_ID}}/
    method: DELETE
    ignore_errors: true               # 已被 steps 删过返回 404 时不报错
    expected_status:                  # 软断言：以下任一即视为清理成功
      - 200
      - 404
```

### 4.3 何时 **必须** 带 ignore_errors=true

- 被测操作就是「删除会议」（DELETE 模块）：steps 已经把会议删了，teardown 再删一次必然 404，必须忽略
- 异常用例 setup 阶段捕获到 `{{MEETING_ID}}` 后 steps 抛错：teardown 仍须尝试删，删不到也不抛
- 凡用例标题含 `[异常]` `[边界]` `[空值]` 维度的：一律建议带 `ignore_errors: true`

### 4.4 何时 **不要** 写 teardown

- 用例 setup 没有 create_meeting（如鉴权类、CREATE 异常类）：没建过就不需要清
- CREATE 正向用例：steps 创建了会议 → teardown 用 steps 捕获到的 meeting_id 清理（teardown 仍要写，但 meeting_id 来自 steps 的 capture，不是 setup）

---

## 5. Python 模式完整 fixture 实现

Python 模式生成的 `.py` 文件中，三套 fixture 必须同时具备。建议放在与用例同目录的 `conftest.py`（若已存在，按"差异最小"原则增量改）。

```python
# conftest.py —— Meeting Server 测试通用 fixture
import os
import json
import time
import requests
import pytest
from datetime import date
from cryptography.hazmat.primitives.asymmetric import padding as _rsa_padding
from cryptography.hazmat.primitives.serialization import load_pem_public_key as _load_pem

BASE_AUTH = "https://usercenter.openubmc.test.osinfra.cn"
BASE_BIZ = "https://openubmc-website.test.osinfra.cn"
CLIENT_ID = "672b25d8b92861baa16ce1e3"
REDIRECT_URI = f"{BASE_BIZ}/personal/meeting"
PATH_MEETING = "/api-meeting/v1/meeting/"


def next_month_first_day() -> str:
    today = date.today()
    if today.month == 12:
        return date(today.year + 1, 1, 1).strftime("%Y-%m-%d")
    return date(today.year, today.month + 1, 1).strftime("%Y-%m-%d")


@pytest.fixture(scope="session")
def login_creds():
    """登录拿 {token, yg}，强制使用 TEST_ACCOUNT / TEST_PASSWORD 环境变量"""
    account = os.environ.get("TEST_ACCOUNT")
    password = os.environ.get("TEST_PASSWORD")
    if not account or not password:
        pytest.skip("未设置环境变量 TEST_ACCOUNT / TEST_PASSWORD")

    # 1) 取公钥
    pk_resp = requests.get(f"{BASE_AUTH}/oneid/public/key", verify=False, timeout=30)
    pk_resp.raise_for_status()
    pub_pem = pk_resp.json()["data"]["rsa"]["publicKey"]

    # 2) RSA 加密
    key = _load_pem(pub_pem.encode("utf-8"))
    enc_hex = key.encrypt(password.encode("utf-8"), _rsa_padding.PKCS1v15()).hex()

    # 3) 登录
    sess = requests.Session()
    body = {
        "permission": "sigRead",
        "account": account,
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "password": enc_hex,
        "oneidPrivacyAccepted": "20240830",
    }
    resp = sess.post(f"{BASE_AUTH}/oneid/login",
                     headers={"Content-Type": "application/json"},
                     data=json.dumps(body), verify=False, timeout=30)
    rj = resp.json()
    if resp.status_code != 200 or rj.get("code") != 200:
        pytest.skip(f"登录失败 status={resp.status_code} body={rj}")

    token = rj["data"]["token"]
    yg = sess.cookies.get("_Y_G_")
    ut = sess.cookies.get("_U_T_")
    if ut and ut != token:
        token = ut
    if not yg:
        pytest.skip("登录响应缺少 _Y_G_ cookie")
    return {"token": token, "yg": yg}


def biz_request(method, path, creds, **kwargs):
    headers = {
        "token": creds["token"],
        "Content-Type": "application/json;charset=UTF-8",
    }
    cookies = {"_U_T_": creds["token"], "_Y_G_": creds["yg"]}
    kwargs.setdefault("verify", False)
    kwargs.setdefault("timeout", 30)
    return requests.request(method, f"{BASE_BIZ}{path}",
                            headers=headers, cookies=cookies, **kwargs)


@pytest.fixture
def created_meeting(request, login_creds):
    """创建一个测试专用会议（次月 1 号），yield meeting_id；用例结束后强制清理。

    使用方式：
        def test_xxx(login_creds, created_meeting):
            mid = created_meeting
            # ...对 mid 做被测操作...
    """
    tc_id = request.node.name
    body = {
        "is_record": False,
        "is_cycle": False,
        "agenda": "auto-test-precondition",
        "email_list": "",
        "platform": "WELINK",
        "topic": f"testcase-{tc_id}-{int(time.time())}",
        "group_name": "infrastructure",
        "etherpad": "https://etherpad.openubmc.cn/p/infrastructrue",
        "date": next_month_first_day(),
        "start": "10:00",
        "time": "10:00-10:30",
        "end": "10:30",
    }
    resp = biz_request("POST", PATH_MEETING, login_creds, json=body)
    if resp.status_code != 200 or resp.json().get("code") != 200:
        pytest.skip(f"前置建会失败 status={resp.status_code} body={resp.text[:200]}")
    data = resp.json().get("data") or {}
    meeting_id = data.get("id") or data.get("meetingId")
    if not meeting_id:
        pytest.skip(f"建会响应缺少 meeting_id: {resp.text[:200]}")

    yield meeting_id

    # —— 强制清理（不论用例成败/异常）——
    try:
        biz_request("DELETE", f"{PATH_MEETING}{meeting_id}/", login_creds)
    except Exception as e:
        print(f"[Teardown][Warn] 清理会议 {meeting_id} 异常：{e}")
```

**用例侧调用模板**：

```python
def test_TC_MEETING_DELETE_001_normal(login_creds, created_meeting):
    """TC-MEETING-DELETE-001 [正常流] 删除已存在会议成功"""
    mid = created_meeting
    resp = biz_request("DELETE", f"/api-meeting/v1/meeting/{mid}/", login_creds)
    assert resp.status_code == 200
    assert resp.json()["code"] == 200
    # 删除后再删一次，期望 404 或同样 200——具体以接口契约为准
    # 注意：created_meeting fixture 的 teardown 也会再删一次，所以这里被测删除已经把会议清掉了，
    # teardown 兜底删除会拿到 404，但 fixture 已用 try/except 吞掉异常，不影响用例判定
```

---

## 6. 完整 agent-exec 范例（Markdown 模式）

### 6.1 删除会议（DELETE 模块，需要先建）

````markdown
| 用例ID | 模块 | 功能点 | 用例标题 | 前置条件 | 操作步骤 | 预期结果 | 优先级 |
|---|---|---|---|---|---|---|---|
| TC-MEETING-DELETE-001 | 会议管理 | 删除会议 | [正常流] 删除已存在的单次会议 | 1.已设置 TEST_ACCOUNT/TEST_PASSWORD 环境变量<br>2.前置建会成功，捕获 meeting_id | 1.调 DELETE /api-meeting/v1/meeting/{meeting_id}/ | 1.http 200<br>2.body.code=200<br>3.列表查询不再有该会议 | P0 |

```agent-exec
type: api
tool: curl
setup:
  login:
    account_env: TEST_ACCOUNT
    password_env: TEST_PASSWORD
    base_auth_url: https://usercenter.openubmc.test.osinfra.cn
    client_id: 672b25d8b92861baa16ce1e3
    redirect_uri: https://openubmc-website.test.osinfra.cn/personal/meeting
    capture:
      TOKEN: $.data.token
      YG: cookie._Y_G_
    on_missing_env: skip
  create_meeting:
    base_biz_url: https://openubmc-website.test.osinfra.cn
    path: /api-meeting/v1/meeting/
    body:
      is_record: false
      is_cycle: false
      agenda: auto-test-precondition
      email_list: ""
      platform: WELINK
      topic: 'testcase-TC-MEETING-DELETE-001-{{TS}}'
      group_name: infrastructure
      etherpad: https://etherpad.openubmc.cn/p/infrastructrue
      date: '{{NEXT_MONTH_FIRST_DAY}}'
      start: '10:00'
      time: '10:00-10:30'
      end: '10:30'
    capture:
      MEETING_ID: $.data.id
    on_failure: skip
request:
  method: DELETE
  url: https://openubmc-website.test.osinfra.cn/api-meeting/v1/meeting/{{MEETING_ID}}/
  headers:
    token: '{{TOKEN}}'
    Content-Type: application/json;charset=UTF-8
  cookies:
    _U_T_: '{{TOKEN}}'
    _Y_G_: '{{YG}}'
assertions:
  - http_status: 200
  - jsonpath: $.code
    equals: 200
teardown:
  always_run: true
  delete_meeting:
    base_biz_url: https://openubmc-website.test.osinfra.cn
    path: /api-meeting/v1/meeting/{{MEETING_ID}}/
    method: DELETE
    ignore_errors: true
    expected_status: [200, 404]
```
````

### 6.2 创建会议正向（CREATE 模块，不需要 setup 建会，但 steps 建完要清理）

````markdown
| TC-MEETING-CREATE-001 | 会议管理 | 创建会议 | [正常流] 合法字段创建单次会议返回会议 ID | 1.已设置 TEST_ACCOUNT/TEST_PASSWORD | 1.调 POST /api-meeting/v1/meeting/ | 1.http 200<br>2.body.code=200<br>3.body.data.id 非空 | P0 |

```agent-exec
type: api
tool: curl
setup:
  login:
    account_env: TEST_ACCOUNT
    password_env: TEST_PASSWORD
    capture: { TOKEN: $.data.token, YG: cookie._Y_G_ }
    on_missing_env: skip
request:
  method: POST
  url: https://openubmc-website.test.osinfra.cn/api-meeting/v1/meeting/
  headers:
    token: '{{TOKEN}}'
    Content-Type: application/json;charset=UTF-8
  cookies: { _U_T_: '{{TOKEN}}', _Y_G_: '{{YG}}' }
  body:
    is_record: false
    is_cycle: false
    agenda: auto-test-create
    email_list: ""
    platform: WELINK
    topic: 'testcase-TC-MEETING-CREATE-001-{{TS}}'
    group_name: infrastructure
    etherpad: https://etherpad.openubmc.cn/p/infrastructrue
    date: '{{NEXT_MONTH_FIRST_DAY}}'
    start: '10:00'
    time: '10:00-10:30'
    end: '10:30'
capture:                              # 从 steps 响应捕获 meeting_id 供 teardown 使用
  MEETING_ID: $.data.id
assertions:
  - http_status: 200
  - jsonpath: $.code
    equals: 200
  - jsonpath: $.data.id
    not_empty: true
teardown:
  always_run: true
  delete_meeting:
    path: /api-meeting/v1/meeting/{{MEETING_ID}}/
    method: DELETE
    ignore_errors: true
```
````

### 6.3 创建会议异常（不需要清理，因为没真正建成）

````markdown
| TC-MEETING-CREATE-101 | 会议管理 | 创建会议 | [边界值] topic 长度超过上限返回 400 | 1.已设置 TEST_ACCOUNT/TEST_PASSWORD | 1.调 POST /api-meeting/v1/meeting/ topic=128 字符 | 1.http 400<br>2.body.code != 200 | P1 |

```agent-exec
type: api
tool: curl
setup:
  login: { account_env: TEST_ACCOUNT, password_env: TEST_PASSWORD, on_missing_env: skip }
request:
  method: POST
  url: https://openubmc-website.test.osinfra.cn/api-meeting/v1/meeting/
  headers: { token: '{{TOKEN}}', Content-Type: 'application/json;charset=UTF-8' }
  cookies: { _U_T_: '{{TOKEN}}', _Y_G_: '{{YG}}' }
  body:
    topic: 'a' * 128                  # 超长，预期失败
    # 其他字段 ...
    date: '{{NEXT_MONTH_FIRST_DAY}}'
    start: '10:00'
    end: '10:30'
    time: '10:00-10:30'
assertions:
  - http_status: 400                   # 或具体业务码，按需求文档
# 无 teardown：未真正建成会议
```
````

# -*- coding: utf-8 -*-
"""
通用 HTTP 请求工具类
封装 requests，提供：
  - 统一请求头、鉴权信息注入
  - 超时控制
  - 请求重试（指数退避）
  - 异常捕获（连接超时、服务器错误、请求拒绝等）
  - 响应统一封装
"""
import time
import json
from typing import Optional, Dict, Any, Union

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

import settings
from logger import get_logger

logger = get_logger(__name__)


class ApiResponse:
    """接口响应封装对象"""

    def __init__(self, raw_response: Optional[requests.Response] = None, error: Optional[str] = None):
        self.raw = raw_response
        self.error = error
        # 注意：requests.Response 的 __bool__ 基于 self.ok（2xx 才为 True），
        # 因此必须用 `is not None` 判断，不能用 `if raw_response`
        self.http_status: int = raw_response.status_code if raw_response is not None else 0
        self.headers: Dict[str, str] = dict(raw_response.headers) if raw_response is not None else {}
        self.text: str = raw_response.text if raw_response is not None else ""
        self.json_data: Optional[Union[Dict, list]] = None
        self.latency_ms: float = 0.0  # 请求耗时（毫秒）

        if raw_response is not None:
            try:
                self.json_data = raw_response.json()
            except Exception:
                self.json_data = None

    @property
    def ok(self) -> bool:
        """HTTP 层是否成功（2xx）"""
        return self.raw is not None and 200 <= self.http_status < 300

    @property
    def business_status(self) -> Optional[int]:
        """
        提取业务状态码
        支持 SysResult（status）、SysCode（code）、ResponceResult（status）等形态
        """
        if not isinstance(self.json_data, dict):
            return None
        # 按优先级尝试提取
        for key in ("status", "code"):
            val = self.json_data.get(key)
            if isinstance(val, int):
                return val
        return None

    @property
    def business_msg(self) -> str:
        """提取业务提示消息"""
        if not isinstance(self.json_data, dict):
            return ""
        return self.json_data.get("msg") or self.json_data.get("message") or ""

    @property
    def data(self) -> Any:
        """
        提取数据体
        支持 obj / data / result 等字段名
        """
        if not isinstance(self.json_data, dict):
            return None
        for key in ("obj", "data", "result"):
            if key in self.json_data:
                return self.json_data[key]
        return None

    def __repr__(self) -> str:
        if self.error:
            return f"<ApiResponse error={self.error}>"
        return f"<ApiResponse http_status={self.http_status} business_status={self.business_status}>"


class RequestClient:
    """通用 HTTP 客户端"""

    def __init__(self):
        self.session = requests.Session()
        self.base_url = settings.BASE_URL.rstrip("/")
        self.headers = dict(settings.DEFAULT_HEADERS)

        # 自动从 base_url 提取 Host 并注入请求头（部分服务端会显式校验）
        from urllib.parse import urlparse
        parsed = urlparse(self.base_url)
        if parsed.hostname:
            self.headers["Host"] = parsed.hostname

        # 如果配置了 source 头（多社区分支），自动注入
        if getattr(settings, "SOURCE", None):
            self.headers["source"] = settings.SOURCE

        # 配置连接池与重试策略
        retry_strategy = Retry(
            total=settings.MAX_RETRIES,
            backoff_factor=settings.RETRY_DELAY,
            status_forcelist=[500, 502, 503, 504],  # 仅对服务器错误重试
            allowed_methods=["HEAD", "GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
        )
        adapter = HTTPAdapter(max_retries=retry_strategy, pool_connections=10, pool_maxsize=20)
        self.session.mount("https://", adapter)
        self.session.mount("http://", adapter)

        logger.info(f"[RequestClient] initialized | base_url={self.base_url} | retries={settings.MAX_RETRIES}")

    def _build_url(self, path: str) -> str:
        """拼接完整 URL"""
        if path.startswith(("http://", "https://")):
            return path
        return f"{self.base_url}/{path.lstrip('/')}"

    def _merge_headers(self, extra: Optional[Dict[str, str]]) -> Dict[str, str]:
        """合并请求头，extra 优先级更高；过滤掉值为空的头"""
        merged = dict(self.headers)
        if extra:
            merged.update(extra)
        # 过滤掉值为空字符串的 header，避免发送无效头导致服务端拒绝
        return {k: v for k, v in merged.items() if v != ""}

    def request(
        self,
        method: str,
        path: str,
        *,
        params: Optional[Dict[str, Any]] = None,
        json_data: Optional[Dict[str, Any]] = None,
        data: Optional[Union[Dict, str, bytes]] = None,
        files: Optional[Dict[str, Any]] = None,
        headers: Optional[Dict[str, str]] = None,
        timeout: Optional[tuple] = None,
        **kwargs,
    ) -> ApiResponse:
        """
        发送 HTTP 请求

        :param method: HTTP 方法，如 GET / POST / PUT / DELETE
        :param path: 接口路径（相对或绝对）
        :param params: URL query 参数
        :param json_data: JSON body（自动序列化）
        :param data: form / raw body
        :param files: 文件上传
        :param headers: 额外请求头
        :param timeout: (connect_timeout, read_timeout)，默认取 settings
        :return: ApiResponse 封装对象
        """
        url = self._build_url(path)
        merged_headers = self._merge_headers(headers)

        if timeout is None:
            timeout = (settings.CONNECT_TIMEOUT, settings.READ_TIMEOUT)

        # 根据是否有文件上传调整 headers
        if files and "Content-Type" in merged_headers:
            # multipart/form-data 由 requests 自动设置边界，需删除固定 Content-Type
            del merged_headers["Content-Type"]

        logger.info(
            f"[REQUEST] {method.upper()} {url} | "
            f"params={json.dumps(params, ensure_ascii=False) if params else None} | "
            f"headers={json.dumps({k: v for k, v in merged_headers.items() if k.lower() not in ('token', 'authorization')}, ensure_ascii=False)}"
        )

        start_time = time.time()
        try:
            resp = self.session.request(
                method=method.upper(),
                url=url,
                params=params,
                json=json_data,
                data=data,
                files=files,
                headers=merged_headers,
                timeout=timeout,
                **kwargs,
            )
            latency = (time.time() - start_time) * 1000

            api_resp = ApiResponse(raw_response=resp)
            api_resp.latency_ms = latency

            # 记录响应摘要（脱敏）
            body_preview = api_resp.text[:500] if api_resp.text else ""
            logger.info(
                f"[RESPONSE] {method.upper()} {url} | "
                f"http_status={api_resp.http_status} | "
                f"business_status={api_resp.business_status} | "
                f"latency={latency:.1f}ms | "
                f"body_preview={body_preview}"
            )
            return api_resp

        except requests.exceptions.Timeout as e:
            latency = (time.time() - start_time) * 1000
            logger.error(f"[ERROR] {method.upper()} {url} | 请求超时 | timeout={timeout}s | detail={str(e)}")
            return ApiResponse(error=f"Timeout: {str(e)}")

        except requests.exceptions.ConnectionError as e:
            latency = (time.time() - start_time) * 1000
            logger.error(f"[ERROR] {method.upper()} {url} | 连接错误 | detail={str(e)}")
            return ApiResponse(error=f"ConnectionError: {str(e)}")

        except requests.exceptions.HTTPError as e:
            latency = (time.time() - start_time) * 1000
            logger.error(f"[ERROR] {method.upper()} {url} | HTTP 错误 | detail={str(e)}")
            return ApiResponse(error=f"HTTPError: {str(e)}")

        except requests.exceptions.RequestException as e:
            latency = (time.time() - start_time) * 1000
            logger.error(f"[ERROR] {method.upper()} {url} | 请求异常 | detail={str(e)}")
            return ApiResponse(error=f"RequestException: {str(e)}")

        except Exception as e:
            latency = (time.time() - start_time) * 1000
            logger.error(f"[ERROR] {method.upper()} {url} | 未知异常 | detail={str(e)}")
            return ApiResponse(error=f"Unknown: {str(e)}")

    # 便捷方法
    def get(self, path: str, **kwargs) -> ApiResponse:
        return self.request("GET", path, **kwargs)

    def post(self, path: str, **kwargs) -> ApiResponse:
        return self.request("POST", path, **kwargs)

    def put(self, path: str, **kwargs) -> ApiResponse:
        return self.request("PUT", path, **kwargs)

    def delete(self, path: str, **kwargs) -> ApiResponse:
        return self.request("DELETE", path, **kwargs)

    def close(self):
        """关闭 session，释放连接池"""
        self.session.close()

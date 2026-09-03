"""
utils.py
接口自动化测试工具模块
提供：ApiParser（API解析）、RequestBuilder（请求构建）、ResponseValidator（响应验证）
"""
import json
import os
import random
import re
import string
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional


# ==================== 数据模型 ====================

@dataclass
class ApiParameter:
    """API 参数定义"""
    name: str
    value: Any = None
    description: Optional[str] = None
    required: bool = False
    dataType: str = "String"
    type: Optional[str] = None
    defaultValue: Any = None
    validateType: Optional[str] = None
    error: Optional[str] = None
    expression: Optional[str] = None
    children: List[Any] = field(default_factory=list)

    @classmethod
    def from_dict(cls, d: dict) -> "ApiParameter":
        return cls(
            name=d.get("name", ""),
            value=d.get("value"),
            description=d.get("description"),
            required=d.get("required", False),
            dataType=d.get("dataType", "String"),
            type=d.get("type"),
            defaultValue=d.get("defaultValue"),
            validateType=d.get("validateType"),
            error=d.get("error"),
            expression=d.get("expression"),
            children=d.get("children") or [],
        )


@dataclass
class ApiInfo:
    """API 接口信息"""
    module_name: str
    name: str
    method: str
    full_path: str
    parameters: List[ApiParameter] = field(default_factory=list)
    headers: List[ApiParameter] = field(default_factory=list)
    paths: List[ApiParameter] = field(default_factory=list)
    requestBody: str = ""
    responseBody: str = ""
    has_response_body: bool = False
    response_body_definition: Optional[dict] = None
    requestBodyDefinition: Optional[dict] = None

    @property
    def required_params(self) -> List[ApiParameter]:
        return [p for p in self.parameters if p.required]

    @property
    def validated_params(self) -> List[ApiParameter]:
        """
        真正带校验规则的参数。
        排除两类无法构造"非法值"的情况：
        - validateType='pass'：接口定义显式声明不做校验
        - expression 为空：没有具体规则可违反
        """
        return [
            p for p in self.parameters
            if p.validateType in ("pattern", "expression") and p.expression
        ]


# ==================== ApiParser ====================

class ApiParser:
    """解析 api 目录下的接口定义文件（MeterSphere .ms 格式 + group.json）"""

    def __init__(self, api_root: str):
        self.api_root = api_root

    def parse_all(self) -> List[ApiInfo]:
        """遍历 api_root 下所有模块，解析接口定义"""
        apis = []
        if not os.path.isdir(self.api_root):
            return apis

        for entry in sorted(os.listdir(self.api_root)):
            module_path = os.path.join(self.api_root, entry)
            if not os.path.isdir(module_path):
                continue
            # module_name 固定为顶层目录名，便于 --module 过滤
            self._collect(module_path, module_name=entry, parent_prefix="", apis=apis)

        return apis

    def _collect(self, dir_path: str, module_name: str, parent_prefix: str, apis: List[ApiInfo]):
        """递归收集目录（含子分组）下的接口定义"""
        group_info = self._parse_group(dir_path)
        group_path = group_info.get("path", "") if group_info else ""
        prefix = self._join_path(parent_prefix, group_path)

        for name in sorted(os.listdir(dir_path)):
            item = os.path.join(dir_path, name)
            if os.path.isdir(item):
                self._collect(item, module_name, prefix, apis)
            elif name.endswith(".ms"):
                api = self._parse_ms_file(item, module_name, prefix)
                if api:
                    apis.append(api)

    @staticmethod
    def _join_path(*segments: str) -> str:
        """
        安全拼接 URL 路径片段。
        接口定义中 group path 与接口 path 都可能缺少/多余前导斜杠，
        统一规整为以 / 开头、片段间单斜杠的形式。
        """
        parts = [s.strip("/") for s in segments if s and s.strip("/")]
        return "/" + "/".join(parts) if parts else "/"

    @staticmethod
    def _fill_path_params(full_path: str, paths: List[ApiParameter]) -> str:
        """用 paths 定义中的示例值替换 URL 中的 {name} 占位符"""
        if "{" not in full_path:
            return full_path

        lookup = {p.name: p for p in paths if p.name}

        def _replace(match):
            key = match.group(1)
            param = lookup.get(key)
            if param is not None:
                val = param.value if param.value not in (None, "") else param.defaultValue
                if val not in (None, ""):
                    return str(val)
            # 定义中未提供示例值时，按数据类型给一个占位值
            return "1"

        return re.sub(r"\{(\w+)\}", _replace, full_path)

    def _parse_group(self, module_path: str) -> Optional[dict]:
        """解析模块下的 group.json"""
        group_file = os.path.join(module_path, "group.json")
        if not os.path.exists(group_file):
            return None
        try:
            with open(group_file, "r", encoding="utf-8") as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            return None

    def _parse_ms_file(self, filepath: str, module_name: str, group_prefix: str) -> Optional[ApiInfo]:
        """解析 .ms 文件：JSON 定义 + 脚本，用 ==== 分隔"""
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
        except IOError:
            return None

        # 分离 JSON 和脚本部分
        parts = content.split("================================", 1)
        json_part = parts[0].strip()

        try:
            data = json.loads(json_part)
        except json.JSONDecodeError:
            return None

        path = data.get("path", "")
        # 拼接完整路径（group path 与接口 path 都可能缺少前导 / ）
        full_path = self._join_path(group_prefix, path)

        # 解析参数
        parameters = [ApiParameter.from_dict(p) for p in data.get("parameters") or []]
        headers = [ApiParameter.from_dict(h) for h in data.get("headers") or []]
        paths = [ApiParameter.from_dict(p) for p in data.get("paths") or []]

        # 替换路径占位符 /threads/{id}/state -> /threads/546323/state
        full_path = self._fill_path_params(full_path, paths)

        response_body = data.get("responseBody", "")
        has_response_body = bool(response_body)

        return ApiInfo(
            module_name=module_name,
            name=data.get("name", ""),
            method=data.get("method", "GET").upper(),
            full_path=full_path,
            parameters=parameters,
            headers=headers,
            paths=paths,
            requestBody=data.get("requestBody", ""),
            responseBody=response_body,
            has_response_body=has_response_body,
            response_body_definition=data.get("responseBodyDefinition"),
            requestBodyDefinition=data.get("requestBodyDefinition"),
        )


# ==================== RequestBuilder ====================

class RequestBuilder:
    """构建 HTTP 请求参数和请求体"""

    @staticmethod
    def get_headers(api: ApiInfo) -> Dict[str, str]:
        """从接口定义中提取自定义 headers"""
        headers = {}
        for h in api.headers:
            if h.name and h.value is not None:
                headers[h.name] = str(h.value)
        return headers

    @staticmethod
    def build_url_params(api: ApiInfo, fill_required: bool = True) -> Dict[str, Any]:
        """
        构建 URL 查询参数
        :param fill_required: True=只填充必填参数, False=填充所有参数
        """
        params = {}
        for p in api.parameters:
            if fill_required and not p.required:
                continue
            val = RequestBuilder._generate_value(p)
            if val is not None:
                params[p.name] = val
        return params

    @staticmethod
    def build_request_body(api: ApiInfo) -> Optional[Dict[str, Any]]:
        """构建 POST/PUT 请求体（从 requestBodyDefinition 生成）"""
        if not api.requestBodyDefinition:
            # 尝试从 requestBody 字符串解析
            if api.requestBody:
                try:
                    return json.loads(api.requestBody)
                except json.JSONDecodeError:
                    return None
            return None

        return RequestBuilder._build_from_definition(api.requestBodyDefinition)

    @staticmethod
    def generate_invalid_value(param: ApiParameter) -> Any:
        """生成不符合校验规则的非法参数值"""
        data_type = (param.dataType or "String").lower()
        validate_type = param.validateType
        expression = param.expression

        # 根据校验类型生成非法值
        if validate_type == "pattern" and expression:
            # 生成不匹配正则的值
            return RequestBuilder._generate_non_matching_string(expression)

        if validate_type == "expression" and expression:
            # 表达式校验（如范围），生成明显越界的值
            if data_type in ("integer", "long", "int"):
                return -999999
            if data_type == "string":
                return ""
            return None

        # 默认：根据数据类型生成错误类型值
        if data_type in ("integer", "long", "int"):
            return "not_a_number"
        if data_type == "boolean":
            return "not_a_boolean"
        if data_type in ("float", "double", "number"):
            return "not_a_float"
        return ""

    @staticmethod
    def _generate_value(param: ApiParameter) -> Any:
        """根据参数定义生成一个合理的值"""
        # 优先使用默认值
        if param.defaultValue is not None:
            return RequestBuilder._convert_type(param.defaultValue, param.dataType)

        data_type = (param.dataType or "String").lower()
        validate_type = param.validateType
        expression = param.expression

        # 如果存在 pattern 校验，尝试生成匹配的值
        if validate_type == "pattern" and expression:
            matched = RequestBuilder._generate_matching_string(expression)
            if matched is not None:
                return matched

        # 根据数据类型生成默认值
        if data_type in ("string", "text"):
            return "test"
        if data_type in ("integer", "int"):
            return 1
        if data_type == "long":
            return 1730419200000
        if data_type == "boolean":
            return True
        if data_type in ("float", "double", "number"):
            return 1.0
        if data_type in ("array", "list"):
            return []
        if data_type == "object":
            return {}
        return "test"

    @staticmethod
    def _convert_type(value: Any, data_type: str) -> Any:
        """将值转换为对应数据类型"""
        if value is None:
            return None
        dt = (data_type or "String").lower()
        if dt in ("integer", "int", "long"):
            try:
                return int(value)
            except (ValueError, TypeError):
                return value
        if dt in ("float", "double", "number"):
            try:
                return float(value)
            except (ValueError, TypeError):
                return value
        if dt == "boolean":
            if isinstance(value, str):
                return value.lower() in ("true", "1", "yes", "on")
            return bool(value)
        return value

    @staticmethod
    def _build_from_definition(definition: dict) -> Dict[str, Any]:
        """从 requestBodyDefinition 递归构建请求体"""
        result = {}
        children = definition.get("children") or []
        for child in children:
            name = child.get("name")
            if not name:
                continue
            param = ApiParameter.from_dict(child)
            val = RequestBuilder._generate_value(param)
            if val is not None:
                result[name] = val
        return result

    @staticmethod
    def _generate_matching_string(pattern: str) -> Optional[str]:
        """根据正则表达式生成一个匹配的值（简单启发式）"""
        if not pattern:
            return "test"

        # 对于枚举类正则如 ^(openeuler|opengauss|openubmc)$
        enum_match = re.search(r"\^?\(([^)]+)\)\$?", pattern)
        if enum_match:
            options = enum_match.group(1).split("|")
            return options[0] if options else "test"

        # 对于简单字母限制 ^[a-zA-Z]{1,32}$
        if "a-zA-Z" in pattern:
            length = 1
            len_match = re.search(r"\{(\d+)(?:,\d*)?\}", pattern)
            if len_match:
                length = int(len_match.group(1))
            return "a" * min(length, 32)

        # 对于日期格式 ^(\d{4}-\d{2}-\d{2})?$
        if "\\d{4}" in pattern and "\\d{2}" in pattern:
            return "2024-01-01"

        # 对于特定值如 ^(openeuler)$
        val_match = re.search(r"\^?\(([^|)]+)\)\$?", pattern)
        if val_match:
            return val_match.group(1)

        return "test"

    @staticmethod
    def _generate_non_matching_string(pattern: str) -> str:
        """生成不匹配正则表达式的值"""
        if not pattern:
            return ""

        # 如果正则要求特定枚举值，返回不在列表中的值
        enum_match = re.search(r"\^?\(([^)]+)\)\$?", pattern)
        if enum_match:
            return "invalid_value_12345"

        # 如果要求纯字母，返回带数字的值
        if "a-zA-Z" in pattern and "0-9" not in pattern:
            return "12345"

        # 如果要求日期格式，返回非法格式
        if "\\d{4}" in pattern and "-" in pattern:
            return "not-a-date"

        # 如果要求数字，返回字母
        if "\\d" in pattern and "a-zA-Z" not in pattern:
            return "abc"

        return "!@#$%"


# ==================== ResponseValidator ====================

class ResponseValidator:
    """验证 HTTP 响应"""

    @staticmethod
    def validate_response_time(elapsed_ms: float, threshold_ms: int = 10000) -> List[str]:
        """验证响应时间，超过阈值返回错误信息"""
        if elapsed_ms > threshold_ms:
            return [f"响应时间超过阈值: {elapsed_ms:.0f}ms > {threshold_ms}ms"]
        return []

    @staticmethod
    def validate_json_schema(resp_json: dict, api: ApiInfo) -> List[str]:
        """
        验证响应 JSON 结构是否与接口定义一致
        目前做简单检查：如果接口定义了 responseBody，检查实际响应是否包含类似结构
        """
        errors = []
        if not isinstance(resp_json, dict):
            return ["响应不是 JSON 对象"]

        # 检查标准字段 code / message
        if "code" not in resp_json:
            errors.append("响应缺少 'code' 字段")
        if "message" not in resp_json:
            errors.append("响应缺少 'message' 字段")

        # 如果有 responseBodyDefinition，进行更详细的字段检查
        if api.response_body_definition:
            errors.extend(ResponseValidator._check_definition(resp_json, api.response_body_definition, ""))

        return errors

    @staticmethod
    def _check_definition(actual: Any, definition: dict, path: str) -> List[str]:
        """递归检查实际响应是否符合定义结构"""
        errors = []
        dtype = (definition.get("dataType") or "Object").lower()

        if dtype == "object":
            if not isinstance(actual, dict):
                errors.append(f"{path or 'root'}: 期望 Object，实际为 {type(actual).__name__}")
                return errors
            children = definition.get("children") or []
            for child in children:
                name = child.get("name")
                if not name:
                    continue
                child_path = f"{path}.{name}" if path else name
                if name not in actual:
                    if child.get("required"):
                        errors.append(f"{child_path}: 缺少必填字段")
                    continue
                errors.extend(ResponseValidator._check_definition(actual[name], child, child_path))

        elif dtype == "array":
            if not isinstance(actual, list):
                errors.append(f"{path or 'root'}: 期望 Array，实际为 {type(actual).__name__}")
                return errors
            # 简单检查：如果数组不为空，检查第一个元素
            if actual:
                item_def = definition.get("children") or []
                if item_def:
                    errors.extend(ResponseValidator._check_definition(actual[0], item_def[0], f"{path}[0]"))

        return errors

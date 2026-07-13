"""
retry_utils.py
通用重试工具：函数级重试装饰器，支持指数退避
"""

import time
import functools
from typing import Callable, Optional, Type

from logger import get_logger

logger = get_logger(__name__)


def retry(
    max_attempts: int = 3,
    delay: float = 1.0,
    backoff: float = 2.0,
    exceptions: tuple[Type[Exception], ...] = (Exception,),
    on_failure: Optional[Callable] = None,
):
    """
    通用重试装饰器
    """
    def decorator(func: Callable):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            current_delay = delay
            last_exception = None

            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except exceptions as e:
                    last_exception = e
                    logger.warning(f"[重试] {func.__name__} | {attempt}/{max_attempts} | {e}")
                    if attempt < max_attempts:
                        time.sleep(current_delay)
                        current_delay *= backoff

            if on_failure:
                on_failure(last_exception)
            raise last_exception

        return wrapper
    return decorator

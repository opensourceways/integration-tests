import sys
from pathlib import Path

# 记录所有导入的本地模块
imported = set()

class ImportTracer:
    def find_module(self, fullname, path=None):
        if fullname.startswith(('common', 'tests', 'token_manager', 
                                'email_verify', 'slider_solver', 'slider_token')):
            imported.add(fullname)
        return None

sys.meta_path.insert(0, ImportTracer())

# 模拟执行 test_cases.py（但不真跑测试）
import pytest
sys.argv = ['test_cases.py', '--collect-only', '-q']
pytest.main(['tests/', '--collect-only', '-q'])

print("=== test_cases.py 引用的本地模块 ===")
for mod in sorted(imported):
    print(f"  {mod}")

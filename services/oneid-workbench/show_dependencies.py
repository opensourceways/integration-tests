#!/usr/bin/env python3
"""展示 test_cases.py 的文件依赖链"""

dependencies = {
    "test_cases.py": ["tests/"],
    
    "tests/": [
        "tests/conftest.py",
        "tests/helpers.py", 
        "tests/test_boundary.py",
        "tests/test_error_cases.py",
        "tests/test_normal_operations.py",
        "tests/test_validation.py"
    ],
    
    "tests/conftest.py": [
        "token_manager.py",
        "common/constants.py",
        "common/browser_helper.py",
        "common/debug_utils.py"
    ],
    
    "tests/helpers.py": [
        "common/debug_utils.py"
    ],
    
    "tests/test_*.py": [
        "token_manager.py",
        "common/constants.py",
        "common/debug_utils.py",
        "common/exceptions.py"
    ],
    
    "token_manager.py": [
        "common/constants.py",
        "common/config.py",
        "common/browser_helper.py",
        "common/auth_helper.py",
        "common/identity_verify.py",
        "common/token_operations.py",
        "common/element_actions.py",
        "common/debug_utils.py",
        "common/exceptions.py",
        "email_verify.py"
    ],
    
    "common/identity_verify.py": [
        "slider_token.py",
        "email_verify.py"
    ],
    
    "slider_token.py": [
        "slider_solver.py"
    ],
    
    "common/config.py": [
        "config.yaml"
    ]
}

# 收集所有文件
all_files = set()
def collect(item):
    if isinstance(item, list):
        for f in item:
            all_files.add(f)
            if f in dependencies:
                collect(dependencies[f])

collect("test_cases.py")
collect(dependencies.get("test_cases.py", []))
for key in dependencies:
    collect(dependencies[key])

print("=" * 60)
print("test_cases.py 执行时引用的所有文件")
print("=" * 60)
print()

categories = {
    "入口": ["test_cases.py"],
    "配置": ["config.yaml", "pytest.ini"],
    "测试套件": [f for f in all_files if f.startswith("tests/")],
    "核心管理": ["token_manager.py", "email_verify.py"],
    "滑块破解": ["slider_solver.py", "slider_token.py"],
    "公共层": [f for f in all_files if f.startswith("common/")]
}

for cat, files in categories.items():
    if files:
        print(f"{cat}:")
        for f in sorted(files):
            if f in all_files or f in ["test_cases.py", "pytest.ini"]:
                print(f"  - {f}")
        print()

print("=" * 60)
print(f"共计: {len(all_files) + 2} 个文件（含 test_cases.py 和 pytest.ini）")
print("=" * 60)

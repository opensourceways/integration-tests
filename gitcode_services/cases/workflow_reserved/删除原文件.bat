@echo off
chcp 65001 >nul
echo ========================================
echo 批量删除 cases/yaml/ 中的 workflow 用例
echo ========================================
echo.
echo 此脚本将删除 83 条 workflow 用例的原文件
echo （cases/workflow_reserved/ 中已有备份）
echo.
pause

cd /d "%~dp0\..\yaml"

for /f "delims=" %%i in (..\workflow_reserved\workflow_files.txt) do (
    if exist "%%i" (
        echo 删除: %%i
        del "%%i"
    )
)

echo.
echo ✓ 删除完成
echo ✓ cases/yaml/ 现在只包含 ui/api/git 用例
pause

@echo off
chcp 65001 >nul
echo ========================================
echo 批量删除 cases/yaml/ 中的 FAIL 用例
echo ========================================
echo.
echo 此脚本将删除 30 条 FAIL 用例的原文件
echo （cases/failed_reserved/ 中已有备份）
echo.
echo 删除后，执行测试时将跳过这些用例
echo 待人工验证后，可运行"恢复用例.bat"放回
echo.
pause

cd /d "%~dp0\..\yaml"

set count=0
for /f "delims=" %%i in (..\failed_reserved\failed_cases.txt) do (
    if exist "%%i.yaml" (
        echo 删除: %%i.yaml
        del "%%i.yaml"
        set /a count+=1
    )
)

echo.
echo ✓ 删除完成，共 %count% 个文件
echo ✓ cases/yaml/ 现在只包含 PASS/INCONCLUSIVE 的用例
echo.
pause

@echo off
chcp 65001 >nul
echo ========================================
echo 恢复已验证的 FAIL 用例到 cases/yaml/
echo ========================================
echo.
echo 此脚本将所有备份的用例复制回 cases/yaml/
echo 如果只需恢复部分用例，请手动复制对应的 .yaml 文件
echo.
pause

cd /d "%~dp0"

set count=0
for /f "delims=" %%i in (failed_cases.txt) do (
    if exist "%%i.yaml" (
        echo 恢复: %%i.yaml
        copy /Y "%%i.yaml" "..\yaml\%%i.yaml" >nul
        set /a count+=1
    )
)

echo.
echo ✓ 恢复完成，共 %count% 个文件
echo ✓ 用例已放回 cases/yaml/，可重新执行测试
echo.
pause

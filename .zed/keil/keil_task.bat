@echo off
chcp 65001 > nul
setlocal

:: --- 配置 ---
SET KEIL_PATH=D:\Program Files\ARM\MDK5\UV4\UV4.exe
:: --- 配置结束 ---

:: 检查 Keil 路径
if not exist "%KEIL_PATH%" (
    echo [ERROR] Keil 程序未在 "%KEIL_PATH%" 找到。请编辑 .zed\keil_task.bat 设置正确路径。
    exit /b 1
)

:: 自动查找项目文件
set "PROJECT_FILE="
for /f "delims=" %%i in ('dir /s /b *.uvprojx 2^>nul') do ( if not defined PROJECT_FILE set "PROJECT_FILE=%%i" )
if not defined PROJECT_FILE (
    for /f "delims=" %%i in ('dir /s /b *.uvproj 2^>nul') do ( if not defined PROJECT_FILE set "PROJECT_FILE=%%i" )
)
if not defined PROJECT_FILE (
    echo [ERROR] 未找到 *.uvprojx 或 *.uvproj 项目文件。
    exit /b 1
)
echo [INFO] 自动查找到项目文件: %PROJECT_FILE%

:: 定义日志文件名，并从项目文件路径中正确提取出日志的完整路径
SET LOG_FILE_NAME=keil_build_log.txt
for %%F in ("%PROJECT_FILE%") do set "PROJECT_DIR=%%~dpF"
SET LOG_FILE_PATH="%PROJECT_DIR%%LOG_FILE_NAME%"

:: 获取指令
SET TASK=%1
IF /I "%TASK%"=="build"   SET ARGS=-b -j0
IF /I "%TASK%"=="rebuild" SET ARGS=-r -j0
IF /I "%TASK%"=="flash"   SET ARGS=-f
IF not defined ARGS (
    echo [ERROR] 无效指令 '%TASK%'. 请使用 'build', 'rebuild', 或 'flash'.
    exit /b 1
)
echo [INFO] 正在执行: %TASK%...
echo ----------------------------------------------------

:: 执行 Keil。-o 参数后的日志文件名不需要路径，Keil 会自动将其放在项目文件旁边。
"%KEIL_PATH%" %ARGS% -o "%LOG_FILE_NAME%" "%PROJECT_FILE%"
SET EXIT_CODE=%errorlevel%

:: 从正确的完整路径打印日志文件
if exist %LOG_FILE_PATH% (
    type %LOG_FILE_PATH%
    del %LOG_FILE_PATH%
) else (
    echo [WARNING] 未在项目目录中找到编译日志文件: %LOG_FILE_PATH%
    echo [WARNING] Keil 可能没有产生任何输出或在其他地方生成了日志。
)

:: 根据退出代码判断最终结果
if %EXIT_CODE% equ 0 (
    echo ----------------------------------------------------
    echo [SUCCESS] 操作成功完成。
) else (
    echo ----------------------------------------------------
    echo [ERROR] 操作失败, 退出代码: %EXIT_CODE%。请检查上面的编译日志。
)

endlocal
exit /b %EXIT_CODE%

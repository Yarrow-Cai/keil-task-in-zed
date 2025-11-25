@echo off
@REM 切换到UTF-8编码
for /f "usebackq tokens=2 delims=:" %%i in (`chcp 65001 ^| find "活动代码页:"`) do set "CP=%%i"

@REM 启用延迟扩展
setlocal enabledelayedexpansion

@echo ===========================================
@echo Keil Zed 集成工具 - clangd 自动配置
@echo ===========================================

@REM 遍历所有子文件夹查找Keil项目文件
set "FOUND_PROJ="
set "PROJ_LIST="
set "PROJ_COUNT=0"
@echo [INFO] 正在遍历所有文件夹查找Keil项目文件...

for /r %%f in (*.uvprojx *.uvproj) do (
    set /a PROJ_COUNT+=1
    set "PROJ_!PROJ_COUNT!=%%f"
    set "PROJ_LIST=!PROJ_LIST!%%f;"
    @echo [INFO] 找到项目文件 #!PROJ_COUNT!: %%f
)

@REM 如果找到多个项目文件，让用户选择
if !PROJ_COUNT! gtr 1 (
    @echo.
    @echo [INFO] 找到 !PROJ_COUNT! 个Keil项目文件，请选择要使用的项目：

    for /l %%i in (1, 1, !PROJ_COUNT!) do (
        for /f "tokens=*" %%a in ('echo !PROJ_%%i!') do (
            @echo %%i. %%a
        )
    )

    @echo.
    set /p "PROJ_CHOICE=请输入项目编号： "

    @REM 验证用户输入
    if "!PROJ_CHOICE!"=="" set "PROJ_CHOICE=1"
    if !PROJ_CHOICE! gtr !PROJ_COUNT! set "PROJ_CHOICE=!PROJ_COUNT!"

    for /f "tokens=*" %%a in ('echo !PROJ_!PROJ_CHOICE!!') do (
        set "FOUND_PROJ=%%a"
    )
    @echo.
    @echo [INFO] 已选择项目：!FOUND_PROJ!

) else if !PROJ_COUNT! equ 1 (
    set "FOUND_PROJ=!PROJ_1!"
)

@REM 检查是否已存在配置文件
if exist ".clangd" (
    @echo [INFO] 已存在 .clangd 配置文件，将跳过创建
) else (
    @echo [INFO] 创建 .clangd 配置文件...

    @REM 创建配置文件内容
    @REM 创建 BUILD 目录
    if not exist "BUILD" mkdir "BUILD" >nul 2>&1

    @(
        echo CompileFlags:
        echo   Add: [-include, stdint.h, -ICMSIS/Core/Include]
        echo Index:
        echo   Background: Build
    ) > ".clangd"

    @echo [SUCCESS] .clangd 配置文件创建成功
)


@REM 检查是否已存在 compile_commands.json
if exist "compile_commands.json" (
    @echo [INFO] BUILD\compile_commands.json 已存在，将尝试使用 keil2clangd 工具更新
)

@REM 尝试使用 keil2clangd 工具生成/更新 compile_commands.json
if defined FOUND_PROJ (
    @echo [INFO] 使用 keil2clangd 工具生成 compile_commands.json...
    .zed\keil2clangd.exe "%FOUND_PROJ%" -o "BUILD\compile_commands.json"

    if errorlevel 1 (
        @echo [ERROR] keil2clangd 工具运行失败，将使用默认模板
        if not exist "BUILD\compile_commands.json" (
            @(
                echo {
                echo   "version": 1,
                echo   "commands": [
                echo     {
                echo       "directory": ".",
                echo       "command": "armcc -c -o obj/main.o -I. -Iinc -DDEBUG main.c",
                echo       "file": "main.c"
                echo     }
                echo   ]
                echo }
            ) > "BUILD\compile_commands.json"
            @echo [INFO] 使用默认模板在 BUILD 目录创建 compile_commands.json
        )
    ) else (
        @echo [SUCCESS] 已使用 keil2clangd 工具生成/更新 compile_commands.json
    )
) else (
    @echo [WARNING] 未找到 Keil 项目文件，无法使用 keil2clangd 工具
    if not exist "BUILD\compile_commands.json" (
        @(
            echo {
            echo   "version": 1,
            echo   "commands": [
            echo     {
            echo       "directory": ".",
            echo       "command": "armcc -c -o obj/main.o -I. -Iinc -DDEBUG main.c",
            echo       "file": "main.c"
            echo     }
            echo   ]
            echo }
        ) > "BUILD\compile_commands.json"
        @echo [INFO] 使用默认模板在 BUILD 目录创建 compile_commands.json
    )
)

@REM 自动查找所有源文件
@echo [INFO] 正在查找源文件...
set "SOURCE_COUNT=0"
for /r %%f in (*.c *.cpp) do (
    if exist "%%f" (
        set /a SOURCE_COUNT+=1
    )
)

if %SOURCE_COUNT% gtr 0 (
    @echo [INFO] 找到 %SOURCE_COUNT% 个源文件
)

@echo.
@echo ===========================================
@echo [INFO] clangd 自动配置完成！
@echo [INFO] 文件位置：
@echo [INFO] - .clangd
@echo [INFO] - compile_commands.json
@echo ===========================================
@echo.
@echo [TIP] 优化clangd配置的建议：
@echo [TIP] 1. 确保Keil编译器路径配置正确
@echo [TIP] 2. 在Keil中启用"Generate compiler command line file"功能
@echo [TIP] 3. 根据项目实际情况修改compile_commands.json
@echo.

@REM 恢复原始代码页
if defined CP chcp %CP% > nul 2>&1

exit /b 0

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
    @(
        echo CompileFlags:
        echo   Add: [-include, stdint.h, -include, string.h, -IFirmware/CMSIS/Include, -ID:\Program Files\ARM\MDK5\ARM\ARMCLANG\include, -Wno-include-next,-D__ARM_ACLE=200, -march=armv8-m.main]
        echo Diagnostics:
        echo   Suppress: [unused-includes]
        echo Index:
        echo   Background: Build
        echo.
        echo # 官方常用 clangd 配置介绍
        echo #
        echo # 1. Completion ^(代码补全相关配置^)
        echo #    AllScopes: true                    # 在全局作用域也提供补全建议
        echo #    BundledArguments: true             # 将函数参数打包为一个补全项
        echo #    CaseSensitivity: CaseInsensitive   # 大小写敏感设置 ^(CaseSensitive/CaseInsensitive^)
        echo #    FilterAndSort: true                # 自动过滤和排序补全结果
        echo #    IncludeBlocks: true                # 在补全中包含代码块
        echo #    ShowOrigins: true                  # 显示符号的来源
        echo #
        echo # 2. Hover ^(悬停提示配置^)
        echo #    ShowAKA: true                      # 显示类型的别名信息
        echo #    ShowOrigins: true                  # 显示符号的定义位置
        echo #
        echo # 3. InlayHints ^(内嵌提示配置^)
        echo #    BlockEnd: true                     # 显示代码块结束提示
        echo #    Designators: true                  # 显示初始化列表指示符
        echo #    Enabled: true                      # 全局启用内嵌提示
        echo #    ParameterNames: true               # 函数参数名提示
        echo #    DeducedTypes: true                 # 推导类型提示
        echo #    TypeNameLimit: 24                  # 类型名称长度限制
        echo #
        echo # 4. ClangTidy ^(静态分析配置^)
        echo #    Checks: "*"                       # 启用所有检查
        echo #    Checks: "cppcoreguidelines-*"     # 启用 C++ Core Guidelines 检查
        echo #    Checks: "modernize-*"             # 启用现代化代码检查
        echo #    Checks: "performance-*"           # 启用性能相关检查
        echo #    Checks: "bugprone-*"              # 启用 bug 预防检查
        echo #    Checks: "clang-analyzer-*"        # 启用 Clang 静态分析器
        echo #    Checks: "readability-*"           # 启用可读性检查
        echo #    Checks: "-*,clang-analyzer-*"     # 仅启用静态分析器
        echo #    WarningsAsErrors: ""              # 将警告视为错误的检查列表
        echo #
        echo # 5. Diagnostics ^(诊断信息配置^)
        echo #    Suppress: ["*"]                   # 抑制所有诊断
        echo #    Suppress: ["unused-includes"]     # 抑制未使用的头文件警告
        echo #    Suppress: ["unknown-warning-option"]  # 抑制未知警告选项警告
        echo #
        echo # 6. Index ^(索引配置^)
        echo #    Background: Build                  # 在后台构建索引
        echo #    Background: Skip                   # 跳过后台索引
        echo #    StandardLibrary: true             # 索引标准库
        echo #
        echo # 7. Style ^(代码风格配置^)
        echo #    FullyQualifiedNamespaces: true     # 始终使用完全限定命名空间
        echo #    UsingNamespaces: [std]            # 自动使用这些命名空间
        echo #
        echo # 8. Semantic Highlighting ^(语义高亮^)
        echo #    DisabledCategories: ["*"]         # 禁用特定类别的高亮
        echo #    Enabled: true                      # 启用语义高亮
        echo #
        echo # 9. Memory Usage ^(内存使用配置^)
        echo #    LimitResults: 500                 # 限制结果数量
        echo #    LimitMemory: 2048                 # 限制内存使用^(MB^)
        echo #
        echo # 10. Cross References ^(交叉引用^)
        echo #    IncludeInactive: true             # 包含非活动文件的引用
        echo #
        echo # 11. CompileFlags ^(编译标志配置^)
        echo #    Add: [-std=c++17]                 # 添加编译器标志，如C++标准
        echo #    Add: [-Wall, -Wextra]            # 添加警告标志
        echo #    Add: [-I./include]               # 添加头文件搜索路径
        echo #    Add: [-DDEBUG=1]                 # 定义预处理器宏
        echo #    Add: [-include, stdint.h]        # 强制包含头文件
        echo #    Add: [-isystem, /path]           # 添加系统头文件路径
        echo #    Add: [--target=arm-none-eabi]    # 指定交叉编译目标
        echo #    Add: [-MMD]                      # 生成依赖文件
        echo #    Remove: [-Werror]               # 移除特定编译器标志
        echo #    Compiler: clang++               # 指定编译器可执行文件
        echo #    CompilationDatabase: build/    # 指定编译数据库目录
        echo #
        echo # 更多配置选项请参考官方文档：https://clangd.llvm.org/config
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

@echo off
chcp 65001 > nul
setlocal

echo [INFO] Keil Zed 集成工具 - .gitignore 自动生成

:: 检查是否已存在 .gitignore 文件
if exist ".gitignore" (
    echo [WARNING] 已存在 .gitignore 文件。 >> "%cd%\.gitignore"
    echo [WARNING] 将在末尾追加新的忽略规则。 >> "%cd%\.gitignore"
) else (
    echo [INFO] 创建 .gitignore 文件...
    echo # .gitignore for Keil C51/MDK-ARM projects > ".gitignore"
    echo # 自动生成 by keil-task-in-zed tool >> ".gitignore"
    echo > ".gitignore"
)

:: Keil 生成的文件
echo: >> ".gitignore"
echo # Keil generated files >> ".gitignore"
echo *.bak >> ".gitignore"
echo *.ddk >> ".gitignore"
echo *.edk >> ".gitignore"
echo *.lst >> ".gitignore"
echo *.lnp >> ".gitignore"
echo *.mpf >> ".gitignore"
echo *.mpj >> ".gitignore"
echo *.obj >> ".gitignore"
echo *.omf >> ".gitignore"
echo *.plg >> ".gitignore"
echo *.rpt >> ".gitignore"
echo *.tmp >> ".gitignore"
echo *.__i >> ".gitignore"
echo *.crf >> ".gitignore"
echo *.o >> ".gitignore"
echo *.d >> ".gitignore"
echo *.axf >> ".gitignore"
echo *.tra >> ".gitignore"
echo *.dep >> ".gitignore"
echo *.iex >> ".gitignore"
echo *.htm >> ".gitignore"
echo *.sct >> ".gitignore"
echo *.map >> ".gitignore"
echo JLinkLog.txt >> ".gitignore"
echo keil_build_log.txt >> ".gitignore"

:: 编辑器配置文件
echo: >> ".gitignore"
echo # IDE and editor configuration >> ".gitignore"
echo .cache/ >> ".gitignore"

:: VSCode
echo *.code-workspace >> ".gitignore"
echo .vscode/ >> ".gitignore"

:: JetBrains IDEs (IntelliJ IDEA, CLion, etc.)
echo .idea/ >> ".gitignore"
echo *.iml >> ".gitignore"

:: Claude AI
echo .claude/ >> ".gitignore"
echo CLAUDE.md >> ".gitignore"
echo claude.md >> ".gitignore"
echo CLAUDE-* >> ".gitignore"

:: AI Agent 文件
echo agent/ >> ".gitignore"
echo agents/ >> ".gitignore"
echo .promptx/ >> ".gitignore"

:: Spec 文件
echo: >> ".gitignore"
echo # Spec and documentation files >> ".gitignore"
echo *.spec >> ".gitignore"
echo openspec/ >> ".gitignore"
echo speckit/ >> ".gitignore"
echo spec/ >> ".gitignore"

:: VSCode 分支 IDE
echo: >> ".gitignore"
echo # VSCode fork IDEs >> ".gitignore"
echo .qoder/ >> ".gitignore"
echo qoder/ >> ".gitignore"
echo .trae/ >> ".gitignore"
echo trae/ >> ".gitignore"
echo .vercel/ >> ".gitignore"
echo vercel/ >> ".gitignore"



:: 其他可能的临时文件
echo: >> ".gitignore"
echo # Temporary files >> ".gitignore"
echo *.tmp >> ".gitignore"
echo *.temp >> ".gitignore"
echo temp/ >> ".gitignore"
echo /.eide/log >> ".gitignore"
echo /.eide.usr.ctx.json >> ".gitignore"
echo *.ept >> ".gitignore"
echo *.eide-template >> ".gitignore"

echo [SUCCESS] .gitignore 文件已更新完成！
echo [INFO] 文件位置：%cd%\%cd%\.gitignore

endlocal
exit /b 0

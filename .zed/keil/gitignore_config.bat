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

:: VSCode 完整配置
echo *.code-workspace >> ".gitignore"
echo *.code-workspace-* >> ".gitignore"
echo .vscode/ >> ".gitignore"
echo .vscode/extensions.json.backup >> ".gitignore"
echo .vscode/keybindings.json.backup >> ".gitignore"
echo .vscode/tasks.json.backup >> ".gitignore"

:: Zed 编辑器配置
echo .zed/ >> ".gitignore"
echo .zed-state/ >> ".gitignore"
echo zed.db >> ".gitignore"
echo zed.log >> ".gitignore"

:: JetBrains IDEs 完整配置
echo .idea/ >> ".gitignore"
echo .idea_modules/ >> ".gitignore"
echo *.iml >> ".gitignore"
echo *.ipr >> ".gitignore"
echo *.iws >> ".gitignore"

:: Claude AI 完整配置
echo .claude/ >> ".gitignore"
echo .claude-* >> ".gitignore"
echo CLAUDE.md >> ".gitignore"
echo claude.md >> ".gitignore"
echo CLAUDE-* >> ".gitignore"
echo claude-* >> ".gitignore"
echo claude_desktop_config.json >> ".gitignore"

:: GitHub Copilot
echo .copilot/ >> ".gitignore"
echo copilot* >> ".gitignore"

:: AI Agent 和助手工具
echo agent/ >> ".gitignore"
echo agents/ >> ".gitignore"
echo .agent/ >> ".gitignore"
echo .agents/ >> ".gitignore"
echo .promptx/ >> ".gitignore"
echo .promptx-* >> ".gitignore"
echo .ai/ >> ".gitignore"
echo ai/ >> ".gitignore"

:: AI CLI 工具
echo .cursor/ >> ".gitignore"
echo .continue/ >> ".gitignore"
echo .aider/ >> ".gitignore"
echo aider_* >> ".gitignore"
echo .supermaven/ >> ".gitignore"
echo supermaven* >> ".gitignore"

:: 其他AI工具配置
echo .chatgpt/ >> ".gitignore"
echo .openai/ >> ".gitignore"
echo openai_config.json >> ".gitignore"
echo .anthropic/ >> ".gitignore"
echo anthropic_config.json >> ".gitignore"

:: 其他语言服务器（不包括clangd）
echo: >> ".gitignore"
echo # Other language servers (excluding clangd) >> ".gitignore"
echo .ccls/ >> ".gitignore"
echo ccls* >> ".gitignore"
echo .cquery/ >> ".gitignore"
echo cquery* >> ".gitignore"
echo .ycm_extra_conf.py >> ".gitignore"

:: LSP 缓存和索引（不包括clangd）
echo .cquery_cached_index/ >> ".gitignore"

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

:: 其他编辑器
echo: >> ".gitignore"
echo # Other editors and tools >> ".gitignore"
echo .sublime-* >> ".gitignore"
echo *.sublime-* >> ".gitignore"
echo .atom/ >> ".gitignore"
echo .brackets/ >> ".gitignore"
echo .vim/ >> ".gitignore"
echo .vimrc.local >> ".gitignore"
echo .emacs.d/auto-save-list/ >> ".gitignore"
echo .emacs.d/elpa/ >> ".gitignore"
echo .emacs.d/undo-tree/ >> ".gitignore"

:: Git和其他版本控制工具
echo: >> ".gitignore"
echo # Version control tools >> ".gitignore"
echo .gitconfig.local >> ".gitignore"
echo .gitmessage >> ".gitignore"
echo .gitattributes.local >> ".gitignore"
echo .gitkeep.* >> ".gitignore"

:: 包管理器和依赖管理
echo: >> ".gitignore"
echo # Package managers and dependencies >> ".gitignore"
echo node_modules/ >> ".gitignore"
echo .npm/ >> ".gitignore"
echo .yarn/ >> ".gitignore"
echo package-lock.json >> ".gitignore"
echo yarn.lock >> ".gitignore"
echo venv/ >> ".gitignore"
echo .venv/ >> ".gitignore"
echo env/ >> ".gitignore"
echo .env.local >> ".gitignore"
echo .env.development.local >> ".gitignore"
echo .env.test.local >> ".gitignore"
echo .env.production.local >> ".gitignore"

:: 其他可能的临时文件
echo: >> ".gitignore"
echo # Temporary files and system junk >> ".gitignore"
echo *.tmp >> ".gitignore"
echo *.temp >> ".gitignore"
echo temp/ >> ".gitignore"
echo tmp/ >> ".gitignore"
echo *.swp >> ".gitignore"
echo *.swo >> ".gitignore"
echo *~ >> ".gitignore"
echo .DS_Store >> ".gitignore"
echo Thumbs.db >> ".gitignore"
echo desktop.ini >> ".gitignore"

:: EIDE插件
echo /.eide/log >> ".gitignore"
echo /.eide.usr.ctx.json >> ".gitignore"
echo *.ept >> ".gitignore"
echo *.eide-template >> ".gitignore"

:: 构建和部署工具
echo: >> ".gitignore"
echo # Build and deployment tools >> ".gitignore"
echo .next/ >> ".gitignore"
echo .nuxt/ >> ".gitignore"
echo .dist/ >> ".gitignore"
echo dist/ >> ".gitignore"
echo build/ >> ".gitignore"
echo out/ >> ".gitignore"
echo .parcel-cache/ >> ".gitignore"
echo .cache-loader/ >> ".gitignore"

:: 调试和性能分析
echo: >> ".gitignore"
echo # Debug and profiling >> ".gitignore"
echo *.profraw >> ".gitignore"
echo *.profdata >> ".gitignore"
echo .debug/ >> ".gitignore"
echo .lldb/ >> ".gitignore"
echo .gdb_history >> ".gitignore"

:: 日志和监控
echo: >> ".gitignore"
echo # Logs and monitoring >> ".gitignore"
echo *.log >> ".gitignore"
echo logs/ >> ".gitignore"
echo .log/ >> ".gitignore"
echo npm-debug.log* >> ".gitignore"
echo yarn-debug.log* >> ".gitignore"
echo yarn-error.log* >> ".gitignore"

echo ========================================== >> ".gitignore"
echo # .gitignore 统计信息 >> ".gitignore"
echo # 总计约 70+ 项忽略规则，涵盖： >> ".gitignore"
echo # - Keil编译文件 (21项) >> ".gitignore"
echo # - 编辑器配置 (15+项) >> ".gitignore"
echo # - AI工具和CLI (20+项) >> ".gitignore"
echo # - 其他语言服务器 (5项) >> ".gitignore"
echo # - 其他开发工具 (15+项) >> ".gitignore"
echo # ========================================== >> ".gitignore"

echo [SUCCESS] .gitignore 文件已更新完成！
echo [INFO] 文件位置：%cd%\.gitignore
echo [INFO] 已添加全面的编辑器和AI工具忽略规则（70+项，保留clangd）

endlocal
exit /b 0

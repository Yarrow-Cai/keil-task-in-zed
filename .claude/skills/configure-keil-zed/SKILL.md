---
name: configure-keil-zed
description: Use when deploying the .zed/ Keil integration folder to a Keil C51/MDK-ARM project — triggered by requests like "configure Keil for Zed", "setup Zed tasks in this Keil project", "deploy .zed folder", or when a user wants to avoid manual GitHub download/extraction for Keil+Zed setup.
---

# Configure Keil Zed Integration

## Overview

Copies `.zed/` from this repository to any Keil project and configures the Keil toolchain path. Eliminates manual GitHub download, extraction, and path editing.

## Quick Reference

| Step | Action | Verify |
|------|--------|--------|
| 1 | Get target path from user | Path contains `.uvprojx` or `.uvproj` |
| 2 | Copy `.zed/` to target | `target/.zed/tasks.json` exists |
| 3 | Configure `KEIL_PATH` | User confirms or you auto-detect |
| 4 | Print usage summary | All tasks listed |

## Implementation

### Step 1: Identify Target

Ask the user for the target Keil project directory. If they don't provide one, use the current working directory. Verify it contains at least one `.uvprojx` or `.uvproj` file. If not found, report the error and ask for the correct path.

### Step 2: Copy .zed/ Directory

The source is always `<this-repo-root>/.zed`. The target is `<user-project>/.zed`.

If the target already has a `.zed/` folder, warn the user and ask whether to overwrite. If they decline, abort.

```powershell
Copy-Item -Recurse -Force "<repo-root>/.zed" "<target>/.zed"
```

The copy includes the binary `keil2clangd.exe` which cannot be generated from text — it must be copied from the source repo.

### Step 3: Configure KEIL_PATH

After copying, the `keil_task.bat` at `<target>/.zed/keil/keil_task.bat` contains a placeholder `KEIL_PATH`. Prompt the user for their Keil installation path (the full path to `UV4.exe` or `UV5.exe`).

If the user doesn't know, search common locations:

```
C:\Keil_v5\UV4\UV4.exe
D:\Keil_v5\UV4\UV4.exe
D:\Program Files\ARM\MDK5\UV4\UV4.exe
C:\Program Files\ARM\MDK5\UV4\UV4.exe
```

Update the `SET KEIL_PATH=...` line in `keil_task.bat` with the confirmed path. Use the Edit tool for precision — do not regenerate the whole file.

### Step 4: Verify and Summarize

Confirm deployment by checking `target/.zed/tasks.json` exists. Print a summary:

```
.zed/ 已部署到 <target-path>
├── tasks.json              # 7 个 Zed 任务
├── keil/keil_task.bat      # 编译/重新编译/烧录 (KEIL_PATH 已配置)
├── keil/keilkilll.bat      # 清理临时文件
├── keil/clangd_config.bat  # clangd 智能补全
├── keil/gitignore_config.bat # .gitignore 生成
├── keil/keil_utf8conv.bat  # UTF-8 编码转换
└── keil/keil2clangd.exe    # compile_commands.json 生成工具

使用方式:
  Zed 中打开 <target-path> → Ctrl+Shift+P → Tasks: Run → 选择 Keil 任务
```

## Files Deployed

| File | Purpose | Editable |
|------|---------|----------|
| `.zed/tasks.json` | Zed task definitions | Yes |
| `.zed/keil/keil_task.bat` | Build/rebuild/flash | KEIL_PATH only |
| `.zed/keil/keilkilll.bat` | Clean temp files | Yes |
| `.zed/keil/clangd_config.bat` | Generate clangd config | Yes |
| `.zed/keil/gitignore_config.bat` | Generate .gitignore | Yes |
| `.zed/keil/keil_utf8conv.bat` | Convert source encoding | Yes |
| `.zed/keil/keil2clangd.exe` | Binary helper for clangd | No (binary) |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Missing `keil2clangd.exe` | Must copy from this repo — it's a binary, cannot be generated |
| KEIL_PATH not updated | Always prompt after copy — this is the #1 cause of `[ERROR] Keil 程序未找到` |
| Wrong target path | Verify `.uvprojx`/`.uvproj` exists BEFORE copying |
| Silent overwrite | Always ask before overwriting existing `.zed/` |
| Forgetting to tell user how to run | Always print the usage summary in Step 4 |

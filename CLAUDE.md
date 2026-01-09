# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

The `keil-task-in-zed` project integrates Keil C51/MDK-ARM's build, flash, and clean functionalities into the Zed editor. It enables embedded developers to perform Keil operations without leaving Zed, streamlining the workflow.

## Key Files & Architecture

### Core Files
- `.zed/tasks.json`: Defines Zed tasks for Keil operations (build, rebuild, flash, clean)
- `.zed/keil_task.bat`: Main script that auto-detects `.uvprojx`/`.uvproj` project files and executes Keil commands
- `.zed/keilkilll.bat`: Cleans Keil-generated temporary files

### Architecture
1. Zed reads `tasks.json` to display available Keil operations in the command palette
2. When a task is selected, Zed executes the corresponding batch script
3. `keil_task.bat` locates the Keil project file automatically
4. It calls Keil with parameters (`-b`, `-r`, `-f`) and displays the output in Zed
5. `keilkilll.bat` removes temporary files (`.obj`, `.lst`, `.axf`, etc.)

## Usage

1. **Config Keil path**: Edit `.zed/keil_task.bat` and set `KEIL_PATH` to `UV4.exe` or `UV5.exe` location
2. **Integrate**: Copy `.zed` folder to any Keil project root directory
3. **Run in Zed**: Press `Ctrl+Shift+P` → `Tasks: Run` → select Keil operation

## Note

This project is meant to be copied into Keil project directories; it doesn't have its own build process, tests, or linting commands.
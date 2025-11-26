@echo off
chcp 65001 >nul
echo ===========================================
echo Keil Project UTF-8 Conversion Tool
echo ===========================================
echo Using PowerShell for conversion (no external dependencies)

REM Find all C and H files
echo Finding C and H files in current directory...
setlocal enabledelayedexpansion

for /r %%f in (*.c *.h) do (
    echo Converting "%%~nxf"...
    powershell -Command "(Get-Content '%%f' -Encoding Default) | Set-Content '%%f' -Encoding UTF8"
)

echo ===========================================
echo UTF-8 conversion completed successfully!
echo ===========================================
pause
exit /b 0

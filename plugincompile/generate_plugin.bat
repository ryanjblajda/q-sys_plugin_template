@echo off

if "%~1"=="" (
    echo Usage: generate_plugin.bat input.lua output.lua
    exit /b 1
)

if "%~2"=="" (
    echo Usage: generate_plugin.bat input.lua output.lua
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0generate_plugin.ps1" %1 %2
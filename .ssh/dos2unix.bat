@echo off
REM Copyright (c) 2024 liudepei. All Rights Reserved.
REM create at 2024/01/18 11:40:00 Thursday

set dp=%~dp0
cd /d %userprofile%
xcopy %dp%\\ %.ssh\\ /s /e /f /y
dos2unix.exe id_* config
ssh -T git@github.com

pause

@echo off
REM Copyright (c) 2024 liudepei. All Rights Reserved.
REM create at 2024/01/18 11:40:00 Thursday

cd /d %userprofile%\\.ssh
dos2unix.exe id_* config
ssh -T git@github.com

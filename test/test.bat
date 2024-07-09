@echo off

call C:\Users\zhanfuyu\anaconda3\Scripts\activate.bat

if exist %~dp0..\build (
    rd /s /q %~dp0..\build
)

if exist %~dp0..\src\rt_env.egg-info (
    rd /s /q %~dp0..\src\rt_env.egg-info
)

if exist %~dp0.venv (
    rd /s /q %~dp0.venv
)

python -m venv %~dp0.venv

call %~dp0.venv\Scripts\activate.bat

pip install %~dp0..\

@REM call %~dp0.venv\Scripts\


cmd /K
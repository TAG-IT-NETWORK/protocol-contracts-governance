@echo off
REM Windows launcher for our Python CLI
setlocal
set SCRIPT_DIR=%~dp0
REM Prefer the Python launcher "py"; fall back to "python" if needed
where py >nul 2>nul
if %ERRORLEVEL%==0 (
  py "%SCRIPT_DIR%tools\codex\codex.py" %*
) else (
  python "%SCRIPT_DIR%tools\codex\codex.py" %*
)
endlocal

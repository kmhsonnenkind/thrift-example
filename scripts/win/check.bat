:: Runs tests and additional code checks for all language bindings
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Run checks using dedicated scripts
call .\java\check.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
call .\py\check.bat

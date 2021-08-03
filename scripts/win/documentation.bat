:: Builds documentation for all language bindings
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Build documentation using dedicated scripts
call .\java\documentation.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
call .\py\documentation.bat

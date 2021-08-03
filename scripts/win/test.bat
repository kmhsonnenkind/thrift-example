:: Runs unittests for all language bindings
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Run tests using dedicated scripts
call .\csharp\test.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
call .\java\test.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
call .\py\test.bat

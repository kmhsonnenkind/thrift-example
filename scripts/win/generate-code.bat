:: Generates code for example thrift service
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Generate code using dedicated scripts
call .\csharp\generate-code.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
call .\java\generate-code.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
call .\py\generate-code.bat

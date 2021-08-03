:: Removes generated files and binaries for all language bindings
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Delete generated files and binaries using dedicated scripts
call .\csharp\clean.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
call .\java\clean.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
call .\py\clean.bat

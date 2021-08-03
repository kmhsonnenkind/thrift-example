:: Builds binaries for all language bindings
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Build binaries using dedicated scripts
call .\csharp\build.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
call .\java\build.bat

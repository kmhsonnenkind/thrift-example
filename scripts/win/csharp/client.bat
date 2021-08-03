:: Runs C# thrift client
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Generate code just to be sure
call .\generate-code.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

:: Start C# client using dotnet command line tool
echo Running C# client using '%DOTNET_EXECUTABLE%'
%DOTNET_EXECUTABLE% run run --project %CSHARP_SRC_DIR%\Client

:: Builds C# binaries for example thrift service
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Generate code just to be sure
call .\generate-code.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

:: Use dotnet command line tool to build the binaries
echo Building C# binaries using '%DOTNET_EXECUTABLE%'
%DOTNET_EXECUTABLE% build %CSHARP_SRC_DIR%\Calculator.sln

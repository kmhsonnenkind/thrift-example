:: Removes C# binaries and generated files
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Delete files
echo Deleting C# binaries and generated files
if exist %CSHARP_SRC_DIR%\Calculator\CalculatorService.cs del /Q %CSHARP_SRC_DIR%\Calculator\CalculatorService.cs
if exist %CSHARP_SRC_DIR%\Calculator\DivideByZeroException.cs del /Q %CSHARP_SRC_DIR%\Calculator\DivideByZeroException.cs
if exist %CSHARP_SRC_DIR%\Calculator\bin rmdir /S /Q %CSHARP_SRC_DIR%\Calculator\bin
if exist %CSHARP_SRC_DIR%\Calculator\obj rmdir /S /Q %CSHARP_SRC_DIR%\Calculator\obj
if exist %CSHARP_SRC_DIR%\Client\bin rmdir /S /Q %CSHARP_SRC_DIR%\Client\bin
if exist %CSHARP_SRC_DIR%\Client\obj rmdir /S /Q %CSHARP_SRC_DIR%\Client\obj
if exist %CSHARP_SRC_DIR%\Server\bin rmdir /S /Q %CSHARP_SRC_DIR%\Server\bin
if exist %CSHARP_SRC_DIR%\Server\obj rmdir /S /Q %CSHARP_SRC_DIR%\Server\obj
if exist %CSHARP_SRC_DIR%\Server.Tests\bin rmdir /S /Q %CSHARP_SRC_DIR%\Server.Tests\bin
if exist %CSHARP_SRC_DIR%\Server.Tests\obj rmdir /S /Q %CSHARP_SRC_DIR%\Server.Tests\obj

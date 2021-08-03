:: Generates C# code for example thrift service
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat
call ..\config.bat

:: Generate code
echo Generating C# code using '%THRIFT_EXECUTABLE%'
%THRIFT_EXECUTABLE% -r -gen netstd -out %CSHARP_SRC_DIR% %THRIFT_FILE%

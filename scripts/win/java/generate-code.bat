:: Generates Java code for example thrift service
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat
call ..\config.bat

:: Generate code
echo Generating Java code using '%THRIFT_EXECUTABLE%'
%THRIFT_EXECUTABLE% -r -gen java -out %JAVA_OUTPUT_DIR% %THRIFT_FILE%

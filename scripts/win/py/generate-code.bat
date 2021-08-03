:: Generates Python code for example thrift service
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat
call ..\config.bat

:: Create output directories if they don't exist yet
if not exist %PY_OUTPUT_DIR% mkdir %PY_OUTPUT_DIR%

:: Generate code
echo Generating Python code using '%THRIFT_EXECUTABLE%'
%THRIFT_EXECUTABLE% -r -gen py -out %PY_OUTPUT_DIR% %THRIFT_FILE%

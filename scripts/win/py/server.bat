:: Runs Python thrift server
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Generate code just to be sure
call .\generate-code.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

:: Start python script
set PYTHONPATH=%PY_SRC_DIR%;%PYTHONPATH
echo Running Python server using '%PYTHON_EXECUTABLE%'
%PYTHON_EXECUTABLE% %PY_SRC_DIR%\calculator\server.py

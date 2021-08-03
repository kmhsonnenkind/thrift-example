:: Runs Python unittests for example thrift service
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Generate code just to be sure
call .\generate-code.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

:: Use setup.py to run the unittests
cd %PY_SRC_DIR%
echo Running Python unittests using '%PYTHON_EXECUTABLE%'
%PYTHON_EXECUTABLE% setup.py pytest

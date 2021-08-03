:: Builds Python documentation for example thrift service
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Generate code just to be sure
call .\generate-code.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

:: Use setup.py to build the documentation
cd %PY_SRC_DIR%
echo Building Python documentation using '%PYTHON_EXECUTABLE%'
%PYTHON_EXECUTABLE% setup.py build_sphinx

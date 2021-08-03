:: Runs Python tests and code analysis for example thrift service
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Generate code just to be sure
call .\generate-code.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

:: Run unittests
call .\test.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %PY_SRC_DIR%
:: Check code style
echo Running Python code style checks using '%PYTHON_EXECUTABLE% -m pycodestyle'
%PYTHON_EXECUTABLE% -m pycodestyle calculator
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
echo Running Python code style checks using '%PYTHON_EXECUTABLE% -m flake8'
%PYTHON_EXECUTABLE% -m flake8 calculator
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

:: Statically check data types
echo Running Python data type analysis using '%PYTHON_EXECUTABLE% -m mypy'
%PYTHON_EXECUTABLE% -m mypy calculator
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

:: Statically analyze code
echo Running Python static code analysis using '%PYTHON_EXECUTABLE% -m pylint'
%PYTHON_EXECUTABLE% -m pylint calculator
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

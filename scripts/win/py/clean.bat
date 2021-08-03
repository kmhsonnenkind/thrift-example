:: Removes Python binaries and temporary files
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Delete binaries
echo Deleting Python temporary and generated files
if exist %PY_OUTPUT_DIR% rmdir /S /Q %PY_OUTPUT_DIR%
if exist %PY_SRC_DIR%\calculator\__pycache__ rmdir /S /Q %PY_SRC_DIR%\calculator\__pycache__
if exist %PY_SRC_DIR%\calculator.egg-info  rmdir /S /Q %PY_SRC_DIR%\calculator.egg-info
if exist %PY_SRC_DIR%\.eggs rmdir /S /Q %PY_SRC_DIR%\.eggs
if exist %PY_SRC_DIR%\.pytest_cache rmdir /S /Q %PY_SRC_DIR%\.pytest_cache
if exist %PY_SRC_DIR%\tests\__pycache__ rmdir /S /Q %PY_SRC_DIR%\tests\__pycache__
if exist %PY_SRC_DIR%\build rmdir /S /Q %PY_SRC_DIR%\build
if exist %PY_SRC_DIR%\.mypy_cache rmdir /S /Q %PY_SRC_DIR%\.mypy_cache

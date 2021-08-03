:: Removes Java binaries and generated files
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Delete files
echo Deleting Java binaries and generated files
if exist %JAVA_OUTPUT_DIR%\calculator\gen rmdir /S /Q %JAVA_OUTPUT_DIR%\calculator\gen
if exist %JAVA_SRC_DIR%\build rmdir /S /Q %JAVA_SRC_DIR%\build
if exist %JAVA_SRC_DIR%\.gradle  rmdir /S /Q %JAVA_SRC_DIR%\.gradle
if exist %JAVA_SRC_DIR%\.classpath rmdir /S /Q %JAVA_SRC_DIR%\.classpath
if exist %JAVA_SRC_DIR%\.project rmdir /S /Q %JAVA_SRC_DIR%\.projectg

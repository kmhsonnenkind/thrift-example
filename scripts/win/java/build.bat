:: Builds Java binaries for example thrift service
@ECHO OFF

:: Work relative from this directory
setlocal
cd %~dp0

:: Load configuration
call .\config.bat

:: Generate code just to be sure
call .\generate-code.bat
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

:: Use gradle wrapper to build binaries
echo Building Java binaries using 'gradlew'
call %JAVA_SRC_DIR%\gradlew.bat -p %JAVA_SRC_DIR% build

:: Runs Java tests and code analysis for example thrift service
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

:: Use gradle wrapper to run checks
echo Running static code checks using 'gradlew'
call %JAVA_SRC_DIR%\gradlew.bat -p %JAVA_SRC_DIR% check

:: Configuration for Python builds
@ECHO OFF

:: Tool configuration
set PYTHON_EXECUTABLE=python

:: In- and output paths
set PY_SRC_DIR=%~dp0..\..\..\python
set PY_OUTPUT_DIR=%PY_SRC_DIR%\calculator\gen

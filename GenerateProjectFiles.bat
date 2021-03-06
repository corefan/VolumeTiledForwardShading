@ECHO OFF

REM ****************************************************************************
REM MIT License
REM 
REM Copyright (c) 2017 Jeremiah van Oosten
REM 
REM Permission is hereby granted, free of charge, to any person obtaining a copy
REM of this software and associated documentation files (the "Software"), to deal
REM in the Software without restriction, including without limitation the rights
REM to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
REM copies of the Software, and to permit persons to whom the Software is
REM furnished to do so, subject to the following conditions:
REM 
REM The above copyright notice and this permission notice shall be included in all
REM copies or substantial portions of the Software.
REM 
REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
REM IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
REM AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
REM OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
REM SOFTWARE.
REM ****************************************************************************

REM This script will generate the solution files for the currenlty installed version
REM of Visual Studio detected on the user's computer. Supported version of Visual Studio are:
REM     Visual Studio 2017
REM     Visual Studio 2015
REM 
REM The solution files will be created in Build_VS15 if Visual Studio 2017 was detected or
REM in Build_VS14 if Visual Studio 2015 was detected.

PUSHD %~dp0

SET CMAKE="%~dp0\Tools\cmake-3.9.0-win64-x64\bin\cmake.exe"
SET CMAKE_GENERATOR=
SET CMAKE_BINARY_DIR=

CALL Tools\BatchFiles\DetectVisualStudioInstallVersion.bat
IF ERRORLEVEL 0 (
    IF %VS_VERSION%==15.0 (
        SET CMAKE_BINARY_DIR=Build_VS15
        SET CMAKE_GENERATOR="Visual Studio 15 2017 Win64"
        GOTO GenerateProjectFiles
    )
    IF %VS_VERSION%==14.0 (
        SET CMAKE_BINARY_DIR=Build_VS14
        SET CMAKE_GENERATOR="Visual Studio 14 2015 Win64"
        GOTO GenerateProjectFiles
    )
    
    ECHO Usupported version of Visual Studio ^(%VS_VERSION%^)
    GOTO Exit
) ELSE (
    ECHO No installed version of Visual Studio detected. Please install the latest version of Visual Studio if you want to compile this project from source.
    ECHO Go to https://www.visualstudio.com/downloads/ to download the latest version of Visual Studio.
    GOTO Exit
)

:GenerateProjectFiles
MKDIR %CMAKE_BINARY_DIR% 2>NUL
PUSHD %CMAKE_BINARY_DIR%
%CMAKE% -G %CMAKE_GENERATOR% -Wno-dev "%~dp0"
POPD

:Exit

POPD

PAUSE
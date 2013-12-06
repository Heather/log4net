@echo off

::make
SETLOCAL ENABLEDELAYEDEXPANSION

::env
if %PROCESSOR_ARCHITECTURE%==x86 (
	set NET="%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\"
    set WinSDK="C:\Program Files\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\"
    set nant="D:\Program Files\NAnt\bin\"
    set nmake="D:\Program Files\Microsoft Visual Studio 12.0\VC\bin\nmake.exe"
) else (
	set NET="%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\"
    set WinSDK="C:\Program Files(x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\"
    set nmake="D:\Program Files(x86)\Microsoft Visual Studio 12.0\VC\bin\nmake.exe"
    set nant="D:\Program Files\NAnt\bin\"
    set nant="D:\Program Files\Microsoft Visual Studio 12.0\VC\bin\nmake.exe"
)

SET PATH=%nant%;%WinSDK%;%NET%;%PATH%

IF "%1"=="-?" GOTO CommandLineOptions

REM Figure out the path to the log4net directory
CALL :ComputeBase %~f0
SET LOG4NET_DIR=%RESULT%
ECHO LOG4NET_DIR is %LOG4NET_DIR%

REM Get path to NAnt.exe

REM Try and determine if NAnt is in the PATH
SET NANTEXE_PATH=nant.exe
"%NANTEXE_PATH%" -help >NUL: 2>NUL:
IF NOT ERRORLEVEL 1 goto FoundNAnt

REM Try hard coded path for NAnt
SET NANTEXE_PATH=C:\Program Files\NAnt\nant-0.85\bin\nant.exe
"%NANTEXE_PATH%" -help >NUL: 2>NUL:
IF NOT ERRORLEVEL 1 goto FoundNAnt

REM We have not found NAnt
ECHO.
ECHO NAnt does not appear to be installed. NAnt.exe failed to execute.
ECHO Please ensure NAnt is installed and can be found in the PATH.
GOTO EndError


:FoundNAnt
ECHO NANTEXE_PATH is %NANTEXE_PATH%

REM Setup the build file
IF EXIST nant.build (
        SET BUILD_FILE=nant.build
) ELSE (
        SET BUILD_FILE=%LOG4NET_DIR%\default.build
)

ECHO BUILD_FILE is %BUILD_FILE%

"%NANTEXE_PATH%" "-buildfile:%BUILD_FILE%" "set-release-build-configuration" "compile-net-4.0-cp"

REM ------------------------------------------
REM Expand a string to a full path
REM ------------------------------------------
:FullPath
SET RESULT=%~f1
GOTO :EOF

REM ------------------------------------------
REM Compute the current directory
REM given a path to this batch script.
REM ------------------------------------------
:ComputeBase
SET RESULT=%~dp1
REM Remove the trailing \
SET RESULT=%RESULT:~0,-1%
CALL :FullPath %RESULT%
GOTO :EOF


:EndOk
ENDLOCAL
EXIT /B 0

:EndError
ENDLOCAL
EXIT /B 1
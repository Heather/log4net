@echo off
setlocal
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

::make
build.cmd

::Handle errors pause
endlocal
pause
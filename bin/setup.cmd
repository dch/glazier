::@echo off
title Prepare to Relax.
:: this script should be run from within your preferred compilation environment
:: either vcvars32.bat x86 (for Visual Studio)
:: or setenv.cmd /Release /x86 (for Windows SDKs)
:: this allows it to set up the correct links so that later scripts don't need
:: to detect them - its a messy and complicated process to automate as each SDK
:: or VC release, and each Windows version has slightly different locations.

:: our goal is to get the path set up in this order:
:: erlang and couchdb build helper scripts
:: Microsoft VC compiler and SDK 7.0
:: cygwin path for other build tools like make
:: the remaining windows system path

:: C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\link.exe
:: C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\cl.exe
:: C:\Program Files\Microsoft SDKs\Windows\v7.0\mc.exe
:: etc
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if "%RELAX%"=="" set RELAX=C:\relax
if not exist %RELAX% mkdir %RELAX%

:: find our source tree from one level up from current bin
set GLAZIER=%~dp0..

:: set these paths into the user environment for future usage
setx GLAZIER %GLAZIER%
setx RELAX %RELAX%

:: now we can set up new paths as junction points
echo setting up links to tools, SDK and VC++

:: set up junction point to make finding stuff simpler in unix path
:: VS90ComnTools is the only variable set by the initial install of VC++ 9.0
:: VS90COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\
:: the Windows SDK uses a different variable only after you've call SetEnv.cmd first
:: VCINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\
if not exist "%RELAX%\bin" mklink /d  "%RELAX%\bin" "%GLAZIER%\bin"
if not exist "%RELAX%\bits" mklink /d  "%RELAX%\bits" "%GLAZIER%\bits"
if defined VCINSTALLDIR  mklink /d "%RELAX%\VC" "%VCINSTALLDIR%\.."
if defined VS90COMNTOOLS mklink /d "%RELAX%\VC" "%VS90COMNTOOLS%\..\.."
if not exist "%RELAX%\SDK" mklink /d "%RELAX%\SDK" "%programfiles%\Microsoft SDKs\Windows\v7.0"
if not exist "c:\cygwin\relax" mklink /d C:\cygwin\relax "%RELAX%"
::mklink /d "%RELAX%\openssl" c:\openssl

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
goto eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: transfer relevant environment variables across for later
::::: SDK vars
CPU=i386
FxTools=C:\Windows\Microsoft.NET\Framework\v3.5;C:\Windows\Microsoft.NET\Framework\v2.0.50727
Include=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\Include;C:\Program Files\Microsoft SDKs\Windows\v7.0\Include;C:\Program Files\Microsoft SDKs\Windows\v7.0\Include\gl;
Lib=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\Lib;C:\Program Files\Microsoft SDKs\Windows\v7.0\Lib;
MSSdk=C:\Program Files\Microsoft SDKs\Windows\v7.0
NODEBUG=1
ORIGINALPATH=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;c:\relax\winmerge;c:\relax\7zip;c:\relax\cmake\bin;c:\relax\bin;Z:\Dropbox\tools\pstools;c:\erlang\bin;C:\NuGet\bin;
OS=Windows_NT
Path=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\Bin;c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcpackages;C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE;C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin\x64;C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Windows\Microsoft.NET\Framework\v2.0.50727;C:\Program Files\Microsoft SDKs\Windows\v7.0\Setup;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;c:\relax\winmerge;c:\relax\7zip;c:\relax\cmake\bin;c:\relax\bin;Z:\Dropbox\tools\pstools;c:\erlang\bin;C:\NuGet\bin;
RegKeyPath=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7
SdkSetupDir=C:\Program Files\Microsoft SDKs\Windows\v7.0\Setup
SdkTools=C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin\x64;C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin
TARGETOS=WINNT
VCINSTALLDIR=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\
VCRoot=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\
VSRegKeyPath=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VS7

:: base env vars
ALLUSERSPROFILE=C:\ProgramData
APPDATA=C:\Users\couch\AppData\Roaming
CommonProgramFiles=C:\Program Files\Common Files
CommonProgramFiles(x86)=C:\Program Files (x86)\Common Files
CommonProgramW6432=C:\Program Files\Common Files
COMPUTERNAME=RELAX
ComSpec=C:\Windows\system32\cmd.exe
FP_NO_HOST_CHECK=NO
GLAZIER=Z:\r\glazier\bin\..
HOMEDRIVE=C:
HOMEPATH=\Users\couch
LOCALAPPDATA=C:\Users\couch\AppData\Local
LOGONSERVER=\\RELAX
NUMBER_OF_PROCESSORS=2
OS=Windows_NT
Path=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;c:\relax\winmerge;c:\relax\7zip;c:\relax\cmake\bin;c:\relax\bin;Z:\Dropbox\tools\pstools;c:\erlang\bin;C:\NuGet\bin;
PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
PROCESSOR_ARCHITECTURE=AMD64
PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 42 Stepping 7, GenuineIntel
PROCESSOR_LEVEL=6
PROCESSOR_REVISION=2a07
ProgramData=C:\ProgramData
ProgramFiles=C:\Program Files
ProgramFiles(x86)=C:\Program Files (x86)
ProgramW6432=C:\Program Files
PROMPT=$P$G
PSModulePath=C:\Windows\system32\WindowsPowerShell\v1.0\Modules\
PUBLIC=C:\Users\Public
RELAX=C:\relax
SESSIONNAME=Console
SystemDrive=C:
SystemRoot=C:\Windows
TEMP=C:\Users\couch\AppData\Local\Temp
TMP=C:\Users\couch\AppData\Local\Temp
tools=z:\Dropbox\tools
USERDOMAIN=relax
USERNAME=couch
USERPROFILE=C:\Users\couch
VS100COMNTOOLS=c:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools\
windir=C:\Windows
windows_tracing_flags=3
windows_tracing_logfile=C:\BVTBin\Tests\installpackage\csilogfile.log

:eof
endlocal

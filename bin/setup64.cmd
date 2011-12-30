::@echo off
title Prepare to Relax.
:: this script should be run from within your preferred compilation environment
:: either vcvars32.bat x64 (for Visual Studio)
:: or setenv.cmd /Release /x64 (for Windows SDKs)
:: this allows it to set up the correct links so that later scripts don't need
:: to detect them - its a messy and complicated process to automate as each SDK
:: or VC release, and each Windows version has slightly different locations.

:: our goal is to get the path set up in this order:
:: erlang and couchdb build helper scripts
:: Microsoft VC compiler and SDK 7.1
:: cygwin path for other build tools like make
:: the remaining windows system path

:: c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\amd64\link.exe
:: c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\amd64\cl.exe
:: C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\x64\mt.exe
:: C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\x64\MC.Exe
:: etc
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: find our source tree from one level up from current bin
if defined RELAX goto mountpoints
set RELAX=%~dp0..
mkdir %RELAX%
:: set these paths into the user environment for future usage
setx RELAX %RELAX%

:mountpoints
:: now we can set up new paths as links
echo setting up links to tools, SDK and VC++

:: VS2010 Ultimate x64 path setup
:: C:\Windows\Microsoft.NET\Framework\
:: C:\Windows\Microsoft.NET\Framework64\v3.5
:: C:\Windows\Microsoft.NET\Framework\v3.5
:: c:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE
:: c:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools
:: c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\Bin\amd64
:: c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\Bin\VCPackages
:: C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\NETFX 4.0 Tools\x64
:: C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\x64
:: C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin
:: C:\Windows\system32
:: C:\Windows
:: C:\Windows\System32\Wbem
:: C:\Windows\System32\WindowsPowerShell\v1.0\

:: VS2010 SDK 7.1 x64 environment (abridged)
:: Configuration=Debug
:: CURRENT_CPU=x64
:: INCLUDE=c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\INCLUDE;C:\Program Files\Microsoft SDKs\Windows\v7.1\INCLUDE;C:\Program Files\Microsoft SDKs\Windows\v7.1\INCLUDE\gl;c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\INCLUDE;
:: LIB=c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\Lib\amd64;C:\Program Files\Microsoft SDKs\Windows\v7.1\Lib\X64;c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB\AMD64;
:: LIBPATH=\;C:\Windows\Microsoft.NET\Framework\;C:\Windows\Microsoft.NET\Framework64\v3.5;C:\Windows\Microsoft.NET\Framework\v3.5;;c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\Lib\amd64;
:: PlatformToolset=Windows7.1SDK
:: PROCESSOR_ARCHITECTURE=AMD64
:: sdkdir=C:\Program Files\Microsoft SDKs\Windows\v7.1\
:: TARGET_CPU=x64
:: TARGET_PLATFORM=WIN7
:: ToolsVersion=4.0
:: VS100COMNTOOLS=c:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools\
:: WindowsSDKDir=C:\Program Files\Microsoft SDKs\Windows\v7.1\
:: WindowsSDKVersionOverride=v7.1
:: windows_tracing_flags=3
:: windows_tracing_logfile=C:\BVTBin\Tests\installpackage\csilogfile.log

:: set up junction point to make finding stuff simpler in unix path
:: VS2008
:: VS90ComnTools is the only variable set by the initial install of VC++ 9.0
:: VS90COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\
:: the Windows SDK uses a different variable only after you've call SetEnv.cmd first
:: VCINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\
:: VS2010
:: VCINSTALLDIR is missing on VS2010u / SDK7.1 but VS10COMNTOOLS is still there

if defined VS100COMNTOOLS mklink /d "%RELAX%\VC" "%VS100COMNTOOLS%..\.."
if defined VCINSTALLDIR  mklink /d "%RELAX%\VC" "%VCINSTALLDIR%.."
if defined VS90COMNTOOLS mklink /d "%RELAX%\VC" "%VS90COMNTOOLS%..\.."
if defined WindowsSDKDir mklink /d "%RELAX%\SDK" "%WindowsSDKDir%"
if not exist "%RELAX%\SDK" mklink /d "%RELAX%\SDK" "%programfiles%\Microsoft SDKs\Windows\v7.0"
if not exist "%RELAX%\SDK" mklink /d "%RELAX%\SDK" "%programfiles%\Microsoft SDKs\Windows\v7.0"
if not exist "c:\cygwin\relax" mklink /d C:\cygwin\relax "%RELAX%"
if not exist "C:\openssl" mklink /d c:\openssl "%RELAX%\openssl"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
goto eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem :: example relevant environment variables from a
rem windows 7 enterprise x64 install
rem ::::: SDK vars
rem CPU=i386
rem FxTools=C:\Windows\Microsoft.NET\Framework\v3.5;C:\Windows\Microsoft.NET\Framework\v2.0.50727
rem Include=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\Include;C:\Program Files\Microsoft SDKs\Windows\v7.0\Include;C:\Program Files\Microsoft SDKs\Windows\v7.0\Include\gl;
rem Lib=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\Lib;C:\Program Files\Microsoft SDKs\Windows\v7.0\Lib;
rem MSSdk=C:\Program Files\Microsoft SDKs\Windows\v7.0
rem NODEBUG=1
rem ORIGINALPATH=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;c:\relax\winmerge;c:\mozilla-build\7zip;c:\relax\cmake\bin;c:\relax\bin;Z:\Dropbox\tools\pstools;c:\erlang\bin;C:\NuGet\bin;
rem OS=Windows_NT
rem Path=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\Bin;c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcpackages;C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE;C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin\x64;C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Windows\Microsoft.NET\Framework\v2.0.50727;C:\Program Files\Microsoft SDKs\Windows\v7.0\Setup;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;c:\relax\winmerge;c:\mozilla-build\7zip;c:\relax\cmake\bin;c:\relax\bin;Z:\Dropbox\tools\pstools;c:\erlang\bin;C:\NuGet\bin;
rem RegKeyPath=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7
rem SdkSetupDir=C:\Program Files\Microsoft SDKs\Windows\v7.0\Setup
rem SdkTools=C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin\x64;C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin
rem TARGETOS=WINNT
rem VCINSTALLDIR=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\
rem VCRoot=c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\
rem VSRegKeyPath=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VS7
rem 
rem :: base env vars
rem ALLUSERSPROFILE=C:\ProgramData
rem APPDATA=C:\Users\couch\AppData\Roaming
rem CommonProgramFiles=C:\Program Files\Common Files
rem CommonProgramFiles(x86)=C:\Program Files (x86)\Common Files
rem CommonProgramW6432=C:\Program Files\Common Files
rem COMPUTERNAME=RELAX
rem ComSpec=C:\Windows\system32\cmd.exe
rem FP_NO_HOST_CHECK=NO
rem GLAZIER=Z:\r\glazier\bin\..
rem HOMEDRIVE=C:
rem HOMEPATH=\Users\couch
rem LOCALAPPDATA=C:\Users\couch\AppData\Local
rem LOGONSERVER=\\RELAX
rem NUMBER_OF_PROCESSORS=2
rem OS=Windows_NT
rem Path=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;c:\relax\winmerge;c:\mozilla-build\7zip;c:\relax\cmake\bin;c:\relax\bin;Z:\Dropbox\tools\pstools;c:\erlang\bin;C:\NuGet\bin;
rem PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
rem PROCESSOR_ARCHITECTURE=AMD64
rem PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 42 Stepping 7, GenuineIntel
rem PROCESSOR_LEVEL=6
rem PROCESSOR_REVISION=2a07
rem ProgramData=C:\ProgramData
rem ProgramFiles=C:\Program Files
rem ProgramFiles(x86)=C:\Program Files (x86)
rem ProgramW6432=C:\Program Files
rem PROMPT=$P$G
rem PSModulePath=C:\Windows\system32\WindowsPowerShell\v1.0\Modules\
rem PUBLIC=C:\Users\Public
rem RELAX=C:\relax
rem SESSIONNAME=Console
rem SystemDrive=C:
rem SystemRoot=C:\Windows
rem TEMP=C:\Users\couch\AppData\Local\Temp
rem TMP=C:\Users\couch\AppData\Local\Temp
rem tools=z:\Dropbox\tools
rem USERDOMAIN=relax
rem USERNAME=couch
rem USERPROFILE=C:\Users\couch
rem VS100COMNTOOLS=c:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools\
rem windir=C:\Windows
rem windows_tracing_flags=3
rem windows_tracing_logfile=C:\BVTBin\Tests\installpackage\csilogfile.log
rem 
:eof

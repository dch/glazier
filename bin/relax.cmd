@echo off
setlocal
pushd %BITS%

:: our goal is to get the path set up in this order
:: erlang and couchdb build helper scripts
:: Microsoft VC9 compiler and SDK 7.0 (link.exe and cl.exe from VC9, and mc.exe from the SDK)
:: cygwin path for other build tools like make
:: the remaining windows system path

:: this is complicated by the fact that on different builds of windows, VC installs to different places
:: C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\link.exe
:: C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\cl.exe
:: C:\Program Files\Microsoft SDKs\Windows\v7.0\mc.exes
:: etc
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set CYGWIN=nontsec
set DIRCMD=/ogen /p
::set JAVA_HOME=c:\Program Files\Java\jre1.6.0_01
mkdir c:\tmp > NUL: 2>&1
set TEMP=c:\tmp
set TMP=c:\tmp

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: get the VC9 path components set up
:: this should work where-ever VC9 is installed
call "%vs90comntools%\..\..\vc\vcvarsall.bat" x86

:: now we can set up new paths as junction points
echo setting up reparse points of new volumes

::VS90ComnTools is the only variable set by the initial install of VC++ 9.0
mklink /j d:\src\vs90 "%VS90COMNTOOLS%\..\.." > NUL: 2>&1
mklink /j d:\src\SDKs "C:\Program Files\Microsoft SDKs" > NUL: 2>&1

:: add ICU, cURL and OpenSSL libraries for C compilers to find later on in CouchDB and Erlang
set OPENSSL_PATH=d:\src\openssl
set CURL_PATH=d:\src\curl-7.21.1
set ICU_PATH=d:\src\icu-4.2
set COUCH_DRIVER_PATH=D:\src\apache-couchdb-1.0.1_otp_5.8\src\couchdb\priv\.libs

set INCLUDE=%INCLUDE%;%OPENSSL_PATH%\include\openssl;%CURL_PATH%\include\curl;%ICU_PATH%\include;
set LIBPATH=%LIBPATH%;%OPENSSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;%COUCH_DRIVER_PATH%
set LIB=%LIB%;%OPENSSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;%COUCH_DRIVER_PATH%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::check which version of erlang setup we want
:: choice.exe exists on all windows platforms since MSDOS but not on XP
:: choice /c ABC /t 30 /d c  /m "press A to use erlang R14A, B for erlang R13B04, C (or wait) to exit to the shell"
set /p choice=press A to use erlang R14A, B for erlang R13B04, C (or wait) to exit to the shell
:: then get to unix goodness as fast as possible
if /i "%choice%"=="c" goto win_shell
if /i "%choice%"=="b" goto R13B04
if /i "%choice%"=="a" goto R14A
:: else
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R14A
set ERL_TOP=/src/otp_src_R14A
set ERL_VER=5.8
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R13B04
set ERL_TOP=/src/otp_src_R13B04
set ERL_VER=5.7.5
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:unix_shell
%root%\cygwin\bin\bash /src/bin/relax.sh
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:win_shell
echo type exit to stop relaxing.
cmd.exe /k

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
endlocal

@echo off
title Time to Relax.
setlocal
pushd %GLAZIER%\bin

:: our goal is to get the path set up in this order
:: erlang and couchdb build helper scripts
:: Microsoft VC9 compiler and SDK 7.0 (link.exe and cl.exe from VC9, and mc.exe from the SDK)
:: cygwin path for other build tools like make
:: the remaining windows system path

:: this is complicated by the fact that on different builds of windows, VC installs to different places
:: C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\link.exe
:: C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\cl.exe
:: C:\Program Files\Microsoft SDKs\Windows\v7.0\mc.exe
:: etc
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set CYGWIN=nontsec nodosfilewarning
set DIRCMD=/ogen /p
::set JAVA_HOME=c:\Program Files\Java\jre1.6.0_01
mkdir c:\tmp > NUL: 2>&1
set TEMP=c:\tmp
set TMP=c:\tmp

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: get the VC9 path components set up
:: this should work where-ever VC9 is installed
:: but first clear out crud in current path
path=%windir%\system32;%windir%;%windir%\system32\wbem;%windir%\syswow64;
call "%vs90comntools%\..\..\vc\vcvarsall.bat" x86

:: now we can set up new paths as junction points
echo setting up reparse points of new volumes

::VS90ComnTools is the only variable set by the initial install of VC++ 9.0
:: set up junction point to make finding stuff simpler
:: the sysinternals tool works on all platforms incl XP & later
%GLAZIER%\bits\junction.exe "%RELAX%\vs90" "%VS90COMNTOOLS%\..\.."  > NUL: 2>&1
%GLAZIER%\bits\junction.exe "%RELAX%\SDKs" "%programfiles%\Microsoft SDKs\Windows"  > NUL: 2>&1
%GLAZIER%\bits\junction.exe C:\mozilla-build\msys\relax "%RELAX%" > NUL: 2>&1
%GLAZIER%\bits\junction.exe C:\cygwin\relax "%RELAX%" > NUL: 2>&1
%GLAZIER%\bits\junction.exe "%RELAX%\openssl" c:\openssl > NUL: 2>&1

:: add ICU, cURL and OpenSSL libraries for C compilers to find later on in CouchDB and Erlang
set OPENSSL_PATH=%RELAX%\openssl
set CURL_PATH=%RELAX%\curl-7.21.1
set ICU_PATH=%RELAX%\icu

:: set path for curl & couch compilation later on
set INCLUDE=%INCLUDE%;%OPENSSL_PATH%\include\openssl;%CURL_PATH%\include\curl;%ICU_PATH%\include;
set LIBPATH=%LIBPATH%;%OPENSSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;
set LIB=%LIB%;%OPENSSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::check which version of erlang setup we want
:: choice.exe exists on all windows platforms since MSDOS but not on XP
set /p choice=press 4 to use erlang R14B, 3 to use erlang R14A, 2 for erlang R13B04, 1 (or wait) to exit to the shell
:: then get to unix goodness as fast as possible
if /i "%choice%"=="1" goto win_shell
if /i "%choice%"=="2" goto R13B04
if /i "%choice%"=="3" goto R14A
if /i "%choice%"=="4" goto R14B
:: else
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R14B
set ERL_TOP=/relax/otp_src_R14B
set ERL_VER=5.8.1
set OTP_VER=R14B
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R14A
set ERL_TOP=/relax/otp_src_R14A
set ERL_VER=5.8
set OTP_VER=R14A
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R13B04
set ERL_TOP=/relax/otp_src_R13B04
set ERL_VER=5.7.5
set OTP_VER=R13B04
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:unix_shell
title Building in %ERL_TOP% with OTP %OTP_VER% and Erlang v%ERL_VER%
c:\cygwin\bin\bash %GLAZIER%\bin\relax.sh
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:win_shell
echo type exit to stop relaxing.
cmd.exe /k

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
endlocal

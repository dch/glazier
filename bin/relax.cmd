@echo off
title Prepare to Relax.
setlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\bin
set CYGWIN=nontsec nodosfilewarning

:: our goal is to get the path set up in this order
:: erlang and couchdb build helper scripts
:: Microsoft VC compiler and SDK (link, cl, mc, mt, link)
:: cygwin path for other build tools like make
:: the remaining windows system path

:: this is complicated by the fact that on different builds of windows
:: VC installs various bits to different places
:: C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\link.exe
:: C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\cl.exe
:: C:\Program Files\Microsoft SDKs\Windows\v7.0\mc.exe
:: etc

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: first clear out crud in current path
path=%windir%\system32;%windir%;%windir%\system32\wbem;%windir%\syswow64;

:: LIB and INCLUDE are preset by Windows SDK and/or Visual C++ shells
:: these are re-set manually here to ensure the *case* of the variable
:: _name_ is correct so that in cygwin you are not confused by Lib/Include
set LIB= && set LIB=%LIB%;%RELAX%\VC\VC\lib;%RELAX%\SDK\lib
set INCLUDE= && SET INCLUDE=%INCLUDE%;%RELAX%\VC\VC\Include;%RELAX%\SDK\Include;%RELAX%\SDK\Include\gl;

:: set path for curl & couch compilation later on
set INCLUDE=%INCLUDE%;%SSL_PATH%\include\openssl;%CURL_PATH%\include\curl;%ICU_PATH%\include;
set LIBPATH=%LIBPATH%;%SSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;
set LIB=%LIB%;%SSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;

:: set LINK & CL to resolve manifest binding issues & virtualisation hack in ld.sh#171
set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
:: SETting LINK buggers up couchdb/src/couchdb/priv libtool and subsequent driver creation
:: set LINK=/manifestuac:"level=asInvoker uiAccess=false"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::check which version of erlang setup we want
:: choice.exe exists on all windows platforms since MSDOS but not on XP
set /p choice=press 2 for erlang R14b02, 1 for erlang R14b01, 3 for R14b03, 4 to use erlang R13b04, 0 (or wait) to exit to the shell
:: then get to unix goodness as fast as possible
if /i "%choice%"=="0" goto win_shell
::::if /i "%choice%"=="2" goto R......
if /i "%choice%"=="4" goto R13B04
if /i "%choice%"=="1" goto R14B01
if /i "%choice%"=="2" goto R14B02
if /i "%choice%"=="3" goto R14B03
:: else
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R14B01
set ERL_TOP=/relax/otp_src_R14B01
set ERL_VER=5.8.2
set OTP_VER=R14B01
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R14B02
set ERL_TOP=/relax/otp_src_R14B02
set ERL_VER=5.8.3
set OTP_VER=R14B02
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R14B03
set ERL_TOP=/relax/otp_src_R14B03
set ERL_VER=5.8.4
set OTP_VER=R14B03
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

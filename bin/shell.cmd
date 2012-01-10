@echo off
title Time to Relax.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set CYGWIN=nontsec nodosfilewarning
if not exist c:\tmp mkdir c:\tmp
set TEMP=c:\tmp
set TMP=c:\tmp

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: following settings allow Erlang build to locate openssl correctly
:: and CouchDB to find ICU, Curl, and SSL if required
set USE_SSLEAY=1
set USE_OPENSSL=1
if not defined SSL_PATH  set SSL_PATH=%RELAX%\openssl
if not defined ICU_PATH  set ICU_PATH=%RELAX%\icu
if not defined CURL_PATH set CURL_PATH=%RELAX%\curl
if not defined ZLIB_PATH set ZLIB_PATH=%RELAX%\zlib

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: LIB and INCLUDE are preset by Windows SDK and/or Visual C++ shells
:: however VC++ uses LIB & INCLUDE and SDK uses Lib & Include. In Cygwin
:: these are *NOT* the same but when we shell out to CL.exe and LINK.exe
:: all is well again

set LIB=%RELAX%\VC\VC\lib;%RELAX%\SDK\lib;%LIB%
SET INCLUDE=%RELAX%\VC\VC\Include;%RELAX%\SDK\Include;%RELAX%\SDK\Include\gl;%INCLUDE%

set INCLUDE=%INCLUDE%;%SSL_PATH%\include\openssl;%SSL_PATH%\include;%CURL_PATH%\include\curl;%ICU_PATH%\include;%ZLIB_PATH%\include;
set LIBPATH=%LIBPATH%;%SSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;%ZLIB_PATH%\lib;
set LIB=%LIB%;%SSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;%ZLIB_PATH%\lib;

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::check which version of erlang setup we want
:: choice.exe exists on all windows platforms since MSDOS but not on XP
echo select:
echo       3 for R14b03
echo       4 for R14b04
echo       5 for R15B
echo       1 for R15b01
set /p choice=or 0 to exit to the shell.
:: then get to unix goodness as fast as possible
if /i "%choice%"=="0" goto win_shell
::::if /i "%choice%"=="2" goto R......
if /i "%choice%"=="3" goto R14B03
if /i "%choice%"=="4" goto R14B04
if /i "%choice%"=="5" goto R15B
if /i "%choice%"=="1" goto R15B01
:: else
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R14B03
set ERL_TOP=/relax/otp_src_R14B03
set ERTS_VSN=5.8.4
set OTP_REL=R14B03
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R15B
set ERL_TOP=/relax/otp_src_R15B
set ERTS_VSN=5.9
set OTP_REL=R15B
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R15B01
set ERL_TOP=/relax/otp_src_R15B01
set ERTS_VSN=5.9.1
set OTP_REL=R15B01
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:R14B04
set ERL_TOP=/relax/otp_src_R14B04
set ERTS_VSN=5.8.5
set OTP_REL=R14B04
goto unix_shell

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:unix_shell
title Building in %ERL_TOP% with OTP %OTP_REL% and Erlang v%ERTS_VSN%
c:\cygwin\bin\bash %RELAX%\bin\relax.sh
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:win_shell
echo type exit to stop relaxing.
cmd.exe /k

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

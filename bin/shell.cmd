@echo off
title Time to Relax.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set CYGWIN=nontsec nodosfilewarning
if not exist c:\temp mkdir c:\temp
set TEMP=c:\temp
set TMP=c:\temp

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

:: relax for couchdb
:: werldir for building erlang

if not defined RELAX setx RELAX e:\relax > NUL:
if not defined RELAX set RELAX=e:\relax
if not defined WERL_DIR setx WERL_DIR c:\werl > NUL:
if not defined WERL_DIR set WERL_DIR=c:\werl

set INCLUDE=%INCLUDE%;%SSL_PATH%\include\openssl;%SSL_PATH%\include;%CURL_PATH%\include\curl;%ICU_PATH%\include;
set LIBPATH=%LIBPATH%;%SSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;
set LIB=%LIB%;%SSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: check which version of erlang setup we want
:: pick up from jenkins if required
if not defined BUILD_WITH_JENKINS goto select
if not defined OTP_REL goto select
goto %OTP_REL%
:: no default, so let's ask the user instead!
:: choice.exe exists on all windows platforms since MSDOS but not on XP
:select
echo Select an Erlang:
echo       7 for Erlang 17.5 (default)
echo       8 for Erlang 18.0
echo       1 for Erlang 18.1
set /p choice="Make your selection ===> "
if /i "%choice%"=="0" goto win_shell
if /i "%choice%"=="7" goto 17.5
if /i "%choice%"=="8" goto 18.0
if /i "%choice%"=="1" goto 18.1
:: else
goto 18.1

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:17.5
set ERTS_VSN=6.4
set OTP_REL=17.5
goto shell_select

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:18.0
set ERTS_VSN=7.0
set OTP_REL=18.0
goto shell_select

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:18.1
set ERTS_VSN=7.1
set OTP_REL=18.1
goto shell_select

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:shell_select
for /f "usebackq" %%i in (`c:\tools\cygwin\bin\cygpath.exe %WERL_DIR%`) do @set WERL_PATH=%%i

echo Select a shell:
echo       w for Windows prompt (default)
echo       b for bash prompt
echo       p for PowerShell prompt
set /p choice="Make your selection ===> "
if /i "%choice%"=="w" goto win_shell
if /i "%choice%"=="b" goto unix_shell
if /i "%choice%"=="p" goto ps_shell
:: else
goto :win_shell

:unix_shell
set ERL_TOP=%WERL_PATH%/otp_src_%OTP_REL%
color
title Building in %ERL_TOP% with OTP %OTP_REL% and Erlang v%ERTS_VSN%
c:\tools\cygwin\bin\bash %relax%\bin\shell.sh
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:win_shell
set ERL_TOP=%WERL_DIR%\otp_src_%OTP_REL%
echo Type exit to stop relaxing.
title On the couch. Type exit to stop relaxing.
:: Need these things on the path to build/run CouchDB
set PATH=%ERL_TOP%\release\win32\erts-%ERTS_VSN%\bin;%ERL_TOP%\bootstrap\bin;%ERL_TOP%\erts\etc\win32\cygwin_tools\vc;%ERL_TOP%\erts\etc\win32\cygwin_tools;%RELAX%\bin;%PATH%;%ICU_PATH%\bin64;%RELAX%\js-1.8.5\js\src\dist\bin;%RELAX%\curl\lib;c:\ProgramData\chocolatey\lib\python3\tools\Scripts;C:\Program Files\nodejs
cmd.exe /k
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:ps_shell
echo Type exit to stop relaxing.
title On the couch. Type exit to stop relaxing.
set PATH=%ERL_TOP%\release\win32\erts-%ERTS_VSN%\bin;%ERL_TOP%\bootstrap\bin;%ERL_TOP%\erts\etc\win32\cygwin_tools\vc;%ERL_TOP%\erts\etc\win32\cygwin_tools;c:\relax\bin;%PATH%;%ICU_PATH%\bin64;C:\Relax\js-1.8.5\js\src\dist\bin;C:\relax\curl\lib;c:\ProgramData\chocolatey\lib\python3\tools\Scripts;C:\Program Files\nodejs
powershell
goto eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

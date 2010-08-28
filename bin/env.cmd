@echo off
:proclaim our greatness
set CWB_TITLE=CouchDB make a Windows Build Server
set CWB_VER=v0.3
echo %CWB_TITLE% %CWB_VER%
title %CWB_TITLE% %CWB_VER%

:quit here as we are not the expected couchdb user
if "%USERNAME%"=="couchdb" goto setup_environment

:setup_couchuser
::net user administrator couchdb1.0.0
net user couchdb 1dot0 /add  > NUL:
net localgroup administrators couchdb /add  > NUL:
echo done.
echo please disable UAC and IE ESC if you are on win2008
echo * disable UAC / control panel / user accts / turn UAC off / restart later
echo * start menu / server manager / 2nd pane / configure IE ESC

pause

echo you will need to login again as couchdb 1dot0
echo to continue the installation
echo press any key to be logged off
pause > NUL:
logoff
goto :eof

:setup_environment
if not "%USERNAME%"=="couchdb" logoff
::we are running as couchdb user

set ROOT=%~d0
echo found root volume: %ROOT%
echo setting up new environment
set SRC=%ROOT%\src
set BIN=%ROOT%\glazier\bin
set BITS=%ROOT%\glazier\bits
set CORE=%BIN%;%BIN%\uxtools;%BIN%\pstools;%BIN%\openssl;

setx ROOT %ROOT% > NUL:
setx SRC %SRC% > NUL:
setx BIN %BIN% > NUL:
setx BITS %BITS% > NUL:
setx CORE %CORE% > NUL:

path=%path%;%CORE%
pushd %BITS%

echo give you some helpful icons
xcopy "%BITS%\desktop\*.lnk" "%userprofile%\desktop\" /y
echo done.

echo disable various enhanced security functions that complicate build on win2008 server
bcdedit.exe /set {current} nx AlwaysOff > NUL:
echo done.

:: reg files seem to need to be loaded from local storage not EBS volume
copy *.reg "%temp%\" /y
pushd "%temp%"
regedit /s disable_aslr.reg > NUL:
regedit /s console_hkcu.reg > NUL:
regedit /s command_process_hkcu.reg > NUL:
echo done.
echo installing VC++ redistributable components
start /wait %BITS%\vcredist_x86.exe /q
echo done.
popd

echo install compilers -- gcc/cygwin, VC++ 2008 Express, mingw via mozilla
pause

::start /wait mozillabuildsetup-latest.exe
:: msys needs a fix by junction point to /c/ to be able to *build* javascript successfully
junction %systemdrive%\mozilla-build %ROOT%\mozilla-build

::start /wait setup.exe --local-install --quiet-mode
junction %systemdrive%\cygwin %root%\cygwin
setx CYGWIN nontsec > NUL:
:: should work fine from a cygwin softlink but doesn't
:: junction %systemdrive%\openssl %root%\src\openssl

start /wait D:\VS2008express_SP1_ENUX1504728\VCExpress\setup.exe
echo done.

echo install SDKs
pause
:: this takes *ages* to run so be patient\
start /wait D:\Windows7_SDK\Setup.exe
echo done.

echo install windows updates
pause
start /wait http://update.microsoft.com/microsoftupdate/v6
echo done.

::build tools are now all used directly off the snapshot after installation under /src/
::start /wait ispack-5.3.10-unicode.exe
::start /wait npp.5.7.Installer.exe
::start /wait nsis-2.46-setup.exe
::start /wait Win32OpenSSL-1_0_0a.exe

echo OK: normal exit
echo press a key to reboot now to complete installation
pause
shutdown -r -t 5 -y -f
goto eof
:fail
echo FAIL: abnormal exit

:eof
pause

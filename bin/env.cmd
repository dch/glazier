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

set GLAZIER=%~dp0..
echo found glazier: %GLAZIER%
echo setting up new environment

path=%path%;%glazier%\bin
pushd %GLAZIER%\bits

echo give you some helpful icons
xcopy "desktop\*.lnk" "%userprofile%\desktop\" /y
echo done.

echo disable various enhanced security functions that complicate build on win2008 server
bcdedit.exe /set {current} nx AlwaysOff > NUL:
echo done.

:: reg files seem to need to be loaded from local storage not EBS volume
pushd %GLAZIER%\bin
copy *.reg "%temp%\" /y
pushd "%temp%"
regedit /s disable_aslr.reg > NUL:
regedit /s console_hkcu.reg > NUL:
regedit /s command_process_hkcu.reg > NUL:
regedit /s disable_sehop_kb956607.reg > NUL:
echo done.
popd

echo install windows updates
pause
start /wait http://update.microsoft.com/microsoftupdate/v6
echo done.

echo OK: normal exit
echo press a key to reboot now to complete installation
pause
shutdown -r -t 5 -y -f
goto eof
:fail
echo FAIL: abnormal exit

:eof

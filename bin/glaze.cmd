@echo off
echo Build CouchDB under Windows - Time to Relax v0.1
setlocal

:quit here as we are not the expected couchdb user
if "%USERNAME%"=="couchdb" goto environment

pause

echo you will need to login again as couchdb 1dot0
echo to continue the installation
echo press any key to be logged off
pause > NUL:
logoff
goto :eof

:environment
if not "%USERNAME%"=="couchdb" logoff
::we are running as couchdb build user

:: find our source tree from one level up from current bin
set GLAZIER=%~dp0..
path=%~dp0;%PATH%;

:: install stuff to %systemdrive%\relax which is usually C:\relax unless otherwise requested
if "%DEST%" == "" set DEST=%SYSTEMDRIVE%\relax

pushd %GLAZIER%\bits

call get_bits.cmd tools
call get_bits.cmd compilers
call get_bits.cmd source

:eof
endlocal
echo press a key to reboot now to complete installation
pause
::shutdown -r -t 5 -y -f
@echo off
echo Build CouchDB under Windows - Time to Relax v0.3

:: find our source tree from one level up from current bin
set GLAZIER=%~dp0..
path=%~dp0;%PATH%;

:: install stuff to %systemdrive%\relax which is usually C:\relax unless otherwise requested
if "%RELAX%" == "" set RELAX=%SYSTEMDRIVE%\relax

:: set these paths into the user environment for future usage
setx GLAZIER %GLAZIER%
setx RELAX %RELAX%

echo START	retrieving packages...
pushd %GLAZIER%\bits
call get_bits.cmd tools
call get_bits.cmd compilers
call get_bits.cmd source
echo DONE	retrieving packages

:: md5 checksums
echo START	md5 checksums...
::TODO md5sum --check md5sums.txt || echo FAILED: please check any missing or failed files && goto :eof
echo DONE	md5 checksums

:: unpack stuff
echo START	unpacking tools in [%RELAX%]...
mkdir %RELAX% > NUL: 2>&1
pushd %RELAX%

:: 7zip is used for unpacking the ISO images
echo START	installing 7zip...
%GLAZIER%\bits\7z465.exe /S /D=%RELAX%\7zip
echo DONE	installing 7zip

:: unpack the ISOs into %RELAX%\ISOs\{name}
echo START	unpacking ISOs in [%RELAX%\ISOs] ...
mkdir %RELAX%\ISOs > NUL: 2>&1
%RELAX%\7zip\7z.exe x %GLAZIER%\bits\*.iso -aos -o%RELAX%\ISOs\*
echo DONE	unpacking ISOs in [%RELAX%\ISOs]

:: start installing stuff
echo START	installing compilers...
echo START	MS VS2008 Express...
:: TODO remove hackage that prevents installing MSSQL burning CPU and space
pushd %RELAX%\ISOs\VS2008ExpressWithSP1ENUX1504728\VCExpress\WCU\
rd /s/q dist > NUL: 2>&1
mkdir dist
for %%i in (dotNetFramework Silverlight SMO SSE) do @move %i dist\
cd .. && start /wait setup.exe /q /norestart
popd
echo DONE	MS VS2008 Express

echo START	installing Windows 7 SDK...
:: if we merge the 32 and 64 bit SDK folders first, Windows installs the right one
pushd %RELAX%\ISOs\
xcopy GRMSDKX_EN_DVD Win7SDK\ /e /y
xcopy GRMSDK_EN_DVD Win7SDK\ /e /y
win7sdk\setup.exe /q
popd
echo DONE	installing Windows 7 SDK

echo START	installing cygwin...
%GLAZIER%\bits\setup.exe
:: c:\cygwin
:: all users
:: store bits in d:\glazier\bits\
:: direct connection
:: http uidaho
:: defaults + all DEVEL + utils/file
echo END	installing cygwin

echo START	installing latest mozilla build tools...
start /wait %GLAZIER%\bits\mozillaBuildSetup-Latest.exe /S
echo DONE	installing mozilla build tools

echo DONE	unpacking tools in [%RELAX%]

:unpack source
echo START	install wxWidgets...
start /wait %RELAX%\7zip\7z.exe x %GLAZIER%\bits\wxMSW* -aos -o%RELAX%\
echo DONE	install wxWidgets
::TODO tweak .h files

echo START	install ICU...
start /wait %RELAX%\7zip\7z.exe x %GLAZIER%\bits\icu* -aos -o%RELAX%\
echo DONE	install ICU


echo START	install vcredist...
xcopy %GLAZIER%\bits\vcredist_x86.exe DEST%\ /y /f
echo DONE	install vcredist

:tools install
echo START	junction points...
%GLAZIER%\bits\junction.exe /accepteula
:: TODO we want to get an env var set by VS2008 install but it  doesn't exist
:: TODO until this cmd.exe dies and a new one starts up ... bugger
:: set up junction point to make finding stuff simpler
:: the sysinternals tool works on all platforms incl XP & later
::%GLAZIER%\bits\junction.exe "%RELAX%\vs90" "%VS90COMNTOOLS%\..\.."
::%GLAZIER%\bits\junction.exe "%RELAX%\SDKs" "%programfiles%\Microsoft SDKs\Windows"
:: so we move these into relax.cmd when the var is available after :eof reboot
echo END	making junction points

echo START	install win32 OpenSSL...
start /wait %GLAZIER%\bits\Win32OpenSSL-1_0_0a.exe /silent /sp- /suppressmsgboxes /dir=%systemdrive%\openssl
:: TODO fails on XP and 2003 but may not be needed ... or use sysinternals junction.exe or some other tool, or try with symlink only in cygwin
%GLAZIER%\bits\junction.exe %RELAX%\openssl %systemdrive%\openssl
echo DONE	install win32 OpenSSL


echo START	install NSIS...
start /wait %GLAZIER%\bits\nsis-2.46-setup.exe /S /D=%RELAX%\nsis
echo DONE	install NSIS


echo START	install Inno...
start /wait %GLAZIER%\bits\isetup-5.3.10-unicode.exe /silent /dir="%RELAX%\inno5"
echo DONE	install Inno

echo START	install NotepadPlus...
start /wait %GLAZIER%\bits\npp.5.7.Installer.exe /S /D=%RELAX%\npp5
echo DONE	install NotepadPlus

:eof
::echo please reboot now to complete installation
::pause
::TODO shutdown -r -t 5 -y -f
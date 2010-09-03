@echo off
echo Build CouchDB under Windows - Time to Relax v0.1
setlocal

:: find our source tree from one level up from current bin
set GLAZIER=%~dp0..
path=%~dp0;%PATH%;

:: install stuff to %systemdrive%\relax which is usually C:\relax unless otherwise requested
if "%DEST%" == "" set DEST=%SYSTEMDRIVE%\relax

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
echo START	unpacking tools in [%DEST%]...
mkdir %DEST% > NUL: 2>&1
pushd %DEST%

:: 7zip is used for unpacking the ISO images
echo START	installing 7zip...
%GLAZIER%\bits\7z465.exe /S /D=%DEST%\7zip
echo DONE	installing 7zip

:: unpack the ISOs into %DEST%\ISOs\{name}
echo START	unpacking ISOs in [%DEST%\ISOs] ...
mkdir %DEST%\ISOs > NUL: 2>&1
%DEST%\7zip\7z.exe x %GLAZIER%\bits\*.iso -aos -o%DEST%\ISOs\*
echo DONE	unpacking ISOs in [%DEST%\ISOs]

:: start installing stuff
echo START	installing compilers...
echo START	MS VS2008 Express...
:: TODO remove hackage that prevents installing MSSQL burning CPU and space
pushd %DEST%\ISOs\VS2008ExpressWithSP1ENUX1504728\VCExpress\WCU\
rd /s/q dist > NUL: 2>&1
mkdir dist
for %%i in (dotNetFramework Silverlight SMO SSE) do @move %i dist\
cd .. && start /wait setup.exe /q /norestart
popd
echo DONE	MS VS2008 Express

echo START	installing Windows 7 SDK...
:: if we merge the 32 and 64 bit SDK folders first, Windows installs the right one
pushd %DEST%\ISOs\
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

echo DONE	unpacking tools in [%DEST%]

:unpack & tweak source
echo START	install wxWidgets...
%DEST%\7zip\7z.exe x %GLAZIER%\bits\wxMSW* -aos -o%DEST%\*
echo DONE	install wxWidgets
::TODO tweak .h files

echo START	install win32 OpenSSL...
%GLAZIER%\bits\Win32OpenSSL-1_0_0a.exe /verysilent /sp- /suppressmsgboxes /dir=%systemdrive%\openssl
echo DONE	install win32 OpenSSL


echo
:eof
endlocal
::echo please reboot now to complete installation
::pause
::TODO shutdown -r -t 5 -y -f
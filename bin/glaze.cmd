@echo off
echo Build CouchDB under Windows - Time to Relax v0.7

:: install stuff to C:\relax unless otherwise requested
if "%relax%" == "" set relax=c:\relax

:: find our source tree from one level up from current bin
path=%~dp0;%~dp0..\bits;%relax%\7zip;%relax%\bin;%path%;

:: set these paths into the user environment for future usage
setx RELAX %relax%

:: set up folders
cd %relax%
mkdir bits bin release

echo START	retrieving packages...
pushd bits
aria2c.exe --force-sequential=false --max-connection-per-server=4  --check-certificate=false --auto-file-renaming=false --input-file=%relax%/downloads.md --max-concurrent-downloads=5 --dir=%relax%/bits --save-session=a2session.txt
echo DONE	retrieving packages

:: md5 checksums
echo START	md5 checksums...
md5sum.exe --check md5sums.txt || echo FAILED: please check any missing or failed files && goto eof
echo DONE	md5 checksums

:: unpack stuff
echo START	unpacking tools in [%relax%]...
pushd %relax%

:: 7zip is used for many things
echo START	installing 7zip...
start /wait bits\7z465.exe /S /D=7zip\
echo DONE	installing 7zip

echo START	installing cygwin...
bits\setup.exe
:: c:\cygwin
:: all users
:: store bits in d:\glazier\bits\
:: direct connection
:: http uidaho or ftp ucmirror.canterbury.ac.nz
:: defaults + all DEVEL + UTILS/file
mklink /d c:\cygwin\relax %relax%
echo END	installing cygwin

echo START	installing latest mozilla build tools...
start /wait bits\mozillaBuildSetup-Latest.exe /S
echo DONE	installing mozilla build tools

echo START	install vcredist...
:: patch in Erlang R14B03 will look for it here
xcopy bits\vcredist_x86.exe %relax%\ /y /f
echo DONE	install vcredist

echo START	install win32 assembler...
7z x bits\nasm-2.09.07-win32.zip -o%relax%\ -y
move nasm* nasm
echo DONE	install win32 assembler

echo START      install strawberry perl...
7z x bits\strawberry-perl-5.12.2.0-portable.zip -o%relax%\strawberry\ -y
echo DONE	install strawberry perl

echo DONE	unpacking tools in [%relax%]

:unpack source
echo START	install wxWidgets...
7z x bits\wxMSW* -aoa -y -o%relax%\
mkdir c:\cygwin\opt\local\pgm
mklink /d c:\cygwin\opt\local\pgm\wxWidgets-2.8.11 c:\relax\wxMSW-2.8.11
echo DONE	install wxWidgets

echo START	install ICU...
start /wait 7z.exe x bits\icu* -aoa -o%relax%\
echo DONE	install ICU

echo START	install win32 OpenSSL...
:: now we build from source using %relax%/nasm and %relax%/strawberry later on
mkdir %relax%\openssl
mklink /d c:\openssl %relax%\openssl
echo DONE	install win32 OpenSSL source

echo START	install NSIS...
start /wait bits\nsis-2.46-setup.exe /s /d=%relax%\nsis
echo DONE	install NSIS

echo START	install Inno...
start /wait bits\isetup-5.4.2-unicode.exe /silent /dir="%relax%\inno5"
echo DONE	install Inno

echo START	install NotepadPlus...
7z x  bits\npp.5.8.7.bin.minimalist.7z -o%relax%\npp
echo DONE	install NotepadPlus

:eof
::echo please reboot now to complete installation
::pause
::TODO shutdown -r -t 5 -y -f

setlocal
path=%path%;c:\mozilla-build\7zip;
:: read the version of wxWidgets from the wxMSW source distribution
:: wx_ver is used later on only in this script to set up a softlink
:: so that Erlang finds it in the correct location
for %%i in ("%glazier%\bits\wxMSW*.zip") do set wx_src=%%~ni
set wx_ver=%wx_src:wxmsw=wxWidgets%
setx wx_ver %wx_ver%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if exist c:\cygwin\opt\local\pgm\%wx_ver% goto build
if exist %relax%\%wx_src% goto build
7z.exe x %glazier%\bits\wxMSW* -aoa -y -o%relax%\
mkdir c:\cygwin\opt\local\pgm > NUL: 2>&1
mklink /d c:\cygwin\opt\local\pgm\%wx_ver% %relax%\%wx_src%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:build
:: we need to modify setup.h to have full wx support in Erlang
:: wx docs also advise modifying the following
::  lib\vc_lib\msw\wx\setup.h          VC++ static, wxMSW
::  lib\vc_lib\mswud\wx\setup.h        VC++ static, wxMSW, Unicode, debug
::  lib\vc_lib\mswunivd\wx\setup.h     VC++ static, wxUniversal, debug
type %glazier%\bits\wxwidgets_setup.h >> %relax%\%wx_src%\include\wx\msw\setup.h

nmake BUILD=release SHARED=0 UNICODE=1 USE_OPENGL=1 USE_GDIPLUS=1 DIR_SUFFIX_CPU= -f makefile.vc
pushd %RELAX%\%wx_src%\build\msw
nmake BUILD=release SHARED=0 UNICODE=1 USE_OPENGL=1 USE_GDIPLUS=1 DIR_SUFFIX_CPU= -f makefile.vc
::rd /s/q vc_msw vc_mswd vc_mswu vc_mswud >NUL: 2>&1
popd
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %RELAX%\wxMSW*\contrib\build\stc
nmake BUILD=release SHARED=0 UNICODE=1 USE_OPENGL=1 USE_GDIPLUS=1 DIR_SUFFIX_CPU= -f makefile.vc
::rd /s/q vc_msw vc_mswd vc_mswu vc_mswudpopd >NUL: 2>&1
goto eof
:::::::::::::::::::::::::::::::::::::::::::::
:: future notes for using 2.9.2
:: hack ERL_TOP/lib/wx/configure.in and replace all 2.8 with 2.9
:: it also looks like changes to setup.h might not be needed either
:: folder names have shifted as well
pushd %RELAX%\wxMSW*\src\msw
pushd %RELAX%\wxMSW*\src\stc

:: or try this approach
:: under wxMSW 2.8.11 using the same upgrade shenanigans as before
pushd %RELAX%\wxMSW*\build\msw
set vsconsoleoutput=1
devenv wx.sln /upgrade
devenv wx.sln /build "Unicode Release|Win32"
devenv wx.sln /build "Unicode Debug|Win32"
pushd %RELAX%\wxMSW*\contrib\build\stc
devenv stc.sln /upgrade
devenv stc.sln /build "Unicode Release|Win32"
devenv stc.sln /build "Unicode Debug|Win32"

:: use this to re-test in Erlang under wx without rerunning configure
:: pushd $ERL_TOP/lib/wx && /bin/sh ./configure --disable-option-checking '--prefix=/usr/local'  '--build=i686-pc-cygwin' 'build_alias=win32' '--host=win32' '--target=win32' 'CC=cc.sh' 'CXX=cc.sh' 'RANLIB=true' 'AR=ar.sh' '--enable-dynamic-ssl-lib' 'host_alias=win32' 'target_alias=win32' 'ERL_TOP=/relax/otp_src_R14B04' --cache-file=/relax/otp_src_R14B04/erts/autoconf/win32.config.cache --srcdir=.
:eof
endlocal

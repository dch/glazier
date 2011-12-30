setlocal
path=%path%;%relax%\7zip;
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if exist c:\cygwin\opt\local\pgm\wxWidgets-2.8.11 goto build
if exist %relax%\wxMSW-2.8.11 goto build
start /wait %RELAX%\7zip\7z.exe x %RELAX%\bits\wxMSW* -aoa -y -o%RELAX%\
mkdir c:\cygwin\opt\local\pgm > NUL: 2>&1
mklink /d c:\cygwin\opt\local\pgm\wxWidgets-2.8.11 c:\relax\wxMSW-2.8.11

:build
pushd %RELAX%\wxMSW*\build\msw
vcbuild /useenv  /platform:Win32 /M4 wx.sln "Unicode Release|Win32"
vcbuild /useenv  /platform:Win32 /M4 wx.sln "Unicode Debug|Win32"
popd
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %RELAX%\wxMSW*\contrib\build\stc
vcbuild /useenv /platform:Win32 /M4 stc.sln "Unicode Release|Win32"
vcbuild /useenv /platform:Win32 /M4 stc.sln "Unicode Debug|Win32"
popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

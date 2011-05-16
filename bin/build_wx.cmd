setlocal
call "%vs90comntools%\..\..\vc\vcvarsall.bat" x86
path=%path%;%relax%\7zip;%glazier%\bin;%glazier%\bits;


pushd %RELAX%\wxMSW*\build\msw
set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
vcbuild /useenv  /platform:Win32 /M4 wx.sln "Unicode Release|Win32"
vcbuild /useenv  /platform:Win32 /M4 wx.sln "Unicode Debug|Win32"
popd


pushd %RELAX%\wxMSW*\contrib\build\stc
vcbuild /useenv /platform:Win32 /M4 stc.sln "Unicode Release|Win32"
vcbuild /useenv /platform:Win32 /M4 stc.sln "Unicode Debug|Win32"
popd

endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

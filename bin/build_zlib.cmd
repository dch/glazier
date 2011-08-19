setlocal
call "%vs90comntools%\..\..\vc\vcvarsall.bat" x86
path=%path%;%relax%\7zip;%relax%\nasm;%relax%\strawberry\perl\bin;%glazier%\bin;%glazier%\bits;

set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
:: extract bundle and name
:: stash SSL version
pushd %glazier%\bits
del /f/q zlib*.tar
7z x zlib-*.tar.gz -y
for %%i in (zlib-*tar) do set zlib_ver=%%~ni
if defined zlib_ver rd /s/q %relax%\%zlib_ver%
.\setenv -u zlib_ver %zlib_ver%
7z x zlib-*.tar -o%relax%\ -y
popd

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\%zlib_ver%
:: enable-static-engine is now required for Erlang R14B03 to link against
pushd contrib\masmx86 && call bld_ml32.bat && popd
vcbuild /rebuild contrib\vstudio\vc9\zlibvc.sln "Release|Win32"
copy contrib\vstudio\vc9\x86\ZlibStatRelease\zlibstat.lib .
popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

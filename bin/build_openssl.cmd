setlocal
call "%vs90comntools%\..\..\vc\vcvarsall.bat" x86
path=%path%;%relax%\7zip;%relax%\nasm;%relax%\strawberry\perl\bin;%glazier%\bin;%glazier%\bits;

set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
:: extract bundle and name
:: stash SSL version
pushd %glazier%\bits
del /f/q openssl*.tar
7z x openssl-*.tar.gz -y
for %%i in (openssl-*tar) do set openssl_ver=%%~ni
if defined openssl_ver rd /s/q %relax%\%openssl_ver%
.\setenv -u openssl_ver %openssl_ver%
7z x openssl-*.tar -o%relax%\ -y
popd

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\%openssl_ver%
:: enable-static-engine is now required for Erlang R14B03 to link against
perl Configure VC-WIN32 --prefix=%RELAX%\openssl enable-static-engine
call ms\do_nasm
nmake -f ms\ntdll.mak
nmake -f ms\ntdll.mak test
nmake -f ms\ntdll.mak install

popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal
path=%path%;%relax%\7zip;%relax%\nasm;%relax%\strawberry\perl\bin;

set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
:: extract bundle and name
:: stash SSL version
del /f/q "%TEMP%\openssl*.tar"
7z x "%RELAX%\bits\openssl-*.tar.gz" -y -o"%TEMP%"

:: get the version of OpenSSL into the environment
for %%i in ("%TEMP%\openssl-*.tar") do set openssl_ver=%%~ni
setx openssl_ver %openssl_ver%

if exist "%RELAX%\openssl" rd /s/q %RELAX%\openssl
if defined openssl_ver rd /s/q %relax%\%openssl_ver%
7z x "%TEMP%\openssl-*.tar" -o%relax%\ -y

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\%openssl_ver%
:: from Erlang/OTP R14B03 onwards, OpenSSL is compiled in statically
:: this requires adding enable-static-engine and using target nt.mak
:: here are the older dynamic lib options commented out
perl Configure VC-WIN32 --prefix=%RELAX%\openssl
call ms\do_nasm
nmake -f ms\ntdll.mak
nmake -f ms\ntdll.mak test
nmake -f ms\ntdll.mak install

::perl Configure VC-WIN32 --prefix=%RELAX%\openssl enable-static-engine
::call ms\do_nasm
::nmake -f ms\nt.mak
::nmake -f ms\nt.mak test
::nmake -f ms\nt.mak install

popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal
path=%path%;c:\mozilla-build\7zip;%opt%\nasm;%opt%\strawberry\perl\bin;

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
:: extract bundle and name
:: stash SSL version
del /f/q "%TEMP%\openssl*.tar"
7z x "%glazier%\bits\openssl-*.tar.gz" -y -o"%TEMP%"

:: get the version of OpenSSL into the environment
for %%i in ("%TEMP%\openssl-*.tar") do set openssl_ver=%%~ni
setx openssl_ver %openssl_ver%
set SSL_PATH=%relax%\openssl
setx SSL_PATH %ssl_path%

if exist "%ssl_path%" rd /s/q %ssl_path%
:: set up a softlink for openssl as Erlang seems to dumb to find it
if not exist c:\openssl mklink /d c:\openssl "%relax%\openssl"
if defined openssl_ver rd /s/q %relax%\%openssl_ver%
7z x "%TEMP%\openssl-*.tar" -o%relax%\ -y

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\%openssl_ver%
perl Configure VC-WIN32 --prefix=%ssl_path%
call ms\do_nasm
nmake -f ms\ntdll.mak
nmake -f ms\ntdll.mak test
nmake -f ms\ntdll.mak install

:: from Erlang/OTP R14B03 onwards, OpenSSL is compiled in statically
:: this may need  adding enable-static-engine and using target nt.mak
:: but currently there seems to be an upstream bug to catch first...
::perl Configure VC-WIN32 --prefix=%RELAX%\openssl enable-static-engine
::call ms\do_nasm
::nmake -f ms\nt.mak
::nmake -f ms\nt.mak test
::nmake -f ms\nt.mak install

popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

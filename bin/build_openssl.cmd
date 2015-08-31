setlocal
path=%path%;c:\mozilla-build\7zip;%relax%\nasm;c:\strawberry\perl\bin;

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
:: extract bundle and name
:: stash SSL version
del /f/q "%TEMP%\openssl*.tar"
7z x "%relax%\bits\openssl-*.tar.gz" -y -o"%TEMP%"

:: get the version of OpenSSL into the environment
for %%i in ("%TEMP%\openssl-*.tar") do set openssl_ver=%%~ni
setx openssl_ver %openssl_ver%
set SSL_PATH=%relax%\openssl
setx SSL_PATH %ssl_path%

if exist "%ssl_path%" rd /s/q "%ssl_path%"
:: set up a softlink for openssl as Erlang seems to dumb to find it
if not exist c:\openssl mklink /j c:\openssl "%relax%\openssl"
if not exist c:\OpenSSL-Win64 mklink /j c:\OpenSSL-Win64 "%relax%\openssl"
if defined openssl_ver rd /s/q %relax%\%openssl_ver%
7z x "%TEMP%\openssl-*.tar" -o%relax%\ -y

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\%openssl_ver%
perl Configure VC-WIN64A --prefix=%ssl_path%
call ms\do_win64a
nmake -f ms\nt.mak clean
nmake -f ms\nt.mak
nmake -f ms\nt.mak test
nmake -f ms\nt.mak install

:: You may be surprised: the 64bit artefacts are indeed output in the
:: out32* sub-directories and bear names ending *32.dll. Fact is the
:: 64 bit compile target is so far an incremental change over the legacy
:: 32bit windows target. Numerous compile flags are still labelled "32"
:: although those do apply to both 32 and 64bit targets. 

popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

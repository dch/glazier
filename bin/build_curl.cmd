::setlocal
path=%path%;%relax%\openssl\bin;

for %%i in ("%relax%\bits\curl-*.zip") do set curl_ver=%%~ni
setx CURL_VER %curl_ver%
set CURL_VER=%curl_ver%
setx CURL_SRC %curl_src%
set CURL_SRC=%RELAX%\%curl_ver%
setx CURL_PATH %curl_path%
set CURL_PATH=%relax%\curl

if not defined SSL_PATH echo OpenSSL not built && goto eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
:: extract bundle and name
:: stash SSL version
if exist %curl_path% rd /s/q %curl_path%
if defined curl_ver rd /s/q %curl_src%
7z x "%RELAX%\bits\curl-*.zip" -o%RELAX% -y

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %curl_src%
:: ensure curl can find OpenSSL libraries
set USE_SSLEAY=1
set USE_OPENSSL=1
set OPENSSL_PATH=%SSL_PATH%
set INCLUDE=%INCLUDE%;%SSL_PATH%\include;%SSL_PATH%\include\openssl;
set LIBPATH=%LIBPATH%;%SSL_PATH%\lib;
set LIB=%LIB%;%SSL_PATH%\lib;
pushd %curl_src%
:: this make target works for vc2013
:: there is no 64-bit DLL target, so we do it here ourselves
nmake VC=VC12 VC12
cd lib
nmake /f Makefile.VC12 MACHINE=x64 cfg=release-dll
cd ..\src
nmake /f Makefile.VC12 MACHINE=x64 cfg=release-dll
popd
:: make this specific curl version available to CouchDB build script
mklink /d %curl_path% %curl_src%
popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof

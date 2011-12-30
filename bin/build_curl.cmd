::setlocal
path=%path%;%relax%\cmake\bin;c:\mozilla-build\7zip;%relax%\openssl\bin;

for %%i in ("%RELAX%\bits\curl-*.zip") do set curl_ver=%%~ni
setx CURL_VER %curl_ver%
set CURL_SRC=%RELAX%\%curl_ver%
setx CURL_SRC %curl_src%
set CURL_PATH=%relax%\curl
setx CURL_PATH %curl_path%

:: settings for CMake
set install=%curl_path%

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
nmake VC=vc10 vc-ssl
popd
:: make this specific curl version available to CouchDB build script
mklink /d %curl_path% %curl_src%
popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof

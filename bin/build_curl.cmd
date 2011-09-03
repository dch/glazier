::setlocal
path=%path%;%relax%\cmake\bin;%relax%\7zip;%relax%\openssl\bin;

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
pushd %relax%\curl-7*

:: settings for Compiler
set USE_SSLEAY=1
set USE_OPENSSL=1
set INCLUDE=%INCLUDE%;%SSL_PATH%\include;%SSL_PATH%\include\openssl;
set LIBPATH=%LIBPATH%;%SSL_PATH%\lib;
set LIB=%LIB%;%SSL_PATH%\lib;
set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1

cmake -G "NMake Makefiles" -D CMAKE_BUILD_TYPE=Release -D BUILD_CURL_TESTS=No -D CURL_STATICLIB=Yes -D CURL_ZLIB=No  -D CMAKE_INSTALL_PREFIX="%curl_path%" -H"%curl_src%" -B"%temp%\%curl_ver%"
cmake --build "%temp%\%curl_ver%" --target install
popd
dir /b %install%\bin %install%\lib

popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof
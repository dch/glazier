::setlocal
path=%path%;%relax%\7zip;

for %%i in ("%RELAX%\bits\curl-*.zip") do set curl_ver=%%~ni
set CURL_PATH=%RELAX%\%curl_ver%

if not defined SSL_PATH echo OpenSSL not found && goto eof
::set USE_SSLEAY=1
::set USE_OPENSSL=1

:: set path for curl & couch compilation later on
set INCLUDE=%INCLUDE%;%SSL_PATH%\include\openssl;%SSL_PATH%\include;%CURL_PATH%\include\curl;
set LIBPATH=%LIBPATH%;%SSL_PATH%\lib;%CURL_PATH%\lib;
set LIB=%LIB%;%SSL_PATH%\lib;%CURL_PATH%\lib;

:: set LINK & CL to resolve manifest binding issues & virtualisation hack in ld.sh#171
set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
:: extract bundle and name
:: stash SSL version
if defined curl_ver rd /s/q %relax%\%curl_ver%
setx curl_ver %curl_ver%
7z x "%RELAX%\bits\curl-*.zip" -o%RELAX% -y
popd

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\%curl_ver%\winbuild
nmake /f makefile.vc mode=static use_sspi=no with_ssl=static
:: TODO do we *need* zlib?
:: TODO these files should be put into $RELAX/curl/
copy ..\builds\libcurl-release-static-ssl-dll-ipv6\bin\curl.exe %glazier%\bits;

popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof
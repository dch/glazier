::setlocal
call "%vs90comntools%\..\..\vc\vcvarsall.bat" x86
path=%path%;%relax%\7zip;%glazier%\bin;%glazier%\bits;

pushd %glazier%\bits
for %%i in (curl-*.zip) do set curl_ver=%%~ni
set CURL_PATH=%RELAX%\%curl_ver%

set OPENSSL_PATH=%RELAX%\openssl

set USE_SSLEAY=1
set USE_OPENSSL=1

:: set path for curl & couch compilation later on
set INCLUDE=%INCLUDE%;%OPENSSL_PATH%\include\openssl;%OPENSSL_PATH%\include;%CURL_PATH%\include\curl;%ICU_PATH%\include;
set LIBPATH=%LIBPATH%;%OPENSSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib;
set LIB=%LIB%;%OPENSSL_PATH%\lib;%CURL_PATH%\lib;%ICU_PATH%\lib

:: set LINK & CL to resolve manifest binding issues & virtualisation hack in ld.sh#171
set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
:: extract bundle and name
:: stash SSL version
if defined curl_ver rd /s/q %relax%\%curl_ver%
.\setenv -u curl_ver %curl_ver%
7z x curl-*.zip -o%RELAX% -y
popd

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\%curl_ver%\winbuild
nmake /f makefile.vc mode=static use_sspi=no with_ssl=static
::with_zlib=static 
copy ..\builds\libcurl-release-static-ssl-dll-ipv6\bin\curl.exe %glazier%\bits;

popd
::endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

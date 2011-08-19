::setlocal
call "%vs90comntools%\..\..\vc\vcvarsall.bat" x86
path=%path%;%relax%\7zip;%glazier%\bin;%glazier%\bits;

pushd %glazier%\bits
set ICU_PATH=%RELAX%\icu

:: set path for ICU compilation later on
set INCLUDE=%INCLUDE%;%ICU_PATH%\include;
set LIBPATH=%LIBPATH%;%ICU_PATH%\lib;
set LIB=%LIB%;%ICU_PATH%\lib

:: set LINK & CL to resolve manifest binding issues & virtualisation hack in ld.sh#171
set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
rd /s/q %icu_path%
.\setenv -u icu_path %icu_path%
7z x icu4c-*src.zip -o%RELAX% -y
popd

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %icu_path%\source\allinone
vcbuild /useenv /platform:Win32 /M8 allinone.sln "Release|Win32" 
::copy ..\builds\libcurl-release-static-ssl-dll-ipv6\bin\curl.exe %glazier%\bits;

::endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
popd

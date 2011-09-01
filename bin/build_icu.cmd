path=%path%;%relax%\7zip;

set ICU_PATH=%RELAX%\icu

:: set path for ICU compilation later on
set INCLUDE=%INCLUDE%;%ICU_PATH%\include;
set LIBPATH=%LIBPATH%;%ICU_PATH%\lib;
set LIB=%LIB%;%ICU_PATH%\lib

:: set LINK & CL to resolve manifest binding issues & virtualisation hack in ld.sh#171
set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
if exist "%icu_path%" rd /s/q %icu_path%
setx icu_path %icu_path%
7z x "%RELAX%\bits\icu4c-*src.zip" -o%RELAX% -y

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd "%icu_path%\source\allinone"
vcbuild /useenv /platform:Win32 /M8 allinone.sln "Release|Win32" 
:: can we try using --with-data-packaging=archive to reduce ICU size?
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
popd

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: trying this on cygwin instead of windows, to compile with
:: current vclibs.
:: use .tgz package & untar
:: start SDK setenv.cmd /release /x86
:: set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
:: call \cygwin\bin\bash.exe
:: export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
:: cd $RELAX/icu442/source
:: ./runConfigureICU Cygwin/MSVC --prefix=$RELAX/icu442/build
:: make
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

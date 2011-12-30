path=%path%;%relax%\7zip;
setlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: icu doesn't have a version name in the archive path
set ICU_PATH=%RELAX%\icu
setx ICU_PATH %icu_path%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ensure we have a fresh source tree to build from
if exist "%icu_path%" rd /s/q %icu_path%
7z x "%relax%\bits\icu4c-*src.zip" -o%relax% -y > NUL:
pushd %icu_path%
vcbuild /useenv /platform:Win32 /M8 %icu_source%\allinone\allinone.sln "Release|Win32"
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: trying this on cygwin instead of windows, to compile with current vclibs
:: doesn't actually build the data DLL correctly - YMMV
:: use .tgz package & untar
:: start SDK setenv.cmd /release /x86
:: call \cygwin\cygwin.bat
:: # check path export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
:: cd $RELAX/icu442/source
:: ./runConfigureICU Cygwin/MSVC --prefix=$RELAX/icu442/build
:: make && make install
:: cp ../lib/*.dll ../bin/
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof
endlocal

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
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: in ICU, the data DLL icudt44.dll built by VC++ is actually a stub, and it
:: gets modified and expanded later on. The stub doesn't compile correctly under
:: BIND_TO_CURRENT_VCLIBS_VERSION so we first compile it without this flag to
:: avoid this error:
:: 1>   Creating library ..\..\lib\icudt.lib and object ..\..\lib\icudt.exp
:: 1>stubdata.obj : error LNK2001: unresolved external symbol __forceCRTManifestCUR
:: 1>..\..\bin\icudt44.dll : fatal error LNK1120: 1 unresolved externals
:: try adding stubdata.c int __forceCRTManifestCUR=0; or similar
:: TODO can we try using --with-data-packaging=archive to reduce ICU size?
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set icu_source=%icu_path%\source
set CL=
vcbuild /useenv /platform:Win32 /M8 %icu_source%\stubdata\stubdata.vcproj "Release|Win32"
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: set CL to resolve manifest binding issues & virtualisation hack in ld.sh#171
set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
vcbuild /useenv /platform:Win32 /M8 %icu_source%\allinone\allinone.sln "Release|Win32"
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: trying this on cygwin instead of windows, to compile with current vclibs
:: doesn't actually build the data DLL correctly - YMMV
:: use .tgz package & untar
:: start SDK setenv.cmd /release /x86
:: set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
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

setlocal
path=%path%;%relax%\7zip;%relax%\nasm;%relax%\strawberry\perl\bin;

set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
:: extract bundle and name
:: stash SSL version
del /f/q "%TEMP%\zlib*.tar"
7z x "%relax%\bits\zlib-*.tar.gz" -y -o"%TEMP%"
for %%i in ("%TEMP%\zlib-*tar") do set zlib_ver=%%~ni
if defined zlib_ver rd /s/q %relax%\%zlib_ver%
setx zlib_ver %zlib_ver%
7z x "%TEMP%\zlib-*.tar" -o%relax%\ -y
popd

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\%zlib_ver%\contrib\masmx86
call bld_ml32.bat
popd
pushd %relax%\%zlib_ver%
vcbuild /rebuild contrib\vstudio\vc9\zlibvc.sln "Release|Win32"
:: TOOD these need to be put into $RELAX/zlib/
copy contrib\vstudio\vc9\x86\ZlibStatRelease\zlibstat.lib .
popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

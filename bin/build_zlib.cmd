setlocal
path=%path%;c:\mozilla-build\7zip;%opt%\nasm;%opt%\strawberry\perl\bin;
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean up existing installs
7z x "%glazier%\bits\zlib-*.zip" -y -o%glazier%
for %%i in ("%") do set zlib_ver=%%~ni
if defined zlib_ver rd /s/q %relax%\%zlib_ver%
setx zlib_ver %zlib_ver%
popd

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pushd %relax%\%zlib_ver%\contrib\masmx86
call bld_ml32.bat
popd
pushd %relax%\%zlib_ver%
nmake -f win32\Makefile.msc
nmake -f win32\Makefile.msc test
:: copy contrib\vstudio\vc9\x86\ZlibStatRelease\zlibstat.lib .
popd
endlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

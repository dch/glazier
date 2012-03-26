path=%path%;c:\mozilla-build\7zip;
setlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: icu doesn't have a version name in the archive path
set ICU_PATH=%RELAX%\icu
setx ICU_PATH %icu_path%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ensure we have a fresh source tree to build from
if exist "%icu_path%" rd /s/q %icu_path%
7z x "%glazier%\bits\icu4c-*src.zip" -o%relax% -y
pushd %icu_path%
msbuild /m /p:Configuration=Release /p:Platform=Win32 /v:m /clp:summary %icu_path%\source\allinone\allinone.sln 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof
endlocal

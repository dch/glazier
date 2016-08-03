path=%path%;c:\mozilla-build\7zip;
setlocal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: icu doesn't have a version name in the archive path
set ICU_PATH=%RELAX%\icu
setx ICU_PATH %icu_path%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ensure we have a fresh source tree to build from
if exist "%icu_path%" rd /s/q %icu_path%
7z x "%relax%\bits\icu4c-*src.zip" -o%relax% -y
pushd %icu_path%
:: ICU is set up for MSVS 2010, this upgrades it to 2013 support
devenv.com %icu_path%\source\allinone\allinone.sln /Upgrade
devenv.com %icu_path%\source\allinone\allinone.sln /Build "Release|x64"
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:eof
endlocal

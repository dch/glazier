@echo off
path=%glazier%\bin;%RELAX%\7zip;%path%
pushd %glazier%\bits\
curl -#L http://github.com/dch/glazier/zipball/master -o glazier_master.zip
7z x glazier_master.zip
cd dch-*
xcopy . %GLAZIER% /e /y /f
popd

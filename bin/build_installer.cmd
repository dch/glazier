@ECHO OFF

:: Licensed under the Apache License, Version 2.0 (the "License"); you may not
:: use this file except in compliance with the License. You may obtain a copy of
:: the License at
::
::   http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
:: WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
:: License for the specific language governing permissions and limitations under
:: the License.

SETLOCAL ENABLEEXTENSIONS
SETLOCAL DISABLEDELAYEDEXPANSION

IF EXIST %~dp0..\..\couchdb\rel\couchdb (
  SET COUCHDB=%~dp0..\..\couchdb\rel\couchdb
) ELSE (
  ECHO Error, couchdb release directory not found. Have you run make release?
  GOTO END
)

SET OLDDIR=%cd%

SET GLAZIER=%~dp0..
SET /P START_ERL= < %COUCHDB%\releases\start_erl.data
FOR /F "tokens=2" %%G IN ("%START_ERL%") DO SET APP_VSN=%%G

:: pre-execution cleanup
cd %GLAZIER%\installer
rmdir /s /q release >NUL 2>&1
del /f *.wixobj >NUL 2>&1
del /f *.wixpdb >NUL 2>&1
del /f couchdb.wxs couchdbfiles.wxs >NUL 2>&1

:: add necessary DLLs to release directory
xcopy %ICU_PATH%\bin64\icu*.dll %COUCHDB%\bin /Y >NUL 2>&1
xcopy %RELAX%\js-1.8.5\js\src\dist\bin\*.dll %COUCHDB%\bin /Y >NUL 2>&1
copy %RELAX%\curl\lib\libcurl.dll %COUCHDB%\bin /Y >NUL 2>&1


:: update version number
:: commented out because WiX insists on a #.#.#.# number format and there's
:: no guarantee that's what we'll see
copy couchdb.wxs.in couchdb.wxs >NUL 2>&1
:: cscript //NoLogo %GLAZIER%\bin\sed.vbs s/####VERSION####/%APP_VSN% < couchdb.wxs.in >couchdb.wxs

:: Package CouchDB as a fragment
:: WiX skips empty directories, so we create a dummy logfile
echo New Log >%COUCHDB%\var\log\couchdb.log
:: We don't want to re-run heat unless files have changed. And even then,
:: we'd want to manually merge. heat will regenerate all GUIDS and that will
:: cause problems in the field if we ever start upgrading rather than
:: uninstall/reinstall. It's the -gg flag that results in this behaviour.
heat dir %COUCHDB% -dr APPLICATIONFOLDER -cg CouchDBFilesGroup -gg -g1 -sfrag -srd -sw5150 -var "var.CouchDir" -out couchdbfiles.wxs

:: Build MSI for installation
candle -arch x64 -ext WiXUtilExtension couchdb.wxs
candle -arch x64 -dCouchDir=%COUCHDB% couchdbfiles.wxs
candle -arch x64 -ext WiXUtilExtension couchdb_wixui.wxs
candle -arch x64 -ext WiXUtilExtension dirwarning.wxs
light -sw1076 -ext WixUIExtension -ext WiXUtilExtension -cultures:en-us couchdb.wixobj couchdbfiles.wixobj couchdb_wixui.wixobj dirwarning.wixobj -out couchdb-%APP_VSN%.msi
copy couchdb-%APP_VSN%.msi %OLDDIR%

cd %OLDDIR%
:END

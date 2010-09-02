@echo off
rem Licensed under the Apache License, Version 2.0 (the "License"); you may not
rem use this file except in compliance with the License. You may obtain a copy
rem of the License at
rem
rem   http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
rem WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
rem License for the specific language governing permissions and limitations
rem under the License.

setlocal
rem move to script homedir
pushd %~dp0

rem check to see if install.exe was run, if not do so.
rem erl.ini is removed during packaging and is recreated by install.exe
if not exist bin\erl.ini echo running Erlang Installer && Install.exe -s

rem Allow a different erlang executable (eg, erl) to be used.
rem When using erl instead of werl, server restarts during test runs can fail
rem intermittently. But using erl should be fine for production use.
if "%ERL%x" == "x" set ERL=werl.exe

cd bin
echo CouchDB 1.0.1 - prepare to relax...
start /max %ERL% -sasl errlog_type error -s couch
popd
endlocal

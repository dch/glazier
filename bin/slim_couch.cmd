@echo off
setlocal
:: are we *really* in %COUCH% ?
if not exist bin\couchdb.bat echo FAIL: this script must be run in %%COUCH%% && goto :eof

:: prune any existing COUCH stuff
rd /s/q var
mkdir var\log\couchdb var\lib\couchdb var\run\couchdb
del unins*

:: prune libs
pushd lib
mkdir ..\stash ..\trash
for /d %%i in (couch-* snappy-* ejson-* common-test-* compiler-* crypto-* debugger-* erlang-oauth* erts-* etap* eunit* hipe* ibrowse-* inets-* kernel-* mochiweb-* os_mon-* parse-tools-* pman-* public_key-* reltool-* runtime_tools-* sasl-* ssl-* stdlib-* xmerl-*) do @echo stashing [%%i] && move "%%i" ..\stash\ > NUL: 2>&1
for /d %%i in (*) do @echo trashing [%%i] && move "%%i" ..\trash\ > NUL: 2>&1
for /d %%i in (..\stash\*) do @move "%%i" > NUL: 2>&1
popd && echo rd /s/q stash trash

:: prune erts
pushd erts* && rd /s/q include lib src & popd

:: lean beams + misc bits
pushd lib && for /r %%i in (examples src include obj) do @if exist "%%i" echo cleaned [%%i] && rd /s/q "%%i"
popd

:: misc bits
del /s/q/f erl.ini
rd /s/q releases
rd /s/q share\doc share\man
pushd bin && del typer.exe run_test.exe ct_run.exe dialyzer.exe & popd
pushd erts-*\bin && del ct_run.exe dialyzer.exe typer.exe & popd

:: Before
:: C:\couch\1.1.0_icu442>diruse . -, -m -*
::
::    Size (mb)  Files  Directory
::        19.30     19  SUB-TOTAL: ..\bin
::         4.39     70  SUB-TOTAL: ..\erts-5.8.2
::         0.01      2  SUB-TOTAL: ..\etc
::        104.1   4686  SUB-TOTAL: ..\lib
::         0.04      9  SUB-TOTAL: ..\releases
::         1.27    177  SUB-TOTAL: ..\share
::         0.00      0  SUB-TOTAL: ..\var
::       129.11   4963  TOTAL
:: After
:: C:\couch>diruse -,  -m -* 1.1.0_slim
::
::    Size (mb)  Files  Directory
::        19.23     15  SUB-TOTAL: 1.1.0_SLIM\bin
::         3.40     11  SUB-TOTAL: 1.1.0_SLIM\erts-5.8.2
::         0.01      2  SUB-TOTAL: 1.1.0_SLIM\etc
::        10.07    530  SUB-TOTAL: 1.1.0_SLIM\lib
::         1.24    163  SUB-TOTAL: 1.1.0_SLIM\share
::         0.00      0  SUB-TOTAL: 1.1.0_SLIM\var
::        33.94    721  TOTAL
echo DONE
echo remember to use 7zip to compress for 25% better reduction vs zip/gz
echo e.g. 7zip a -mx9 slimcouch.7z slimcouch
echo 7zip a -mx9 archive.7z folder gets a 15MiB .7z file vs zip 21MiB file
echo NOTES - further pruning options to test
echo remove futon rd /s/q share\couchdb\www
echo werl.exe, escript.exe, erlc.exe, heart.exe if you're sure
echo use erlc "+compressed" to squash beam files at build time
echo use this to strip beams:
echo erl -noinput -eval 'erlang:display(beam_lib:strip_release("."))' -s init stop
echo what modules are needed? read http://erlang.org/pipermail/erlang-questions/2011-June/059489.html
echo vcredist_x86.exe if you are deploying via MSI pre-req or GPOs
echo share/couchdb/www if you don't need futon locally
echo script doesn't handle extensions like geocouch yet
echo erts-*\bin is duplicated, maybe try a junction point and avoid install.exe
echo bin\* erts-5.8.2\bin\ /y ^& rd bin ^& junction bin erts-5.8.2\bin

:eof
endlocal

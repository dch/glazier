@echo off
:restart
for /l %%i in (1,1,100000000000) do @echo TEST_RUN %%i && call :curl %%i
goto :eof

:curl
curl -H "Content-Type: application/json" -X POST http://localhost:5984/_restart
:: check to see if couch died horribly
if exist erl_crash.dump echo Woops!!!! && pause
goto :eof

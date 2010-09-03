@echo off
:: assumes there's a curl_%1.txt file in current folder
if /i "%1"=="" goto eof
if not exist "curl_%1.txt" echo "curl_%1.txt" not found && goto eof

echo START	fetching %1
:: skips lines starting with #, then into 4 tokens as follows
:: %i short name
:: %j filename
:: %k URL
:: %l md5 hash check
:: TODO implement md5 check
:: if the filename doesn't exist, fetch it from the URL
for /f "eol=# tokens=1,2,3,4" %%i in (curl_%1.txt) do @echo [%%i] && if not exist %%j echo fetching from %%k && curl.exe -L %%k --output %%j
echo DONE	fetching %1
:eof

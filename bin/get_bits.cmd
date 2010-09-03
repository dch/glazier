@echo off
:: assumes curl.exe and any required DLLs are in path already
:: assumes there's a curl_%1.txt file in current folder or process all curl_*.txt

echo START	fetching %1
if  exist "curl_%1.txt" goto single_file

:: check for multiple files
for %%f in (curl_*.txt) do @echo processing [%%f] & for /f "eol=# tokens=1,2,3,4" %%i in (%%f) do @echo [%%i] & if not exist %%j echo fetching from %%k & curl.exe -L %%k --output %%j

:: now exit
goto eof

:single_file
:: skips lines starting with #, then into 4 tokens as follows
:: %i short name
:: %j filename
:: %k URL
:: %l md5 hash check
:: TODO implement md5 check
:: if the filename doesn't exist, fetch it from the URL
for /f "eol=# tokens=1,2,3,4" %%i in (curl_%1.txt) do @echo [%%i] & if not exist %%j echo fetching from %%k & curl.exe -L %%k --output %%j

:eof
echo DONE	fetching %1

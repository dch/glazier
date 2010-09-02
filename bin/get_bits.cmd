@echo off
:: assumes there's a curl_%1.txt file in current folder
if /i "%1"=="" goto eof
if not exist "curl_%1.txt" echo "curl_%1.txt" not found && goto eof

:: skips lines starting with #, then into 4 tokens as follows
:: short name
:: filename
:: URL
:: md5 hash (not yet implemented)
for /f "eol=# tokens=1,2,3" %%i in (curl_%1.txt) do @echo checking [%%i] && if not exist %%j curl.exe -OL %%k

:eof

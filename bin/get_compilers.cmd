@echo off
for /f "tokens=1,2,3" %%i in (curl_file_list.txt) do @echo %%i from %%j
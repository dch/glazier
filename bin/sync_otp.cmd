if not defined WERL_SRC  set WERL_SRC=c:\relax\werl
if not defined WERL_DIR  set WERL_DIR=c:\jenkins\workspace\werl
robocopy %WERL_SRC% %WERL_DIR% -mir -log:NUL: -r:0 -w:0

@echo off
:: tell other glazier scripts to run automated
:: builds instead of usual interactive mode
set BUILD_WITH_JENKINS=1

:: decide where to find couchdb build scripts and tools
if not defined RELAX    set RELAX=c:\relax

:: this is used only in jenkins.cmd to set up cygwin environment
:: right now we can't support these in the script but we will in future
if not defined OTP_REL  set OTP_REL=R15B03-1
if not defined OTP_ARCH set OTP_ARCH=x86


:: a pristine copy of erlang artefacts is stored in WERL_SRC
:: cleans out any old build artefacts
if not defined WERL_SRC  set WERL_SRC=c:\werl
if not defined WERL_DIR  set WERL_DIR=c:\jenkins\workspace\werl
robocopy %WERL_SRC% %WERL_DIR% -mir -log:NUL: -r:0 -w:0

:: expect crash and burn for the moment

:: this allows you to run the jenkins build interactively TODO HACKHACKHACK
if not defined WORKSPACE set WORKSPACE=c:\jenkins\workspace\Apache-CouchDB-Windows-master\label\Windows-8-x64\

:: This script must run with elevated (admin/uac) permissions for the
:: cp -p stage in couchdb autotools script to complete successfully.

call c:\relax\bin\shell.cmd
:: and relax

:: output when all is well, ends up in /etc/windows/ for better or for worse!

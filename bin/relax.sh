#!/bin/bash

# The PATH variable should be Cygwinish
# which is normally done during the eval `./otp_build env_win32` build step
# but we rebuild the path from scratch to ensure tools are found in the right order
# note significant differences between win32 OS and win64 OS paths
# TODO we can find a better way to do this in future
## current ./otp_build seems to get cygwin tools in the wrong place so MS linker is overridden 
## this is what we are looking for in order
## /cygdrive/c/src/otp_src_R13B04/erts/etc/win32/cygwin_tools/vc:/cygdrive/c/src/otp_src_R13B04/erts/etc/win32/cygwin_tools:/cygdrive/c/PROGRA~2/MICROS~1.0/Common7/IDE:/cygdrive/c/PROGRA~2/MICROS~1.0/VC/bin:/cygdrive/c/PROGRA~2/MICROS~1.0/Common7/Tools/:/cygdrive/c/Windows/MICROS~1.NET/FRAMEW~1/:/cygdrive/c/Windows/MICROS~1.NET/FRAMEW~1/:/cygdrive/c/Windows/MICROS~1.NET/FRAMEW~1/V20~1.507:/cygdrive/c/PROGRA~2/MICROS~1.0/VC/VCPACK~1:/cygdrive/c/PROGRA~1/MICROS~1/Windows/v6.0A/bin:/cygdrive/c/PROGRA~1/MICROS~1/Windows/v7.0/bin:/usr/local/bin:/usr/bin:/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/Wbem:/cygdrive/c/Windows/System32/WINDOW~1/v1.0/:/cygdrive/c/PROGRA~2/NSIS:/cygdrive/c/OpenSSL/bin

# build for the right version of erlang
echo Using Erlang $ERL_VER OTP $OTP_VER in $ERL_TOP
echo

echo doing sanity checks
# here we want to see that junction points are set up and 
# rebuild path from scratch as ./otp_build env_win32 gets it wrong
# first up are erlang build helper scripts
PATH=$ERL_TOP/release/win32/erts-$ERL_VER/bin:$ERL_TOP/erts/etc/win32/cygwin_tools/vc:$ERL_TOP/erts/etc/win32/cygwin_tools

# then MSVC9 binaries using the new junction points
###PATH=$PATH:/cygdrive/c/PROGRA~2/MICROS~1.0/Common7/IDE:/cygdrive/c/PROGRA~2/MICROS~1.0/VC/BIN:/cygdrive/c/PROGRA~2/MICROS~1.0/Common7/Tools:/cygdrive/c/PROGRA~2/MICROS~1.0/VC/VCPACK~1
PATH=$PATH:/relax/vs90/Common7/IDE:/relax/vs90/VC/BIN:/relax/vs90/Common7/Tools:/relax/vs90/vc/vcPackages

#### then .Net framework which we need to have clean manifests and SxS for Win7 x64
PATH=$PATH:/cygdrive/c/WINDOWS/Microsoft.NET/Framework:/cygdrive/c/Microsoft.NET/Framework/v2.0.50727

# then SDKs
###PATH=$PATH:/cygdrive/c/PROGRA~1/MICROS~1/Windows/v7.0/bin
###PATH=$PATH:/cygdrive/c/PROGRA~1/MICROS~1/Windows/v6.0A/bin
PATH=$PATH:/relax/SDKs/v7.0/bin
PATH=$PATH:/relax/SDKs/v6.0A/bin

# then erlang and couchdb build helper scripts
PATH=$PATH:/relax/openssl:/relax/nsis:/relax/inno5
# then cygwin tools

# then cygwin tools
PATH=$PATH:/usr/local/bin:/usr/bin:/bin	
# then glazier tools
PATH=$PATH:/relax/bin

# then windows
PATH=$PATH:/cygdrive/c/WINDOWS/system32:/cygdrive/c/WINDOWS:/cygdrive/c/WINDOWS/System32/Wbem:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0

# remaining settings from otp_build env_win32 script
OVERRIDE_TARGET="win32"
CC="cc.sh"
CXX="cc.sh"
AR="ar.sh"
RANLIB="true"
OVERRIDE_CONFIG_CACHE="$ERL_TOP/erts/autoconf/win32.config.cache"
OVERRIDE_CONFIG_CACHE_STATIC="$ERL_TOP/erts/autoconf/win32.config.cache.static"

CC_SH_DEBUG_LOG=$TMP/cc_r$OTP_VER.log
LD_SH_DEBUG_LOG=$TMP/ld_r$OTP_VER.log
RC_SH_DEBUG_LOG=$TMP/rc_r$OTP_VER.log
MD_SH_DEBUG_LOG=$TMP/md_r$OTP_VER.log
MC_SH_DEBUG_LOG=$TMP/mc_r$OTP_VER.log

export OVERRIDE_TARGET CC CXX AR RANLIB OVERRIDE_CONFIG_CACHE_STATIC OVERRIDE_CONFIG_CACHE INCLUDE LIB LIBPATH LINK CL PATH TMP CC_SH LD_SH RC_SH MD_SH MC_SH ERL_TOP ERL_VER OTP_VER SHELL RELAX GLAZIER

# first change to $RELAX as if erlang tar.gz are not extracted the latter will fail
cd $RELAX
cd $ERL_TOP
# this shouldn't change anything really
### eval `./otp_build env_win32`

echo current path:
echo $PATH | sed 's/:/\n/g'
echo
echo please check the toolkit paths point to Microsoft versions:
which mc; which lc; which cl; which link; which mt
echo

echo Ready to build Erlang and CouchDB using Erlang $ERL_VER OTP $OTP_VER in $ERL_TOP
echo Time to Relax.

bash -i

#!/bin/sh
./otp_build autoconf 2>&1 | tee $ERL_TOP/build_autoconf.txt
# ./otp_build configure --enable-dynamic-ssl-lib 2>&1 | tee $ERL_TOP/build_configure.txt
./otp_build configure 2>&1 | tee $ERL_TOP/build_configure.txt

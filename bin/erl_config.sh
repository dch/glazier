#!/bin/sh
pushd $ERL_TOP
./otp_build autoconf 2>&1 | tee $ERL_TOP/build_autoconf.txt
# from Erlang/OTP R14B03 onwards, Erlang by default is built with
# *static* OpenSSL. Uncomment following, and change build_openssl.cmd
# to revert this.
./otp_build configure --enable-dynamic-ssl-lib 2>&1 | tee $ERL_TOP/build_configure.txt
## ./otp_build configure --with-ssl=/relax/openssl 2>&1 | tee $ERL_TOP/build_configure.txt
popd

#!/bin/sh
COUCH_TOP=`pwd`
export COUCH_TOP

./configure \
--prefix=$ERL_TOP/release/win32 \
--with-erlang=$ERL_TOP/release/win32/usr/include \
--with-win32-icu-binaries=/src/icu-4.2.1 \
--with-win32-curl=/src/curl-7.21.1 \
--with-openssl-bin-dir=/src/openssl/bin \
--with-msvc-redist-dir=/src/bits \
--with-js-lib=/src/seamonkey-2.0.6/comm-1.9.1/mozilla/js/src/dist/lib \
--with-js-include=/src/seamonkey-2.0.6/comm-1.9.1/mozilla/js/src/dist/include/js \
| tee $COUCH_TOP/build_configure.txt

echo DONE. | tee -a $COUCH_TOP/build_configure.txt

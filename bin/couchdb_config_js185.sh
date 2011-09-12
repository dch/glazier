#!/bin/sh
COUCH_TOP=`pwd`
export COUCH_TOP

## --with-win32-curl=/relax/curl \

./configure \
--prefix=$ERL_TOP/release/win32 \
--with-erlang=$ERL_TOP/release/win32/usr/include \
--with-win32-icu-binaries=/relax/icu \
--with-openssl-bin-dir=/relax/openssl/bin \
--with-msvc-redist-dir=/relax \
--with-js-lib=/relax/js-1.8.5/js/src/dist/lib \
--with-js-include=/relax/js-1.8.5/js/src/dist/include \
2>&1 | tee $COUCH_TOP/build_configure.txt
### --enable-static \
### --with-win32-curl=/relax/curl \

echo DONE. | tee -a $COUCH_TOP/build_configure.txt

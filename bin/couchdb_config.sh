#!/bin/sh
COUCH_TOP=`pwd`
export COUCH_TOP

./configure \
--prefix=$ERL_TOP/release/win32 \
--with-erlang=$ERL_TOP/release/win32/usr/include \
--with-win32-icu-binaries=$RELAX/icu \
--without-win32-curl \
--with-openssl-bin-dir=$RELAX/openssl/bin \
--with-msvc-redist-dir=$RELAX \
--with-js-lib=$RELAX/js-1.8.5/js/src/dist/lib \
--with-js-include=$RELAX/js-1.8.5/js/src/dist/include \
2>&1 | tee $COUCH_TOP/build_configure.txt
### --enable-static \

echo DONE. | tee -a $COUCH_TOP/build_configure.txt

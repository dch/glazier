#!/bin/sh
COUCH_TOP=`pwd`
export COUCH_TOP

./configure \
--prefix=$ERL_TOP/release/win32 \
--with-erlang=$ERL_TOP/release/win32/usr/include \
--with-win32-icu-binaries=$COUCH_TOP/../icu \
--with-win32-curl=$COUCH_TOP/../curl \
--with-openssl-bin-dir=$COUCH_TOP/../openssl/bin \
--with-msvc-redist-dir=$ERL_TOP/.. \
--with-js-lib=$COUCH_TOP/../js-1.8.5/js/src/dist/lib \
--with-js-include=$COUCH_TOP/../js-1.8.5/js/src/dist/include \
--disable-init \
--disable-launchd \
2>&1 | tee $COUCH_TOP/build_configure.txt
### --enable-static \

echo DONE. | tee -a $COUCH_TOP/build_configure.txt

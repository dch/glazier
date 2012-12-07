#!/bin/sh
COUCH_TOP=`pwd`
export COUCH_TOP

echo ============= COUCHDB_CONFIG CONFIGURE ===================
./configure \
--prefix=$ERL_TOP/release/win32 \
--with-erlang=$ERL_TOP/release/win32/usr/include \
--with-win32-icu-binaries=$COUCH_TOP/../icu \
--with-openssl-bin-dir=$COUCH_TOP/../openssl/bin \
--with-msvc-redist-dir=$ERL_TOP/.. \
--with-js-lib=$COUCH_TOP/../js-1.8.5/js/src/dist/lib \
--with-js-include=$COUCH_TOP/../js-1.8.5/js/src/dist/include \
--disable-init \
--disable-launchd \
--disable-docs \
#--with-win32-curl=$COUCH_TOP/../curl \
2>&1 | tee $COUCH_TOP/build_configure.txt

echo ============= COUCHDB_CONFIG CONFIGURE ===================
echo DONE. | tee -a $COUCH_TOP/build_configure.txt

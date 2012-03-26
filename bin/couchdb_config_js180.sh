#!/bin/sh
COUCH_TOP=`pwd`
export COUCH_TOP

# use config.cache to save hours of time on cygwin
#--cache-file=/tmp/couchdb_config.cache \
### --enable-static \

./configure \
--prefix=$ERL_TOP/release/win32 \
--with-erlang=$ERL_TOP/release/win32/usr/include \
--with-win32-icu-binaries=$RELAX/icu \
--with-win32-curl=$RELAX/curl \
--with-openssl-bin-dir=$RELAX/openssl/bin \
--with-msvc-redist-dir=$RELAX \
--with-js-lib=$RELAX/tracemonkey-57a6ad20eae9/js/src/dist/lib \
--with-js-include=$RELAX/tracemonkey-57a6ad20eae9/js/src/dist/include \
2>&1 | tee $COUCH_TOP/build_configure.txt

echo DONE. | tee -a $COUCH_TOP/build_configure.txt

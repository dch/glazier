
## Make & Build ###############################################################

* The generic configure script looks like this:

        ./configure \
        --with-js-include=/cygdrive/c/path_to_spidermonkey/dist/include \
        --with-js-lib=/cygdrive/c/path_to_spidermonkey/dist/lib \
        --with-win32-icu-binaries=/cygdrive/c/path_to_icu_binaries_root \
        --with-erlang=$ERL_TOP/release/win32/usr/include \
        --with-win32-curl=/cygdrive/c/path/to/curl/root/directory \
        --with-openssl-bin-dir=/cygdrive/c/path/to/openssl/bin \
        --with-msvc-redist-dir=/cygdrive/c/dir/with/vcredist_platform_executable \
        --prefix=$ERL_TOP/release/win32

## using spidermonkey 1.8.x   ###################################################

* This is the recommended config if you have used the above steps:

        ./configure \
        --prefix=$ERL_TOP/release/win32 \
        --with-erlang=$ERL_TOP/release/win32/usr/include \
        --with-win32-icu-binaries=/relax/icu \
        --with-win32-curl=/relax/curl-7.21.5 \
        --with-openssl-bin-dir=/relax/openssl/bin \
        --with-msvc-redist-dir=/relax \
        --with-js-lib=/relax/57a6ad20eae9/js/src/dist/lib \
        --with-js-include=/relax/57a6ad20eae9/js/src/dist/include \
        2>&1 | tee $COUCH_TOP/build_configure.txt


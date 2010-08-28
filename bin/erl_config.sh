#!/bin/sh
./otp_build autoconf | tee $ERL_TOP/build_autoconf.txt
./otp_build configure| tee $ERL_TOP/build_configure.txt
./otp_build remove_prebuilt_files


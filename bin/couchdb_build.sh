#!/bin/sh
COUCH_TOP=`pwd`
export COUCH_TOP

make | tee $COUCH_TOP/build_make.txt
echo DONE. | tee -a $COUCH_TOP/build_make.txt

make install | tee $COUCH_TOP/build_install.txt
echo DONE. | tee -a $COUCH_TOP/build_install.txt

make check | tee $COUCH_TOP/build_check.txt
echo DONE. | tee -a $COUCH_TOP/build_check.txt

make dist  | tee $COUCH_TOP/build_dist.txt
echo DONE. | tee -a $COUCH_TOP/build_dist.txt

pushd $COUCH_TOP/etc/windows/
rename .exe _otp_$OTP_VER.exe setup-couchdb-*
mv setup-couchdb-* /src/built/
popd

echo DONE.

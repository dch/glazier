#!/bin/sh
COUCH_TOP=`pwd`
export COUCH_TOP

make 2>&1 | tee $COUCH_TOP/build_make.txt
echo DONE. | tee -a $COUCH_TOP/build_make.txt

make check 2>&1  | tee $COUCH_TOP/build_check.txt
echo DONE. | tee -a $COUCH_TOP/build_check.txt

make install 2>&1  | tee $COUCH_TOP/build_install.txt
echo DONE. | tee -a $COUCH_TOP/build_install.txt

make dist 2>&1   | tee $COUCH_TOP/build_dist.txt
echo DONE. | tee -a $COUCH_TOP/build_dist.txt

echo DONE.
echo to move build files to release area run the following:
echo PATCH=_otp_$OTP_REL.exe
echo DEST=/relax/z/Dropbox/CouchDB/Snapshots/`date +%Y%m%d`
echo pushd $COUCH_TOP/etc/windows/
echo rename .exe \$PATCH setup-couchdb-*
echo WINCOUCH=\`ls -1 setup-*.exe\`
echo rm \$WINCOUCH.*
echo shasum \$WINCOUCH \> \$WINCOUCH.sha
echo md5sum \$WINCOUCH \> \$WINCOUCH.md5
echo mkdir -p \$DEST
echo mv setup-couchdb-* \$DEST/
echo popd

echo DONE.

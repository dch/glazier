#!/bin/sh
set -e
COUCH_TOP=`pwd`
export COUCH_TOP

echo ============= COUCHDB_BUILD  MAKE ===================
make 2>&1 | tee $COUCH_TOP/build_make.txt
echo DONE. | tee -a $COUCH_TOP/build_make.txt

echo ============= COUCHDB_BUILD CHECK  ===================
make check 2>&1  | tee $COUCH_TOP/build_check.txt
echo DONE. | tee -a $COUCH_TOP/build_check.txt

echo ============= COUCHDB_BUILD  INSTALL ===================
make install 2>&1  | tee $COUCH_TOP/build_install.txt
echo DONE. | tee -a $COUCH_TOP/build_install.txt

echo ============= COUCHDB_BUILD DIST  ===================
make dist 2>&1   | tee $COUCH_TOP/build_dist.txt
echo DONE. | tee -a $COUCH_TOP/build_dist.txt

echo ============= COUCHDB_BUILD_PDB-LOGS ==================
tar cvzf $COUCH_TOP/build_pdbs-logs.tar.gz \
    `find $COUCH_TOP -name \*.pdb` \
    $COUCH_TOP/bui*.txt \
    `find $ERL_TOP -name \*.pdb` \
    $ERL_TOP/bui*.txt \
    $COUCH_TOP/config.*
echo DONE.
echo to move build files to release area run the following:
echo PATCH=_otp_$OTP_REL.exe
echo DEST=/cygdrive/c/jenkins/release/CouchDB/Snapshots/`date +%Y%m%d`
echo pushd $COUCH_TOP/etc/windows/
echo rename .exe \$PATCH setup-couchdb-*
echo WINCOUCH=\`ls -1 setup-*.exe\`
echo rm \$WINCOUCH.*
echo shasum \$WINCOUCH \> \$WINCOUCH.sha
echo md5sum \$WINCOUCH \> \$WINCOUCH.md5
echo mkdir -p \$DEST/
echo mv setup-couchdb-* \$DEST/
echo mv $COUCH_TOP/build_pdbs-logs.tar.gz \$DEST/\$WINCOUCH.build_pdbs-logs.tar.gz
echo popd

echo ============= COUCHDB_BUILD ===================
echo DONE.

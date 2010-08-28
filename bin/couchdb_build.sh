#!/bin/sh
COUCH_TOP=`pwd`
export COUCH_TOP

make install | tee $COUCH_TOP/build_install.txt
echo DONE. | tee -a $COUCH_TOP/build_install.txt
make dist  | tee $COUCH_TOP/build_dist.txt
echo DONE.   | tee -a $COUCH_TOP/build_dist.txt



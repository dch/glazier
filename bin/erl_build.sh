#!/bin/sh
pushd $ERL_TOP
./otp_build boot -a  2>&1 | tee $ERL_TOP/build_boot.txt
echo DONE. | tee -a $ERL_TOP/build_boot.txt

./otp_build release -a  2>&1 | tee $ERL_TOP/build_release.txt
echo DONE. | tee -a $ERL_TOP/build_release.txt

./otp_build installer_win32  2>&1 | tee $ERL_TOP/build_installer_win32.txt
mkdir $RELAX/release
mv --force $ERL_TOP/release/win32/otp_win32_R*.exe $RELAX/release/  2>&1 | tee -a $ERL_TOP/build_installer_win32.txt

rm $ERL_TOP/release/win32/vcredist_x86.exe

cmd /c release\\win32\\Install.exe -s 2>&1 | tee -a $ERL_TOP/build_release.txt
echo DONE. | tee -a $ERL_TOP/build_release.txt

echo ============= ERLANG_BUILD_PDB-LOGS ==================
tar cvzf $ERL_TOP/build_pdbs-logs.tar.gz \
    $ERL_TOP/bui*.txt $ERL_TOP/config.* \
    `find . -name \*.pdb`
echo DONE. | tee -a $ERL_TOP/build_release.txt
popd

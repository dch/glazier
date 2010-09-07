#!/bin/sh
./otp_build boot -a  2>&1 | tee $ERL_TOP/build_boot.txt
echo DONE. | tee -a $ERL_TOP/build_boot.txt

./otp_build release -a  2>&1 | tee $ERL_TOP/build_release.txt
echo DONE. | tee -a $ERL_TOP/build_release.txt
echo -e \\n|./release/win32/Install.exe  2>&1 | tee -a $ERL_TOP/build_release.txt
echo DONE. | tee -a $ERL_TOP/build_release.txt 

./otp_build installer_win32  2>&1 | tee $ERL_TOP/build_installer_win32.txt
mv --force $ERL_TOP/release/win32/otp_win32_R*.exe /relax/release/  2>&1 | tee -a $ERL_TOP/build_installer_win32.txt

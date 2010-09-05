#!/bin/sh
./otp_build boot -a  | tee $ERL_TOP/build_boot.txt
./otp_build release -a | tee $ERL_TOP/build_release.txt
./otp_build installer_win32 | tee $ERL_TOP/build_installer_win32.txt
mv --force $ERL_TOP/release/win32/otp_win32_R*.exe /relax/release/ | tee -a $ERL_TOP/build_installer_win32.txt

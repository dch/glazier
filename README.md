# Download Glazier scripts, tools, and source
################################################################################
* download [glazier latest zip](https://nodeload.github.com/dch/glazier/zipball/master)
* unpack it into `c:\relax` - you should have `c:\relax\bin` for example
* download source & tools using aria, and then check MD5 hashes:

        pushd c:\relax
        path=c:\relax\bin;%path%
        aria2c.exe --force-sequential=false --max-connection-per-server=4  --check-certificate=false --auto-file-renaming=false --input-file=downloads.md --max-concurrent-downloads=5 --dir=bits --save-session=bits/a2session.txt
         cd bits && md5sum.exe --check md5sums.txt

# Install Compilers    
################################################################################
Due to size, these are not downloaded in the bundle apart from
mozilla & cygwin setup.

* Install Windows SDK 7.0 either 32 or 64bit for your platform
    [win7sdk_32bit] or [win7sdk_64bit]
* Run Windows Update for latest patches
* Reboot
* Download Mozilla toolkit from [mozbuild] and install per defaults
* Install [cygwin] components, at least:
    * devel: ALL
    * editors: vim or emacs 
    * utils: file

[cygwin]: http://www.cygwin.com/setup.exe
[msvc++]: http://download.microsoft.com/download/E/8/E/E8EEB394-7F42-4963-A2D8-29559B738298/VS2008ExpressWithSP1ENUX1504728.iso
[win7sdk_32bit]:	http://download.microsoft.com/download/2/E/9/2E911956-F90F-4BFB-8231-E292A7B6F287/GRMSDK_EN_DVD.iso
[win7sdk_64bit]:	http://download.microsoft.com/download/2/E/9/2E911956-F90F-4BFB-8231-E292A7B6F287/GRMSDKX_EN_DVD.iso
[mozbuild]: http://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/MozillaBuildSetup-Latest.exe

# Initial Setup of Environment
################################################################################
Now that the compilers are installed, we need to set a few things up first:

* start an SDK shell via `setenv.cmd /Release /x86`
* run `c:\relax\bin\setup.cmd` once to set up links and environment variables

You should end up with something resembling this structure:

        Directory of C:\relax
        06/09/2011  10:41 p.m.    <DIR>          .
        06/09/2011  10:41 p.m.    <DIR>          ..
        06/09/2011  10:41 p.m.    <SYMLINKD>     bin [z:\r\glazier\bin]
        06/09/2011  10:41 p.m.    <SYMLINKD>     bits [z:\r\glazier\bits]
        03/09/2011  11:00 a.m.    <DIR>          release
        06/09/2011  10:40 p.m.    <SYMLINKD>     SDK [C:\Program Files\Microsoft SDKs\Windows\v7.0]
        06/09/2011  12:19 a.m.    <SYMLINKD>     tmp [C:\Users\couch\AppData\Local\Temp]
        06/09/2011  10:40 p.m.    <SYMLINKD>     VC [c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\..]


# Install downloaded tools
################################################################################
The express solution is just to use 7zip to unpack [glazier tools](https://github.com/downloads/dch/glazier/toolbox.7z)
 inside `%relax%`. Or do it manually for the same result:

* Download [7zip] to `%relax%/7zip`
* Innosoft's [isetup] to `%relax%/inno5`
* Nullsoft [NSIS] Installer to `%relax%/nsis`
* Add 7zip, Inno5, and nsis to the user environment PATH
* using 7zip, extract and rename [nasm] to `%relax%/nasm`
* using 7zip, extract and rename [cmake] to `%relax%/cmake`
* `mkdir strawberry && cd strawberry` then using 7zip, extract Strawberry [Perl]
* copy [vcredist] to `%relax%/` for later use by Erlang and CouchDB builds

[perl]: http://strawberryperl.com/download/5.12.2.0/strawberry-perl-5.12.2.0-portable.zip
[nasm]: http://www.nasm.us/pub/nasm/releasebuilds/2.09.07/win32/nasm-2.09.07-win32.zip
[cmake]: http://www.cmake.org/files/v2.8/cmake-2.8.5-win32-x86.zip
[vcredist]: http://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe
[nsis]: http://download.sourceforge.net/project/nsis/NSIS%202/2.46/nsis-2.46-setup.exe
[isetup]: http://www.jrsoftware.org/download.php/is-unicode.exe
[7zip]: http://downloads.sourceforge.net/sevenzip/7z465.exe

## wxWidgets
################################################################################
* [wxWidgets] source and the glazier [overlay] are already downloaded
* start an SDK shell via `setenv.cmd /Release /x86`
* run `c:\relax\bin\build_wx.cmd` to extract and build wxWidgets
* NB Erlang build requires wxWidgets in `/opt/local/pgm/wxWidgets-2.8.11` so
  we set that up too
* check for errors

[wxwidgets]: http://sourceforge.net/projects/wxwindows/files/2.8.11/wxMSW-2.8.11.zip
[overlay]:   https://raw.github.com/dch/glazier/master/bits/wxMSW-2.8.11_erlang_overlay.zip

## OpenSSL
################################################################################
Erlang requires finding OpenSSL in `c:\OpenSSL` so that's where we build to,
using mount point to keep things clean=ish under `%relax%`.

* [OpenSSL] source has already been downloaded
* start an SDK shell via `setenv.cmd /Release /x86`
* run `c:\relax\bin\build_openssl.cmd` to extract and build OpenSSL
* it requires nasm, 7zip, strawberry perl all in place
* check for errors
* ensure Erlang can locate SSL with `mklink /d c:\OpenSSL %relax%\OpenSSL`

[openssl]: http://www.openssl.org/source/openssl-1.0.0d.tar.gz

## Environment
################################################################################
Our goal is to get the path set up in this order:

1. erlang and couchdb build helper scripts
2. Microsoft VC compiler, linker, etc from Windows SDK 7.0
3. cygwin path for other build tools like make, autoconf, libtool
4. the remaining windows system path

Express start is to:
* start an SDK shell via `setenv.cmd /Release /x86`
* launch a cygwin erl-ified shell via `c:\relax\bin\shell.cmd`
* choose your preferred erlang version - R14B03 is recommended
* after validating the path, I usually run these two scripts which
can take several hours on slower machines:

        erl_config.sh
        erl_build.sh
        
* the output is logged into `$ERL_TOP/build_*.txt` if required
* at this point I usually duplicate the OTP source tree for later

        robocopy $ERL_TOP /relax/release/$OTP_REL -mir

cfdc2ab751bf18049c5ef7866602d8ed *apache-couchdb-1.0.3.tar.gz
907b763d3a14b6649bf0371ffa75a36b *apache-couchdb-1.1.0.tar.gz
8e0411224c978aaa449210637165072c *curl-7.21.7.zip
314e582264c36b3735466c522899aa07 *icu4c-4_4_2-src.tgz
ce595447571128bc66f630a8fa13339a *otp_src_R14B01.tar.gz
7979e662d11476b97c462feb7c132fb7 *otp_src_R14B03.tar.gz
5b39aa309baf8633b475f25e23b75677 *tcltk85_win32_bin.tar.gz


#TODO needs work

        cd /relax
        CYGWIN="nontsec nodosfilewarning"
        CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
        tar xzf /relax/bits/apache-couchdb-1.1.0.tar.gz &
        tar xzf /relax/bits/curl-7.21.7.tar.gz &
        tar xzf /relax/bits/otp_src_R14B03.tar.gz &
        cd /relax/otp_src_R14B03 && tar xzf /relax/bits/tcltk85_win32_bin.tar.gz &

* then run the following 4 scripts in order

        erl_config.sh
        erl_build.sh
        couchdb_config.sh
        couchdb_build.sh


## Microsoft Visual C++ runtime ###############################################

* download the runtime installer [vcredist] and copy to `c:\relax\` - note this
    must be the same as the one your compiler uses.


# Building pre-requisites for Erlang ##########################################
## Inno Installer #############################################################


## OpenSSL ####################################################################

* already installed into `C:/OpenSSL/` no further steps required

[vcredist]:
# NB this is the same version as supplied with VS2008sp1 - EXEs and DLLs built against older vcredists can use the newer one successfully
http://download.microsoft.com/download/d/d/9/dd9a82d0-52ef-40db-8dab-795376989c03/vcredist_x86.exe
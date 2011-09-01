Workflow
.- wxwidgets
.- openssl
- erlang
.- spidermonkey
- libcurl
- icu
- zlib

# Download Glazier scripts, tools, and source
################################################################################
* download and unzip [glazier latest zip](https://nodeload.github.com/dch/glazier/zipball/windows_sdk_7.0)
* set where you plan to build in. I am using `C:\relax` so:

        :: set in current shell and then user environment
        set RELAX=c:\relax
        setx RELAX %RELAX%
        mklink /d c:\cygwin\relax %RELAX%
        cd %RELAX%

* download source & tools using aria, and then check MD5 hashes:

        aria2c.exe --force-sequential=false --max-connection-per-server=4  --check-certificate=false --auto-file-renaming=false --input-file=downloads.md --max-concurrent-downloads=5 --dir=bits --save-session=bits/a2session.txt
         md5sum.exe --check md5sums.txt

# Install Compilers    
################################################################################
Due to size, these are not downloaded in the bundle apart from
mozilla & cygwin setup.

===== SKIP VC9 FOR THE MOMENT - WE SHOULD BE ABLE TO BUILD WITHOUT IT =====

* Install Visual C++ 9 only, to the default locations, using the DVD ISO
    [msvc++] excluding optional MSSSQL & Silverlight
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

# Install downloaded tools
################################################################################
The express solution is just to use 7zip to unpack [glazier tools](https://www.dropbox.com/s/jeifcxpbtpo78ak/Building_from_Source/glazier_tools.7z) inside `%relax%`. Or do it manually for the same result:

* 7zip to `7zip` and add to the user environment PATH
* Innosoft's isetup to `inno5`
* Nullsoft Installer to `nsis`
* using 7zip, extract nasm in `%relax%`
* `mkdir strawberry && cd strawberry` then using 7zip, extract Strawberry Perl
* copy vcredist to `%relax%`

## wxWidgets
################################################################################
* [wxWidgets] source and the glazier [overlay] are already downloaded
* start an SDK shell via 'setenv.cmd /Release /x86'
* run `c:\relax\bin\build_wx.cmd` to extract and build wxWidgets
* NB Erlang build requires wxWidgets in `/opt/local/pgm/wxWidgets-2.8.11` so
  we set that up too
* check for errors

[wxwidgets]: http://sourceforge.net/projects/wxwindows/files/2.8.11/wxMSW-2.8.11.zip
[overlay]:   https://raw.github.com/dch/glazier/master/bits/wxMSW-2.8.11_erlang_overlay.zip

## OpenSSL
################################################################################
Erlang requires finding OpenSSL in `c:\OpenSSL` so that's where we build to,
using mount point to keep things clean=ish.

* [OpenSSL] source has already been downloaded
* start an SDK shell via 'setenv.cmd /Release /x86'
* run `c:\relax\bin\build_openssl.cmd` to extract and build OpenSSL
* it requires nasm, 7zip, strawberry perl all in the path
* check for errors
* ensure Erlang can locate SSL with `mklink /d c:\OpenSSL %relax%\OpenSSL`

[openssl]: http://www.openssl.org/source/openssl-1.0.0d.tar.gz

## Environment
################################################################################
Our goal is to get the path set up in this order:

1. erlang and couchdb build helper scripts
2. Microsoft VC compiler from Windows SDK 7.0
3. cygwin path for other build tools like make, autoconf, libtool
4. the remaining windows system path

Express start is to:
* start an SDK shell via 'setenv.cmd /Release /x86'
* `c:\relax\bin\setup.cmd` is only needed the first time round


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
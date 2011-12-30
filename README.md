# Why Glazier?
################################################################################

I first got involved with CouchDB around 0.7, and liked what I saw. Only
having a low-spec Windows PC to develop on, and no CouchDB Cloud provider
being available, I tried to build CouchDB myself. It was hard going, and
most of the frustration was trying to get the core Erlang environment set
up and working without needing to buy Microsoft's expensive but excellent
Visual Studio tools myself. Once Erlang was working I found many of the
pre-requisite modules such as cURL, Zlib, OpenSSL, Mozilla's SpiderMonkey
JavaScript engine, and IBM's ICU were not available at a consistent
compiler and VC runtime release.

Glazier is a set of related scripts and toolchains to ease that pain.
It's not fully automated but most of the effort is only required once.
I hope it simplifies using Erlang and CouchDB for you by giving you a
consistent repeatable build environment.

# Download Glazier scripts, tools, and source
################################################################################

* download [glazier latest zip](https://nodeload.github.com/dch/glazier/zipball/master)
* unpack it into `c:\relax` - you should have `c:\relax\bin` for example
* download source & tools using aria, and then check MD5 hashes:

        pushd c:\relax
        path=c:\relax\bin;%path%
        aria2c.exe --force-sequential=false --max-connection-per-server=1 --check-certificate=false --auto-file-renaming=false --input-file=downloads.md --max-concurrent-downloads=5 --dir=bits --save-session=bits/a2session.txt
        cd bits && md5sum.exe --check ..\downloads.md5

# Install Compilers
################################################################################
Due to size, these are not downloaded in the bundle apart from
mozilla & cygwin setup.

* Install Windows SDK 7.1 either 32 or 64bit for your platform using
[win71sdk_websetup] or a downloaded [win71sdk_iso]
* Run Windows Update for latest patches
* Reboot
* Download Mozilla toolkit from [mozbuild] and install per defaults
* Install [cygwin] components, at least:
    * devel: ALL
    * editors: vim or emacs
    * utils: file

[cygwin]: http://www.cygwin.com/setup.exe
[win71sdk_websetup]: http://www.microsoft.com/download/en/confirmation.aspx?id=8279
[win71sdk_iso]:	http://go.microsoft.com/fwlink/?LinkID=191420
[mozbuild]: http://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/MozillaBuildSetup-1.6.exe

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
        06/09/2011  10:40 p.m.    <SYMLINKD>     SDK [C:\Program Files\Microsoft SDKs\Windows\v7.1]
        06/09/2011  12:19 a.m.    <SYMLINKD>     tmp [C:\Users\couch\AppData\Local\Temp]
        06/09/2011  10:40 p.m.    <SYMLINKD>     VC [c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\..]


# Install downloaded tools
################################################################################

* copy [vcredist] to `%relax%/` for later use by Erlang and CouchDB builds

The express solution is just to use 7zip to unpack [glazier tools](https://github.com/downloads/dch/glazier/toolbox.7z)
 inside `%relax%`. Or do it manually for the same result:

* Add 7zip from `c:\mozilla-build\7zip` to your path
* Innosoft's [isetup] to `%relax%/inno5`
* Nullsoft [NSIS] Installer to `%relax%/nsis`
* Add 7zip, Inno5, and nsis to the user environment PATH
* using 7zip, extract and rename [nasm] to `%relax%/nasm`
* using 7zip, extract and rename [cmake] to `%relax%/cmake`
* `mkdir strawberry && cd strawberry` then using 7zip, extract Strawberry [Perl]

[perl]: http://strawberryperl.com/download/5.12.2.0/strawberry-perl-5.12.2.0-portable.zip
[nasm]: http://www.nasm.us/pub/nasm/releasebuilds/2.09.07/win32/nasm-2.09.07-win32.zip
[cmake]: http://www.cmake.org/files/v2.8/cmake-2.8.6-win32-x86.zip
[vcredist]: http://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe
[nsis]: http://download.sourceforge.net/project/nsis/NSIS%202/2.46/nsis-2.46-setup.exe
[isetup]: http://www.jrsoftware.org/download.php/is-unicode.exe

# wxWidgets
################################################################################
* [wxWidgets] source should already be downloaded into `%relax%/bits/`
* start an SDK shell via `setenv.cmd /Release /x86`
* run `c:\relax\bin\build_wx.cmd` to extract and build wxWidgets
* NB Erlang build requires softlinked wxWidgets in `/opt/local/pgm/wxWidgets-2.8.12` so
  we set that up too
* check for errors

[wxwidgets]: http://sourceforge.net/projects/wxwindows/files/2.8.12/wxMSW-2.8.12.zip

# OpenSSL
################################################################################
Erlang requires finding OpenSSL in `c:\OpenSSL` so that's where we build to,
using mount point to keep things clean=ish under `%relax%`.

* [OpenSSL] source has already been downloaded
* start an SDK shell via `setenv.cmd /Release /x86`
* run `c:\relax\bin\build_openssl.cmd` to extract and build OpenSSL
* it requires nasm, 7zip, strawberry perl all in place
* check for errors
* ensure Erlang can locate SSL with `mklink /d c:\OpenSSL %relax%\OpenSSL`
* the resulting DLLs in `c:\relax\openssl\bin` need to be distributed with
Erlang/OTP and therefore CouchDB as well.

[openssl]: http://www.openssl.org/source/openssl-0.9.8r.tar.gz

# Environment
################################################################################
Our goal is to get the path set up in this order:

1. erlang and couchdb build helper scripts
2. Microsoft VC compiler, linker, etc from Windows SDK
3. cygwin path for other build tools like make, autoconf, libtool
4. the remaining windows system path

The express start is to:

* start an SDK shell via `setenv.cmd /Release /x86`
* launch a cygwin erl-ified shell via `c:\relax\bin\shell.cmd`
* go to next section to compile Erlang/OTP

Alternatively, you can launch your own cmd prompt, and ensure that your system
path is correct first in the win32 side before starting cygwin. Once in cygwin
go to the root of where you installed erlang, and run the Erlang/OTP script:

        eval `./otp_build env_win32`
        echo $PATH | /bin/sed 's/:/\n/g'
        which cl link mc lc mt

Confirm that output of `which` returns only MS versions from VC++ or the SDK.
This is critical and if not correct will cause confusing errors much later on.
Overall, the desired order for your $PATH is:

* Erlang build helper scripts
* Windows SDK tools, .Net framework
* Visual C++ if installed
* Ancillary Erlang and CouchDB packaging tools
* Usual cygwin unix tools such as make, gcc
* Ancillary glazier/relax tools for building dependent libraries
* Usual Windows folders `%windir%;%windir%\system32` etc
* Various settings form the `otp_build` script

More details are at [erlang INSTALL-Win32.md on github](http://github.com/erlang/otp/blob/dev/INSTALL-WIN32.md)

# Erlang
################################################################################

* start an SDK shell via `setenv.cmd /Release /x86`
* launch a cygwin erl-ified shell via `c:\relax\bin\shell.cmd`
* choose your erlang version - R14B03 is strongly advised
* unpack erlang source by `cd $RELAX && tar xzf bits/otp_src_R14B03.tar.gz`
* customise Erlang by excluding unneeded Java interface and old GS GUI:

        cd $ERL_TOP
        tar xvzf /relax/bits/tcltk85_win32_bin.tar.gz
        echo "skipping gs" > lib/gs/SKIP
        echo "skipping jinterface" > lib/jinterface/SKIP


* after validating the path, I usually run these two scripts which
can take several hours on slower machines:

        erl_config.sh
        erl_build.sh

* the output is logged into `$ERL_TOP/build_*.txt` if required
* at this point I usually duplicate the OTP source tree for later

        robocopy $ERL_TOP /relax/release/$OTP_REL -mir


# ICU 4.6.1
################################################################################

* Download ICU 4.6.1 windows source from [icu461]
* either re-use the "shell.cmd" from before, or open a Windows SDK prompt
via `setenv /release /x86` again

        %relax%\bin\build_icu.cmd

* confirm that the resulting ICU DLLs have the appropriate manifests

[icu461]: http://download.icu-project.org/files/icu4c/4.6.1/icu4c-4_6_1-src.zip

# LibcURL
################################################################################
LibcURL is only required for versions of CouchDB < 1.1.1 where it is embedded
in couchjs.exe. Trunk and future releases will have this as an optional include.

* download [LibcURL] source from (http://curl.haxx.se/)
* either re-use the "shell.cmd" from before, or open a Windows SDK prompt
via `setenv /release /x86` again

        %relax%\bin\build_curl.cmd

[libcurl]: http://curl.haxx.se/download/curl-7.23.1.zip

# Javascript
################################################################################
The Javascript engine used by CouchDB is Mozilla Spidermonkey v1.8.5 [js185].

* to build and install SpiderMonkey we use the mozilla tools chain.
* run `c:\mozilla-build\start-msvc10.bat` even if you are on a 64-bit platform.
* do a sanity check to confirm the MS build compilers are present via
 `which cl link mc lc mt`
* you may need to fudge the path if `cl.exe` can't be found using `PATH=$PATH:/c/relax/VC/VC/bin/:/c/relax/SDK/bin:/c/relax/VC/Common7/IDE:/c/relax/VC/VC/bin/amd64/:/c/relax/VC/VC/bin/x86_ia64/`

        cd /c/relax
        tar xzf bits/js185-1.0.0.tar.gz
        cd ./js-1.8.5/js/src
        autoconf-2.13
        ./configure --enable-static --enable-shared-js
        make

[js185]: http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz

# Building CouchDB
################################################################################

Finally we are going to build Apache CouchDB... whew! Recapping, we should have:

* erlang in `/relax/otp_src_R14B04/release/win32` with a copy stashed nearby
* openssl in `/relax/openssl/{bin,lib}/{lib,ssl}eay32.{bin,lib}`
* libcurl in `/relax/curl/lib/libcurl.lib`
* js library in `/relax/js-1.8.5/js/src/dist/{bin,lib}/mozjs185-1.0.*`
* icu in `/relax/icu/bin/icu*.dll`

There are two relevant scripts for building CouchDB:

* `couchdb_config.sh` for CouchDB 1.1.1 or newer, supporting js185 only
* `couchdb_build.sh` which compiles, and packages, CouchDB

There are still some patches required against both released and master versions.
For CouchDB 1.1.1 or newer, two small filthy hacks are required, which
is needed until `configure.ac` avoids detection of cygwin's curl and avoids
assuming that help2man will be useful on Windows.

        cd /relax
        git clone http://git-wip-us.apache.org/repos/asf/couchdb.git
        git checkout 1.1.1
        git clean -fdx
        cd couchdb
        mv /usr/bin/curl-config /usr/bin/curl-config.dist
        mv /usr/bin/help2man /usr/bin/help2man.dist
        ./bootstrap
        /relax/bin/couchdb_build.sh

# Why Glazier?

I first got involved with CouchDB around 0.7. Only having a low-spec Windows
PC to develop on, and no CouchDB Cloud provider being available, I tried
to build CouchDB myself. It was hard going, and most of the frustration was
trying to get the core Erlang environment set up and compiling without needing
to buy Microsoft's expensive but excellent Visual Studio tools myself. Once
Erlang was working I found many of the pre-requisite modules such as cURL,
Zlib, OpenSSL, Mozilla's SpiderMonkey JavaScript engine, and IBM's ICU were
not available at a consistent compiler and VC runtime release.

Glazier is a set of related scripts and toolchains to ease that pain.
It's not fully automated but most of the effort is only required once.
I hope it simplifies using Erlang and CouchDB for you by giving you a
consistent repeatable build environment.

There is a branch of glazier that was used to build each CouchDB release.
I'm in the process of migrating a large portion of the setup scripts to
use [Chocolatey] for installing pre-requisites, and then to roll most of
the code into the CouchDB autotools scripts.

# Big Picture

When I build Erlang/OTP from source, or CouchDB, I typically spend 80% of my
time faffing around getting dependencies right. I want to make this as easy as
`aptitude install -y <list_of_packages>`.

Here's the general approach:

- 64-bit Windows + 64-bit SDK 7.1 + optionally Visual Studio 2012
- chocolatey packages for remaining dev tool dependencies
- Cygwin latest development tools

Onwards!

# Windows and SDKs

While any 64-bit Windows will likely do, I use specifically:

- 64-bit Windows 8 Enterprise N (the Euro version without media player etc) from MSDN [en-gb_windows_8_enterprise_n_x64_dvd_918053.iso](https://msdn.microsoft.com/en-us/subscriptions/securedownloads/#FileId=50201)
- Install the full [Microsoft .Net Framework 4](http://www.microsoft.com/en-us/download/details.aspx?id=17851)
- reboot and run updates
- Install [Windows SDK 7.1](http://www.microsoft.com/download/en/confirmation.aspx?id=8279)
- Optionally, Install `Visual Studio 2012 Ultimate` via the web installer for a nice UI & debugger interface
- Install the [NuGet Package Manager](http://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c)
- Install [Chocolatey]:

	@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.github.com/chocolatey/chocolatey/master/chocolateyInstall/InstallChocolatey.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
- Apply Windows Updates and Reboot until Done.

Typically here I shutdown & snapshot my VM as past this point its going to
evolve a lot over time. Many of the downstream chocolatey packages still
prompt you to run their installers, which arguably defeats the purpose, but
hey its still marginally easier.

[Chocolatey]: http://chocolatey.org/
[NuGet]: http://nuget.org/

# Pre-requisites

## Clean Package Installs with Chocolatey

These packages install silently, without intervention. Cut and paste them
into a command prompt, leave it running, and open another one for the next
section.

    cinst git
    cinst 7zip.commandline
    cinst sublimetext2
    cinst StrawberryPerl
    cinst nsis
    cinst MozillaBuild
    cinst nasm
    cinst InnoSetup

## Optional but Useful Packages

    cinst sysinternals
    cinst dependencywalker
    cinst cmake
    cinst SourceCodePro
    cinst firefox
    cinst GoogleChrome.Canary
    cinst ChocolateyPackageUpdater
    cinst MicrosoftSecurityEssentials
    cinst msicuu2


## Cygwin

Download and run [Cygwin Setup](http://cygwin.com/setup.exe)

Confirm you have:

        ARCHIVE/
        - p7zip

        DEVEL/
        - auto*
        - binutils
        - bison
        - gcc-core
        - gcc-g++
        - gcc4-core
        - gcc4-g++
        - gdb
        - git
        - libtool
        - make
        - patchutils
        - pkgconfig
        - readline

        EDITORS/
        - vim

        INTERPRETERS/
        - M4
        - perl
        - python

        NET/
        - aria2

        UTILS/
        - file
        - gnupg
        - rename
        - socat
        - time
        - tree
        - util-linux

        WEB/
        - wget

        Ensure you DON'T have:
        - help2man
        - curl


## Update AutoConf Archives

Start a new cygwin shell:

    cd /cygdrive/c/relax/bits
    wget http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2012.09.08.tar.gz
    tar zxf autoconf-archive-2012.09.08.tar.gz
    cd autoconf-archive-2012.09.08
    ./configure --prefix=/usr && make && make install

## Install Python easy_install and Sphinx for Documentation Builds

Still within cygwin:

    cd /relax/bits
    wget http://pypi.python.org/packages/2.6/s/setuptools/setuptools-0.6c11-py2.6.egg
    sh setuptools-0.6c11-py2.6.egg
    easy_install sphinx docutils pygments
    # check its working
    sphinx-build -h

## make a new prompt

Make a new shortcut on the desktop, targeted at
`cmd.exe /E:ON /V:ON /T:0E /K "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x86 /release`
and I suggest you pin it to the start menu. We'll use this all the time,
referred to as `the SDK prompt`. Right-click on the icon, click the `advanced`
button, and tick the `Run as Administrator` button. We do need this so that
`cp -P` works within autotools on Windows8.

When you launch one, the text will be an unreadable green. Type `color` to
fix it. Color takes parameters if you hate yellow. Borland users will like
`color 1f`. Let's confirm we have the right bits with
`echo %RELAX% && where cl mc mt link lc rc nmake`:

	c:\relax
	C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\cl.exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\MC.Exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\mt.exe
	C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\link.exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\NETFX 4.0 Tools\lc.exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\lc.exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\RC.Exe
	C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\nmake.exe

Stop here if it's not *identical*. Not Visual Studio 11.0. Not SDK v8.0a,
or 7.0, or 7.0a, or any other satanic god-forsaken combination not listed here.
Seriously. Identical.

## Set up convenience Links

	mkdir c:\relax\bits
        pushd c:\relax && rd SDK VC nasm inno5 nsis strawberry
	mklink /j c:\relax\SDK "C:\Program Files\Microsoft SDKs\Windows\v7.1"
	mklink /j c:\relax\VC "C:\Program Files (x86)\Microsoft Visual Studio 10.0"
	mklink /j nasm "c:\Program Files (x86)\nasm"
	mklink /j c:\relax\inno5 "c:\Program Files (x86)\Inno Setup 5"
	mklink /j c:\relax\nsis "c:\Program Files\NSIS"

	:: these ones are for the picky software packagers
	mklink /j c:\cygwin\relax c:\relax
	mklink /j c:\openssl c:\relax\openssl

## Set Environment Variables

	setx RELAX c:\relax
	set RELAX=c:\relax

Close all open command prompts. Now!!

# Building CouchDB Pre-requisites

## Setting up the glazier build kit

	git clone git://github.com/dch/glazier.git c:\relax
	pushd c:\relax && path=c:\relax\bin;%PATH%;
	aria2c.exe --force-sequential=false --max-connection-per-server=5 --check-certificate=false --auto-file-renaming=false --input-file=downloads.md --max-concurrent-downloads=5 --dir=bits --save-session=bits/a2session.txt

## Build wxWidgets

Open a new SDK prompt. Check that it has `/x86 /Release Build` in the title bar.

	pushd %RELAX%\bin && build_wx.cmd

## Build OpenSSL

	pushd %RELAX%\bin && build_openssl.cmd

## Build ICU

	pushd %RELAX%\bin && build_icu.cmd

## Start a UNIX-friendly shell

Our goal is to get the path set up in this order:

1. erlang and couchdb build helper scripts
2. Microsoft VC compiler, linker, etc from Windows SDK
3. cygwin path for other build tools like make, autoconf, libtool
4. the remaining windows system path

It seems this is a challenge for most environments, so `glazier` just
assumes you're using [chocolatey] and takes care of the rest.

- start your `SDK prompt` as above
- launch a cygwin erl-ified shell via `c:\relax\bin\shell.cmd`
- select R14B04 unless you know what you are doing
- go to next section to compile Erlang/OTP

Alternatively, you can launch your own cmd prompt, and ensure that your system
path is correct first in the win32 side before starting cygwin. Once in cygwin
go to the root of where you installed erlang, and run the Erlang/OTP script:

        eval `./otp_build env_win32`
        echo $PATH | /bin/sed 's/:/\n/g'
        which cl link mc lc mt nmake rc

Confirm that output of `which` returns only MS versions from VC++ or the SDK.
This is critical and if not correct will cause confusing errors much later on.
Overall, the desired order for your $PATH is:

- Erlang build helper scripts
- Windows SDK tools, .Net framework
- Visual C++ if installed
- Ancillary Erlang and CouchDB packaging tools
- Usual cygwin unix tools such as make, gcc
- Ancillary glazier/relax tools for building dependent libraries
- Usual Windows folders `%windir%;%windir%\system32` etc
- Various settings form the `otp_build` script

More details are at [erlang INSTALL-Win32.md on github](https://github.com/erlang/otp/blob/master/HOWTO/INSTALL-WIN32.md)

## Unpack Erlang/OTP

	cd .. && tar xzf /relax/bits/otp_src_R14B04.tar.gz
	cd $ERL_TOP
	cp /relax/SDK/Redist/VC/vcredist_x86.exe /cygdrive/c/werl/
	cp /relax/SDK/Redist/VC/vcredist_x86.exe /cygdrive/c/relax/

## Configure and Build Erlang/OTP

	echo "skipping gs" > lib/gs/SKIP
	echo "skipping ic" > lib/ic/SKIP
	echo "skipping jinterface" > lib/jinterface/SKIP
	erl_config.sh && erl_build.sh

## Spidermonkey

Spidermonkey needs to be compiled with the Mozilla Build chain. This
requires special and careful incantations. Launch your `SDK prompt` again.

    color
    call c:\mozilla-build\start-msvc10.bat
    which cl link
    # /c/Program Files (x86)/Microsoft Visual Studio 10.0/VC/Bin/cl.exe
    # /c/Program Files (x86)/Microsoft Visual Studio 10.0/VC/Bin/link.exe
    export INCLUDE='c:\relax\SDK\include;c:\relax\VC\VC\Include;c:\relax\VC\VC\Include\Sys;'
    export LIB='c:\Program Files\Microsoft SDKs\Windows\v7.1\Lib;c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\lib;c:\mozilla-build\atlthunk_compat'
    export PATH=/c/relax/SDK/Bin:/c/relax/VC/VC/bin:$PATH
    which cl lc link mt rc make
    # /c/relax/VC/VC/bin/cl.exe
    # /c/relax/SDK/Bin/lc.exe
    # /c/relax/VC/VC/bin/link.exe
    # /c/relax/SDK/Bin/mt.exe
    # /c/relax/SDK/Bin/rc.exe
    # /usr/local/bin/make
    cd /c/relax
    tar xzf bits/js185-1.0.0.tar.gz
    cd /c/relax/js-1.8.5/js/src
    autoconf-2.13
    ./configure --enable-static --enable-shared-js --enable-debug --enable-debug-symbols
    make
    make check # optional, takes a while, check-date-format-tofte.js fails
    exit

Note: the above PATH and LIB hacks are a workaround for having both
VS2012 + SDK7.1 installed side by side. It seems that having both of
these installed breaks compilation of js-185. If you're building with
the SDK 7.1 alone this is not required.

## Building CouchDB itself

start `SDK prompt`, shell (4) for R14B04.

    cd /relax && git clone http://git-wip-us.apache.org/repos/asf/couchdb.git
    git checkout --track origin/1.3.x ## or suitable tag here
    git clean -fdx && git reset --hard
    ./bootstrap && couchdb_config.sh && couchdb_build.sh

This will produce a working CouchDB installation inside
`$ERL_TOP/release/win32` that you can run directly, and also a full
installer inside `$COUCH_TOP/etc/windows/` to transfer to other
systems, without the build chain dependencies.

Glazier prints out minimal instructions to transfer the logs and other files
to a release directory of your choice. I typically use this when building
from git to keep track of snapshots, and different erlang or couch build
configurations.

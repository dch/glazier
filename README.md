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

- 64-bit Windows + 64-bit SDK 7.1 + Visual Studio 2012
- chocolatey packages for remaining dev tool dependencies
- Cygwin latest development tools

Onwards!

# Windows and SDKs

While any 64-bit Windows will likely do, I use specifically:

- 64-bit Windows 8 Enterprise N (the Euro version without media player etc) from MSDN [en-gb_windows_8_enterprise_n_x64_dvd_918053.iso](https://msdn.microsoft.com/en-us/subscriptions/securedownloads/#FileId=50201)
- Install the full [Microsoft .Net Framework 4](http://www.microsoft.com/en-us/download/details.aspx?id=17851)
- reboot and run updates
- Install [Windows SDK 7.1](http://www.microsoft.com/download/en/confirmation.aspx?id=8279)
- Install [Visual Studio 2012 Express](http://www.microsoft.com/en-ca/download/details.aspx?id=34673)
- Install [Chocolatey]:

    	    @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin

- (optional) Install the [NuGet Package Manager](http://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c)
- Apply Windows Updates and Reboot until no more updates appear.

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

Download and run *32-bit* [Cygwin Setup](http://cygwin.com/setup-x86.exe)

Select the following, in addition to the defaults:

        ARCHIVE/
        - p7zip

        DEVEL/
        - auto*
        - binutils
        - bison
        - gcc-core
        - gcc-g++
        - gdb
        - git
        - libtool
        - make
        - patchutils
        - pkg-config
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
        - renameutils
        - socat
        - time
        - tree
        - util-linux

        WEB/
        - wget

        *Ensure you DON'T have*:
        DEVEL/
        - help2man
        NET/
        - curl


## Update AutoConf Archives

Start a new cygwin shell:

    git config --global core.autocrlf false
    mkdir -p /cygdrive/c/relax/bits
    cd /cygdrive/c/relax/bits
    wget http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2013.11.01.tar.gz
    tar zxf autoconf-archive-2013.11.01.tar.gz
    cd autoconf-archive-2013.11.01
    ./configure --prefix=/usr && make && make install

## Install Python easy_install, pip and Sphinx for Documentation Builds

Still within cygwin:

    cd /cygdrive/c/relax/bits
    echo "--ca-directory=/usr/ssl/certs" > ~/.wgetrc
    wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | python
    wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py -O - | python
    pip install sphinx docutils pygments
    # check its working
    sphinx-build -h

## Make a new prompt shortcut

Make a new shortcut on the desktop, targeted at

    cmd.exe /E:ON /V:ON /T:1F /K "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x86 /release && color 1f
    
I suggest you pin it to the Start menu. We'll use this all the time,
referred to as `the SDK prompt`. Right-click on the icon, click the `advanced`
button, and tick the `Run as Administrator` button. We do need this so that
`cp -P` works within autotools on Windows8.

If you don't like white-on-blue, type `color` to fix it. It takes parameters.

Let's confirm we have the right bits with
`where cl mc mt link lc rc nmake`:

	C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\cl.exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\MC.Exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\mt.exe
	C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\link.exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\NETFX 4.0 Tools\lc.exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\lc.exe
	C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\RC.Exe
	C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\nmake.exe

Stop here if your results are not *identical*.

*NOTE*: A recent MS .NET 4 security update broke the ICU build process. To fix, rename
the broken SDK version of `cvtres.exe` to get it out of the path:

        copy "C:\Windows\Microsoft.NET\Framework\v4.0.30319\cvtres.exe" "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\BIN\cvtresold.exe"

## Set up required convenience links

        pushd c:\relax
        rd /s/q SDK VC nasm inno5 nsis strawberry
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

Close all open command prompts. Now we're ready to go!

# Building CouchDB Pre-requisites

## Setting up the glazier build kit

	pushd c:\relax
        git config --global core.autocrlf false
	git clone git://github.com/dch/glazier.git
	mklink /j c:\relax\bin c:\relax\glazier\bin
	path=c:\relax\bin;%PATH%;
	aria2c.exe --force-sequential=false --max-connection-per-server=5 --check-certificate=false --auto-file-renaming=false --input-file=glazier/downloads.md --max-concurrent-downloads=5 --dir=bits --save-session=bits/a2session.txt

## Build wxWidgets

Open a new SDK prompt. Check that it has `x86 Release Build Environment` in the title bar.

	pushd %RELAX%\bin && build_wx.cmd

## Build OpenSSL

	pushd %RELAX%\bin && build_openssl.cmd

## Build ICU

	pushd %RELAX%\bin && build_icu.cmd

## Start a UNIX-friendly shell with MS compilers

The short version:

1. Start your `SDK prompt` as above
2. Launch a cygwin erl-ified shell via `c:\relax\bin\shell.cmd`
3. Select R14B04 unless you know what you are doing!
4. Skip down to the next section ("Unpack Erlang/OTP")

The long version: our goal is to get the path set up in this order:

1. erlang and couchdb build helper scripts
2. Microsoft VC compiler, linker, etc from Windows SDK
3. cygwin path for other build tools like make, autoconf, libtool
4. the remaining windows system path

It seems this is a challenge for most environments, so `glazier` just
assumes you're using [chocolatey] and takes care of the rest.

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
    ./configure --enable-static --enable-shared-js --enable-debug-symbols
    make
    make check # optional, takes a while, check-date-format-tofte.js fails
    exit

Note: the above PATH and LIB hacks are a workaround for having both
VS2012 + SDK7.1 installed side by side. It seems that having both of
these installed breaks compilation of js-185. If you're building with
the SDK 7.1 alone this is not required, but it's recommended to
follow the steps above anyway for safety.

## Building CouchDB itself

start `SDK prompt`, then shell.cmd, option (4) for R14B04.

    cd /relax && git clone http://git-wip-us.apache.org/repos/asf/couchdb.git
    cd /relax/couchdb
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

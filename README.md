#Glazier - automating building CouchDB on Windows #############################

Glazier is a set of scripts designed to help automate as much as practicable the
build of CouchDB on Windows, from XP/2003 to Windows 7 or Server 2008. It
assumes you're starting from a vanilla state.

# Using Glazier  ##############################################################

Glazier requires 5 things to run successfully
1 you are logged in as a local user "couchdb" which has admin permissions
2 Windows XP, 2003, Vista, Windows 7 or 2008, either 32 or 64-bit platforms
3 internet connectivity
4 approx 12GiB of disk space during fetch & build stages
5 download and unzipped
	[glazier latest zip](http://github.com/dch/glazier/zipball/master)
6 an optional environment variable, %RELAX%, set to where you wish to have CouchDB
 and Erlang built within. If none is selected, c:\relax will be used.


## Current State ##############################################################

* The steps below, manually or automated, should produce a working CouchDB build & self-installing .exe from
	Erlang/OTP  R14A, and CouchDB 0.11.2 or 1.0.1. 
* The build environment should be fully functional on both 32,64, desktop and
	server versions of windows from XP/2003 onwards
* Fetching binaries is described and automated
* Installation of development environment is described and automated
* Downloads are not small -
	get_bits.cmd](http://github.com/dch/glazier/blob/master/bin/get_bits.cmd)
	retrieves approx 7GiB of DVD ISOs for Microsoft's Visual Studio 2008
	compiler, related SDKs, the smaller cygwin and mozilla build frameworks,
	source and misc tools
* Glazier tries to be self-contained so that it is both repeatable and also
	easy to clean up.

# Running Automatically #######################################################

* run `%GLAZIER%\bin\glaze.cmd` to fetch & cache the bits, install compiilers
* you will need to select the cygwin modules individually
* close any open command prompts
* run `%GLAZIER%\bin\relax.cmd` to start a valid build environment
* select the erlang version you wish to build from
* the first time around you will need to unpack your erlang and couchdb tarballs

        cd /relax
        tar xzf /relax/bits/apache-couchdb-0.11.2.tar.gz &        
        tar xzf /relax/bits/apache-couchdb-1.0.1.tar.gz &        
        tar xzf /relax/bits/curl-7.21.1.tar.gz &        
        tar xzf /relax/bits/otp_src_R13B04.tar.gz &        
        tar xzf /relax/bits/otp_src_R14A.tar.gz &
        cd /relax/otp_src_R13B04; tar xzf /relax/bits/tcltk85_win32_bin.tar.gz &
        cd /relax/otp_src_R14A;   tar xzf /relax/bits/tcltk85_win32_bin.tar.gz &
        
* then run the following 4 scripts in order
        
        couchdb_build.sh
        couchdb_config.sh
        erl_build.sh
        erl_config.sh

* each of these scripts leaves logfiles in the root folder. If you have issues
	during compilation phase, load these onto <http://friendpaste.com/>
	don't email them to the mailing list

# Installing the Build Environment

* Building Erlang & CouchDB on Windows requires a custom build environment,
	which is very sensitive to path order amongst the three different 
	compilers used to build wxWidgets, erlang, javascript, and couchdb
* Each component is built via standard Makefiles in the Cygwin unix/posix
	emulation layer, and then handed over to the appropriate compiler.
* This is further complicated by different install locations on 32 vs 64 bit
	windows versions, and which Microsoft C compiler and Windows SDKs
	installed.

## Cygwin
The full Cygwin install comprises several GiB of data. Run [cygwin]'s setup.exe
	using defaults, optionally installing all components if you have the
	bandwidth, or alternatively with the following additional modules at a
	minimum:

* devel: ALL
* editors: vim
* utils: file

After install, set up a link to where you plan to install related binaries,
	build erlang, and couchdb. I am using `C:\relax` so:

		setx RELAX c:\relax
		mkdir %RELAX%
		junction.exe c:\cygwin\relax %RELAX%

## Mozilla Build
The mozilla build toolchain is needed solely for building a javascript engine.

* Download it from [mozbuild] and install per defaults

## Microsoft Visual C++
* Erlang and CouchDB can be built using the free VS2008 Express C++ edition
	from [MSDN](http://msdn.microsoft.com/en-gb/vstudio/)
* install Visual C++ 9 only, to the default locations, using the DVD ISO
	[msvc++] excluding optional MSSSQL & Silverlight

## Windows 7 SDK
* The windows 7 SDK is required, as the free VS2008 install is missing the
	message compiler. Download one of the following version per your
	requirements & install
* [win7sdk_32bit]
* [win7sdk_64bit]

# Supporting Tools

Both CouchDB and Erlang have dependencies on other opensource tools.

## OpenSSL

* use the 32-bit version even if you are using a 64-bit OS
* download [openssl_bits] and install to `c:\openssl`

## Innosoft Installer

* download the installer [inno_bits] and install to `c:\relax\inno5`

## NSIS Installer

* download the installer [nsis_bits] and install to `c:\relax\nsis`

## set up links

* to keep our paths clean later, and largely independent of the compiler
	installs if you have pre-existing ones, start a new cmd.exe prompt
	with a fresh environment
* this should have both VS90ComnTools and ProgramFiles environment vars
	defined from the previous install of Visual Studio
* setup the following hard links (junction points), using either the included
	mklink tool (Windows 7 and later), or SysInternal's
	[junction](http://live.sysinternals.com/junction.exe)

        junction c:\relax\openssl c:\openssl
        junction c:\relax\vs90 "%VS90COMNTOOLS%\..\.."
        junction c:\relax\SDKs "%programfiles%\Microsoft SDKs\Windows"

or using mklink.exe

        mklink /j c:\relax\openssl c:\openssl
	[etc...]

# Building pre-requisites for Erlang

## wxWidgets
* two components are used for building Erlang's graphical shell, `werl.exe`
	on windows
* download [wxwidgets_bits] from [WxWidgets website](http://wxwidgets.org/)
	& unzip using cygwin into /relax/
* the Erlang build expects to see wxWidgets in /opt/local/pgm/wxWidgets-2.8.11
	by default

        mkdir c:\cygwin\opt\local\pgm
        junction c:\cygwin\opt\local\pgm\wxWidgets-2.8.11 c:\relax\wxMSW-2.8.11

* Using a suitable editor (vi in the cygwin suite, or install
	[notepadplus_bits] for windows users) and
* Edit `c:\relax\wxMSW-2.8.11\include\wx\msw\setup.h` to enable
	`wxUSE\_GLCANVAS, wxUSE\_POSTSCRIPT` and `wxUSE\_GRAPHICS_CONTEXT`

### wx.dsw
* open VSC++ & the project  `C:\relax\wxMSW-2.8.11\build\msw\wx.dsw`,
	accepting the automatic conversion to the newer VC++ format and save
	as `\relax\wxMSW-2.8.11\build\msw\wx.sln`
* right-click on the project, and set up the dependencies for wx.dsw to
	achieve the below build order
`jpeg, png, tiff, zlib, regex, expat, base, net, odbc, core,
 gl, html, media, qa, adv, dbgrid, xrc, aui, richtext, xml`
* Launch a new prompt from somewhere like Start -> Programs -> Microsoft
	Visual C++ -> Visual Studio Tools -> VS2008 Cmd Prompt
* Then build all unicode release (and unicode debug) packages:

        pushd %RELAX%\wxMSW*\build\msw
        vcbuild /useenv  /platform:Win32 /M4 wx.sln "Unicode Release|Win32"
        vcbuild /useenv  /platform:Win32 /M4 wx.sln "Unicode Debug|Win32"

### stc.dsw
* open VSC++ & convert `%RELAX%\wxMSW-2.8.11\contrib\build\stc\stc.dsw`
	to `%RELAX%\wxMSW-2.8.11\contrib\build\stc\stc.sln`

        pushd %RELAX%\wxMSW*\contrib\build\stc
        set LIB=%LIB%;..\..\..\include..\..\..\lib\vc_lib\mswd
        set LIBPATH=%LIBPATH%;..\..\..\lib\vc_lib
        vcbuild /useenv /platform:Win32 /M4 stc.sln "Unicode Release|Win32"
        vcbuild /useenv /platform:Win32 /M4 stc.sln "Unicode Debug|Win32"

********************************************************************************
# Building Erlang

* after installing VC++ 2008 Express, and most other Visual Studio solutions,
	`call "%vs90comntools%\..\..\vc\vcvarsall.bat" x86` will automatically
	insert the correct VS2008 compiler paths, but not the Windows v7.0 SDK.
	It sets up our 32-bit build environment correctly, independently if
	you have installed on 32 or 64bit windows.
	
* in a cmd.exe shell
      
        junction.exe %RELAX%\bin %GLAZIER%\bin
        junction.exe %RELAX%\bits %GLAZIER%\bits
        mkdir %RELAX%\release
  
* in a cygwin shell, using these new junction points:

        cd /relax
        tar xzf /relax/bits/otp_src_R14A.tar.gz &
        tar xzf /relax/bits/otp_src_R13B04.tar.gz &

* then run `%GLAZIER%\bin\relax.cmd`

## Tk/Tcl
* optional component

        cd $ERL_TOP && tar xvzf /relax/bits/tcltk85_win32_bin.tar.gz
        # or simply
        cd /relax/otp_src_R14A && tar xvzf /relax/bits/tcltk85_win32_bin.tar.gz
        cd /relax/otp_src_R13B04 && tar xvzf /relax/bits/tcltk85_win32_bin.tar.gz

* or skip the whole damn lot this way

		echo "skipping gs" > lib/gs/SKIP

* check that `which cl; which link; which mc` return the MS ones, if not then sort them out manually. Refer to [relax.cmd](http://github.com/dch/glazier/bin/relax.cmd) and  [relax.sh](http://github.com/dch/glazier/bin/relax.sh)
* build Erlang using `/relax/glazier/bin/erl_config.sh` and `/relax/glazier/bin/erl_build.sh`, or manually as follows

		./otp_build autoconf
		./otp_build configure
		./otp_build boot -a
		./otp_build release -a
		./otp_build installer_win32
		# we need to set up erlang to run from this new source build to build CouchDB
		echo -e \\n|./release/win32/Install.exe
		
[erlang INSTALL-Win32.md on github](http://github.com/erlang/otp/blob/dev/INSTALL-WIN32.md)

or using the relax tools:

        start %glazier%\bin\relax.cmd
	[select erlang R14A build or R13B04]
	/relax/bin/erl_config.sh; /relax/bin/erl_build.sh
	[note concurrent builds don't work - try putting a sleep 1200 in front]


********************************************************************************
# CouchDB
********************************************************************************

CouchDB has been built & tested against the following components successfully

* Erlang OTP R13B04 or R14A including source
* ICU 4.2.1                      (http://icu.sourceforge.net/)
* Win32 OpenSSL  1.0.0a               (http://www.openssl.org/)
* Mozilla SpiderMonkey 1.8 from SeaMonkey 2.0.6
* libcurl 7.21.1                    (http://curl.haxx.se/libcurl/)

## Javascript

The Javascript engine used by CouchDB is built from Seamonkey, using the mozilla build toolkit.

* get [seamonkey_bits]
* run `c:\mozilla-build\start-msvc9.bat` even if you are on a 64-bit platform.

        cd /c/relax && mkdir seamonkey-2.0.6
        cd seamonkey-2.0.6
        tar xjf /d/glazier/bits/seamonkey-2.0.6.source.tar.bz2
        cd /c/relax/seamonkey-2.0.6/comm-1.9.1/mozilla/js/src
        autoconf-2.13
        ./configure
        make

* to install from -current do:
        cd /c/relax && mkdir seamonkey-current
        cd seamonkey-current
        hg clone http://hg.mozilla.org/mozilla-central
        cd mozilla-central/......./comm-1.9.1/mozilla/js/src
        autoconf-2.13
        ./configure
        make

## Inno Installer
from http://www.jrsoftware.org/download.php/ispack-unicode.exe
download and install ispack-5.3.10-unicode.exe, including all additional components
to c:\relax\inno5 & ensure its in the path

## OpenSSL

* already installed into C:/OpenSSL/ no further steps required


## LibCURL

### from cygwin shell:	

        cd /relax && tar xf /relax/bits/curl-7*

### from cmd shell:

        pushd c:\relax\curl-7*
        set OPENSSL_PATH=c:\openssl
        set INCLUDE=%INCLUDE%;%OPENSSL_PATH%\include\openssl;
        set LIBPATH=%LIBPATH%;%OPENSSL_PATH%\lib;
        set LIB=%LIB%;%OPENSSL_PATH%\lib;

        vcbuild /useenv /upgrade /platform:Win32 lib\libcurl.vcproj
        vcbuild /useenv /platform:Win32 lib\libcurl.vcproj "Release|Win32"
        xcopy lib\Release\libcurl.lib lib\ /y /f
	popd
## ICU
* binaries from http://site.icu-project.org/
		wget http://download.icu-project.org/files/icu4c/4.4.1/icu4c-4_4_1-Win32-msvc9.zip
		wget http://download.icu-project.org/files/icu4c/4.2/icu4c-4_2-Win32-msvc9.zip
		cd c:\relax
		7z x d:\glazier\bits\icu4c-4_2_1-Win32-msvc9.zip

## Make & Build
        ./configure \
        --with-js-include=/cygdrive/c/path_to_seamonkey \
        --with-js-lib=/cygdrive/c/path_to_seamonkey_lib \
        --with-win32-icu-binaries=/cygdrive/c/path_to_icu_binaries_root \
        --with-erlang=$ERL_TOP/release/win32/usr/include \
        --with-win32-curl=/cygdrive/c/path/to/curl/root/directory \
        --with-openssl-bin-dir=/cygdrive/c/openssl/bin \
        --with-msvc-redist-dir=/cygdrive/c/dir/with/vcredist_platform_executable \
        --prefix=$ERL_TOP/release/win32

## using seamonkey 2.0.6
        ./configure \
        --prefix=$ERL_TOP/release/win32 \
        --with-erlang=$ERL_TOP/release/win32/usr/include \
        --with-win32-icu-binaries=/relax/icu \
        --with-win32-curl=/relax/curl-7.21.1 \
        --with-openssl-bin-dir=/relax/openssl/bin \
        --with-msvc-redist-dir=/relax \
        --with-js-lib=/relax/seamonkey-2.0.6/comm-1.9.1/mozilla/js/src/dist/lib \
        --with-js-include=/relax/seamonkey-2.0.6/comm-1.9.1/mozilla/js/src/dist/include/js

CURL
[curl] -> win32-openssl [curl_bits]

# Automated Test Bed for Builds
The objective is to take the current manual steps, and have them automated for a successful build off a variety of representative Microsoft current OS using Amazon EC2 infrastructure.

## Tested AMIs

These are all sourced from [AWS Windows Servers] provided by Amazon. The release build is taken from the Windows 2008 64-bit AMI below. You will need to set up an AWS account before using the [AWS console] and we recommend using spot instances as these are significantly cheaper to run.

TODO // URLs don't go to right AMIs

* ami-c3e40daa | amazon/Windows-Server2008r1sp2-i386-Base-v103 ** bash.exe dumps core
* ami-d9e40db0 | amazon/Windows-Server2008r1sp2-x86_64-Base-v103 ** bash.exe and cmd.exe dumps core
* ami-f11ff098 | amazon/Windows-Server2003r2-i386-Base-v109 ** too bloody slow
* ami-f51ff09c | amazon/Windows-Server2003r2-x86_64-Base-v109

* NB both of the Win2008 ones above dump core while installing/running cygwin so we do not build by default
* reference CouchDB install is therefore Win2003r2 x86_64  ami-f51ff09c l1.large & snap-080bb263 for accompanying binaries
* reference CouchDB install is therefore Win2003r2 x86_i386  ami-f11ff098 c1.medium & snap-080bb263 for accompanying binaries

## Config of bundled W2008R1SP2 64b AMI

* attach a 30GiB EBS vol for storage of the bits
* logon, bring up an admin command prompt by right-clicking on any Command Prompt link and choosing "Run as Administrator"
* execute the following within that
* diskmgmt.msc -> find the newly attached volume & turn it online
* a fix for [SEHOP] security feature causing cygwin & similar unix shell emulations to dump core

        regedit d:\glazier\bundles\disable_sehop_kb956607.reg
        net user couchdb 1dot0 /add
        net localgroup administrators couchdb /add

* disable UAC -> control panel -> user accts -> turn UAC off -> restart later
* start menu -> server manager -> 2nd pane -> configure IE ESC
* disable [DEP] ->  bcdedit.exe /set {current} nx AlwaysOff

* restart now

********************************************************************************
# Appendices
********************************************************************************

## Licences

* the core tools & scripts used in glazier are released or included as BSD-style licence
* curl and the included openssl libraries are the only ones distributed with glazier
* the silent installation of each component assumes your implicit acceptance of the rest
* curl <http://curl.haxx.se/docs/copyright.html>
* openssl <http://www.openssl.org/source/license.html>

## sample environments on different windows platforms

### win7 std - default environment

    ALLUSERSPROFILE=C:\ProgramData
    APPDATA=C:\Users\couchdb\AppData\Roaming
    CLIENTNAME=continuity.muse
    CommonProgramFiles=C:\Program Files\Common Files
    CommonProgramFiles(x86)=C:\Program Files (x86)\Common Files
    CommonProgramW6432=C:\Program Files\Common Files
    COMPUTERNAME=BUILD
    ComSpec=C:\Windows\system32\cmd.exe
    FP_NO_HOST_CHECK=NO
    HOMEDRIVE=C:
    HOMEPATH=\Users\couchdb
    LOCALAPPDATA=C:\Users\couchdb\AppData\Local
    LOGONSERVER=\\BUILD
    NUMBER_OF_PROCESSORS=1
    OPENSSL_CONF=C:\OpenSSL\bin\openssl.cfg
    OS=Windows_NT
    Path=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\
    PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
    PROCESSOR_ARCHITECTURE=AMD64
    PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 15 Stepping 6, GenuineIntel
    PROCESSOR_LEVEL=6
    PROCESSOR_REVISION=0f06
    ProgramData=C:\ProgramData
    ProgramFiles=C:\Program Files
    ProgramFiles(x86)=C:\Program Files (x86)
    ProgramW6432=C:\Program Files
    PROMPT=$P$G
    PSModulePath=C:\Windows\system32\WindowsPowerShell\v1.0\Modules\
    PUBLIC=C:\Users\Public
    SESSIONNAME=RDP-Tcp#0
    SystemDrive=C:
    SystemRoot=C:\Windows
    TEMP=C:\Users\couchdb\AppData\Local\Temp
    TMP=C:\Users\couchdb\AppData\Local\Temp
    USERDOMAIN=BUILD
    USERNAME=couchdb
    USERPROFILE=C:\Users\couchdb
    VS90COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\
    windir=C:\Windows

### win7 std - vs2008 environment
    ALLUSERSPROFILE=C:\ProgramData
    APPDATA=C:\Users\couchdb\AppData\Roaming
    CLIENTNAME=continuity.muse
    CommonProgramFiles=C:\Program Files\Common Files
    CommonProgramFiles(x86)=C:\Program Files (x86)\Common Files
    CommonProgramW6432=C:\Program Files\Common Files
    COMPUTERNAME=BUILD
    ComSpec=C:\Windows\system32\cmd.exe
    DevEnvDir=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE
    FP_NO_HOST_CHECK=NO
    FrameworkDir=C:\Windows\Microsoft.NET\Framework
    FrameworkVersion=v2.0.50727
    HOMEDRIVE=C:
    HOMEPATH=\Users\couchdb
    INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\INCLUDE;C:\Program Files\Microsoft SDKs\Windows\v6.0A\include;
    LIB=C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\ATLMFC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\LIB;C:\Program Files\Microsoft SDKs\Windows\v6.0A\lib;
    LIBPATH=C:\Windows\Microsoft.NET\Framework\;C:\Windows\Microsoft.NET\Framework\v2.0.50727;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\ATLMFC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\LIB;
    LOCALAPPDATA=C:\Users\couchdb\AppData\Local
    LOGONSERVER=\\BUILD
    NUMBER_OF_PROCESSORS=1
    OPENSSL_CONF=C:\OpenSSL\bin\openssl.cfg
    OS=Windows_NT
    Path=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\BIN;C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools;C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\bin;C:\Windows\Microsoft.NET\Framework\;C:\Windows\Microsoft.NET\Framework\\Microsoft .NET Framework 3.5 (Pre-Release Version);C:\Windows\Microsoft.NET\Framework\v2.0.50727;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\VCPackages;C:\Program Files\Microsoft SDKs\Windows\v6.0A\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\
    PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
    PROCESSOR_ARCHITECTURE=AMD64
    PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 15 Stepping 6, GenuineIntel
    PROCESSOR_LEVEL=6
    PROCESSOR_REVISION=0f06
    ProgramData=C:\ProgramData
    ProgramFiles=C:\Program Files
    ProgramFiles(x86)=C:\Program Files (x86)
    ProgramW6432=C:\Program Files
    PROMPT=$P$G
    PSModulePath=C:\Windows\system32\WindowsPowerShell\v1.0\Modules\
    PUBLIC=C:\Users\Public
    SESSIONNAME=RDP-Tcp#0
    SystemDrive=C:
    SystemRoot=C:\Windows
    TEMP=C:\Users\couchdb\AppData\Local\Temp
    TMP=C:\Users\couchdb\AppData\Local\Temp
    USERDOMAIN=BUILD
    USERNAME=couchdb
    USERPROFILE=C:\Users\couchdb
    VCINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC
    VS90COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools\
    VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 9.0
    windir=C:\Windows
    WindowsSdkDir=C:\Program Files\Microsoft SDKs\Windows\v6.0A\


### a perfect path for erlang R13B04 after eval `./otp_build env_win32`

    export PATH=$ERL_TOP/release/win32/erts-5.7.5/bin:\
    $ERL_TOP/erts/etc/win32/cygwin_tools/vc:\
    $ERL_TOP/erts/etc/win32/cygwin_tools:\
    /cygdrive/c/PROGRA~1/MICROS~1.0/Common7/IDE:\
    /cygdrive/c/PROGRA~1/MICROS~1.0/VC/BIN:\
    /cygdrive/c/PROGRA~1/MICROS~1.0/Common7/Tools:\
    /cygdrive/c/WINDOWS/MICROS~1.NET/FRAMEW~1/:\
    /cygdrive/c/WINDOWS/MICROS~1.NET/FRAMEW~1/V20~1.507:\
    /cygdrive/c/PROGRA~1/MICROS~1.0/VC/VCPACK~1:\
    /cygdrive/c/PROGRA~1/MICROS~3/Windows/v7.0/bin:\
    /src/openssl:\
    /src/nsis:\
    /src/inno5:\
    /usr/local/bin:\
    /usr/bin:\
    /bin:\
    /cygdrive/c/WINDOWS/system32:\
    /cygdrive/c/WINDOWS:\
    /cygdrive/c/WINDOWS/System32/Wbem

    export ERL_TOP=/src/otp_src_R13B04
    export PATH=$ERL_TOP/release/win32/erts-5.7.5/bin:$ERL_TOP/erts/etc/win32/cygwin_tools/vc:$ERL_TOP/erts/etc/win32/cygwin_tools:/cygdrive/c/PROGRA~1/MICROS~1.0/Common7/IDE:/cygdrive/c/PROGRA~1/MICROS~1.0/VC/BIN:/cygdrive/c/PROGRA~1/MICROS~1.0/Common7/Tools:/cygdrive/c/WINDOWS/MICROS~1.NET/FRAMEW~1/:/cygdrive/c/WINDOWS/MICROS~1.NET/FRAMEW~1/V20~1.507:/cygdrive/c/PROGRA~1/MICROS~1.0/VC/VCPACK~1:/cygdrive/c/PROGRA~1/MICROS~3/Windows/v7.0/bin:/src/openssl:/src/nsis:/src/inno5:/usr/local/bin:/usr/bin:/bin:/cygdrive/c/WINDOWS/system32:/cygdrive/c/WINDOWS:/cygdrive/c/WINDOWS/System32/Wbem

    export ERL_TOP=/src/otp_src_R14A
    EXPORT PATH=$ERL_TOP/release/win32/erts-5.8/bin:$ERL_TOP/erts/etc/win32/cygwin_tools/vc:$ERL_TOP/erts/etc/win32/cygwin_tools:/cygdrive/c/PROGRA~1/MICROS~1.0/Common7/IDE:/cygdrive/c/PROGRA~1/MICROS~1.0/VC/BIN:/cygdrive/c/PROGRA~1/MICROS~1.0/Common7/Tools:/cygdrive/c/WINDOWS/MICROS~1.NET/FRAMEW~1/:/cygdrive/c/WINDOWS/MICROS~1.NET/FRAMEW~1/V20~1.507:/cygdrive/c/PROGRA~1/MICROS~1.0/VC/VCPACK~1:/cygdrive/c/PROGRA~1/MICROS~3/Windows/v7.0/bin:/src/openssl:/src/nsis:/src/inno5:/usr/local/bin:/usr/bin:/bin:/cygdrive/c/WINDOWS/system32:/cygdrive/c/WINDOWS:/cygdrive/c/WINDOWS/System32/Wbem

## Download URLs - visible only in raw text view

[7zip_bits]:		http://downloads.sourceforge.net/sevenzip/7z465.exe
[7zip_license]:		http://www.7-zip.org/license.txt
[AWS console]:		https://console.aws.amazon.com/ec2/home#c=EC2&s=Instances
[AWS Windows Servers]:	http://developer.amazonwebservices.com/connect/kbcategory.jspa?categoryID=201
[bitvise_sshd_bits]:	http://dl.bitvise.com/WinSSHD5-Inst.exe
[curl]:			http://curl.haxx.se/download.html
[curl_license]:		http://curl.haxx.se/docs/copyright.html
[cygwin]:		http://www.cygwin.com/setup.exe
[DEP]:			http://support.microsoft.com/kb/875352
[erlang_R13B04]:	http://www.erlang.org/download/otp_src_R13B04.tar.gz
[erlang_R14A]:		http://www.erlang.org/download/otp_src_R14A.tar.gz
[icu_bits_curr]:	http://download.icu-project.org/files/icu4c/4.2/icu4c-4_2-Win32-msvc9.zip
[icu_bits_new]:		http://download.icu-project.org/files/icu4c/4.4.1/icu4c-4_4_1-Win32-msvc9.zip
[inno_bits]:		http://www.jrsoftware.org/download.php/is-unicode.exe
[inno_help]:		http://www.jrsoftware.org/ishelp/
[libcurl_bits]:		http://curl.haxx.se/download/libcurl-7.19.3-win32-ssl-msvc.zip
[libcurl_src]:		http://curl.haxx.se/download/curl-7.21.1.tar.gz
[msvc++]:		http://download.microsoft.com/download/E/8/E/E8EEB394-7F42-4963-A2D8-29559B738298/VS2008ExpressWithSP1ENUX1504728.iso
[vsmc++webstart]:	http://download.microsoft.com/download/A/5/4/A54BADB6-9C3F-478D-8657-93B3FC9FE62D/vcsetup.exe
[mozbuild]:		http://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/MozillaBuildSetup-Latest.exe
[notepadplus_bits]:	http://download.sourceforge.net/project/notepad-plus/notepad%2B%2B%20releases%20binary/npp%205.7%20bin/npp.5.7.Installer.exe
[nsis_bits]:		http://download.sourceforge.net/project/nsis/NSIS%202/2.46/nsis-2.46-setup.exe
[openssl_bits]:		http://www.slproweb.com/download/Win32OpenSSL-1_0_0a.exe
[openssl_license]:	http://www.openssl.org/source/license.html
[ramdisk]:		http://www.ltr-data.se/files/imdiskinst.exe
[seamonkey_bits]:	http://releases.mozilla.org/pub/mozilla.org/seamonkey/releases/2.0.6/source/seamonkey-2.0.6.source.tar.bz2
[SEHOP]:		http://support.microsoft.com/kb/956607
[vcredist]:		http://download.microsoft.com/download/d/d/9/dd9a82d0-52ef-40db-8dab-795376989c03/vcredist_x86.exe
[win7sdk_32bit]:	http://download.microsoft.com/download/2/E/9/2E911956-F90F-4BFB-8231-E292A7B6F287/GRMSDK_EN_DVD.iso
[win7sdk_64bit]:	http://download.microsoft.com/download/2/E/9/2E911956-F90F-4BFB-8231-E292A7B6F287/GRMSDKX_EN_DVD.iso
[wxwidgets_bits]:	http://sourceforge.net/projects/wxwindows/files/2.8.11/wxMSW-2.8.11.zip
[zlib-bits]:		http://zlib.net/zlib125-dll.zip
[zlib-src]:		http://zlib.net/zlib-1.2.5.tar.gz

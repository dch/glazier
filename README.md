********************************************************************************
#Glazier - automating building CouchDB on Windows
********************************************************************************

Glazier is a set of scripts designed to help automate as much as practicable the build of CouchDB on Windows, from XP/2003 to Windows 7 or Server 2008.

## Current State

* scripts don't yet produce a working CouchDB
* installation of development environment is described but not automated
* the build environment should be fully functional on both 32,64, desktop and server versions of windows from XP/2003 onwards
* [get_compilers.cmd](http://github.com/dch/glazier/blob/master/bin/get_compilers.cmd) retrieves approx 6GiB of DVD ISOs for Microsoft's Visual Studio 2008 compiler, related SDKs and the smaller cygwin and mozilla build frameworks
* [get_bits.cmd](http://github.com/dch/glazier/blob/master/bin/get_bits.cmd) retrieves source for erlang, couchdb, curl, 

# Build Environment
* Building Erlang & CouchDB on Windows requires a custom build environment, which is very sensitive to path order amongst the three different compilers used to build wxWidgets, erlang, javascript, and couchdb
* This is further complicated by different install locations on 32 vs 64 bit windows versions, and which Microsoft C compiler and Windows SDKs are installed.
* To simplify this we use symlinks liberally

		mkdir c:\src
		setx SRC=c:\src

## Microsoft Visual C++
* Erlang and CouchDB can be built using the free VS2008 Express C++ edition from [MSDN](http://msdn.microsoft.com/en-gb/vstudio/)
* install using the DVD ISO [msvc++] excluding optional MSSSQL & Silverlight

## Cygwin
The full Cygwin install comprises several GiB of data. Run [cygwin]'s setup.exe using defaults with the following additional modules:

* accessibility, admin, archive, audio, base, database: default
* devel: ALL
		autoconf, automake, gcc-, gcc4, openssl-devel, readline
* doc: default
* editors: vim
* games, gnome, graphics, interpreters, KDE, libs,  mail, math, mingw, net, perl, publishing, python, security, shells, system, text, utils, web, X11: default

		ln -s /cygdrive/c/src /src

## WXWIDGETS
* download [wxwidgets_bits] from [WxWidgets website](http://wxwidgets.org/) & untar using cygwin into /src/

		mkdir -p /opt/local/pgm/
		ln -s /src/wxWidgets-2.8.11 /opt/local/pgm/wxWidgets-2.8.11

* Enable wxUSE\_GLCANVAS, wxUSE\_POSTSCRIPT and wxUSE\_GRAPHICS_CONTEXT in c:\src\wxWidgets-2.8.11\include\wx\msw\setup.h

### wx.dsw
* open & convert C:\src\wxWidgets-2.8.11\build\msw\wx.dsw to C:\src\wxWidgets-2.8.11\build\msw\wx.sln
* if you have a multicore process you can do a batch build
* set up the dependencies for wx.dsw to achieve the below build order
jpeg, png, tiff, zlib, regex, expat, base, net, odbc, core,
 gl, html, media, qa, adv, dbgrid, xrc, aui, richtext, xml
* Build all unicode release (and unicode debug) packages via build -> batch build

TODO: can we do this somehow from prompt e.g. vcbuild /rebuild contrib\vstudio\vc9\zlibvc.sln "Release|Win32"
	
### stc.dsw
* open & convert C:\src\wxWidgets-2.8.11\contrib\build\stc\stc.dsw to C:\src\wxWidgets-2.8.11\contrib\build\stc\stc.sln
*  right-click on stc in solution explorer pane (not "Solution 'stc' at the top of the tree)
* Under the C/C++ -> General tree, make sure add the following include directories:

        ..\..\..\include
        ..\..\..\lib\vc_lib\mswd

* Under Librarian -> General add additional library directories:

        ..\..\..\lib\vc_lib

* Build all unicode release (and unicode debug) packages via build -> batch build

TODO: can we do this somehow from prompt e.g. vcbuild /rebuild contrib\vstudio\vc9\zlibvc.sln "Release|Win32"

### Reference URLs
* [WxWidgets Source](http://svn.wxwidgets.org/svn/wx/wxWidgets/branches/WX_2_8_BRANCH/docs/msw/install.txt)
* [MSVC++ WxWidgets](http://wiki.wxwidgets.org/Microsoft_Visual_C%2B%2B_Guide)
* [WxWidgets compilation advice](http://rhyous.com/2009/12/16/how-to-compile-a-wxwidgets-application-in-visual-studio-2008/)
* notes on building [Erlang](http://github.com/erlang/otp/blob/dev/INSTALL-WIN32.md)
* [wxWidgets](http://www.zerothlaw.org/joomla/index.php?option=com_jd-wiki&Itemid=26&id=wxwidgets:wxwidgets_with_visual_studio_express) guidance

## Building Erlang
* after installing VC++ 2008 Express, and most other Visual Studio solutions, `call "%vs90comntools%\..\..\vc\vcvarsall.bat" x86
` will automatically find the correct path, and set up our 32-bit build environment correctly, independently if you have installed on 32 or 64bit windows. Alternatively you can run "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" on 64bit systems, or "C:\Program Files\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" on 32bit systems
* then run
	c:\glazier\bin\relax.cmd
* download R13B04 or R14A from http://www.erlang.org/download/
* under cygwin cd /src and untar


## Tk/Tcl
* optional component

		cd $ERL_TOP && tar xvzf /src/bits/tcltk85_win32_bin.tar.gz

* or skip the whole damn lot this way

		echo "skipping gs" > lib/gs/SKIP

## Setup Erlang Environment and Tools
* Now we setup the environment to use our symlinked tools
* install OpenSSL, NSIS installer,
    
	    ln -s /cygdrive/c/OpenSSL/ /src/openssl
	    ln -s /cygdrive/c/Program\ Files\ \(x86\)/NSIS /src/nsis
	    
* sanity check against [http://github.com/erlang/otp/blob/dev/INSTALL-WIN32.md]()

* start `c:\glazier\relax.cmd`
* check that `which cl; which link; which mc` return the MS ones, if not then sort them manually
* build Erlang using `/src/glazier/bin/erl_config.sh` and `/src/glazier/bin/erl_build.sh`, or manually as follows

		./otp_build autoconf
		./otp_build configure
		./otp_build boot -a
		./otp_build release -a
		./otp_build installer_win32
		# to setup erlang to run from this new source build immediately run:
		./release/win32/Install.exe -s

# CouchDB
minimum requirements

* Erlang OTP R13B04 or R14A
* ICU 4.2 only                      (http://icu.sourceforge.net/)
* OpenSSL  1.0.0a               (http://www.openssl.org/)
* Mozilla SpiderMonkey 1.8 from SeaMonkey 2.0.6
* libcurl 7.21.1                    (http://curl.haxx.se/libcurl/)

## Javascript

### SpiderMonkey
useful links
http://releases.mozilla.org/pub/mozilla.org/seamonkey/releases/2.0.6/source/seamonkey-2.0.6.source.tar.bz2
https://developer.mozilla.org/En/Developer_Guide/Build_Instructions/Windows_Prerequisites
https://developer.mozilla.org/En/SpiderMonkey/Build_Documentation

* pre-reqs
* install the windows 7 SDK
* install VS2008 Express
* SpiderMonkey is a red herring you need mozilla seamonkey instead unless you can build spidermonkey > 1.8.x from source which I can't
* instead, download SeaMonkey 2.0.6 source and use this to build javascript
* install the moz build system from here
* get [mozbuild]
* there are a few junction.exe reqd - d:/mozilla-build to c:/mozilla-build
* get [seamonkey_bits] and unpack into c:\src\seamonkey\comm-1.9.1\mozilla\js\src
* run c:\mozilla-build\start-msvc9.bat

		cd /c/src/seamonkey/comm-1.9.1/mozilla/js/src
		autoconf-2.13
		./configure
		make

* to install from -current do:
		cd /d/src/seamonkey-current
		hg clone http://hg.mozilla.org/mozilla-central
		cd mozilla-central/ .... /js/src
		autoconf-2.13
		./configure
		make 

## Inno Installer
from http://www.jrsoftware.org/download.php/ispack-unicode.exe
download and install ispack-5.3.10-unicode.exe, including all additional components
to c:\src\inno5 & ensure its in the path

## LibCURL
* you need to have libcurl.lib in the ./configure path (CURL_LIBS="$withval/lib/libcurl")
* most downloadable libcurls have sasl or other unwanted libs
* we need this for couch_js.exe to function
* and for curl for enduser testing
* untar http://curl.haxx.se/docs/install.html
		
		set OPENSSL_PATH=d:\src\openssl
		set INCLUDE=%INCLUDE%;%OPENSSL_PATH%\include\openssl;
		set LIBPATH=%LIBPATH%;%OPENSSL_PATH%\lib;
		set LIB=%LIB%;%OPENSSL_PATH%\lib;
		nmake vc-ssl
		couldn't get this to work so instead i built curl/vc6curl.sln
		check curl.exe & see what libs it needs - these should be openssl only
		check that /src/curl-7.21.1/lib/libcurl.lib exists

## OpenSSL

* already installed into C:/OpenSSL/ for compilation
		ln -s /cygdrive/c/OpenSSL /src/openssl
## ICU
* binaries from http://site.icu-project.org/
		wget http://download.icu-project.org/files/icu4c/4.4.1/icu4c-4_4_1-Win32-msvc9.zip
		wget http://download.icu-project.org/files/icu4c/4.2/icu4c-4_2-Win32-msvc9.zip
		cd src
		unzip icu4c-4_2-Win32-msvc9.zip

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
		--with-win32-icu-binaries=/src/icu \
		--with-erlang=$ERL_TOP/release/win32/usr/include \
		--with-win32-curl=/src/curl-7.19.5 \
		--with-openssl-bin-dir=/src/openssl/bin \
		--with-msvc-redist-dir=/src/vcredist \
		--with-js-lib=/src/mozilla/js/src \
		--with-js-include=/src/mozilla/js/src/dist/include/js



CURL
[curl] -> win32-openssl [curl-bits]

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
        net user administrator couchdb1.0.0
        net user couchdb 1dot0 /add
        net localgroup administrators couchdb /add

* disable UAC -> control panel -> user accts -> turn UAC off -> restart later
* start menu -> server manager -> 2nd pane -> configure IE ESC
* disable [DEP] ->  bcdedit.exe /set {current} nx AlwaysOff

* restart now

* administrator passwd is _couchdb1.0.0_
* lgoon as _couchdb_ with passwd _couchdb1dot0_
* import console_hkcu.reg
* import 

* open up d:\glazier\bin & copy all .lnk files to desktop
* install VC++ excluding silverlight, MSSQL, RSS feeds via D:\VS2008express_SP1_ENUX1504728\VCExpress\setup.exe
* run D:\Windows7_SDK_amd64\Setup.exe and install all components (64bit)
* run D:\Windows7_SDK_x86\Setup.exe and install all components (32bit)
* visit http://www.update.microsoft.com/microsoftupdate/v6/vistadefault.aspx?ln=en-us & install all updates/patches
* open d:\src\bundles in explorer & run everything below
* install mozilla tools d:\src\bundles\mozillabuildsetup-latest.exe
* install npp
* install inno5 via ispack including all additional packages
* install nsis
* install vcredist_x86
* install openssl & binaries to openssl dir, ignore warnings about vcredist
* install cygwin from local only (no download) selecting all modules to install. This is a limited set compared to full cygwin and saves about 1GiB of download crud + lost install time	

## Build
* open wxwidgets /build/msw/wx.sln, select batch build, all unicode modules
* ditto for contrib/build/stc/stc.sln, select batch build, all unicode modules

# Notes, Links and URLs (source view only)
## Cygwin on EC2 Windows 2008 64 bit R1SP2
* plenty of internet info about failures with no current solution
* turn on XP or vista compatibility mode
* try running from a SYSWOW64 cmd.exe instead of usual one

[7zip_bits]: http://voxel.dl.sourceforge.net/project/sevenzip/7-Zip/4.65/7za465.zip
[AWS Windows Servers]: http://developer.amazonwebservices.com/connect/kbcategory.jspa?categoryID=201
[AWS console]: https://console.aws.amazon.com/ec2/home#c=EC2&s=Instances
[DEP]: http://support.microsoft.com/kb/875352
[SEHOP]: http://support.microsoft.com/kb/956607
[bitvise_sshd_bits]: http://dl.bitvise.com/WinSSHD5-Inst.exe
[curl-bits]: http://curl.haxx.se/download/curl-7.19.5-win32-ssl.zip
[curl]: http://curl.haxx.se/download.html
[cygwin]: http://www.cygwin.com/setup.exe
[erlang_R13B04]: http://www.erlang.org/download/otp_src_R13B04.tar.gz
[erlang_R14A]: http://www.erlang.org/download/otp_src_R14A.tar.gz
[icu_bits_curr]: http://download.icu-project.org/files/icu4c/4.2/icu4c-4_2-Win32-msvc9.zip
[icu_bits_new]: http://download.icu-project.org/files/icu4c/4.4.1/icu4c-4_4_1-Win32-msvc9.zip
[inno_bits]: http://www.jrsoftware.org/download.php/ispack-unicode.exe
[libcurl-bits] http://curl.haxx.se/download/libcurl-7.19.3-win32-ssl-msvc.zip
[libcurl-src]: http://curl.haxx.se/download/curl-7.21.1.tar.gz
[msvc++]: http://download.microsoft.com/download/E/8/E/E8EEB394-7F42-4963-A2D8-29559B738298/VS2008ExpressWithSP1ENUX1504728.iso
[notepadplus_bits]: http://voxel.dl.sourceforge.net/project/notepad-plus/notepad%2B%2B%20releases%20binary/npp%205.7%20bin/npp.5.7.Installer.exe
[nsis_bits]: http://voxel.dl.sourceforge.net/project/nsis/NSIS%202/2.46/nsis-2.46-setup.exe
[openssl_bits]: http://www.slproweb.com/download/Win32OpenSSL-1_0_0a.exe
[ramdisk]: http://www.ltr-data.se/files/imdiskinst.exe
[seamonkey_bits]: http://releases.mozilla.org/pub/mozilla.org/seamonkey/releases/2.0.6/source/seamonkey-2.0.6.source.tar.bz2
[vcredist]: http://download.microsoft.com/download/d/1/0/d10d210e-e0ad-4010-b547-bc5e395ef691/vcredist_x86.exe
[win7sdk_32bit]: http://download.microsoft.com/download/2/E/9/2E911956-F90F-4BFB-8231-E292A7B6F287/GRMSDK_EN_DVD.iso
[win7sdk_64bit]: http://download.microsoft.com/download/2/E/9/2E911956-F90F-4BFB-8231-E292A7B6F287/GRMSDKX_EN_DVD.iso
[wxwidgets_bits]: http://voxel.dl.sourceforge.net/project/wxwindows/2.8.11/wxMSW-2.8.11-Setup.exe
[zlib-bits]: http://zlib.net/zlib125-dll.zip
[zlib-src]: http://zlib.net/zlib-1.2.5.tar.gz

================================================================================
win7 std - default environment

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


================================================================================
win7 std - vs2008 environment
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

================================================================================
perfect path

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

dIRTY NOTES
================================================================================
fix missing path for disable alsr & run all .reg from local c: partition. try regini instead.
after logoff goto eof

i think all we really need (via snapshotted volume) is:

start /wait D:\VS2008express_SP1_ENUX1504728\VCExpress\setup.exe
start /wait D:\Windows7_SDK\Setup.exe
setx CYGWIN nontsec

and then to ensure that you can still compile javascript from source;
junction c:\mozilla-build d:\mozilla-build

echo vcredist and windows updates
pause
start /wait vcredist_x86.exe /q
start /wait http://update.microsoft.com/microsoftupdate/v6

& then final reboot of happiness


# erlang
* figure out how to resolve openssl hack can we do this by soft link on d: or does it need a copy to c: ?
	ln -s /src/openssl /cygdrive/c/openssl
* repair all icons
* simple startup notes - vcvars then cygwin.bat then cd /src/otp... then eval `./otp_build env_win32`

export PATH=$ERL_TOP/release/win32/erts-5.7.5/bin:$ERL_TOP/erts/etc/win32/cygwin_tools/vc:$ERL_TOP/erts/etc/win32/cygwin_tools:/cygdrive/c/PROGRA~1/MICROS~1.0/Common7/IDE:/cygdrive/c/PROGRA~1/MICROS~1.0/VC/BIN:/cygdrive/c/PROGRA~1/MICROS~1.0/Common7/Tools:/cygdrive/c/WINDOWS/MICROS~1.NET/FRAMEW~1/:/cygdrive/c/WINDOWS/MICROS~1.NET/FRAMEW~1/V20~1.507:/cygdrive/c/PROGRA~1/MICROS~1.0/VC/VCPACK~1:/cygdrive/c/PROGRA~1/MICROS~3/Windows/v7.0/bin:/src/openssl:/src/nsis:/src/inno5:/usr/local/bin:/usr/bin:/bin:/cygdrive/c/WINDOWS/system32:/cygdrive/c/WINDOWS:/cygdrive/c/WINDOWS/System32/Wbem

* check path esp cl,mc,link which seems to be wrong & then get going
./otp_build all -a; ./otp_build install_win32

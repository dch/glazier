## Javascript
################################################################################
The Javascript engine used by CouchDB is Mozilla Spidermonkey. Prior to 1.8.5
[js185] there was no formal release for it, so you can build from anywhere on
trunk. The 1.8.x source below [js18x] is also used on the Mac OS X homebrew
build of CouchDB.

* to build and install SpiderMonkey we use the mozilla tools chain.
* run `c:\mozilla-build\start-msvc9.bat` even if you are on a 64-bit platform.
* do a sanity check to confirm the MS build compilers are present via
 `which cl link mc lc mt`
* you may need to fudge the path if `cl.exe` can't be found using `PATH=$PATH:/c/relax/VC/VC/bin/:/c/relax/SDK/bin:/c/relax/VC/Common7/IDE:/c/relax/VC/VC/bin/amd64/:/c/relax/VC/VC/bin/x86_ia64/`

* to build Spidermonkey JS 1.8.x [js18x]
 
        cd /c/relax
        tar xzf bits/57a6ad20eae9.tar.gz
        cd ./tracemonkey-57a6ad20eae9/js/src
        autoconf-2.13
        export CXXFLAGS='-D_BIND_TO_CURRENT_VCLIBS_VERSION=1'
        ./configure --enable-static --enable-shared-js
        make


* alternatively to build Spidermonkey JS 1.8.5 [js185]

        cd /c/relax
        tar xzf bits/js185-1.0.0.tar.gz
        cd ./js-1.8.5/js/src
        autoconf-2.13
        export CXXFLAGS='-D_BIND_TO_CURRENT_VCLIBS_VERSION=1'
        ./configure --enable-static --enable-shared-js
        make

The CouchDB configure script is used later on to select which version of
Spidermonkey is used.

[js185]: http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz
[js18x]: http://hg.mozilla.org/tracemonkey/archive/57a6ad20eae9.tar.gz

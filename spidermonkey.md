## Javascript
################################################################################
The Javascript engine used by CouchDB is Mozilla Spidermonkey. As there is no
formal release for it, you can build from anywhere on trunk. The 1.8.x source
below is also used on the Mac OS X homebrew build of CouchDB.

* to build and install from [SpiderMonkey] we use the mozilla tools chain.
* run `c:\mozilla-build\start-msvc9.bat` even if you are on a 64-bit platform.
* you may need to fudge the path if `cl.exe` can't be found

        cd /c/relax
        tar xzf bits/57a6ad20eae9.tar.gz
        cd ./tracemonkey-57a6ad20eae9/js/src
        autoconf-2.13
        export CXXFLAGS='-D_BIND_TO_CURRENT_VCLIBS_VERSION=1'
        ./configure --enable-static --enable-shared-js
        make

[spidermonkey]:	http://hg.mozilla.org/tracemonkey/archive/57a6ad20eae9.tar.gz

* to build and install from SpiderMonkey JS 1.8.5 [js185]
* run `c:\mozilla-build\start-msvc9.bat` even if you are on a 64-bit platform.

        cd /c/relax
        tar xzf bits/js185-1.0.0.tar.gz
        cd ./js-1.8.5/js/src
        autoconf-2.13
        export CXXFLAGS='-D_BIND_TO_CURRENT_VCLIBS_VERSION=1'
        ./configure --enable-static --enable-shared-js
        make

[js185]:	http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz


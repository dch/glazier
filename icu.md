## ICU 4.4.2
################################################################################
Ideally ICU would compile with current VC runtime using VC++ directly but
it doesn't. Instead we use cygwin make tools and VC++ compiler.

* download ICU 4.4.2 unix source from [icu442]
* open a Windows SDK prompt via `setenv /release /x86`

    set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
    call \cygwin\bin\bash.exe
    export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin

    cd $RELAX
    DEST=`pwd`/icu
    tar xzf bits/icu4c-4_4_2-src.tgz
    cd $DEST/source
    ./runConfigureICU Cygwin/MSVC --prefix=$DEST
    make
    make install
    cp $DEST/lib/*.dll $DEST/bin/

* the last line is because CouchDB still looks in icu/bin/ for the DLLs even though the build puts them
 in icu/lib/. This should probably be changed in CouchDB
* confirm that the resulting ICU DLLs have the appropriate manifests

[icu442]: http://download.icu-project.org/files/icu4c/4.4.2/icu4c-4_4_2-src.tgz

# Building Erlang #############################################################

* start an SDK shell via `setenv.cmd /Release /x86`
* start a new cygwin shell via `c:\relax\bin\shell.cmd`
* in a cygwin shell:

        cd /relax && tar xzf /relax/bits/otp_src_R14B04.tar.gz &

* include optional components - used for debugger and java interfaces

        cd $ERL_TOP && tar xvzf /relax/bits/tcltk85_win32_bin.tar.gz

* skip other non-essential components as follows:

        echo "skipping gs" > lib/gs/SKIP
        echo "skipping jinterface" > lib/jinterface/SKIP

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

* Build Erlang using `/relax/bin/erl_config.sh`
  and `/relax/bin/erl_build.sh`, or manually as follows

        eval `./otp_build env_win32`
        ./otp_build autoconf
        ./otp_build configure
        ./otp_build boot -a
        ./otp_build release -a
        ./otp_build installer_win32
        # we need to set up erlang to run from this new source build to build CouchDB
        ./release/win32/Install.exe -s

* More details are at [erlang INSTALL-Win32.md on github](http://github.com/erlang/otp/blob/dev/INSTALL-WIN32.md)

* or using the relax tools, starting an SDK shell via `setenv.cmd /Release /x86`:
        start `c:\relax\bin\shell.cmd`
        :: [select an erlang build]
        erl_config.sh && erl_build.sh

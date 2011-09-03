
## LibCURL ####################################################################

* Extract from cygwin shell if not already done

::        cd /relax && tar xf /relax/bits/curl-7*

* run from a Visual Studio command shell:

        path=%path%;%relax%\cmake\bin;%relax%\7zip;%relax%\openssl\bin;
        if exist %relax%\curl rd /s/q %relax%\curl
        pushd %relax%\curl-7*
        
        :: settings for Compiler
        set SSL_PATH=%relax%\openssl
        set USE_SSLEAY=1
        set USE_OPENSSL=1
        set INCLUDE=%INCLUDE%;%SSL_PATH%\include;%SSL_PATH%\include\openssl;
        set LIBPATH=%LIBPATH%;%SSL_PATH%\lib;
        set LIB=%LIB%;%SSL_PATH%\lib;

        :: settings for CMake
        set build=c:\relax\curl\build
        set install=c:\relax\curl
        set source=c:\relax\curl-7.21.7
        set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1

        cmake -G "NMake Makefiles" -D CMAKE_BUILD_TYPE=Release -D BUILD_CURL_TESTS=No -D CURL_STATICLIB=Yes -D CURL_ZLIB=No  -D CMAKE_INSTALL_PREFIX="%install%" -H"%source%" -B"%build%"
        cmake --build %build% --target install
        popd
        dir /b %install%\bin %install%\lib

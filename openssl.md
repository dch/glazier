## OpenSSL
################################################################################
Erlang requires finding OpenSSL in `c:\OpenSSL` so that's where we build to,
using mount point to keep things clean=ish.

* [OpenSSL] source has already been downloaded
* start an SDK shell via 'setenv.cmd /Release /x86'
* run `c:\relax\bin\build_openssl.cmd` to extract and build OpenSSL
* it requires nasm, 7zip, strawberry perl all in the path
* check for errors
* ensure Erlang can locate SSL with `mklink /d c:\OpenSSL %relax%\OpenSSL`

[OpenSSL]: http://www.openssl.org/source/openssl-1.0.0d.tar.gz

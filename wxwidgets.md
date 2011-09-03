## wxWidgets

* [wxWidgets] source and the glazier [overlay] are already downloaded
* start an SDK shell via `setenv.cmd /Release /x86`
* run `c:\relax\bin\build_wx.cmd` to extract and build wxWidgets
* NB Erlang build requires wxWidgets in `/opt/local/pgm/wxWidgets-2.8.11` so
  we set that up too
* check for errors

[wxwidgets]: http://sourceforge.net/projects/wxwindows/files/2.8.11/wxMSW-2.8.11.zip
[overlay]:   https://raw.github.com/dch/glazier/master/bits/wxMSW-2.8.11_erlang_overlay.zip

### Equivalent Manual Steps ####################################################

* Open a suitable editor (vi in the cygwin suite, or Notepad++ for windows users)
* Edit `c:\relax\wxMSW-2.8.11\include\wx\msw\setup.h` to enable
    `wxUSE_GLCANVAS, wxUSE_POSTSCRIPT` and `wxUSE_GRAPHICS_CONTEXT`

### wx.dsw #####################################################################

* open VC++ & the project `%RELAX%\wxMSW-2.8.11\build\msw\wx.dsw`,
    accepting the automatic conversion to the newer VC++ format and save
    as `%RELAX%\wxMSW-2.8.11\build\msw\wx.sln`
* right-click on the project, and set up the dependencies for wx.dsw to
    achieve the below build order:
`jpeg, png, tiff, zlib, regex, expat, base, net, odbc, core,
 gl, html, media, qa, adv, dbgrid, xrc, aui, richtext, xml`
* Launch a new prompt from somewhere like Start -> Programs -> Microsoft
    Visual C++ -> Visual Studio Tools -> VS2008 Cmd Prompt
* Then build all unicode release (and unicode debug) packages:

        pushd %RELAX%\wxMSW*\build\msw
        set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
        vcbuild /useenv  /platform:Win32 /M4 wx.sln "Unicode Release|Win32"
        vcbuild /useenv  /platform:Win32 /M4 wx.sln "Unicode Debug|Win32"
        popd

### stc.dsw ####################################################################

* open VC++ & convert `%RELAX%\wxMSW-2.8.11\contrib\build\stc\stc.dsw`
    to `%RELAX%\wxMSW-2.8.11\contrib\build\stc\stc.sln`

        pushd %RELAX%\wxMSW*\contrib\build\stc
        set CL=/D_BIND_TO_CURRENT_VCLIBS_VERSION=1
        vcbuild /useenv /platform:Win32 /M4 stc.sln "Unicode Release|Win32"
        vcbuild /useenv /platform:Win32 /M4 stc.sln "Unicode Debug|Win32"
        popd

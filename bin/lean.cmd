::@echo off
title Prepare to Relax.
:: this script should be run from within your preferred compilation environment
:: either vcvars32.bat x86 (for Visual Studio)
:: or setenv.cmd /Release /x86 (for Windows SDKs)
:: use erlc "+compressed" to squash beam files
erl -noinput -eval 'erlang:display(beam_lib:strip_release("."))' -s init stop

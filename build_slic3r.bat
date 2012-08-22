@echo off

set X2SW_PROJ_DIR="%~dp0"
if not defined PATH_TO_PERL_INSTALL set PATH_TO_PERL_INSTALL=D:\CitrusPerl
if not defined PATH_TO_CAVACONSOLE set PATH_TO_CAVACONSOLE="C:\Program Files\Cava Packager 2.0\bin"
rem if not defined PATH_TO_CYGWIN set PATH_TO_CYGWIN="C:\cygwin\bin"

if exist %PATH_TO_PERL_INSTALL%\bin\citrusvars.bat goto OK1
echo Unable to find Citrus Perl environment setup script!
goto FAILURE

:OK1
subst P: %PATH_TO_PERL_INSTALL%
if not errorlevel 1 goto OK2
echo Unable to substitute drive P: to the path to Citrus Perl install!
goto FAILURE

:OK2
subst S: %X2SW_PROJ_DIR%\.
if not errorlevel 1 goto OK3
echo Unable to substitute drive S: to the path to x2sw project!
goto FAILURE

:OK3
call %PATH_TO_PERL_INSTALL%\bin\citrusvars.bat
goto OK4

echo Starting the slick3r build sript.
cd %X2SW_PROJ_DIR%\slic3r
%PATH_TO_PERL_INSTALL%\bin\perl.exe build.pl

if not errorlevel 1 goto OK4
echo Slic3r build script has failed!
goto FAILURE

:OK4
echo Starting the excutable builder. %X2SW_PROJ_DIR%\slic3r_build
rem %PATH_TO_CAVACONSOLE%\cavaconsole -S -B --project S:\slic3r_build
%PATH_TO_CAVACONSOLE%\cavapackager
if not errorlevel 1 goto OK5
echo Cava packager build has failed!
goto FAILURE

:OK5


:FAILURE
subst P: /D > :NULL
subst S: /D > :NULL

@echo off

set X2SW_PROJ_DIR="%~dp0"
if not defined PATH_TO_PERL_INSTALL set PATH_TO_PERL_INSTALL=D:\CitrusPerl
if not defined PATH_TO_CAVACONSOLE set PATH_TO_CAVACONSOLE="C:\Program Files\Cava Packager 2.0\bin"
if not defined PATH_TO_PYTHON set PATH_TO_PYTHON=C:\Python27
if not defined PATH_TO_PYINSTALLER set PATH_TO_PYINSTALLER=D:\pyinstaller-2.0
if not defined PATH_TO_INNOSETUP set PATH_TO_INNOSETUP="C:\Program Files\Inno Setup 5"

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
echo Starting the slick3r build sript.
cd %X2SW_PROJ_DIR%\slic3r
%PATH_TO_PERL_INSTALL%\bin\perl.exe build.pl
if not errorlevel 1 goto OK4
echo Slic3r build script has failed!
goto FAILURE

:OK4
echo Starting the slic3r excutable builder. 
%PATH_TO_CAVACONSOLE%\cavaconsole -S -B --project S:\slic3r_win
if not errorlevel 1 goto OK5
echo Cava packager build has failed!
goto FAILURE

:OK5
echo Starting Pronterface build
cd %X2SW_PROJ_DIR%\x2sw_build
%PATH_TO_PYTHON%\python.exe compile.py
if not errorlevel 1 goto OK6
echo Compilation of the Python files has failed!
goto FAILURE

:OK6
echo Building x2sw binary distribution...
%PATH_TO_PYTHON%\python.exe %PATH_TO_PYINSTALLER%/pyinstaller.py ./x2sw.spec
if not errorlevel 1 goto OK7
echo Building the distribution package tree has failed!
goto FAILURE

:OK7
echo Building packages
IF not exists "%X2SW_PROJ_DIR%\out" mkdir "%X2SW_PROJ_DIR%\out"
IF exists "%X2SW_PROJ_DIR%\out\win" del /F /S /Q "%X2SW_PROJ_DIR%\out\win"
mkdir "%X2SW_PROJ_DIR%\out\win"
if not errorlevel 1 goto OK8
echo Unable to create output directory!
goto FAILURE

echo Adding submodule information to the version file
pushd "%X2SW_PROJ_DIR%"
git submodule >> x2sw_build\dist\version.txt
popd

:OK8
echo Binary distribution zip
pushd "%X2SW_PROJ_DIR%\x2sw_build\dist"
zip -r "%X2SW_PROJ_DIR%\out\win\x2sw.zip" x2swbin
if not errorlevel 1 goto OK9
popd 
echo Failed to create the package zip archive!
goto FAILURE

:OK9
echo Building installer
%PATH_TO_INNOSETUP%\iscc /Q /O"%X2SW_PROJ_DIR%\out\win" /F"x2sw_win" "%X2SW_PROJ_DIR%\installer\win\x2sw_installer.iss"
if not errorlevel 1 goto OK10
echo Failed to create the installer package!
goto FAILURE

:OK10
echo Done
goto eof

:FAILURE
echo The build has failed!
subst P: /D > :NULL
subst S: /D > :NULL

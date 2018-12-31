@echo off

set SKIP1=
set SKIP2=
set SKIP3=
set SKIP4=
set SKIP5=
set SKIP6=
set SKIP7=
set SKIP8=
set SKIP9=

set "X2SW_PROJ_DIR=%~dp0"
if not defined PATH_TO_PERL_INSTALL set PATH_TO_PERL_INSTALL=D:\CitrusPerl
if not defined PATH_TO_CAVACONSOLE set PATH_TO_CAVACONSOLE="C:\Program Files\Cava Packager 2.0\bin"
if not defined PATH_TO_PYTHON set PATH_TO_PYTHON=C:\Python27
if not defined PATH_TO_PYINSTALLER set PATH_TO_PYINSTALLER=D:\pyinstaller-2.0
if not defined PATH_TO_INNOSETUP set PATH_TO_INNOSETUP="C:\Program Files\Inno Setup 5"

FOR /F "tokens=1-9" %%a IN ("%*") DO (
set SKIP%%a=1
set SKIP%%b=1
set SKIP%%c=1
set SKIP%%d=1
set SKIP%%e=1
set SKIP%%f=1
set SKIP%%g=1
set SKIP%%h=1
set SKIP%%i=1
)

pushd %X2SW_PROJ_DIR%

:OK1
IF "%SKIP1%"=="1" goto OK2
subst P: /D > :NULL
subst P: %PATH_TO_PERL_INSTALL%
if not errorlevel 1 goto OK2
echo 1: Unable to substitute drive P: to the path to Citrus Perl install!
goto FAILURE

:OK2
IF "%SKIP2%"=="1" goto OK3
subst S: /D > :NULL
subst S: "%X2SW_PROJ_DIR%\."
if not errorlevel 1 goto OK3
echo 2: Unable to substitute drive S: to the path to x2sw project!
goto FAILURE

exit

:OK3
IF "%SKIP3%"=="1" goto OK4
echo Starting the slick3r build sript.
cd "%X2SW_PROJ_DIR%\slic3r"
%PATH_TO_PERL_INSTALL%\bin\perl.exe build.pl
if not errorlevel 1 goto OK4
echo 3: Slic3r build script has failed!
goto FAILURE

:OK4
IF "%SKIP4%"=="1" goto OK5
echo Starting the slic3r excutable builder. 
%PATH_TO_CAVACONSOLE%\cavaconsole -S -B --project S:\slic3r_win
if not errorlevel 1 goto OK5
echo 4: Cava packager build has failed!
goto FAILURE

:OK5
IF "%SKIP5%"=="1" goto OK6
echo Starting Pronterface build
cd "%X2SW_PROJ_DIR%
%PATH_TO_PYTHON%\python.exe setup.py build_ext --inplace
cd "%X2SW_PROJ_DIR%\x2sw_build"
if not errorlevel 1 goto OK5_CONT
echo 5: Compilation of the gcoder_line extension has failed!
goto FAILURE
:OK5_CONT
%PATH_TO_PYTHON%\python.exe compile.py
if not errorlevel 1 goto OK6
echo 5: Compilation of the Python files has failed!
goto FAILURE

:OK6
IF "%SKIP6%"=="1" goto OK7
echo Building x2sw binary distribution...
del /F /Q /S "%X2SW_PROJ_DIR%\x2sw_build\dist" > :NULL
%PATH_TO_PYTHON%\python.exe %PATH_TO_PYINSTALLER%/pyinstaller.py ./x2sw.spec
if not errorlevel 1 goto OK7
echo 6: Building the distribution package tree has failed!
goto FAILURE

echo Adding submodule information to the version file
pushd "%X2SW_PROJ_DIR%"
copy /Y .\x2sw\version.txt x2sw_build\dist\x2swbin\version.txt
git submodule >> x2sw_build\dist\x2swbin\version.txt
popd

:OK7
IF "%SKIP7%"=="1" goto OK8
echo Building packages
IF not exist "%X2SW_PROJ_DIR%\out" mkdir "%X2SW_PROJ_DIR%\out"
IF exist "%X2SW_PROJ_DIR%\out\win" rd /S /Q "%X2SW_PROJ_DIR%\out\win"
mkdir "%X2SW_PROJ_DIR%\out\win"
if not errorlevel 1 goto OK8
echo 7: Unable to create output directory!
goto FAILURE

:OK8
IF "%SKIP8%"=="1" goto OK9
echo Binary distribution zip
cd "%X2SW_PROJ_DIR%\x2sw_build\dist"
FOR /F "tokens=*" %%a IN (..\..\x2sw\version.txt) do set VER=%%a
zip -r "%X2SW_PROJ_DIR%\out\win\x2sw_%VER%.zip" x2swbin
if not errorlevel 1 goto OK9
echo 8: Failed to create the package zip archive!
goto FAILURE

:OK9
IF "%SKIP9%"=="1" goto OK10
echo Building installer
cd "%X2SW_PROJ_DIR%"
FOR /F "tokens=*" %%a IN (.\x2sw\version.txt) do set VER=%%a
%PATH_TO_INNOSETUP%\iscc /Q /O"%X2SW_PROJ_DIR%\out\win" /F"x2sw_win_%VER%" "%X2SW_PROJ_DIR%\installer\win\x2sw_installer.iss"
if not errorlevel 1 goto OK10
echo Failed to create the installer package!
goto FAILURE

:OK10
echo Done
popd
goto :eof

:FAILURE
echo The build has failed!
popd
subst P: /D > :NULL
subst S: /D > :NULL

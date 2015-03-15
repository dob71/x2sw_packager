#!/bin/bash

MY_CWD=`pwd`
X2SW_PROJ_DIR=$(dirname $(readlink -f $0))

if [ "$PATH_TO_PERL_INSTALL" == "" ]; then 
  PATH_TO_PERL_INSTALL=~/CitrusPerl
fi
. $PATH_TO_PERL_INSTALL/bin/citrusvars.sh

if [ "$PATH_TO_CAVACONSOLE" == "" ]; then
  PATH_TO_CAVACONSOLE=~/CavaPackager/bin
fi

if [ "$PATH_TO_PYINSTALLER" == "" ]; then
  PATH_TO_PYINSTALLER=/usr/local/bin/pyinstaller
  if [ -d "$PATH_TO_PYINSTALLER" ]; then
    PATH_TO_PYINSTALLER=/usr/local/bin/pyinstaller/pyinstaller.py
  fi
fi

# error handling
trap onexit 1 2 3 15 ERR
function onexit() {
    local exit_status=${1:-$?}
	rm -f /tmp/[SP]
	cd $MY_CWD
    echo Done, status $exit_status
    exit $exit_status
}

cd $X2SW_PROJ_DIR

# Step 1, set up a temp symlink to citrus perl (because cava uses abs paths)
if [[ ! $* =~ (^| )1($| ) ]]; then 
   echo "Creating symlink to: $PATH_TO_PERL_INSTALL"
   rm -f /tmp/P
   ln -s "$PATH_TO_PERL_INSTALL" /tmp/P
fi

# Step 2, set up a temp symlink to x2sw (because cava uses abs paths)
if [[ ! $* =~ (^| )2($| ) ]]; then 
   echo "Creating symlink to: $X2SW_PROJ_DIR"
   rm -f /tmp/S
   ln -s "$X2SW_PROJ_DIR" /tmp/S
fi

# Step 3, run slic3r build script
if [[ ! $* =~ (^| )3($| ) ]]; then 
   echo "Starting the slick3r build sript."
   cd "$X2SW_PROJ_DIR/slic3r"
   perl Build.PL
fi

# Step 4, build slic3r binary package
if [[ ! $* =~ (^| )4($| ) ]]; then 
   echo "Starting the slic3r binaries build."
   while [ 1 ]; do 
     if $PATH_TO_CAVACONSOLE/cavaconsole -S -B --project /tmp/S/slic3r_linux
     then
       break
     else
       echo "Cava packager has failed. Use GUI to fix the project file."
       echo "If this is the first run set scripts path to /tmp/S/slic3r"
       $PATH_TO_CAVACONSOLE/cavapackager --project /tmp/S/slic3r_linux
     fi
   done
fi

# Step 5, pre-compile python code
if [[ ! $* =~ (^| )5($| ) ]]; then 
   echo "Starting Pronterface build."
   cd "$X2SW_PROJ_DIR/x2sw"
   python setup.py build_ext --inplace
   cd "$X2SW_PROJ_DIR/x2sw_build"
   python compile.py
fi

# Step 6, buid the binary distribution file tree
if [[ ! $* =~ (^| )6($| ) ]]; then 
   echo "Building x2sw binary distribution."
   cd "$X2SW_PROJ_DIR/x2sw_build"
   [ -d ./dist/x2swbin ] && rm -Rf ./dist/x2swbin
   [ -d ./dist/x2sw ] && rm -Rf ./dist/x2sw
   "$PATH_TO_PYINSTALLER" ./x2sw.spec
   # new pyinstaller skips x2sw folder
   if [ -d ./dist/x2swbin ]; then
     mkdir -p ./dist/x2sw
     mv ./dist/x2swbin ./dist/x2sw/
   fi
   ln -s bin/slic3r ./dist/x2sw/x2swbin/slic3r/slic3r
fi

# Step 7, add Pango modules ang configuration files
if [[ ! $* =~ (^| )7($| ) ]]; then 
   echo "Adding Pango."
   cd "$X2SW_PROJ_DIR/x2sw_build/dist/x2sw/x2swbin"
   mkdir -p ./pango/modules
   echo "[Pango]" > ./pango/pangorc
   echo "ModuleFiles = ./pango/pango.modules" >> ./pango/pangorc
   touch ./pango/pango.modules
   #pango-querymodules | sed -e "s/.*\/\([^\/][^\/]*\.so\)\s\(.*\)/\.\/pango\/modules\/\1 \2/" > ./pango/pango.modules
   #for f in `pango-querymodules | sed -e "s/\s*\([^#].*\.so\) .*/\1/"  | grep -Ev "\s*#"`; do
   #   cp -f $f ./pango/modules/
   #done
fi

echo Adding submodule information to the version file
cd "$X2SW_PROJ_DIR"
# Use packager's version file
cp -f ./x2sw/version.txt x2sw_build/dist/x2sw/version.txt
git submodule >> x2sw_build/dist/x2sw/version.txt

# Step 8, building the binary package (first move the files around
# and create symlinks to make it look clean and simple).
if [[ ! $* =~ (^| )8($| ) ]]; then 
   echo Building packages
   if [ ! -e "$X2SW_PROJ_DIR/out" ]; then 
      mkdir "$X2SW_PROJ_DIR/out"
   fi
   if [ -e "$X2SW_PROJ_DIR/out/linux" ]; then 
      rm -Rf "$X2SW_PROJ_DIR/out/linux"
   fi
   mkdir "$X2SW_PROJ_DIR/out/linux"
   VER=`cat ./x2sw/version.txt`
   cd "$X2SW_PROJ_DIR/x2sw_build/dist"
   cp "$X2SW_PROJ_DIR/x2sw_build/x2start" ./x2sw/
   # replace real python with a wrapper
   mv ./x2sw/x2swbin/python ./x2sw/x2swbin/pythonx
   cp "$X2SW_PROJ_DIR/x2sw_build/pywrapper" ./x2sw/x2swbin/python
   # make the tarball
   tar -czvf "$X2SW_PROJ_DIR/out/linux/x2sw_$VER.tgz" x2sw
fi

# We are done
onexit


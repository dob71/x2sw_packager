x2sw_packager
=============

Packager for x2sw software bundle

Dependencies:
- Install all the dependencies for compiling slic3r (see http://slic3r.org)
- Install Cava Packager (I've ended up with 2.0.76 under Windows, 2.0.81 under Linux)
  (http://www.cavapackager.com/download/CavaPackager/)
- Install all the dependencies for Printrun (see README.printrun under x2sw)
- Install Dulwich (v0.8.5 or later)
- Install Pyinstaller 2.0 (http://www.pyinstaller.org)
- Linux packager expects to find tcl/tk 8.5 for python.

Instructions:
- The packages are built by scripts in the root of the repo tree.
- The scripts rely on the environment vars to point to instalations of 
  the dependencies. Look in the script for the chosen platform and 
  set up the environment vars to point to the correct locations before 
  executing. 
- Clean the repository tree (unless it is a new download) before 
  building (git clean -xdf).
- Run the build script (you might be asked to confirm some actions during the build).
- If completed successfully the packages are created in the "out/<platform>" folder.
  
Notes:

* Cloning
```
- After runing "git clone" do "git submodule init" and "git submodule update"
  to populate submodule folders
```
* Building Slic3r (Ubuntu 12.04, 32bit)
```
- Get CitrusPerl (see http://www.citrusperl.com/), currrently:
  citrusperl-standard-51603-linux-x86-018.tar.gz
- Unapck to home folder and chown recursively to your user:group
- Rename the top level "perl" folder to "CitrusPerl"
- Run ~/CitrusPerl/bin/citrusutils and update all the packages,
  use stable Wx (currently v2.8.12)
- Source perl envirionment vars in the terminal where you going to run build
  . ~/CitrusPerl/bin/citrusvars.sh
- install "cpanm" (if don't have curl yet, "sudo apt-get install curl" first)
  curl -L http://cpanmin.us | perl - --sudo App::cpanminus
- Go to "x2sw_packager/slic3r" folder and install/build dependencies: 
  perl Build.PL --install
- Force-install Test:Harness (for now it has one useless test that always fails)
  cpanm --force Test::Harness
- Install a few other dependencies manually:
  sudo apt-get install libexpat1 libexpat1-dev
  cpanm XML::SAX::ExpatXS --configure-args EXPATLIBPATH=/usr/lib/i386-linux-gnu
- Install freeglut, webkitgtk, and a few more GUI dependencies:
  sudo apt-get install libwebkitgtk-1.0
  sudo apt-get install freeglut3 freeglut3-dev
  sudo apt-get install libxi-dev libxmu-dev
- Create symlink (OpenGL v0.6704 Makefile.PL fails to find freeglut without
  it, you can remove the symlink after it is installed):
  sudo ln -s /usr/lib/i386-linux-gnu /usr/local/freeglut/lib
- Go to "x2sw_packager/slic3r" folder and install/build GUI dependencies.
  This will most certainly fail (never happened to "just work" for me), but 
  depending on where you run it and what new packages are uploaded to CPAN 
  you might get lucky. If WX is not building, try bundled WX (it's v0.9923):
  perl Build.PL --install --gui
   If the above command succeedes you are done, otherwise:
  perl Build.PL --install --wx
```
* Building Printrun (Ubuntu 12.04, 32bit)
```
- Do it after finishing up with slic3r as some of the dependencies are shared
- Go to the "x2sw" folder in the x2sw_packager repository, 
  assuming you are in ./slic3r folder:
  cd ../x2sw
- Install packages:
  sudo apt-get install python-dev python-pip python-serial python-wxgtk2.8 python-pyglet python-tornado python-setuptools python-libxml2 python-gobject avahi-daemon libavahi-compat-libdnssd1 python-dbus python-psutil python-dulwich
- Install Tk:
  sudo apt-get install python-tk
- Install other requirements:
  sudo apt-get install ncurses-dev
  sudo pip install readline
  sudo pip install numpy
- Build the gcode parser cython extension:
  sudo pip install cython
  python setup.py build_ext --inplace

```
* At this point evertything should work from sources. I.e. if you, for example, 
  clone sources distribution from https://github.com/dob71/x2swn and follow 
  the above instructions you should be able to run "python pronterface.py" and 
  have everything functioning as expected.

* Building binary package (Ubuntu 12.04, 32b)
```
- Continue from the same terminal window where environment is set up for perl
- Go to the top level folder of x2sw_packager repository, 
  assuming you are in ./x2sw folder:
  cd ..
- Install CavaPackager. It has GUI installer. When GUI pops up, change install 
  path to just "/home/<your_username>". It creates CavaPackager folder there...
   wget http://www.cavapackager.com/download/release-2.0.81/cava-packager-linux-x86-2-0-81
   chmod a+x ./cava-packager-linux-x86-2-0-81
   ./cava-packager-linux-x86-2-0-81
   cd <back_to_x2sw_packager_repository>
- Install Pyinstaller:
   cd /tmp
   wget https://pypi.python.org/packages/source/P/PyInstaller/PyInstaller-2.1.tar.gz
   tar -xzvf PyInstaller-2.1.tar.gz 
   cd PyInstaller-2.1/
   sudo python setup.py install
- Clean up the repository:
  git clean -xdf
- Run the build script:
  ./buildall.sh
- First time you run the build script CavaPackager GUI should pop up and 
  complain about finding slic3r.pl script file. You'll need to fix the 
  CavaPackager project (alas its portability mechanism is a bit of PITA
  see http://www.cavapackager.com/appdocs/topicoverview-portability.htm).
  1. Click on "scripts" in the left pane, then click pencil icon in the right 
     pane top corner. Set the script path to /tmp/S/slic3r. 
  2. Click on "Slic3r" project root in the left pane and switch to the
     "Perl Interpreter" tab on the right and add "/tmp/S/slic3r/lib" to the 
     "Extra Module Search Paths".
  Then just close the GUI and the build will try to continue.
- If everything is OK the x2sw_<VERSION>.tgz tarball is in "./out/linux/"
  under the packager repository.

```

x2sw_packager
=============

Packager for x2sw software bundle

Dependencies:
- Install all the dependencies for compiling slic3r (see http://slic3r.org)
- Install Cava Packager (I'm using 2.0.76.682) 
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
- After runing "git clone" do "git submodule init" and "git submodule update"
  to populate submodule folders

* Building Slic3r (Ubuntu 12.04)
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

* Building Printrun (Ubuntu 12.04)
TBD   

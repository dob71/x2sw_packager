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

Instructions:
- The packages are built by scripts in the root of the repo tree.
- The scripts rely on the environment vars to point to instalations of 
  the dependencies. Loook in the script for the chosen platform and 
  set up the environment vars to point to the correct locations before 
  executing. 
- Clean the repository tree (unless it is a new download) before 
  building (git clean -xdf).
- Run the build script (you might be asked to confirm some actions during the build).
- If completed successfully the packages are created in the "out/<platform>" folder.
  

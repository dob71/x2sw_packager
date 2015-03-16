# -*- mode: python -*-

a = Analysis(['../x2sw/pronterface.py','../x2sw/skeinforge/fabmetheus_utilities/archive.py'],
             pathex=['../x2sw'],
             hiddenimports=['X2MergeDialog'])

# Can't make automatic stuff working, just adding skeinforge manually 

pathToMyPython = os.path.dirname(sys.executable)
python2dVersion = sys.version[:3]
pathToInterpreter = sys.executable
pathToWinInterpreter = sys.executable

if sys.platform.startswith('win'):
    pfaceExeName = 'dist/pronterface.exe'
    pathToWinInterpreter = pathToInterpreter[:-4] + 'w.exe'
    if not os.path.exists(pathToWinInterpreter):
        print "Python GUI executable is required, not found: " + pathToWinInterpreter
        exit(-1)
    libPath = os.path.join(pathToMyPython, 'Lib')
    tclTree1 = Tree(os.path.join(pathToMyPython, 'tcl', 'tcl8.5'), prefix='tcl/tcl8.5')
    tclTree2 = Tree(os.path.join(pathToMyPython, 'tcl', 'tk8.5'), prefix='tcl/tk8.5')
    dllsPath = os.path.join(pathToMyPython, 'DLLs')
    dlls = [ (os.path.join('DLLs',f), os.path.join(dllsPath,f), 'DATA') for f in ('_tkinter.pyd','tcl85.dll','tk85.dll') ]
    slic3rDll = Tree('../slic3r_win/release/slic3r/dll', 'slic3r/dll')
    slic3rLib = Tree('../slic3r_win/release/slic3r/lib', 'slic3r/lib')
    slic3rRt = Tree('../slic3r_win/release/slic3r/cpfworkrt', 'slic3r/cpfworkrt')
    slic3rRes = Tree('../slic3r_win/release/slic3r/user', 'slic3r/var')
    slic3rExe = '../slic3r_win/release/slic3r/slic3r.exe'
    slic3rBin = [(os.path.join('slic3r', os.path.basename(slic3rExe)), slic3rExe, 'BINARY')]
    driversDir = Tree('../drivers/win', 'drivers')
    libNamesRoot = [(os.path.join('Lib',f),os.path.join(libPath,f),'DATA') for f in os.listdir(libPath)
                    if (not os.path.isdir(f)
                        and (os.path.splitext(f)[1]=='.py' 
                            or os.path.splitext(f)[1]=='.pyc'))]
    elibPath = os.path.join(libPath,'encodings')
    libNamesEnc = [(os.path.join('Lib','encodings',f),os.path.join(elibPath,f),'DATA') for f in os.listdir(elibPath)
                    if (not os.path.isdir(f)
                        and (os.path.splitext(f)[1]=='.py' 
                            or os.path.splitext(f)[1]=='.pyc'))]
    tlibPath = os.path.join(libPath,'lib-tk')
    libNamesTk = [(os.path.join('Lib','lib-tk',f),os.path.join(tlibPath,f),'DATA') for f in os.listdir(tlibPath)
                    if (not os.path.isdir(f)
                        and (os.path.splitext(f)[1]=='.py' 
                            or os.path.splitext(f)[1]=='.pyc'))]
    binTreeName = 'dist/x2swbin'
elif sys.platform.startswith('linux'):
    pfaceExeName = 'dist/pronterface'
    usrLibPath = '/usr/lib/i386-linux-gnu'
    if not os.path.exists(usrLibPath):
        usrLibPath = '/usr/lib'
    libPath = '/usr/lib/python' + python2dVersion
    tclTree1 = Tree(os.path.join('/usr/share', 'tcltk', 'tcl8.5'), prefix='lib/tcl')
    tclTree2 = Tree(os.path.join('/usr/share', 'tcltk', 'tk8.5'), prefix='lib/tk')
    slic3rDll = Tree('../slic3r_linux/release/slic3r/dll', 'slic3r/dll')
    slic3rLib = Tree('../slic3r_linux/release/slic3r/lib', 'slic3r/lib')
    slic3rRt = []
    slic3rRes = Tree('../slic3r/var', 'slic3r/bin/var')
    slic3rExe = '../slic3r_linux/release/slic3r/bin/slic3r'
    slic3rBin = [(os.path.join('slic3r', 'bin', os.path.basename(slic3rExe)), slic3rExe, 'BINARY')]
    driversDir = Tree(os.path.join(usrLibPath, 'gtk-2.0'), 'lib/gtk-2.0')
    dlls = []
    # flag bits 0-include dependencies, 1-optional, 2-put under bindir
    manualLibs = [(libPath + '/lib-dynload/_tkinter.so', 1),
                  (libPath + '/lib-dynload/datetime.so', 1),
                  (libPath + '/lib-dynload/cmath.so', 3),
                  ('/tmp/pango_fc_mod.so', 5), 
                  ('/tmp/P/site/lib/auto/OpenGL/OpenGL.so', 5), 
                  ('/tmp/P/site/lib/auto/Wx/Wx.so', 5), 
                  (usrLibPath + '/mesa/libGL.so.1', 5), 
                  (usrLibPath + '/libglut.so.3', 5)]
    for (lib, flag) in manualLibs:
        if ((flag & 2) != 0) and (not os.path.exists(lib)):
            continue
        dstPrefix = 'lib/'
        if ((flag & 4) != 0):
            dstPrefix = ''
        if (flag & 1) != 0:
            for (t1, t2) in PyInstaller.bindepend.selectImports(lib):
                dlls.append((dstPrefix + t1, t2, 'DATA'))
        dlls.append((dstPrefix + os.path.basename(lib), lib, 'DATA'))
    # Add TCL/TK deps
    #import imp
    #tkhook = imp.find_module("PyInstaller/hooks/hook-_tkinter")
    #mod = imp.load_module("tkhook", *tkhook)
    #mmm = PyInstaller.depend.modules.ExtensionModule("Tkinter", libPath + '/lib-dynload/_tkinter.so') 
    #print mod.hook(mmm)
    libNamesRoot = [(os.path.join('lib',f),os.path.join(libPath,f),'DATA') for f in os.listdir(libPath)
                    if (not os.path.isdir(f)
                        and (os.path.splitext(f)[1]=='.py' 
                            or os.path.splitext(f)[1]=='.pyc'))]
    elibPath = os.path.join(libPath,'encodings')
    libNamesEnc = [(os.path.join('lib','encodings',f),os.path.join(elibPath,f),'DATA') for f in os.listdir(elibPath)
                    if (not os.path.isdir(f)
                        and (os.path.splitext(f)[1]=='.py' 
                            or os.path.splitext(f)[1]=='.pyc'))]
    tlibPath = os.path.join(libPath,'lib-tk')
    libNamesTk = [(os.path.join('lib','lib-tk',f),os.path.join(tlibPath,f),'DATA') for f in os.listdir(tlibPath)
                    if (not os.path.isdir(f)
                        and (os.path.splitext(f)[1]=='.py' 
                            or os.path.splitext(f)[1]=='.pyc'))]
    binTreeName = 'dist/x2sw/x2swbin'
else:
    print "Not supported architecture!"
    exit(-1)

localeDir = Tree('../x2sw/locale','locale')
imagesDir = Tree('../x2sw/images', 'images')
sfDir = Tree('../x2sw/skeinforge', 'skeinforge')
pfaceIcon = '../x2sw/pronterface.ico'
pfacePng = '../x2sw/pronterface.png'
platerIcon = '../x2sw/plater.ico'
platerPng = '../x2sw/plater.png'
profilerIcon = '../x2sw/x2.ico'
pronsoleIcon = '../x2sw/pronsole.ico'
pronsolePng = '../x2sw/pronsole.png'
versionFile = '../x2sw/version.txt'

# Profiles are included with repo's real git folder
# .git file in submodule points to that real repo git folder
profiles = Tree('../x2sw_profiles', '.x2sw', excludes=['.git'])
profilesGitDir = '../x2sw_profiles/.git'
if os.path.isfile(profilesGitDir):
    for line in open(profilesGitDir,'r'):
       print 'Read line: %s' % line
       if line.split(':')[0] == 'gitdir': profilesGitDir = line.split(' ')[1].lstrip(' ').rstrip('\n')
print 'The git path is: %s\n' % profilesGitDir
profilesGit = Tree(profilesGitDir, os.path.join('.x2sw','.git'))

pyz = PYZ(a.pure)
exe = EXE(pyz,
          a.scripts,
          exclude_binaries=1,
          name=pfaceExeName,
          debug=0,
          strip=False,
          upx=False,
          icon=pfaceIcon,
          console=0 )

coll = COLLECT(exe,                    
          a.binaries, 
          [(os.path.basename(pathToInterpreter), pathToWinInterpreter, 'BINARY')],
          a.zipfiles, 
          a.datas, 
          libNamesRoot,
          libNamesEnc,
          libNamesTk,
          dlls,
          tclTree1,
          tclTree2,
          localeDir,
          imagesDir,
          [(os.path.basename(pfaceIcon),    pfaceIcon,    'DATA'),\
           (os.path.basename(platerIcon),   platerIcon,   'DATA'),\
           (os.path.basename(profilerIcon), profilerIcon, 'DATA'),\
           (os.path.basename(pronsoleIcon), pronsoleIcon, 'DATA'),\
           (os.path.basename(platerPng),    platerPng,    'DATA'),\
           (os.path.basename(pfacePng),     pfacePng,     'DATA'),\
           (os.path.basename(pronsolePng),  pronsolePng,  'DATA'),\
           (os.path.basename(versionFile),  versionFile,  'DATA')],
          sfDir,
          slic3rDll,
          slic3rLib,
          slic3rRt,
          slic3rRes,
          slic3rBin,
          profiles,
          profilesGit,
          driversDir,
          name=binTreeName)

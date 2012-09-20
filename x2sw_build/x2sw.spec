# -*- mode: python -*-

a = Analysis(['../x2sw/pronterface.py','../x2sw/skeinforge/fabmetheus_utilities/archive.py'],
             pathex=['../x2sw'],
             hiddenimports=['X2MergeDialog'])

# %-() let's just add skeinforge manually 

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
    slic3rBin = [(os.path.join('slic3r', os.path.basename(slic3rExe)), slic3rExe, 'BINARY')],
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
    tclTree1 = []
    tclTree2 = []
    slic3rDll = Tree('../slic3r_linux/release/slic3r/dll', 'slic3r/dll')
    slic3rLib = Tree('../slic3r_linux/release/slic3r/lib', 'slic3r/lib')
    slic3rRt = []
    slic3rRes = Tree('../slic3r_linux/release/slic3r/user', 'slic3r/bin/var')
    slic3rExe = '../slic3r_linux/release/slic3r/bin/slic3r'
    slic3rBin = [(os.path.join('slic3r', 'bin', os.path.basename(slic3rExe)), slic3rExe, 'BINARY')]
    driversDir = []
    libPath = '/usr/lib/python' + python2dVersion
    dlls = [('lib/_tkinter.so', libPath + '/lib-dynload/_tkinter.so', 'DATA')]
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
pfaceIcon = '../x2sw/P-face.ico'
platerIcon = '../x2sw/plater.ico'
profilerIcon = '../x2sw/x2.ico'
pronsoleIcon = '../x2sw/pronsole.ico'
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
          [(os.path.basename(pfaceIcon), pfaceIcon, 'DATA'),\
           (os.path.basename(platerIcon), platerIcon, 'DATA'),\
           (os.path.basename(profilerIcon), profilerIcon, 'DATA'),\
           (os.path.basename(pronsoleIcon), pronsoleIcon, 'DATA'),\
           (os.path.basename(versionFile), versionFile, 'DATA')],
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

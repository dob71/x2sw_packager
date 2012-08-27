# -*- mode: python -*-

a = Analysis(['../x2sw/pronterface.py','../x2sw/skeinforge/fabmetheus_utilities/archive.py'],
             pathex=['../x2sw'],
             hiddenimports=['X2MergeDialog'])

# %-() let's just add skeinforge manually 

pathToMyPython = os.path.dirname(sys.executable)

if sys.platform.startswith('win'):
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
    driversDir = Tree('../drivers/win', 'drivers')
elif sys.platform.startswith('linux'):
    print "Not yet supported architecture!"
    exit(-1)
else:
    print "Not supported architecture!"
    exit(-1)

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


localeDir = Tree('../x2sw/locale','locale')
imagesDir = Tree('../x2sw/images', 'images')
sfDir = Tree('../x2sw/skeinforge', 'skeinforge')
pfaceIcon = '../x2sw/P-face.ico'
platerIcon = '../x2sw/plater.ico'
versionFile = '../x2sw/version.txt'

# Profiles are included with repo's real git folder
# .git file in submodule points to that real repo git folder
profiles = Tree('../x2sw_profiles', '.x2sw', excludes=['.git'])
profilesGitDir = '../x2sw_profiles/.git'
if os.path.isfile(profilesGitDir):
    for line in open(profilesGitDir,'r'):
       print 'Read line: {}\n'.format(line)
       if line.split(':')[0] == 'gitdir': profilesGitDir = line.split(' ')[1].lstrip(' ').rstrip('\n')
print 'The git path is: {}\n'.format(profilesGitDir)
profilesGit = Tree(profilesGitDir, os.path.join('.x2sw','.git'))

pyz = PYZ(a.pure)
exe = EXE(pyz,
          a.scripts,
          exclude_binaries=1,
          name='dist/pronterface.exe',
          debug=1,
          strip=False,
          upx=False,
          icon=pfaceIcon,
          console=0 )

coll = COLLECT(exe,                    
          a.binaries, 
          [(os.path.basename(sys.executable), sys.executable, 'BINARY')],
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
          [(os.path.basename(pfaceIcon), pfaceIcon, 'DATA'),(os.path.basename(platerIcon), platerIcon, 'DATA'),(os.path.basename(versionFile), versionFile, 'DATA')],
          sfDir,
          slic3rDll,
          slic3rLib,
          slic3rRt,
          slic3rRes,
          [(os.path.join('slic3r',os.path.basename(slic3rExe)), slic3rExe, 'BINARY')],
          profiles,
          profilesGit,
          driversDir,
          name='dist/x2swbin')

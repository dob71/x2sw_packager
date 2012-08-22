# -*- mode: python -*-
a = Analysis(['../x2sw/pronterface.py', '../x2sw/skeinforge/skeinforge_application/skeinforge.py'],
             pathex=['T:\\Job\\3DPrint\\x2sw_packager\\x2sw_build'],
             hiddenimports=[],
             hookspath=None)
pyz = PYZ(a.pure)
exe = EXE(pyz,
          a.scripts,
          exclude_binaries=1,
          name=os.path.join('build\\pyi.win32\\pronterface', 'pronterface.exe'),
          debug=False,
          strip=None,
          upx=True,
          console=True )
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=None,
               upx=True,
               name=os.path.join('dist', 'pronterface'))

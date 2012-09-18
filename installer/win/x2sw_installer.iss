#define MyAppName "x2sw"
#define MyAppVersion GetEnv("VER")
#define MyAppExeName "pronterface.exe"
#define MyProjectDir GetEnv("X2SW_PROJ_DIR")

#define FindHandle
#define FindResult
#define InfMask GetEnv("X2SW_PROJ_DIR")+'\drivers\win\*.INF'
#define Count
#define DrvComponentList ''

#sub EmitInfComponent
  #define FileName FindGetFileName(FindHandle)
  #define DrvName Copy(FileName, 1, Pos('.inf',LowerCase(FileName))-1)
  #emit 'Name: "drv'+str(Count)+'"; Description: "'+DrvName+' Driver"; Types: custom'
  #expr DrvComponentList += ' drv' + str(Count)
#endsub

#sub EmitInfFileEntry
  #define FileName FindGetFileName(FindHandle)
  #define DrvName Copy(FileName, 1, Pos('.inf',LowerCase(FileName))-1)
  #emit 'Source: "drivers\win\'+FileName+'"; DestDir: "{app}\drivers";  Components: drv'+str(Count)+'; Flags: ignoreversion'
#endsub

[Code]
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  AppDir: String;
begin
  AppDir := ExpandConstant('{app}');
  if (usPostUninstall = CurUninstallStep) then
    if DirExists(AppDir) then
      if MsgBox('Would you like to clean up all the remainig files and folders under "'+AppDir+'"?', mbInformation, MB_YESNO) = IDYES then
        DelTree(AppDir,true,true,true);
end;

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={#MyAppName}_{#MyAppVersion}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
SourceDir={#MyProjectDir}
InfoBeforeFile={#MyProjectDir}\x2sw\README.md
OutputDir={#MyProjectDir}\out\win
OutputBaseFilename=x2sw_win_{#MyAppVersion}
Compression=lzma
SolidCompression=yes
SetupIconFile="{#MyProjectDir}\installer\win\setup.ico"
UninstallDisplayIcon="{app}\x2.ico"
UsePreviousLanguage=no

[Components]
Name: "main"; Description: "Pronterface, Skeinforge and Slic3r bundle w/ Profiles"; Types: full custom; Flags: fixed
#for {(Count = 1, FindHandle = FindResult = FindFirst(InfMask, 0)); FindResult; (Count++, FindResult = FindNext(FindHandle))} EmitInfComponent
#if FindHandle
  #expr FindClose(FindHandle)
#endif

[Types]
Name: "full"; Description: "Full installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Components: main; Flags: unchecked

[Files]
Source: "x2sw_build\dist\x2swbin\*"; DestDir: "{app}"; Excludes: "\drivers"; Components: main; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "drivers\win\dpinst_x86.exe"; DestDir: "{app}\drivers"; Components: {#DrvComponentList}; DestName: dpinst.exe; Check: not IsWin64; Flags: ignoreversion
Source: "drivers\win\dpinst_x64.exe"; DestDir: "{app}\drivers"; Components: {#DrvComponentList}; DestName: dpinst.exe; Check: IsWin64; Flags: ignoreversion
Source: "drivers\win\*.bat"; DestDir: "{app}\drivers"; Components: {#DrvComponentList}; Flags: ignoreversion
#for {(Count = 1, FindHandle = FindResult = FindFirst(InfMask, 0)); \
      FindResult; \
      (Count++, FindResult = FindNext(FindHandle))} EmitInfFileEntry
#if FindHandle
  #expr FindClose(FindHandle)
#endif
; Source: "installer\win\setup.ico"; DestDir: "{app}"; Components: main; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\Pronterface"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{group}\Slic3r"; Filename: "{app}\slic3r\slic3r.exe"; WorkingDir: "{app}"
Name: "{group}\Skeinforge"; Filename: "{app}\python.exe"; Parameters: "skeinforge/skeinforge_application/skeinforge.py"; WorkingDir: "{app}"
; Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Pronterface"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\drivers\dpinst.exe"; Description: "Arduino 0.23 drivers setup"; Parameters: "/LM /SA /SW"; WorkingDir: "{app}\drivers"; Components: {#DrvComponentList}; StatusMsg: "Installing Arduino 0.23 drivers"
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{app}\drivers\uninstall.bat"; WorkingDir: "{app}\drivers"; Components: {#DrvComponentList}; StatusMsg: "Removing Arduino 0.23 drivers"; Flags: shellexec waituntilterminated runminimized

#define MyAppName "x2sw"
#define MyAppVersion "0.0.0"
#define MyAppExeName "pronterface.exe"
#define MyProjectDir "T:\Job\3DPrint\x2sw_packager"

#define FileHandle
#define FileLine
#if FileHandle = FileOpen("{#MyProjectDir}\x2sw\version.txt");
  #undef MyAppVersion
  #define MyAppVersion = FileRead(FileHandle)
  #expr FileClose(FindHandle)
#endif

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
InfoBeforeFile={#MyProjectDir}\x2sw\README.md
OutputDir={#MyProjectDir}\install_win
OutputBaseFilename=x2sw_setup
Compression=lzma
SolidCompression=yes
SourceDir={#MyProjectDir}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "x2sw_build\dist\x2swbin\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "x2sw_build\installer\win\setup.ico"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
IconFilename: "{app}\setup.ico"
WorkingDir: "{app}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

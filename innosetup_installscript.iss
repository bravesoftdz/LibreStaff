;InnoSetupVersion=5.5.5

[Setup]
AppName=LibreStaff
AppVerName=v0.0.4-alpha
DefaultDirName={pf}\LibreStaff
DefaultGroupName=LibreStaff
OutputBaseFilename=LibreStaff_v0.0.4-alpha
Uninstallable=yes
;WizardImageFile=
WizardImageStretch=no
WizardImageBackColor=clWhite
Compression=lzma
ShowLanguageDialog=yes

[Files]
Source: "librestaff.exe"; DestDir: "{app}"; Components: "base"; Flags: ignoreversion
Source: "sqlite3.dll"; DestDir: "{app}"; Components: "base"; Flags: ignoreversion
Source: "lic\*.rtf"; DestDir: "{app}\lic"; Components: "base"; Flags: ignoreversion
Source: "data\*.*"; DestDir: "{app}\data"; Components: "base"; Flags: ignoreversion recursesubdirs
Source: "locale\*.mo"; DestDir: "{app}\locale"; Components: "base"; Flags: ignoreversion recursesubdirs
Source: "templates\*.lrf"; DestDir: "{app}\templates"; Components: "base"; Flags: ignoreversion recursesubdirs

[Dirs]
Name: "{app}";

[Components]
Name: "base"; Description: "LibreStaff"; Types: full compact custom; Flags: fixed

[Icons]
Name: "{group}\LibreStaff"; Filename: "{app}\librestaff.exe"; 
Name: "{group}\Uninstall"; Filename: "{app}\unins000.exe"; 
Name: "{commondesktop}\LibreStaff"; Filename: "{app}\librestaff.exe"; 

[UninstallDelete]
Type: filesandordirs; Name: "{app}";


[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "pt_BR"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Messages]
es.BeveledLabel=Spanish

[Code]
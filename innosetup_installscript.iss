;InnoSetupVersion=5.5.9

[Setup]
AppName=LibreStaff
AppVerName=v0.0.18-alpha
DefaultDirName={pf}\LibreStaff
DefaultGroupName=LibreStaff
OutputBaseFilename=LibreStaff_v0.0.18-alpha
Uninstallable=yes
UninstallDisplayName=LibreStaff
;WizardImageFile=
WizardImageStretch=no
WizardImageBackColor=clWhite
Compression=lzma
ShowLanguageDialog=yes

[Files]
Source: "librestaff.exe"; DestDir: "{app}"; Components: "base"; Flags: ignoreversion
Source: "sqlite3.dll"; DestDir: "{app}"; Components: "base"; Flags: ignoreversion
Source: "libmysql.dll"; DestDir: "{app}"; Components: "base"; Flags: ignoreversion
Source: "lic\*.rtf"; DestDir: "{app}\lic"; Components: "base"; Flags: ignoreversion
Source: "data\states_en_US.txt"; DestDir: "{app}\data"; Components: "base"; Flags: ignoreversion recursesubdirs
Source: "data\states_es_ES.txt"; DestDir: "{app}\data"; Components: "base"; Flags: ignoreversion recursesubdirs
Source: "data\states_pt_BR.txt"; DestDir: "{app}\data"; Components: "base"; Flags: ignoreversion recursesubdirs
Source: "locale\*.*"; DestDir: "{app}\locale"; Components: "base"; Flags: ignoreversion recursesubdirs
Source: "avatars\*.*"; DestDir: "{app}\avatars"; Components: "base"; Flags: ignoreversion recursesubdirs
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
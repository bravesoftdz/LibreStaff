unit FormLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, Buttons, ExtCtrls, PopupNotifier, Globals, FuncData, DataModule,
  FormMain, Crypt;

type
  { TFrmLogin }
  TFrmLogin = class(TForm)
    BtnEnter: TBitBtn;
    BtnExit: TBitBtn;
    EdiUser: TEdit;
    EdiPassword: TEdit;
    ImgUser: TImage;
    ImgPassword: TImage;
    Img22: TImageList;
    LblPassword: TLabel;
    LblUser: TLabel;
    LblLibreStaff: TLabel;
    PopLogin: TPopupNotifier;
    procedure BtnEnterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.lfm}

{ TFrmLogin }

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  //Get bitmaps
  Img22.GetBitmap(0, ImgUser.Picture.Bitmap);
	Img22.GetBitmap(1, ImgPassword.Picture.Bitmap);
  Img22.GetBitmap(2, BtnEnter.Glyph);
  Img22.GetBitmap(3, BtnExit.Glyph);
  //Set lenght for the input boxes
  EdiUser.MaxLength:= USERNAME_LENGTH;
  EdiPassword.MaxLength:= PASSWORD_LENGTH;
  FuncData.ExecSQL(DataMod.QueUsers, SELECT_ALL_USERS_SQL); //Open User's table
end;

procedure TFrmLogin.BtnEnterClick(Sender: TObject);
var
  LoginUser, LoginPassword, HashLoginPassword, HashUser, SaltUser: String;
  p: TPoint;
begin
  LoginUser:= EdiUser.Text;
  LoginPassword:= EdiPassword.Text;
  //Search the user name, password and salt
  FuncData.ExecSQL(DataMod.QueVirtual, 'SELECT ID_User, Hash_User, Salt_User FROM Users WHERE Name_User='''+LoginUser+''' LIMIT 1');
  if DataMod.QueVirtual.IsEmpty= FALSE then
    begin
    SaltUser:= DataMod.QueVirtual.FieldByName('Salt_User').AsString;
    HashLoginPassword:= Crypt.HashString(SaltUser+LoginPassword);
    HashUser:= DataMod.QueVirtual.FieldByName('Hash_User').AsString;
    if (HashLoginPassword= HashUser) then
      begin
      ModalResult:= mrOK;
      end;
    end
  else
    begin
//      p:= Point(FrmLogin.Left, FrmLogin.Top);
//      PopLogin.Text:= 'Username does not exist';
//      PopLogin.ShowAtPos(p.x,p.y);
    end;
  //Get the user
end;

end.



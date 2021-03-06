unit FormReports;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, Buttons, ComCtrls, StdCtrls, DBGrids,
  Globals, FuncData;

type

	TQueryCriteria = record
  	FieldName: String;
	  Criteria: String;
  	DataFormat: TDataFormat;
	end;

	TReportField= class(TObject)
    private
 			fName, fTitle, fShortTitle: String;
    public
      property Name: string read fName write fName;
			property Title: string read fTitle write fTitle;
      property ShortTitle: string read fShortTitle write fShortTitle;
      constructor Create(stName : string; stTitle: string; stShortTitle: string);
  end;

type
	TReport= class(TObject)
    private
      fTable: TTable;
 			fReportFieldsList, fAvailableReportFieldsList: TList;
    public
      property Table: TTable read fTable write fTable;
      property ReportFieldsList: TList read fReportFieldsList write fReportFieldsList;
			property AvailableReportFieldsList: TList read fAvailableReportFieldsList write fAvailableReportFieldsList;
      constructor Create(tbTable: TTable; lsReportFieldsList: TList; lsAvailableReportFieldsList: TList);
      destructor Destroy; override;
  end;

  { TFrmReports }

  TFrmReports = class(TForm)
    BtnClose: TBitBtn;
    BtnQuery: TBitBtn;
    BtnAddField: TBitBtn;
    BtnRemoveField: TBitBtn;
    BtnUpField: TBitBtn;
    BtnDownField: TBitBtn;
    ChkActByName: TCheckBox;
    ChkActByBirthday: TCheckBox;
    ChkActBySurname1: TCheckBox;
    DatDateBirthEnd: TDateTimePicker;
    DBGridQueryResult: TDBGrid;
    EdiNameEmployee: TEdit;
    EdiSurname1Employee: TEdit;
    GroupBox1: TGroupBox;
    ImgFilters: TImage;
    LblFilters: TLabel;
    LblDateBirthEnd: TLabel;
    LblDateBirthInit: TDateTimePicker;
    LblNameEmployee: TLabel;
    LblSurname1Employee1: TLabel;
    LstBoxFields: TListBox;
    LstBoxAvailableFields: TListBox;
    LLblDateBirthInit: TLabel;
    PagCriterion: TPageControl;
    PanBottom2: TPanel;
    PanTop: TPanel;
    TabCriterionPersonalData: TTabSheet;
    TabeCriterionContract: TTabSheet;
    TabFields: TTabSheet;
    procedure BtnAddFieldClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnQueryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    Report: TReport;
		Criteria: array of TQueryCriteria;
    procedure AddCriteria(FieldName: String; CriteriaStr: String; DataFormat: TDataFormat);
		procedure UpdateLstBoxes;
  public

  end;

var
  FrmReports: TFrmReports;

implementation

{$R *.lfm}

uses
  DataModule, FuncApp, FormMain;

{The Report Object Procedures}

constructor TReportField.Create(stName: String; stTitle: String; stShortTitle: String);
begin
	self.Name:= stName;
	self.Title:= stTitle;
  self.ShortTitle:= stShortTitle;
end;

constructor TReport.Create(tbTable: TTable; lsReportFieldsList: TList; lsAvailableReportFieldsList: TList);
begin
  self.Table:= tbTable;
	self.ReportFieldsList:= lsReportFieldsList;
	self.AvailableReportFieldsList:= lsAvailableReportFieldsList;
end;

destructor TReport.Destroy;
begin
  FreeAndNil(fReportFieldsList);
  FreeAndNil(fAvailableReportFieldsList);
end;

{ TFrmReports }

procedure TFrmReports.FormCreate(Sender: TObject);
var
  i: Integer;
  ReportFieldsStrings: TStringList;
begin
	DataMod.ImgLstBtn.GetBitmap(2, BtnClose.Glyph);
  DataMod.ImgLstBtn.GetBitmap(16, BtnQuery.Glyph);
  DataMod.ImgLstBtn.GetBitmap(24, ImgFilters.Picture.Bitmap);
  Report:= TReport.Create(DBEngine.Tables[4], TList.Create, TList.Create);
  Report.ReportFieldsList.Add(TReportField.Create('Name_Employee', 'Name of Employee', 'Name'));
  Report.ReportFieldsList.Add(TReportField.Create('Surname1_Employee', 'Surname 1 of Employee', 'Surname 1'));
  Report.ReportFieldsList.Add(TReportField.Create('Surname2_Employee', 'Surname 2 of Employee', 'Surname 2'));
  ReportFieldsStrings:= TStringList.Create;
  for i:=0 to (Report.ReportFieldsList.Count-1) do
    begin
		ReportFieldsStrings.Add(TReportField(Report.ReportFieldsList.Items[i]).Title);
    end;
 	LstBoxFields.Items.Assign(ReportFieldsStrings);
  ReportFieldsStrings.Clear;
	Report.AvailableReportFieldsList.Add(TReportField.Create('DateBirth_Employee', 'Datebirth of Employee', 'Datebirth'));
  for i:=0 to (Report.AvailableReportFieldsList.Count-1) do
    begin
		ReportFieldsStrings.Add(TReportField(Report.AvailableReportFieldsList.Items[i]).Title);
    end;
	LstBoxAvailableFields.Items.Assign(ReportFieldsStrings);
  FreeAndInvalidate(ReportFieldsStrings);
end;

procedure TFrmReports.BtnAddFieldClick(Sender: TObject);
var
  Item: Pointer;
begin
  if (LstBoxAvailableFields.Items.Count= 0) then
  	begin
    FuncApp.PopNotifier(FrmReports, 'Error!', 'No more items to add.', FrmMain.ScreenToClient(Mouse.CursorPos));
    Exit;
    end;
  if (LstBoxAvailableFields.ItemIndex>-1) then
    begin
    Item:= TReportField(Report.AvailableReportFieldsList.Items[LstBoxAvailableFields.ItemIndex]);
		if (LstBoxFields.ItemIndex>-1) then
      begin
      Report.ReportFieldsList.Insert(LstBoxFields.ItemIndex, Item);
      end
    else
    	begin
      Report.ReportFieldsList.Add(Item);
      end;
		Report.AvailableReportFieldsList.Delete(LstBoxAvailableFields.ItemIndex);
    UpdateLstBoxes;
    end
  	else
    	begin
      FuncApp.PopNotifier(FrmReports, 'Warning!', 'Select an item.', FrmMain.ScreenToClient(Mouse.CursorPos));
      end;
end;

procedure TFrmReports.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmReports.BtnQueryClick(Sender: TObject);
var
  i: Integer;
	SelectFields: String;
  HighCriteria: Integer;
  SQLReport: TStringList;
begin
  for i:=0 to (Report.ReportFieldsList.Count-1) do
  	begin
    SelectFields:= SelectFields + ' ' + TReportField(Report.ReportFieldsList.Items[i]).Name;
    if (i<Report.ReportFieldsList.Count-1) then
    	begin
    	SelectFields:= SelectFields + ',';
      end;
    end;
  SetLength(Criteria, 0);
  SQLReport:= TStringList.Create;
  SQLReport.Add('SELECT '+ SelectFields + ' FROM ' + Report.Table.Name);
  if ChkActByName.Checked= True then
    AddCriteria('Name_Employee', EdiNameEmployee.Text, dtString);
  if ChkActBySurname1.Checked= True then
    AddCriteria('Surname1_Employee', EdiSurname1Employee.Text, dtString);
  if (Criteria<>nil) then
    begin
	  SQLReport.Add('WHERE');
    HighCriteria:= High(Criteria);
  	for i:= 0 to HighCriteria do
    	begin
      if (i>0) then
        begin
        SQLReport.Add('AND');
        end;
      SQLReport.Add('('+Criteria[i].FieldName+'='+'"'+Criteria[i].Criteria+'")');
  	  end;
    end;
  FuncData.ExecSQL(DataMod.QueQuery, '', True, SQLReport);
  //Fill the grid titles:
  for i:=0 to (Report.ReportFieldsList.Count-1) do
    begin
	  DBGridQueryResult.Columns.Items[i].Title.Caption:= TReportField(Report.ReportFieldsList.Items[i]).ShortTitle;
    end;
  //FreeAndNil(SQLReport): PUT THIS COULD CASUE ERRORS
  SQLReport:= nil;
  SQLReport.Free;
end;

procedure TFrmReports.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  i: Integer;
begin
  //Before delete Report, It's mandatory to Free the ReportFields objects of the two lists
  for i:= 0 to Report.ReportFieldsList.Count - 1 do
		begin;
	  TReportField(Report.ReportFieldsList[i]).Free
		end;
  for i:= 0 to Report.AvailableReportFieldsList.Count - 1 do
		begin;
	  TReportField(Report.AvailableReportFieldsList[i]).Free
		end;
  FreeAndNil(Report);
  DataMod.QueQuery.Close;
  FreeAndNil(PopNotifierObj);
  CloseAction:= caFree;
end;

procedure TFrmReports.AddCriteria(FieldName: String; CriteriaStr: String; DataFormat: TDataFormat);
var
  LenghtCriteria: Integer;
begin
  SetLength(Criteria, Length(Criteria)+1);
  LenghtCriteria:= Length(Criteria);
	Criteria[LenghtCriteria-1].FieldName:= FieldName;
	Criteria[LenghtCriteria-1].Criteria:= CriteriaStr;
	Criteria[LenghtCriteria-1].DataFormat:= DataFormat;
end;

procedure TFrmReports.UpdateLstBoxes;
var
	ReportFieldsStrings: TStringList;
  i: Integer;
begin
	ReportFieldsStrings:= TStringList.Create;
  for i:=0 to (Report.ReportFieldsList.Count-1) do
 		ReportFieldsStrings.Add(TReportField(Report.ReportFieldsList.Items[i]).Title);
  LstBoxFields.Items.Assign(ReportFieldsStrings);
  ReportFieldsStrings.Clear;
  for i:=0 to (Report.AvailableReportFieldsList.Count-1) do
 		ReportFieldsStrings.Add(TReportField(Report.AvailableReportFieldsList.Items[i]).Title);
	LstBoxAvailableFields.Items.Assign(ReportFieldsStrings);
	FreeAndInvalidate(ReportFieldsStrings);
end;

end.


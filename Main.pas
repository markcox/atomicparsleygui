unit Main;

interface

{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, FileCtrl, Grids, ComCtrls, StrUtils,
  ExtCtrls, ShellCtrls;
{$WARNINGS ON}

type
  TfrmMain = class(TForm)
    pnlMain: TPanel;
    lsvMain: TListView;
    splProcess: TSplitter;
    memProcess: TMemo;
    svwMain: TShellTreeView;
    Splitter1: TSplitter;
    pctMain: TPageControl;
    tbsTV: TTabSheet;
    btnTvProcessFiles: TButton;
    tbsMovie: TTabSheet;
    tbsMusic: TTabSheet;
    edtTVShowName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtTVSeason: TEdit;
    edtTVFirstShowNo: TEdit;
    btnTVApplyInfo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnTvProcessFilesClick(Sender: TObject);
    procedure svwMainChange(Sender: TObject; Node: TTreeNode);
    procedure lsvMainSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnTVApplyInfoClick(Sender: TObject);
    procedure edtPadZero(Sender: TObject);
  private
    MovieExt : TStrings;

    function  PadZero(aValue : String) : String;
    procedure RunDosInMemo(DosApp: String; AMemo:TMemo);
    procedure SetupColumns;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent) ; override;
    destructor  Destroy; override;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation


{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
 // ToDo: Add code to read movie extentions from ini file

  MovieExt := TStringList.Create;
  MovieExt.Add('.mp4');
  MovieExt.Add('.m4v');
  inherited;

end;


procedure TfrmMain.FormCreate(Sender: TObject);
var
  sFilePath  : string;
  MyIniFile  : TIniFile;

begin

  MyIniFile := TIniFile.Create(ChangeFileExt( Application.ExeName, '.INI' ));
  sFilePath :=MyIniFile.ReadString('PATHS', 'FilePath', '');
  svwMain.Width := StrToInt(MyIniFile.ReadString('GUI', 'svwMain.Width', '200'));
  memProcess.Height := StrToInt(MyIniFile.ReadString('GUI', 'memProcess.Height', '200'));
  MyIniFile.Free;

  if DirectoryExists( sFilePath ) then
  begin
    svwMain.Path :=  sFilePath;
  end;


end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  MyIniFile  : TIniFile;

begin

  MyIniFile := TIniFile.Create(ChangeFileExt( Application.ExeName, '.INI' ));
  MyIniFile.WriteString('PATHS', 'FilePath', svwMain.Path);
  MyIniFile.WriteString('GUI', 'svwMain.Width', IntToStr(svwMain.Width));
  MyIniFile.WriteString('GUI', 'memProcess.Height', IntToStr(memProcess.Height));
  MyIniFile.Free;

end;


procedure TfrmMain.btnTvProcessFilesClick(Sender: TObject);
var
  i           : integer;
  sCmdOptions : string;
  oOptions    : TStrings;

begin
  sCmdOptions := '';

  lsvMain.MultiSelect := False;

  for i := 0 to lsvMain.Items.Count - 1 do
  begin

    if lsvMain.Items[i].Checked then
    begin
      lsvMain.Items[i].Selected := true;
      lsvMain.Enabled := False;
      oOptions := lsvMain.Items.Item[i].SubItems;
      sCmdOptions := ' --stik "TV Show"';
      sCmdOptions := sCmdOptions + ' --TVShowName "' + oOptions[1] + '"';
      sCmdOptions := sCmdOptions + ' --TVEpisode "' + oOptions[2] + oOptions[3] +'"';
      sCmdOptions := sCmdOptions + ' --TVEpisodeNum "' + oOptions[3] + '"';
      sCmdOptions := sCmdOptions + ' --TVSeason "' + oOptions[2] +'"';
      RunDosInMemo('AtomicParsley.exe "' + oOptions[0] + '"' + sCmdOptions, memProcess) ;
      lsvMain.Enabled := True;
    end;
  end;
  lsvMain.MultiSelect := True;

end;

procedure TfrmMain.svwMainChange(Sender: TObject; Node: TTreeNode);
var
  NewItem    : TListItem;
  Rec        : TSearchRec;

begin

  lsvMain.Clear;
  SetupColumns;
  lsvMain.Items.BeginUpdate;

  if FindFirst(svwMain.Path + '\*.*' ,faAnyFile ,Rec) = 0 then
  begin
    repeat
      if MovieExt.IndexOf(ExtractFileExt(Rec.Name)) > -1 then
      begin
        NewItem := lsvMain.Items.Add;
        NewItem.SubItems.Add(svwMain.Path + '\' + Rec.Name);
      end;
    until FindNext(Rec) <> 0;

    FindClose(Rec);
  end;

  lsvMain.Items.EndUpdate;

end;

procedure TfrmMain.lsvMainSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  CmdLine : string;

begin

  if lsvMain.ItemIndex > - 1 then
  begin
    lsvMain.Enabled := False;
    CmdLine := 'AtomicParsley.exe "' + Item.SubItems[0] + '" -t +';
    RunDosInMemo(CmdLine, memProcess) ;
    lsvMain.Enabled := True;
    self.ActiveControl := lsvMain;
  end;

end;


procedure TfrmMain.SetupColumns;
var
  NewCol : TListColumn;

begin
  if lsvMain.Columns.Count = 0 then
  begin
    NewCol := lsvMain.Columns.Add;
    NewCol.Width := 20;
    NewCol := lsvMain.Columns.Add;
    NewCol.Width := 200;
    NewCol.Caption := 'File Name';
  end;

  While lsvMain.Columns.Count > 2 do
  begin
    lsvMain.Columns.Delete(2);
  end;

  Case pctMain.ActivePageIndex of
    0:
    begin
      NewCol := lsvMain.Columns.Add;
      NewCol.Width := 150;
      NewCol.Caption := 'Series Name';
      NewCol := lsvMain.Columns.Add;
      NewCol.Width := 50;
      NewCol.Caption := 'Season';
      NewCol := lsvMain.Columns.Add;
      NewCol.Width := 50;
      NewCol.Caption := 'Episode';
    end;
    1:
    begin

    end;
    2:
    begin

    end;
  end;
end;

procedure TfrmMain.RunDosInMemo(DosApp:String;AMemo:TMemo) ;
  const
    ReadBuffer = 2400;
  var
    Security         : TSecurityAttributes;
    ReadPipe,
    WritePipe        : THandle;
    start            : TStartUpInfo;
    ProcessInfo      : TProcessInformation;
    Buffer           : Pchar;
    BytesRead        : DWord;
    Apprunning       : DWord;
    LastLineIndex    : integer;
    TempBuffer       : String;

begin
   AMemo.Clear;
   LastLineIndex := 0;

   With Security do begin
    nlength := SizeOf(TSecurityAttributes) ;
    binherithandle := true;
    lpsecuritydescriptor := nil;
   end;


   if Createpipe (ReadPipe, WritePipe, @Security, 0) then
   begin
     Buffer := AllocMem(ReadBuffer + 1) ;
     FillChar(Start,Sizeof(Start),#0) ;
     start.cb := SizeOf(start) ;
     start.hStdOutput := WritePipe;
     start.hStdInput := ReadPipe;
     start.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
     start.wShowWindow := SW_HIDE;

     if CreateProcess(nil, PChar(DosApp), @Security, @Security, true, NORMAL_PRIORITY_CLASS, nil, nil, start, ProcessInfo) then
     begin

       Repeat
         Apprunning := WaitForSingleObject (ProcessInfo.hProcess,100) ;
         BytesRead := 0;
         ReadFile(ReadPipe,Buffer[0],ReadBuffer,BytesRead,nil) ;
         Buffer[BytesRead]:= #0;
         OemToAnsi(Buffer,Buffer);

         TempBuffer := TempBuffer + Buffer;

         while pos(#13, TempBuffer) > 0 do
         begin
           if TempBuffer[pos(#13, TempBuffer) + 1] = #10 then
           begin
             LastLineIndex := AMemo.Lines.Add(LeftStr(TempBuffer, pos(#13, TempBuffer) - 1));
             TempBuffer := RightStr(TempBuffer, Length(TempBuffer) - (pos(#13, TempBuffer) + 1));
             inc(LastLineIndex);
           end
           else
           begin
             AMemo.Lines.Strings[LastLineIndex] := Trim(LeftStr(TempBuffer, pos(#13, TempBuffer) - 1));
             TempBuffer := RightStr(TempBuffer, Length(TempBuffer) - (pos(#13, TempBuffer) ))
           end;
         end;

         Application.ProcessMessages;

       until ((Apprunning <> WAIT_TIMEOUT) and (BytesRead < ReadBuffer)) ;

       AMemo.Lines.Text := AMemo.Lines.Text + TempBuffer;

     end;

     FreeMem(Buffer) ;
     CloseHandle(ProcessInfo.hProcess) ;
     CloseHandle(ProcessInfo.hThread) ;
     CloseHandle(ReadPipe) ;
     CloseHandle(WritePipe) ;
   end;
end;

procedure TfrmMain.btnTVApplyInfoClick(Sender: TObject);
var
  i,
  ShowNo   : Integer;

begin
  ShowNo := 0;

  for i := 0 to lsvMain.Items.Count -1 do
  begin
    if lsvMain.Items.Item[i].Selected then
    begin
      if lsvMain.Items.Item[i].SubItems.Count = 1 then
      begin
        lsvMain.Items.Item[i].SubItems.Add(edtTVShowName.text);
        lsvMain.Items.Item[i].SubItems.Add(edtTVSeason.text);
        lsvMain.Items.Item[i].SubItems.Add(PadZero(IntToStr(StrToInt(edtTVFirstShowNo.Text) + ShowNo)));
      end
      else
      begin
        lsvMain.Items.Item[i].SubItems.Strings[1] := edtTVShowName.text;
        lsvMain.Items.Item[i].SubItems.Strings[2] := edtTVSeason.text;
        lsvMain.Items.Item[i].SubItems.Strings[3] := PadZero(IntToStr(StrToInt(edtTVFirstShowNo.Text) + ShowNo));
      end;
      lsvMain.Items.Item[i].checked := true;
      inc(ShowNo);

    end;

  end;
end;

procedure TfrmMain.edtPadZero(Sender: TObject);
begin
  TEdit(Sender).Text := PadZero(TEdit(Sender).Text);

end;

function TfrmMain.PadZero(aValue: String): String;
var
  iValue : Integer;
  sValue : String;
begin
  iValue := StrToIntDef(aValue, 0);
  sValue := IntToStr(iValue);
  if length(sValue) = 1 then
    result := '0' + sValue
  else
    result := sValue;

end;

destructor TfrmMain.Destroy;
begin
  MovieExt.Free;
  inherited;
end;

end.

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdFTP, IdFtpList, StrUtils, IdFTPCommon;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edHost: TEdit;
    edPassword: TEdit;
    edUser: TEdit;
    IdFTP1: TIdFTP;
    btnConnect: TButton;
    Label4: TLabel;
    edCurrentDir: TEdit;
    btnChangeDir: TButton;
    btnCreateDir: TButton;
    btnUpload: TButton;
    btnDelete: TButton;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    Edit1: TEdit;
    Label5: TLabel;
    procedure btnConnectClick(Sender: TObject);
    procedure IdFTP1Connected(Sender: TObject);
    procedure IdFTP1AfterClientLogin(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnChangeDirClick(Sender: TObject);
    procedure btnCreateDirClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure ShowDir(Dir: String);
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  if IdFTP1.Connected then
  begin
    IdFtp1.Disconnect;
    btnConnect.Caption := 'Verbinden';
    ListBox1.Clear;
  end
  else begin
    IdFTP1.Host := edHost.Text;
    IdFtp1.Username := edUser.Text;
    IdFtp1.Password := edPassword.Text;
   // IdFtp1.Port := 2222;
    IdFtp1.Connect;
  end;
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
var
  I: Integer;
  FileName: String;
begin
  if IdFTP1.Connected and (ListBox1.SelCount > 0) then
  begin
    for I := 0 to ListBox1.Count - 1 do
    begin
      if ListBox1.Selected[i] then
      begin
        FileName := EdCurrentDir.Text;
        if not EndsText('/', FileName) then
          FileName := FileName + '/';
        FileName := FileName + ListBox1.Items[I];
        if MessageDlg('Soll die Datei ' + FileName
          + ' wirklich gel�scht werden?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          IdFtp1.Delete(FileName);
      end;
    end;
  end;
end;

procedure TForm1.btnUploadClick(Sender: TObject);
begin
  if IdFTP1.Connected then begin
    if OpenDialog1.Execute then
    begin
      IdFTP1.TransferType := ftBinary;
      IdFTP1.Put(OpenDialog1.FileName, ExtractFileName(OpenDialog1.FileName));
      ShowDir(EdCurrentDir.Text);
    end;
  end;
end;

procedure TForm1.btnCreateDirClick(Sender: TObject);
var
  Dir: string;
begin
  if IdFTP1.Connected then
  begin
    Dir := '/';
    if (InputQuery('Verzeichnis anlegen', 'Pfad es neuen Verzeichnisses', dir)) then
    begin
      IdFtp1.MakeDir(dir);
      ShowDir(EdCurrentDir.Text);
    end;
  end;
end;

procedure TForm1.btnChangeDirClick(Sender: TObject);
begin
  if IdFTP1.Connected then
  begin
    IdFtp1.ChangeDir(edCurrentDir.Text);
    ShowDir(EdCurrentDir.Text);
  end;
end;

procedure TForm1.IdFTP1AfterClientLogin(Sender: TObject);
begin
  ShowDir('/');
end;

procedure TForm1.IdFTP1Connected(Sender: TObject);
begin
  btnConnect.Caption := 'Trennen'
end;

procedure TForm1.ShowDir(Dir: String);
var
  I: Integer;
begin
  ListBox1.Clear;
  if IdFTP1.Connected then
  begin
    IdFTP1.List();
    for I := 0 to IdFtp1.DirectoryListing.Count - 1 do
      ListBox1.Items.Add(IdFtp1.DirectoryListing.Items[I].FileName);
    edCurrentDir.Text := Dir;
  end;
end;

end.

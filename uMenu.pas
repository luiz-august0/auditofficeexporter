unit uMenu;

interface

uses
	midas,
	midaslib,
	Winapi.Windows,
	Winapi.Messages,
	System.SysUtils,
	System.Variants,
	System.Classes,
	IniFiles,
	Vcl.Graphics,
	Vcl.Controls,
	Vcl.Forms,
	Vcl.Dialogs,
	Vcl.StdCtrls,
	Vcl.Buttons,
	Vcl.ExtCtrls,
	Vcl.Menus;

type
	TfrmMenu = class(TForm)
		MainMenu1 : TMainMenu;
		menuCadastro : TMenuItem;
		menuExportacao : TMenuItem;
		menuCadClassificacao : TMenuItem;
		menuCadFuncSituacao : TMenuItem;
		menuClassificaoTCE : TMenuItem;
		menuBalancete : TMenuItem;
		menuMovimentoContabil : TMenuItem;
		menuFolhaServidor : TMenuItem;
		menuRelatorios : TMenuItem;
		menuRelFuncionarios : TMenuItem;
		menuRemuneracao : TMenuItem;
		procedure FormCreate(Sender : TObject);
		procedure FormShow(Sender : TObject);
		procedure menuCadClassificacaoClick(Sender : TObject);
		procedure menuClassificaoTCEClick(Sender : TObject);
		procedure menuCadFuncSituacaoClick(Sender : TObject);
		procedure menuBalanceteClick(Sender : TObject);
		procedure menuMovimentoContabilClick(Sender : TObject);
		procedure menuFolhaServidorClick(Sender : TObject);
		procedure menuRelFuncionariosClick(Sender : TObject);
		procedure menuRemuneracaoClick(Sender : TObject);
		procedure FormClose(Sender : TObject; var Action : TCloseAction);
		private
			{ Private declarations }
		public
			{ Public declarations }
	end;

var
	frmMenu    : TfrmMenu;
	oIF_config : TIniFile;

implementation

uses
	oDmDados,
	mCadClassificacao,
	mCadClassificacaoTCE,
	mCadFuncionarioServidor,
	mExpBalanceteMensal,
	mExpMovContabilMensal,
	mExpFolhaServidor,
	mRelRelacaoFuncionarios,
	mRelRelacaoFuncionariosComp,
	mCreateTables;

{$R *.dfm}


procedure TfrmMenu.FormClose(Sender : TObject; var Action : TCloseAction);
begin
	dmDados.pDesconecta;
	FreeAndNil(oIF_config);
end;

procedure TfrmMenu.FormCreate(Sender : TObject);
var
	vsArqIni, HostName, User, Password, Database : String;
	Port                                         : Integer;

begin
	vsArqIni := ExtractFilePath(Application.ExeName) + 'ExportadorConfig.ini';

	if (oIF_config = nil) then
		oIF_config := TIniFile.Create(vsArqIni);

	HostName := oIF_config.ReadString('DBConfig', 'HostName', '');
	User     := oIF_config.ReadString('DBConfig', 'User', '');
	Password := oIF_config.ReadString('DBConfig', 'Password', '');
	Port     := oIF_config.ReadInteger('DBConfig', 'Port', 3306);
	Database := oIF_config.ReadString('DBConfig', 'Database', '');

	dmDados.pConecta(HostName, User, Password, Database, Port);

	if dmDados.vbConectado then
		mCreateTables.pCriaTabelas;
end;

procedure TfrmMenu.FormShow(Sender : TObject);
begin
	if not dmDados.vbConectado then
	begin
		ShowMessage('Não há conexão com banco de dados. Favor verificar se o arquivo "ExportadorConfig.ini" está na pasta do executável');
		Close;
	end;
end;

procedure TfrmMenu.menuBalanceteClick(Sender : TObject);
begin
	if frmBalancete = nil then
		frmBalancete := TfrmBalancete.Create(Self);
	frmBalancete.show;
end;

procedure TfrmMenu.menuCadClassificacaoClick(Sender : TObject);
begin
	if frmCadClassificacao = nil then
		frmCadClassificacao := TfrmCadClassificacao.Create(Self);
	frmCadClassificacao.show;
end;

procedure TfrmMenu.menuCadFuncSituacaoClick(Sender : TObject);
begin
	if frmCadFuncionarioServidor = nil then
		frmCadFuncionarioServidor := TfrmCadFuncionarioServidor.Create(Self);
	frmCadFuncionarioServidor.show;
end;

procedure TfrmMenu.menuClassificaoTCEClick(Sender : TObject);
begin
	if frmCadClassificacaoTCE = nil then
		frmCadClassificacaoTCE := TfrmCadClassificacaoTCE.Create(Self);
	frmCadClassificacaoTCE.show;
end;

procedure TfrmMenu.menuFolhaServidorClick(Sender : TObject);
begin
	if frmFolhaServidor = nil then
		frmFolhaServidor := TfrmFolhaServidor.Create(Self);
	frmFolhaServidor.show;
end;

procedure TfrmMenu.menuMovimentoContabilClick(Sender : TObject);
begin
	if frmMovContabil = nil then
		frmMovContabil := TfrmMovContabil.Create(Self);
	frmMovContabil.show;
end;

procedure TfrmMenu.menuRelFuncionariosClick(Sender : TObject);
begin
	if frmRelacaoFuncionarios = nil then
		frmRelacaoFuncionarios := TfrmRelacaoFuncionarios.Create(Self);
	frmRelacaoFuncionarios.show;
end;

procedure TfrmMenu.menuRemuneracaoClick(Sender : TObject);
begin
	if frmRelacaoFuncionariosComp = nil then
		frmRelacaoFuncionariosComp := TfrmRelacaoFuncionariosComp.Create(Self);
	frmRelacaoFuncionariosComp.show;
end;

end.

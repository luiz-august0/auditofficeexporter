unit mCadClassificacao;

interface

uses
	midas,
	midaslib,
	Winapi.Windows,
	Winapi.Messages,
	System.SysUtils,
	System.Variants,
	System.Classes,
	Vcl.Graphics,
	Vcl.Controls,
	Vcl.Forms,
	Vcl.Dialogs,
	Data.DB,
	Vcl.DBCGrids,
	Vcl.Grids,
	Vcl.DBGrids,
	Datasnap.DBClient,
	Vcl.StdCtrls,
	Vcl.Mask,
	Vcl.DBCtrls,
	Vcl.ExtCtrls,
	ZAbstractRODataset,
	ZAbstractDataset,
	ZAbstractTable,
	ZDataset,
	uGeral,
	Vcl.Buttons;

type
	TfrmCadClassificacao = class(TForm)
		DBGrid1 : TDBGrid;
		oDS_ClassificacaoVinculo : TDataSource;
		Label1 : TLabel;
		Label2 : TLabel;
		DBNavigator1 : TDBNavigator;
		tableClassificacaoXTce : TZTable;
		dbcSistema : TDBComboBox;
		dbcTCE : TDBComboBox;
		editSistema : TEdit;
		editTCE : TEdit;
		Panel1 : TPanel;
		SpeedButton2 : TSpeedButton;
		Edit1 : TEdit;
		procedure tableClassificacaoXTceBeforePost(DataSet : TDataSet);
		procedure DBNavigator1Click(Sender : TObject; Button : TNavigateBtn);
		procedure dbcSistemaChange(Sender : TObject);
		procedure dbcSistemaEnter(Sender : TObject);
		procedure dbcTCEChange(Sender : TObject);
		procedure dbcTCEEnter(Sender : TObject);
		procedure FormShow(Sender : TObject);
		procedure SpeedButton2Click(Sender : TObject);
		procedure FormClose(Sender : TObject; var Action : TCloseAction);
		procedure tableClassificacaoXTceBeforeDelete(DataSet : TDataSet);
		private
			{ Private declarations }
			procedure pCarregaDados;
			procedure validaCampos(classSistema, classTce : String);
			procedure getSistema;
			procedure getDescTCE;
		public
			{ Public declarations }
	end;

var
	frmCadClassificacao : TfrmCadClassificacao;

implementation

uses
	oDmDados;

{$R *.dfm}


procedure TfrmCadClassificacao.pCarregaDados;
var
	oCDS_Tce, oCDS_Sistema : TClientDataSet;

begin
	oCDS_Tce     := TClientDataSet.Create(nil);
	oCDS_Sistema := TClientDataSet.Create(nil);

	if dmDados.vbConectado then
		tableClassificacaoXTce.Active := True;

	dmDados.ExecSQL('SELECT classificacao_tce, descricao_tce FROM ClassificacaoTce', oCDS_Tce);
	if not oCDS_Tce.IsEmpty then
	begin
		oCDS_Tce.First;
		while not oCDS_Tce.EOF do
		begin
			dbcTCE.Items.Add(oCDS_Tce.FieldByName('classificacao_tce').AsString + ' - ' + oCDS_Tce.FieldByName('descricao_tce').AsString);
			oCDS_Tce.Next;
		end;
	end;

	dmDados.ExecSQL('SELECT classificacao, descricao FROM Plano WHERE nr_grau = 5', oCDS_Sistema);
	if not oCDS_Sistema.IsEmpty then
	begin
		oCDS_Sistema.First;
		while not oCDS_Sistema.EOF do
		begin
			dbcSistema.Items.Add(oCDS_Sistema.FieldByName('classificacao').AsString + ' - ' + oCDS_Sistema.FieldByName('descricao').AsString);
			oCDS_Sistema.Next;
		end;
	end;

	getSistema;
	getDescTCE;
	oCDS_Tce.Free;
	oCDS_Sistema.Free;
end;

procedure TfrmCadClassificacao.FormClose(Sender : TObject; var Action : TCloseAction);
begin
	inherited;
	Action := caFree;
	Release;
	frmCadClassificacao := nil;
end;

procedure TfrmCadClassificacao.FormShow(Sender : TObject);
begin
	dbcTCE.Items.Clear;
	dbcSistema.Items.Clear;
	pCarregaDados;
end;

procedure TfrmCadClassificacao.getSistema;
var
	classSistema : string;
	oCDS_Sistema : TClientDataSet;
begin
	oCDS_Sistema := TClientDataSet.Create(nil);

	if dbcSistema.Text <> '' then
	begin
		if Pos('-', dbcSistema.Text) <> 0 then
			classSistema := Copy(dbcSistema.Text, 0, Pos('-', dbcSistema.Text) - 1)
		else
			classSistema := dbcSistema.Text;

		dmDados.ExecSQL('SELECT descricao FROM Plano WHERE classificacao = "' + classSistema + '"', oCDS_Sistema);
		editSistema.Text := oCDS_Sistema.FieldByName('descricao').AsString;

		oCDS_Sistema.EmptyDataSet;
		dmDados.ExecSQL('SELECT classificacao_sistema FROM ClassificacaoXTce WHERE classificacao_sistema = "' + classSistema + '"', oCDS_Sistema);
		if not oCDS_Sistema.IsEmpty then
		begin
			tableClassificacaoXTce.Filtered := False;
			tableClassificacaoXTce.Filter   := 'classificacao_sistema = ' + f_StrToSQL(oCDS_Sistema.FieldByName('classificacao_sistema').AsString);
			tableClassificacaoXTce.Filtered := True;
		end;
		tableClassificacaoXTce.Filtered := False;
	end
	else
		editSistema.Text := '';

	oCDS_Sistema.Free;
end;

procedure TfrmCadClassificacao.getDescTCE;
var
	classTce : string;
	oCDS_Tce : TClientDataSet;
begin
	oCDS_Tce := TClientDataSet.Create(nil);

	if dbcTCE.Text <> '' then
	begin
		if Pos('-', dbcTCE.Text) <> 0 then
			classTce := Copy(dbcTCE.Text, 0, Pos('-', dbcTCE.Text) - 1)
		else
			classTce := dbcTCE.Text;

		dmDados.ExecSQL('SELECT descricao_tce FROM ClassificacaoTce WHERE classificacao_tce = "' + classTce + '"', oCDS_Tce);
		editTCE.Text := oCDS_Tce.FieldByName('descricao_tce').AsString;
	end
	else
		editTCE.Text := '';

	oCDS_Tce.Free;
end;

procedure TfrmCadClassificacao.dbcSistemaChange(Sender : TObject);
begin
	getSistema;
end;

procedure TfrmCadClassificacao.dbcSistemaEnter(Sender : TObject);
begin
	getSistema;
end;

procedure TfrmCadClassificacao.dbcTCEChange(Sender : TObject);
begin
	getDescTCE;
end;

procedure TfrmCadClassificacao.dbcTCEEnter(Sender : TObject);
begin
	getDescTCE;
end;

procedure TfrmCadClassificacao.DBNavigator1Click(Sender : TObject; Button : TNavigateBtn);
begin
	getSistema;
	getDescTCE;
end;

procedure TfrmCadClassificacao.validaCampos(classSistema, classTce : String);
var
	oCDS_Aux : TClientDataSet;

begin
	oCDS_Aux := TClientDataSet.Create(nil);

	if classSistema = '' then
	begin
		p_MsgAviso('Classificação do sistema deve ser informada');
		Abort;
	end else
	begin
		dmDados.ExecSQL('SELECT classificacao FROM Plano WHERE classificacao = "' + classSistema + '" ' +
				'AND nr_grau = 5', oCDS_Aux);
		if oCDS_Aux.IsEmpty then
		begin
			p_MsgAviso('Classificação do sistema informada não existe');
			Abort;
		end;
	end;

	if classTce = '' then
	begin
		p_MsgAviso('Classificação do TCE deve ser informada');
		Abort;
	end else
	begin
		dmDados.ExecSQL('SELECT classificacao_tce FROM ClassificacaoTce WHERE classificacao_tce = "' + classTce + '"', oCDS_Aux);
		if oCDS_Aux.IsEmpty then
		begin
			p_MsgAviso('Classificação do TCE informada não existe');
			Abort;
		end;
	end;

	oCDS_Aux.Free;
end;

procedure TfrmCadClassificacao.tableClassificacaoXTceBeforeDelete(DataSet : TDataSet);
begin
	if not f_MsgConfirma('Eliminar o Registro?') then
		Abort
end;

procedure TfrmCadClassificacao.tableClassificacaoXTceBeforePost(DataSet : TDataSet);
var
	classSistema, classTce : String;
	oCDS_Aux               : TClientDataSet;

begin
	oCDS_Aux := TClientDataSet.Create(nil);

	if Pos('-', dbcSistema.Text) <> 0 then
		classSistema := Copy(dbcSistema.Text, 0, Pos('-', dbcSistema.Text) - 1)
	else
		classSistema := dbcSistema.Text;

	if Pos('-', dbcTCE.Text) <> 0 then
		classTce := Copy(dbcTCE.Text, 0, Pos('-', dbcTCE.Text) - 1)
	else
		classTce := dbcTCE.Text;

	validaCampos(classSistema, classTce);

	tableClassificacaoXTce.FieldByName('classificacao_sistema').AsString := classSistema;
	tableClassificacaoXTce.FieldByName('classificacao_tce').AsString := classTce;

	if tableClassificacaoXTce.State in [dsInsert] then
	begin
		dmDados.ExecSQL('SELECT * FROM ClassificacaoXTce WHERE classificacao_sistema = "' + classSistema + '"', oCDS_Aux);
		if not oCDS_Aux.IsEmpty then
		begin
			p_MsgAviso('Classificação do sistema informada já existe vinculo');
			Abort;
		end;
	end;

	if tableClassificacaoXTce.State in [dsEdit] then
	begin
		dmDados.ExecSQL('SELECT * FROM ClassificacaoXTce WHERE classificacao_sistema = "' + classSistema + '" ' +
				'AND classificacao_sistema <> "' + tableClassificacaoXTce.FieldByName('classificacao_sistema').OldValue + '" ', oCDS_Aux);

		if not oCDS_Aux.IsEmpty then
		begin
			p_MsgAviso('Classificação do sistema informada já existe vinculo');
			Abort;
		end;
	end;

	oCDS_Aux.Free;
end;

procedure TfrmCadClassificacao.SpeedButton2Click(Sender : TObject);
begin
	Close;
end;

end.

unit mCadClassificacaoTCE;

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
	Datasnap.DBClient,
	Vcl.ExtCtrls,
	Vcl.DBCtrls,
	Vcl.Grids,
	Vcl.DBGrids,
	Vcl.StdCtrls,
	Vcl.Mask,
	ZAbstractRODataset,
	ZAbstractDataset,
	ZAbstractTable,
	ZDataset,
	uGeral,
	Vcl.Buttons;

type
	TfrmCadClassificacaoTCE = class(TForm)
		Label1 : TLabel;
		dbeClassificacao : TDBEdit;
		Label2 : TLabel;
		dbeDescricao : TDBEdit;
		DBGrid1 : TDBGrid;
		DBNavigator1 : TDBNavigator;
		oDS_ClassificacaoTCE : TDataSource;
		tableClassificacaoTCE : TZTable;
		Panel1 : TPanel;
		SpeedButton2 : TSpeedButton;
		Edit1 : TEdit;
		procedure FormCreate(Sender : TObject);
		procedure tableClassificacaoTCEBeforePost(DataSet : TDataSet);
		procedure tableClassificacaoTCEBeforeDelete(DataSet : TDataSet);
		procedure dbeClassificacaoEnter(Sender : TObject);
		procedure dbeClassificacaoChange(Sender : TObject);
		procedure SpeedButton2Click(Sender : TObject);
		procedure FormClose(Sender : TObject; var Action : TCloseAction);
		procedure tableClassificacaoTCEAfterPost(DataSet : TDataSet);
		private
			{ Private declarations }
		var
			oCDS_NovosVinculos : TClientDataSet;
			procedure validaCampos;
			procedure getClassificacao;
		public
			{ Public declarations }
	end;

var
	frmCadClassificacaoTCE : TfrmCadClassificacaoTCE;

implementation

uses
	oDmDados;

{$R *.dfm}


procedure TfrmCadClassificacaoTCE.FormClose(Sender : TObject; var Action : TCloseAction);
begin
	inherited;
	Action := caFree;
	Release;
	frmCadClassificacaoTCE := nil;
end;

procedure TfrmCadClassificacaoTCE.FormCreate(Sender : TObject);
begin
	if dmDados.vbConectado then
		tableClassificacaoTCE.Active := True;
end;

procedure TfrmCadClassificacaoTCE.getClassificacao;
var
	oCDS_ClassTCE : TClientDataSet;
begin
	oCDS_ClassTCE := TClientDataSet.Create(nil);

	if dbeClassificacao.Text <> '' then
	begin
		dmDados.ExecSQL('SELECT classificacao_tce FROM ClassificacaoTce WHERE classificacao_tce = "' + dbeClassificacao.Text + '"', oCDS_ClassTCE);
		if not oCDS_ClassTCE.IsEmpty then
		begin
			tableClassificacaoTCE.Filtered := False;
			tableClassificacaoTCE.Filter   := 'classificacao_tce = ' + f_StrToSQL(oCDS_ClassTCE.FieldByName('classificacao_tce').AsString);
			tableClassificacaoTCE.Filtered := True;
		end;
		tableClassificacaoTCE.Filtered := False;
	end;
	oCDS_ClassTCE.Free;
end;

procedure TfrmCadClassificacaoTCE.dbeClassificacaoChange(Sender : TObject);
begin
	getClassificacao;
end;

procedure TfrmCadClassificacaoTCE.dbeClassificacaoEnter(Sender : TObject);
begin
	getClassificacao;
end;

procedure TfrmCadClassificacaoTCE.validaCampos;
var
	oCDS_Aux : TClientDataSet;
begin
	oCDS_Aux           := TClientDataSet.Create(nil);
	oCDS_NovosVinculos := TClientDataSet.Create(nil);
	if oCDS_NovosVinculos.FieldCount > 0 then
		oCDS_NovosVinculos.ClearFields;

	oCDS_NovosVinculos.FieldDefs.Add('classificacao_sistema', ftString, 250, False);
	oCDS_NovosVinculos.FieldDefs.Add('classificacao_tce', ftString, 250, False);
	oCDS_NovosVinculos.CreateDataSet;

	if dbeClassificacao.Text = '' then
	begin
		p_MsgAviso('Classificação é obrigatória');
		Abort;
	end;

	if dbeDescricao.Text = '' then
	begin
		p_MsgAviso('Descrição é obrigatória');
		Abort;
	end;

	if tableClassificacaoTCE.State in [dsEdit] then
	begin
		dmDados.ExecSQL('SELECT classificacao_tce FROM ClassificacaoTce WHERE classificacao_tce = "' + dbeClassificacao.Text + '" ' +
				'AND classificacao_tce <> "' + tableClassificacaoTCE.Fields[0].OldValue + '"', oCDS_Aux);
		if not oCDS_Aux.IsEmpty then
		begin
			p_MsgAviso('Classificação informada já está cadastrada');
			Abort;
		end else
		begin
			oCDS_Aux.EmptyDataSet;
			dmDados.ExecSQL('SELECT * FROM ClassificacaoXTce WHERE classificacao_tce = "' + tableClassificacaoTCE.Fields[0].OldValue + '"', oCDS_Aux);
			if not oCDS_Aux.IsEmpty then
			begin
				oCDS_Aux.First;
				while not oCDS_Aux.EOF do
				begin
					// Deleta vinculo
					dmDados.ExecSQL(' DELETE FROM ClassificacaoXTce WHERE classificacao_sistema = "' + oCDS_Aux.FieldByName('classificacao_sistema').AsString + '"' +
							' AND classificacao_tce = "' + oCDS_Aux.FieldByName('classificacao_tce').AsString + '"', nil);

					oCDS_NovosVinculos.Append;
					oCDS_NovosVinculos.FieldByName('classificacao_sistema').AsString := oCDS_Aux.FieldByName('classificacao_sistema').AsString;
					oCDS_NovosVinculos.FieldByName('classificacao_tce').AsString := dbeClassificacao.Text;
					oCDS_NovosVinculos.Post;
					oCDS_Aux.Next;
				end;
			end;
		end;
	end;

	if tableClassificacaoTCE.State in [dsInsert] then
	begin
		dmDados.ExecSQL('SELECT classificacao_tce FROM ClassificacaoTce WHERE classificacao_tce = "' + dbeClassificacao.Text + '"', oCDS_Aux);
		if not oCDS_Aux.IsEmpty then
		begin
			p_MsgAviso('Classificação informada já está cadastrada');
			Abort;
		end;
	end;

	oCDS_Aux.Free;
end;

procedure TfrmCadClassificacaoTCE.tableClassificacaoTCEBeforeDelete(DataSet : TDataSet);
begin
	// Exclui o vinculo da classificação primeiro antes de excluir a classificação do TCE
	if not f_MsgConfirma('Eliminar o Registro?') then
		Abort
	else
		dmDados.ExecSQL('DELETE FROM ClassificacaoXTce WHERE classificacao_tce = "' + tableClassificacaoTCE.FieldByName('classificacao_tce').AsString + '"', nil);
end;

procedure TfrmCadClassificacaoTCE.tableClassificacaoTCEBeforePost(DataSet : TDataSet);
begin
	validaCampos;
end;

procedure TfrmCadClassificacaoTCE.tableClassificacaoTCEAfterPost(DataSet : TDataSet);
begin
	if not oCDS_NovosVinculos.IsEmpty then
	begin
		oCDS_NovosVinculos.First;
		while not oCDS_NovosVinculos.EOF do
		begin
			// Insere vinculo com classificação do tce informada
			dmDados.ExecSQL(' INSERT INTO ClassificacaoXTce ' +
					' VALUES ( ' +
					'"' + oCDS_NovosVinculos.FieldByName('classificacao_sistema').AsString + '", ' +
					'"' + dbeClassificacao.Text + '")', nil);
			oCDS_NovosVinculos.Next;
		end;
	end;

	oCDS_NovosVinculos.Free;
end;

procedure TfrmCadClassificacaoTCE.SpeedButton2Click(Sender : TObject);
begin
	Close;
end;

end.

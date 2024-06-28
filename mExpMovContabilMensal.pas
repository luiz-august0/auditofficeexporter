unit mExpMovContabilMensal;

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
	RxToolEdit,
	Vcl.Buttons,
	FlatFileDirEdit,
	Vcl.ComCtrls;

type
	TfrmMovContabil = class(TForm)
		Label2 : TLabel;
		Label3 : TLabel;
		editMesAno : TMaskEdit;
		Label1 : TLabel;
		diretorio : TDirectoryEdit;
		Label4 : TLabel;
		cbbColunaP : TComboBox;
		Label5 : TLabel;
		cbbColunaQ : TComboBox;
		Label6 : TLabel;
		cbbColunaR : TComboBox;
		Label7 : TLabel;
		editCampanha : TEdit;
		Panel1 : TPanel;
		SpeedButton1 : TSpeedButton;
		SpeedButton2 : TSpeedButton;
		Edit1 : TEdit;
		ProgressBar1 : TProgressBar;
		cbbEmpresa : TComboBox;
		procedure SpeedButton1Click(Sender : TObject);
		procedure FormShow(Sender : TObject);
		procedure SpeedButton2Click(Sender : TObject);
		procedure FormClose(Sender : TObject; var Action : TCloseAction);
		private
			{ Private declarations }
			function getDebitos(mes, ano, empresa, classificacao : String) : String;
			function getCreditos(mes, ano, empresa, classificacao : String) : String;
		public
			{ Public declarations }
	end;

var
	frmMovContabil : TfrmMovContabil;

implementation

uses
	oDmDados;

{$R *.dfm}

{ TfrmBalancete }

procedure TfrmMovContabil.FormClose(Sender : TObject; var Action : TCloseAction);
begin
	inherited;
	Action := caFree;
	Release;
	frmMovContabil := nil;
end;

procedure TfrmMovContabil.FormShow(Sender : TObject);
var
	oCDS_Aux : TClientDataSet;
begin
	oCDS_Aux := TClientDataSet.Create(nil);

	cbbEmpresa.Items.Clear;
	cbbColunaP.Items.Clear;
	cbbColunaQ.Items.Clear;
	cbbColunaR.Items.Clear;

	dmDados.ExecSQL('SELECT cd_empresa, razao FROM CRDEmpresa', oCDS_Aux);
	if not oCDS_Aux.IsEmpty then
	begin
		oCDS_Aux.First;
		while not oCDS_Aux.EOF do
		begin
			cbbEmpresa.Items.Add(oCDS_Aux.FieldByName('cd_empresa').AsString + ' - ' + oCDS_Aux.FieldByName('razao').AsString);
			oCDS_Aux.Next;
		end;
	end;

	oCDS_Aux.EmptyDataSet;
	dmDados.ExecSQL('SELECT colunaP, descricao FROM TipoMovimentoContabil', oCDS_Aux);
	if not oCDS_Aux.IsEmpty then
	begin
		oCDS_Aux.First;
		while not oCDS_Aux.EOF do
		begin
			cbbColunaP.Items.Add(oCDS_Aux.FieldByName('colunaP').AsString + ' - ' + oCDS_Aux.FieldByName('descricao').AsString);
			oCDS_Aux.Next;
		end;
	end;

	oCDS_Aux.EmptyDataSet;
	dmDados.ExecSQL('SELECT colunaQ, descricao FROM IdentificadorSuperavit', oCDS_Aux);
	if not oCDS_Aux.IsEmpty then
	begin
		oCDS_Aux.First;
		while not oCDS_Aux.EOF do
		begin
			cbbColunaQ.Items.Add(oCDS_Aux.FieldByName('colunaQ').AsString + ' - ' + oCDS_Aux.FieldByName('descricao').AsString);
			oCDS_Aux.Next;
		end;
	end;

	oCDS_Aux.EmptyDataSet;
	dmDados.ExecSQL('SELECT colunaR, descricao FROM IdentificadorVariacaoPatrimonial', oCDS_Aux);
	if not oCDS_Aux.IsEmpty then
	begin
		oCDS_Aux.First;
		while not oCDS_Aux.EOF do
		begin
			cbbColunaR.Items.Add(oCDS_Aux.FieldByName('colunaR').AsString + ' - ' + oCDS_Aux.FieldByName('descricao').AsString);
			oCDS_Aux.Next;
		end;
	end;

	oCDS_Aux.EmptyDataSet;
	dmDados.ExecSQL('SELECT * FROM HistoricoExpMovimentoColunas', oCDS_Aux);
	oCDS_Aux.Last;

	cbbColunaP.ItemIndex := (oCDS_Aux.FieldByName('colunaP').AsInteger - 1);
	if oCDS_Aux.FieldByName('colunaQ').AsInteger = 9 then
		cbbColunaQ.ItemIndex := 3
	else
		cbbColunaQ.ItemIndex := (oCDS_Aux.FieldByName('colunaQ').AsInteger - 1);

	if oCDS_Aux.FieldByName('colunaR').AsInteger = 99 then
		cbbColunaR.ItemIndex := 4
	else
		cbbColunaR.ItemIndex := (oCDS_Aux.FieldByName('colunaR').AsInteger - 1);

	oCDS_Aux.EmptyDataSet;
	dmDados.ExecSQL('SELECT campanha_cod FROM HistoricoExpCampanha', oCDS_Aux);
	oCDS_Aux.Last;
	editCampanha.Text := oCDS_Aux.FieldByName('campanha_cod').AsString;

	cbbEmpresa.ItemIndex := 0;
	oCDS_Aux.Free;
end;

function TfrmMovContabil.getDebitos(mes, ano, empresa, classificacao : String) : String;
var
	oCDS_Debitos : TClientDataSet;
	vsSQL        : string;
begin
	oCDS_Debitos := TClientDataSet.Create(nil);

	vsSQL := ' SELECT FORMAT(ROUND(SUM(vl_lancamento), 2),"#0.00") AS vlrDebitos ' +
		' FROM Lancamento LA ' +
		' INNER JOIN ClassificacaoXTce CXTCE ON CXTCE.classificacao_sistema = LA.cla_conta_deb ' +
		' WHERE MONTH(LA.dt_lancamento) = ' + mes +
		' AND YEAR(LA.dt_lancamento) = ' + ano +
		' AND CXTCE.classificacao_tce = ' + f_StrToSQL(classificacao) +
		' AND LA.enterprise_id = ' + empresa +
		' AND LA.situacao = "L"';
	dmDados.ExecSQL(vsSQL, oCDS_Debitos);
	if (not oCDS_Debitos.IsEmpty) and (oCDS_Debitos.FieldByName('vlrDebitos').AsString <> '') then
		Result := VirgulaPorPonto(oCDS_Debitos.FieldByName('vlrDebitos').AsString)
	else
		Result := '0.00';

	oCDS_Debitos.Free;
end;

function TfrmMovContabil.getCreditos(mes, ano, empresa, classificacao : String) : String;
var
	oCDS_Creditos : TClientDataSet;
	vsSQL         : string;
begin
	oCDS_Creditos := TClientDataSet.Create(nil);

	vsSQL := ' SELECT FORMAT(ROUND(SUM(vl_lancamento), 2),"#0.00") AS vlrCreditos ' +
		' FROM Lancamento LA ' +
		' INNER JOIN ClassificacaoXTce CXTCE ON CXTCE.classificacao_sistema = LA.cla_conta_cre ' +
		' WHERE MONTH(LA.dt_lancamento) = ' + mes +
		' AND YEAR(LA.dt_lancamento) = ' + ano +
		' AND CXTCE.classificacao_tce = ' + f_StrToSQL(classificacao) +
		' AND LA.enterprise_id = ' + empresa +
		' AND LA.situacao = "L"';
	dmDados.ExecSQL(vsSQL, oCDS_Creditos);
	if (not oCDS_Creditos.IsEmpty) and (oCDS_Creditos.FieldByName('vlrCreditos').AsString <> '') then
		Result := VirgulaPorPonto(oCDS_Creditos.FieldByName('vlrCreditos').AsString)
	else
		Result := '0.00';

	oCDS_Creditos.Free;
end;

procedure TfrmMovContabil.SpeedButton1Click(Sender : TObject);
var
	vsSQL, classTCE, linha, mes, ano, empresa, colP, colQ, colR : string;
	arq : TextFile;
	oCDS_Exportacao : TClientDataSet;
	oCDS_Aux        : TClientDataSet;
begin
	oCDS_Exportacao := TClientDataSet.Create(nil);
	oCDS_Aux        := TClientDataSet.Create(nil);

	if Trim(editCampanha.Text) = '' then
	begin
		p_MsgAviso('Cod. Empresa � obrigat�rio');
		editCampanha.SetFocus;
		Exit;
	end;

	if Trim(cbbColunaP.Text) = '' then
	begin
		p_MsgAviso('Coluna P deve ser preenchida');
		cbbColunaP.SetFocus;
		Exit;
	end;

	if Trim(cbbColunaQ.Text) = '' then
	begin
		p_MsgAviso('Coluna Q deve ser preenchida');
		cbbColunaQ.SetFocus;
		Exit;
	end;

	if Trim(cbbColunaR.Text) = '' then
	begin
		p_MsgAviso('Coluna R deve ser preenchida');
		cbbColunaR.SetFocus;
		Exit;
	end;

	if Length(Trim(StringReplace(editMesAno.Text, '/', '', [rfReplaceAll]))) <> 6 then
	begin
		p_MsgAviso('M�s e ano inv�lido');
		editMesAno.SetFocus;
		Exit;
	end;

	if diretorio.Text = '' then
	begin
		p_MsgAviso('Selecione o diret�rio do arquivo a ser exportado');
		diretorio.SetFocus;
		Exit;
	end;

	if POS('-', cbbColunaP.Text) <> 0 then
		colP := Copy(cbbColunaP.Text, 0, POS('-', cbbColunaP.Text) - 2)
	else
		colP := cbbColunaP.Text;

	if POS('-', cbbColunaQ.Text) <> 0 then
		colQ := Copy(cbbColunaQ.Text, 0, POS('-', cbbColunaQ.Text) - 2)
	else
		colQ := cbbColunaQ.Text;

	if POS('-', cbbColunaR.Text) <> 0 then
		colR := Copy(cbbColunaR.Text, 0, POS('-', cbbColunaR.Text) - 2)
	else
		colR := cbbColunaR.Text;

	dmDados.ExecSQL(' SELECT * FROM HistoricoExpMovimentoColunas WHERE colunaP = ' + colP +
			' AND colunaQ = ' + colQ +
			' AND colunaR = ' + colR, oCDS_Aux);
	if oCDS_Aux.IsEmpty then
		dmDados.ExecSQL('INSERT INTO HistoricoExpMovimentoColunas VALUES(' + colP +
				',' + colQ + ',' + colR + ')', nil);

	oCDS_Aux.EmptyDataSet;
	dmDados.ExecSQL('SELECT campanha_cod FROM HistoricoExpCampanha WHERE campanha_cod = ' + f_StrToSQL(editCampanha.Text), oCDS_Aux);
	if oCDS_Aux.IsEmpty then
		dmDados.ExecSQL('INSERT INTO HistoricoExpCampanha VALUES(' + f_StrToSQL(editCampanha.Text) + ')', nil);

	mes := Copy(editMesAno.Text, 1, POS('/', editMesAno.Text) - 1);
	ano := Copy(editMesAno.Text, POS('/', editMesAno.Text) + 1);

	if POS('-', cbbEmpresa.Text) <> 0 then
		empresa := Copy(cbbEmpresa.Text, 0, POS('-', cbbEmpresa.Text) - 1)
	else
		empresa := cbbEmpresa.Text;

	vsSQL := ' SELECT * FROM( ' +
		' SELECT CXTCE.classificacao_tce ' +
		' FROM Lancamento LA ' +
		' INNER JOIN Plano PL ON PL.classificacao = ISNULL(LA.cla_conta_deb, LA.cla_conta_cre) ' +
		' INNER JOIN ClassificacaoXTce CXTCE ON CXTCE.classificacao_sistema = PL.classificacao ' +
		' WHERE MONTH(LA.dt_lancamento) = ' + mes +
		' AND YEAR(LA.dt_lancamento) = ' + ano +
		' AND LA.enterprise_id = ' + empresa + ' ) AS TMP ' +
		' GROUP BY classificacao_tce ' +
		' ORDER BY classificacao_tce ';
	dmDados.ExecSQL(vsSQL, oCDS_Exportacao);

	if not oCDS_Exportacao.IsEmpty then
	begin
		AssignFile(arq, diretorio.Text + '\MovimentoContabilMensal.txt');
		Rewrite(arq);
		ProgressBar1.Visible  := True;
		ProgressBar1.Max      := oCDS_Exportacao.RecordCount;
		ProgressBar1.Position := 0;

		oCDS_Exportacao.First;
		while not oCDS_Exportacao.EOF do
		begin
			classTCE := '';
			classTCE := oCDS_Exportacao.FieldByName('classificacao_tce').AsString;
			linha    := editCampanha.Text +
				'|' + Copy(classTCE, 1, 1) +
				'|' + Copy(classTCE, 2, 1) +
				'|' + Copy(classTCE, 3, 1) +
				'|' + Copy(classTCE, 4, 1) +
				'|' + Copy(classTCE, 5, 1) +
				'|' + Copy(classTCE, 6, 2) +
				'|' + Copy(classTCE, 8, 2) +
				'|' + Copy(classTCE, 10, 2) +
				'|' + Copy(classTCE, 12, 2) +
				'|' + Copy(classTCE, 14, 2) +
				'|' + Copy(classTCE, 16, 2) +
				'|' + Copy(classTCE, 18, 2) +
				'|' + ano +
				'|' + mes +
				'|' + colP +
				'|' + colQ +
				'|' + colR +
				'|' + getDebitos(mes, ano, empresa, classTCE) +
				'|' + getCreditos(mes, ano, empresa, classTCE) +
				'|';
			Writeln(arq, linha);

			ProgressBar1.Position := ProgressBar1.Position + 1;
			oCDS_Exportacao.Next;
		end;

		CloseFile(arq);
		p_MsgAviso('Arquivo gravado com sucesso em: ' + #13 + #10 +
				diretorio.Text + '\MovimentoContabilMensal.txt');
		ProgressBar1.Position := 0;
		ProgressBar1.Visible  := False;
	end
	else
		p_MsgAviso('Dados n�o encontrados');

	oCDS_Exportacao.Free;
end;

procedure TfrmMovContabil.SpeedButton2Click(Sender : TObject);
begin
	Close;
end;

end.

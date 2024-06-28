unit mExpFolhaServidor;

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
	TfrmFolhaServidor = class(TForm)
		Panel1 : TPanel;
		SpeedButton1 : TSpeedButton;
		Label2 : TLabel;
		Label3 : TLabel;
		ProgressBar1 : TProgressBar;
		editMesAno : TMaskEdit;
		Label1 : TLabel;
		diretorio : TDirectoryEdit;
		Edit1 : TEdit;
		editCampanha : TEdit;
		Label4 : TLabel;
		Label5 : TLabel;
		datePagamento : TDateEdit;
		editCPF : TMaskEdit;
		Label6 : TLabel;
		Label7 : TLabel;
		editLotacao : TEdit;
		labelExportacao : TLabel;
		SpeedButton2 : TSpeedButton;
		cbbEmpresa : TComboBox;
		procedure SpeedButton1Click(Sender : TObject);
		procedure FormShow(Sender : TObject);
		procedure SpeedButton2Click(Sender : TObject);
		procedure FormClose(Sender : TObject; var Action : TCloseAction);
		private
			{ Private declarations }
		var
			empresa : string;
			procedure pExportaFolha(mes, ano : string);
			procedure pExportaFolhaServidor(mes, ano, Data : string);
			procedure pExportaFolhaVerbas(mes, ano, Data : string);
		public
			{ Public declarations }
	end;

var
	frmFolhaServidor : TfrmFolhaServidor;

implementation

uses
	oDmDados;

{$R *.dfm}

{ TfrmBalancete }

procedure TfrmFolhaServidor.FormClose(Sender : TObject; var Action : TCloseAction);
begin
	inherited;
	Action := caFree;
	Release;
	frmFolhaServidor := nil;
end;

procedure TfrmFolhaServidor.FormShow(Sender : TObject);
var
	oCDS_Aux : TClientDataSet;
begin
	oCDS_Aux := TClientDataSet.Create(nil);

	cbbEmpresa.Items.Clear;
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
	dmDados.ExecSQL('SELECT campanha_cod FROM HistoricoExpCampanha', oCDS_Aux);
	oCDS_Aux.Last;
	editCampanha.Text := oCDS_Aux.FieldByName('campanha_cod').AsString;

	oCDS_Aux.EmptyDataSet;
	dmDados.ExecSQL('SELECT lotacao, cpf FROM HistoricoExpFolhaLotacaoCPF', oCDS_Aux);
	oCDS_Aux.Last;
	editLotacao.Text := oCDS_Aux.FieldByName('lotacao').AsString;
	editCPF.Text     := oCDS_Aux.FieldByName('cpf').AsString;

	cbbEmpresa.ItemIndex := 0;
	oCDS_Aux.Free;
end;

procedure TfrmFolhaServidor.pExportaFolha(mes, ano : string);
var
	linha : string;
	arq   : TStringList;
begin
	arq   := TStringList.Create;
	linha := editCampanha.Text +
		'|' + mes + Copy(ano, 3, 2) +
		'|' + mes +
		'|' + ano +
		'|' + StringReplace(datePagamento.Text, '/', '-', [rfReplaceAll]) +
		'|' + f_TiraMascara(editCPF.Text) +
		'|';
	arq.Add(linha);
	arq.SaveToFile(diretorio.Text + '\Folha.csv');
end;

procedure TfrmFolhaServidor.pExportaFolhaServidor(mes, ano, Data : string);
var
	vsSQL, linha    : string;
	arq             : TStringList;
	oCDS_Exportacao : TClientDataSet;
begin
	oCDS_Exportacao := TClientDataSet.Create(nil);

	vsSQL := ' SELECT FUND.cpf, FUN.cd_funcionario, "1" AS situacao, ' +
		' FSERV.tipo_codigo, FFUNCAO.cd_funcao, FUNC.descricao, ' +
		' FORMAT(FSERV.Desc_Patronal, "#0.00") AS Desc_Patronal, ' +
		' FORMAT(FSERV.Desc_Func, "#0.00") AS Desc_Func, FSERV.vinculo_codigo ' +
		' FROM ' +
		' Funcionario FUN ' +
		' INNER JOIN FunDocumento FUND ' +
		' ON FUN.cd_funcionario = FUND.cd_funcionario ' +
		' AND FUN.cd_empresa = FUND.cd_empresa ' +
		' INNER JOIN FuncionarioSituacaoServidor FSERV ' +
		' ON FUN.cd_funcionario = FSERV.cd_funcionario ' +
		' AND FUN.cd_empresa = FSERV.cd_empresa ' +
		' INNER JOIN FunFuncao FFUNCAO ' +
		' ON FUN.cd_funcionario = FFUNCAO.cd_funcionario ' +
		' AND FUN.cd_empresa = FFUNCAO.cd_empresa ' +
		' INNER JOIN FUNCAO FUNC ' +
		' ON FFUNCAO.cd_funcao = FUNC.cd_funcao ' +
		' AND FFUNCAO.cd_empresa = FUNC.enterprise_id ' +
		' WHERE ' +
		' FUN.cd_empresa = ' + empresa +
		' AND FFUNCAO.dt_final >= GETDATE() ' +
		' AND (SELECT cd_funcionario FROM FunMovimentacao ' +
		' WHERE tipo_movimentacao = 2 ' +
		' AND convert(char, dt_movimentacao, 23) <= ' + f_StrToSQL(Data) +
		' AND cd_funcionario = FUN.cd_funcionario) IS NULL ';
	dmDados.ExecSQL(vsSQL, oCDS_Exportacao);

	if not oCDS_Exportacao.IsEmpty then
	begin
		arq                     := TStringList.Create;
		labelExportacao.Visible := True;
		labelExportacao.Caption := 'FolhaServidor.csv';
		ProgressBar1.Visible    := True;
		ProgressBar1.Max        := oCDS_Exportacao.RecordCount;
		ProgressBar1.Position   := 0;

		oCDS_Exportacao.First;
		while not oCDS_Exportacao.EOF do
		begin
			linha := editCampanha.Text +
				'|' + f_TiraMascara(oCDS_Exportacao.FieldByName('cpf').AsString) +
				'|' + oCDS_Exportacao.FieldByName('cd_funcionario').AsString +
				'|' + oCDS_Exportacao.FieldByName('situacao').AsString +
				'|' + oCDS_Exportacao.FieldByName('tipo_codigo').AsString +
				'|' + oCDS_Exportacao.FieldByName('cd_funcao').AsString +
				'|' + oCDS_Exportacao.FieldByName('descricao').AsString +
				'|' + editLotacao.Text +
				'|' + VirgulaPorPonto(oCDS_Exportacao.FieldByName('Desc_Patronal').AsString) +
				'|' + VirgulaPorPonto(oCDS_Exportacao.FieldByName('Desc_Func').AsString) +
				'|' + oCDS_Exportacao.FieldByName('vinculo_codigo').AsString +
				'|';
			arq.Add(linha);

			ProgressBar1.Position := ProgressBar1.Position + 1;
			oCDS_Exportacao.Next;
		end;

		arq.SaveToFile(diretorio.Text + '\FolhaServidor.csv');
		ProgressBar1.Position   := 0;
		ProgressBar1.Visible    := False;
		labelExportacao.Visible := False;
	end
	else
		p_MsgAviso('Dados n�o encontrados');

	oCDS_Exportacao.Free;
end;

procedure TfrmFolhaServidor.pExportaFolhaVerbas(mes, ano, Data : string);
var
	vsSQL, linha    : string;
	arq             : TStringList;
	oCDS_Exportacao : TClientDataSet;
begin
	oCDS_Exportacao := TClientDataSet.Create(nil);

	vsSQL := ' SELECT FUND.cpf, FUN.cd_funcionario, "1" AS situacao, PROCE.cd_evento, ' +
		' (SELECT TOP 1 descricao FROM EventoGVigencia WHERE cd_evento = PROCE.cd_evento ' +
		' AND tp_evento <> "N" ' +
		' ORDER BY dt_inicio DESC) AS descricao_verba, FORMAT(PROCE.valor,"#0.00") AS valor, ' +
		' (SELECT TOP 1 ' +
		' CASE tp_evento ' +
		' WHEN "V" THEN "P" ' +
		' WHEN "D" THEN "N" END AS tp_evento ' +
		' FROM EventoGVigencia WHERE cd_evento = PROCE.cd_evento ' +
		' AND tp_evento <> "N" ' +
		' ORDER BY dt_inicio DESC) AS tp_evento ' +
		' FROM Funcionario FUN ' +
		' INNER JOIN FunDocumento FUND ' +
		' ON FUN.cd_funcionario = FUND.cd_funcionario ' +
		' AND FUN.cd_empresa = FUND.cd_empresa ' +
		' INNER JOIN ProcEvento PROCE ' +
		' ON FUN.cd_funcionario = PROCE.cd_funcionario ' +
		' AND FUN.cd_empresa = PROCE.cd_empresa ' +
		' WHERE ' +
		' FUN.cd_empresa = ' + empresa +
		' AND PROCE.mes = ' + mes +
		' AND PROCE.ano = ' + ano +
		' AND (SELECT cd_funcionario FROM FunMovimentacao ' +
		' WHERE tipo_movimentacao = 2 ' +
		' AND convert(char, dt_movimentacao, 23) <= ' + f_StrToSQL(Data) +
		' AND cd_funcionario = FUN.cd_funcionario) IS NULL ' +
		' ORDER BY cd_funcionario ';
	dmDados.ExecSQL(vsSQL, oCDS_Exportacao);

	if not oCDS_Exportacao.IsEmpty then
	begin
		arq                     := TStringList.Create;
		labelExportacao.Visible := True;
		labelExportacao.Caption := 'FolhaVerbas.csv';
		ProgressBar1.Visible    := True;
		ProgressBar1.Max        := oCDS_Exportacao.RecordCount;
		ProgressBar1.Position   := 0;

		oCDS_Exportacao.First;
		while not oCDS_Exportacao.EOF do
		begin
			linha := editCampanha.Text +
				'|' + f_TiraMascara(oCDS_Exportacao.FieldByName('cpf').AsString) +
				'|' + oCDS_Exportacao.FieldByName('cd_funcionario').AsString +
				'|' + oCDS_Exportacao.FieldByName('situacao').AsString +
				'|' + oCDS_Exportacao.FieldByName('cd_evento').AsString +
				'|' + oCDS_Exportacao.FieldByName('descricao_verba').AsString +
				'|' + VirgulaPorPonto(oCDS_Exportacao.FieldByName('valor').AsString) +
				'|' + oCDS_Exportacao.FieldByName('tp_evento').AsString +
				'||||';
			arq.Add(linha);

			ProgressBar1.Position := ProgressBar1.Position + 1;
			oCDS_Exportacao.Next;
		end;

		arq.SaveToFile(diretorio.Text + '\FolhaVerbas.csv');
		ProgressBar1.Position   := 0;
		ProgressBar1.Visible    := False;
		labelExportacao.Visible := False;
	end
	else
		p_MsgAviso('Dados n�o encontrados');

	oCDS_Exportacao.Free;
end;

procedure TfrmFolhaServidor.SpeedButton1Click(Sender : TObject);
var
	mes, ano, cpf, Data : string;
	oCDS_Aux            : TClientDataSet;
begin
	oCDS_Aux := TClientDataSet.Create(nil);

	if Trim(editCampanha.Text) = '' then
	begin
		p_MsgAviso('Cod. Empresa � obrigat�rio');
		editCampanha.SetFocus;
		Exit;
	end;

	if Length(Trim(StringReplace(editMesAno.Text, '/', '', [rfReplaceAll]))) <> 6 then
	begin
		p_MsgAviso('M�s e ano inv�lido');
		editMesAno.SetFocus;
		Exit;
	end;

	if editLotacao.Text = '' then
	begin
		p_MsgAviso('Lota��o � obrigat�rio');
		editLotacao.SetFocus;
		Exit;
	end;

	if Length(Trim(StringReplace(datePagamento.Text, '/', '', [rfReplaceAll]))) <> 8 then
	begin
		p_MsgAviso('Data de pagamento inv�lida');
		datePagamento.SetFocus;
		Exit;
	end;

	cpf := f_TiraMascara(editCPF.Text);
	if not f_ValidaCPF(cpf) then
	begin
		editCPF.SetFocus;
		Exit;
	end;

	if diretorio.Text = '' then
	begin
		p_MsgAviso('Selecione o diret�rio dos arquivos a serem exportados');
		diretorio.SetFocus;
		Exit;
	end;

	dmDados.ExecSQL('SELECT * FROM HistoricoExpFolhaLotacaoCPF WHERE lotacao = ' + f_StrToSQL(editLotacao.Text) + ' AND cpf = ' + f_StrToSQL(cpf), oCDS_Aux);
	if oCDS_Aux.IsEmpty then
		dmDados.ExecSQL('INSERT INTO HistoricoExpFolhaLotacaoCPF VALUES(' + f_StrToSQL(editLotacao.Text) + ',' + f_StrToSQL(cpf) + ')', nil);

	oCDS_Aux.EmptyDataSet;
	dmDados.ExecSQL('SELECT campanha_cod FROM HistoricoExpCampanha WHERE campanha_cod = ' + f_StrToSQL(editCampanha.Text), oCDS_Aux);
	if oCDS_Aux.IsEmpty then
		dmDados.ExecSQL('INSERT INTO HistoricoExpCampanha VALUES(' + f_StrToSQL(editCampanha.Text) + ')', nil);

	mes := Copy(editMesAno.Text, 1, Pos('/', editMesAno.Text) - 1);
	ano := Copy(editMesAno.Text, Pos('/', editMesAno.Text) + 1);

	if Pos('-', cbbEmpresa.Text) <> 0 then
		empresa := Copy(cbbEmpresa.Text, 0, Pos('-', cbbEmpresa.Text) - 1)
	else
		empresa := cbbEmpresa.Text;

	Data := Copy(editMesAno.Text, Pos('/', editMesAno.Text) + 1) + '-' +
		Copy(editMesAno.Text, 1, Pos('/', editMesAno.Text) - 1) + '-' +
		UltimoDiaDoMes(Trim(StringReplace(editMesAno.Text, '/', '', [rfReplaceAll])));

	pExportaFolhaServidor(mes, ano, Data);
	pExportaFolha(mes, ano);
	pExportaFolhaVerbas(mes, ano, Data);

	p_MsgAviso('Arquivos gravados com sucesso em: ' + #13#10 + diretorio.Text);

	oCDS_Aux.Free;
end;

procedure TfrmFolhaServidor.SpeedButton2Click(Sender : TObject);
begin
	Close;
end;

end.
